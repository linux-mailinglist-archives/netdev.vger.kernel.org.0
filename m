Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8404B3DBAE4
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhG3Omd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:42:33 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44814
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239430AbhG3Om1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:42:27 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4ED233F047
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627656142;
        bh=1znQCNoqUlEMI5poOw0ZjBZ5wK7z3hvmMB9nUaNmREA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=rlHTXiGDL9LMViLWwjwt6z96Sp11g2NhErRoYpNsCRh4hWfEVGDrVCSZBugwl9MLa
         KIZhz3XNnaxHIaI+red80L7uAf8ajsM6gnW6dQmSp/Kf3bCLHj4HAiYUkO2o9jZKvG
         VPYwzQk8OorYBemeKBDhm9q+qd/76QaIO1HbeEU7+dOhNm0jYn2x2hKC3ff1TxliJo
         CdXw+8exC9VasWKjS5ZxJIzPnOBZeLVerrCgXZo89dyg1Be2LlUOExWvO7/FbxdQ4c
         1QB9wAkffy5ElqtjucI0agpU+F83dERyvYSFn2/RZYyThDmO+wIiAh4L9q3UAEtwKg
         1JRUszS2I0zrA==
Received: by mail-ej1-f70.google.com with SMTP id qf6-20020a1709077f06b029057e66b6665aso3192910ejc.18
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1znQCNoqUlEMI5poOw0ZjBZ5wK7z3hvmMB9nUaNmREA=;
        b=sNzQve4MqBZx2LvL1dWLR06jEG8LnYUosH+xEwwSAiM2Rsqa1RGB/8HLKTlxUt4CPn
         F4ibi4rdXCJTrcNp6kExCLLZAWHSUdBAejwg40GNi1nnQRNp8qESzZQFiLuv0Um9Nz4k
         h/0ZWAeJMaTUJzksjmk+oeOHO9OaHL0IsPJl/f0Zzfs6zpLZ8kS2Fa3MiWntpk3MvBoj
         +E/O3TuMLfaTWb+4SBjA2626Zkw7way9lS3h2o8kO/4fKF7zJHEYkcztpTrcPXJIA3RJ
         +TwGgqn065QmgDrXKbynlD+TfNv3tHSIuNDp1bBPqqdvtm0FG10RJwZ3pFcwo6eVyfLa
         0IjQ==
X-Gm-Message-State: AOAM5327r7vy9a07LFKF0OU2YjiLygSjRw20xX5nc19CiV1uedDKajNg
        GIhELpFyt3n1cyxLcUNdacqJRnB71Oq73idxP1fr/zdTUeyZlZdVknIYf6owLVISG9to4FpXfoy
        G0E4uU4kYQ91/EpwpKtXxwVfPNLzL4c9cow==
X-Received: by 2002:a50:d698:: with SMTP id r24mr3405021edi.316.1627656141873;
        Fri, 30 Jul 2021 07:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR7m5xILM6A60J/5SHUYH5rQvCwRRECUJKkYnyp+ryMs1/2V3FrotgTyAKsGYvnx0cVFsAUQ==
X-Received: by 2002:a50:d698:: with SMTP id r24mr3405014edi.316.1627656141770;
        Fri, 30 Jul 2021 07:42:21 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id z8sm626325ejd.94.2021.07.30.07.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:42:20 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] nfc: hci: cleanup unneeded spaces
Date:   Fri, 30 Jul 2021 16:42:02 +0200
Message-Id: <20210730144202.255890-8-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
References: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need for multiple spaces in variable declaration (the code does not
use them in other places).  No functional change.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/nci/core.c |  8 ++++----
 net/nfc/nci/hci.c  | 14 +++++++-------
 net/nfc/nci/ntf.c  |  4 ++--
 net/nfc/nci/rsp.c  |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 774ddf957388..80a5c2a8e9fa 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -409,7 +409,7 @@ static void nci_send_data_req(struct nci_dev *ndev, unsigned long opt)
 static void nci_nfcc_loopback_cb(void *context, struct sk_buff *skb, int err)
 {
 	struct nci_dev *ndev = (struct nci_dev *)context;
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, ndev->cur_conn_id);
 	if (!conn_info) {
@@ -1006,7 +1006,7 @@ static int nci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 
 	conn_info = ndev->rf_conn_info;
 	if (!conn_info)
@@ -1271,7 +1271,7 @@ EXPORT_SYMBOL(nci_register_device);
  */
 void nci_unregister_device(struct nci_dev *ndev)
 {
-	struct nci_conn_info    *conn_info, *n;
+	struct nci_conn_info *conn_info, *n;
 
 	nci_close_device(ndev);
 
@@ -1443,7 +1443,7 @@ int nci_core_ntf_packet(struct nci_dev *ndev, __u16 opcode,
 static void nci_tx_work(struct work_struct *work)
 {
 	struct nci_dev *ndev = container_of(work, struct nci_dev, tx_work);
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 	struct sk_buff *skb;
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, ndev->cur_conn_id);
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 71a306b29735..a8ff794a8084 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -16,11 +16,11 @@
 #include <linux/nfc.h>
 
 struct nci_data {
-	u8              conn_id;
-	u8              pipe;
-	u8              cmd;
-	const u8        *data;
-	u32             data_len;
+	u8 conn_id;
+	u8 pipe;
+	u8 cmd;
+	const u8 *data;
+	u32 data_len;
 } __packed;
 
 struct nci_hci_create_pipe_params {
@@ -363,7 +363,7 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 static void nci_hci_resp_received(struct nci_dev *ndev, u8 pipe,
 				  struct sk_buff *skb)
 {
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 
 	conn_info = ndev->hci_dev->conn_info;
 	if (!conn_info)
@@ -714,7 +714,7 @@ static int nci_hci_dev_connect_gates(struct nci_dev *ndev,
 
 int nci_hci_dev_session_init(struct nci_dev *ndev)
 {
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 	struct sk_buff *skb;
 	int r;
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index d6251363b72b..c5eacaac41ae 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -48,7 +48,7 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 					     struct sk_buff *skb)
 {
 	struct nci_core_conn_credit_ntf *ntf = (void *) skb->data;
-	struct nci_conn_info	*conn_info;
+	struct nci_conn_info *conn_info;
 	int i;
 
 	pr_debug("num_entries %d\n", ntf->num_entries);
@@ -528,7 +528,7 @@ static int nci_store_general_bytes_nfc_dep(struct nci_dev *ndev,
 static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 					     const struct sk_buff *skb)
 {
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 	struct nci_rf_intf_activated_ntf ntf;
 	const __u8 *data = skb->data;
 	int err = NCI_STATUS_OK;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index dbb0b55a1757..a2e72c003805 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -185,7 +185,7 @@ static void nci_rf_disc_map_rsp_packet(struct nci_dev *ndev,
 static void nci_rf_disc_rsp_packet(struct nci_dev *ndev,
 				   const struct sk_buff *skb)
 {
-	struct nci_conn_info    *conn_info;
+	struct nci_conn_info *conn_info;
 	__u8 status = skb->data[0];
 
 	pr_debug("status 0x%x\n", status);
-- 
2.27.0

