Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202ED333017
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhCIUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhCIUkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:40:12 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D389C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 12:40:12 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z5so7232846plg.3
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 12:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tp0jETsifKOFsq76DPhTKnUmC75d7AffkMc+0LyJPHs=;
        b=FpEAsy73a6hrywRRw5qX+fNDJjFtFIRi3zgs+HaegnTPAPeRkqwhk5DoUFp01L42zc
         XVbp0TuILoVTtRwsenQ/RcLbJvomM5qHeExbG9CieYSjE8mhHKYDvwUII5XAILDnayPa
         RLlpmUyWjh/t9SiocUCyMTakCkwznofWZWYbTfBzF8RcjVDE718DR4sYNUkuPU6bkDUz
         bKM2FiguxbbJ6tbLwDPgmsQuEjYesN6gHPrTBRnwwNrY9rzWS3Jxjj0BuXJvpE/zosGp
         XtkFMzxxl22Q0qtWmRrUgKaE/tm0BO/RTQkqAmAh4LpCt00bPU38+xolTOBLM0hwbQt9
         5+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tp0jETsifKOFsq76DPhTKnUmC75d7AffkMc+0LyJPHs=;
        b=H3uCTOh5kuLilKRbpcIu7HDsyXmr2rT4c/BLXW/bZ4t3fXAWjyDGNCZeiiZtQcNIJg
         ZMstdAfUbgCyPXxhxSdbUM3CeffzBRtAt2sJQDTsjexVYkpvdtJnoKvysRzuUxvQSciD
         fIRrK2de8Q7ZktsFgkjKaTUHdN+oBaCnvsc4BM0UlZnL/KMlU0iRO/6yfQoOulFR+2bt
         VK4iuH2dNDSRJ03VG+piGgaPSXVNc1ua98kvVjXhzVGhr/EFZyTiYcxtovcUNNtzjHrq
         gMLOV+m1nY5c2Nkp207NNV9jz/7VYPNo8lSKnR0ga2QQ3gg/fDD0lC1garvh5srPMjdC
         oEDg==
X-Gm-Message-State: AOAM532rAzmCg2Kt59+/pLpaMOs0xnOqowQ+tAb2djnqqx6C/2uLDE7L
        hnQvoJz0WNizCLWPYLJ9hwwluVOhpps=
X-Google-Smtp-Source: ABdhPJzs2JR+Br4Y1V7hqjsdoIfFF+q21E0qGfFOPcZFEYv0enyA7kz+7UPqFxifdWT2V6AbIsOcfw==
X-Received: by 2002:a17:903:1cb:b029:e5:f712:c13c with SMTP id e11-20020a17090301cbb02900e5f712c13cmr20772856plh.22.1615322410988;
        Tue, 09 Mar 2021 12:40:10 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b9sm13456084pgn.42.2021.03.09.12.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:40:10 -0800 (PST)
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210309184244.1970173-1-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
Date:   Tue, 9 Mar 2021 12:40:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309184244.1970173-1-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 10:42 AM, Tobias Waldekranz wrote:
> There are three kinds of events that have an inpact on VLAN
> configuration of DSA ports:
> 
> - Adding of stacked VLANs
>   (ip link add dev swp0.1 link swp0 type vlan id 1)
> 
> - Adding of bridged VLANs
>   (bridge vlan add dev swp0 vid 1)
> 
> - Changes to a bridge's VLAN filtering setting
>   (ip link set dev br0 type bridge vlan_filtering 1)
> 
> For all of these events, we want to ensure that some invariants are
> upheld:
> 
> - For hardware where VLAN filtering is a global setting, either all
>   bridges must use VLAN filtering, or no bridge can.

I suppose that is true, given that a non-VLAN filtering bridge must not
perform ingress VID checking, OK.

> 
> - For all filtering bridges, no stacked VLAN on any port may be
>   configured on multiple ports.

You need to qualify multiple ports a bit more here, are you saying
multiple ports that are part of said bridge, or?

> 
> - For all filtering bridges, no stacked VLAN may be configured in the
>   bridge.

Being stacked in the bridge does not really compute for me, you mean, no
VLAN upper must be configured on the bridge master device(s)? Why would
that be a problem though?

> 
> Move the validation of these invariants to a central function, and use
> it from all sites where these events are handled. This way, we ensure
> that all invariants are always checked, avoiding certain configs being
> allowed or disallowed depending on the order in which commands are
> given.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> There is still testing left to do on this, but I wanted to send early
> in order show what I meant by "generic" VLAN validation in this
> discussion:
> 
> https://lore.kernel.org/netdev/87mtvdp97q.fsf@waldekranz.com/
> 
> This is basically an alternative implementation of 1/4 and 2/4 from
> this series by Vladimir:
> 
> https://lore.kernel.org/netdev/20210309021657.3639745-1-olteanv@gmail.com/

I really have not been able to keep up with your discussion, and I am
not sure if I will given how quickly you guys can spin patches (not a
criticism, this is welcome).

