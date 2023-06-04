Return-Path: <netdev+bounces-7749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D00737215E0
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9025928122E
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EBC441C;
	Sun,  4 Jun 2023 09:50:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763CF23B3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:50:11 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60A7D3;
	Sun,  4 Jun 2023 02:50:09 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 40D975C00D1;
	Sun,  4 Jun 2023 05:50:09 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sun, 04 Jun 2023 05:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685872209; x=1685958609; bh=jB
	pSfKUu6g0tTh7kun5Pd9yKmiW3zyzac/8DZ01kT8g=; b=oJbdWX55eMSWq+02KI
	fRuMpx1qCk5Z6EmEHNTxJ/9fY1O9EwSkMTJ0U621i8SO5m8hNbXBly2ZdmkI9oBw
	MrW+rXFBtPKWQsh+eubuTktF8EiAmSymTwSedENUv5rb59onYz30bOXY9y8bbNcx
	CNCFb5C7bONp4HBlsCF15ahCMTtBrvzger2KL7zbzi0/P4dVidtvdZNnXDMeve38
	iha011cuAYIbyFmEzRV0l5GU562mvKRa4u8+ANyRiruCM4SZmDaYfgeNcsKUoZBw
	wPjSvwinNQm0nLFygzOIAykjVgQ3QwDEV9LLMhqb6lmTyP8AGVr26cF0h3MaGEUE
	pQ+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685872209; x=1685958609; bh=jBpSfKUu6g0tT
	h7kun5Pd9yKmiW3zyzac/8DZ01kT8g=; b=ZJ7ZqSZvdfTNq4EwCH4RGXcIV6jHU
	YaAlsG9hRyLfDhtcj1IJZ7irMJmASH/Gp6NrcZWAGwaRDgeZOWWJXEmzurL6YNC6
	rSvoHQTxBv+UoQeWX00gR8CoGjM8F/MYP2FS+6m3DkzfTl+3ngVQKecAnedQgxJG
	qWUQFvcjO/0pwY773+89etlzQweH0IHZ+oIh14pBeg/keoKvGCp4Kx7tpW1HguHK
	aFHkoGuIka5CUnmTjLJH/nxm2wPH6DUb3sxydGo0TDobkxNZQAMpyQ2P/JMp/KDn
	ofGvXOUeeV5detfqylU6uuIMpiYWEYi+iwqA4IB0uuMP/s6pBChaMMcww==
X-ME-Sender: <xms:UF58ZFDkXvUfT_kpYfCql7e_tG7AIFp6eOT2Mpn6h3_rzq_qGK-9Ig>
    <xme:UF58ZDgyPdwZtSZr0A8wGMMAQen99qWzOZcQ0HIfm3IqrxBnS_XU4IG1lomrhIqPQ
    ACoktosoZJBnBBtpiI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeljedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:UF58ZAkKLZTntqZL03bWn0CngTJJhscpwa1yGJ2ulsVNzq2m5LuPuA>
    <xmx:UF58ZPzHYOHAr8cyqxDbK8D65-kYtraE7NvYfVxaeq_NsD7AYn-kCA>
    <xmx:UF58ZKRSdQooc9lvDs9hQksGNU0Z_hi0UWdWdFpMGYU1DZENuFlpww>
    <xmx:UV58ZD2G9wXgl_EejQe5nWqgbsh89fAMALZCeXwz8EQ3_O_rpVB7Kw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id AC67BB60086; Sun,  4 Jun 2023 05:50:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <4d3694b3-8728-42c1-8497-ae38134db37c@app.fastmail.com>
In-Reply-To: <20230603-sanded-blunderer-73cdd7c290c1@spud>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-16-varshini.rajendran@microchip.com>
 <20230603-fervor-kilowatt-662c84b94853@spud>
 <20230603-sanded-blunderer-73cdd7c290c1@spud>
Date: Sun, 04 Jun 2023 11:49:48 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Conor Dooley" <conor@kernel.org>,
 "Varshini Rajendran" <varshini.rajendran@microchip.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Marc Zyngier" <maz@kernel.org>,
 "Rob Herring" <robh+dt@kernel.org>, krzysztof.kozlowski+dt@linaro.org,
 "Conor Dooley" <conor+dt@kernel.org>,
 "Nicolas Ferre" <nicolas.ferre@microchip.com>,
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
 mihai.sain@microchip.com, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
Subject: Re: [PATCH 15/21] dt-bindings: irqchip/atmel-aic5: Add support for sam9x7 aic
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 3, 2023, at 23:23, Conor Dooley wrote:
> On Sat, Jun 03, 2023 at 10:19:50PM +0100, Conor Dooley wrote:
>> Hey Varshini,
>> 
>> On Sun, Jun 04, 2023 at 01:32:37AM +0530, Varshini Rajendran wrote:
>> > Document the support added for the Advanced interrupt controller(AIC)
>> > chip in the sam9x7 soc family
>> 
>> Please do not add new family based compatibles, but rather use per-soc
>> compatibles instead.
>
> These things leave me penally confused. Afaiu, sam9x60 is a particular
> SoC. sam9x7 is actually a family, containing sam9x70, sam9x72 and
> sam9x75. It would appear to me that each should have its own compatible,
> no?

I think the usual way this works is that the sam9x7 refers to the
SoC design as in what is actually part of the chip, whereas the 70,
72 and 75 models are variants that have a certain subset of the
features enabled.

If that is the case here, then referring to the on-chip parts by
the sam9x7 name makes sense, and this is similar to what we do
on TI AM-series chips.

There is a remaining risk that a there would be a future
sam9x71/73/74/76/... product based on a new chip that uses
incompatible devices, but at that point we can still use the
more specific model number to identify those without being
ambiguous. The same thing can of course happen when a SoC
vendor reuses a specific name of a prior product with an update
chip that has software visible changes.

I'd just leave this up to Varshini and the other at91 maintainers
here, provided they understand the exact risks.

It's different for the parts that are listed as just sam9x60
compatible in the DT, I think those clearly need to have sam9x7
in the compatible list, but could have the sam9x60 identifier
as a fallback if the hardware is compatible.

     Arnd

