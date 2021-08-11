Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B849B3E96DE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhHKRdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhHKRdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:33:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749AC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 10:32:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n12so4897541edx.8
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 10:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8cYzPOEKPUNU4iMfWGsw+UgGLEuh/P3WpqyKJm8oKo=;
        b=PHFrUXPUQ5Gidmu0e6OnlpL49Puflgfj5se38xcU4hRLu7cO/HPmgeJRVpNz4FzaD1
         0FkjKaK85vRJdyUl3twXLoEgO+06WJLyX04qjp3L0cMAqmuEgPwi0pI8hYiZRQBeLwnq
         ZjMfi+PWDQT3T32kkh3NH11TCeyRavjk8HHkp7//63PODxa/qYYq6OZnKfvgUMTbSw1j
         fa9qMsr07tf6gFdMWnJeji/zS6JbdeQ49/DZaTa73hSx3qOZH6xGwmDDkVkGIOXYXaAY
         ndZBbob/fy4hatfWyTZXrZRDcyh35UH7Tvl2RNjY+E3YxNXi3KhNOdE017k+PE15/T55
         19og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8cYzPOEKPUNU4iMfWGsw+UgGLEuh/P3WpqyKJm8oKo=;
        b=b/iQqlUirp5JCf3th4Be+941epgyq4qgoFNBuVVgwVv6HeUT6fNi8vl/jr5uEV5eNX
         UswwvQ7hyzMhuLUjwtnSAXr5msI+SVm6jSpGjZIgKvrskthKO3ygtnPRttkWFifUZnFr
         WhJaXsoBoQqZjaf/1VNSR/1ddlDIgzKzptv6sa5SyP3Cqgi3p3BKSR90+BEFTb12ZC4M
         ai3w6c/KXzJOBJXen1Fqh3TQYyZ2NanTcHl7VzAezM6s6GWzjIvPHkEiP5TObs5XjJtC
         Ypf3CRlO0UVek/iK3O0S7/pO+a5TEZd1r63aODgN7KBCoOK7Ivss1279742klcX72Y7R
         2xZQ==
X-Gm-Message-State: AOAM530DVjYH35GsX0HdhY+irtnzOzMn6Yn0qddL0VI2Y2MUdjRxG7SW
        AZTmtph12fEBCCzcXz75M5s=
X-Google-Smtp-Source: ABdhPJwfhyQ7OSQMnrGXukSyXcvXj9zJsSDCmvt0t9kjh3mYqJMtA5NxNJDplEihgZ5SssbsgNGaWw==
X-Received: by 2002:aa7:d404:: with SMTP id z4mr12340284edq.255.1628703176785;
        Wed, 11 Aug 2021 10:32:56 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v13sm24211ejx.24.2021.08.11.10.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 10:32:56 -0700 (PDT)
Date:   Wed, 11 Aug 2021 20:32:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a
 loop" antipattern from the core
Message-ID: <20210811173254.shwupnunaaoadpjb@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-3-vladimir.oltean@nxp.com>
 <20210810033339.1232663-1-dqfext@gmail.com>
 <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com>
 <20210810113532.tvu5dk5g7lbnrdjn@skbuf>
 <20210810163533.bn7zq2dzcilfm6o5@skbuf>
 <20210810170447.1517888-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810170447.1517888-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 01:04:47AM +0800, DENG Qingfang wrote:
> On Tue, Aug 10, 2021 at 07:35:33PM +0300, Vladimir Oltean wrote:
> > If I were to guess where Qingfang was hinting at, is that the receive
> > path now needs to iterate over a list, whereas before it simply indexed
> > an array:
> > 
> > static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
> > 						       int device, int port)
> > {
> > 	struct dsa_port *cpu_dp = dev->dsa_ptr;
> > 	struct dsa_switch_tree *dst = cpu_dp->dst;
> > 	struct dsa_port *dp;
> > 
> > 	list_for_each_entry(dp, &dst->ports, list)
> > 		if (dp->ds->index == device && dp->index == port &&
> > 		    dp->type == DSA_PORT_TYPE_USER)
> > 			return dp->slave;
> > 
> > 	return NULL;
> > }
> > 
> > I will try in the following days to make a prototype implementation of
> > converting back the linked list into an array and see if there is any
> > justifiable performance improvement.
> > 
> > [ even if this would make the "multiple CPU ports in LAG" implementation
> >   harder ]
> 
> Yes, you got my point.
> 
> There is RTL8390M series SoC, which has 52+ ports but a weak CPU (MIPS
> 34kc 700MHz). In that case the linear lookup time and the potential cache
> miss could make a difference.

