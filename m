Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6D844E3B
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfFMVRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:17:31 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:41011 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:17:30 -0400
Received: by mail-qk1-f173.google.com with SMTP id c11so339088qkk.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XF1ryB/FS0GUz6g8vYYgiLtJkcEtFDiJGXqGBvwy3Tw=;
        b=M2RwFMcIeZYmrkHLC5b3+TQ80GLdVUpNGFZLnKJGwq0FZv2u5AaGsw+o7/BUXwKDSr
         VcTgZf/2tBtWfJ43ViXu88C4p6/GS2lF81JXHkgxordmZkxxJBoXpAuGdhyhPWrefymx
         4N+/a1FNyP10s7hotjFeex1N7gkYOLs+GikA2EItYM1lRqCx70gX9xWgndkd7Iez2aCY
         3D+uKNJZ2oU+irnzDl0vy+Gy0kLCVSAHYbJSH2emwv+EjWRAbbJCEOm+j64q4D5TsJ0I
         uf7NdXQeI58PZKXnA41W9hXoGc+V+eVGyAN8lEEmP/JIGoX0t3CHDZr6umWg44R3RjAD
         arSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XF1ryB/FS0GUz6g8vYYgiLtJkcEtFDiJGXqGBvwy3Tw=;
        b=RF0oD5rGoBaGINRuuJlFDHZCoibY6P4vRCzUtcjQtgWVIygKNkT6/pmTg8Ui7M25x2
         FwLfXHjsCvKi7W13+apmNl8Nwl6DHthzUrsOb6KDgkYc/m/LyWwKtxmYJ5gP1mxuctsY
         zRelGVGNWXu6YQdupP+SjEMJ67osS/YXcsOl4DAq5axYyrFp6MhvfudLBbNhOmlwK6UB
         PPG4QS1UA5KUH3bT0VcmYPZMSPbOmDnobl08VZKGujnWf3zi2kZragbbOyE6wBLDbQrr
         IuhqHG2IfajCirkeKnIeClLpk17Eiz6enRbAGpFJSbFAOFFAI4wCBc+2+GrMEwlpYXBJ
         limw==
X-Gm-Message-State: APjAAAV0v4C12NNx/B+d3jFvJKkuV2AiBrvRuevqfAbdhbPfrST748mn
        nVJhoLpPHYlLU8cHYU2Vlu0McQ==
X-Google-Smtp-Source: APXvYqymn6UcHzZ+2zEtoPIvFbyTVHHCfGLm/FUSjSo8WGHkG3BVw9m8mZzs2MRYRRcEVptS3RMxTw==
X-Received: by 2002:a05:620a:16ba:: with SMTP id s26mr580710qkj.301.1560460648281;
        Thu, 13 Jun 2019 14:17:28 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x7sm497322qth.37.2019.06.13.14.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 14:17:27 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 3/3] nfp: flower: extend extack messaging for flower match and actions
