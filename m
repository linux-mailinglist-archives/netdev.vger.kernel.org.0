Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B32C8D92
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgK3TBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgK3TBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:01:24 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC70C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:00:44 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id z7so17636099wrn.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jseHTwJsTGxbFFBS08KtA1BMTMljRZ4c0zXRDsuItBk=;
        b=kXaCTSC2+4d+ALK+X2p4StnsPe9ek3JyF+QE7cJBGJlGXCxtYv20/Ps8W6vAQG+rxw
         UMmgXYtQxQEincRrSPUw1Qmj7MqG1E3Wje6VofMaVWeEZMKF8R6yCAaFo/5lfNrPnREN
         9frMxZrMlX46WNuySFmSkWQJBInccRXlxgOTXbTY2LtNI8h5P5FWGMFK4NXTbunkYLOw
         IPpzblrfVNkOTKgjL1xAGAEg40dQxMmp/RUVCfR+ml4JwPzah5ngNvPlIvUO9naShk3F
         pJK1iPgnhNCrtLaE3oZ2IraeEn88SMqGZxjPr7PIkcY2lrAkHXcOfrfBsDBjKawllTuO
         7V2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jseHTwJsTGxbFFBS08KtA1BMTMljRZ4c0zXRDsuItBk=;
        b=FZltAbpcbJZRlIUqVhwYDn2rZfplHPHOEgDLuyUZMR+UXa/JCKK6rR2tQzlm4CnNIf
         ohsdZ4r4WgSxYx5XTX3MBOe/9l3bMi/1YQNWToslkbV5F0T3WyGXxkDsa3g/Kg0NNDz5
         7ttJ936nxaVzbxrIXXOOBYntHbj9/sm59qVrC8XEdfQv0cdCoq/Xit9i7fwth5fUhShn
         PyyX+kN0SwyYMsAWJ9SERU8mCMR+sSHgnF01ilc+l2vQzUOx9YYCGKxhmUPHJfBZl2WH
         EnlkPY52Y3qaMfxg7BuSALWwHx6VurO+wTi5lRvSQv7ccDlrbxwoKPd9w1t2myWukA6a
         8qKg==
X-Gm-Message-State: AOAM533cOsGTgHZuPlHnP99Yp+YO2pzZKbQMppb33NXG414vF1Smf5hQ
        yGPBTMAaTVeJtme36mYg89E=
X-Google-Smtp-Source: ABdhPJxzgkVlE1CZptPOf7VlQpTO9F0pw6takv36/iU/kC2NPVQD83JtEQNihQ9HSIFyDWuPw42Pnw==
X-Received: by 2002:adf:f607:: with SMTP id t7mr29771660wrp.169.1606762842863;
        Mon, 30 Nov 2020 11:00:42 -0800 (PST)
