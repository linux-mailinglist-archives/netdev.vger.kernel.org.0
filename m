Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE384A8375
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350369AbiBCMAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350365AbiBCMA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:00:29 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE8C061714;
        Thu,  3 Feb 2022 04:00:29 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id d186so2084319pgc.9;
        Thu, 03 Feb 2022 04:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3yzQdnp6hIr3Gf3mJOVKEBUzI+A+dvxPGyrCfuhesHQ=;
        b=eZJ5Duttf+LiLSOFgmo4wo235FS0ZkODlITXB8uU3/mnNT10fXFFZ0HmptjseMbPZE
         PoF9WrLF2mHrht2cvXnrevTR+Ve8St1zV2O32Bea8aH13uGflxeNqtIkwU9NmJLhOq3a
         eZ1DRPHx5OT97CVDqvnJEJpVXnnA0/occvdX18M/VMtnMsOqtMrA34BK1sToV8xf1GxE
         BD2v7iJARJs9JNtg/9sseteIbIF9UUcsDjpERwZCzD0EcQ0XjV62npFJYLd/wQcLHcBC
         DBNAowk0KEmbgXHslo3ogNEyq0sjDTcLEA/Va04+3YeveCmqxSyjN0VmjN50WNb8FgEe
         yoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3yzQdnp6hIr3Gf3mJOVKEBUzI+A+dvxPGyrCfuhesHQ=;
        b=V5Gu6Ok5Vk59laqxP1LRARQFKzPUChRs1swdI9NbKSJ83whL9F7TviHiEevUfDpkd/
         vWsMYXokfj+NiCAqZ60+VWgOdQmne8eFwMP2KJ+g8Ut07afWhseo3TjuQLFpXAZDtm6X
         hix9b+94fchFyLLNXFp4ARV/jd1chfEdydTfWmd7mMRAwrCAJeMyhk3LXt2qlz0zITPw
         2huG6GWGkMuMKlEkzbdCHtJIjJWMvwqWHZKIALRZCvy7eHl6KepORzlQZY9mTZzxUrwE
         ldPfAm2HF2jZs5bYmZp0mDTTLxB0gt9548FWGyjHR+aCGohvkI1TrgWn04UKJbWPUH5/
         50xw==
X-Gm-Message-State: AOAM5334P0o86lA/G877EeVbzH0dm2x8f7JpHIeJBtLyHEzoakOKMlLp
        YA1cZ2MCIT1csnRdjlzroI8=
X-Google-Smtp-Source: ABdhPJwJUM6ekp22lbgG63ir8D/NHUuy6WG1cvz8sJNxae0WBLQCYS5UXPL2uLIkMUhNaAkuFEME2A==
X-Received: by 2002:a63:4182:: with SMTP id o124mr27728165pga.479.1643889628948;
        Thu, 03 Feb 2022 04:00:28 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id f12sm16506697pfc.70.2022.02.03.04.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:00:28 -0800 (PST)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: Support GRE conntrack offload
Date:   Thu,  3 Feb 2022 20:59:41 +0900
Message-Id: <20220203115941.3107572-4-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 0f4d3b9d..465643c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -258,7 +258,8 @@ struct mlx5_ct_entry {
 			return -EOPNOTSUPP;
 		}
 	} else {
-		return -EOPNOTSUPP;
+		if (tuple->ip_proto != IPPROTO_GRE)
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -807,7 +808,11 @@ struct mlx5_ct_entry {
 	attr->dest_chain = 0;
 	attr->dest_ft = mlx5e_tc_post_act_get_ft(ct_priv->post_act);
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
-	attr->outer_match_level = MLX5_MATCH_L4;
+	if (entry->tuple.ip_proto == IPPROTO_TCP ||
+	    entry->tuple.ip_proto == IPPROTO_UDP)
+		attr->outer_match_level = MLX5_MATCH_L4;
+	else
+		attr->outer_match_level = MLX5_MATCH_L3;
 	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
@@ -1224,16 +1229,20 @@ static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
 	struct flow_keys flow_keys;
 
 	skb_reset_network_header(skb);
-	skb_flow_dissect_flow_keys(skb, &flow_keys, 0);
+	skb_flow_dissect_flow_keys(skb, &flow_keys, FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
 
 	tuple->zone = zone;
 
 	if (flow_keys.basic.ip_proto != IPPROTO_TCP &&
-	    flow_keys.basic.ip_proto != IPPROTO_UDP)
+	    flow_keys.basic.ip_proto != IPPROTO_UDP &&
+	    flow_keys.basic.ip_proto != IPPROTO_GRE)
 		return false;
 
-	tuple->port.src = flow_keys.ports.src;
-	tuple->port.dst = flow_keys.ports.dst;
+	if (flow_keys.basic.ip_proto == IPPROTO_TCP ||
+	    flow_keys.basic.ip_proto == IPPROTO_UDP) {
+		tuple->port.src = flow_keys.ports.src;
+		tuple->port.dst = flow_keys.ports.dst;
+	}
 	tuple->n_proto = flow_keys.basic.n_proto;
 	tuple->ip_proto = flow_keys.basic.ip_proto;
 
-- 
1.8.3.1