Date:   Thu, 13 Jun 2019 14:17:11 -0700
Message-Id: <20190613211711.5505-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613211711.5505-1-jakub.kicinski@netronome.com>
References: <20190613211711.5505-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Use extack messages in flower offload when compiling match and actions
messages that will configure hardware.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/flower/action.c    | 205 ++++++++++++------
 .../ethernet/netronome/nfp/flower/lag_conf.c  |   4 +-
 .../net/ethernet/netronome/nfp/flower/main.h  |  12 +-
 .../net/ethernet/netronome/nfp/flower/match.c |  14 +-
 .../ethernet/netronome/nfp/flower/metadata.c  |  28 ++-
 .../ethernet/netronome/nfp/flower/offload.c   |  10 +-
 6 files changed, 196 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index c56e31d9f8a4..8bea3004d66c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -54,7 +54,8 @@ nfp_fl_push_vlan(struct nfp_fl_push_vlan *push_vlan,
 
 static int
 nfp_fl_pre_lag(struct nfp_app *app, const struct flow_action_entry *act,
-	       struct nfp_fl_payload *nfp_flow, int act_len)
+	       struct nfp_fl_payload *nfp_flow, int act_len,
+	       struct netlink_ext_ack *extack)
 {
 	size_t act_size = sizeof(struct nfp_fl_pre_lag);
 	struct nfp_fl_pre_lag *pre_lag;
@@ -65,8 +66,10 @@ nfp_fl_pre_lag(struct nfp_app *app, const struct flow_action_entry *act,
 	if (!out_dev || !netif_is_lag_master(out_dev))
 		return 0;
 
-	if (act_len + act_size > NFP_FL_MAX_A_SIZ)
+	if (act_len + act_size > NFP_FL_MAX_A_SIZ) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at LAG action");
 		return -EOPNOTSUPP;
+	}
 
 	/* Pre_lag action must be first on action list.
 	 * If other actions already exist they need pushed forward.
@@ -76,7 +79,7 @@ nfp_fl_pre_lag(struct nfp_app *app, const struct flow_action_entry *act,
 			nfp_flow->action_data, act_len);
 
 	pre_lag = (struct nfp_fl_pre_lag *)nfp_flow->action_data;
-	err = nfp_flower_lag_populate_pre_action(app, out_dev, pre_lag);
+	err = nfp_flower_lag_populate_pre_action(app, out_dev, pre_lag, extack);
 	if (err)
 		return err;
 
@@ -93,7 +96,8 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 	      const struct flow_action_entry *act,
 	      struct nfp_fl_payload *nfp_flow,
 	      bool last, struct net_device *in_dev,
-	      enum nfp_flower_tun_type tun_type, int *tun_out_cnt)
+	      enum nfp_flower_tun_type tun_type, int *tun_out_cnt,
+	      struct netlink_ext_ack *extack)
 {
 	size_t act_size = sizeof(struct nfp_fl_output);
 	struct nfp_flower_priv *priv = app->priv;
@@ -104,18 +108,24 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 	output->head.len_lw = act_size >> NFP_FL_LW_SIZ;
 
 	out_dev = act->dev;
-	if (!out_dev)
+	if (!out_dev) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid egress interface for mirred action");
 		return -EOPNOTSUPP;
+	}
 
 	tmp_flags = last ? NFP_FL_OUT_FLAGS_LAST : 0;
 
 	if (tun_type) {
 		/* Verify the egress netdev matches the tunnel type. */
-		if (!nfp_fl_netdev_is_tunnel_type(out_dev, tun_type))
+		if (!nfp_fl_netdev_is_tunnel_type(out_dev, tun_type)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: egress interface does not match the required tunnel type");
 			return -EOPNOTSUPP;
+		}
 
-		if (*tun_out_cnt)
+		if (*tun_out_cnt) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot offload more than one tunnel mirred output per filter");
 			return -EOPNOTSUPP;
+		}
 		(*tun_out_cnt)++;
 
 		output->flags = cpu_to_be16(tmp_flags |
@@ -127,8 +137,10 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 
 		output->flags = cpu_to_be16(tmp_flags);
 		gid = nfp_flower_lag_get_output_id(app, out_dev);
-		if (gid < 0)
+		if (gid < 0) {
+			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot find group id for LAG action");
 			return gid;
+		}
 		output->port = cpu_to_be32(NFP_FL_LAG_OUT | gid);
 	} else {
 		/* Set action output parameters. */
@@ -136,16 +148,22 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 
 		if (nfp_netdev_is_nfp_repr(in_dev)) {
 			/* Confirm ingress and egress are on same device. */
-			if (!netdev_port_same_parent_id(in_dev, out_dev))
+			if (!netdev_port_same_parent_id(in_dev, out_dev)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ingress and egress interfaces are on different devices");
 				return -EOPNOTSUPP;
+			}
 		}
 
-		if (!nfp_netdev_is_nfp_repr(out_dev))
+		if (!nfp_netdev_is_nfp_repr(out_dev)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: egress interface is not an nfp port");
 			return -EOPNOTSUPP;
+		}
 
 		output->port = cpu_to_be32(nfp_repr_get_port_id(out_dev));
-		if (!output->port)
+		if (!output->port) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid port id for egress interface");
 			return -EOPNOTSUPP;
+		}
 	}
 	nfp_flow->meta.shortcut = output->port;
 
@@ -194,7 +212,8 @@ static struct nfp_fl_pre_tunnel *nfp_fl_pre_tunnel(char *act_data, int act_len)
 
 static int
 nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
-			   const struct flow_action_entry *act)
+			   const struct flow_action_entry *act,
+			   struct netlink_ext_ack *extack)
 {
 	struct ip_tunnel_info *ip_tun = (struct ip_tunnel_info *)act->tunnel;
 	int opt_len, opt_cnt, act_start, tot_push_len;
@@ -212,20 +231,26 @@ nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
 		struct geneve_opt *opt = (struct geneve_opt *)src;
 
 		opt_cnt++;
-		if (opt_cnt > NFP_FL_MAX_GENEVE_OPT_CNT)
+		if (opt_cnt > NFP_FL_MAX_GENEVE_OPT_CNT) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed number of geneve options exceeded");
 			return -EOPNOTSUPP;
+		}
 
 		tot_push_len += sizeof(struct nfp_fl_push_geneve) +
 			       opt->length * 4;
