Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8784811D51E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfLLSR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35661 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730362AbfLLSRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:17 -0500
Received: by mail-lj1-f196.google.com with SMTP id j6so3364025lja.2
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nSjcwjQ9MDiPykK5MQUkHYcte3ClNWhY1JT29VT0zAo=;
        b=s4xPmfUDtynQUlPSFwiYtmibVRWrmHC0hmG5FBRgqbdiTaU2KmKne6re0CPMNjiDV/
         bYuEeqlobJae71QCuoMnzpbBYaSIKYHq1joQzapl+NYrj7UVa/rSlD7zPc7cAA0BqoS7
         68oFq0cBVgCnN+xO9cTz5lqr4/E0H5ernlinr9XGSwwbGbkvimJQ2th96KkQ2hUl5dBm
         Y8P0muvXCOSXDvbhsnQ7XJO2raVvEb16DpRameT4UL4QmLnW3ysFw5uA9YWb8nmyzz2L
         6NSWXlEYGcqPei+2MEQrtTot/kZad8tHF08cDKB0PUljbdL5OF4XFeeBl8GWlxIUQzWs
         vQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nSjcwjQ9MDiPykK5MQUkHYcte3ClNWhY1JT29VT0zAo=;
        b=fOjy9oPK3RirH0dGx+plZ+jtT1dFrsAoDbaQqeji6x+fLp6ECQZx9b1Get//3G1FIm
         T4N+Fue27H1nrKKTplQ8JUKWku7owT/2oSWrqzTM2QqJYpvST7AHK3hpz0BJlRH/Aq9d
         6kPQqXTpZCfVxBtqAtnrCTldRdm0qKnwF1WPRvUyCHNitWGK57+O7qO9V/z4gTFj2m/I
         4qrKNwSR+jq3oRAQhxWx9E1beIC3tUc5D+pRmAPvxr2WftMjIItNQ+2gjPJ8A5HgxxL0
         6SG7UIPadk9CZaC+DkWEKbqZyu/VljeHGPbc92qdeE/rNyFclNJzfybW/zYTyJnDfnVY
         hG9w==
X-Gm-Message-State: APjAAAXdvhsTFds0jYEDX3adDBHF1gC4P3IU0UJNZxlNUQX9jaiOvF9q
        2zxAJgXcgEy04Oqd2w1wZFu4rwobnLnj80lIOC9DQXM48KJoBnUEA7BYkBRpTEZWPmydu6o/89E
        pW85F6CBXoBLeoIZKsVj64f7ZZRczJIoQFj7ODWLzztvqHhpHFe8O8jIw1hKqznaxs/fVPPFpMg
        ==
X-Google-Smtp-Source: APXvYqyMadSwZ4/esqmz9xXODF/c628OYxzTYp1lM3IIxdNWgznFdfrb4ruI37e2+XMtRNXDtMbR9A==
X-Received: by 2002:adf:9427:: with SMTP id 36mr7807192wrq.166.1576174634872;
        Thu, 12 Dec 2019 10:17:14 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:14 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 8/9] nfp: flower: support ipv6 tunnel keep-alive messages from fw
Date:   Thu, 12 Dec 2019 18:16:55 +0000
Message-Id: <1576174616-9738-9-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FW sends an update of IPv6 tunnels that are active in a given period. Use
this information to update the kernel table so that neighbour entries do
not time out when active on the NIC.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c   |  3 ++
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  1 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 62 ++++++++++++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
index 00b904e..a595ddb 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
@@ -278,6 +278,9 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 	case NFP_FLOWER_CMSG_TYPE_ACTIVE_TUNS:
 		nfp_tunnel_keep_alive(app, skb);
 		break;
+	case NFP_FLOWER_CMSG_TYPE_ACTIVE_TUNS_V6:
+		nfp_tunnel_keep_alive_v6(app, skb);
+		break;
 	case NFP_FLOWER_CMSG_TYPE_QOS_STATS:
 		nfp_flower_stats_rlim_reply(app, skb);
 		break;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 5a8ad58..9b50d76 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -574,6 +574,7 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_TUN_IPS_V6 =	22,
 	NFP_FLOWER_CMSG_TYPE_NO_NEIGH_V6 =	23,
 	NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 =	24,
+	NFP_FLOWER_CMSG_TYPE_ACTIVE_TUNS_V6 =	25,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7a46032..ddd7b7f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -425,6 +425,7 @@ nfp_tunnel_add_ipv6_off(struct nfp_app *app, struct in6_addr *ipv6);
 void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb);
 void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb);
 void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb);
+void nfp_tunnel_keep_alive_v6(struct nfp_app *app, struct sk_buff *skb);
 void nfp_flower_lag_init(struct nfp_fl_lag *lag);
 void nfp_flower_lag_cleanup(struct nfp_fl_lag *lag);
 int nfp_flower_lag_reset(struct nfp_fl_lag *lag);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 0eaaa637..4aca670 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -55,6 +55,25 @@ struct nfp_tun_active_tuns {
 };
 
 /**
+ * struct nfp_tun_active_tuns_v6 - periodic message of active IPv6 tunnels
+ * @seq:		sequence number of the message
+ * @count:		number of tunnels report in message
+ * @flags:		options part of the request
+ * @tun_info.ipv6:		dest IPv6 address of active route
+ * @tun_info.egress_port:	port the encapsulated packet egressed
+ * @tun_info:		tunnels that have sent traffic in reported period
+ */
+struct nfp_tun_active_tuns_v6 {
+	__be32 seq;
+	__be32 count;
+	__be32 flags;
+	struct route_ip_info_v6 {
+		struct in6_addr ipv6;
+		__be32 egress_port;
+	} tun_info[];
+};
+
+/**
  * struct nfp_tun_neigh - neighbour/route entry on the NFP
  * @dst_ipv4:	destination IPv4 address
  * @src_ipv4:	source IPv4 address
@@ -244,6 +263,49 @@ void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb)
 	rcu_read_unlock();
 }
 
+void nfp_tunnel_keep_alive_v6(struct nfp_app *app, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct nfp_tun_active_tuns_v6 *payload;
+	struct net_device *netdev;
+	int count, i, pay_len;
+	struct neighbour *n;
+	void *ipv6_add;
+	u32 port;
+
+	payload = nfp_flower_cmsg_get_data(skb);
+	count = be32_to_cpu(payload->count);
+	if (count > NFP_FL_IPV6_ADDRS_MAX) {
+		nfp_flower_cmsg_warn(app, "IPv6 tunnel keep-alive request exceeds max routes.\n");
+		return;
+	}
+
+	pay_len = nfp_flower_cmsg_get_data_len(skb);
+	if (pay_len != struct_size(payload, tun_info, count)) {
+		nfp_flower_cmsg_warn(app, "Corruption in tunnel keep-alive message.\n");
+		return;
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < count; i++) {
+		ipv6_add = &payload->tun_info[i].ipv6;
+		port = be32_to_cpu(payload->tun_info[i].egress_port);
+		netdev = nfp_app_dev_get(app, port, NULL);
+		if (!netdev)
+			continue;
+
+		n = neigh_lookup(&nd_tbl, ipv6_add, netdev);
+		if (!n)
+			continue;
+
+		/* Update the used timestamp of neighbour */
+		neigh_event_send(n, NULL);
+		neigh_release(n);
+	}
+	rcu_read_unlock();
+#endif
+}
+
 static int
 nfp_flower_xmit_tun_conf(struct nfp_app *app, u8 mtype, u16 plen, void *pdata,
 			 gfp_t flag)
-- 
2.7.4

