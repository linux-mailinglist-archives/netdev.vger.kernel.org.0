Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7143450321
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhKOLJm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 06:09:42 -0500
Received: from mslow1.mail.gandi.net ([217.70.178.240]:50923 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhKOLJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 06:09:25 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id D14E6CFBD7;
        Mon, 15 Nov 2021 11:02:21 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id EF225FF809;
        Mon, 15 Nov 2021 11:01:52 +0000 (UTC)
Date:   Mon, 15 Nov 2021 11:58:05 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Message-ID: <20211115115805.434e71a8@fixe.home>
In-Reply-To: <20211115105144.le3a62a2wbkgp632@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-4-clement.leger@bootlin.com>
        <20211103123811.im5ua7kirogoltm7@skbuf>
        <20211103145351.793538c3@fixe.home>
        <20211115111344.03376026@fixe.home>
        <20211115105144.le3a62a2wbkgp632@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 15 Nov 2021 10:51:45 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> > I checked again my bandwith numbers (obtained with iperf3) with and
> > without the pre-computed header:
> > 
> > Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
> > - With pre-computed header: UDP TX: 	33Mbit/s
> > - Without UDP TX: 			31Mbit/s  
> > -> 6.5% improvement  
> > 
> > Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> > - With pre-computed header: UDP TX: 	15.8Mbit/s
> > - Without UDP TX: 			16.4Mbit/s  
> > -> 4.3% improvement  
> > 
> > The improvement might not be huge but also not negligible at all.
> > Please tell me if you want me to drop it or not based on those numbers.  
> 
> Is this with manual injection or with FDMA? Do you have before/after
> numbers with FDMA as well? At 31 vs 33 Mbps, this isn't going to compete
> for any races anyway :)

These numbers were for the FDMA, with the CPU, its even much lower
because more time is spent to push bytes through registers...
But agreed with that, this isn't going to beat any records !


-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
