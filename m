Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EB76A5486
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjB1Iht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB1Ihr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:37:47 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2023919F25;
        Tue, 28 Feb 2023 00:37:46 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id E32B15C0145;
        Tue, 28 Feb 2023 03:37:42 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 28 Feb 2023 03:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677573462; x=1677659862; bh=bNOL6dMp9i
        YZZl04z0RBXD9l8jOntO4AqkKsmgHnVhU=; b=CHUa3o94TMUNVsX9/Zz0vsJdyc
        h35O81glpTkF7T0THcVqLDhw2FyfsdFJ/CK9ibW6acuCcCoPKvcmqdUy6EXTgqyU
        /oWv2XbimJgMoK8YgkMagzaGMp3WodRMpaaQyIxiquJPBgIfQLjYFR1Tu2jVX9AV
        8upruDIliKA4pIK/5SFjYlz2oI9sM6VJ8FMAURTEZscP4haviwvn1Wv0sZTtdQDg
        YWQwesFjdPS8gHKuX13hkgU4YwPdObQpg72Y0OkKLkye8COjw1bxJxYWlxw8WecJ
        u39EFqpRYLdWZGJIScKAfUg8yX+2DSD3kF1S/47nUV9aDyQ9qHaAO36TjyVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677573462; x=1677659862; bh=bNOL6dMp9iYZZl04z0RBXD9l8jOn
        tO4AqkKsmgHnVhU=; b=FcIAbpq39dKkCVB7/nrEL0HSMu/Goub43y5d3EMN0I0B
        hzTD0gTG4c/SID9bYAUMxXKiW0OQvCaWQ9sXTGkCQFkK/4V+JNG/yCqYeG6WAx0Q
        WI0pmNVzARviAS8ZDHZ3PrAITMpMp8JYOcICgHsfbmLzCYaGZO4UbDu+NOL2smxe
        KSx6oKNNyIbLmZOWgjoL41PWAXwPPEvxq8iMJWznfIRkJ1qDDvGLjxrcSkJI8fbW
        31jSogKn/joHfvRO2J03jWZdPLmauq/77zkShzY+cm8aiVdSID7oK8gyXTDh2JXI
        0Cr/f//NBEAZkj5miFjq1mUoX8loHNumTfR+koU4MA==
X-ME-Sender: <xms:Vb39Y331EKqm317YZFalHXGw8zQZYR56_YI_8Ma2KFR43yiU-eTUjg>
    <xme:Vb39Y2Hw-KK-HVckWZ7vg9_kcZKjlo4iBxBiEEpJjazvu_7gR7_s6QOddmrCSM3ba
    srY65NA69GG6gx5Uhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeluddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Vb39Y37Xwbp3uTv7MbACAMzNl093eYyjGC3A5tvrsC11pLDiafXMNA>
    <xmx:Vb39Y81gL92BaiTKkD-Z36O4mNZee3sVHnl1bnzw7cPWPumBMzhWjw>
    <xmx:Vb39Y6EpZP0HNBSt-sGMUio4fM51BHjkEol9LDUiXqzcpMJwW-yy8g>
    <xmx:Vr39Y9mYuRWLy_dmJncffFhN8xGp91P4cbj8JMvmINamP-ovc-JHmg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 8CBFFB60089; Tue, 28 Feb 2023 03:37:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <31fee002-db3b-43d9-b8bc-5a869516c2d7@app.fastmail.com>
In-Reply-To: <18be9b45-e7c1-9f81-afeb-3e0d4cfe5f73@lwfinger.net>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
 <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
 <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
 <18be9b45-e7c1-9f81-afeb-3e0d4cfe5f73@lwfinger.net>
Date:   Tue, 28 Feb 2023 09:37:21 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     "Bjorn Helgaas" <bhelgaas@google.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Hartley Sweeten" <hsweeten@visionengravers.com>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Kevin Cernekee" <cernekee@gmail.com>,
        "Lukas Wunner" <lukas@wunner.de>,
        "Manuel Lauss" <manuel.lauss@gmail.com>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Olof Johansson" <olof@lixom.net>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023, at 04:57, Larry Finger wrote:
> On 2/27/23 15:30, Arnd Bergmann wrote:
>
> It was a configuration problem. In the .config obtained by installing 
> your 
> patches, and doing a make, CONFIG_CARDBUS was not mentioned, and 
> CONFIG_PCI_HOTPLUG was not selected. When I deleted the reference to 
> the latter, 
> did a make, and set ..._HOTPLUG, I got CONFIG+CARDBUS set to "m", and 
> the yenta 
> modules were built. This version sees the BCM4318 in the lspci scan, 
> and the 
> interface works. Your patches are OK.

Ok, great, thanks for testing!

> I am not sure how to warn people about the configuration change possible 
> breaking things.

My intention was to keep Cardbus support working with old defconfig files,
and I've not moved CONFIG_CARDBUS into a separate submenu between
CONFIG_PCI_HOTPLUG and CONFIG_PCI_CONTROLLER but left the driver in
drivers/pci/hotplug. I think that's the best compromise here, but maybe
the PCI maintainers have a better idea.

     Arnd
