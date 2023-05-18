Return-Path: <netdev+bounces-3625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770657081F3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F3D5281904
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE6923C77;
	Thu, 18 May 2023 12:58:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2042D23C67
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:58:13 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6CA170B;
	Thu, 18 May 2023 05:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ornDW2gcGC07DEWBDSLBzCZabH8SWvpEcRaK0EXRMog=; b=Yu2Xq+9dmo4vRz9ArK8Y0aKvaL
	kOjDPbXmtzz22cUPYu7iZ5LyX7KhUNjJcBTnBkt442tUyL0NNDA+q2nV65MmrEm81gT2gJ8WwoXKO
	hck1QEukCZESBxrVzW16DLk+8Bdwiy0AcZEq9OElCrqRMXXeOyS8iZXQXqc8O5o1YpxA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzdCi-00DEDS-Ix; Thu, 18 May 2023 14:58:00 +0200
Date: Thu, 18 May 2023 14:58:00 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
 <20230517203430.448705-3-alexis.lothore@bootlin.com>
 <9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
 <ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> >> +	[MV88E6361] = {
> >> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
> >> +		.family = MV88E6XXX_FAMILY_6393,
> >> +		.name = "Marvell 88E6361",
> >> +		.num_databases = 4096,
> >> +		.num_macs = 16384,
> >> +		.num_ports = 11,
> >> +		/* Ports 1, 2 and 8 are not routed */
> >> +		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
> >> +		.num_internal_phys = 5,
> > 
> > Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
> > mv88e6xxx_phy_is_internal() return for these ports, and
> > mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
> > need to list 8 here?
> 
> Indeed there is something wrong here too. I need to tune
> mv88e6393x_phylink_get_caps to reflect 88E6361 differences.
> 
> As stated above, port 3 to 7 are the ones with internal PHY.
> For mv88e6xxx_phy_is_internal, I see that it is merely comparing the port index
> to the number of internal phys, so in this case it would advertise (wrongly)
> that ports 0 to 4 have internal phys.

Ports 1 and 2 should hopefully be protected by the
invalid_port_mask. It should not even be possible to create those
ports. port 0 is interesting, and possibly currently broken on
6393. Please take a look at that.

    Andrew

---
pw-bot: cr

