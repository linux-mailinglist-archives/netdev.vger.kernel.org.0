Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286354922CD
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 10:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbiARJdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 04:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbiARJdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 04:33:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D63C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:33:14 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso1806132pjh.0
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0hYH159O/HIuVNisjkUC0VBlqEEUQ3+xZf44IO2qDDw=;
        b=WnRHXMIUP24vRSVkJHIX5hU2DuJQp82+r6Hbxvq1+d2jsUWosgBO54Xo/5xgAssQNC
         otUOqBhlgIwza3VDH4VtsWWckqOKtu/cwyvVRTp+rSYCnrcKehEv1EFkl1nz45xedJ7L
         kFn+O4uPtT0vFr3T4xDVJd3Dz7wwdcmsL3xy80Adc3t2dA1cbO4IlwD1zyfGsJ/i6Phe
         ixhe1AquY+S+5n9ALIBvzcRV2hNwTA+xDxcJOojXzQY+ZyXutbQfjdcvJf6mMzJC/7yI
         lMGiBB5v+CKqx+CSYCI25XWIN64XKp1vKLX17mq/+FgIkG3btTcjowsO94ze1KyPELuL
         yawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0hYH159O/HIuVNisjkUC0VBlqEEUQ3+xZf44IO2qDDw=;
        b=ZSZSnzdYGuNlrFC4nG5uJ/M0HCpguY2t3SYQdMAJyWu63rDlvDX2xahNPV5QvydWyt
         7Iqb8FDTQa7WC58zvoLLnARW3kwa+uBNo4c58ht5hATMiGs/KBBNtsw5gPMEwsa4hdPK
         414QXDTaGxVnUxOZYPFOArQjhpgr24nIAvHYyfy45Mgt4SsySHKfw/w364FjQ6NIp5Qb
         s9WMwULxaHgHNJf9M3eo8OTMXomWr5nXQOzI6moLUOkr+eHt3OpCnTBSSEsW1N8O9RRn
         LNH0RuN5ucwhVE59Rtj3mewXrNKc/YCVJZcqsj1IZUxrJlIXqeOrbbOFLIc+boLCUeq7
         OhqA==
X-Gm-Message-State: AOAM533+T8SWW4s4vTy2FMPDQ2R80+VVY5MELo9pFWZRPVJVfpzHcMDP
        1Is1l+xYp/ybPUMGT191t6WgxrubUKg=
X-Google-Smtp-Source: ABdhPJwBmGbjm27yBC3HumZcZpclIV7LZ2q2fiEzYcd6E2F5OZuCPEWp2IRwyX0nl8XfSwvHOqCOyg==
X-Received: by 2002:a17:902:bd05:b0:148:a2e8:2c3d with SMTP id p5-20020a170902bd0500b00148a2e82c3dmr26354154pls.140.1642498393476;
        Tue, 18 Jan 2022 01:33:13 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q12sm16961093pfk.136.2022.01.18.01.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 01:33:12 -0800 (PST)
Date:   Tue, 18 Jan 2022 17:33:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH draft] bonding: add IPv6 NS/NA monitor support
Message-ID: <YeaJUokxbWFm0dP9@Laptop-X1>
References: <20211124071854.1400032-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124071854.1400032-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I still want to get some feedback before post the format patch.

Appreciated for any comments.

