Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAC67E230
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjA0KuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjA0KuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:50:12 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B731D761FB;
        Fri, 27 Jan 2023 02:50:10 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id F19355C0343;
        Fri, 27 Jan 2023 05:50:09 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 27 Jan 2023 05:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674816609; x=1674903009; bh=mAgmgifJZb
        sNY0MSx0GdHlaxsbe0sdIlGrvLoHOEdbs=; b=ryTNrn3MDgQn3vHVTKYe63xMqJ
        7zwljaDpWplmn8gnB9mvrHoji34aXTVZ6jKKhDgr/mAZg3uSHDYuJebgcVwemXK/
        J4BVnqYquVMfTkXwDmngbgjaJcZkE7W15k4XN3dbsee5+BQGiqgpe6R1GDH+9CvG
        m4GEOH1DVd+6RR4mBDljnI9z3vmfUDLl/veAeuO8oOGr+8AVzDKB0gcRa6PhUIBd
        AJMFlBO/N4VNqJqIpjAYWBDjS/gJtQPHEH96iXPqcMhYH2E6NFmfd6tdP7jcAyzT
        d7fcBStZo/6sWvnAJSTtx0GcD4N/9cWwA10igYCw51V2E7VPXZpM6j7yQctw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674816609; x=1674903009; bh=mAgmgifJZbsNY0MSx0GdHlaxsbe0
        sdIlGrvLoHOEdbs=; b=iJAtqWkfpfdhkAfLCNxr49fiokSrGLwD5tZHw4SLejkl
        QgarbAnscD5IrcJREV4tE+9tsoUM5LdU97Mf+qh9LgEWqkcnKL7+mhayUMPV2cLU
        9SKb0IQWEVSCov479gEiC0gESu543/sYkwKr1EVITzcv2n/87SBHUwrY8M8EO5dU
        CTIzSsawYD5PhP8plhNVNlwNmi3n7mLlWS0jb3x4EH26bP48Gzq6wDFeQNDjYVeP
        bXY5oWIMdeJDtAZ3zSZR2LXMpidnMnWYuGgS+IMznEvFzSsV1wEzTvOI2M8L1o3P
        fOSwXkiGIx9eHqHYwpkD/SjhGKJVHMCCeydNPQ0mMw==
X-ME-Sender: <xms:YazTY9qed4OCVC9IuRsIEEdem2YyGsaMflu20pDeOg3bS7m09qlEyg>
    <xme:YazTY_qalDdXvNx7vs-nQ_9RHOqkqwEeTaHu6hTL8LBEkPCG9DCB7e6ktUFM_ZvcB
    dSFXrCsl60QIlMRAa8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddviedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:YazTY6PwWs-E9Q2TtDllhV5ldYBtO4_DNywbRATFMr96EtA1zsQ8TA>
    <xmx:YazTY45TEnMyJduU6TCna7rBHvG_R0SufXCw-ePPMLegb4wQegSB8Q>
    <xmx:YazTY87rCt0p_wxnTrsgbzFO77MyN6LZ4NCu8xMN9gmKDv0nUFPFYA>
    <xmx:YazTY9Fzu5XKcuQZLS52K1EPaes9BrCxEgxWN7_z8mwEdwCZcRN_VQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BB8E9B60086; Fri, 27 Jan 2023 05:50:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <8c0dc833-b61c-4e4f-b4aa-20109fd2ff17@app.fastmail.com>
In-Reply-To: <8028ffe4-c042-e405-ac64-6707c84d5a1f@microchip.com>
References: <20230126135034.3320638-1-arnd@kernel.org>
 <8028ffe4-c042-e405-ac64-6707c84d5a1f@microchip.com>
Date:   Fri, 27 Jan 2023 11:49:50 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Ludovic Desroches" <ludovic.desroches@microchip.com>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Balamanikandan Gunasundar" <Balamanikandan.Gunasundar@microchip.com>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        linux-kernel@vger.kernel.org,
        "linux-mmc @ vger . kernel . org" <linux-mmc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel: convert to gpio descriptos
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

On Fri, Jan 27, 2023, at 11:32, Nicolas Ferre wrote:
> Hi Arnd,
>
> On 26/01/2023 at 14:50, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> All Atmel (now Microchip) machines boot using DT, so the
>> old platform_data for this driver is no longer used by any
>> boards.
>> 
>> Removing the pdata probe lets us simplify the GPIO handling
>> with the use of the descriptor API.
>
> Thanks for your patch. I would like to know if it's related to the 
> initiative started by Bala in this series:
>
> https://lore.kernel.org/all/20221226073908.17317-1-balamanikandan.gunasundar@microchip.com/
>
> It's true that it didn't come to a conclusion yet...

I hadn't seen that one, my patch was a somewhat older series to
convert a couple of subsystems over from the old of_get_named_gpio(),
with no special interest in this platform.

It looks like the patches are fairly similar, with two differences
I can see immediately:

- I use the normal devm_gpiod_get_optional(), while Bala uses
  the fwnode variant that should not be needed here since the
  fwnode is the one for the platform device itself.
- I use the normal gpiod_get_value(), which will handle polarity
  as specified in DT, while Bala's patch uses gpiod_get_raw_value().
  The difference is what happens when the GPIO_ACTIVE_LOW flag
  is set in the DT, and the possible combinations with the
  "cd-inverted" flag. I did not test my version, so I assume
  Bala is correct here, but it would be good to review this
  carefully either way.

     Arnd
