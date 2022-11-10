Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B3662485B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiKJR2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiKJR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:28:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E26226E8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:31 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020a056a000bcb00b0056c6ec11eefso1352089pfu.14
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kRT7IaEUomFF9eJv4iDntNjmNn0drnrbLUbGt3Sz26o=;
        b=kG4NPD9tgtUZzv4wlibhBW25R14Egh8I012Y1WDT2DkRhRRrs7owdCjvprEpKkHAhE
         h997c+IcJZJPeHdhmsantBagwrl2KRC76Fp2AFNcOvat1uj1h8+Ytfz0dS4lNsODrMuz
         YQMdH3mWGqTmd8kxuXwEj2mnb0w61m8rMb3FeNKJqO8RpbMb4bcgR22Zd4bxr6fAVT9t
         8KzFPHhAki21YA4/s4mOrvgLM7huB2RNgoRAVY6YWcQEuJYgSZD/cz7YI4BuUwOxscHV
         qbhbDDizf9OMsnE6jiaiCefUkTdKWAfpVgCTeHy5U9uIC9Clvq5c1kAL8cCR5z/Zxh+E
         JQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRT7IaEUomFF9eJv4iDntNjmNn0drnrbLUbGt3Sz26o=;
        b=zg7bsaJHKUO+OurOs52oNqMlA/pQskRwg1bKbMIJTCYQxAREZWXpBDKgMlxB2VbroP
         yk37me9UEWuwf4RdbH7dYOTNI3BPSCEZBoej9V4RFI9+ax8Cjg9KemM/CMv/0+dOqGtF
         RruxHqFSWgv256X9LVVA+n4VlK1YoHtSYhgBogdT88JnicpcsZkQLqFQn6mJ1tNKUJiR
         gsjsOE/zozZ72AP6RdarSFv6fKSX7+2OCbGMv1T8MHu8ZB7/guRkB5a7SrujiorwioBr
         pwib4lDIerH2pWZTsT5tQ+OEpmoPm4LmbklHAijpJrWbUQyplgk35RSwESzMd+IBDfHn
         6+Mg==
X-Gm-Message-State: ACrzQf1RvVY0HairPVGy3LrMIeuhAvmRUXWhun27csRVjTCXcXlN4TFq
        LUWptj/T7pbqYmi4jS/qWtMzonCHyWGeWv77ItufbukDdt8hOlwMUfTVL5/UPnylcy6yCZfDNwT
        iF3FDJXxXGbwDLzfY9xWZBekOy2NS7xd50THqv4m0Kx9j5J98b38Z8SWBe+xC0fmiDKs=
X-Google-Smtp-Source: AMsMyM4KIe9fFHrTNbcM2flISfBDVfnmYs57fiyhQR4xtc4TxLSRzfvDKWAKmMn8BuPbFYVAVxbWK/nAy+M/rg==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:fb53:b0:213:2173:f46a with SMTP
 id iq19-20020a17090afb5300b002132173f46amr1538536pjb.103.1668101310856; Thu,
 10 Nov 2022 09:28:30 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:28:00 -0800
In-Reply-To: <20221110172800.1228118-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221110172800.1228118-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110172800.1228118-3-jeroendb@google.com>
Subject: [PATCH net-next 2/2] Handle alternate miss completions
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

