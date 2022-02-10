Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66B64B061B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiBJGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:10:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiBJGK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:10:26 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA410DF
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 22:10:27 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v47so12427727ybi.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 22:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2I6BT3ilOSyFain1a7k5Gsfw/gPro8oeAg2URGLNw5M=;
        b=C4Frmk1dl+mYape4U7wd8H/fb8sCFpMpVQSa/9Vd4v/bNfJI8Wo0ssto5DvyYYIYPS
         Vj0+cg/eRsK/fMOAJ2xTzIyG/gFm4YJqB1eKgR/dlScitI0UvWOuOfKMwvXu08w8UiZP
         SKuaUrnOdy0+6esaXEU9AcUSYzi5PSj6dgIuUHaqkPgfeNEqn02va0hp/aNbve2A4FPG
         cwrVy2tDp6uK+KkxCvCADnyggbxNVJaq2hd8+hXNDhYaUDtqCw5ZMxeFQLmP1zpkplrq
         UPEsu+3gbxaFqK/ImWqy3FIQCplYuqKIeUfBOxL3RQ3N4qM1yi5WKIW7rCTq9IEn3TGF
         2MmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2I6BT3ilOSyFain1a7k5Gsfw/gPro8oeAg2URGLNw5M=;
        b=W36tN3BfGRTFs71vs2E76+Xxng2f5bpd4DSi2A5BkGOZ512fJXtlxya+D7OzlCUcla
         1zrsN+0O2QOUvF4bBDzAyY133v6t5PPyafd/w5GzFUQVNqsWWpEqUH7BkyGsCdwHOBHX
         fX3OagTVIxJJ0HlNdPH9uxccalQxKBaqgEWRJvFItL1+bBLIZwrKDa7RR2WnTmMfigKC
         GfqEqlHUPFv4QF9/w3DGf7qV0NxhwsRSYY1Dapd+MHkVItaygLElymHbhvuN4Mu3YXeS
         2/yInnEPB6TvGMqrHDuENttM/p7YU9ptTRi4d3igZkBKUYJVMHl4s0JLTbgGFVeLF6r+
         e9Gw==
X-Gm-Message-State: AOAM5328iyOOw9KdIL+wDhoxBp+wSrhD/EEH8RwK3f/52OeW/c+pOSXW
        BSmp3mUU/6he4gCuAH2EN0ScALxMeguYnnvPyeAKYA==
X-Google-Smtp-Source: ABdhPJzt5R1Ic+/m178DND38oMMfKBC7X5UWBC0mwYWH50NuDIQ5LKEM9KSNPLb0xWu40JwHGu37WIddNDkljVrGKAY=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr5520508ybb.156.1644473426369;
 Wed, 09 Feb 2022 22:10:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1644394642.git.lucien.xin@gmail.com> <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
 <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
 <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
In-Reply-To: <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Feb 2022 22:10:15 -0800
Message-ID: <CANn89iJdvCqp9ZCm4pDP9YSb=8o=66_2Vtqm7x02915oapK1VQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 9:49 PM Eric Dumazet <edumazet@google.com> wrote:

>
> BTW, I have the plan of generalizing blackhole_netdev for IPv6,
> meaning that we could perhaps get rid of the dependency
> about loopback dev, being the last device in a netns being dismantled.

Untested patch to give more ideas:
(Main incentive is that we are still chasing a unregister_device bug,
that I now think is related to IPv6 idev leaking somewhere)


diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4f402bc38f056e08f3761e63a7bc7a51e54e9384..02d31d4fcab3b3d529c4fe3260216ecee1108e82
100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -372,7 +372,7 @@ static struct inet6_dev *ipv6_add_dev(struct
net_device *dev)

        ASSERT_RTNL();

-       if (dev->mtu < IPV6_MIN_MTU)
+       if (dev->mtu < IPV6_MIN_MTU && dev != blackhole_netdev)
                return ERR_PTR(-EINVAL);

        ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
@@ -400,21 +400,22 @@ static struct inet6_dev *ipv6_add_dev(struct
net_device *dev)
        /* We refer to the device */
        dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);

-       if (snmp6_alloc_dev(ndev) < 0) {
-               netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
-                          __func__);
-               neigh_parms_release(&nd_tbl, ndev->nd_parms);
-               dev_put_track(dev, &ndev->dev_tracker);
-               kfree(ndev);
-               return ERR_PTR(err);
-       }
+       if (dev != blackhole_netdev) {
+               if (snmp6_alloc_dev(ndev) < 0) {
+                       netdev_dbg(dev, "%s: cannot allocate memory
for statistics\n",
+                                  __func__);
+                       neigh_parms_release(&nd_tbl, ndev->nd_parms);
+                       dev_put_track(dev, &ndev->dev_tracker);
+                       kfree(ndev);
+                       return ERR_PTR(err);
+               }

-       if (snmp6_register_dev(ndev) < 0) {
-               netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
-                          __func__, dev->name);
-               goto err_release;
+               if (snmp6_register_dev(ndev) < 0) {
+                       netdev_dbg(dev, "%s: cannot create
/proc/net/dev_snmp6/%s\n",
+                                  __func__, dev->name);
+                       goto err_release;
+               }
        }
