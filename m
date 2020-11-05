Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296362A7C7D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgKEK6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEK6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:58:51 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A930C0613CF;
        Thu,  5 Nov 2020 02:58:51 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a15so1069631edy.1;
        Thu, 05 Nov 2020 02:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VgVqbVlPdC7trmxMyYQKlzpgDE2dM31LZq1Ldt00j4s=;
        b=AzL5wa0QrxD40fyLbdDLijiQ9RrKtGeUXtLOwrRn5rSTck8Od1TqIg50IZZjbD3dPa
         QmNGXo+8ljGJi64q1nQ8FeLacNhrbc7beSpc3JWa2Ur4Cjo2Zlfh14M9A8qEuzcNpbsX
         TNIag4xSC3MRAAvmY7ZYEprj5V8DCOzulb0ws2T+fX+XC20eSbFWM7Pie9WoF3iRQrYw
         xBaU4YBLg5alhJDF8rt9IMEsPOsKB2r3RX4VGwna2jKTiHLb/JdMkEIptBbchvyh/GLx
         2Ng+eGBa0a4WA8Mi0cI7CKBulU5ki1wN7SFFG0ytMWTQ+KbB0EgCVpKmVFtCIfHMISRQ
         ejlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VgVqbVlPdC7trmxMyYQKlzpgDE2dM31LZq1Ldt00j4s=;
        b=I96fJvQovgaDQQklSxsdEjvVenPNpcbEexxIg4LY3uJZyOIJd7bhodE2dj9C+1aHwn
         D3i9Y2Lpt6j0FJ2qYLKsR4butDx3eoVu0E8hqX+rXX8pcrNZvY5F1M8OYBn9WYlNp5Ag
         oGOywIWlWORD2z7sazv5SUMYUn7ppnEjT6AZqR5WRfCn42Y6zASchUsn/ppFtqJLC3Dc
         Lt/UJgZs969uW3v103AiPxKlc6jfoCCYFNesEUnOjhC1QnkYV5EabZ5TZoL0ucJZXC+A
         qBKnkj51HTb/rYO3PjCrS+ZJ/QVohhAGK5BaV2wFDVNWYh0eU1i6I1eCJPIKYppovINt
         rriQ==
X-Gm-Message-State: AOAM530lk4G9tsbxRwyFj84LCGVjdafYCb/4IpHh/K2br2tc/m93hvkA
        OSTaZgtUvAt/5A8FuaaWGCQ=
X-Google-Smtp-Source: ABdhPJwQCHp1lJyBBkAvC7tLk4P4lDyEtO0yV+VMjC/tt3XgdSwabBcAMz6X1dNyHDPufWw5+hoHFA==
X-Received: by 2002:a05:6402:142c:: with SMTP id c12mr1981116edx.41.1604573929776;
        Thu, 05 Nov 2020 02:58:49 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id g20sm754322ejz.88.2020.11.05.02.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:58:49 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 5 Nov 2020 12:58:48 +0200
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 8/9] staging: dpaa2-switch: properly setup switching domains
Message-ID: <20201105105848.tt3gktuxkq36nt57@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-9-ciorneiioana@gmail.com>
 <20201104220810.a5n24vh45hsvv646@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104220810.a5n24vh45hsvv646@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:08:10AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 04, 2020 at 06:57:19PM +0200, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > Until now, the DPAA2 switch was not capable to properly setup it's
