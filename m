Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7035B458554
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhKURUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:20:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36065 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhKURUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:20:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 759EC5C0156;
        Sun, 21 Nov 2021 12:17:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 21 Nov 2021 12:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+5n8RT
        SM/0ibOoiOP0YJBycHVWk7QTaN9IDFMpJhtx8=; b=i0poCsjl34A+UmZKXPXChZ
        hssSVgVREmHxoD0sXvSn9Inmcm2gR0DD1yg00e7poYpX9pEo+ltMIv6KPA1eSY0k
        C/I7+kjNw83fjbxJS6916noi+ifb5qGDzsASbGEO3psPnsBzkOWY8nmgOLLekJ79
        O3DVwLD4fEGd/jiM7nUwaq737sIZQNlHjpw3jJ36KfjVP7Ww53Lp9zNAMcZ9CLgx
        ksqBhirAGDBmYcTffS9Z33mH2/t41yMDN9B0DmH4kE6aZcENTV6/YCjznlBirRrL
        zQQQ4C+nhq9i/NNlj8ZGtwK8D6zC5QsI4iA3Ylohks3lIBQBdeIzHAD7Y1BECByg
        ==
X-ME-Sender: <xms:NX-aYTP6G2f5CG-K3AoNNU9pTji0jyz2SFy99CjUsWuxdjNNd2LTkw>
    <xme:NX-aYd91rTI5Hust-x6b26W13oFn5tSiLSYC2voBxE3oQJ-NbFCl7Fjnu9zOosAcc
    cEJqgc4JQ57Ua4>
X-ME-Received: <xmr:NX-aYSTitW6-9qtwJkXkt9_s5UsE4mZDDWMqMx5jnuXpcbknQ4nve8GFS1Ao>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgedvgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NX-aYXsNsYJP8ZGmL8TCV0lIUwukdcyW0gs6AIy9MUaolyikPcVrew>
    <xmx:NX-aYbcDJwtqD8fTKp2R6ZtanyQSADpZYAou3UylEq21DB2JRZkwAg>
    <xmx:NX-aYT2bjWy17cjgLOUbBz9pRCqk8kou1fy9TT0bR-2AyR2rUT8ahQ>
    <xmx:NX-aYX5LJSoYZnL1MnBbf9zFfSIMdNy-64MUlcdKtqMCJj5nkcUv3Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Nov 2021 12:17:40 -0500 (EST)
Date:   Sun, 21 Nov 2021 19:17:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 2/3] net: nexthop: release IPv6 per-cpu dsts when
 replacing a nexthop group
Message-ID: <YZp/MvIX/YCHJY9K@shredder>
References: <20211121152453.2580051-1-razor@blackwall.org>
 <20211121152453.2580051-3-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121152453.2580051-3-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:24:52PM +0200, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When replacing a nexthop group, we must release the IPv6 per-cpu dsts of