Received: from [192.168.8.116] ([37.172.189.71])
        by smtp.gmail.com with ESMTPSA id f17sm267676wmh.10.2020.11.30.11.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 11:00:41 -0800 (PST)
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
Date:   Mon, 30 Nov 2020 20:00:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130184828.x56bwxxiwydsxt3k@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/20 7:48 PM, Vladimir Oltean wrote:
> On Mon, Nov 30, 2020 at 10:14:05AM -0800, Jakub Kicinski wrote:
>> On Mon, 30 Nov 2020 11:41:10 +0100 Eric Dumazet wrote:
>>>> So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
>>>> (ie before my time). The time has come to get rid of it.
>>>>
>>>> The use is sysfs is because could be changed to RCU. There have been issues
>>>> in the past with sysfs causing lock inversions with the rtnl mutex, that
>>>> is why you will see some trylock code there.
>>>>
>>>> My guess is that dev_base_lock readers exist only because no one bothered to do
>>>> the RCU conversion.
>>>
>>> I think we did, a long time ago.
>>>
>>> We took care of all ' fast paths' already.
>>>
>>> Not sure what is needed, current situation does not bother me at all ;)
>>
>> Perhaps Vladimir has a plan to post separately about it (in that case
>> sorry for jumping ahead) but the initial problem was procfs which is
>> (hopefully mostly irrelevant by now, and) taking the RCU lock only
>> therefore forcing drivers to have re-entrant, non-sleeping
>> .ndo_get_stats64 implementations.
> 
> Right, the end reason why I'm even looking at this is because I want to
> convert all callers of dev_get_stats to use sleepable context and not
> atomic. This makes it easier to gather statistics from devices that have
> a firmware, or off-chip devices behind a slow bus like SPI.
> 
> Like Jakub pointed out, some places call dev_get_stats while iterating
> through the list of network interfaces - one would be procfs, but not
> only. These callers are pure readers, so they use RCU protection. But
> that gives us atomic context when calling dev_get_stats. The naive
> solution is to convert all those callers to hold the RTNL mutex, which
> is the writer-side protection for the network interface lists, and which
> is sleepable. In fact I do have a series of 8 patches where I get that
> done. But there are some weirder cases, such as the bonding driver,
> where I need to do this:
> 
> -----------------------------[cut here]-----------------------------
> From 369a0e18a2446cda8ff52d72c02aa144ae6687ec Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Mon, 30 Nov 2020 02:39:46 +0200
> Subject: [PATCH] net: bonding: retrieve device statistics under RTNL, not RCU
> 
> In the effort of making .ndo_get_stats64 be able to sleep, we need to
> ensure the callers of dev_get_stats do not use atomic context.
> 
> The bonding driver uses an RCU read-side critical section to ensure the
> integrity of the list of network interfaces, because the driver iterates
> through all net devices in the netns to find the ones which are its
> configured slaves. We still need some protection against an interface
> registering or deregistering, and the writer-side lock, the RTNL mutex,
> is fine for that, because it offers sleepable context.
> 
> We are taking the RTNL this way (checking for rtnl_is_locked first)
> because the RTNL is not guaranteed to be held by all callers of
> ndo_get_stats64, in fact there will be work in the future that will
> avoid as much RTNL-holding as possible.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/bonding/bond_main.c | 18 +++++++-----------
>  include/net/bonding.h           |  1 -
>  2 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e0880a3840d7..1d44534e95d2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3738,21 +3738,17 @@ static void bond_get_stats(struct net_device *bond_dev,
>  			   struct rtnl_link_stats64 *stats)
>  {
>  	struct bonding *bond = netdev_priv(bond_dev);
> +	bool rtnl_locked = rtnl_is_locked();
>  	struct rtnl_link_stats64 temp;
>  	struct list_head *iter;
>  	struct slave *slave;
> -	int nest_level = 0;
>  
> +	if (!rtnl_locked)
> +		rtnl_lock();

Gosh, do not do that.

Convert the bonding ->stats_lock to a mutex instead.

Adding more reliance to RTNL is not helping cases where
access to stats should not be blocked by other users of RTNL (which can be abused)

>  
> -	rcu_read_lock();
> -#ifdef CONFIG_LOCKDEP
> -	nest_level = bond_get_lowest_level_rcu(bond_dev);
> -#endif
> -
> -	spin_lock_nested(&bond->stats_lock, nest_level);
>  	memcpy(stats, &bond->bond_stats, sizeof(*stats));
>  
> -	bond_for_each_slave_rcu(bond, slave, iter) {
> +	bond_for_each_slave(bond, slave, iter) {
>  		const struct rtnl_link_stats64 *new =
>  			dev_get_stats(slave->dev, &temp);
>  
> @@ -3763,8 +3759,9 @@ static void bond_get_stats(struct net_device *bond_dev,
>  	}
>  
>  	memcpy(&bond->bond_stats, stats, sizeof(*stats));
> -	spin_unlock(&bond->stats_lock);
> -	rcu_read_unlock();
> +
> +	if (!rtnl_locked)
> +		rtnl_unlock();
>  }
>  
>  static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
> @@ -5192,7 +5189,6 @@ static int bond_init(struct net_device *bond_dev)
>  	if (!bond->wq)
>  		return -ENOMEM;
>  
> -	spin_lock_init(&bond->stats_lock);
>  	netdev_lockdep_set_classes(bond_dev);
>  
>  	list_add_tail(&bond->bond_list, &bn->dev_list);
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index d9d0ff3b0ad3..6fbde9713424 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -224,7 +224,6 @@ struct bonding {
>  	 * ALB mode (6) - to sync the use and modifications of its hash table
>  	 */
>  	spinlock_t mode_lock;
> -	spinlock_t stats_lock;
>  	u8	 send_peer_notif;
>  	u8       igmp_retrans;
>  #ifdef CONFIG_PROC_FS
> -----------------------------[cut here]-----------------------------
> 
> Only that there's a problem with this. It's the lock ordering that
> Stephen talked about.
> 
> cat /sys/class/net/bond0/statistics/*
> [   38.715829]
> [   38.717329] ======================================================
> [   38.723528] WARNING: possible circular locking dependency detected
> [   38.729730] 5.10.0-rc5-next-20201127-00016-gde02bf51f2fa #1481 Not tainted
> [   38.736628] ------------------------------------------------------
> [   38.742828] cat/602 is trying to acquire lock:
> [   38.747285] ffffcf4908119080 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x28
> [   38.754555]
> [   38.754555] but task is already holding lock:
> [   38.760406] ffff53364222c168 (kn->active#123){++++}-{0:0}, at: kernfs_seq_start+0x38/0xb0
> [   38.768631]
> [   38.768631] which lock already depends on the new lock.
> [   38.768631]
> [   38.776835]
> [   38.776835] the existing dependency chain (in reverse order) is:
> [   38.784341]
> [   38.784341] -> #1 (kn->active#123){++++}-{0:0}:
> [   38.790387]        lock_acquire+0x238/0x468
> [   38.794583]        __kernfs_remove+0x26c/0x3e0
> [   38.799040]        kernfs_remove_by_name_ns+0x5c/0xb8
> [   38.804107]        remove_files.isra.1+0x40/0x80
> [   38.808739]        sysfs_remove_group+0x50/0xb0
> [   38.813282]        sysfs_remove_groups+0x3c/0x58
> [   38.817913]        device_remove_attrs+0x64/0x98
> [   38.822544]        device_del+0x16c/0x3f8
> [   38.826566]        netdev_unregister_kobject+0x80/0x90
> [   38.831722]        rollback_registered_many+0x444/0x688
> [   38.836964]        unregister_netdevice_many.part.163+0x20/0xa8
> [   38.842904]        unregister_netdevice_many+0x2c/0x38
> [   38.848059]        rtnl_delete_link+0x5c/0x90
> [   38.852428]        rtnl_dellink+0x158/0x310
> [   38.856622]        rtnetlink_rcv_msg+0x298/0x4d8
> [   38.861254]        netlink_rcv_skb+0x64/0x130
> [   38.865625]        rtnetlink_rcv+0x28/0x38
> [   38.869733]        netlink_unicast+0x1dc/0x288
> [   38.874190]        netlink_sendmsg+0x2b0/0x3e8
> [   38.878647]        ____sys_sendmsg+0x27c/0x2c0
> [   38.883105]        ___sys_sendmsg+0x90/0xd0
> [   38.887299]        __sys_sendmsg+0x7c/0xd0
> [   38.891407]        __arm64_sys_sendmsg+0x2c/0x38
> [   38.896040]        el0_svc_common.constprop.3+0x80/0x1b0
> [   38.901369]        do_el0_svc+0x34/0xa0
> [   38.905216]        el0_sync_handler+0x138/0x198
> [   38.909760]        el0_sync+0x140/0x180
> [   38.913604]
> [   38.913604] -> #0 (rtnl_mutex){+.+.}-{4:4}:
> [   38.919295]        check_noncircular+0x154/0x168
> [   38.923926]        __lock_acquire+0x1118/0x15e0
> [   38.928470]        lock_acquire+0x238/0x468
> [   38.932667]        __mutex_lock+0xa4/0x970
> [   38.936776]        mutex_lock_nested+0x54/0x70
> [   38.941233]        rtnl_lock+0x20/0x28
> [   38.944993]        bond_get_stats+0x140/0x1a8
> [   38.949363]        dev_get_stats+0xdc/0xf0
> [   38.953472]        netstat_show.isra.25+0x50/0xa0
> [   38.958190]        collisions_show+0x2c/0x38
> [   38.962472]        dev_attr_show+0x3c/0x78
> [   38.966580]        sysfs_kf_seq_show+0xbc/0x138
> [   38.971124]        kernfs_seq_show+0x44/0x50
> [   38.975407]        seq_read_iter+0xe4/0x450
> [   38.979601]        seq_read+0xf8/0x148
> [   38.983359]        kernfs_fop_read+0x1e0/0x280
> [   38.987817]        vfs_read+0xac/0x1c8
> [   38.991576]        ksys_read+0x74/0xf8
> [   38.995335]        __arm64_sys_read+0x24/0x30
> [   38.999706]        el0_svc_common.constprop.3+0x80/0x1b0
> [   39.005035]        do_el0_svc+0x34/0xa0
> [   39.008882]        el0_sync_handler+0x138/0x198
> [   39.013426]        el0_sync+0x140/0x180
> [   39.017270]
> [   39.017270] other info that might help us debug this:
> [   39.017270]
> [   39.025300]  Possible unsafe locking scenario:
> [   39.025300]
> [   39.031236]        CPU0                    CPU1
> [   39.035779]        ----                    ----
> [   39.040321]   lock(kn->active#123);
> [   39.043826]                                lock(rtnl_mutex);
> [   39.049507]                                lock(kn->active#123);
> [   39.055540]   lock(rtnl_mutex);
> [   39.058691]
> [   39.058691]  *** DEADLOCK ***
> [   39.058691]
> [   39.064630] 3 locks held by cat/602:
> [   39.068212]  #0: ffff533645926f70 (&p->lock){+.+.}-{4:4}, at: seq_read_iter+0x64/0x450
> [   39.076173]  #1: ffff533643bfa090 (&of->mutex){+.+.}-{4:4}, at: kernfs_seq_start+0x30/0xb0
> [   39.084482]  #2: ffff53364222c168 (kn->active#123){++++}-{0:0}, at: kernfs_seq_start+0x38/0xb0
> 
> Ok, I admit I don't really understand the message, because struct
> kernfs_node::active is an atomic_t and not really a lock, but
> intuitively I think lockdep is unhappy that the RTNL mutex is not being
> used here as a top-level mutex.
> If somebody were to cat /sys/class/net/bond0/statistics/*, the kernfs
> node locking happens first, then the RTNL mutex is acquired by the
> bonding implementation of ndo_get_stats64.
> If somebody were to delete the bonding device via an "ip link del"
> rtnetlink message, the RTNL mutex would be held first, then the kernfs
> node lock corresponding to the interface's sysfs attributes second.
> I don't think there's really any potential deadlock, only an ordering
> issue between lockdep classes.
> 
> How I think this could be solved is if we made the network interface
> lists use some other writer-side protection than the big RTNL mutex.
> So I went on exactly to see how knee-deep I would need to get into that.
> 
> There are 2 separate classes of problems:
> - We already have two ways of protecting pure readers: via RCU and via
>   the rwlock. It doesn't help if we also add a second way of locking out
>   pure writers. We need to first clean up what we have. That's the
>   reason why I started the discussion about the rwlock.
> - Some callers appear to not use any sort of protection at all. Does
>   this code path look ok to you?
> 
> nfnetlink_rcv_batch
> -> NFT_MSG_NEWCHAIN
>    -> nf_tables_addchain
>       -> nft_chain_parse_hook
>          -> nft_chain_parse_netdev
>             -> nf_tables_parse_netdev_hooks
>                -> nft_netdev_hook_alloc
>                   -> __dev_get_by_name
>                      -> netdev_name_node_lookup: must be under RTNL mutex or dev_base_lock protection
> 
> Unless I'm missing something, there are just tons, tons of callers of
> __dev_get_by_name which hold neither the RTNL mutex, nor the
> dev_base_lock rwlock, nor RCU read-side critical section.
> 
> What I was thinking was that if we could add a separate mutex for the
> network interface lists (and this time make it per netns, and not global
> to the kernel), then we could take that lock a lot more locally. I.e. we
> could have __dev_get_by_name take that lock, and alleviate the need for
> callers to hold the RTNL mutex. That would solve some of these bugs too,
> and would also be more usable for the bonding case.
> 
