Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7562662C778
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbiKPSRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbiKPSRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:17:34 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242E63BB2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36810cfa61fso167569297b3.6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTj0ksf4ppybxX4gsUR6ETSTB3xeDENh0IfC2jQuJbc=;
        b=ZfskacRb9uB3e96hPH9MhM/c1vhF+A+VH1yiFLPZ1ecqvsWh446IM223GR2POMYMM/
         rq+P3D5kyRZL+vOVpRXWeQtgUmDtZlX+zYIfxeVQBvytgbNP/Lmbwn8M13DjMwY2f/dr
         RYw5dtNiDbjGJU1lvrYrn/uRHsuMzTaFzkz2fr5OwlubS721aP1Z7UFSNo2By9qYPjMV
         Nez8Jx6JVICFK0AQfexKM8zOV593fWCQgVmfP6CIxh1xHeq8aPaET7YG247yYzf7crDW
         gXTDzZkI6ezEAn2jmuiW6kqMQwKD/RDmcN6i8/Sl+uZDshe7HbxG9951cfdXwOpx0JHu
         LkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTj0ksf4ppybxX4gsUR6ETSTB3xeDENh0IfC2jQuJbc=;
        b=ZLWR6w0VT7+uYCpHHHMoKTm3kS7FMs9q+2WBbUOKvvswXiTsrGVA2F3smKqaowspz5
         f5QHP5pjPELB5kFti+vh0DGsySMuUGyE83JhXdFTBR6iI5Q4CfKmXb3JiYWTJnZ4+oGf
         5k1DZ/nZFui6E+V4vKtBpYLfRb+TDiukmN+Z62Q9orVS0yX/HpNi8mZuIPAXKfwqTRxd
         MVsN38P+/WOMhMpoEsL2plL0MsjZT31CBnjLEw9LJYp879A4PbGarffV/fT9XeVqiEZt
         /7zF/bpgyFGgsOn4r1hxpRm9M+JPOt5vgWQOdp+YuxVMpgyit0F74TWH5xhIDWHEIPlc
         FD9w==
X-Gm-Message-State: ACrzQf24OrY4ZNBbAfoN8LR28JH0GlP6yzF8++cTo3xNv7UEkLHuDrWc
        NfCcsF6SS53NtO5vKWZnko87MBLnHy88E6e0E8kOFaWcUx3u0RQLcLuyu/oAITMtrQQ/Nvy4YA3
        Ae7NjxIxD9w//Gg4SVPVzmiqGFPT7irA6FWmAOp4tJAKuxBeOJAF47kByYM7akoAUO/8=
X-Google-Smtp-Source: AMsMyM5xXzQfEwMYhlv8X61BFsCRT/+s8TU0Y7d5JcRMmz0MPM45o93sIlnSoBYyoQQMmGRbqK6sR4NigPMBgg==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:131e:f4f:919b:71c5])
 (user=jeroendb job=sendgmr) by 2002:a81:a241:0:b0:373:5ede:1fec with SMTP id
 z1-20020a81a241000000b003735ede1fecmr41230333ywg.399.1668622651705; Wed, 16
 Nov 2022 10:17:31 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:17:25 -0800
In-Reply-To: <20221116181725.2207544-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221116181725.2207544-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116181725.2207544-3-jeroendb@google.com>
Subject: [PATCH net-next v4 2/2] gve: Handle alternate miss completions
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

