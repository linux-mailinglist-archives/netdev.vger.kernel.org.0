Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD757251CCD
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHYQCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgHYQCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:02:46 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003AFC061574;
        Tue, 25 Aug 2020 09:02:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q14so2136727wrn.9;
        Tue, 25 Aug 2020 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GBdGSIj6c6kMmn2l3br70BmRSgCoyvpbeosCzLwhaiQ=;
        b=gHlYvvBKVBB9MbiHpJ5W2+mubNzZz9fccqFaVNiF6i65de6l84KBY2YNo/CcZBWTtU
         Hb03r9OSnU1blTHS5k2PPlxQLTuoN6jFn0wGPaLEFir468xZHzCR62Mn2QI3unQk3Rm7
         Y2mvP7GsmCKu/SKmT31Ymuy3dOw78ZpsR29AHkWlxL0tEQU/3pEvx1DErT+zPikjyOd7
         +SL1LMNDRQMwBD2hQgzVwbWL5aKOO5VVO5OEe5E1ULbsHMyP6O5ytdR5+7DuHqchJB2Q
         t+FuovH+xtHDfjx9ufsJWScZl8VhOYV1ozNHgWkDPCILhMh0rV3tXebuPVkqoeBtcfMn
         epTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GBdGSIj6c6kMmn2l3br70BmRSgCoyvpbeosCzLwhaiQ=;
        b=lyMc9kuZA2JncwBDaSXGt47FfvAdk+PU7LA5/CpPNv5jlwhL5y3e7Mi8GegMi9Rhb7
         kmabMZTEGcT/JIt9Juw/EtHULpgCo4sudBQHnLftpnigPYQVVZzHiuOxQ8ZM89GpbVsg
         gWlhmfC/f3twXYZLiBr5uz6FtovzxtaD4G1XpS4byhBZ46zgxLJcN/q6TKdHmnysgY0Z
         jmwYo+RQQkRA+ZWYqBiBPNiiZ2RbhBCfJm66rTEESRxcpsrBupO3douWjmb1bJnwIHEb
         IxH2MiswfF7+VTdYYt+PZ0wqCPRfuNC/ganPUH2MS55HmzYWEKOtC1E96iZiGzXhXhGc
         qfOA==
X-Gm-Message-State: AOAM5307rNe4Wrr0SyMHqBtQccONBS9yoUoSuJMCspIOlzdxK+osFmTa
        Gd4zcK4u8xxrXknx6lArQFk=
X-Google-Smtp-Source: ABdhPJwg1w6hC0wPfzTvlgDP5wtZeHxsrtuxW2x99xq/v63Bl0Alz7BDYKNzUJgFqZ2t6A3L2A42yQ==
X-Received: by 2002:adf:fecc:: with SMTP id q12mr11701025wrs.374.1598371364695;
        Tue, 25 Aug 2020 09:02:44 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id o2sm30070711wrj.21.2020.08.25.09.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 09:02:44 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
Subject: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
Date:   Tue, 25 Aug 2020 16:02:33 +0000
Message-Id: <20200825160236.1123-1-ahabdels@gmail.com>
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

