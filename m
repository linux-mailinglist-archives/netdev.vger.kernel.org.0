Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD460C4C5
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJYHLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJYHLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:11:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546C6100BEC;
        Tue, 25 Oct 2022 00:11:23 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y4so10456231plb.2;
        Tue, 25 Oct 2022 00:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OpGVdTHPTo8HE73NSMb14pa67PYd3cbhvavpF08Svys=;
        b=LFPhd8kXff5Z7xDxPYwT8GK84sP92AapJRipScMeKFvJXwYapY1fMnr6PnMk5UcN2K
         ZVe4XJF7X2BqqEiBgxCaCYvlUyDvtvTI9Q3o9jCAWVEVTj+M88JmvrDf4nndmZBlXz8k
         O5jXS0jS6RL4aB8UmCkmiK69x4wqGAo6bd8x05Z3/b/6ZeePVA+LREPpyNIazui8XwGz
         XJM+uosbpxVEcfLzGWaEcYUwewJyWNY/s4MTX1sEVxkmqoIY553Gg4FQhA3Gg/hjgWJb
         RHLjwPBzcn/ivHgjhepULYkri2KaXES6BkF4Y0tfGhr6kmB+6jtMPHlK24I9Xm5RGZWl
         ScYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpGVdTHPTo8HE73NSMb14pa67PYd3cbhvavpF08Svys=;
        b=0evw5c+9UrPAHx0THwBlacaH4dYUCcMdns90XboPiT87dmQ23wQkgalPtqVZac7Ajl
         PTKBQMk5DbR8NlNob6x7tDnpoj/NbIxD3UR4sHHFlKvuhNl801mY7Oh712PE6XRTuPjp
         9S9rpO279R3N3gU7VXmBPhfCaA+y/EGLdB6l5HgiI+7GD1i+YezYSBLYBJEchixoDs/h
         DrdOHseceMhVA9Hltjr6ymnfVVjG77go2JluoouSy+GAWKkM34DP97s1mjOpGNJVFgdT
         kwL+ct8j15RAK/9h1eW89btu1l1frZtIHxiMfMydUr5hq70uPq7QYhAAIdvNoZAHpsKm
         jbRg==
X-Gm-Message-State: ACrzQf3IZtCZVP82SzwNyqdckNjfMaQRILBNqqpzetnjbvQk7uLqbJa+
        2fItRU3CZOOc5CMkTVwNnXM=
X-Google-Smtp-Source: AMsMyM78ep3vxaArGkOQSNI8U22FumC6eFJK6qze2I7VonY67ClnJIuiMq0XFH5PZaWrkMHhCxhZ8Q==
X-Received: by 2002:a17:90b:305:b0:213:8a6:8bb4 with SMTP id ay5-20020a17090b030500b0021308a68bb4mr11792021pjb.33.1666681882711;
        Tue, 25 Oct 2022 00:11:22 -0700 (PDT)
Received: from smtpclient.apple ([2001:e68:541d:e8fd:fd7f:3fc0:34d8:db1])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ce8f00b00186a2444a43sm713855plg.27.2022.10.25.00.11.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Oct 2022 00:11:22 -0700 (PDT)
From:   Wong Vee Khee <veekhee@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 2/2] net: stmmac: remove duplicate dma queue
 channel macros
Message-Id: <03329169-560C-4319-AEBB-44BFFE959EBC@gmail.com>
Date:   Tue, 25 Oct 2022 15:11:17 +0800
Cc:     Joao.Pinto@synopsys.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, edumazet@google.com, joabreu@synopsys.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        pabeni@redhat.com, peppe.cavallaro@st.com
To:     junxiao.chang@intel.com
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Why not combine with the other =E2=80=98if (queue < 4).. else=E2=80=99 =
in
this function all together?

Regards,
Vee Khee=
