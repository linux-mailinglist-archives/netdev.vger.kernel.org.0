Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F272A7034
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbgKDWIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgKDWIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:08:14 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6CC0613D3;
        Wed,  4 Nov 2020 14:08:12 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so102973ejg.1;
        Wed, 04 Nov 2020 14:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PGCQWFW/RghIe5jdvxGrKg1Fw8ui76SHa6o56w9e5CE=;
        b=Xh8YX+7iNF5QjSHiV/SlxZal4xX8WXYggxAZQeyPJMR0CppMRIg1lSkdOduMrSefCf
         VoB7FTu41diSUgHFW251+FZVMZhDOPynmUkWOxjkqfyeZlOIIICOIp6E52gOd0tx2Sir
         Dmc7BV81dQtd/JeX6vdvaUJjqZrp08qF4B+vdYDtiZKdBCMubbjyWX0zyVkQasIqpv1X
         Buqz8Epc7XA/FENfDxATrSnhcPp3rlKyptcWAPeSTEe9x+E6pwDAR8bj8waCt4CTdqVE
         CQMMhblbZo+Ly+CoTckpQMgohrXUnIA0s2rJ3lqFyA3VYJ1RaJHHwYD9H7zKRn3yM5IE
         QtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PGCQWFW/RghIe5jdvxGrKg1Fw8ui76SHa6o56w9e5CE=;
        b=idz1tsRZmCDKY3o/upPiDV73ikFYLzNS2loAmpDUDjSDrJBDmnPhfKdeKDYMm5Bje1
         KlwFrqF6m5voDOeancc8dCZxex0N2A3tQxI92aFesnfRs/xclvtorPITU8k9SPBlxczq
         loONdskZ6dtMSppyRkg2iQivQOQ8/9bXyni10krsYEk9VvfHCIMQdkDWzG4nZD5QXdpD
         WeZ+CpJRgz5QVvmbKIVOT315eZ9tCRp9cwT6M0wfGPnNDoIsEHSKm1uMC1yQaUuqchrw
         twDALxZCI42vFsmYTpUXFJcSHKgFfcYCZxG0yfSj2tO+YZJS8vWsTY9pZ8gZ1ANGeljM
         oEDQ==
X-Gm-Message-State: AOAM530eVxp5sNGV509sOw3jnD01l88jMsA9e+LUWJcBzZKK6kLZ3Nss
        GanhGvjWSLzeLTHqkR/YxKY=
X-Google-Smtp-Source: ABdhPJwy+M22CJM4yfBDoN8FCYJlddyiHeb4NiPHfuVpeTE3mWBTbSklGQQ2CDsZIFtWVXx/nyXC9w==
X-Received: by 2002:a17:906:c114:: with SMTP id do20mr171434ejc.169.1604527691603;
        Wed, 04 Nov 2020 14:08:11 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id x2sm1563377ejb.86.2020.11.04.14.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 14:08:11 -0800 (PST)
Date:   Thu, 5 Nov 2020 00:08:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 8/9] staging: dpaa2-switch: properly setup switching domains
Message-ID: <20201104220810.a5n24vh45hsvv646@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-9-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104165720.2566399-9-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 06:57:19PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Until now, the DPAA2 switch was not capable to properly setup it's
> switching domains depending on the existence, or lack thereof, of a
> upper bridge device. This meant that all switch ports of a DPSW object
> were switching by default even though they were not under the same
> bridge device.
> 
> Another issue was the inability to actually add the CPU in the flooding
> domains (broadcast, unknown unicast etc) of a particular switch port.
> This meant that a simple ping on a switch interface was not possible
> since no broadcast ARP frame would actually reach the CPU queues.
> 
> This patch tries to fix exactly these problems by:
> 
> * Creating and managing a FDB table for each flooding domain. This means
>   that when a switch interface is not bridged it will use it's own FDB
>   table. While in bridged mode all DPAA2 switch interfaces under the
>   same upper will use the same FDB table, thus leverage the same FDB
>   entries.
> 
> * Adding a new MC firmware command - dpsw_set_egress_flood() - through
>   which the driver can setup the flooding domains as needed. For
>   example, when the switch interface is standalone, thus not in a
>   bridge with any other DPAA2 switch port, it will setup it's broadcast
>   and unknown unicast flooding domains to only include the control
>   interface (the queues that reach the CPU and the driver can dequeue
>   from). This flooding domain changes when the interface joins a bridge
>   and is configured to include, beside the control interface, all other
>   DPAA2 switch interfaces.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

None of the occurrences of "it's" in the commit message is grammatically
correct. So please s/it's/its/g.

> diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> index 24bdac6d6005..7a0d9a178cdc 100644
> --- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> +++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> @@ -25,6 +25,36 @@
>  
>  #define DEFAULT_VLAN_ID			1
>  
> +static u16 dpaa2_switch_port_get_fdb_id(struct ethsw_port_priv *port_priv)
> +{
> +	struct ethsw_port_priv *other_port_priv = NULL;
> +	struct net_device *other_dev;
> +	struct list_head *iter;
> +
> +	/* If not part of a bridge, just use the private FDB */
> +	if (!port_priv->bridge_dev)
> +		return port_priv->fdb_id;
> +
> +	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
> +	 * to be present in that bridge
> +	 */
> +	netdev_for_each_lower_dev(port_priv->bridge_dev, other_dev, iter) {

netdev_for_each_lower_dev calls netdev_lower_get_next which has this in
the comments:

 * The caller must hold RTNL lock or
 * its own locking that guarantees that the neighbour lower
 * list will remain unchanged.

Does that hold true for all callers, if you put ASSERT_RTNL() here?

> +		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
> +			continue;
> +
> +		other_port_priv = netdev_priv(other_dev);
> +		break;
> +	}
> +
> +	/* We are the first dpaa2 switch interface to join the bridge, just use
> +	 * our own FDB
> +	 */
> +	if (!other_port_priv)
> +		other_port_priv = port_priv;
> +
> +	return other_port_priv->fdb_id;
> +}
> +
>  static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
>  				dma_addr_t iova_addr)
>  {
> @@ -133,7 +163,7 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
>  {
>  	struct ethsw_core *ethsw = port_priv->ethsw_data;
>  	struct net_device *netdev = port_priv->netdev;
> -	struct dpsw_vlan_if_cfg vcfg;
> +	struct dpsw_vlan_if_cfg vcfg = {0};
>  	int err;
>  
>  	if (port_priv->vlans[vid]) {
> @@ -141,8 +171,13 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
>  		return -EEXIST;
>  	}
>  
> +	/* If hit, this VLAN rule will lead the packet into the FDB table
> +	 * specified in the vlan configuration below
> +	 */

And this is the reason why VLAN-unaware mode is unsupported, right? No
hit on any VLAN rule => no FDB table selected for the packet. What is
the default action for misses on VLAN rules? Drop or some default FDB
ID?

>  	vcfg.num_ifs = 1;
>  	vcfg.if_id[0] = port_priv->idx;
> +	vcfg.fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
> +	vcfg.options |= DPSW_VLAN_ADD_IF_OPT_FDB_ID;
>  	err = dpsw_vlan_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle, vid, &vcfg);
>  	if (err) {
>  		netdev_err(netdev, "dpsw_vlan_add_if err %d\n", err);
> @@ -172,8 +207,10 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
>  	return 0;
>  }
>  
> -static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
> +static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, bool enable)

The commit message says nothing about changes to the learning
configuration.

>  {
> +	u16 fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
> +	struct ethsw_core *ethsw = port_priv->ethsw_data;
>  	enum dpsw_fdb_learning_mode learn_mode;
>  	int err;
>  
> @@ -182,13 +219,12 @@ static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
>  	else
>  		learn_mode = DPSW_FDB_LEARNING_MODE_DIS;
>  
> -	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
> +	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, fdb_id,
>  					 learn_mode);
>  	if (err) {
>  		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);
>  		return err;
>  	}
> -	ethsw->learning = enable;
>  
>  	return 0;
>  }
> @@ -267,15 +303,17 @@ static int dpaa2_switch_port_fdb_add_uc(struct ethsw_port_priv *port_priv,
>  					const unsigned char *addr)
>  {
>  	struct dpsw_fdb_unicast_cfg entry = {0};
> +	u16 fdb_id;
>  	int err;
>  
>  	entry.if_egress = port_priv->idx;
>  	entry.type = DPSW_FDB_ENTRY_STATIC;
>  	ether_addr_copy(entry.mac_addr, addr);
>  
> +	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
>  	err = dpsw_fdb_add_unicast(port_priv->ethsw_data->mc_io, 0,
>  				   port_priv->ethsw_data->dpsw_handle,
> -				   0, &entry);
> +				   fdb_id, &entry);

Hmmm, so in dpaa2_switch_port_get_fdb_id you say:

	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
	 * to be present in that bridge
	 */

So let's say there is a br0 with swp3 and swp2, and a br1 with swp4.
IIUC, br0 interfaces (swp3 and swp2) will have an fdb_id of 3 (due to
swp3 being added first) and br1 will have an fdb_id of 4 (due to swp4).

When swp3 leaves br0, will this cause the fdb_id of swp2 to change?
I expect the answer is yes, since otherwise swp2 and swp3 would keep
forwarding packets to one another. Is this change graceful?

For example, if you add a static FDB entry to swp2 prior to removing
swp3, I would expect the fdb_id of swp2 to preserve that static FDB
entry, even if swp2 now gets moved to a different fdb_id. Similarly,
flooding settings, everything is preserved when the fdb_id changes?

The flip side of that is: what happens if you add an FDB entry to swp2,
then you remove swp2 from br0 and move it to br1? Will swp4 (which was
already in br1) see that static FDB entry in hardware, even if the
software bridge br1 hasn't notified you about it?

Basically, my question boils down to: why is there so little activity in
dpaa2_switch_port_bridge_leave.

>  	if (err)
>  		netdev_err(port_priv->netdev,
>  			   "dpsw_fdb_add_unicast err %d\n", err);