-
        /* One reference from device. */
        refcount_set(&ndev->refcnt, 1);

@@ -445,25 +446,28 @@ static struct inet6_dev *ipv6_add_dev(struct
net_device *dev)

        ipv6_mc_init_dev(ndev);
        ndev->tstamp = jiffies;
-       err = addrconf_sysctl_register(ndev);
-       if (err) {
-               ipv6_mc_destroy_dev(ndev);
-               snmp6_unregister_dev(ndev);
-               goto err_release;
+       if (dev != blackhole_netdev) {
+               err = addrconf_sysctl_register(ndev);
+               if (err) {
+                       ipv6_mc_destroy_dev(ndev);
+                       snmp6_unregister_dev(ndev);
+                       goto err_release;
+               }
        }
        /* protected by rtnl_lock */
        rcu_assign_pointer(dev->ip6_ptr, ndev);

-       /* Join interface-local all-node multicast group */
-       ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
+       if (dev != blackhole_netdev) {
+               /* Join interface-local all-node multicast group */
+               ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);

-       /* Join all-node multicast group */
-       ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
-
-       /* Join all-router multicast group if forwarding is set */
-       if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
-               ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+               /* Join all-node multicast group */
+               ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);

+               /* Join all-router multicast group if forwarding is set */
+               if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
+                       ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+       }
        return ndev;

 err_release:
@@ -7233,26 +7237,8 @@ int __init addrconf_init(void)
                goto out_nowq;
        }

-       /* The addrconf netdev notifier requires that loopback_dev
-        * has it's ipv6 private information allocated and setup
-        * before it can bring up and give link-local addresses
-        * to other devices which are up.
-        *
-        * Unfortunately, loopback_dev is not necessarily the first
-        * entry in the global dev_base list of net devices.  In fact,
-        * it is likely to be the very last entry on that list.
-        * So this causes the notifier registry below to try and
-        * give link-local addresses to all devices besides loopback_dev
-        * first, then loopback_dev, which cases all the non-loopback_dev
-        * devices to fail to get a link-local address.
-        *
-        * So, as a temporary fix, allocate the ipv6 structure for
-        * loopback_dev first by hand.
-        * Longer term, all of the dependencies ipv6 has upon the loopback
-        * device and it being up should be removed.
-        */
        rtnl_lock();
-       idev = ipv6_add_dev(init_net.loopback_dev);
+       idev = ipv6_add_dev(blackhole_netdev);
        rtnl_unlock();
        if (IS_ERR(idev)) {
                err = PTR_ERR(idev);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f4884cda13b92e72d041680cbabfee2e07ec0f10..dc9d26a77c48f649ec39084c539d45b378474a35
100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -160,12 +160,8 @@ void rt6_uncached_list_del(struct rt6_info *rt)

 static void rt6_uncached_list_flush_dev(struct net *net, struct
net_device *dev)
 {
-       struct net_device *loopback_dev = net->loopback_dev;
        int cpu;

-       if (dev == loopback_dev)
-               return;
-
        for_each_possible_cpu(cpu) {
                struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
                struct rt6_info *rt;
@@ -176,7 +172,7 @@ static void rt6_uncached_list_flush_dev(struct net
*net, struct net_device *dev)
                        struct net_device *rt_dev = rt->dst.dev;

                        if (rt_idev->dev == dev) {
-                               rt->rt6i_idev = in6_dev_get(loopback_dev);
+                               rt->rt6i_idev = in6_dev_get(blackhole_netdev);
                                in6_dev_put(rt_idev);
                        }

@@ -373,13 +369,12 @@ static void ip6_dst_ifdown(struct dst_entry
*dst, struct net_device *dev,
 {
        struct rt6_info *rt = (struct rt6_info *)dst;
        struct inet6_dev *idev = rt->rt6i_idev;
-       struct net_device *loopback_dev =
-               dev_net(dev)->loopback_dev;

-       if (idev && idev->dev != loopback_dev) {
-               struct inet6_dev *loopback_idev = in6_dev_get(loopback_dev);
-               if (loopback_idev) {
-                       rt->rt6i_idev = loopback_idev;
+       if (idev && idev->dev != blackhole_netdev) {
+               struct inet6_dev *blackhole_idev =
in6_dev_get(blackhole_netdev);
+
+               if (blackhole_idev) {
+                       rt->rt6i_idev = blackhole_idev;
                        in6_dev_put(idev);
                }
        }
