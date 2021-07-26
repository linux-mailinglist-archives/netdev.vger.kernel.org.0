Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB9C3D5C2F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhGZOMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:35 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47844
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234748AbhGZOML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:11 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 5C90C3F0F9
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311158;
        bh=g1LkV8DDccEtDXpQgmRL/I/BZfgYC4JOs0tKKXQ3AwE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=P2lmyo9vRMyNSHzd5M6h0d8tIDUJVe9jBqwp/1T8uMm9nKoLmh/r4Ul/ur6J5rKKX
         wN19DpMjL1FUUbS0M3zSJb11PFEWbs26FSfrxdHzOONlyl4PI6tbOwRQqesZgYFPL7
         MeRA2CZfRdRbJWw/oqrjf67p9/y/jwx0dC+w9oGykZUlzHI06eygOdh+Y/0MS12C63
         /RpxU0gsrFSCOsHDK16UWsdT8YYSKo7WEaEPSPQQh6oEV1/Hsy6QUf9+r3Ah1XbGXy
         p9mc/qoSGiZoT27qsGC16yarHvUlKqceEhAcoQdJs/iIK1E/ZbpUewclMhowBXbS8j
         f1g9Ad/+CA5Sg==
Received: by mail-ej1-f72.google.com with SMTP id o17-20020a1709063591b02905127dfeb6c7so2127591ejb.16
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1LkV8DDccEtDXpQgmRL/I/BZfgYC4JOs0tKKXQ3AwE=;
        b=HH7JglzR0IZrfGAgsGRKjR9aWGqF3+xAt7h4l14b3CTxT96DVbsD3mETOgGKCKFHe8
         nyCSTrkhM1/2LGUahpJOhLOeFK2DG3BSp7afMZ21RBTx0bde6ElnbQlTGjIEKxL/yOyO
         tvdHeQJCRGeYFpf6RSOgYdHh5qj5CQmg3CRHGtlijt9NHLugFN7M0FyWiIkmKtkeZtF3
         wRg9jmEr23Q3rrLP6huf9m8WUV72hSuVk9KeipYa+dPx8cQwiLzojZH5cJSLUwg2ElBV
         Et1F9tMJy4tnLzy9VmYC8JX741woROk3AyZS49rWYRFD9zaovQI86jJR4TFTTt6Cz/z6
         z+rg==
X-Gm-Message-State: AOAM532hD/KTwF8bkoIUPpC6VO0tuzAVlhPdfZStxWyrqpGdRC9Rm1T4
        vlf6HjrOff34D0fESk2PViToUpPYrNSxBGDg34JCrDIviWxtIuFEuq+NV5jgxThKDqjJ93PcpLp
        IHPPOEh/i2rO3loKvaAnRYgHg9Ub7/mB2gQ==
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr15502148ejc.183.1627311157956;
        Mon, 26 Jul 2021 07:52:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwReAdpF33eb7FYa+LoME1aqutspOAjxBvuPlWKmS1BBT9IGKmuVRLyLI5osYQ/Wa2L9Bm6LA==
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr15502128ejc.183.1627311157679;
        Mon, 26 Jul 2021 07:52:37 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] nfc: hci: pass callback data param as pointer in nci_request()
Date:   Mon, 26 Jul 2021 16:52:23 +0200
Message-Id: <20210726145224.146006-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
References: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nci_request() receives a callback function and unsigned long data
argument "opt" which is passed to the callback.  Almost all of the
nci_request() callers pass pointer to a stack variable as data argument.
Only few pass scalar value (e.g. u8).

All such callbacks do not modify passed data argument and in previous
commit they were made as const.  However passing pointers via unsigned
long removes the const annotation.  The callback could simply cast
unsigned long to a pointer to writeable memory.

