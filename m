Return-Path: <netdev+bounces-3694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE26708586
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6117B1C2112E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9519021CC3;
	Thu, 18 May 2023 16:03:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A55721092
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:03:06 +0000 (UTC)
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888AAE0;
	Thu, 18 May 2023 09:03:04 -0700 (PDT)
Received: from [127.0.0.1] (nyx.walle.cc [158.255.213.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.3ffe.de (Postfix) with ESMTPSA id CEC81134D;
	Thu, 18 May 2023 18:03:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
	t=1684425781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvG8wUHeD8f5boEoH8cd19lDZyzlLDtuQeO0DFjRyjU=;
	b=wihb0PNFphom+iZAAubXNjbDyXpEWL4kUUySWOp4yef3wM2ajOMknGWd/8GGMXwbPYNQY2
	UdS8EFtT2vXIB1lNQLnw0gDKPMuI2zSd1Tc4KByxu7EYGZ2/GEexpZ+iZSYnSCNCrFJ0xD
	nSBfYEn4dTbMEz34arJcvG6SqRh27pA2F37I46zZ+n/Yq6x5bbwRsV95Dg+3nebP8zvfxH
	nPAj9RsARLWa96wktQRdgb21F0cN+0Eyt7AWjPMh0E2uApIwSBoqzFRawZ/2nzN7vzVe6O
	Bz87EbFg64WPp/DRJyF3UkYjdCRrPIqTKKHRbbwzbo7VZyF9lJHmuTWMUtBdrQ==
Date: Thu, 18 May 2023 18:02:57 +0200
From: Michael Walle <michael@walle.cc>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
 Jiawen Wu <jiawenwu@trustnetic.com>
CC: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
 jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
 mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
 linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
User-Agent: K-9 Mail for Android
In-Reply-To: <CAHp75VfuB5dHp1U+G2OFpupMnbBJv=aHRWaBHemtPU-xOZA_3g@mail.gmail.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook> <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com> <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch> <025b01d9897e$d8894660$899bd320$@trustnetic.com> <CAHp75VfuB5dHp1U+G2OFpupMnbBJv=aHRWaBHemtPU-xOZA_3g@mail.gmail.com>
Message-ID: <E27AF534-C281-4247-8A9B-FA06C8F30AB1@walle.cc>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,=20

I'm currently (and for the next three weeks) on vacation=2E Sorry in advan=
ced if the format of the mail is wrong or similar=2E I just have access to =
my mobile=2E=20

Am 18=2E Mai 2023 14:27:00 MESZ schrieb Andy Shevchenko <andy=2Eshevchenko=
@gmail=2Ecom>:
>On Thu, May 18, 2023 at 2:50=E2=80=AFPM Jiawen Wu <jiawenwu@trustnetic=2E=
com> wrote:
>> On Wednesday, May 17, 2023 11:01 PM, Andrew Lunn wrote:
>> > On Wed, May 17, 2023 at 10:55:01AM +0800, Jiawen Wu wrote:
>
>=2E=2E=2E
>
>> > > I should provide gpio_regmap_config=2Eirq_domain if I want to add t=
he gpio_irq_chip=2E
>> > > But in this use, GPIO IRQs are requested by SFP driver=2E How can I=
 get irq_domain
>> > > before SFP probe? And where do I add IRQ parent handler?
>> >
>> > I _think_ you are mixing upstream IRQs and downstream IRQs=2E
>> >
>> > Interrupts are arranged in trees=2E The CPU itself only has one or tw=
o
>> > interrupts=2E e=2Eg=2E for ARM you have FIQ and IRQ=2E When the CPU g=
ets an
>> > interrupt, you look in the interrupt controller to see what external
>> > or internal interrupt triggered the CPU interrupt=2E And that interru=
pt
>> > controller might indicate the interrupt came from another interrupt
>> > controller=2E Hence the tree structure=2E And each node in the tree i=
s
>> > considered an interrupt domain=2E
>> >
>> > A GPIO controller can also be an interrupt controller=2E It has an
>> > upstream interrupt, going to the controller above it=2E And it has
>> > downstream interrupts, the GPIO lines coming into it which can cause
>> > an interrupt=2E And the GPIO interrupt controller is a domain=2E
>> >
>> > So what exactly does gpio_regmap_config=2Eirq_domain mean? Is it the
>> > domain of the upstream interrupt controller? Is it an empty domain
>> > structure to be used by the GPIO interrupt controller? It is very
>> > unlikely to have anything to do with the SFP devices below it=2E
>>
>> Sorry, since I don't know much about interrupt,  it is difficult to und=
erstand
>> regmap-irq in a short time=2E There are many questions about regmap-irq=
=2E
>
>That's why I Cc'ed to Michael who is the author of gpio-regmap to
>probably get advice from=2E

All gpio remap is doing is forwarding the IRQ domain from regmap-irq to th=
e gpio subsystem=2E It's opaque to gpio-regmap and outside the scope of gpi=
o-regmap=2E=20

-michael

>> When I want to add an IRQ chip for regmap, for the further irq_domain,
>> I need to pass a parameter of IRQ, and this IRQ will be requested with =
handler:
>> regmap_irq_thread()=2E Which IRQ does it mean? In the previous code of =
using
>> devm_gpiochip_add_data(), I set the MSI-X interrupt as gpio-irq's paren=
t, but
>> it was used to set chained handler only=2E Should the parent be this IR=
Q? I found
>> the error with irq_free_descs and irq_domain_remove when I remove txgbe=
=2Eko=2E
>>
>> As you said, the interrupt of each tree node has its domain=2E Can I un=
derstand
>> that there are two layer in the interrupt tree for MSI-X and GPIOs, and=
 requesting
>> them separately is not conflicting? Although I thought so, but after I =
implement
>> gpio-regmap, SFP driver even could not find gpio_desc=2E Maybe I missed=
 something
>> on registering gpio-regmap=2E=2E=2E
>>
>> Anyway it is a bit complicated, could I use this version of GPIO implem=
entation if
>> it's really tough?
>
>It's possible but from GPIO subsystem point of view it's discouraged
>as long as there is no technical impediment to go the regmap way=2E