-		if (tot_push_len > NFP_FL_MAX_GENEVE_OPT_ACT)
+		if (tot_push_len > NFP_FL_MAX_GENEVE_OPT_ACT) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at push geneve options");
 			return -EOPNOTSUPP;
+		}
 
 		opt_len -= sizeof(struct geneve_opt) + opt->length * 4;
 		src += sizeof(struct geneve_opt) + opt->length * 4;
 	}
 
-	if (*list_len + tot_push_len > NFP_FL_MAX_A_SIZ)
+	if (*list_len + tot_push_len > NFP_FL_MAX_A_SIZ) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at push geneve options");
 		return -EOPNOTSUPP;
+	}
 
 	act_start = *list_len;
 	*list_len += tot_push_len;
@@ -261,7 +286,8 @@ nfp_fl_set_ipv4_udp_tun(struct nfp_app *app,
 			const struct flow_action_entry *act,
 			struct nfp_fl_pre_tunnel *pre_tun,
 			enum nfp_flower_tun_type tun_type,
-			struct net_device *netdev)
+			struct net_device *netdev,
+			struct netlink_ext_ack *extack)
 {
 	size_t act_size = sizeof(struct nfp_fl_set_ipv4_udp_tun);
 	const struct ip_tunnel_info *ip_tun = act->tunnel;
@@ -275,8 +301,10 @@ nfp_fl_set_ipv4_udp_tun(struct nfp_app *app,
 		     NFP_FL_TUNNEL_GENEVE_OPT != TUNNEL_GENEVE_OPT);
 	if (ip_tun->options_len &&
 	    (tun_type != NFP_FL_TUNNEL_GENEVE ||
-	    !(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT)))
+	    !(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT))) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve options offload");
 		return -EOPNOTSUPP;
+	}
 
 	set_tun->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL;
 	set_tun->head.len_lw = act_size >> NFP_FL_LW_SIZ;
@@ -316,8 +344,10 @@ nfp_fl_set_ipv4_udp_tun(struct nfp_app *app,
 	set_tun->tos = ip_tun->key.tos;
 
 	if (!(ip_tun->key.tun_flags & NFP_FL_TUNNEL_KEY) ||
-	    ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_IPV4_UDP_TUN_FLAGS)
+	    ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_IPV4_UDP_TUN_FLAGS) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support tunnel flag offload");
 		return -EOPNOTSUPP;
+	}
 	set_tun->tun_flags = ip_tun->key.tun_flags;
 
 	if (tun_type == NFP_FL_TUNNEL_GENEVE) {
@@ -345,18 +375,22 @@ static void nfp_fl_set_helper32(u32 value, u32 mask, u8 *p_exact, u8 *p_mask)
 
 static int
 nfp_fl_set_eth(const struct flow_action_entry *act, u32 off,
-	       struct nfp_fl_set_eth *set_eth)
+	       struct nfp_fl_set_eth *set_eth, struct netlink_ext_ack *extack)
 {
 	u32 exact, mask;
 
-	if (off + 4 > ETH_ALEN * 2)
+	if (off + 4 > ETH_ALEN * 2) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit ethernet action");
 		return -EOPNOTSUPP;
+	}
 
 	mask = ~act->mangle.mask;
 	exact = act->mangle.val;
 
-	if (exact & ~mask)
+	if (exact & ~mask) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit ethernet action");
 		return -EOPNOTSUPP;
+	}
 
 	nfp_fl_set_helper32(exact, mask, &set_eth->eth_addr_val[off],
 			    &set_eth->eth_addr_mask[off]);
@@ -377,7 +411,8 @@ struct ipv4_ttl_word {
 static int
 nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	       struct nfp_fl_set_ip4_addrs *set_ip_addr,
-	       struct nfp_fl_set_ip4_ttl_tos *set_ip_ttl_tos)
+	       struct nfp_fl_set_ip4_ttl_tos *set_ip_ttl_tos,
+	       struct netlink_ext_ack *extack)
 {
 	struct ipv4_ttl_word *ttl_word_mask;
 	struct ipv4_ttl_word *ttl_word;
@@ -389,8 +424,10 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 	mask = (__force __be32)~act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
-	if (exact & ~mask)
+	if (exact & ~mask) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 action");
 		return -EOPNOTSUPP;
+	}
 
 	switch (off) {
 	case offsetof(struct iphdr, daddr):
@@ -413,8 +450,10 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 		ttl_word_mask = (struct ipv4_ttl_word *)&mask;
 		ttl_word = (struct ipv4_ttl_word *)&exact;
 
-		if (ttl_word_mask->protocol || ttl_word_mask->check)
+		if (ttl_word_mask->protocol || ttl_word_mask->check) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 ttl action");
 			return -EOPNOTSUPP;
+		}
 
 		set_ip_ttl_tos->ipv4_ttl_mask |= ttl_word_mask->ttl;
 		set_ip_ttl_tos->ipv4_ttl &= ~ttl_word_mask->ttl;