Use "const void *" as type of this "opt" argument to solve this and
prevent modifying the pointed contents.  This is also consistent with
generic pattern of passing data arguments - via "void *".  In few places
passing scalar values, use casts via "unsigned long" to suppress any
warnings.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 include/net/nfc/nci_core.h |   4 +-
 net/nfc/nci/core.c         | 102 ++++++++++++++++++-------------------
 net/nfc/nci/hci.c          |  16 +++---
 3 files changed, 58 insertions(+), 64 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 4770a81f4aa7..a964daedc17b 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -276,8 +276,8 @@ int nci_register_device(struct nci_dev *ndev);
 void nci_unregister_device(struct nci_dev *ndev);
 int nci_request(struct nci_dev *ndev,
 		void (*req)(struct nci_dev *ndev,
-			    unsigned long opt),
-		unsigned long opt, __u32 timeout);
+			    const void *opt),
+		const void *opt, __u32 timeout);
 int nci_prop_cmd(struct nci_dev *ndev, __u8 oid, size_t len,
 		 const __u8 *payload);
 int nci_core_cmd(struct nci_dev *ndev, __u16 opcode, size_t len,
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 774ddf957388..a17635612bcc 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -95,8 +95,8 @@ static void nci_req_cancel(struct nci_dev *ndev, int err)
 
 /* Execute request and wait for completion. */
 static int __nci_request(struct nci_dev *ndev,
-			 void (*req)(struct nci_dev *ndev, unsigned long opt),
-			 unsigned long opt, __u32 timeout)
+			 void (*req)(struct nci_dev *ndev, const void *opt),
+			 const void *opt, __u32 timeout)
 {
 	int rc = 0;
 	long completion_rc;
@@ -139,8 +139,8 @@ static int __nci_request(struct nci_dev *ndev,
 
 inline int nci_request(struct nci_dev *ndev,
 		       void (*req)(struct nci_dev *ndev,
-				   unsigned long opt),
-		       unsigned long opt, __u32 timeout)
+				   const void *opt),
+		       const void *opt, __u32 timeout)
 {
 	int rc;
 
@@ -155,7 +155,7 @@ inline int nci_request(struct nci_dev *ndev,
 	return rc;
 }
 
-static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_reset_req(struct nci_dev *ndev, const void *opt)
 {
 	struct nci_core_reset_cmd cmd;
 
@@ -163,17 +163,17 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
 	nci_send_cmd(ndev, NCI_OP_CORE_RESET_CMD, 1, &cmd);
 }
 
-static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_init_req(struct nci_dev *ndev, const void *opt)
 {
 	u8 plen = 0;
 
 	if (opt)
 		plen = sizeof(struct nci_core_init_v2_cmd);
 
-	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, plen, (void *)opt);
+	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, plen, opt);
 }
 
-static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_init_complete_req(struct nci_dev *ndev, const void *opt)
 {
 	struct nci_rf_disc_map_cmd cmd;
 	struct disc_map_config *cfg = cmd.mapping_configs;
@@ -215,10 +215,9 @@ struct nci_set_config_param {
 	const __u8	*val;
 };
 
-static void nci_set_config_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_set_config_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_set_config_param *param =
-		(struct nci_set_config_param *)opt;
+	const struct nci_set_config_param *param = opt;
 	struct nci_core_set_config_cmd cmd;
 
 	BUG_ON(param->len > NCI_MAX_PARAM_LEN);
@@ -236,10 +235,9 @@ struct nci_rf_discover_param {
 	__u32	tm_protocols;
 };
 
-static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_rf_discover_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_rf_discover_param *param =
-		(struct nci_rf_discover_param *)opt;
+	const struct nci_rf_discover_param *param = opt;
 	struct nci_rf_disc_cmd cmd;
 
 	cmd.num_disc_configs = 0;
@@ -302,10 +300,9 @@ struct nci_rf_discover_select_param {
 	__u8	rf_protocol;
 };
 
-static void nci_rf_discover_select_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_rf_discover_select_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_rf_discover_select_param *param =
-		(struct nci_rf_discover_select_param *)opt;
+	const struct nci_rf_discover_select_param *param = opt;
 	struct nci_rf_discover_select_cmd cmd;
 
 	cmd.rf_discovery_id = param->rf_discovery_id;
@@ -329,11 +326,11 @@ static void nci_rf_discover_select_req(struct nci_dev *ndev, unsigned long opt)
 		     sizeof(struct nci_rf_discover_select_cmd), &cmd);
 }
 