> > switching domains depending on the existence, or lack thereof, of a
> > upper bridge device. This meant that all switch ports of a DPSW object
> > were switching by default even though they were not under the same
> > bridge device.
> > 
> > Another issue was the inability to actually add the CPU in the flooding
> > domains (broadcast, unknown unicast etc) of a particular switch port.
> > This meant that a simple ping on a switch interface was not possible
> > since no broadcast ARP frame would actually reach the CPU queues.
> > 
> > This patch tries to fix exactly these problems by:
> > 
> > * Creating and managing a FDB table for each flooding domain. This means
> >   that when a switch interface is not bridged it will use it's own FDB
> >   table. While in bridged mode all DPAA2 switch interfaces under the
> >   same upper will use the same FDB table, thus leverage the same FDB
> >   entries.
> > 
> > * Adding a new MC firmware command - dpsw_set_egress_flood() - through
> >   which the driver can setup the flooding domains as needed. For
> >   example, when the switch interface is standalone, thus not in a
> >   bridge with any other DPAA2 switch port, it will setup it's broadcast
> >   and unknown unicast flooding domains to only include the control
> >   interface (the queues that reach the CPU and the driver can dequeue
> >   from). This flooding domain changes when the interface joins a bridge
> >   and is configured to include, beside the control interface, all other
> >   DPAA2 switch interfaces.
> > 
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> 
> None of the occurrences of "it's" in the commit message is grammatically
> correct. So please s/it's/its/g.
> 
> > diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> > index 24bdac6d6005..7a0d9a178cdc 100644
> > --- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> > +++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
> > @@ -25,6 +25,36 @@
> >  
> >  #define DEFAULT_VLAN_ID			1
> >  
> > +static u16 dpaa2_switch_port_get_fdb_id(struct ethsw_port_priv *port_priv)
> > +{
> > +	struct ethsw_port_priv *other_port_priv = NULL;
> > +	struct net_device *other_dev;
> > +	struct list_head *iter;
> > +
> > +	/* If not part of a bridge, just use the private FDB */
> > +	if (!port_priv->bridge_dev)
> > +		return port_priv->fdb_id;
> > +
> > +	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
> > +	 * to be present in that bridge
> > +	 */
> > +	netdev_for_each_lower_dev(port_priv->bridge_dev, other_dev, iter) {
> 
> netdev_for_each_lower_dev calls netdev_lower_get_next which has this in
> the comments:
> 
>  * The caller must hold RTNL lock or
>  * its own locking that guarantees that the neighbour lower
>  * list will remain unchanged.
> 
> Does that hold true for all callers, if you put ASSERT_RTNL() here?

No, not for all. The probe path uses this as well and is not protected
by the rtnl lock.

Good point, I'll add an explicit lock/unlock. Thanks.

> 
> > +		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
> > +			continue;
> > +
> > +		other_port_priv = netdev_priv(other_dev);
> > +		break;
> > +	}
> > +
> > +	/* We are the first dpaa2 switch interface to join the bridge, just use
> > +	 * our own FDB
> > +	 */
> > +	if (!other_port_priv)
> > +		other_port_priv = port_priv;
> > +
> > +	return other_port_priv->fdb_id;
> > +}
> > +
> >  static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
> >  				dma_addr_t iova_addr)
> >  {
> > @@ -133,7 +163,7 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
> >  {
> >  	struct ethsw_core *ethsw = port_priv->ethsw_data;
> >  	struct net_device *netdev = port_priv->netdev;
> > -	struct dpsw_vlan_if_cfg vcfg;
> > +	struct dpsw_vlan_if_cfg vcfg = {0};
> >  	int err;
> >  
> >  	if (port_priv->vlans[vid]) {
> > @@ -141,8 +171,13 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
> >  		return -EEXIST;
> >  	}
> >  
> > +	/* If hit, this VLAN rule will lead the packet into the FDB table
> > +	 * specified in the vlan configuration below
> > +	 */
> 
> And this is the reason why VLAN-unaware mode is unsupported, right?

Yes, exactly.

> No
> hit on any VLAN rule => no FDB table selected for the packet. What is
> the default action for misses on VLAN rules? Drop or some default FDB
> ID?

The default action for misses on the VLAN table is drop. For example, if
a VLAN tagged packet is received on a switch interface which does not
have an upper VLAN interface with that VLAN id (thus the
.ndo_vlan_rx_add_vid() is not called) , the packet will get dropped
immediately.

> 
> >  	vcfg.num_ifs = 1;
> >  	vcfg.if_id[0] = port_priv->idx;
> > +	vcfg.fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
> > +	vcfg.options |= DPSW_VLAN_ADD_IF_OPT_FDB_ID;
> >  	err = dpsw_vlan_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle, vid, &vcfg);
> >  	if (err) {
> >  		netdev_err(netdev, "dpsw_vlan_add_if err %d\n", err);
> > @@ -172,8 +207,10 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
> >  	return 0;
> >  }
> >  
> > -static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
> > +static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, bool enable)
> 
> The commit message says nothing about changes to the learning
> configuration.

