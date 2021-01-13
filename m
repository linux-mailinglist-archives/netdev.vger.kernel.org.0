Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04AB2F5708
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbhAMXn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 18:43:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbhAMXmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:42:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzplY-000QoW-4F; Thu, 14 Jan 2021 00:41:28 +0100
Date:   Thu, 14 Jan 2021 00:41:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <X/+FKCRgkqOtoWbo@lunn.ch>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113154139.1803705-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In Time Sensitive Networking it is a common and simple use case to
> configure switches to give all traffic from an attached station the same
> priority, without requiring those stations to use VLAN PCP or IP DSCP to
> signal the priority that they want. Many pieces of hardware support this
> feature via a port-based default priority. We can model this in Linux
> through a matchall action on the ingress qdisc of the port, plus a
> skbedit priority action with the desired priority.

The mv88e6xxx has something similar. There is a bit to enable this
feature, as well as the priority the feature should have. I think that
then takes a value in the range of 0 to 4, but i could be remembering
it wrongly.

> +	int	(*port_priority_set)(struct dsa_switch *ds, int port,
> +				     struct dsa_mall_skbedit_tc_entry *skbedit);

The fact we can turn this on/off suggests there should be a way to
disable this in the hardware, when the matchall is removed. I don't
see any such remove support in this patch.

    Andrew
