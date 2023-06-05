Return-Path: <netdev+bounces-7985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DCC722582
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82FDB281138
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B856B18B04;
	Mon,  5 Jun 2023 12:22:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998417AD1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:22:40 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1FAE68;
	Mon,  5 Jun 2023 05:22:15 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 9A3D53200913;
	Mon,  5 Jun 2023 08:22:11 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 05 Jun 2023 08:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685967731; x=1686054131; bh=7W
	iLrLsF5xVxXNcAy4Mh7e7hxHBVb5egJsZ8LOLNRvo=; b=2o1kwlV3Do2loqfo88
	8E8nDDB5CavhahXYo6NRabED24JsbSPlA/28nBdwLSv8pPi6tdbInnX6ZLfYGJIm
	d/ZZHp7m3paDvnOH0noWl7Ko/QtboQpabiwAApHaYpbnOwCG8p32w6UHX3sH2Ryu
	+1MCyFRdDI/RN6Vs811t++D4ZDUd9Q086Ay7fCnXsIeNNYynG3hZ+0AZcg8R/dGf
	/pCFJ5fYIIzQeWOQ9TU+7r18p7N0MpyKzCac44ZpElncC9G/hZJVnXyo8ZaNm+H5
	Xu64ngLXypJBb9h19upA8yk8tu8iWMkH+/NUkndFMdFatP/V6RtvpzMYJ0L+1GlG
	BYjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685967731; x=1686054131; bh=7WiLrLsF5xVxX
	NcAy4Mh7e7hxHBVb5egJsZ8LOLNRvo=; b=bMOmsPyCvbE5xOYlrfbDXKiyTdvl0
	h1VBo3CiJg9/m3T4yfz7v6rr4FNGm/olLi+ic+M4vg1lnfrcUE5OFFK2K9z+7YPV
	1uLrhqglfmTMp0PhHZ40d1x813XFyKNPtEhylYRwrnhGTJrWr6J4kNdDxDPFe7HG
	Bq3psbyd1ZbIVb5pPBWyAH2s78xfNogW1DvNWuncHMbTSH7xFkyBLGVqKRpaEK1Q
	u+SEAeHhjPQPRh6JCOdsylGdjmsMme9LyKKeqNNtfyhSVnrf2ka0IyRtrUXjnn/C
	A8jkfIUvqaljFkLxBRaemIN76g3qGznuTBwEZYlOUJEyOl1SkhQw2DpNA==
X-ME-Sender: <xms:ctN9ZDmD-tSymJN54hej2KEc-SLnn0p6xZC_NVsNaNZlh6NPqUqI2g>
    <xme:ctN9ZG0xEW8krpuXFulA_rknWNdgRDA6LQIUcgWN1ZWQM7VKvzUCWUu-a9tdf802u
    avA_EX3MyQOR_4oRfo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelledgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ctN9ZJpRlsoxA7UiHkqptL34w_v_IjkGD8QhakerALnfohbmRYGSYQ>
    <xmx:ctN9ZLmGLFrIAbb-zW7rxXN7J0076toHehHcVydIzI9Z0PlSSDgacg>
    <xmx:ctN9ZB1Xz0IQNNTMSL3_dcw1XG4Q85C4_eI4tBnm94D3uLNNSd1GFQ>
    <xmx:c9N9ZOLlaiJV7ZDVd7olUsSd-GhbZoNUddglv_9XL9y0u-TTf6ke2w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 96776B60086; Mon,  5 Jun 2023 08:22:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <d98d050a-29dd-4ee7-86cd-bad4e6a04584@app.fastmail.com>
In-Reply-To: <3e262485-bf5f-1a98-e399-e02add3eaa89@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-22-varshini.rajendran@microchip.com>
 <be3716e0-383f-e79a-b441-c606c0e049df@linaro.org>
 <3e262485-bf5f-1a98-e399-e02add3eaa89@microchip.com>
Date: Mon, 05 Jun 2023 14:21:50 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nicolas Ferre" <nicolas.ferre@microchip.com>,
 "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
 "Varshini Rajendran" <varshini.rajendran@microchip.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Marc Zyngier" <maz@kernel.org>,
 "Rob Herring" <robh+dt@kernel.org>, krzysztof.kozlowski+dt@linaro.org,
 "Conor Dooley" <conor+dt@kernel.org>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@microchip.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Russell King" <linux@armlinux.org.uk>,
 "Michael Turquette" <mturquette@baylibre.com>,
 "Stephen Boyd" <sboyd@kernel.org>, "Sebastian Reichel" <sre@kernel.org>,
 "Mark Brown" <broonie@kernel.org>,
 "Gregory Clement" <gregory.clement@bootlin.com>,
 "Sudeep Holla" <sudeep.holla@arm.com>,
 "Balamanikandan Gunasundar" <balamanikandan.gunasundar@microchip.com>,
 "Mihai.Sain" <mihai.sain@microchip.com>, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
Subject: Re: [PATCH 21/21] net: macb: add support for gmac to sam9x7
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023, at 14:07, Nicolas Ferre wrote:
> On 05/06/2023 at 08:42, Krzysztof Kozlowski wrote:
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index 29a1199dad14..609c8e9305ba 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -4913,6 +4913,7 @@ static const struct of_device_id macb_dt_ids[] = {
>>>        { .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
>>>        { .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
>>>        { .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
>>> +     { .compatible = "microchip,sam9x7-gem", .data = &sama7g5_gem_config },
>> 
>> These are compatible, aren't they? Why do you need new entry?
>
> The hardware itself is different, even if the new features are not 
> supported yet in the macb driver.
> The macb driver will certainly evolve in order to add these features so 
> we decided to match a new compatible string all the way to the driver.

It sounds like you can still drop this patch though, and only add a
specific entry here after the .data field is actually different
when those features get added.

The important bit for now is to have the specific string in the binding
and in the dtb, along with the fallback for I assume "microchip,sama7g5-gem".

     Arnd

