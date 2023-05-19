Return-Path: <netdev+bounces-3893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FC9709754
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DFEE1C21291
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99016134;
	Fri, 19 May 2023 12:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7233A7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE3C433EF;
	Fri, 19 May 2023 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684499931;
	bh=tuw/mKj0P6fjqCWthB3GTMhCdp5EZdmQ+EdF4Yb0yf0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PVU9nfoaNQpms40ciIXHs6s2YzKHm/o+vE9Qux9gyKAvKGN0rOxq3Aa6YkEkEMJbs
	 h3k6ALD71V8hYPkmNZH2h+KvRz2WmY1ft0bsBud/P3rudL7eYSSnxiAA8Nnlo1vvAH
	 vzaFChbcEez+EaFkSkdy4oYxrRr6Gi5rM+pzcyO4H54sMp3srERmnYj6bSHA1+I5/J
	 PBt9FNEILY1jnARUzqB2qBsXTkiS9NoXwzXY9Bw1TwkWeCZAR+1E4BT7efq7Fkshvn
	 njoksnTG+nuxS1zlEvjYZ5+/ARSk5gPDWIbYookCDhttaZu30KfZPjtfKo7GMsd4JR
	 2aPRbLx4E+xaA==
Date: Fri, 19 May 2023 14:38:36 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>, Florian
 Fainelli <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <20230519143713.1ac9c7a1@thinkpad>
In-Reply-To: <6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
	<20230517203430.448705-3-alexis.lothore@bootlin.com>
	<9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
	<ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
	<6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 14:58:00 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > >> +	[MV88E6361] = {
> > >> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
> > >> +		.family = MV88E6XXX_FAMILY_6393,
> > >> +		.name = "Marvell 88E6361",
> > >> +		.num_databases = 4096,
> > >> +		.num_macs = 16384,
> > >> +		.num_ports = 11,
> > >> +		/* Ports 1, 2 and 8 are not routed */
> > >> +		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
> > >> +		.num_internal_phys = 5,  
> > > 
> > > Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
> > > mv88e6xxx_phy_is_internal() return for these ports, and
> > > mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
> > > need to list 8 here?  
> > 
> > Indeed there is something wrong here too. I need to tune
> > mv88e6393x_phylink_get_caps to reflect 88E6361 differences.
> > 
> > As stated above, port 3 to 7 are the ones with internal PHY.
> > For mv88e6xxx_phy_is_internal, I see that it is merely comparing the port index
> > to the number of internal phys, so in this case it would advertise (wrongly)
> > that ports 0 to 4 have internal phys.  
> 
> Ports 1 and 2 should hopefully be protected by the
> invalid_port_mask. It should not even be possible to create those
> ports. port 0 is interesting, and possibly currently broken on
> 6393. Please take a look at that.

Why would port 0 be broken on 6393x ?

Marek