@@ -429,8 +468,10 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 		tos_word = (struct iphdr *)&exact;
 
 		if (tos_word_mask->version || tos_word_mask->ihl ||
-		    tos_word_mask->tot_len)
+		    tos_word_mask->tot_len) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv4 tos action");
 			return -EOPNOTSUPP;
+		}
 
 		set_ip_ttl_tos->ipv4_tos_mask |= tos_word_mask->tos;
 		set_ip_ttl_tos->ipv4_tos &= ~tos_word_mask->tos;
@@ -441,6 +482,7 @@ nfp_fl_set_ip4(const struct flow_action_entry *act, u32 off,
 					      NFP_FL_LW_SIZ;
 		break;
 	default:
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported section of IPv4 header");
 		return -EOPNOTSUPP;
 	}
 
@@ -468,7 +510,8 @@ struct ipv6_hop_limit_word {
 
 static int
 nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
-				    struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl)
+				    struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl,
+				    struct netlink_ext_ack *extack)
 {
 	struct ipv6_hop_limit_word *fl_hl_mask;
 	struct ipv6_hop_limit_word *fl_hl;
@@ -478,8 +521,10 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 		fl_hl_mask = (struct ipv6_hop_limit_word *)&mask;
 		fl_hl = (struct ipv6_hop_limit_word *)&exact;
 
-		if (fl_hl_mask->nexthdr || fl_hl_mask->payload_len)
+		if (fl_hl_mask->nexthdr || fl_hl_mask->payload_len) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 hop limit action");
 			return -EOPNOTSUPP;
+		}
 
 		ip_hl_fl->ipv6_hop_limit_mask |= fl_hl_mask->hop_limit;
 		ip_hl_fl->ipv6_hop_limit &= ~fl_hl_mask->hop_limit;
@@ -488,8 +533,10 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 		break;
 	case round_down(offsetof(struct ipv6hdr, flow_lbl), 4):
 		if (mask & ~IPV6_FLOW_LABEL_MASK ||
-		    exact & ~IPV6_FLOW_LABEL_MASK)
+		    exact & ~IPV6_FLOW_LABEL_MASK) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 flow label action");
 			return -EOPNOTSUPP;
+		}
 
 		ip_hl_fl->ipv6_label_mask |= mask;
 		ip_hl_fl->ipv6_label &= ~mask;
@@ -507,7 +554,8 @@ static int
 nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	       struct nfp_fl_set_ipv6_addr *ip_dst,
 	       struct nfp_fl_set_ipv6_addr *ip_src,
-	       struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl)
+	       struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl,
+	       struct netlink_ext_ack *extack)
 {
 	__be32 exact, mask;
 	int err = 0;
@@ -517,12 +565,14 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 	mask = (__force __be32)~act->mangle.mask;
 	exact = (__force __be32)act->mangle.val;
 
-	if (exact & ~mask)
+	if (exact & ~mask) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 action");
 		return -EOPNOTSUPP;
+	}
 
 	if (off < offsetof(struct ipv6hdr, saddr)) {
 		err = nfp_fl_set_ip6_hop_limit_flow_label(off, exact, mask,
-							  ip_hl_fl);
+							  ip_hl_fl, extack);
 	} else if (off < offsetof(struct ipv6hdr, daddr)) {
 		word = (off - offsetof(struct ipv6hdr, saddr)) / sizeof(exact);
 		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_SRC, word,
@@ -533,6 +583,7 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 		nfp_fl_set_ip6_helper(NFP_FL_ACTION_OPCODE_SET_IPV6_DST, word,
 				      exact, mask, ip_dst);
 	} else {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported section of IPv6 header");
 		return -EOPNOTSUPP;
 	}
 
@@ -541,18 +592,23 @@ nfp_fl_set_ip6(const struct flow_action_entry *act, u32 off,
 
 static int
 nfp_fl_set_tport(const struct flow_action_entry *act, u32 off,
-		 struct nfp_fl_set_tport *set_tport, int opcode)
+		 struct nfp_fl_set_tport *set_tport, int opcode,
+		 struct netlink_ext_ack *extack)
 {
 	u32 exact, mask;
 
-	if (off)
+	if (off) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported section of L4 header");
 		return -EOPNOTSUPP;
+	}
 
 	mask = ~act->mangle.mask;
 	exact = act->mangle.val;
 
