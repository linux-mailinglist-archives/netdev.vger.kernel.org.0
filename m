Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7726E9422
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbjDTMVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjDTMVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:21:37 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC34C37;
        Thu, 20 Apr 2023 05:21:35 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C5AA5C017F;
        Thu, 20 Apr 2023 08:21:32 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 08:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681993292; x=1682079692; bh=aj
        j8ckcYRmO7dOoo1JmsRpld7eVArWfG+uH2nIR89dI=; b=T0gxSfg/fhE0/rGhnZ
        RjHfgwADDlW0YfrFf3O0WfTJZXdSigDoof8ibpiw46qTGigWNagguWzRPPYyTCAk
        5bGcrIVS/QZ93MECLInizrp9agyWHbQvPQglyQ4MkTsVaXYTPYbSjxcdK45//SwJ
        oxEZYv9o871fYGWl5Oe/VXwVGwSUEdCLn2hxEYhhTIoC801Fbo5uRPW5R1QtJz6B
        gY0ErVZEa0ERalJ3XFJb1lIRmrr04ULxU8NifO/HCfz2NoKH13i3mh3xKXHEadq3
        VCDnAqzVNlK/rrcyYjfOSQ6L/ee0TmdI7ucL5ivGAyk6ocKoamzCWf3Aanvr6ZUz
        TZ/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681993292; x=1682079692; bh=ajj8ckcYRmO7d
        Ooo1JmsRpld7eVArWfG+uH2nIR89dI=; b=JKKcjIXb3s3D8DdViWBfx1XsCr/mb
        LRJKz2aUzTifLpx2f/NXUQK2Z/0XGtHiMngLqFgg+Gh0ZHB9WxkF8o+mADK2VMU2
        XkMUfZY79qb2b7JlC35e38vJbOUqgrjmaWMB+ozX7k+Ce00YP6CC3IvuPD5xYFWR
        fpwGk2UCBNy7mLcAXG2WzgtWDVC/LHIAWO3Z+PShh0iV43KEYAoVhzfzzJ/eIS2f
        KY8m7szPTf2RhOIwFwXW5NqLNEaoJfb74yD2XltqGe4fDWsC0mokpaqSUDT3PD79
        Wy4yeUPqWAPnyf9GHSFsIbIwAq0ovl69MHUhTf7yYFAAP3HOrmVhe3bbw==
X-ME-Sender: <xms:TC5BZEuLiJgeilkq3pZZJhRmEDewiCR9znuI7wZ26siFN0Fz5Tt4mw>
    <xme:TC5BZBfNYloNDEK3Il2SjnnRFCwEe1SHbbTnfAauGNMN6SjTkVq7bg09ZEDVETFCw
    -gf32G9dKCmknDHCBY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:TC5BZPxU6DpN3wG4iSxDYPquMWcY9uHDRWxPhrPn3HqQXqi_B2cbEA>
    <xmx:TC5BZHMDevZwSsCCEmowJ9naB-XCxHbBu_gidtXYjaQ3wq9llbgOiQ>
    <xmx:TC5BZE-OVLVKVEmfcx9mEueVck_bAhxvEMMCV8XhZVyziHtgrQ7qJQ>
    <xmx:TC5BZF1Sx18Q_snCEuxjLSjpKmRc68pRkCYyiYmfHBAsfmGHcG8J_A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 23594B60086; Thu, 20 Apr 2023 08:21:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <a5ed97f2-b3f8-454b-a63a-16e7153003a6@app.fastmail.com>
In-Reply-To: <CA+G9fYuMEEzTUyF-pCVuZYd+BU53_8MRyXoOmbYEo1O1v=9teg@mail.gmail.com>
References: <CA+G9fYuMEEzTUyF-pCVuZYd+BU53_8MRyXoOmbYEo1O1v=9teg@mail.gmail.com>
Date:   Thu, 20 Apr 2023 14:21:10 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev
Cc:     "Russell King" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Anders Roxell" <anders.roxell@linaro.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: next: arm: drivers/net/phy/phy_device.o: in function `phy_probe':
 drivers/net/phy/phy_device.c:3053: undefined reference to
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023, at 12:51, Naresh Kamboju wrote:
> [ Please ignore this email if it is already reported ]
>
> Following build failures noticed on Linux next-20230419.
>
> Regressions found on arm:
>  - build/clang-16-omap2plus_defconfig
>  - build/clang-16-davinci_all_defconfig
>  - build/gcc-8-davinci_all_defconfig
>  - build/clang-nightly-omap2plus_defconfig
>  - build/gcc-12-omap2plus_defconfig
>  - build/gcc-12-davinci_all_defconfig
>  - build/clang-nightly-davinci_all_defconfig
>  - build/gcc-8-omap2plus_defconfig
>
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Build log:
> ------------
>
>  arm-linux-gnueabihf-ld: drivers/net/phy/phy_device.o: in function `phy_probe':
> drivers/net/phy/phy_device.c:3053: undefined reference to
> `devm_led_classdev_register_ext'

I sent this patch now:

https://lore.kernel.org/all/20230420084624.3005701-1-arnd@kernel.org/

      Arnd
