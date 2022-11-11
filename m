Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCE3625F97
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiKKQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiKKQf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:35:28 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBEE558E
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:27 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id om10-20020a17090b3a8a00b002108b078ab1so5667127pjb.9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kRT7IaEUomFF9eJv4iDntNjmNn0drnrbLUbGt3Sz26o=;
        b=mycB9QRlHKubBnLTt8Oi4NVPWwvnqZKNmXCUuFil8KdKRSitKBvokIqI4lyWn5ks//
         0XwY+yRAZFkuGIH3QjMv4uvJFmb+nvVukY76iDrR1Nq9ZAthk4rYY9ox2sOYZBdypBV/
         +OYKhG06UtubxwVceoqqXXGO+QiFtBf3lnM0sHxye7uj+4FasVRPDtTD/aWPCA+OzATZ
         Y8QiLm8SBUsVSEN1KP9yKUjHSVysrIAu0gJsDTTML68w+ecrUn25h+D9LfZra1/CX+ey
         x3eYWFLQFwJDXo5048/rRupGgK3EPSVXl+vmTmPcyoYLhNwSyA8JQAckdV+4VFNxvVai
         07Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRT7IaEUomFF9eJv4iDntNjmNn0drnrbLUbGt3Sz26o=;
        b=Q/bOy8jxDcwS448pwhP93PZ2nlEWRBjcGLNjVGHBKr4fFYad/Xo4JmzTcey7rmd44o
         iH//agnem9laYBu+tNVQ7RJrlr/3ctdXlu92NuGDsIih/Rv60/SJx4PTKpFi793ZWsHZ
         Yucd+4q+YmhfY2RgB4SNvFywiRW/ebHrlNj8hOBDskd132SkjLH97F2O29CQzfOXelRz
         55vBAjioCCSh9u5qSSMMkqOLzRK5CqSUEQZYMSsVuzj8VqLfGhEXIepIWbtGvq0lGTpb
         nq8pJhZ4scATZ4xVCWDXDQjYV9AyGmcVZXsO0QvpUHtinPu02zipe8xnbMmOGfGfZvnS
         i3sg==
X-Gm-Message-State: ANoB5pngSsykxQY/OalFtfNUoQvYqY3lO7RZAYBM1+1CczFvkFnH76mi
        0u2uJEQNd4cDFwGD0zKZBnA/Ye3JBO7u2o7ayrf2LZSLk60ETqtjJDJoIhzYdt3911EUM+4BYPX
        b6Sp1BPDKccI+egSMm6mwg1g5xa4Jf5JDhTjS3Y7YBZMSKRcAfU3/GJ4Glsn+HjU9Cn0=
X-Google-Smtp-Source: AA0mqf7zs9kmFUYElPcWhT0OEPmufQuNpdQloWoPdq+ckAQ3cotSwV0dPuIQ1cMW/EWbl1zrpQvekUkQ3ss0Tg==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a62:388a:0:b0:56c:7b59:5137 with SMTP id
 f132-20020a62388a000000b0056c7b595137mr3363973pfa.74.1668184526926; Fri, 11
 Nov 2022 08:35:26 -0800 (PST)
Date:   Fri, 11 Nov 2022 08:35:21 -0800
In-Reply-To: <20221111163521.1373687-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221111163521.1373687-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221111163521.1373687-3-jeroendb@google.com>
Subject: [PATCH net-next v2 2/2] gve: Handle alternate miss completions
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
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