Then I am not in a position to make relevant performance tests for that
scenario.

I have been testing with the following setup: an NXP LS1028A switch
(ocelot/felix driver) using IPv4 forwarding of 64 byte UDP datagrams
sent by a data generator. 2 ports at 1Gbps each, 100% port load. IP
forwarding takes place between 1 port and the other.
Generator port A sends from 192.168.100.1 to 192.168.200.1
Generator port B sends from 192.168.200.1 to 192.168.100.1

Flow control is enabled on all switch ports, the user ports and the CPU port
(I don't really have a setup that I can test in any meaningful way
without flow control).

The script I run on the board to set things up for IP forwarding is:

ip link set eno2 down && echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
ip link set swp0 address a0:00:00:00:00:02
ip link set swp1 address a0:00:00:00:00:04
for eth in swp0 swp1; do
	ip link set ${eth} up
done
ip addr add 192.168.100.2/24 dev swp0
ip addr add 192.168.200.2/24 dev swp1
echo 1 > /proc/sys/net/ipv4/ip_forward
arp -s 192.168.100.1 00:01:02:03:04:05 dev swp0
arp -s 192.168.200.1 00:01:02:03:04:06 dev swp1
ethtool --config-nfc eno2 flow-type ip4 dst-ip 192.168.200.1 action 0
ethtool --config-nfc eno2 flow-type ip4 dst-ip 192.168.100.1 action 1
ethtool -K eno2 gro on rx-gro-list on
ethtool -K swp0 gro on rx-gro-list on
ethtool -K swp1 gro on rx-gro-list on


The DSA patch I used on top of today's net-next was:

-----------------------------[ cut here ]-----------------------------
From 7733f643dd61431a93da5a8f5118848cdc037562 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 11 Aug 2021 00:27:07 +0300
Subject: [PATCH] net: dsa: setup a linear port cache for faster receive path

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  5 +++++
 net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++----
 net/dsa/dsa_priv.h |  9 ++++-----
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3203b200cc38..2a9ea4f57910 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -153,9 +153,14 @@ struct dsa_switch_tree {
 	struct net_device **lags;
 	unsigned int lags_len;
 
+	struct dsa_port **port_cache;
+
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
 
+	/* Track the largest port count in a switch within a tree */
+	unsigned int max_num_ports;
+
 	/* Track the bridges with forwarding offload enabled */
 	unsigned long fwd_offloading_bridges;
 };
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 0b7497dd60c3..3d2b92dbd603 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -941,6 +941,39 @@ static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
 	kfree(dst->lags);
 }
 
+static int dsa_tree_setup_port_cache(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dst->last_switch < dp->ds->index)
+			dst->last_switch = dp->ds->index;
+		if (dst->max_num_ports < dp->ds->num_ports)
+			dst->max_num_ports = dp->ds->num_ports;
+	}
+
+	dst->port_cache = kcalloc((dst->last_switch + 1) * dst->max_num_ports,
+				  sizeof(struct dsa_port *), GFP_KERNEL);
+	if (!dst->port_cache)
+		return -ENOMEM;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		dst->port_cache[dp->ds->index * dst->max_num_ports + dp->index] = dp;
+
+	return 0;
+}
+
+static void dsa_tree_teardown_port_cache(struct dsa_switch_tree *dst)
+{
+	int i;
+
+	for (i = 0; i < dst->max_num_ports * dst->last_switch; i++)
+		dst->port_cache[i] = NULL;
+
+	kfree(dst->port_cache);
+	dst->port_cache = NULL;
+}
+
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
 {
 	bool complete;
@@ -956,10 +989,14 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (!complete)
 		return 0;
 
-	err = dsa_tree_setup_cpu_ports(dst);
+	err = dsa_tree_setup_port_cache(dst);
 	if (err)
 		return err;
 
+	err = dsa_tree_setup_cpu_ports(dst);
+	if (err)
+		goto teardown_port_cache;
+
 	err = dsa_tree_setup_switches(dst);
 	if (err)
 		goto teardown_cpu_ports;
@@ -984,6 +1021,8 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
 	dsa_tree_teardown_cpu_ports(dst);
+teardown_port_cache:
+	dsa_tree_teardown_port_cache(dst);
 
 	return err;
 }
