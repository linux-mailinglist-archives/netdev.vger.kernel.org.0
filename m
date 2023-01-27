Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BC467E0E1
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjA0J4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjA0J4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:56:22 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30571A48F;
        Fri, 27 Jan 2023 01:56:21 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A0145C00E8;
        Fri, 27 Jan 2023 04:56:21 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 27 Jan 2023 04:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674813381; x=1674899781; bh=Ek2r2jSHix
        ixjWq33qHaUHF/N9rmNq22jzG/Lx//aCc=; b=Pvgs6LgvCdJiTREtkmTr5Ax6Wj
        coLOUln59FyAik3QtNONcm5tVrKuaDy/nkOs+UZ8Dedlt2SGjvg0bwSL8P75M49X
        OLnGBkrO7G3i6asclI4S5Z9kInolHuLNPOuFcjpUe/yjvdGXksoABX8jfyvG/9+P
        8qFXHnSE6jU1WdTcYv1Ml6qQkIIByE7xJQPp+AhcKKeqJR9rfCH6ser1YGc4zRei
        E/GdIB4N6v78fO3n9Aaz5COJCNrJrNNvevW1oALfP9rRifQClrn8L1sdqVrlVglt
        Lpz746d3CdKHaXz9+0sBLbSJ6p0nHKhKZ7d6v5vO71ZcQNJ1e55rtYvKjOkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674813381; x=1674899781; bh=Ek2r2jSHixixjWq33qHaUHF/N9rm
        Nq22jzG/Lx//aCc=; b=RU5lNj/NnEnKRbtPJIQUggYU/TMLV+UdWjUkKwfFxzSD
        NuK15ciiaVRQAa4o203DS47Ls6nqBPIIq7BaxQnPd3O7d550QRFJ3HlVMq80DdLb
        wENNJHWhE8o28ul/pfhx58KE6Di3y/iJQviCdOmAUfoIq4iwI7tyZbWbpxhYglNh
        tkL0dFTrzUaQJca7CCDaEOzbTydCNpToRIwkrBGvbkB/bJO9g4YIpL9AVgt78SV9
        R8ntXl7dAhpKrMGhoGc36f8PV9m7w2DkeHCPJQwhTn+3WF+1/Jehugcv6ZHYlbDu
        t9U7BuKr7cR/JvtOB+KMsyxjYpsi7UoJBmqORL2p0w==
X-ME-Sender: <xms:xJ_TYzBn6CYrUBu69A7VriFYQojAfqKv_rAHWFCphbiLYpSlAJ8q7g>
    <xme:xJ_TY5gr32XbHA0GUfBsjDpDU2NUGpZ_CMsSMUEFt1WLZ8i2RJiWY5SeE0Rhe-b1U
    wJD03QKBHAy9i3e6CU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddviedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:xJ_TY-l3sNjKngcTBgOQsDDYUri24Q6y9VJcYBHdjNj9X5X1fB7RZA>
    <xmx:xJ_TY1zQjayEptGEmjVjp9E7mxIiBMPUKv35hvXJuMxmNPkBA8mAdw>
    <xmx:xJ_TY4QjqPo2Uy9ETbrtB1jCpb40hxdVIG09a5zF-oCn1sg57NzpZg>
    <xmx:xZ_TY7EsAVNLgt6wsRheVHDT9tMYWzKfgo8XW62u1Z4BKcIC8itR8w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E2E34B60086; Fri, 27 Jan 2023 04:56:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <e1b8282a-0b5e-4f6a-9692-485fae23c121@app.fastmail.com>
In-Reply-To: <20230126210803.1712901-1-arnd@kernel.org>
References: <20230126210803.1712901-1-arnd@kernel.org>
Date:   Fri, 27 Jan 2023 10:56:01 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Arnd Bergmann" <arnd@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Leon Romanovsky" <leon@kernel.org>,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] wiznet: convert to GPIO descriptors
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 22:07, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The w5100/w5300 drivers only support probing with old platform data in
> MMIO mode, or probing with DT in SPI mode. There are no users of this
> platform data in tree, and from the git history it appears that the only
> users of MMIO mode were on the (since removed) blackfin architecture.
>
> Remove the platform data option, as it's unlikely to still be needed, and
> change the internal operation to GPIO descriptors, making the behavior
> the same for SPI and MMIO mode. The other data in the platform_data
> structure is the MAC address, so make that also handled the same for both.
>
> It would probably be possible to just remove the MMIO mode driver
> completely, but it seems fine otherwise, and fixing it to use the modern
> interface seems easy enough.
>
> The CONFIG_WIZNET_BUS_SHIFT value was apparently meant to be set
> at compile time to a machine specific value. This was always broken
> for multiplatform configurations with conflicting requirements, and
> in the mainline kernel it was set to 0 anyway. Leave it defined
> locally as 0 but rename it to something without the CONFIG_ prefix.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: replace CONFIG_WIZNET_BUS_SHIFT with a constant

Please disregard v2, I found a build regression in some rare
random configurations with CONFIG_GPIOLIB=n, v3 coming up.

     Arnd