-	if (exact & ~mask)
+	if (exact & ~mask) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit L4 action");
 		return -EOPNOTSUPP;
+	}
 
 	nfp_fl_set_helper32(exact, mask, set_tport->tp_port_val,
 			    set_tport->tp_port_mask);
@@ -695,7 +751,8 @@ nfp_fl_commit_mangle(struct tc_cls_flower_offload *flow, char *nfp_action,
 static int
 nfp_fl_pedit(const struct flow_action_entry *act,
 	     struct tc_cls_flower_offload *flow, char *nfp_action, int *a_len,
-	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act)
+	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
+	     struct netlink_ext_ack *extack)
 {
 	enum flow_action_mangle_base htype;
 	u32 offset;
@@ -705,21 +762,22 @@ nfp_fl_pedit(const struct flow_action_entry *act,
 
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		return nfp_fl_set_eth(act, offset, &set_act->set_eth);
+		return nfp_fl_set_eth(act, offset, &set_act->set_eth, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 		return nfp_fl_set_ip4(act, offset, &set_act->set_ip_addr,
-				      &set_act->set_ip_ttl_tos);
+				      &set_act->set_ip_ttl_tos, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
 		return nfp_fl_set_ip6(act, offset, &set_act->set_ip6_dst,
 				      &set_act->set_ip6_src,
-				      &set_act->set_ip6_tc_hl_fl);
+				      &set_act->set_ip6_tc_hl_fl, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
 		return nfp_fl_set_tport(act, offset, &set_act->set_tport,
-					NFP_FL_ACTION_OPCODE_SET_TCP);
+					NFP_FL_ACTION_OPCODE_SET_TCP, extack);
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
 		return nfp_fl_set_tport(act, offset, &set_act->set_tport,
-					NFP_FL_ACTION_OPCODE_SET_UDP);
+					NFP_FL_ACTION_OPCODE_SET_UDP, extack);
 	default:
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pedit on unsupported header");
 		return -EOPNOTSUPP;
 	}
 }
@@ -730,7 +788,8 @@ nfp_flower_output_action(struct nfp_app *app,
 			 struct nfp_fl_payload *nfp_fl, int *a_len,
 			 struct net_device *netdev, bool last,
 			 enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
-			 int *out_cnt, u32 *csum_updated)
+			 int *out_cnt, u32 *csum_updated,
+			 struct netlink_ext_ack *extack)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_output *output;
@@ -739,15 +798,19 @@ nfp_flower_output_action(struct nfp_app *app,
 	/* If csum_updated has not been reset by now, it means HW will
 	 * incorrectly update csums when they are not requested.
 	 */
-	if (*csum_updated)
+	if (*csum_updated) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: set actions without updating checksums are not supported");
 		return -EOPNOTSUPP;
+	}
 
-	if (*a_len + sizeof(struct nfp_fl_output) > NFP_FL_MAX_A_SIZ)
+	if (*a_len + sizeof(struct nfp_fl_output) > NFP_FL_MAX_A_SIZ) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: mirred output increases action list size beyond the allowed maximum");
 		return -EOPNOTSUPP;
+	}
 
 	output = (struct nfp_fl_output *)&nfp_fl->action_data[*a_len];
 	err = nfp_fl_output(app, output, act, nfp_fl, last, netdev, *tun_type,
-			    tun_out_cnt);
+			    tun_out_cnt, extack);
 	if (err)
 		return err;
 
@@ -757,11 +820,13 @@ nfp_flower_output_action(struct nfp_app *app,
 		/* nfp_fl_pre_lag returns -err or size of prelag action added.
 		 * This will be 0 if it is not egressing to a lag dev.
 		 */
-		prelag_size = nfp_fl_pre_lag(app, act, nfp_fl, *a_len);
-		if (prelag_size < 0)
+		prelag_size = nfp_fl_pre_lag(app, act, nfp_fl, *a_len, extack);
+		if (prelag_size < 0) {
 			return prelag_size;
-		else if (prelag_size > 0 && (!last || *out_cnt))
+		} else if (prelag_size > 0 && (!last || *out_cnt)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: LAG action has to be last action in action list");
 			return -EOPNOTSUPP;
+		}
 
 		*a_len += prelag_size;
 	}
@@ -777,7 +842,8 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct net_device *netdev,
 		       enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
 		       int *out_cnt, u32 *csum_updated,
