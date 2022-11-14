Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382F9628D80
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiKNXfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiKNXf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:35:29 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE609FD8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:29 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i71-20020a63874a000000b00476a4a5452eso849422pge.22
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTj0ksf4ppybxX4gsUR6ETSTB3xeDENh0IfC2jQuJbc=;
        b=D2OKKXnni7N1eVkMSOadaQsNIluJt3dD9ttk/EzBdmAFx0dFavJ4z32XdH+3zwC4Gu
         BrnjTUJ+lcd0cuw6X3Z0Dhqx5LC4V4VrD+uEI3Xo7+wW5gN19APKJ+ZYSVyMIxYWKZny
         Qlgje5f1bmVqIG8C5tElOzbkgrmomKhXBpRKTJOYttar3jg7HCs+ieE80CC0r3XjfsqP
         SsYKX5TnCKEweQLU0Cux6uFKDULHC32QPcEb7ndaCT2xk/cN3gTEIlsmGXmjJHDSAbZV
         qW2UDi9EfMLOXCNX4yYAXVv3y6zc3Z0Y9PKxWxqc15eh+ZREZrVGZVXGXj9ng50Z2dpG
         lOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTj0ksf4ppybxX4gsUR6ETSTB3xeDENh0IfC2jQuJbc=;
        b=cTYqH7cUZBIdSqHUTCyzMJBL3JLP/vwJNUKX9Y95ZKyJMlW5qiKdmkQiZoOpSh1XOl
         H3R0QFoCVTfB3s95LpDa8toFbHNCjzczsACCJJNoTfHsza64e7mUTdK2bY+/y0bfm+k3
         ENcykiWJI0tpm5QKpeT+iG2j8izjk+Ohm43L03u79gcfmEbtTA7QrkECwI+s9m1+YNKH
         htjZxgEPiwE43dA4RTsYk4nWrNH4e7yj+Nr4gBIjUo3EkkfwRE7MposIlPYSg9eRBuL6
         iQfl867G1Mypl5mhw/FGKOs5YE3NsUa2Z6hVYRbqK6qPdWXzkWovzershsnuJB8jyMAy
         hWHw==
X-Gm-Message-State: ANoB5plSjkRMBScxTJge9upaZeNj55QmFWY1eBsAs2W6sA0R4eH5g6Rw
        7foBP3MFlMgjQtUuNNMr0XIORBb61Dp49KjTEaJYXOLZdDWsrG6SxXdg3H/haxvf881nfHdi6NU
        N/L8FQLS6Bgc1TmZhm7F0q1eieKF7/7nYNFBo5UxCAqpBZzN+GE7UNbglpJV+J7XnWko=
X-Google-Smtp-Source: AA0mqf6XspTsfwKKr+HPM5aO+KHqV6IptflnLtDOb+VWq8FoYGt64lNI5MNTWycyyjHaiyw+u8ADpot3j7oxAQ==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a62:ee0b:0:b0:56d:c3af:2d7f with SMTP id
 e11-20020a62ee0b000000b0056dc3af2d7fmr15980389pfi.64.1668468928566; Mon, 14
 Nov 2022 15:35:28 -0800 (PST)
Date:   Mon, 14 Nov 2022 15:35:14 -0800
In-Reply-To: <20221114233514.1913116-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221114233514.1913116-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221114233514.1913116-3-jeroendb@google.com>
Subject: [PATCH net-next v3 2/2] gve: Handle alternate miss completions
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtual NIC has 2 ways of indicating a miss-path
completion. This handles the alternate.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.h   |  4 +++-
 drivers/net/ethernet/google/gve/gve_desc_dqo.h |  5 +++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c   | 18 ++++++++++++------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index b9ee8be73f96..cf29662e6ad1 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -154,6 +154,7 @@ enum gve_driver_capbility {
 	gve_driver_capability_gqi_rda = 1,
 	gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
 	gve_driver_capability_dqo_rda = 3,
+	gve_driver_capability_alt_miss_compl = 4,
 };
 
 #define GVE_CAP1(a) BIT((int)a)
@@ -164,7 +165,8 @@ enum gve_driver_capbility {
 #define GVE_DRIVER_CAPABILITY_FLAGS1 \
 	(GVE_CAP1(gve_driver_capability_gqi_qpl) | \
 	 GVE_CAP1(gve_driver_capability_gqi_rda) | \
-	 GVE_CAP1(gve_driver_capability_dqo_rda))
+	 GVE_CAP1(gve_driver_capability_dqo_rda) | \
+	 GVE_CAP1(gve_driver_capability_alt_miss_compl))
 
 #define GVE_DRIVER_CAPABILITY_FLAGS2 0x0
 #define GVE_DRIVER_CAPABILITY_FLAGS3 0x0
diff --git a/drivers/net/ethernet/google/gve/gve_desc_dqo.h b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
index e8fe9adef7f2..f79cd0591110 100644
--- a/drivers/net/ethernet/google/gve/gve_desc_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
@@ -176,6 +176,11 @@ static_assert(sizeof(struct gve_tx_compl_desc) == 8);
 #define GVE_COMPL_TYPE_DQO_MISS 0x1 /* Miss path completion */
 #define GVE_COMPL_TYPE_DQO_REINJECTION 0x3 /* Re-injection completion */
 
+/* The most significant bit in the completion tag can change the completion
+ * type from packet completion to miss path completion.
+ */
+#define GVE_ALT_MISS_COMPL_BIT BIT(15)
+
 /* Descriptor to post buffers to HW on buffer queue. */
 struct gve_rx_desc_dqo {
 	__le16 buf_id; /* ID returned in Rx completion descriptor */
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 588d64819ed5..762915c6063b 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -953,12 +953,18 @@ int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
 			atomic_set_release(&tx->dqo_compl.hw_tx_head, tx_head);
 		} else if (type == GVE_COMPL_TYPE_DQO_PKT) {
 			u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
-
-			gve_handle_packet_completion(priv, tx, !!napi,
-						     compl_tag,
-						     &pkt_compl_bytes,
-						     &pkt_compl_pkts,
-						     /*is_reinjection=*/false);
+			if (compl_tag & GVE_ALT_MISS_COMPL_BIT) {
+				compl_tag &= ~GVE_ALT_MISS_COMPL_BIT;
+				gve_handle_miss_completion(priv, tx, compl_tag,
+							   &miss_compl_bytes,
+							   &miss_compl_pkts);
+			} else {
+				gve_handle_packet_completion(priv, tx, !!napi,
+							     compl_tag,
+							     &pkt_compl_bytes,
+							     &pkt_compl_pkts,
+							     /*is_reinjection=*/false);
+			}
 		} else if (type == GVE_COMPL_TYPE_DQO_MISS) {
 			u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
 
-- 
2.38.1.431.g37b22c650d-goog

