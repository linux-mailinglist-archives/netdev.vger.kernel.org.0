Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414E8251867
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgHYMSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgHYMSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:18:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD44C061574;
        Tue, 25 Aug 2020 05:18:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b17so11704024wru.2;
        Tue, 25 Aug 2020 05:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GBdGSIj6c6kMmn2l3br70BmRSgCoyvpbeosCzLwhaiQ=;
        b=mt+pWwlwZQlDp6ICVCSpTPEZQGnBRrUH2clmqMFK951PPoSAe92uARykcXsJfFvL8x
         FNavkaDxwpxzFSwPTpG/ghNmwKeBD4fRHu7R9br4oFEKZfeeEGC8jbmJ09k32AOJO2hF
         tcbyPsUzLkeagd1mBR+ZZYfcCBoek22ZXVBcYHZUPGeALzLahOM4k3sZdAD/rRMaJ1Yd
         ZrHTYGO9ox6QCaHcOF5CYblsMF06K/EeHV+Z/KSsUnGi9OUJUqvU/i25yMbPgQU2gpAq
         weVj+l68/wN4HFtVtzzoPwaXgO1gTDVDp+W6JOTqDyqaIObVdLoV8T8LJeXXFtzW4dya
         xYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GBdGSIj6c6kMmn2l3br70BmRSgCoyvpbeosCzLwhaiQ=;
        b=bGg84KN25ijzW+npBDHAGjIlV3l0DNFp9H0xw56jUbV+HELFp64C5SLTIDFvY64sMj
         VSwJcB/7t1RfMnFIB/X73iHZG9YEFWKqzbnl3briyZG8MjeajOJzE/gflvWjjH6JaEYk
         Ihq9ZJfAQVchvSI6stMEPOEi8RNN++CLiLBQVJLeMbkEBg5aeYMMG2YW3JOc1ajfa/DT
         0U4prQaCJGcPas/v0Ib4sm2wFM5FRZTasTRJ3vrkUJOyg4AQsMy/PzrQb8SeAFYA6Ciy
         mXpEX4/5C5b9MqzI3YZdRaNr7L5r3Tj4Q5Z23bFzvMm3RoYw1E/7w5IcmsBF2wYnWuj7
         f3kA==
X-Gm-Message-State: AOAM533zTfRO7ChP9OSd44aJQRryyBDakYV+6dtHQOhCdH0eCzfa5sAZ
        XJc7tbAShT2JNAstoXuLxjY=
X-Google-Smtp-Source: ABdhPJxNB6qSXIDWHxAGA3pSFjoa6G1hLEhjjGr4vPiCTdO5j2Z5a/zdg63cY+NgNIrCU18GcZEA8g==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr9954271wrx.270.1598357893338;
        Tue, 25 Aug 2020 05:18:13 -0700 (PDT)
Received: from localhost.localdomain (dynamic-adsl-84-220-30-184.clienti.tiscali.it. [84.220.30.184])
        by smtp.gmail.com with ESMTPSA id t14sm29263718wrv.14.2020.08.25.05.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 05:18:12 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@gmail.com>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
Subject: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
Date:   Tue, 25 Aug 2020 12:17:57 +0000
Message-Id: <20200825121800.1521-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows SRv6 encapsulation to inherit the DSCP value of
the inner IPv4 packet.

This allows forwarding packet across the SRv6 fabric based on their
original traffic class.

The option is controlled through a sysctl (seg6_inherit_inner_ipv4_dscp).
The sysctl has to be set to 1 to enable this feature.

Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 include/net/netns/ipv6.h   |  1 +
 net/ipv6/seg6_iptunnel.c   | 37 ++++++++++++++++++++-----------------
 net/ipv6/sysctl_net_ipv6.c |  9 +++++++++
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5ec054473d81..6ed73951f479 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -50,6 +50,7 @@ struct netns_sysctl_ipv6 {
 	int max_dst_opts_len;
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
+	bool seg6_inherit_inner_ipv4_dscp;
 	bool skip_notify_on_dev_down;
 };
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 897fa59c47de..9cc168462e11 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -104,8 +104,7 @@ static void set_tun_src(struct net *net, struct net_device *dev,
 }
 
 /* Compute flowlabel for outer IPv6 header */
-static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
-				  struct ipv6hdr *inner_hdr)
+static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb)
 {
 	int do_flowlabel = net->ipv6.sysctl.seg6_flowlabel;
 	__be32 flowlabel = 0;
@@ -116,7 +115,7 @@ static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
 		hash = rol32(hash, 16);
 		flowlabel = (__force __be32)hash & IPV6_FLOWLABEL_MASK;
 	} else if (!do_flowlabel && skb->protocol == htons(ETH_P_IPV6)) {
-		flowlabel = ip6_flowlabel(inner_hdr);
+		flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 	}
 	return flowlabel;
 }
@@ -129,6 +128,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	struct ipv6hdr *hdr, *inner_hdr;
 	struct ipv6_sr_hdr *isrh;
 	int hdrlen, tot_len, err;
+	u8 tos = 0, hop_limit;
 	__be32 flowlabel;
 
 	hdrlen = (osrh->hdrlen + 1) << 3;
@@ -138,30 +138,33 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	if (unlikely(err))
 		return err;
 
-	inner_hdr = ipv6_hdr(skb);
-	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
-
-	skb_push(skb, tot_len);
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-	hdr = ipv6_hdr(skb);
-
 	/* inherit tc, flowlabel and hlim
 	 * hlim will be decremented in ip6_forward() afterwards and
 	 * decapsulation will overwrite inner hlim with outer hlim
 	 */
 
+	flowlabel = seg6_make_flowlabel(net, skb);
+	hop_limit = ip6_dst_hoplimit(skb_dst(skb));
+
 	if (skb->protocol == htons(ETH_P_IPV6)) {
-		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
-			     flowlabel);
-		hdr->hop_limit = inner_hdr->hop_limit;
+		inner_hdr = ipv6_hdr(skb);
+		hop_limit = inner_hdr->hop_limit;
+		tos = ip6_tclass(ip6_flowinfo(inner_hdr));
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		if (net->ipv6.sysctl.seg6_inherit_inner_ipv4_dscp)
+			tos = ip_hdr(skb)->tos;
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	} else {
-		ip6_flow_hdr(hdr, 0, flowlabel);
-		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
-
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	}
 
+	skb_push(skb, tot_len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
+	hdr = ipv6_hdr(skb);
+	ip6_flow_hdr(hdr, tos, flowlabel);
+	hdr->hop_limit = hop_limit;
 	hdr->nexthdr = NEXTHDR_ROUTING;
 
 	isrh = (void *)hdr + sizeof(*hdr);
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index fac2135aa47b..4b2cf8764524 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -159,6 +159,15 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "seg6_inherit_inner_ipv4_dscp",
+		.data		= &init_net.ipv6.sysctl.seg6_inherit_inner_ipv4_dscp,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
-- 
2.17.1