-static void nci_rf_deactivate_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_rf_deactivate_req(struct nci_dev *ndev, const void *opt)
 {
 	struct nci_rf_deactivate_cmd cmd;
 
-	cmd.type = opt;
+	cmd.type = (unsigned long)opt;
 
 	nci_send_cmd(ndev, NCI_OP_RF_DEACTIVATE_CMD,
 		     sizeof(struct nci_rf_deactivate_cmd), &cmd);
@@ -345,10 +342,9 @@ struct nci_cmd_param {
 	const __u8 *payload;
 };
 
-static void nci_generic_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_generic_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_cmd_param *param =
-		(struct nci_cmd_param *)opt;
+	const struct nci_cmd_param *param = opt;
 
 	nci_send_cmd(ndev, param->opcode, param->len, param->payload);
 }
@@ -361,7 +357,7 @@ int nci_prop_cmd(struct nci_dev *ndev, __u8 oid, size_t len, const __u8 *payload
 	param.len = len;
 	param.payload = payload;
 
-	return __nci_request(ndev, nci_generic_req, (unsigned long)&param,
+	return __nci_request(ndev, nci_generic_req, &param,
 			     msecs_to_jiffies(NCI_CMD_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_prop_cmd);
@@ -375,7 +371,7 @@ int nci_core_cmd(struct nci_dev *ndev, __u16 opcode, size_t len,
 	param.len = len;
 	param.payload = payload;
 
-	return __nci_request(ndev, nci_generic_req, (unsigned long)&param,
+	return __nci_request(ndev, nci_generic_req, &param,
 			     msecs_to_jiffies(NCI_CMD_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_core_cmd);
@@ -399,9 +395,9 @@ struct nci_loopback_data {
 	struct sk_buff *data;
 };
 
-static void nci_send_data_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_send_data_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_loopback_data *data = (struct nci_loopback_data *)opt;
+	const struct nci_loopback_data *data = opt;
 
 	nci_send_data(ndev, data->conn_id, data->data);
 }
@@ -462,7 +458,7 @@ int nci_nfcc_loopback(struct nci_dev *ndev, const void *data, size_t data_len,
 	loopback_data.data = skb;
 
 	ndev->cur_conn_id = conn_id;
-	r = nci_request(ndev, nci_send_data_req, (unsigned long)&loopback_data,
+	r = nci_request(ndev, nci_send_data_req, &loopback_data,
 			msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	if (r == NCI_STATUS_OK && resp)
 		*resp = conn_info->rx_skb;
@@ -508,10 +504,10 @@ static int nci_open_device(struct nci_dev *ndev)
 			.feature1 = NCI_FEATURE_DISABLE,
 			.feature2 = NCI_FEATURE_DISABLE
 		};
-		unsigned long opt = 0;
+		const void *opt = NULL;
 
 		if (ndev->nci_ver & NCI_VER_2_MASK)
-			opt = (unsigned long)&nci_init_v2_cmd;
+			opt = &nci_init_v2_cmd;
 
 		rc = __nci_request(ndev, nci_init_req, opt,
 				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
@@ -637,15 +633,15 @@ int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, const __u8 *val)
 	param.len = len;
 	param.val = val;
 
-	return __nci_request(ndev, nci_set_config_req, (unsigned long)&param,
+	return __nci_request(ndev, nci_set_config_req, &param,
 			     msecs_to_jiffies(NCI_SET_CONFIG_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_set_config);
 
-static void nci_nfcee_discover_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_nfcee_discover_req(struct nci_dev *ndev, const void *opt)
 {
 	struct nci_nfcee_discover_cmd cmd;
-	__u8 action = opt;
+	__u8 action = (unsigned long)opt;
 
 	cmd.discovery_action = action;
 
@@ -654,15 +650,16 @@ static void nci_nfcee_discover_req(struct nci_dev *ndev, unsigned long opt)
 
 int nci_nfcee_discover(struct nci_dev *ndev, u8 action)
 {
-	return __nci_request(ndev, nci_nfcee_discover_req, action,
+	unsigned long opt = action;
+
+	return __nci_request(ndev, nci_nfcee_discover_req, (void *)opt,
 				msecs_to_jiffies(NCI_CMD_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_nfcee_discover);
 
-static void nci_nfcee_mode_set_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_nfcee_mode_set_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_nfcee_mode_set_cmd *cmd =
-					(struct nci_nfcee_mode_set_cmd *)opt;
+	const struct nci_nfcee_mode_set_cmd *cmd = opt;
 
 	nci_send_cmd(ndev, NCI_OP_NFCEE_MODE_SET_CMD,
 		     sizeof(struct nci_nfcee_mode_set_cmd), cmd);
@@ -675,16 +672,14 @@ int nci_nfcee_mode_set(struct nci_dev *ndev, u8 nfcee_id, u8 nfcee_mode)
 	cmd.nfcee_id = nfcee_id;
 	cmd.nfcee_mode = nfcee_mode;
 
-	return __nci_request(ndev, nci_nfcee_mode_set_req,
-			     (unsigned long)&cmd,
+	return __nci_request(ndev, nci_nfcee_mode_set_req, &cmd,
 			     msecs_to_jiffies(NCI_CMD_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_nfcee_mode_set);
 
-static void nci_core_conn_create_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_core_conn_create_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct core_conn_create_data *data =
-					(struct core_conn_create_data *)opt;
+	const struct core_conn_create_data *data = opt;
 
 	nci_send_cmd(ndev, NCI_OP_CORE_CONN_CREATE_CMD, data->length, data->cmd);
 }
@@ -721,24 +716,26 @@ int nci_core_conn_create(struct nci_dev *ndev, u8 destination_type,
 	}
 	ndev->cur_dest_type = destination_type;
 
-	r = __nci_request(ndev, nci_core_conn_create_req, (unsigned long)&data,
+	r = __nci_request(ndev, nci_core_conn_create_req, &data,
 			  msecs_to_jiffies(NCI_CMD_TIMEOUT));
 	kfree(cmd);
 	return r;
 }
 EXPORT_SYMBOL(nci_core_conn_create);
 
-static void nci_core_conn_close_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_core_conn_close_req(struct nci_dev *ndev, const void *opt)
 {
-	__u8 conn_id = opt;
+	__u8 conn_id = (unsigned long)opt;
 
 	nci_send_cmd(ndev, NCI_OP_CORE_CONN_CLOSE_CMD, 1, &conn_id);
 }
 
 int nci_core_conn_close(struct nci_dev *ndev, u8 conn_id)
 {
+	unsigned long opt = conn_id;
+
 	ndev->cur_conn_id = conn_id;
-	return __nci_request(ndev, nci_core_conn_close_req, conn_id,
+	return __nci_request(ndev, nci_core_conn_close_req, (void *)opt,
 			     msecs_to_jiffies(NCI_CMD_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_core_conn_close);
@@ -758,14 +755,14 @@ static int nci_set_local_general_bytes(struct nfc_dev *nfc_dev)
 
 	param.id = NCI_PN_ATR_REQ_GEN_BYTES;
 
-	rc = nci_request(ndev, nci_set_config_req, (unsigned long)&param,
+	rc = nci_request(ndev, nci_set_config_req, &param,
 			 msecs_to_jiffies(NCI_SET_CONFIG_TIMEOUT));
 	if (rc)
 		return rc;
 
 	param.id = NCI_LN_ATR_RES_GEN_BYTES;
 
-	return nci_request(ndev, nci_set_config_req, (unsigned long)&param,
+	return nci_request(ndev, nci_set_config_req, &param,
 			   msecs_to_jiffies(NCI_SET_CONFIG_TIMEOUT));
 }
 
@@ -837,7 +834,7 @@ static int nci_start_poll(struct nfc_dev *nfc_dev,
 
 	param.im_protocols = im_protocols;
 	param.tm_protocols = tm_protocols;
-	rc = nci_request(ndev, nci_rf_discover_req, (unsigned long)&param,
+	rc = nci_request(ndev, nci_rf_discover_req, &param,
 			 msecs_to_jiffies(NCI_RF_DISC_TIMEOUT));
 
 	if (!rc)
@@ -915,8 +912,7 @@ static int nci_activate_target(struct nfc_dev *nfc_dev,
 		else
 			param.rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
 
-		rc = nci_request(ndev, nci_rf_discover_select_req,
-				 (unsigned long)&param,
+		rc = nci_request(ndev, nci_rf_discover_select_req, &param,
 				 msecs_to_jiffies(NCI_RF_DISC_SELECT_TIMEOUT));
 	}
 
@@ -931,7 +927,7 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev,
 				  __u8 mode)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
-	u8 nci_mode = NCI_DEACTIVATE_TYPE_IDLE_MODE;
+	unsigned long nci_mode = NCI_DEACTIVATE_TYPE_IDLE_MODE;
 
 	pr_debug("entry\n");
 
@@ -949,7 +945,7 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev,
 	}
 
 	if (atomic_read(&ndev->state) == NCI_POLL_ACTIVE) {
-		nci_request(ndev, nci_rf_deactivate_req, nci_mode,
+		nci_request(ndev, nci_rf_deactivate_req, (void *)nci_mode,
 			    msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 	}
 }
@@ -987,7 +983,7 @@ static int nci_dep_link_down(struct nfc_dev *nfc_dev)
 	} else {
 		if (atomic_read(&ndev->state) == NCI_LISTEN_ACTIVE ||
 		    atomic_read(&ndev->state) == NCI_DISCOVERY) {
-			nci_request(ndev, nci_rf_deactivate_req, 0,
+			nci_request(ndev, nci_rf_deactivate_req, (void *)0,
 				msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 		}
 
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 71a306b29735..163e5de7eda6 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -195,9 +195,9 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 	return i;
 }
 
-static void nci_hci_send_data_req(struct nci_dev *ndev, unsigned long opt)
+static void nci_hci_send_data_req(struct nci_dev *ndev, const void *opt)
 {
-	const struct nci_data *data = (struct nci_data *)opt;
+	const struct nci_data *data = opt;
 
 	nci_hci_send_data(ndev, data->pipe, data->cmd,
 			  data->data, data->data_len);
@@ -240,7 +240,7 @@ int nci_hci_send_cmd(struct nci_dev *ndev, u8 gate, u8 cmd,
 	data.data = param;
 	data.data_len = param_len;
 
-	r = nci_request(ndev, nci_hci_send_data_req, (unsigned long)&data,
+	r = nci_request(ndev, nci_hci_send_data_req, &data,
 			msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	if (r == NCI_STATUS_OK) {
 		message = (struct nci_hcp_message *)conn_info->rx_skb->data;
@@ -511,9 +511,8 @@ int nci_hci_open_pipe(struct nci_dev *ndev, u8 pipe)
 	data.data = NULL;
 	data.data_len = 0;
 
-	return nci_request(ndev, nci_hci_send_data_req,
-			(unsigned long)&data,
-			msecs_to_jiffies(NCI_DATA_TIMEOUT));
+	return nci_request(ndev, nci_hci_send_data_req, &data,
+			   msecs_to_jiffies(NCI_DATA_TIMEOUT));
 }
 EXPORT_SYMBOL(nci_hci_open_pipe);
 
@@ -587,8 +586,7 @@ int nci_hci_set_param(struct nci_dev *ndev, u8 gate, u8 idx,
 	data.data = tmp;
 	data.data_len = param_len + 1;
 
-	r = nci_request(ndev, nci_hci_send_data_req,
-			(unsigned long)&data,
+	r = nci_request(ndev, nci_hci_send_data_req, &data,
 			msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	if (r == NCI_STATUS_OK) {
 		message = (struct nci_hcp_message *)conn_info->rx_skb->data;
@@ -627,7 +625,7 @@ int nci_hci_get_param(struct nci_dev *ndev, u8 gate, u8 idx,
 	data.data = &idx;
 	data.data_len = 1;
 
-	r = nci_request(ndev, nci_hci_send_data_req, (unsigned long)&data,
+	r = nci_request(ndev, nci_hci_send_data_req, &data,
 			msecs_to_jiffies(NCI_DATA_TIMEOUT));
 
 	if (r == NCI_STATUS_OK) {
-- 
2.27.0

