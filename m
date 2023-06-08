Return-Path: <netdev+bounces-9304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EA3728620
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9B0228165C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F5719929;
	Thu,  8 Jun 2023 17:19:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8591182DA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:19:06 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0568E59;
	Thu,  8 Jun 2023 10:19:04 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686244743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb8J7HAweHUeUCbXpL89ISyPMCUFjIKfgJ5u0eOPeq8=;
	b=exYyQcF8h11MVW3n7QIALf02FHhka9poa2QfR4hWBuET4YMMyixZGxl0JIQgnUwoZmiPcY
	Zppm/5bxj6EIXNbCwyTTvvhgMMMAFWMGO1KkZUQ7iIMDups2RWs0jEplhpHhsMYekCx2gP
	/wsvNei7JDq69xB3U6KhqGJuZwaCm3jgcBfxKfExetSbrDXfu5BuTpTdsic4MOa2rLZGZR
	4fBMRicEtTO+dmjajjs3qkpWfbTdCRAqW4Ue/B3dCJEBBFs5cXX+yWR1SO9DuESwutWzC3
	/2P5HX+C6Il7xxfDLoF+smCzHT2q6xmMNROQAbP8rlUsfGoRtcD3esDvNpF3ag==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1DE4C1BF205;
	Thu,  8 Jun 2023 17:19:00 +0000 (UTC)
Date: Thu, 8 Jun 2023 19:54:23 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com, Andrew Lunn
 <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Heiner Kallweit
 <hkallweit1@gmail.com>, linux-arm-kernel@lists.infradead.org,
 Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
 UNGLinuxDriver@microchip.com, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: phylink: use a dedicated helper to parse
 usgmii control word
Message-ID: <20230608195423.0607959b@pc-7.home>
In-Reply-To: <ZIIC6mi2LtrD5P2m@shell.armlinux.org.uk>
References: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
	<20230608163415.511762-3-maxime.chevallier@bootlin.com>
	<ZIIC6mi2LtrD5P2m@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Russell,

On Thu, 8 Jun 2023 17:33:46 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Thu, Jun 08, 2023 at 06:34:14PM +0200, Maxime Chevallier wrote:
> > Q-USGMII is a derivative of USGMII, that uses a specific formatting for
> > the control word. The layout is close to the USXGMII control word, but
> > doesn't support speeds over 1Gbps. Use a dedicated decoding logic for
> > the USGMII control word, re-using USXGMII definitions with a custom mask
> > and only considering 10/100/1000 speeds  
> 
> Seems to be a duplicate patch?

Heh indeed, I fixed my commit title at the last minute and forgot to
cleanup my outgoing folder... Sorry about that

> Please see my comments on the other submission of this patch.
> 


