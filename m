Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F5687979
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBBJtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjBBJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:49:03 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E82A7BE4C;
        Thu,  2 Feb 2023 01:48:34 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 592925C018A;
        Thu,  2 Feb 2023 04:48:17 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 02 Feb 2023 04:48:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675331297; x=1675417697; bh=CiULM1jpaz
        VqNIAxfxvBsJCRH3PL/Pmm6+XQw+54KMc=; b=KyQ3TPJ6ldt2vk18DoLypbpxZH
        bC/qlrC8AFAEWnkGCEPLMvv/x5+MHR2rN2uUR6zH/GgLabkXwsYwnzrs75U/CoqZ
        hBgN7PHNNSqpRGkDeTJwzsqzK+91jwympMt9CXlnqgFaTagm0iouAYBEMkjcxu7k
        Oe4nCOIzjzvcw4ohgZwQdDCPHPsHaVW1HIOzJ5vC/mma06tXY7kweVIKuitRid5w
        /avqODo0qXRnZJ1WD3kDQo8vNOMNgYQqz1Idtis5N4lUcG8i3mThiZpiEU1aLTbX
        byBREppWGJQjFkvV6yrNi2dhGBfRDBcjXP/Bp3B4WEMgX99fd8bQEExpjpKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675331297; x=1675417697; bh=CiULM1jpazVqNIAxfxvBsJCRH3PL
        /Pmm6+XQw+54KMc=; b=jFqA/kFJhRg2Qfp/dWe9lzDaqGC02SZAJDCQvfcw8Ip6
        vMCd3vP0yChhRijW4fTlAOs1n1/VzGzqwMxGtaNuK6X8DjzNpcALOl/31Lu2YP/8
        baw+uDPo7ohak+wtbT94H+MXDXrpoo29Zk0ljmIaIBk4LWclU/m4Vqw+UXyGMsTy
        PQP2DXoWV+FallqN9jqGTw6vNphrsUtBMCvct8IS5cnRf1Rt/Kf1sU3AASO+Xaax
        kmMW5xWWiBNCwXjxn8tx+RwusMxlsvezKa/w44p16Mpim7OdH8YKuinykvwrdHuQ
        pIIVcLr24D+Q+32j2U2avPgYXYIdMbMZWSVZiIjRVA==
X-ME-Sender: <xms:4YbbY6zw2b47_A-ux_mkmUqoypeg6uf2i9MhdlW_PJO8-JlIovHLIg>
    <xme:4YbbY2QdjF-uCfqKCqF9hhK0V-t-4eN_S8dsNw8HP5NWYjh-eNkrWhXedUBAf030m
    0cwfx7HeGcV2-Jgl2s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:4YbbY8WzoFhaA9EzW3BUuWhtrlihuRdtWNPdTGf65LTISnaxRY6-8A>
    <xmx:4YbbYwj1bvJzsjgf58aI9P-W5rmI2aEY4fAjpwRO70zwM_CFA1PiKg>
    <xmx:4YbbY8BIB_lgzX7sf5R6vsdUQaPjtBlwGaioy1OZIdFzUhu_YC7m0A>
    <xmx:4YbbYw6L0dAuX4OAX2feLMxXW2g8yiZNCuJa8yIrhJgCyxu9IPtYgw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 01C78B6044F; Thu,  2 Feb 2023 04:48:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-107-g82c3c54364-fm-20230131.002-g82c3c543
Mime-Version: 1.0
Message-Id: <566b855b-dbdd-4c10-aac2-262b64343ae6@app.fastmail.com>
In-Reply-To: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
Date:   Thu, 02 Feb 2023 10:47:58 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Wei Fang" <wei.fang@nxp.com>, "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>
Cc:     "Shenwei Wang" <shenwei.wang@nxp.com>,
        "Clark Wang" <xiaoning.wang@nxp.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: fec: restore handling of PHY reset line as optional
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

On Wed, Feb 1, 2023, at 22:53, Dmitry Torokhov wrote:
> Conversion of the driver to gpiod API done in 468ba54bd616 ("fec:
> convert to gpio descriptor") incorrectly made reset line mandatory and
> resulted in aborting driver probe in cases where reset line was not
> specified (note: this way of specifying PHY reset line is actually
> deprecated).
>
> Switch to using devm_gpiod_get_optional() and skip manipulating reset
> line if it can not be located.
>
> Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>
> v3: removed handling of 'phy-reset-active-high', it was moved to patch #2
> v2: dropped conversion to generic device properties from the patch

Thanks for fixing it,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
