Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DCF2B54FE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgKPXag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:30:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgKPXag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:30:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kenx5-007QmT-IU; Tue, 17 Nov 2020 00:30:27 +0100
Date:   Tue, 17 Nov 2020 00:30:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: am65-cpsw: enable
 broadcast/multicast rate limit support
Message-ID: <20201116233027.GC1756591@lunn.ch>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-4-grygorii.strashko@ti.com>
 <20201114191723.rvmhyrqinkhdjtpr@skbuf>
 <e9f2b153-d467-15fd-bd4a-601211601fca@ti.com>
 <20201116185919.qwaklquxhhhtqttg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116185919.qwaklquxhhhtqttg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Same as above, just in packets per second.
> 
> tc qdisc add dev eth0 clsact
> tc filter add dev eth0 ingress flower skip_sw \
> 	dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
> 	action police rate 20kpps

I agree with Vladimir here. Since the hardware does PPS limits, the TC
API should also be PPS limit based. And as you said, CPU load is more
a factor of PPS than BPS, so it is a useful feature in general to
have. You just need to implement the software version first, before
you offload it to the hardware.

    Andrew