-		       struct nfp_flower_pedit_acts *set_act)
+		       struct nfp_flower_pedit_acts *set_act,
+		       struct netlink_ext_ack *extack)
 {
 	struct nfp_fl_set_ipv4_udp_tun *set_tun;
 	struct nfp_fl_pre_tunnel *pre_tun;
@@ -792,20 +858,23 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	case FLOW_ACTION_REDIRECT:
 		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       true, tun_type, tun_out_cnt,
-					       out_cnt, csum_updated);
+					       out_cnt, csum_updated, extack);
 		if (err)
 			return err;
 		break;
 	case FLOW_ACTION_MIRRED:
 		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       false, tun_type, tun_out_cnt,
-					       out_cnt, csum_updated);
+					       out_cnt, csum_updated, extack);
 		if (err)
 			return err;
 		break;
 	case FLOW_ACTION_VLAN_POP:
-		if (*a_len + sizeof(struct nfp_fl_pop_vlan) > NFP_FL_MAX_A_SIZ)
+		if (*a_len +
+		    sizeof(struct nfp_fl_pop_vlan) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at pop vlan");
 			return -EOPNOTSUPP;
+		}
 
 		pop_v = (struct nfp_fl_pop_vlan *)&nfp_fl->action_data[*a_len];
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_POPV);
@@ -814,8 +883,11 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		*a_len += sizeof(struct nfp_fl_pop_vlan);
 		break;
 	case FLOW_ACTION_VLAN_PUSH:
-		if (*a_len + sizeof(struct nfp_fl_push_vlan) > NFP_FL_MAX_A_SIZ)
+		if (*a_len +
+		    sizeof(struct nfp_fl_push_vlan) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at push vlan");
 			return -EOPNOTSUPP;
+		}
 
 		psh_v = (struct nfp_fl_push_vlan *)&nfp_fl->action_data[*a_len];
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
@@ -827,31 +899,37 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		const struct ip_tunnel_info *ip_tun = act->tunnel;
 
 		*tun_type = nfp_fl_get_tun_from_act_l4_port(app, act);
-		if (*tun_type == NFP_FL_TUNNEL_NONE)
+		if (*tun_type == NFP_FL_TUNNEL_NONE) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported tunnel type in action list");
 			return -EOPNOTSUPP;
+		}
 
-		if (ip_tun->mode & ~NFP_FL_SUPPORTED_TUNNEL_INFO_FLAGS)
+		if (ip_tun->mode & ~NFP_FL_SUPPORTED_TUNNEL_INFO_FLAGS) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported tunnel flags in action list");
 			return -EOPNOTSUPP;
+		}
 
 		/* Pre-tunnel action is required for tunnel encap.
 		 * This checks for next hop entries on NFP.
 		 * If none, the packet falls back before applying other actions.
 		 */
 		if (*a_len + sizeof(struct nfp_fl_pre_tunnel) +
-		    sizeof(struct nfp_fl_set_ipv4_udp_tun) > NFP_FL_MAX_A_SIZ)
+		    sizeof(struct nfp_fl_set_ipv4_udp_tun) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at tunnel encap");
 			return -EOPNOTSUPP;
+		}
 
 		pre_tun = nfp_fl_pre_tunnel(nfp_fl->action_data, *a_len);
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
 		*a_len += sizeof(struct nfp_fl_pre_tunnel);
 
-		err = nfp_fl_push_geneve_options(nfp_fl, a_len, act);
+		err = nfp_fl_push_geneve_options(nfp_fl, a_len, act, extack);
 		if (err)
 			return err;
 
 		set_tun = (void *)&nfp_fl->action_data[*a_len];
 		err = nfp_fl_set_ipv4_udp_tun(app, set_tun, act, pre_tun,
-					      *tun_type, netdev);
+					      *tun_type, netdev, extack);
 		if (err)
 			return err;
 		*a_len += sizeof(struct nfp_fl_set_ipv4_udp_tun);
@@ -862,13 +940,15 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		return 0;
 	case FLOW_ACTION_MANGLE:
 		if (nfp_fl_pedit(act, flow, &nfp_fl->action_data[*a_len],
-				 a_len, csum_updated, set_act))
+				 a_len, csum_updated, set_act, extack))
 			return -EOPNOTSUPP;
 		break;
 	case FLOW_ACTION_CSUM:
 		/* csum action requests recalc of something we have not fixed */
-		if (act->csum_flags & ~*csum_updated)
+		if (act->csum_flags & ~*csum_updated) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported csum update action in action list");
 			return -EOPNOTSUPP;
