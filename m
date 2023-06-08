Return-Path: <netdev+bounces-9105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F0F727453
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E47A2815AC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6530B7F6;
	Thu,  8 Jun 2023 01:30:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F16A4A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:30:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EE811A;
	Wed,  7 Jun 2023 18:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=JkoPEkLt7D0jJJFRvQ8ngWGLv9aFq/+g4HClM8jXfIo=; b=rxleVb1u5ggqns0tfkC6UgE1mZ
	F93YF3gXnbZtzkxyEW8DWzD0sK710eRZjavX0QK+mVJE89Glb03edW96tprFSRqbrCHS2yWLjeF7f
	jT8TkjoZbCey4WEXLhdyeS2f1mMuPGcExWSoGkZX8EvTKrY5ZZh3XBRqxMRTu9pBtaNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q74UC-00FCeo-4Y; Thu, 08 Jun 2023 03:30:48 +0200
Date: Thu, 8 Jun 2023 03:30:48 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	"linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: NPD in phy_led_set_brightness+0x3c
Message-ID: <5558742d-232b-4417-9bea-6369434f8983@lunn.ch>
References: <9e6da1b3-3749-90e9-6a6a-4775463f5942@gmail.com>
 <c8fb4ca8-f6ef-461c-975b-09a15a43e408@lunn.ch>
 <11182cf6-eb35-273e-da17-6ca901ac06d3@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11182cf6-eb35-273e-da17-6ca901ac06d3@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> (gdb) print /x (int)&((struct phy_driver *)0)->led_brightness_set
> $1 = 0x1f0
> 
> so this would indeed look like an use-after-free here. If you tested with a
> PHYLINK enabled driver you might have no seen due to
> phylink_disconnect_phy() being called with RTNL held?

Yes, i've been testing with mvneta, which is phylink.

     Andrew