@@ -1003,6 +1042,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_cpu_ports(dst);
 
+	dsa_tree_teardown_port_cache(dst);
+
 	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
 		list_del(&dl->list);
 		kfree(dl);
@@ -1301,9 +1342,6 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 		return -EEXIST;
 	}
 
-	if (ds->dst->last_switch < ds->index)
-		ds->dst->last_switch = ds->index;
-
 	return 0;
 }
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6310a15afe21..5c27f66fd62a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -188,12 +188,11 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 	struct dsa_switch_tree *dst = cpu_dp->dst;
 	struct dsa_port *dp;
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds->index == device && dp->index == port &&
-		    dp->type == DSA_PORT_TYPE_USER)
-			return dp->slave;
+	dp = dst->port_cache[device * dst->max_num_ports + port];
+	if (!dp || dp->type != DSA_PORT_TYPE_USER)
+		return NULL;
 
-	return NULL;
+	return dp->slave;
 }
 
 /* netlink.c */
-----------------------------[ cut here ]-----------------------------

The results I got were:

Before the patch:

684 Kpps = 459 Mbps

perf record -e cycles -C 0 sleep 10 && perf report
    10.17%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_pci_remove
     6.13%  ksoftirqd/0      [kernel.kallsyms]  [k] eth_type_trans
     5.48%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_poll
     4.99%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_alloc
     4.56%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_gro_receive
     2.89%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_start_xmit
     2.77%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_flow_dissect
     2.75%  ksoftirqd/0      [kernel.kallsyms]  [k] __siphash_aligned
     2.55%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_core
     2.48%  ksoftirqd/0      [kernel.kallsyms]  [k] build_skb
     2.47%  ksoftirqd/0      [kernel.kallsyms]  [k] take_page_off_buddy
     2.01%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gro_receive
     1.86%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_slave_xmit
     1.76%  ksoftirqd/0      [kernel.kallsyms]  [k] __dev_queue_xmit
     1.68%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_zcopy_clear
     1.62%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_build_skb
     1.60%  ksoftirqd/0      [kernel.kallsyms]  [k] __build_skb_around
     1.50%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_hard_start_xmit
     1.49%  ksoftirqd/0      [kernel.kallsyms]  [k] sch_direct_xmit
     1.42%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_get_hash
     1.29%  ksoftirqd/0      [kernel.kallsyms]  [k] __local_bh_enable_ip
     1.26%  ksoftirqd/0      [kernel.kallsyms]  [k] udp_gro_receive
     1.23%  ksoftirqd/0      [kernel.kallsyms]  [k] udp4_gro_receive
     1.21%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_segment_list
     1.13%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_drivername
     1.05%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_shutdown
     1.05%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gso_segment
     1.01%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_switch_rcv
     0.98%  ksoftirqd/0      [kernel.kallsyms]  [k] ocelot_rcv
     0.91%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_gro_receive
     0.87%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_xmit
     0.85%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_free_bulk
     0.84%  ksoftirqd/0      [kernel.kallsyms]  [k] do_csum
     0.84%  ksoftirqd/0      [kernel.kallsyms]  [k] memmove
     0.80%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_rcv
     0.79%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_list_core
     0.78%  ksoftirqd/0      [kernel.kallsyms]  [k] netif_skb_features
     0.76%  ksoftirqd/0      [kernel.kallsyms]  [k] netif_receive_skb_list_internal
     0.76%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_all
     0.74%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_pick_tx

