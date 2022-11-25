Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95FC638954
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiKYMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYMAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:00:09 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1062C65E;
        Fri, 25 Nov 2022 04:00:08 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F9F05C010F;
        Fri, 25 Nov 2022 07:00:05 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 25 Nov 2022 07:00:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1669377605; x=1669464005; bh=ORhbw5an4G
        KOiycsFaYqr6B7NvcZliSQjROA9jUxxDQ=; b=SX3HhB2VU0akjfNzf1Zjg3a/E/
        WMXIeswGBRQdbDbwf7BDfohblR9XpFpj6zaI9zO31143qWlt4oq8tio5c/tA8DYr
        /dsxgEO+BGRv4k+uYBAybNhuYoBjtVqC+AvVQhTdBHi1vGu0dkPs8S+/VEHjYBTc
        NCk5sObJZOh5PywusTWdp9W8XLSNipo02ImL7YyIJPcFB5rAqStowiZ56+Hh8Fcg
        k30lRJq42LxThw98Lnb2RrbeWjPIpZJId2zG+9cYJ1BZzBFrahPUTkBWIVj2s/x5
        3eNW6Qq8gXTMYglbUtHo3/ha1mOh4O2kdM0pN3F9GTnB+xPT/ZYfyEYiufnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669377605; x=1669464005; bh=ORhbw5an4GKOiycsFaYqr6B7NvcZ
        liSQjROA9jUxxDQ=; b=ZoKlCL5YPv32N0RUcpxX3a7QvEHwfmqOW61w0eFQcxI8
        euGHCkRQpIyTmDq/RSB5o+/Nm4HYRPslxu05jMYBuERy6kf97/BH0QEHCoWh4c5+
        4v8OT+laiPrqzXRAskS12VGUsnYlZkhz4LMGGVbt/RoVQz+KhrR+06qiy0D9DHHN
        XL5kMRKJ9J2gT3CzgPN0fmaZ6kgCF8q+Vy3IKosLtd/ORh1dwpT+ut8ry7LhK5OP
        5G3MfCZ3spqMdMrOaiw0P21kSZa1OTFC0NbpWCnF07DvsLcM28RnpbC9q/dGdwp2
        hYIC0XYdpydBe/b+o69nGHcwoKcR5bfQvhulJRC6/A==
X-ME-Sender: <xms:Ra6AY9HtGXENshMown2z-nLMpSjYeMpr9U9BWEDQKRh1n9bv8ElXNA>
    <xme:Ra6AYyUkVjaBnLfZbfmbU1Of_q9zTD_4bT9etK8FVpBYxrHO_0_qRLPamrtfQ1x2J
    slANLQ16Rp99zqAmwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Ra6AY_L5ouZKpCDJx89DpbzqttGSqUlX19fpuOYdKhQSFEfN1sfKGA>
    <xmx:Ra6AYzFE7yvr-5avfIo59jRUYy6G_yQl6HlLmQzQQoVSWJA23JUd2A>
    <xmx:Ra6AYzXTk0O97UnKHdY6fIXqHQiIZkIJ-TF4EeLUsHmch16zVJAxkA>
    <xmx:Ra6AY6EBVauUH7dPJEDvicc4Tmo-_8-PBKrqPuYB5YRj-9v1mckffQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EEE29B60086; Fri, 25 Nov 2022 07:00:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <cfd1324c-ca40-4af5-a469-2e9ba897dfcc@app.fastmail.com>
In-Reply-To: <20221125115003.30308-1-yuehaibing@huawei.com>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
Date:   Fri, 25 Nov 2022 12:59:44 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, f.fainelli@broadcom.com,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET
 under ARCH_BCM2835
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

On Fri, Nov 25, 2022, at 12:50, YueHaibing wrote:
> commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
> that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> leads to a link failure. However this may trigger a runtime failure.
>
> Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
> of BROADCOM_PHY down to BCMGENET.
>
> Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
> Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks for fixing this,

Acked-by: Arnd Bergmann <arnd@arndb.de>
