Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E83F62E1BC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240591AbiKQQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240766AbiKQQ1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:27:18 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4214E786EF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:27:17 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l4-20020a170903244400b00188c393fff1so1727378pls.7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iVZvfO/sWbxoP2BEQ4Dh7QZlCl5dzP6xKnDgEuPGBOM=;
        b=Vvtb8g9I9kGBx5NgcpCtpy7qNyM6KuoHymasBooYhOGovh2M+NT5BT1alupnr8FOOM
         jjwPUHa2NcG+V3k27Jo8RcsYKMCsEWZYtzp0gKh0ydvqIUie+PFIFv5YWL67iR/6lGkG
         IvFTSGKEPqi14vEOAT50f7L4sH4xLTBM3lvNrvym5k2rNqpvW18Wk0I4MTfDP9tuBZFL
         1vqpQXkEgwJFY5C/LqGisRQUErdncepPCLSOk8tKtYYNUMlxb7jyz0TxykpR3lLogIQ2
         s5PKwMFP6MimRTX02zmum8a04JdZEhJeaX6mA+lZVJApDYMCS7Oak9oBSPTctMXuajnL
         xfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iVZvfO/sWbxoP2BEQ4Dh7QZlCl5dzP6xKnDgEuPGBOM=;
        b=VqPIl25kIqE+8dJJBCvUF1PWU+4prEkd3PNcPIx+J6bFbLpwy/XGoKmXWY3Tt5VVVe
         +/9pnJ6GbtgQ3/Y5cFCZuKnrbWau7bGu/AessMBCZaNksVnHDk9/L1boQ9sLbvngcQ2R
         SS1zqtj56dnkEeVb2HR9l3XTlFcfg4xGcRIIwix5BrpvJr2H9o3WBC3VQyPnGXu9pMyf
         ARPPVdU3q+epaXPh8E2m/dvHh02z1XHlcuSoRVduQEUA0tJwHJ4lwoTrkLI8qQsYi6+i
         Tr8AwOD7b+sL8qWX14eTTOiA8+arm9vi9vskNzGpj5oN3Gb+QvCw5rVskR26xPIlGmW3
         j+TQ==
X-Gm-Message-State: ANoB5pmtP4Hz5Ikow/LZlzbVMg9WrRMjv8Ci9rxIBpwMbodh8rilyi1X
        hd4ZfoVqFX24na/w4UhA/kWwzgB0gb0v7coVR85YgxXjKEhkNtHkycM64mQtjIoG3Naszg4Jtc6
        12WZ6QeknV0/8vZ0c3bG5EkMeD3U9mMryalMhxEi1rIaKt584fHUY2SGwP7tqRqGwiwk=
X-Google-Smtp-Source: AA0mqf6f8Hmp3x2UmZqGDgMUdXj4uZPe5m/QkMqFVh+DZDCbilStgunOCPlgcNLREpUHxJV6zMVkAeln/qY92A==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:7ba7:146e:ec34:b926])
 (user=jeroendb job=sendgmr) by 2002:a62:d441:0:b0:53e:6210:96de with SMTP id
 u1-20020a62d441000000b0053e621096demr3666815pfl.58.1668702436727; Thu, 17 Nov
 2022 08:27:16 -0800 (PST)
Date:   Thu, 17 Nov 2022 08:27:01 -0800
In-Reply-To: <20221117162701.2356849-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221117162701.2356849-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117162701.2356849-3-jeroendb@google.com>
Subject: [PATCH net-next v5 2/2] gve: Handle alternate miss completions
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
 drivers/net/ethernet/google/gve/gve_adminq.h  |  4 +++-
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 +++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 20 ++++++++++++-------
 3 files changed, 21 insertions(+), 8 deletions(-)

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
index 588d64819ed5..b76143bfd594 100644
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
+							     false);
+			}
 		} else if (type == GVE_COMPL_TYPE_DQO_MISS) {
 			u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
 
@@ -972,7 +978,7 @@ int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
 						     compl_tag,
 						     &reinject_compl_bytes,
 						     &reinject_compl_pkts,
-						     /*is_reinjection=*/true);
+						     true);
 		}
 
 		tx->dqo_compl.head =
-- 
2.38.1.431.g37b22c650d-goog