perf record -e cache-misses -C 0 sleep 10 && perf report
     7.22%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_zcopy_clear
     6.46%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gro_receive
     6.41%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_pci_remove
     6.20%  ksoftirqd/0      [kernel.kallsyms]  [k] take_page_off_buddy
     6.13%  ksoftirqd/0      [kernel.kallsyms]  [k] build_skb
     5.06%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gso_segment
     4.47%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_gro_receive
     4.28%  ksoftirqd/0      [kernel.kallsyms]  [k] memmove
     3.77%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_poll
     3.73%  ksoftirqd/0      [kernel.kallsyms]  [k] __copy_skb_header
     3.46%  ksoftirqd/0      [kernel.kallsyms]  [k] eth_type_trans
     3.06%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_all
     2.76%  ksoftirqd/0      [kernel.kallsyms]  [k] ip_send_check
     2.36%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_get_hash
     2.24%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_alloc
     2.23%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_core
     1.68%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_pick_tx
     1.56%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_segment_list
     1.55%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_slave_xmit
     1.54%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_headers_offset_update
     1.51%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_start_xmit
     1.48%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_core_pick_tx
     1.30%  ksoftirqd/0      [kernel.kallsyms]  [k] __dev_queue_xmit
     1.14%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_rcv
     1.05%  ksoftirqd/0      [kernel.kallsyms]  [k] __build_skb_around
     1.05%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_pull_rcsum
     1.03%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_xmit
     0.98%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_flow_dissect
     0.89%  ksoftirqd/0      [kernel.kallsyms]  [k] ocelot_xmit
     0.84%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_build_skb
     0.73%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_free_bulk
     0.63%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_refill_rx_ring
     0.55%  ksoftirqd/0      [kernel.kallsyms]  [k] netif_skb_features
     0.46%  ksoftirqd/0      [kernel.kallsyms]  [k] dma_unmap_page_attrs
     0.46%  ksoftirqd/0      [kernel.kallsyms]  [k] fib_table_lookup
     0.36%  ksoftirqd/0      [kernel.kallsyms]  [k] fib_lookup_good_nhc
     0.33%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_data
     0.33%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_tx_vid
     0.32%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_flip_rx_buff
     0.29%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_consume_skb

After the patch:

650 Kpps = 426 Mbps

perf record -e cycles -C 0 sleep 10 && perf report
     9.34%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_pci_remove
     7.70%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_poll
     5.49%  ksoftirqd/0      [kernel.kallsyms]  [k] eth_type_trans
     4.62%  ksoftirqd/0      [kernel.kallsyms]  [k] take_page_off_buddy
     4.55%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_alloc
     4.36%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_gro_receive
     3.22%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_zcopy_clear
     2.59%  ksoftirqd/0      [kernel.kallsyms]  [k] __siphash_aligned
     2.51%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_start_xmit
     2.37%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_flow_dissect
     2.20%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_core
     1.84%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_free_bulk
     1.69%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gro_receive
     1.65%  ksoftirqd/0      [kernel.kallsyms]  [k] __dev_queue_xmit
     1.63%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_slave_xmit
     1.60%  ksoftirqd/0      [kernel.kallsyms]  [k] build_skb
     1.45%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_build_skb
     1.41%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_hard_start_xmit
     1.39%  ksoftirqd/0      [kernel.kallsyms]  [k] sch_direct_xmit
     1.39%  ksoftirqd/0      [kernel.kallsyms]  [k] __build_skb_around
     1.28%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_get_hash
     1.16%  ksoftirqd/0      [kernel.kallsyms]  [k] __local_bh_enable_ip
     1.14%  ksoftirqd/0      [kernel.kallsyms]  [k] udp4_gro_receive
     1.12%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_all
     1.09%  ksoftirqd/0      [kernel.kallsyms]  [k] ocelot_rcv
     1.08%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_drivername
     1.08%  ksoftirqd/0      [kernel.kallsyms]  [k] dma_unmap_page_attrs
     1.08%  ksoftirqd/0      [kernel.kallsyms]  [k] udp_gro_receive
     1.05%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_shutdown
     1.04%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_consume_skb
     1.03%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_segment_list
     0.90%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_gro_receive
     0.86%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gso_segment
     0.83%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_switch_rcv
     0.77%  ksoftirqd/0      [kernel.kallsyms]  [k] memmove
     0.75%  ksoftirqd/0      [kernel.kallsyms]  [k] do_csum
     0.73%  ksoftirqd/0      [kernel.kallsyms]  [k] netif_skb_features
     0.71%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_rcv
     0.69%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_list_core
     0.67%  ksoftirqd/0      [kernel.kallsyms]  [k] netif_receive_skb_list_internal