Thanks
Hangbin
On Wed, Nov 24, 2021 at 03:18:53PM +0800, Hangbin Liu wrote:
> This patch add bond IPv6 NS/NA monitor support. A new option
> ns_ip6_target is added, which is similar with arp_ip_target.
> The IPv6 NS/NA monitor will take effect when there is a valid IPv6
> address. And ARP monitor will stop working.
> 
> A new field struct in6_addr ip6_addr is added to struct bond_opt_value
> for IPv6 support. Thus __bond_opt_init() is also updated to check
> string, addr first.
> 
> Function bond_handle_vlan() is split from bond_arp_send() for both
> IPv4/IPv6 usage.
> 
> To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
> are exported.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  Documentation/networking/bonding.rst |  11 ++
>  drivers/net/bonding/bond_main.c      | 260 ++++++++++++++++++++++++---
>  drivers/net/bonding/bond_netlink.c   |  48 +++++
>  drivers/net/bonding/bond_options.c   | 142 ++++++++++++++-
>  drivers/net/bonding/bond_sysfs.c     |  22 +++
>  include/net/bond_options.h           |  14 +-
>  include/net/bonding.h                |  36 ++++
>  include/net/ndisc.h                  |   9 +
>  include/uapi/linux/if_link.h         |   1 +
>  net/ipv6/ndisc.c                     |  48 +++--
>  tools/include/uapi/linux/if_link.h   |   1 +
>  11 files changed, 544 insertions(+), 48 deletions(-)
> 
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index dc28c9551b9b..ff4560c4feae 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -312,6 +312,17 @@ arp_ip_target
>  	maximum number of targets that can be specified is 16.  The
>  	default value is no IP addresses.
>  
> +ns_ip6_target
> +
> +	Specifies the IPv6 addresses to use as IPv6 monitoring peers when
> +	arp_interval is > 0.  These are the targets of the NS request
> +	sent to determine the health of the link to the targets.
> +	Specify these values in ffff:ffff::ffff:ffff format.  Multiple IPv6
> +	addresses must be separated by a comma.  At least one IPv6
> +	address must be given for NS/NA monitoring to function.  The
> +	maximum number of targets that can be specified is 16.  The
> +	default value is no IPv6 addresses.
> +
>  arp_validate
>  
>  	Specifies whether or not ARP probes and replies should be
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 9a28d3de798e..9f87f2abdc22 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -86,6 +86,7 @@
>  #if IS_ENABLED(CONFIG_TLS_DEVICE)
>  #include <net/tls.h>
>  #endif
> +#include <net/ip6_route.h>
>  
>  #include "bonding_priv.h"
>  
> @@ -2792,31 +2793,41 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
>  	return ret;
>  }
>  
> -/* We go to the (large) trouble of VLAN tagging ARP frames because
> - * switches in VLAN mode (especially if ports are configured as
> - * "native" to a VLAN) might not pass non-tagged frames.
> - */
> -static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
> -			  __be32 src_ip, struct bond_vlan_tag *tags)
> +static int bond_confirm_addr6(struct net_device *dev,
> +			       struct netdev_nested_priv *priv)
>  {
> -	struct sk_buff *skb;
> -	struct bond_vlan_tag *outer_tag = tags;
> -	struct net_device *slave_dev = slave->dev;
> -	struct net_device *bond_dev = slave->bond->dev;
> +	struct in6_addr *addr = (struct in6_addr *)priv->data;
>  
> -	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
> -		  arp_op, &dest_ip, &src_ip);
> +	return ipv6_chk_addr(dev_net(dev), addr, dev, 0);
> +}
>  
> -	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
> -			 NULL, slave_dev->dev_addr, NULL);
> +static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
> +{
> +	struct netdev_nested_priv priv = {
> +		.data = addr,
> +	};
> +	int ret = false;
>  
> -	if (!skb) {
> -		net_err_ratelimited("ARP packet allocation failed\n");
> -		return;
> -	}
> +	if (bond_confirm_addr6(bond->dev, &priv))
> +		return true;
> +
> +	rcu_read_lock();
> +	if (netdev_walk_all_upper_dev_rcu(bond->dev, bond_confirm_addr6, &priv))
> +		ret = true;
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
> +static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
> +			    struct sk_buff *skb)
> +{
> +	struct net_device *bond_dev = slave->bond->dev;
> +	struct net_device *slave_dev = slave->dev;
> +	struct bond_vlan_tag *outer_tag = tags;
>  
>  	if (!tags || tags->vlan_proto == VLAN_N_VID)
> -		goto xmit;
> +		return true;
>  
>  	tags++;
>  
> @@ -2833,7 +2844,7 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
>  						tags->vlan_id);
>  		if (!skb) {
>  			net_err_ratelimited("failed to insert inner VLAN tag\n");
> -			return;
> +			return false;
>  		}
>  
>  		tags++;
> @@ -2846,10 +2857,57 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
>  				       outer_tag->vlan_id);
>  	}
>  
> -xmit:
> -	arp_xmit(skb);
> +	return true;
> +}
> +/* We go to the (large) trouble of VLAN tagging ARP frames because
> + * switches in VLAN mode (especially if ports are configured as
> + * "native" to a VLAN) might not pass non-tagged frames.
> + */
> +static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
> +			  __be32 src_ip, struct bond_vlan_tag *tags)
> +{
> +	struct sk_buff *skb;
> +	struct net_device *slave_dev = slave->dev;
> +	struct net_device *bond_dev = slave->bond->dev;
> +
> +	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
> +		  arp_op, &dest_ip, &src_ip);
> +
> +	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
> +			 NULL, slave_dev->dev_addr, NULL);
> +
> +	if (!skb) {
> +		net_err_ratelimited("ARP packet allocation failed\n");
> +		return;
> +	}
> +
> +	if (bond_handle_vlan(slave, tags, skb))
> +		arp_xmit(skb);
> +	return;
>  }
>  
> +static void bond_ns_send(struct slave *slave, const struct in6_addr *daddr,
> +			 const struct in6_addr *saddr, struct bond_vlan_tag *tags)
> +{
> +	struct sk_buff *skb;
> +	struct net_device *slave_dev = slave->dev;
> +	struct net_device *bond_dev = slave->bond->dev;
> +	struct in6_addr mcaddr;
> +
> +	slave_dbg(bond_dev, slave_dev, "NS on slave: dst %pI6 src %pI6\n",
> +		  &daddr, &saddr);
> +
> +	skb = ndisc_ns_create(slave_dev, daddr, saddr, 0);
> +	if (!skb) {
> +		net_err_ratelimited("NS packet allocation failed\n");
> +		return;
> +	}
> +
> +	addrconf_addr_solict_mult(daddr, &mcaddr);
> +	if (bond_handle_vlan(slave, tags, skb))
> +		ndisc_send_skb(skb, &mcaddr, saddr);
> +	return;
> +}
>  /* Validate the device path between the @start_dev and the @end_dev.
>   * The path is valid if the @end_dev is reachable through device
>   * stacking.
> @@ -3058,6 +3116,140 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
>  	return RX_HANDLER_ANOTHER;
>  }
>  
> +static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
> +{
> +	struct in6_addr *targets = bond->params.ns_targets;
> +	struct bond_vlan_tag *tags;
> +	struct in6_addr saddr;
> +	struct dst_entry *dst;
> +	struct flowi6 fl6;
> +	int i;
> +
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS && !ipv6_addr_any(&targets[i]); i++) {
> +		slave_dbg(bond->dev, slave->dev, "%s: target %pI6\n",
> +			  __func__, &targets[i]);
> +		tags = NULL;
> +
> +		/* Find out through which dev should the packet go */
> +		memset(&fl6, 0, sizeof(struct flowi6));
> +		fl6.daddr = targets[i];
> +		fl6.flowi6_oif = bond->dev->ifindex;
> +
> +		dst = ip6_route_output(dev_net(bond->dev), NULL, &fl6);
> +		if (dst->error) {
> +			dst_release(dst);
> +			/* there's no route to target - try to send arp
> +			 * probe to generate any traffic (arp_validate=0)
> +			 */
> +			if (bond->params.arp_validate)
> +				pr_warn_once("%s: no route to ns_ip6_target %pI6 and arp_validate is set\n",
> +					     bond->dev->name,
> +					     &targets[i]);
> +			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
> +			continue;
> +		}
> +
> +		/* bond device itself */
> +		if (dst->dev == bond->dev)
> +			goto found;
> +
> +		rcu_read_lock();
> +		tags = bond_verify_device_path(bond->dev, dst->dev, 0);
> +		rcu_read_unlock();
> +
> +		if (!IS_ERR_OR_NULL(tags))
> +			goto found;
> +
> +		/* Not our device - skip */
> +		slave_dbg(bond->dev, slave->dev, "no path to ns_ip6_target %pI6 via dst->dev %s\n",
> +			   &targets[i], dst->dev ? dst->dev->name : "NULL");
> +
> +		dst_release(dst);
> +		continue;
> +
> +found:
> +		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
> +			bond_ns_send(slave, &targets[i], &saddr, tags);
> +		dst_release(dst);
> +		kfree(tags);
> +	}
> +}
> +
> +static void bond_validate_ns(struct bonding *bond, struct slave *slave,
> +			     struct in6_addr *saddr, struct in6_addr *daddr)
> +{
> +	int i;
> +
> +	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
> +		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6 tip %pI6 not found\n",
> +			   __func__, saddr, daddr);
> +		return;
> +	}
> +
> +	i = bond_get_targets_ip6(bond->params.ns_targets, saddr);
> +	if (i == -1) {
> +		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6 not found in targets\n",
> +			   __func__, saddr);
> +		return;
> +	}
> +	slave->last_rx = jiffies;
> +	slave->target_last_arp_rx[i] = jiffies;
> +}
> +
> +int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> +		 struct slave *slave)
> +{
> +	struct icmp6hdr *hdr = icmp6_hdr(skb);
> +	struct slave *curr_active_slave, *curr_arp_slave;
> +	struct in6_addr *saddr, *daddr;
> +	bool is_icmpv6 = skb->protocol == __cpu_to_be16(ETH_P_IPV6);
> +
> +	if (!slave_do_arp_validate(bond, slave)) {
> +		if ((slave_do_arp_validate_only(bond) && is_icmpv6) ||
> +		    !slave_do_arp_validate_only(bond))
> +			slave->last_rx = jiffies;
> +		return RX_HANDLER_ANOTHER;
> +	} else if (!is_icmpv6) {
> +		return RX_HANDLER_ANOTHER;
> +	}
> +
> +	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
> +		   __func__, skb->dev->name);
> +
> +	if (skb->pkt_type == PACKET_OTHERHOST ||
> +	    skb->pkt_type == PACKET_LOOPBACK ||
> +	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> +		goto out;
> +
> +	saddr = &ipv6_hdr(skb)->saddr;
> +	daddr = &ipv6_hdr(skb)->daddr;
> +
> +	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6 tip %pI6\n",
> +		  __func__, slave->dev->name, bond_slave_state(slave),
> +		  bond->params.arp_validate, slave_do_arp_validate(bond, slave),
> +		  saddr, daddr);
> +
> +	curr_active_slave = rcu_dereference(bond->curr_active_slave);
> +	curr_arp_slave = rcu_dereference(bond->current_arp_slave);
> +
> +	/* We 'trust' the received ARP enough to validate it if:
> +	 * see bond_arp_rcv().
> +	 */
> +	if (bond_is_active_slave(slave))
> +		bond_validate_ns(bond, slave, saddr, daddr);
> +	else if (curr_active_slave &&
> +		 time_after(slave_last_rx(bond, curr_active_slave),
> +			    curr_active_slave->last_link_up))
> +		bond_validate_ns(bond, slave, saddr, daddr);
> +	else if (curr_arp_slave &&
> +		 bond_time_in_interval(bond,
> +				       dev_trans_start(curr_arp_slave->dev), 1))
> +		bond_validate_ns(bond, slave, saddr, daddr);
> +
> +out:
> +	return RX_HANDLER_ANOTHER;
> +}
> +
>  /* function to verify if we're in the arp_interval timeslice, returns true if
>   * (last_act - arp_interval) <= jiffies <= (last_act + mod * arp_interval +
>   * arp_interval/2) . the arp_interval/2 is needed for really fast networks.
> @@ -3152,8 +3344,12 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
>  		 * do - all replies will be rx'ed on same link causing slaves
>  		 * to be unstable during low/no traffic periods
>  		 */
> -		if (bond_slave_is_up(slave))
> -			bond_arp_send_all(bond, slave);
> +		if (bond_slave_is_up(slave)) {
> +			if (bond_do_ns_validate(bond))
> +				bond_ns_send_all(bond, slave);
> +			else
> +				bond_arp_send_all(bond, slave);
> +		}
>  	}
>  
>  	rcu_read_unlock();
> @@ -3367,7 +3563,10 @@ static bool bond_ab_arp_probe(struct bonding *bond)
>  			    curr_active_slave->dev->name);
>  
>  	if (curr_active_slave) {
> -		bond_arp_send_all(bond, curr_active_slave);
> +		if (bond_do_ns_validate(bond))
> +			bond_ns_send_all(bond, curr_active_slave);
> +		else
> +			bond_arp_send_all(bond, curr_active_slave);
>  		return should_notify_rtnl;
>  	}
>  
> @@ -3419,7 +3618,10 @@ static bool bond_ab_arp_probe(struct bonding *bond)
>  	bond_set_slave_link_state(new_slave, BOND_LINK_BACK,
>  				  BOND_SLAVE_NOTIFY_LATER);
>  	bond_set_slave_active_flags(new_slave, BOND_SLAVE_NOTIFY_LATER);
> -	bond_arp_send_all(bond, new_slave);
> +	if (bond_do_ns_validate(bond))
> +		bond_ns_send_all(bond, new_slave);
> +	else
> +		bond_arp_send_all(bond, new_slave);
>  	new_slave->last_link_up = jiffies;
>  	rcu_assign_pointer(bond->current_arp_slave, new_slave);
>  
> @@ -3955,7 +4157,10 @@ static int bond_open(struct net_device *bond_dev)
>  
>  	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
>  		queue_delayed_work(bond->wq, &bond->arp_work, 0);
> -		bond->recv_probe = bond_arp_rcv;
> +		if (bond_do_ns_validate(bond))
> +			bond->recv_probe = bond_na_rcv;
> +		else
> +			bond->recv_probe = bond_arp_rcv;
>  	}
>  
>  	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
> @@ -5857,6 +6062,7 @@ static int bond_check_params(struct bond_params *params)
>  		strscpy_pad(params->primary, primary, sizeof(params->primary));
>  
>  	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
> +	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_ARP_TARGETS);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> index 1007bf6d385d..0d4e0a3b7c4f 100644
> --- a/drivers/net/bonding/bond_netlink.c
> +++ b/drivers/net/bonding/bond_netlink.c
> @@ -14,6 +14,7 @@
>  #include <net/netlink.h>
>  #include <net/rtnetlink.h>
>  #include <net/bonding.h>
> +#include <net/ipv6.h>
>  
>  static size_t bond_get_slave_size(const struct net_device *bond_dev,
>  				  const struct net_device *slave_dev)
> @@ -111,6 +112,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
>  	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
>  	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
>  	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
> +	[IFLA_BOND_NS_IP6_TARGET]	= { .type = NLA_NESTED },
>  };
>  
>  static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> @@ -272,6 +274,31 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
>  		if (err)
>  			return err;
>  	}
> +	if (data[IFLA_BOND_NS_IP6_TARGET]) {
> +		struct nlattr *attr;
> +		int i = 0, rem;
> +
> +		bond_option_ns_ip6_targets_clear(bond);
> +		nla_for_each_nested(attr, data[IFLA_BOND_NS_IP6_TARGET], rem) {
> +			struct in6_addr target;
> +
> +			if (nla_len(attr) < sizeof(target))
> +				return -EINVAL;
> +
> +			target = nla_get_in6_addr(attr);
> +
> +			bond_opt_initaddr(&newval, &target);
> +			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
> +					     &newval);
> +			if (err)
> +				break;
> +			i++;
> +		}
> +		if (i == 0 && bond->params.arp_interval)
> +			netdev_warn(bond->dev, "Removing last ns target with arp_interval on\n");
> +		if (err)
> +			return err;
> +	}
>  	if (data[IFLA_BOND_ARP_VALIDATE]) {
>  		int arp_validate = nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
>  
> @@ -526,6 +553,9 @@ static size_t bond_get_size(const struct net_device *bond_dev)
>  		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
>  		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
>  		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
> +						/* IFLA_BOND_NS_IP6_TARGET */
> +		nla_total_size(sizeof(struct nlattr)) +
> +		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_ARP_TARGETS +
>  		0;
>  }
>  
> @@ -603,6 +633,24 @@ static int bond_fill_info(struct sk_buff *skb,
>  			bond->params.arp_all_targets))
>  		goto nla_put_failure;
>  
> +	targets = nla_nest_start(skb, IFLA_BOND_NS_IP6_TARGET);
> +	if (!targets)
> +		goto nla_put_failure;
> +
> +	targets_added = 0;
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
> +		if (!ipv6_addr_any(&bond->params.ns_targets[i])) {
> +			if (nla_put_in6_addr(skb, i, &bond->params.ns_targets[i]))
> +				goto nla_put_failure;
> +			targets_added = 1;
> +		}
> +	}
> +
> +	if (targets_added)
> +		nla_nest_end(skb, targets);
> +	else
> +		nla_nest_cancel(skb, targets);
> +
>  	primary = rtnl_dereference(bond->primary_slave);
>  	if (primary &&
>  	    nla_put_u32(skb, IFLA_BOND_PRIMARY, primary->dev->ifindex))
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 0f48921c4f15..d073d9c3ae9b 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -34,6 +34,12 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
>  static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
>  static int bond_option_arp_ip_targets_set(struct bonding *bond,
>  					  const struct bond_opt_value *newval);
> +static int bond_option_ns_ip6_target_add(struct bonding *bond,
> +					 struct in6_addr *target);
> +static int bond_option_ns_ip6_target_rem(struct bonding *bond,
> +					 struct in6_addr *target);
> +static int bond_option_ns_ip6_targets_set(struct bonding *bond,
> +					  const struct bond_opt_value *newval);
>  static int bond_option_arp_validate_set(struct bonding *bond,
>  					const struct bond_opt_value *newval);
>  static int bond_option_arp_all_targets_set(struct bonding *bond,
> @@ -295,6 +301,13 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
>  		.flags = BOND_OPTFLAG_RAWVAL,
>  		.set = bond_option_arp_ip_targets_set
>  	},
> +	[BOND_OPT_NS_TARGETS] = {
> +		.id = BOND_OPT_NS_TARGETS,
> +		.name = "ns_ip6_target",
> +		.desc = "NS targets in ffff:ffff::ffff:ffff form",
> +		.flags = BOND_OPTFLAG_RAWVAL,
> +		.set = bond_option_ns_ip6_targets_set
> +	},
>  	[BOND_OPT_DOWNDELAY] = {
>  		.id = BOND_OPT_DOWNDELAY,
>  		.name = "downdelay",
> @@ -1052,7 +1065,10 @@ static int bond_option_arp_interval_set(struct bonding *bond,
>  			cancel_delayed_work_sync(&bond->arp_work);
>  		} else {
>  			/* arp_validate can be set only in active-backup mode */
> -			bond->recv_probe = bond_arp_rcv;
> +			if (bond_do_ns_validate(bond))
> +				bond->recv_probe = bond_na_rcv;
> +			else
> +				bond->recv_probe = bond_arp_rcv;
>  			cancel_delayed_work_sync(&bond->mii_work);
>  			queue_delayed_work(bond->wq, &bond->arp_work, 0);
>  		}
> @@ -1184,6 +1200,130 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
>  	return ret;
>  }
>  
> +static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
> +					    struct in6_addr *target,
> +					    unsigned long last_rx)
> +{
> +	struct in6_addr *targets = bond->params.ns_targets;
> +	struct list_head *iter;
> +	struct slave *slave;
> +
> +	if (slot >= 0 && slot < BOND_MAX_ARP_TARGETS) {
> +		bond_for_each_slave(bond, slave, iter)
> +			slave->target_last_arp_rx[slot] = last_rx;
> +		targets[slot] = *target;
> +	}
> +
> +	/* Use IPv6 NS/NA monitor if NS target set */
> +	if (bond_do_ns_validate(bond))
> +		bond->recv_probe = bond_na_rcv;
> +}
> +
> +void bond_option_ns_ip6_targets_clear(struct bonding *bond)
> +{
> +	struct in6_addr addr_any = in6addr_any;
> +	int i;
> +
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
> +		_bond_options_ns_ip6_target_set(bond, i, &addr_any, 0);
> +}
> +
> +static int bond_option_ns_ip6_target_add(struct bonding *bond, struct in6_addr *target)
> +{
> +	struct in6_addr *targets = bond->params.ns_targets;
> +	struct in6_addr addr_any = in6addr_any;
> +	int index;
> +
> +	if (!bond_is_ip6_target_ok(target)) {
> +		netdev_err(bond->dev, "invalid NS target %pI6 specified for addition\n",
> +			   target);
> +		return -EINVAL;
> +	}
> +
> +	if (bond_get_targets_ip6(targets, target) != -1) { /* dup */
> +		netdev_err(bond->dev, "NS target %pI6 is already present\n",
> +			   &target);
> +		return -EINVAL;
> +	}
> +
> +	index = bond_get_targets_ip6(targets, &addr_any); /* first free slot */
> +	if (index == -1) {
> +		netdev_err(bond->dev, "NS target table is full!\n");
> +		return -EINVAL;
> +	}
> +
> +	netdev_dbg(bond->dev, "Adding NS target %pI6\n", &target);
> +
> +	_bond_options_ns_ip6_target_set(bond, index, target, jiffies);
> +
> +	return 0;
> +}
> +
> +static int bond_option_ns_ip6_target_rem(struct bonding *bond, struct in6_addr *target)
> +{
> +	struct in6_addr *targets = bond->params.ns_targets;
> +	struct list_head *iter;
> +	struct slave *slave;
> +	unsigned long *targets_rx;
> +	int index, i;
> +
> +	if (!bond_is_ip6_target_ok(target)) {
> +		netdev_err(bond->dev, "invalid NS target %pI6 specified for removal\n",
> +			   target);
> +		return -EINVAL;
> +	}
> +
> +	index = bond_get_targets_ip6(targets, target);
> +	if (index == -1) {
> +		netdev_err(bond->dev, "unable to remove nonexistent NS target %pI6\n",
> +			   target);
> +		return -EINVAL;
> +	}
> +
> +	if (index == 0 && ipv6_addr_any(&targets[1]) && bond->params.arp_interval)
> +		netdev_warn(bond->dev, "Removing last NS target with arp_interval on\n");
> +
> +	netdev_dbg(bond->dev, "Removing NS target %pI6\n", target);
> +
> +	bond_for_each_slave(bond, slave, iter) {
> +		targets_rx = slave->target_last_arp_rx;
> +		for (i = index; (i < BOND_MAX_ARP_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
> +			targets_rx[i] = targets_rx[i+1];
> +		targets_rx[i] = 0;
> +	}
> +	for (i = index; (i < BOND_MAX_ARP_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
> +		targets[i] = targets[i+1];
> +	memset(&targets[i], 0, sizeof(struct in6_addr));
> +
> +	return 0;
> +}
> +
> +static int bond_option_ns_ip6_targets_set(struct bonding *bond,
> +					  const struct bond_opt_value *newval)
> +{
> +	int ret = -EPERM;
> +	struct in6_addr target;
> +
> +	if (newval->string) {
> +		if (!in6_pton(newval->string+1, -1, (u8 *)&target.s6_addr, -1, NULL)) {
> +			netdev_err(bond->dev, "invalid NS target %pI6 specified\n",
> +				   &target);
> +			return ret;
> +		}
> +		if (newval->string[0] == '+')
> +			ret = bond_option_ns_ip6_target_add(bond, &target);
> +		else if (newval->string[0] == '-')
> +			ret = bond_option_ns_ip6_target_rem(bond, &target);
> +		else
> +			netdev_err(bond->dev, "no command found in ns_ip6_targets file - use +<addr> or -<addr>\n");
> +	} else {
> +		target = newval->ip6_addr;
> +		ret = bond_option_ns_ip6_target_add(bond, &target);
> +	}
> +
> +	return ret;
> +}
> +
>  static int bond_option_arp_validate_set(struct bonding *bond,
>  					const struct bond_opt_value *newval)
>  {
> diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
> index 9b5a5df23d21..c61d95161782 100644
> --- a/drivers/net/bonding/bond_sysfs.c
> +++ b/drivers/net/bonding/bond_sysfs.c
> @@ -25,6 +25,7 @@
>  #include <linux/nsproxy.h>
>  
>  #include <net/bonding.h>
> +#include <net/ipv6.h>
>  
>  #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))
>  
> @@ -315,6 +316,26 @@ static ssize_t bonding_show_missed_max(struct device *d,
>  static DEVICE_ATTR(arp_missed_max, 0644,
>  		   bonding_show_missed_max, bonding_sysfs_store_option);
>  
> +static ssize_t bonding_show_ns_targets(struct device *d,
> +				       struct device_attribute *attr,
> +				       char *buf)
> +{
> +	struct bonding *bond = to_bond(d);
> +	int i, res = 0;
> +
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
> +		if (!ipv6_addr_any(&bond->params.ns_targets[i]))
> +			res += sprintf(buf + res, "%pI6 ",
> +				       &bond->params.ns_targets[i]);
> +	}
> +	if (res)
> +		buf[res-1] = '\n'; /* eat the leftover space */
> +
> +	return res;
> +}
> +static DEVICE_ATTR(ns_ip6_target, 0644,
> +		   bonding_show_ns_targets, bonding_sysfs_store_option);
> +
>  /* Show the up and down delays. */
>  static ssize_t bonding_show_downdelay(struct device *d,
>  				      struct device_attribute *attr,
> @@ -761,6 +782,7 @@ static struct attribute *per_bond_attrs[] = {
>  	&dev_attr_arp_all_targets.attr,
>  	&dev_attr_arp_interval.attr,
>  	&dev_attr_arp_ip_target.attr,
> +	&dev_attr_ns_ip6_target.attr,
>  	&dev_attr_downdelay.attr,
>  	&dev_attr_updelay.attr,
>  	&dev_attr_peer_notif_delay.attr,
> diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> index dd75c071f67e..689cea946dbf 100644
> --- a/include/net/bond_options.h
> +++ b/include/net/bond_options.h
> @@ -66,6 +66,7 @@ enum {
>  	BOND_OPT_PEER_NOTIF_DELAY,
>  	BOND_OPT_LACP_ACTIVE,
>  	BOND_OPT_MISSED_MAX,
> +	BOND_OPT_NS_TARGETS,
>  	BOND_OPT_LAST
>  };
>  
> @@ -79,6 +80,7 @@ struct bond_opt_value {
>  	char *string;
>  	u64 value;
>  	u32 flags;
> +	struct in6_addr ip6_addr;
>  };
>  
>  struct bonding;
> @@ -118,18 +120,22 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
>   * When value is ULLONG_MAX then string will be used.
>   */
>  static inline void __bond_opt_init(struct bond_opt_value *optval,
> -				   char *string, u64 value)
> +				   char *string, u64 value, struct in6_addr *addr)
>  {
>  	memset(optval, 0, sizeof(*optval));
>  	optval->value = ULLONG_MAX;
> -	if (value == ULLONG_MAX)
> +	if (string)
>  		optval->string = string;
> +	else if (addr)
> +		optval->ip6_addr = *addr;
>  	else
>  		optval->value = value;
>  }
> -#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
> -#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
> +#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL)
> +#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL)
> +#define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
>  
>  void bond_option_arp_ip_targets_clear(struct bonding *bond);
> +void bond_option_ns_ip6_targets_clear(struct bonding *bond);
>  
>  #endif /* _NET_BOND_OPTIONS_H */
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index f6ae3a4baea4..de1a38d1c531 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -29,6 +29,8 @@
>  #include <net/bond_3ad.h>
>  #include <net/bond_alb.h>
>  #include <net/bond_options.h>
> +#include <net/ipv6.h>
> +#include <net/addrconf.h>
>  
>  #define BOND_MAX_ARP_TARGETS	16
>  
> @@ -146,6 +148,7 @@ struct bond_params {
>  	struct reciprocal_value reciprocal_packets_per_slave;
>  	u16 ad_actor_sys_prio;
>  	u16 ad_user_port_key;
> +	struct in6_addr ns_targets[BOND_MAX_ARP_TARGETS];
>  
>  	/* 2 bytes of padding : see ether_addr_equal_64bits() */
>  	u8 ad_actor_system[ETH_ALEN + 2];
> @@ -499,6 +502,13 @@ static inline int bond_is_ip_target_ok(__be32 addr)
>  	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
>  }
>  
> +static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
> +{
> +	return !ipv6_addr_any(addr) &&
> +	       !ipv6_addr_loopback(addr) &&
> +	       !ipv6_addr_is_multicast(addr);
> +}
> +
>  /* Get the oldest arp which we've received on this slave for bond's
>   * arp_targets.
>   */
> @@ -619,6 +629,18 @@ static inline __be32 bond_confirm_addr(struct net_device *dev, __be32 dst, __be3
>  	return addr;
>  }
>  
> +static inline bool bond_do_ns_validate(struct bonding *bond)
> +{
> +	int i;
> +
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
> +		if (!ipv6_addr_any(&bond->params.ns_targets[i]))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  struct bond_net {
>  	struct net		*net;	/* Associated network namespace */
>  	struct list_head	dev_list;
> @@ -629,6 +651,7 @@ struct bond_net {
>  };
>  
>  int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
> +int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
>  netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
>  int bond_create(struct net *net, const char *name);
>  int bond_create_sysfs(struct bond_net *net);
> @@ -749,6 +772,19 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
>  	return -1;
>  }
>  
> +static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
> +{
> +	int i;
> +
> +	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
> +		if (ipv6_addr_equal(&targets[i], ip))
> +			return i;
> +		else if (ipv6_addr_any(&targets[i]))
> +			break;
> +
> +	return -1;
> +}
> +
>  /* exported from bond_main.c */
>  extern unsigned int bond_net_id;
>  
> diff --git a/include/net/ndisc.h b/include/net/ndisc.h
> index 04341d86585d..d2a7869ddfcb 100644
> --- a/include/net/ndisc.h
> +++ b/include/net/ndisc.h
> @@ -459,10 +459,19 @@ void ndisc_cleanup(void);
>  
>  int ndisc_rcv(struct sk_buff *skb);
>  
> +void ip6_nd_hdr(struct sk_buff *skb,
> +		       const struct in6_addr *saddr,
> +		       const struct in6_addr *daddr,
> +		       int hop_limit, int len);
> +struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
> +				const struct in6_addr *saddr, u64 nonce);
>  void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
>  		   const struct in6_addr *daddr, const struct in6_addr *saddr,
>  		   u64 nonce);
>  
> +void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
> +		    const struct in6_addr *saddr);
> +
>  void ndisc_send_rs(struct net_device *dev,
>  		   const struct in6_addr *saddr, const struct in6_addr *daddr);
>  void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4ac53b30b6dc..fc300b752f8d 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -859,6 +859,7 @@ enum {
>  	IFLA_BOND_PEER_NOTIF_DELAY,
>  	IFLA_BOND_AD_LACP_ACTIVE,
>  	IFLA_BOND_MISSED_MAX,
> +	IFLA_BOND_NS_IP6_TARGET,
>  	__IFLA_BOND_MAX,
>  };
>  
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index f03b597e4121..7b1f8ce69237 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -438,7 +438,7 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
>  	return skb;
>  }
>  
> -static void ip6_nd_hdr(struct sk_buff *skb,
> +void ip6_nd_hdr(struct sk_buff *skb,
>  		       const struct in6_addr *saddr,
>  		       const struct in6_addr *daddr,
>  		       int hop_limit, int len)
> @@ -465,10 +465,10 @@ static void ip6_nd_hdr(struct sk_buff *skb,
>  	hdr->saddr = *saddr;
>  	hdr->daddr = *daddr;
>  }
> +EXPORT_SYMBOL(ip6_nd_hdr);
>  
> -static void ndisc_send_skb(struct sk_buff *skb,
> -			   const struct in6_addr *daddr,
> -			   const struct in6_addr *saddr)
> +void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
> +		    const struct in6_addr *saddr)
>  {
>  	struct dst_entry *dst = skb_dst(skb);
>  	struct net *net = dev_net(skb->dev);
> @@ -515,6 +515,7 @@ static void ndisc_send_skb(struct sk_buff *skb,
>  
>  	rcu_read_unlock();
>  }
> +EXPORT_SYMBOL(ndisc_send_skb);
>  
>  void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
>  		   const struct in6_addr *solicited_addr,
> @@ -598,22 +599,16 @@ static void ndisc_send_unsol_na(struct net_device *dev)
>  	in6_dev_put(idev);
>  }
>  
> -void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
> -		   const struct in6_addr *daddr, const struct in6_addr *saddr,
> -		   u64 nonce)
> +struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
> +				const struct in6_addr *saddr, u64 nonce)
>  {
>  	struct sk_buff *skb;
> -	struct in6_addr addr_buf;
>  	int inc_opt = dev->addr_len;
>  	int optlen = 0;
>  	struct nd_msg *msg;
>  
> -	if (!saddr) {
> -		if (ipv6_get_lladdr(dev, &addr_buf,
> -				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
> -			return;
> -		saddr = &addr_buf;
> -	}
> +	if (!saddr)
> +		return NULL;
>  
>  	if (ipv6_addr_any(saddr))
>  		inc_opt = false;
> @@ -625,7 +620,7 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
>  
>  	skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
>  	if (!skb)
> -		return;
> +		return NULL;
>  
>  	msg = skb_put(skb, sizeof(*msg));
>  	*msg = (struct nd_msg) {
> @@ -647,7 +642,28 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
>  		memcpy(opt + 2, &nonce, 6);
>  	}
>  
> -	ndisc_send_skb(skb, daddr, saddr);
> +	return skb;
> +}
> +EXPORT_SYMBOL(ndisc_ns_create);
> +
> +void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
> +		   const struct in6_addr *daddr, const struct in6_addr *saddr,
> +		   u64 nonce)
> +{
> +	struct sk_buff *skb;
> +	struct in6_addr addr_buf;
> +
> +	if (!saddr) {
> +		if (ipv6_get_lladdr(dev, &addr_buf,
> +				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
> +			return;
> +		saddr = &addr_buf;
> +	}
> +
> +	skb = ndisc_ns_create(dev, solicit, saddr, nonce);
> +
> +	if (skb)
> +		ndisc_send_skb(skb, daddr, saddr);
>  }
>  
>  void ndisc_send_rs(struct net_device *dev, const struct in6_addr *saddr,
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index 4772a115231a..2df505cfbff4 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -656,6 +656,7 @@ enum {
>  	IFLA_BOND_PEER_NOTIF_DELAY,
>  	IFLA_BOND_AD_LACP_ACTIVE,
>  	IFLA_BOND_MISSED_MAX,
> +	IFLA_BOND_NS_IP6_TARGET,
>  	__IFLA_BOND_MAX,
>  };
>  
> -- 
> 2.31.1
> 
