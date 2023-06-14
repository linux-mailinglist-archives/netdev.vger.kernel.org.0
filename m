Return-Path: <netdev+bounces-10847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7200473088D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472E01C20D74
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416C111CA6;
	Wed, 14 Jun 2023 19:42:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3246ADF4E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:42:03 +0000 (UTC)
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8919C1B2;
	Wed, 14 Jun 2023 12:42:01 -0700 (PDT)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-33e53672aa6so39312895ab.1;
        Wed, 14 Jun 2023 12:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686771721; x=1689363721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoR5QtDrDerfHXoKGe2GEzME6z543uT6MUP8iRSfPcM=;
        b=VqfTKZwrF8yUIuiQkvqaT/Xyn/0ar6lo4zdKm7vXL6j2a6xcFZhzCcBU6xintDegCf
         MYMBvfpKjKQkCIAYOHtBS3hwS4JHB2Ov7sOr80ImRFfu15/d6EBJqnrYs79+/BCEmVG1
         7jG9VHMTGiII7qdKNN1MgT9Pds9bDAwUgpgSFa3+08La6Q+ZiJuLOUKHgbylY7uMUk/Q
         QUXrBpJ337EZ2YfFXsXV5yhfQQscwDoKisxJQRb46WMYVS9nStLCD87MLU665mh15QbX
         mIex75KjZqWn42F3MN945v3z/+FRmCbaZ4SW8XdZcRQxWNvMmgSToRtDedXEjPxVq4hl
         Aqrg==
X-Gm-Message-State: AC+VfDz8UFL0nK2/PjQZxXAQvsWcVxeGaXyLQ02avqtt4VqWO8ozxM2x
	b5kU2DBPoshAioZqm6AAfg==
X-Google-Smtp-Source: ACHHUZ7fLbAPBebjBVM1Qjy7KigC+9HERpITyxqAjj85fhFE7tI69JqQbf2H70N0bNnPi4eYV/A+qQ==
X-Received: by 2002:a92:db0f:0:b0:329:bba2:781a with SMTP id b15-20020a92db0f000000b00329bba2781amr16482600iln.0.1686771720705;
        Wed, 14 Jun 2023 12:42:00 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id m10-20020a924b0a000000b0033355fa5440sm5657425ilg.37.2023.06.14.12.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 12:41:59 -0700 (PDT)
Received: (nullmailer pid 2619391 invoked by uid 1000);
	Wed, 14 Jun 2023 19:41:56 -0000
Date: Wed, 14 Jun 2023 13:41:56 -0600
From: Rob Herring <robh@kernel.org>
To: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Conor Dooley <conor@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Varshini Rajendran <varshini.rajendran@microchip.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Marc Zyngier <maz@kernel.org>, krzysztof.kozlowski+dt@linaro.org, 
	Conor Dooley <conor+dt@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Claudiu Beznea <claudiu.beznea@microchip.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russell King <linux@armlinux.org.uk>, 
	Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Gregory Clement <gregory.clement@bootlin.com>, Sudeep Holla <sudeep.holla@arm.com>, 
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>, mihai.sain@microchip.com, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Netdev <netdev@vger.kernel.org>, 
	linux-usb@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-pm@vger.kernel.org, Hari.PrasathGE@microchip.com, 
	cristian.birsan@microchip.com, durai.manickamkr@microchip.com, 
	manikandan.m@microchip.com, dharma.b@microchip.com, 
	nayabbasha.sayed@microchip.com, balakrishnan.s@microchip.com
Subject: Re: [PATCH 15/21] dt-bindings: irqchip/atmel-aic5: Add support for
 sam9x7 aic
Message-ID: <20230614194156.GA2618101-robh@kernel.org>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-16-varshini.rajendran@microchip.com>
 <20230603-fervor-kilowatt-662c84b94853@spud>
 <20230603-sanded-blunderer-73cdd7c290c1@spud>
 <4d3694b3-8728-42c1-8497-ae38134db37c@app.fastmail.com>
 <20230604-cohesive-unmoving-032da3272620@spud>
 <add5e49e-8416-ba9f-819a-da944938c05f@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <add5e49e-8416-ba9f-819a-da944938c05f@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:37:16PM +0200, Nicolas Ferre wrote:
> Arnd, Conor,
> 
> On 04/06/2023 at 23:08, Conor Dooley wrote:
> > On Sun, Jun 04, 2023 at 11:49:48AM +0200, Arnd Bergmann wrote:
> > > On Sat, Jun 3, 2023, at 23:23, Conor Dooley wrote:
> > > > On Sat, Jun 03, 2023 at 10:19:50PM +0100, Conor Dooley wrote:
> > > > > Hey Varshini,
> > > > > 
> > > > > On Sun, Jun 04, 2023 at 01:32:37AM +0530, Varshini Rajendran wrote:
> > > > > > Document the support added for the Advanced interrupt controller(AIC)
> > > > > > chip in the sam9x7 soc family
> > > > > Please do not add new family based compatibles, but rather use per-soc
> > > > > compatibles instead.
> > > > These things leave me penally confused. Afaiu, sam9x60 is a particular
> > s/penally/perennially/
> > 
> > > > SoC. sam9x7 is actually a family, containing sam9x70, sam9x72 and
> > > > sam9x75. It would appear to me that each should have its own compatible,
> > > > no?
> > > I think the usual way this works is that the sam9x7 refers to the
> > > SoC design as in what is actually part of the chip, whereas the 70,
> > > 72 and 75 models are variants that have a certain subset of the
> > > features enabled.
> 
> Yes, That's the case.
> > > If that is the case here, then referring to the on-chip parts by
> > > the sam9x7 name makes sense, and this is similar to what we do
> > > on TI AM-series chips.
> 
> This is what we did for most of our SoCs families, indeed.
> 
> > If it is the case that what differentiates them is having bits chopped
> > off, and there's no implementation differences that seems fair.
> 
> Ok, thanks.
> 
> > > There is a remaining risk that a there would be a future
> > > sam9x71/73/74/76/... product based on a new chip that uses
> > > incompatible devices, but at that point we can still use the
> > > more specific model number to identify those without being
> > > ambiguous.
> 
> This is exactly what we did for sama5d29 which is not the same silicon vs.
> the other members of the sama5d2 family. We used the more specify sama5d29
> sub-string for describing the changing parts (CAN-FD and Ethernet).
> 
> > > The same thing can of course happen when a SoC
> > > vendor reuses a specific name of a prior product with an update
> > > chip that has software visible changes.
> > > 
> > > I'd just leave this up to Varshini and the other at91 maintainers
> > > here, provided they understand the exact risks.
> 
> Yep, I understand the risk and will try to review the compatibility strings
> that would need more precise description (maybe PMC or AIC).
> 
> > Ye, seems fair to me. Nicolas/Claudiu etc, is there a convention to use
> > the "0" model as the compatible (like the 9x60 did) or have "random"
> > things been done so far?
> 
> sam9x60 was a single SoC, not a member of a "family", so there was no
> meaning of the "0" here. Moreover, the "0" ones are usually not the subset,
> if it even exists.
> So far, we used the silicon string to define the compatibility string,
> adding a more precise string for hardware of family members that needed it
> (as mentioned above for sama5d29).
> 
> > > It's different for the parts that are listed as just sam9x60
> > > compatible in the DT, I think those clearly need to have sam9x7
> > > in the compatible list, but could have the sam9x60 identifier
> > > as a fallback if the hardware is compatible.
> > Aye.
> 
> Yep, agreed.

Can we convert this binding to schema so all this is perfectly clear 
what's valid or not.

Rob

