Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25495324874
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhBYBVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:21:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhBYBVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:21:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5KF-008KWl-0H; Thu, 25 Feb 2021 02:20:19 +0100
Date:   Thu, 25 Feb 2021 02:20:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 07/12] Documentation: networking: dsa:
 mention integration with devlink
Message-ID: <YDb7Un3v5jvo/aZ2@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-8-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:33:50PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the devlink features supported by the DSA core.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index 3c6560a43ae0..463b48714fe9 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -394,6 +394,7 @@ DSA currently leverages the following subsystems:
>  - MDIO/PHY library: ``drivers/net/phy/phy.c``, ``mdio_bus.c``
>  - Switchdev:``net/switchdev/*``
>  - Device Tree for various of_* functions
> +- Devlink: ``net/core/devlink.c``
>  
>  MDIO/PHY library
>  ----------------
> @@ -433,6 +434,32 @@ more specifically with its VLAN filtering portion when configuring VLANs on top
>  of per-port slave network devices. As of today, the only SWITCHDEV objects
>  supported by DSA are the FDB and VLAN objects.
>  
> +Devlink
> +-------
> +
> +DSA registers one devlink device per each physical switch in the fabric.

"per each" sounds wrong to my ears. per on its own is better.

> +For each devlink device, every physical port (i.e. user ports, CPU ports, DSA
> +links and unused ports) is exposed as a devlink port.

I would probably use "or", instead of "and". 

> +
> +DSA drivers can make use of the following devlink features:
> +- Regions: debugging feature which allows user space to dump driver-defined
> +  areas of hardware information in a low-level, binary format. Both global
> +  regions as well as per-port regions are supported. Since address tables and
> +  VLAN tables are only inspectable by core iproute2 tools (ip-link, bridge) on
> +  user ports, devlink regions can be created for dumping these tables on the
> +  non-user ports too.

You might also add that additional details which don't fit the
iproute2 model can be included in regions dumps, since the format is
not restricted.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

