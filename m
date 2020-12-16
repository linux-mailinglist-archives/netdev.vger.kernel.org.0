Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9D2DC34E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgLPPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:40:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgLPPkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 10:40:37 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpYuA-00CJEL-6Y; Wed, 16 Dec 2020 16:39:54 +0100
Date:   Wed, 16 Dec 2020 16:39:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 5/7] net: dsa: exit early in
 dsa_slave_switchdev_event if we can't program the FDB
Message-ID: <20201216153954.GD2901580@lunn.ch>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
 <20201213140710.1198050-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213140710.1198050-6-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 04:07:08PM +0200, Vladimir Oltean wrote:
> Right now, the following would happen for a switch driver that does not
> implement .port_fdb_add or .port_fdb_del.
> 
> dsa_slave_switchdev_event returns NOTIFY_OK and schedules:
> -> dsa_slave_switchdev_event_work
>    -> dsa_port_fdb_add
>       -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
>          -> dsa_switch_fdb_add
>             -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
>    -> an error is printed with dev_dbg, and
>       dsa_fdb_offload_notify(switchdev_work) is not called.
> 
> We can avoid scheduling the worker for nothing and say NOTIFY_DONE.
> Because we don't call dsa_fdb_offload_notify, the static FDB entry will
> remain just in the software bridge.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