perf record -e cache-misses -C 0 sleep 10 && perf report
    12.38%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_zcopy_clear
     9.34%  ksoftirqd/0      [kernel.kallsyms]  [k] take_page_off_buddy
     8.62%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_pci_remove
     5.61%  ksoftirqd/0      [kernel.kallsyms]  [k] memmove
     5.44%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gro_receive
     4.61%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_poll
     4.20%  ksoftirqd/0      [kernel.kallsyms]  [k] inet_gso_segment
     3.58%  ksoftirqd/0      [kernel.kallsyms]  [k] dev_gro_receive
     3.19%  ksoftirqd/0      [kernel.kallsyms]  [k] build_skb
     3.11%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_all
     2.80%  ksoftirqd/0      [kernel.kallsyms]  [k] __copy_skb_header
     2.79%  ksoftirqd/0      [kernel.kallsyms]  [k] eth_type_trans
     2.31%  ksoftirqd/0      [kernel.kallsyms]  [k] ip_send_check
     1.95%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_get_hash
     1.64%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_alloc
     1.54%  ksoftirqd/0      [kernel.kallsyms]  [k] __netif_receive_skb_core
     1.52%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_slave_xmit
     1.51%  ksoftirqd/0      [kernel.kallsyms]  [k] kmem_cache_free_bulk
     1.49%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_pick_tx
     1.42%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_headers_offset_update
     1.34%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_segment_list
     1.20%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_build_skb
     1.19%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_start_xmit
     1.09%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_xmit
     0.94%  ksoftirqd/0      [kernel.kallsyms]  [k] netdev_core_pick_tx
     0.90%  ksoftirqd/0      [kernel.kallsyms]  [k] __dev_queue_xmit
     0.87%  ksoftirqd/0      [kernel.kallsyms]  [k] ocelot_xmit
     0.85%  ksoftirqd/0      [kernel.kallsyms]  [k] __skb_flow_dissect
     0.68%  ksoftirqd/0      [kernel.kallsyms]  [k] dsa_8021q_rcv
     0.63%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_pull_rcsum
     0.63%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_flip_rx_buff
     0.61%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_consume_skb
     0.50%  ksoftirqd/0      [kernel.kallsyms]  [k] skb_release_data
     0.48%  ksoftirqd/0      [kernel.kallsyms]  [k] dma_unmap_page_attrs
     0.41%  ksoftirqd/0      [kernel.kallsyms]  [k] enetc_refill_rx_ring
     0.37%  ksoftirqd/0      [kernel.kallsyms]  [k] __build_skb_around
     0.33%  ksoftirqd/0      [kernel.kallsyms]  [k] fib_table_lookup
     0.33%  ksoftirqd/0      [kernel.kallsyms]  [k] napi_skb_cache_put
     0.28%  ksoftirqd/0      [kernel.kallsyms]  [k] gro_cells_receive
     0.26%  ksoftirqd/0      [kernel.kallsyms]  [k] bpf_skb_load_helper_16

So the performance seems to be slightly worse with the patch, for
reasons that are not immediately apparent from perf, as far as I can
tell. If I just look at dsa_switch_rcv, I see there is a decrease in CPU
cycles from 1.01% to 0.83%, but that doesn't reflect in the throughput I
see for some reason.

(also please ignore some oddities in the perf reports like
"enetc_pci_remove", this comes from enetc_lock_mdio/enetc_unlock_mdio, I
have no idea why it gets printed like that)

So yeah, I cannot actually change my setup such that the list iteration
is more expensive than this (swp0 is the first element, swp1 is the second).
