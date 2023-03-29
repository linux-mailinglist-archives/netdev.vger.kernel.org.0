Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7E6CD94D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjC2MYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2MYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:24:18 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574FD3C1E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:24:17 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AFEE43F23A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680092655;
        bh=swtrxUv/pKI8ab5w6xKcagMA1RvyRPHwLmMe6L8/sdc=;
        h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
        b=UVOa1mnZ4SejSFsNTylwBPfcNO/HqkCOk42ZvQrLY8cHRetKENEzqJgUOxvwBjCDN
         jqlkrLJDsaQB1dXifNVBsVGic+0Z6W5iJ/WjoDAhz/rfRFQT6CaA0q2sKbwT9ONG3B
         NMxrwrAB1ncKnJ2Cz7NAlW2+UMttClMgzaWdU+c22kB+YSOg24Sxg+4l/+bnM05IJM
         OzqbAlj6Yc2CxUQlpv/uBpbFnN7jBvrJUwUtROdBjMNBcvaw1juWfxB4cuWM7SKZ4O
         wVxcyYF9u7GMosimD0jS2Ys2b/cwTd6Bq+XpqEta9v7J/5btkU/gJbvCut3mgvyFjf
         +Z6R87sATwwug==
Received: by mail-ed1-f72.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so21780376edc.9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680092655; x=1682684655;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=swtrxUv/pKI8ab5w6xKcagMA1RvyRPHwLmMe6L8/sdc=;
        b=6cyosiDzL3s0R1T2gawVUum/Yc+DAG1h4QAUIvoY0Vcdn9t+g+oBi6GYJ3jQ+m6iiU
         2zVI75pEpWzo8z+zgL8JjCfEatN/lzXwJ2pskVZQVfDEGOBohtxtCwxMpx/WynaemnqV
         iwubVG2Lw1sMWukxxqwNpiRl9jUXAZtf7VRQSpPFYwndc8pI3eILu60fiW0CBStakkX+
         USWDOR7q2XtgcwY5Zw5tA0VdQjXdmUIeKtKODhz/JdeUYwbVXi6zxt0YZ2wgVi+Sxwt5
         3jB2guIIydIUwRkZQIPJta0sHp2+sDQpjf7clE/iJ1G+vFLYv77X2/lkSTo86qTaJuJw
         FyFQ==
X-Gm-Message-State: AAQBX9enNG8nHZvkq4eQvwzdZeSD1Wv0hKN+YjVTQPctyk1HK1GqBGrD
        v2tIOpJq3y4LisH0POovfKlEfJk5cWRQCfZffxrEnjKgm3HZlJXxhgc4A6BP+GFxqUBbnEh9eKK
        +WjtORuIQMqR+QCqSkq9cFhpgimFotz+KMw==
X-Received: by 2002:a17:906:2cc8:b0:93d:cbf8:ca14 with SMTP id r8-20020a1709062cc800b0093dcbf8ca14mr18122600ejr.75.1680092655165;
        Wed, 29 Mar 2023 05:24:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350YMFhvs43gYsdT5jJ81I6Web+lcMSlXRngIx1j14X6MuV8d7bWBDKpvwXcfU4EIuCD0TaLVPg==
X-Received: by 2002:a17:906:2cc8:b0:93d:cbf8:ca14 with SMTP id r8-20020a1709062cc800b0093dcbf8ca14mr18122585ejr.75.1680092654930;
        Wed, 29 Mar 2023 05:24:14 -0700 (PDT)
Received: from localhost (host-79-33-132-140.retail.telecomitalia.it. [79.33.132.140])
        by smtp.gmail.com with ESMTPSA id d7-20020a1709067f0700b00882f9130eafsm16367613ejr.26.2023.03.29.05.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 05:24:14 -0700 (PDT)
Date:   Wed, 29 Mar 2023 14:24:14 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: selftests: net: l2tp.sh regression starting with 6.1-rc1
Message-ID: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed that l2tp.sh net selftest is failing in recent kernels with
the following error:

 RTNETLINK answers: Protocol not supported

See also: https://bugs.launchpad.net/bugs/2013014

Apprently the module lt2p_ipv6 is not automatically loaded when the test
is trying to create an l2tp ipv6 tunnel.

I did a bisect and found that the offending commit is this one:

 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")

I've temporarily reverted this commit for now, any suggestion on how to
fix this properly?

Thanks,
-Andrea
