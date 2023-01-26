Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272AA67CE5D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 15:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjAZOkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 09:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAZOkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 09:40:08 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6357B26BB;
        Thu, 26 Jan 2023 06:40:07 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 0E6763200A69;
        Thu, 26 Jan 2023 09:40:05 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 09:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674744005; x=1674830405; bh=2y4ifRRBY2
        zAJdRnpFIN5yh9VL5vAaJGv1a4q1ONRxY=; b=nmLi29PHmhe7Mt1UUCxqHDFwV8
        Ydw/Al6jYtzGI9Fn5PDw67OEMYW/e54wH36cbLEcUsturGaSxLj0FizjrQ3bIwWh
        ENEolmTgll+nzxxv7pYkagVf4V0TXti7ixi57adlpY6tUQEI/nKTbQ/4LbM0u9vo
        mXp2Vlq2cT59FjaFUYykCUhycj85oKkl8efo9a/zJMrJCq/5i1qZer5DOG2679ma
        4XtVDlYqonTPCKnuH6uw+2yueW/izFLHXBf7Voxgw/toR+Q6GVbvnVNWreRleCdi
        zh04G1RP6FZuN6DGdEcXRjP63wOLjcUZVMc5IZxJDHne4EZwlU597xY1hNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674744005; x=1674830405; bh=2y4ifRRBY2zAJdRnpFIN5yh9VL5v
        AaJGv1a4q1ONRxY=; b=ZOh7Ea7S7GeZG9kQ6b/qG3acCa+eJqb97eVnHWk+RX1D
        my+5BC9JVi6PChQIcVRMrklJu3vLN9/pCqXhCMZeHloB1BqxjTSXJlrrD61RQx4U
        ILHi8l7rvuOYAB8iZ6lWaJLnixKEiQDb2PO7sIpACKeCZpRaaV0C3pi/XpIys+4D
        J6bgHWMIHvHRVkEUfzw684yeQQKW5nn+uv4gaM4DTV9rwmVLsxAZVGQLLnpBvhyw
        VSrlc86hHeGtH9svDv64u6BMu3KK2/bKDxuBamOvxBknt4UtX0XKCsjZSAoowFmV
        Qy3C2NAzylIKm76PJ99awpj2OohXBaohM0GDFlGq/w==
X-ME-Sender: <xms:xJDSYyPxWsV1TGssLmf5RIN4Fh0wIhUBxRGXfCXDJ1xpcZSlbq3l2Q>
    <xme:xJDSYw86mKpKCqL4tz6n2qN4xXcTtlFZW3vDH-c9UHDCGhfp0nybr9D00qqlP6tsa
    9A9MsfVv1rkTdFGQog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:xZDSY5SKLuYNZiZSPZsQR9_ihFm60myxVARhVoI6UHwasfepJqoF4Q>
    <xmx:xZDSYytlpS9pHzkxrF4e_2doCkeEZI4xnsVkGmJKefX6pcyNfdMgAg>
    <xmx:xZDSY6d5OKwOOQfMTLo_Cp4goFQTntLsEGF0z90dvT3GS3cOvOEcZw>
    <xmx:xZDSY7XDXHtwEtBIs7RLo0weclrHAsjjSfdsfKV1pJrvbLSb5nyP2Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E670AB60086; Thu, 26 Jan 2023 09:40:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <f83ae34a-b46a-47c8-817a-d82d43178eba@app.fastmail.com>
In-Reply-To: <20230126151243.3acc1fe2@xps-13>
References: <20230126135215.3387820-1-arnd@kernel.org>
 <20230126151243.3acc1fe2@xps-13>
Date:   Thu, 26 Jan 2023 15:39:45 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Alexander Aring" <alex.aring@gmail.com>,
        "Stefan Schmidt" <stefan@datenfreihafen.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        linux-wpan@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] at86rf230: convert to gpio descriptors
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 15:12, Miquel Raynal wrote:

>> @@ -1682,7 +1650,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
>>  static struct spi_driver at86rf230_driver = {
>>  	.id_table = at86rf230_device_id,
>>  	.driver = {
>> -		.of_match_table = of_match_ptr(at86rf230_of_match),
>> +		.of_match_table = at86rf230_of_match,
>
> Looks like an unrelated change? Or is it a consequence of "not having
> any in-tree users of platform_data" that plays a role here?

I probably did it because I thought I had removed the matching #ifdef
for at86rf230_of_match in the process of making the driver DT-only.

Without this trivial change, building the driver as built-in with
CONFIG_OF=n can result in a warning like

drivers/net/ieee802154/at86rf230.c:1632:28: error: unused variable 'at86rf230_of_match' [-Werror,-Wunused-variable]

It looks like this was already removed in a8b66db804f0 ("at86rf230:
remove #ifdef CONFIG_OF"), which was not technically correct, but
nobody noticed, including me.

I could split this out as a separate patch, but it's probably
not worth it.

> Anyhow, the changes in the driver look good, so:
>
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,

    Arnd