> 
> net/dsa/dsa_priv.h |   4 ++
>  net/dsa/port.c     | 167 ++++++++++++++++++++++++++++++++-------------
>  net/dsa/slave.c    |  31 +--------
>  3 files changed, 125 insertions(+), 77 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 9d4b0e9b1aa1..c88ef5a43612 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -188,6 +188,10 @@ int dsa_port_lag_change(struct dsa_port *dp,
>  int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
>  		      struct netdev_lag_upper_info *uinfo);
>  void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
> +bool dsa_port_can_apply_stacked_vlan(struct dsa_port *dp, u16 vid,
> +				     struct netlink_ext_ack *extack);
> +bool dsa_port_can_apply_bridge_vlan(struct dsa_port *dp, u16 vid,
> +				    struct netlink_ext_ack *extack);
>  int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			    struct netlink_ext_ack *extack);
>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index c9c6d7ab3f47..3bf457d6775d 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -292,72 +292,141 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
>  	dsa_lag_unmap(dp->ds->dst, lag);
>  }
>  
> -/* Must be called under rcu_read_lock() */
> -static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
> -					      bool vlan_filtering,
> -					      struct netlink_ext_ack *extack)
> +static int dsa_port_stacked_vids_collect(struct net_device *vdev, int vid,
> +					 void *_stacked_vids)
>  {
> -	struct dsa_switch *ds = dp->ds;
> -	int err, i;
> +	unsigned long *stacked_vids = _stacked_vids;
> +
> +	if (test_bit(vid, stacked_vids))
> +		return -EBUSY;
>  
> -	/* VLAN awareness was off, so the question is "can we turn it on".
> -	 * We may have had 8021q uppers, those need to go. Make sure we don't
> -	 * enter an inconsistent state: deny changing the VLAN awareness state
> -	 * as long as we have 8021q uppers.
> +	set_bit(vid, stacked_vids);
> +	return 0;
> +}
> +
> +static bool dsa_port_can_apply_vlan(struct dsa_port *dp, bool *mod_filter,
> +				    u16 *stacked_vid, u16 *br_vid,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct dsa_switch_tree *dst = dp->ds->dst;
> +	unsigned long *stacked_vids = NULL;
> +	struct dsa_port *other_dp;
> +	bool filter;
> +	u16 vid;
> +
> +	/* If the modification we are validating is not toggling VLAN
> +	 * filtering, use the current setting.
>  	 */
> -	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
> -		struct net_device *upper_dev, *slave = dp->slave;
> -		struct net_device *br = dp->bridge_dev;
> -		struct list_head *iter;
> +	if (mod_filter)
> +		filter = *mod_filter;
> +	else
> +		filter = dp->bridge_dev && br_vlan_enabled(dp->bridge_dev);
>  
> -		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
> -			struct bridge_vlan_info br_info;
> -			u16 vid;
> +	/* For cases where enabling/disabling VLAN awareness is global
> +	 * to the switch, we need to handle the case where multiple
> +	 * bridges span different ports of the same switch device and
> +	 * one of them has a different setting than what is being
> +	 * requested.
> +	 */
> +	if (dp->ds->vlan_filtering_is_global) {
> +		list_for_each_entry(other_dp, &dst->ports, list) {
> +			if (!other_dp->bridge_dev ||
> +			    other_dp->bridge_dev == dp->bridge_dev)
> +				continue;
>  
> -			if (!is_vlan_dev(upper_dev))
> +			if (br_vlan_enabled(other_dp->bridge_dev) == filter)
>  				continue;
>  
> -			vid = vlan_dev_vlan_id(upper_dev);
> -
> -			/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
> -			 * device, respectively the VID is not found, returning
> -			 * 0 means success, which is a failure for us here.
> -			 */
> -			err = br_vlan_get_info(br, vid, &br_info);
> -			if (err == 0) {
> -				NL_SET_ERR_MSG_MOD(extack,
> -						   "Must first remove VLAN uppers having VIDs also present in bridge");
> -				return false;
> -			}
> +			NL_SET_ERR_MSG_MOD(extack, "VLAN filtering is a global setting");
> +			goto err;
>  		}
> +
>  	}
>  
> -	if (!ds->vlan_filtering_is_global)
> +	if (!filter)
>  		return true;
>  
> -	/* For cases where enabling/disabling VLAN awareness is global to the
> -	 * switch, we need to handle the case where multiple bridges span
> -	 * different ports of the same switch device and one of them has a
> -	 * different setting than what is being requested.
> -	 */
> -	for (i = 0; i < ds->num_ports; i++) {
> -		struct net_device *other_bridge;
> +	stacked_vids = bitmap_zalloc(VLAN_N_VID, GFP_KERNEL);
> +	if (!stacked_vids) {
> +		WARN_ON_ONCE(1);
> +		goto err;
> +	}
>  
> -		other_bridge = dsa_to_port(ds, i)->bridge_dev;
> -		if (!other_bridge)
> +	/* If the current operation is to add a stacked VLAN, mark it
> +	 * as busy. */
> +	if (stacked_vid)
> +		set_bit(*stacked_vid, stacked_vids);
> +
> +	/* Forbid any VID used by a stacked VLAN to exist on more than
> +	 * one port in the bridge, as the resulting configuration in
> +	 * hardware would allow forwarding between those ports. */
> +	list_for_each_entry(other_dp, &dst->ports, list) {
> +		if (!dsa_is_user_port(other_dp->ds, other_dp->index) ||
> +		    !other_dp->bridge_dev ||
> +		    other_dp->bridge_dev != dp->bridge_dev)
>  			continue;
> -		/* If it's the same bridge, it also has same
> -		 * vlan_filtering setting => no need to check
> -		 */
> -		if (other_bridge == dp->bridge_dev)
> -			continue;
> -		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
> -			NL_SET_ERR_MSG_MOD(extack,
> -					   "VLAN filtering is a global setting");
> -			return false;
> +
> +		if (vlan_for_each(other_dp->slave, dsa_port_stacked_vids_collect,
> +				  stacked_vids)) {
> +			NL_SET_ERR_MSG_MOD(extack, "Two bridge ports cannot be "
> +					   "the base interfaces for VLAN "
> +					   "interfaces using the same VID");
> +			goto err;
>  		}
>  	}
> +
> +	/* If the current operation is to add a bridge VLAN, make sure
> +	 * that it is not used by a stacked VLAN. */
> +	if (br_vid && test_bit(*br_vid, stacked_vids)) {
> +		NL_SET_ERR_MSG_MOD(extack, "A bridge cannot use the same VID "
> +				   "already in use by a VLAN interface "
> +				   "configured on a bridge port");
> +		goto err;
> +	}
> +
> +	/* Ensure that no stacked VLAN is also configured on the bridge
> +	 * offloaded by dp as that could result in leakage between
> +	 * non-bridged ports. */
> +	for_each_set_bit(vid, stacked_vids, VLAN_N_VID) {
> +		struct bridge_vlan_info br_info;
> +
> +		if (br_vlan_get_info(dp->bridge_dev, vid, &br_info))
> +			/* Error means that the VID does not exist,
> +			 * which is what we want to ensure. */
> +			continue;
> +
> +		NL_SET_ERR_MSG_MOD(extack, "A VLAN interface cannot use a VID "
> +				   "that is already in use by a bridge");
> +		goto err;
> +	}
> +
> +	kfree(stacked_vids);
>  	return true;
> +
> +err:
> +	if (stacked_vids)
> +		kfree(stacked_vids);
> +	return false;
> +}
> +
> +bool dsa_port_can_apply_stacked_vlan(struct dsa_port *dp, u16 vid,
> +				     struct netlink_ext_ack *extack)
> +{
> +	return dsa_port_can_apply_vlan(dp, NULL, &vid, NULL, extack);
> +}
> +
> +bool dsa_port_can_apply_bridge_vlan(struct dsa_port *dp, u16 vid,
> +				    struct netlink_ext_ack *extack)
> +{
> +	return dsa_port_can_apply_vlan(dp, NULL, NULL, &vid, extack);
> +}
> +
> +static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
> +					      bool vlan_filtering,
> +					      struct netlink_ext_ack *extack)
> +{
> +	return dsa_port_can_apply_vlan(dp, &vlan_filtering,
> +				       NULL, NULL, extack);
>  }
>  
>  int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 992fcab4b552..fc0dfeb6b64c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -363,19 +363,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  
>  	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
>  
> -	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
> -	 * the same VID.
> -	 */
> -	if (br_vlan_enabled(dp->bridge_dev)) {
> -		rcu_read_lock();
> -		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
> -		rcu_read_unlock();
> -		if (err) {
> -			NL_SET_ERR_MSG_MOD(extack,
> -					   "Port already has a VLAN upper with this VID");
> -			return err;
> -		}
> -	}
> +	if (!dsa_port_can_apply_bridge_vlan(dp, vlan.vid, extack))
> +		return -EBUSY;
>  
>  	err = dsa_port_vlan_add(dp, &vlan, extack);
>  	if (err)
> @@ -2083,28 +2072,14 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
>  			    struct netdev_notifier_changeupper_info *info)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct net_device *br = dp->bridge_dev;
> -	struct bridge_vlan_info br_info;
>  	struct netlink_ext_ack *extack;
> -	int err = NOTIFY_DONE;
>  	u16 vid;
>  
> -	if (!br || !br_vlan_enabled(br))
> -		return NOTIFY_DONE;
> -
>  	extack = netdev_notifier_info_to_extack(&info->info);
>  	vid = vlan_dev_vlan_id(info->upper_dev);
>  
> -	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
> -	 * device, respectively the VID is not found, returning
> -	 * 0 means success, which is a failure for us here.
> -	 */
> -	err = br_vlan_get_info(br, vid, &br_info);
> -	if (err == 0) {
> -		NL_SET_ERR_MSG_MOD(extack,
> -				   "This VLAN is already configured by the bridge");
> +	if (!dsa_port_can_apply_stacked_vlan(dp, vid, extack))
>  		return notifier_from_errno(-EBUSY);
> -	}
>  
>  	return NOTIFY_DONE;
>  }
> 


-- 
Florian