+		}
 		/* If we will correctly fix the csum we can remove it from the
 		 * csum update list. Which will later be used to check support.
 		 */
@@ -876,6 +956,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		break;
 	default:
 		/* Currently we do not handle any other actions. */
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
 		return -EOPNOTSUPP;
 	}
 
@@ -921,7 +1002,8 @@ static bool nfp_fl_check_mangle_end(struct flow_action *flow_act,
 int nfp_flower_compile_action(struct nfp_app *app,
 			      struct tc_cls_flower_offload *flow,
 			      struct net_device *netdev,
-			      struct nfp_fl_payload *nfp_flow)
+			      struct nfp_fl_payload *nfp_flow,
+			      struct netlink_ext_ack *extack)
 {
 	int act_len, act_cnt, err, tun_out_cnt, out_cnt, i;
 	struct nfp_flower_pedit_acts set_act;
@@ -942,7 +1024,8 @@ int nfp_flower_compile_action(struct nfp_app *app,
 			memset(&set_act, 0, sizeof(set_act));
 		err = nfp_flower_loop_action(app, act, flow, nfp_flow, &act_len,
 					     netdev, &tun_type, &tun_out_cnt,
-					     &out_cnt, &csum_updated, &set_act);
+					     &out_cnt, &csum_updated, &set_act,
+					     extack);
 		if (err)
 			return err;
 		act_cnt++;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index 5db838f45694..63907aeb3884 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
@@ -156,7 +156,8 @@ nfp_fl_lag_find_group_for_master_with_lag(struct nfp_fl_lag *lag,
 
 int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 				       struct net_device *master,
-				       struct nfp_fl_pre_lag *pre_act)
+				       struct nfp_fl_pre_lag *pre_act,
+				       struct netlink_ext_ack *extack)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_lag_group *group = NULL;
@@ -167,6 +168,7 @@ int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 							  master);
 	if (!group) {
 		mutex_unlock(&priv->nfp_lag.lock);
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: group does not exist for LAG action");
 		return -ENOENT;
 	}
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 40957a8dbfe6..1f165d89582d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -347,15 +347,18 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
-				  enum nfp_flower_tun_type tun_type);
+				  enum nfp_flower_tun_type tun_type,
+				  struct netlink_ext_ack *extack);
 int nfp_flower_compile_action(struct nfp_app *app,
 			      struct tc_cls_flower_offload *flow,
 			      struct net_device *netdev,
-			      struct nfp_fl_payload *nfp_flow);
+			      struct nfp_fl_payload *nfp_flow,
+			      struct netlink_ext_ack *extack);
 int nfp_compile_flow_metadata(struct nfp_app *app,
 			      struct tc_cls_flower_offload *flow,
 			      struct nfp_fl_payload *nfp_flow,
-			      struct net_device *netdev);
+			      struct net_device *netdev,
+			      struct netlink_ext_ack *extack);
 void __nfp_modify_flow_metadata(struct nfp_flower_priv *priv,
 				struct nfp_fl_payload *nfp_flow);
 int nfp_modify_flow_metadata(struct nfp_app *app,
@@ -389,7 +392,8 @@ int nfp_flower_lag_netdev_event(struct nfp_flower_priv *priv,
 bool nfp_flower_lag_unprocessed_msg(struct nfp_app *app, struct sk_buff *skb);
 int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 				       struct net_device *master,
-				       struct nfp_fl_pre_lag *pre_act);
+				       struct nfp_fl_pre_lag *pre_act,
+				       struct netlink_ext_ack *extack);
 int nfp_flower_lag_get_output_id(struct nfp_app *app,
 				 struct net_device *master);
 void nfp_flower_qos_init(struct nfp_app *app);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index bfa4bf34911d..371b5be33dc7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -54,7 +54,8 @@ nfp_flower_compile_ext_meta(struct nfp_flower_ext_meta *frame, u32 key_ext)
 
 static int
 nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