> the removed nexthop entries after an RCU grace period because they
> contain references to the nexthop's net device and to the fib6 info.
> With specific series of events[1] we can reach net device refcount
> imbalance which is unrecoverable.
> 
> [1]
>  $ ip nexthop list
>   id 200 via 2002:db8::2 dev bridge.10 scope link onlink
>   id 201 via 2002:db8::3 dev bridge scope link onlink
>   id 203 group 201/200
>  $ ip -6 route
>   2001:db8::10 nhid 203 metric 1024 pref medium
>      nexthop via 2002:db8::3 dev bridge weight 1 onlink
>      nexthop via 2002:db8::2 dev bridge.10 weight 1 onlink
> 
> Create rt6_info through one of the multipath legs, e.g.:
>  $ taskset -a -c 1  ./pkt_inj 24 bridge.10 2001:db8::10
>  (pkt_inj is just a custom packet generator, nothing special)
> 
> Then remove that leg from the group by replace (let's assume it is id
> 200 in this case):
>  $ ip nexthop replace id 203 group 201
> 
> Now remove the IPv6 route:
>  $ ip -6 route del 2001:db8::10/128
> 
> The route won't be really deleted due to the stale rt6_info holding 1
> refcnt in nexthop id 200.
> At this point we have the following reference count dependency:
>  (deleted) IPv6 route holds 1 reference over nhid 203
>  nh 203 holds 1 ref over id 201
>  nh 200 holds 1 ref over the net device and the route due to the stale
>  rt6_info
> 
> Now to create circular dependency between nh 200 and the IPv6 route, and
> also to get a reference over nh 200, restore nhid 200 in the group:
>  $ ip nexthop replace id 203 group 201/200
> 
> And now we have a permanent circular dependncy because nhid 203 holds a
> reference over nh 200 and 201, but the route holds a ref over nh 203 and
> is deleted.
> 
> To trigger the bug just delete the group (nhid 203):
>  $ ip nexthop del id 203
> 
> It won't really be deleted due to the IPv6 route dependency, and now we
> have 2 unlinked and deleted objects that reference each other: the group
> and the IPv6 route. Since the group drops the reference it holds over its
> entries at free time (i.e. its own refcount needs to drop to 0) that will
> never happen and we get a permanent ref on them, since one of the entries
> holds a reference over the IPv6 route it will also never be released.
> 
> At this point the dependencies are:
>  (deleted, only unlinked) IPv6 route holds reference over group nh 203
>  (deleted, only unlinked) group nh 203 holds reference over nh 201 and 200
>  nh 200 holds 1 ref over the net device and the route due to the stale
>  rt6_info
> 
> This is the last point where it can be fixed by running traffic through
> nh 200, and specifically through the same CPU so the rt6_info (dst) will
> get released due to the IPv6 genid, that in turn will free the IPv6
> route, which in turn will free the ref count over the group nh 203.
> 
> If nh 200 is deleted at this point, it will never be released due to the
> ref from the unlinked group 203, it will only be unlinked:
>  $ ip nexthop del id 200
>  $ ip nexthop
>  $
> 
> Now we can never release that stale rt6_info, we have IPv6 route with ref
> over group nh 203, group nh 203 with ref over nh 200 and 201, nh 200 with
> rt6_info (dst) with ref over the net device and the IPv6 route. All of
> these objects are only unlinked, and cannot be released, thus they can't
> release their ref counts.
> 
>  Message from syslogd@dev at Nov 19 14:04:10 ...
>   kernel:[73501.828730] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3
>  Message from syslogd@dev at Nov 19 14:04:20 ...
>   kernel:[73512.068811] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3
> 
> Fixes: 7bf4796dd099 ("nexthops: add support for replace")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 9e8100728d46..a69a9e76f99f 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1899,15 +1899,36 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
>  /* if any FIB entries reference this nexthop, any dst entries
>   * need to be regenerated
>   */
> -static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
> +static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
> +			      struct nexthop *replaced_nh)
>  {
>  	struct fib6_info *f6i;
> +	struct nh_group *nhg;
> +	int i;
>  
>  	if (!list_empty(&nh->fi_list))
>  		rt_cache_flush(net);
>  
>  	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
>  		ipv6_stub->fib6_update_sernum(net, f6i);
> +
> +	/* if an IPv6 group was replaced, we have to release all old
> +	 * dsts to make sure all refcounts are released
> +	 */

This problem is specific to IPv6 because IPv4 dst entries do not hold
references on routes / FIB info thereby avoiding the circular dependency
described in the commit message?

> +	if (!replaced_nh->is_group)
> +		return;

Does it also make sense to skip the part below if we don't have any IPv6
routes using the nexthop?

> +
> +	/* new dsts must use only the new nexthop group */
> +	synchronize_net();
> +
> +	nhg = rtnl_dereference(replaced_nh->nh_grp);

In replace_nexthop_grp() that precedes this function we assign the new
nh_group to the nexthop shell used by the routes:

rcu_assign_pointer(old->nh_grp, newg);

And the old one that you want to purge is stored in
'replaced_nh->nh_grp':

rcu_assign_pointer(new->nh_grp, oldg);

The need for synchronize_net() above stems from the fact that some CPUs
might still be using 'oldg' via 'old->nh_grp'?

If so, we already have one synchronize_net() in replace_nexthop_grp()
for resilient groups. See:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=563f23b002534176f49524b5ca0e1d94d8906c40

Can we avoid two synchronize_net() per resilient group by removing the
one added here and instead do:

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index a69a9e76f99f..a47ce43ab1ff 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2002,9 +2002,10 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 
        rcu_assign_pointer(old->nh_grp, newg);
 
+       /* Make sure concurrent readers are not using 'oldg' anymore. */
+       synchronize_net();
+
        if (newg->resilient) {
-               /* Make sure concurrent readers are not using 'oldg' anymore. */
-               synchronize_net();
                rcu_assign_pointer(oldg->res_table, tmp_table);
                rcu_assign_pointer(oldg->spare->res_table, tmp_table);
        }

> +	for (i = 0; i < nhg->num_nh; i++) {
> +		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
> +		struct nh_info *nhi = rtnl_dereference(nhge->nh->nh_info);
> +
> +		if (nhi->family == AF_INET6)
> +			ipv6_stub->fib6_nh_release_dsts(&nhi->fib6_nh);
> +	}
>  }
>  
>  static int replace_nexthop_grp(struct net *net, struct nexthop *old,
> @@ -2247,7 +2268,7 @@ static int replace_nexthop(struct net *net, struct nexthop *old,
>  		err = replace_nexthop_single(net, old, new, extack);
>  
>  	if (!err) {
> -		nh_rt_cache_flush(net, old);
> +		nh_rt_cache_flush(net, old, new);
>  
>  		__remove_nexthop(net, new, NULL);
>  		nexthop_put(new);
> -- 
> 2.31.1
> 
