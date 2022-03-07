Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3624B4D082E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbiCGUMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238439AbiCGUMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:12:23 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03413F8B1
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:11:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s8so11223186pfk.12
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 12:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vvx0kFH9tXVxtxYZn9Ru7ue2wSOsObKPRZoMefv3ypA=;
        b=WP9pPxtZahqej1YvJ5yLLRwkhOBmkS5++A/3BkkOPbzH6yq6xa4gsIFJll0ogoqOfN
         wLgJud4wYZxdFlQD61FenI6Y0wNs36+sxZH7Ajsc3J4vKbulrEJPQjKpRWCXWYebYhsN
         suRPdRFlHG0CXW9lCGZcG0WAnq+OXhNu7i3qSUx0LK5SQ1oVIItorG0pboGU3L41AXJa
         q8OBGRj53Vd7zpS1H3niwgASXJkZolKZHSyWIWfAPqODLbwvttPcQWc9eo6NMwa6uo7j
         qzRi0Eayco/FZcOhURhVkpfBS/VFXt70wDH67LCTJwF4uCBwpqFX8RjcfBBbjY440F9p
         j5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vvx0kFH9tXVxtxYZn9Ru7ue2wSOsObKPRZoMefv3ypA=;
        b=182aMCtTLgRyslfcI51ciNqotaTv1HhZzMSPRMA91Jr7BBuZZgPIPMZvIIJqxdu/07
         07ZJo+BmbcTv7zRZiZ5Gdl1qHRbVq9t5tXoJLKarVfENZV4mRvMexYkCe6V8JmfbHmrY
         olR0YDiqOJptNBKEmguT/2PaQfJmHFsIVgR5M7dExQ/P14lcTlqLeuzuLqvwBC6YagWV
         4oJtANZKMG5WiM0/qz+5/w6/ywuwjAJsBeiokuS3gpeHZTFQoDPinV6TLPO3BZFqSq1A
         peOZh7Q846XMBQVsWb23uDZnkYu72pEIPw9iKXvXXi9zHedj0hyQ0Q5sk/ykJapEN0pf
         68lA==
X-Gm-Message-State: AOAM53022//e1rKXCpLQoem/NsFA3xLWQj1ykWC6l7xoXuu9SMLOaynz
        HADwJNt18EEx0WY3PgnAiYGcDg==
X-Google-Smtp-Source: ABdhPJwUGFifg5fcqNsradD84KEB/n8CyBeW5kzgQ2MBUj6Fu4/D6X3lw/bXieTsIl+gGC2rJ+p6yA==
X-Received: by 2002:a05:6a00:14ca:b0:4cf:1930:9d67 with SMTP id w10-20020a056a0014ca00b004cf19309d67mr14463568pfu.55.1646683886111;
        Mon, 07 Mar 2022 12:11:26 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c34-20020a630d22000000b0034cb89e4695sm12854497pgl.28.2022.03.07.12.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 12:11:25 -0800 (PST)
Date:   Mon, 7 Mar 2022 12:11:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org
Subject: Regression in add xfrm interface
Message-ID: <20220307121123.1486c035@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There appears to be a regression between 5.10 (Debian 11) and 5.16 (Debian testing)
kernel in handling of ip link xfrm create. This shows up in the iproute2 testsuite
which now fails. This is kernel (not iproute2) regression.


Running ip/link/add_type_xfrm.t [iproute2-this/5.16.0-1-amd64]: FAILED


Good log:
::::::::::::::
link/add_type_xfrm.t.iproute2-this.out
::::::::::::::
[Testing Add XFRM Interface, With IF-ID]
tests/ip/link/add_type_xfrm.t: Add dev-ktyXSm xfrm interface succeeded
tests/ip/link/add_type_xfrm.t: Show dev-ktyXSm xfrm interface succeeded with output:
2: dev-ktyXSm@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none  promiscuity 0 minmtu 68 maxmtu 65535 
    xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
test on: "dev-ktyXSm" [SUCCESS]
test on: "if_id 0xf" [SUCCESS]
tests/ip/link/add_type_xfrm.t: Del dev-ktyXSm xfrm interface succeeded
[Testing Add XFRM Interface, No IF-ID]
tests/ip/link/add_type_xfrm.t: Add dev-tkUDaA xfrm interface succeeded
tests/ip/link/add_type_xfrm.t: Show dev-tkUDaA xfrm interface succeeded with output:
3: dev-tkUDaA@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none  promiscuity 0 minmtu 68 maxmtu 65535 
    xfrm if_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
test on: "dev-tkUDaA" [SUCCESS]
test on: "if_id 0xf" [SUCCESS]
tests/ip/link/add_type_xfrm.t: Del dev-tkUDaA xfrm interface succeeded

Failed log:

[Testing Add XFRM Interface, With IF-ID]
tests/ip/link/add_type_xfrm.t: Add dev-pxNsUc xfrm interface succeeded
tests/ip/link/add_type_xfrm.t: Show dev-pxNsUc xfrm interface succeeded with output:
2: dev-pxNsUc@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none  promiscuity 0 minmtu 68 maxmtu 65535 
    xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
test on: "dev-pxNsUc" [SUCCESS]
test on: "if_id 0xf" [SUCCESS]
tests/ip/link/add_type_xfrm.t: Del dev-pxNsUc xfrm interface succeeded
[Testing Add XFRM Interface, No IF-ID]
test on: "dev-dSwSKP" [FAILED]
test on: "if_id 0xf" [FAILED]