The learning flag is per FDB table, thus it's configuration now has to
take into account the corresponding FDB of an interface.

Actually, being able to configure the learning flag is somewhat of an
inconvenience since this would also change the learning behavior of all
the other switch ports under the same bridge, all this without the
bridge actually learning of this change.

I think I will just remove the code that handles changing the learning
status at the moment, until I can make changes in the MC firmware so
that this flag is indeed per port.

> 
> >  {
> > +	u16 fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
> > +	struct ethsw_core *ethsw = port_priv->ethsw_data;
> >  	enum dpsw_fdb_learning_mode learn_mode;
> >  	int err;
> >  
> > @@ -182,13 +219,12 @@ static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
> >  	else
> >  		learn_mode = DPSW_FDB_LEARNING_MODE_DIS;
> >  
> > -	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
> > +	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, fdb_id,
> >  					 learn_mode);
> >  	if (err) {
> >  		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);
> >  		return err;
> >  	}
> > -	ethsw->learning = enable;
> >  
> >  	return 0;
> >  }
> > @@ -267,15 +303,17 @@ static int dpaa2_switch_port_fdb_add_uc(struct ethsw_port_priv *port_priv,
> >  					const unsigned char *addr)
> >  {
> >  	struct dpsw_fdb_unicast_cfg entry = {0};
> > +	u16 fdb_id;
> >  	int err;
> >  
> >  	entry.if_egress = port_priv->idx;
> >  	entry.type = DPSW_FDB_ENTRY_STATIC;
> >  	ether_addr_copy(entry.mac_addr, addr);
> >  
> > +	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
> >  	err = dpsw_fdb_add_unicast(port_priv->ethsw_data->mc_io, 0,
> >  				   port_priv->ethsw_data->dpsw_handle,
> > -				   0, &entry);
> > +				   fdb_id, &entry);
> 
> Hmmm, so in dpaa2_switch_port_get_fdb_id you say:
> 
> 	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
> 	 * to be present in that bridge
> 	 */
> 
> So let's say there is a br0 with swp3 and swp2, and a br1 with swp4.
> IIUC, br0 interfaces (swp3 and swp2) will have an fdb_id of 3 (due to
> swp3 being added first) and br1 will have an fdb_id of 4 (due to swp4).
> 
> When swp3 leaves br0, will this cause the fdb_id of swp2 to change?
> I expect the answer is yes, since otherwise swp2 and swp3 would keep
> forwarding packets to one another. Is this change graceful?
> 

Yes, the fdb_id of swp2 will change but, as the code is now, it will
only change for new FDB static entries added or any new VLANs
installed.

> For example, if you add a static FDB entry to swp2 prior to removing
> swp3, I would expect the fdb_id of swp2 to preserve that static FDB
> entry, even if swp2 now gets moved to a different fdb_id. Similarly,
> flooding settings, everything is preserved when the fdb_id changes?
> 

No, moving static FDB entries on a bridge leave/join does not happen
now.

> The flip side of that is: what happens if you add an FDB entry to swp2,
> then you remove swp2 from br0 and move it to br1? Will swp4 (which was
> already in br1) see that static FDB entry in hardware, even if the
> software bridge br1 hasn't notified you about it?
> 

As you said, moving any FDB entry from one FDB table to another one
would be a problem since the software bridge br1 would not be notified
of any of these new entries.

Taking all the above into account, what I think the code should do if
swp2, for example, leaves a bridge is to:
 - update all VLAN entries installed for swp2 so that on a hit it would
   lead the packet into the new FDB table.
 - all static FDB entries already installed on swp2 should be removed
   from the FDB table corresponding to the previous bridge that the port
   was under.

> Basically, my question boils down to: why is there so little activity in
> dpaa2_switch_port_bridge_leave.
> 
> >  	if (err)
> >  		netdev_err(port_priv->netdev,
> >  			   "dpsw_fdb_add_unicast err %d\n", err);