-			bool mask_version, enum nfp_flower_tun_type tun_type)
+			bool mask_version, enum nfp_flower_tun_type tun_type,
+			struct netlink_ext_ack *extack)
 {
 	if (mask_version) {
 		frame->in_port = cpu_to_be32(~0);
@@ -64,8 +65,10 @@ nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 	if (tun_type) {
 		frame->in_port = cpu_to_be32(NFP_FL_PORT_TYPE_TUN | tun_type);
 	} else {
-		if (!cmsg_port)
+		if (!cmsg_port) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid ingress interface for match offload");
 			return -EOPNOTSUPP;
+		}
 		frame->in_port = cpu_to_be32(cmsg_port);
 	}
 
@@ -324,7 +327,8 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
-				  enum nfp_flower_tun_type tun_type)
+				  enum nfp_flower_tun_type tun_type,
+				  struct netlink_ext_ack *extack)
 {
 	u32 port_id;
 	int err;
@@ -357,13 +361,13 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 
 	/* Populate Exact Port data. */
 	err = nfp_flower_compile_port((struct nfp_flower_in_port *)ext,
-				      port_id, false, tun_type);
+				      port_id, false, tun_type, extack);
 	if (err)
 		return err;
 
 	/* Populate Mask Port Data. */
 	err = nfp_flower_compile_port((struct nfp_flower_in_port *)msk,
-				      port_id, true, tun_type);
+				      port_id, true, tun_type, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 3d326efdc814..dae60961c1eb 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -292,7 +292,8 @@ nfp_check_mask_remove(struct nfp_app *app, char *mask_data, u32 mask_len,
 int nfp_compile_flow_metadata(struct nfp_app *app,
 			      struct tc_cls_flower_offload *flow,
 			      struct nfp_fl_payload *nfp_flow,
-			      struct net_device *netdev)
+			      struct net_device *netdev,
+			      struct netlink_ext_ack *extack)
 {
 	struct nfp_fl_stats_ctx_to_flow *ctx_entry;
 	struct nfp_flower_priv *priv = app->priv;
@@ -302,8 +303,10 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	int err;
 
 	err = nfp_get_stats_entry(app, &stats_cxt);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot allocate new stats context");
 		return err;
+	}
 
 	nfp_flow->meta.host_ctx_id = cpu_to_be32(stats_cxt);
 	nfp_flow->meta.host_cookie = cpu_to_be64(flow->cookie);
@@ -328,6 +331,12 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	if (!nfp_check_mask_add(app, nfp_flow->mask_data,
 				nfp_flow->meta.mask_len,
 				&nfp_flow->meta.flags, &new_mask_id)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot allocate a new mask id");
+		if (nfp_release_stats_entry(app, stats_cxt)) {
+			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release stats context");
+			err = -EINVAL;
+			goto err_remove_rhash;
+		}
 		err = -ENOENT;
 		goto err_remove_rhash;
 	}
@@ -343,6 +352,21 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 
 	check_entry = nfp_flower_search_fl_table(app, flow->cookie, netdev);
 	if (check_entry) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot offload duplicate flow entry");
+		if (nfp_release_stats_entry(app, stats_cxt)) {
+			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release stats context");
+			err = -EINVAL;
+			goto err_remove_mask;
+		}
+
+		if (!nfp_check_mask_remove(app, nfp_flow->mask_data,
+					   nfp_flow->meta.mask_len,
+					   NULL, &new_mask_id)) {
+			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release mask id");
+			err = -EINVAL;
+			goto err_remove_mask;
+		}
+
 		err = -EEXIST;
 		goto err_remove_mask;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 26d24b103317..39e6599f2bd7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -825,12 +825,14 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 {
 	struct tc_cls_flower_offload merge_tc_off;
 	struct nfp_flower_priv *priv = app->priv;
+	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *merge_flow;
 	struct nfp_fl_key_ls merge_key_ls;
 	int err;
 
 	ASSERT_RTNL();
 
+	extack = merge_tc_off.common.extack;
 	if (sub_flow1 == sub_flow2 ||
 	    nfp_flower_is_merge_flow(sub_flow1) ||
 	    nfp_flower_is_merge_flow(sub_flow2))
@@ -868,7 +870,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 
 	merge_tc_off.cookie = merge_flow->tc_flower_cookie;
 	err = nfp_compile_flow_metadata(app, &merge_tc_off, merge_flow,
-					merge_flow->ingress_dev);
+					merge_flow->ingress_dev, extack);
 	if (err)
 		goto err_unlink_sub_flow2;
 
@@ -947,15 +949,15 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	}
 
 	err = nfp_flower_compile_flow_match(app, flow, key_layer, netdev,
-					    flow_pay, tun_type);
+					    flow_pay, tun_type, extack);
 	if (err)
 		goto err_destroy_flow;
 
-	err = nfp_flower_compile_action(app, flow, netdev, flow_pay);
+	err = nfp_flower_compile_action(app, flow, netdev, flow_pay, extack);
 	if (err)
 		goto err_destroy_flow;
 
-	err = nfp_compile_flow_metadata(app, flow, flow_pay, netdev);
+	err = nfp_compile_flow_metadata(app, flow, flow_pay, netdev, extack);
 	if (err)
 		goto err_destroy_flow;
 
-- 
2.21.0

