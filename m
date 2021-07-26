Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9BC3D5C32
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhGZOMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:41 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47846
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234750AbhGZOML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:11 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id D0F2F3F35F
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311154;
        bh=y9Kq91mi6t8RaWbdyROQw2ukHnHQAlA9a5ysysyt3/4=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=dpA4qISTo/z2yWGughnOWs3E2t/nReHftfmwSZKENvY3eCUfYhLdK2Zp+3+drUkFk
         mXECSAzTkXQ3Qp0dqTkTDmmx1+JvKkoQYw0EEmAzZ98b15Y8CxJ3sXCSqkMP9By900
         qE9uiZIA2XY4OsvA9yU3ho3f5JNKaD6pOfFpt6T+3///5ICDt7ltgmXT76MtvcxzS6
         5T9ej0aUulpx37ws5PSzjR6SmUV3guo6eJWpRQe+5E+IRTI6OUikiVbDkDOyWI063X
         S2SxUYRPNDc8o9CXBH+tNFR5J0FXWANH8n6FQpxrGG4KjbYL6IJkiPwMedz7/5hv5I
         0b+QVVPBGPXxQ==
Received: by mail-ed1-f69.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so4880370edu.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9Kq91mi6t8RaWbdyROQw2ukHnHQAlA9a5ysysyt3/4=;
        b=rQo4FzUM2SkSMl5Y/ygz7VNiT935iEYK30cRcaTXcs9C4DlDt8p5RqOYexNTsdd66o
         bMEkSSG8Zl/2VTcybZdRNNERbOLrD/AEcyyOVoynnDfPLTfMilKMPy6qzbz1Gc9NVhuU
         HgPCFMWapH4UGj6qCyZ1VdxMS717D3sd5pjL6yNdIRmzk2tFRzHlzg+QRHGGogVy2IGx
         KTIuSuVdWAOddSYyP1eaEf4VpI9NtTNTg5KZgSH2+9sx5bkn4kKB94dnm72avy0bc0Wf
         OVVwHxvyHjYoMdtNXBY9tJhLqAPaBxoJzuiY5Mnvu0G0jo1LKT63L87V0w1bxJYVwpBp
         7Ylw==
X-Gm-Message-State: AOAM530II24dsYCi9H7mVj9xjkCsrdT7tG4gRK4dscF5tsqTvVzKxxpF
        Sf9/tJffb5k/ZMaIVx6g2eo47BOhaDVYo0GiSZbvSnNLZ8odEOjbY3wGbbXG33Y6Q4ZZ2OY2hXf
        mSQ1rjX/nxSGEoZPL8iamUV/khET/lEZ0Bw==
X-Received: by 2002:a05:6402:1e91:: with SMTP id f17mr3691495edf.133.1627311154424;
        Mon, 26 Jul 2021 07:52:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX9MOkumVMGEFY1d4vD2k5pe0geK2wSSsfxonUou+CERZmZr14CWd621DX359WXUHJk8cpzA==
X-Received: by 2002:a05:6402:1e91:: with SMTP id f17mr3691478edf.133.1627311154186;
        Mon, 26 Jul 2021 07:52:34 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:33 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] nfc: constify several pointers to u8, char and sk_buff
Date:   Mon, 26 Jul 2021 16:52:20 +0200
Message-Id: <20210726145224.146006-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
References: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several functions receive pointers to u8, char or sk_buff but do not
modify the contents so make them const.  This allows doing the same for
local variables and in total makes the code a little bit safer.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 include/net/nfc/nfc.h   |  4 ++--
 net/nfc/core.c          |  4 ++--
 net/nfc/hci/llc_shdlc.c | 10 ++++-----
 net/nfc/llcp.h          |  8 +++----
 net/nfc/llcp_commands.c | 46 ++++++++++++++++++++++-------------------
 net/nfc/llcp_core.c     | 44 +++++++++++++++++++++------------------
 net/nfc/nfc.h           |  2 +-
 7 files changed, 63 insertions(+), 55 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 85b698794b14..c9ff341d57e4 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -266,7 +266,7 @@ struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
 struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 
 int nfc_set_remote_general_bytes(struct nfc_dev *dev,
-				 u8 *gt, u8 gt_len);
+				 const u8 *gt, u8 gt_len);
 u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, size_t *gb_len);
 
 int nfc_fw_download_done(struct nfc_dev *dev, const char *firmware_name,
@@ -280,7 +280,7 @@ int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 		       u8 comm_mode, u8 rf_mode);
 
 int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
-		     u8 *gb, size_t gb_len);
+		     const u8 *gb, size_t gb_len);
 int nfc_tm_deactivated(struct nfc_dev *dev);
 int nfc_tm_data_received(struct nfc_dev *dev, struct sk_buff *skb);
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 6ade54149b73..08182e209144 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -636,7 +636,7 @@ int nfc_disable_se(struct nfc_dev *dev, u32 se_idx)
 	return rc;
 }
 
-int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+int nfc_set_remote_general_bytes(struct nfc_dev *dev, const u8 *gb, u8 gb_len)
 {
 	pr_debug("dev_name=%s gb_len=%d\n", dev_name(&dev->dev), gb_len);
 
@@ -665,7 +665,7 @@ int nfc_tm_data_received(struct nfc_dev *dev, struct sk_buff *skb)
 EXPORT_SYMBOL(nfc_tm_data_received);
 
 int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
-		     u8 *gb, size_t gb_len)
+		     const u8 *gb, size_t gb_len)
 {
 	int rc;
 
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 6b747856d095..aef750d7787c 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -123,7 +123,7 @@ static bool llc_shdlc_x_lteq_y_lt_z(int x, int y, int z)
 		return ((y >= x) || (y < z)) ? true : false;
 }
 
-static struct sk_buff *llc_shdlc_alloc_skb(struct llc_shdlc *shdlc,
+static struct sk_buff *llc_shdlc_alloc_skb(const struct llc_shdlc *shdlc,
 					   int payload_len)
 {
 	struct sk_buff *skb;
@@ -137,7 +137,7 @@ static struct sk_buff *llc_shdlc_alloc_skb(struct llc_shdlc *shdlc,
 }
 
 /* immediately sends an S frame. */
-static int llc_shdlc_send_s_frame(struct llc_shdlc *shdlc,
+static int llc_shdlc_send_s_frame(const struct llc_shdlc *shdlc,
 				  enum sframe_type sframe_type, int nr)
 {
 	int r;
@@ -159,7 +159,7 @@ static int llc_shdlc_send_s_frame(struct llc_shdlc *shdlc,
 }
 
 /* immediately sends an U frame. skb may contain optional payload */
-static int llc_shdlc_send_u_frame(struct llc_shdlc *shdlc,
+static int llc_shdlc_send_u_frame(const struct llc_shdlc *shdlc,
 				  struct sk_buff *skb,
 				  enum uframe_modifier uframe_modifier)
 {
@@ -361,7 +361,7 @@ static void llc_shdlc_connect_complete(struct llc_shdlc *shdlc, int r)
 	wake_up(shdlc->connect_wq);
 }
 
-static int llc_shdlc_connect_initiate(struct llc_shdlc *shdlc)
+static int llc_shdlc_connect_initiate(const struct llc_shdlc *shdlc)
 {
 	struct sk_buff *skb;
 
@@ -377,7 +377,7 @@ static int llc_shdlc_connect_initiate(struct llc_shdlc *shdlc)
 	return llc_shdlc_send_u_frame(shdlc, skb, U_FRAME_RSET);
 }
 
-static int llc_shdlc_connect_send_ua(struct llc_shdlc *shdlc)
+static int llc_shdlc_connect_send_ua(const struct llc_shdlc *shdlc)
 {
 	struct sk_buff *skb;
 
diff --git a/net/nfc/llcp.h b/net/nfc/llcp.h
index 97853c9cefc7..d49d4bf2e37c 100644
--- a/net/nfc/llcp.h
+++ b/net/nfc/llcp.h
@@ -221,15 +221,15 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *sk, struct socket *newsock);
 
 /* TLV API */
 int nfc_llcp_parse_gb_tlv(struct nfc_llcp_local *local,
-			  u8 *tlv_array, u16 tlv_array_len);
+			  const u8 *tlv_array, u16 tlv_array_len);
 int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
-				  u8 *tlv_array, u16 tlv_array_len);
+				  const u8 *tlv_array, u16 tlv_array_len);
 
 /* Commands API */
 void nfc_llcp_recv(void *data, struct sk_buff *skb, int err);
-u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length);
+u8 *nfc_llcp_build_tlv(u8 type, const u8 *value, u8 value_length, u8 *tlv_length);
 struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdres_tlv(u8 tid, u8 sap);
-struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, char *uri,
+struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, const char *uri,
 						  size_t uri_len);
 void nfc_llcp_free_sdp_tlv(struct nfc_llcp_sdp_tlv *sdp);
 void nfc_llcp_free_sdp_tlv_list(struct hlist_head *sdp_head);
diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 475061c79c44..3c4172a5aeb5 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -15,7 +15,7 @@
 #include "nfc.h"
 #include "llcp.h"
 
-static u8 llcp_tlv_length[LLCP_TLV_MAX] = {
+static const u8 llcp_tlv_length[LLCP_TLV_MAX] = {
 	0,
 	1, /* VERSION */
 	2, /* MIUX */
@@ -29,7 +29,7 @@ static u8 llcp_tlv_length[LLCP_TLV_MAX] = {
 
 };
 
-static u8 llcp_tlv8(u8 *tlv, u8 type)
+static u8 llcp_tlv8(const u8 *tlv, u8 type)
 {
 	if (tlv[0] != type || tlv[1] != llcp_tlv_length[tlv[0]])
 		return 0;
@@ -37,7 +37,7 @@ static u8 llcp_tlv8(u8 *tlv, u8 type)
 	return tlv[2];
 }
 
-static u16 llcp_tlv16(u8 *tlv, u8 type)
+static u16 llcp_tlv16(const u8 *tlv, u8 type)
 {
 	if (tlv[0] != type || tlv[1] != llcp_tlv_length[tlv[0]])
 		return 0;
@@ -46,37 +46,37 @@ static u16 llcp_tlv16(u8 *tlv, u8 type)
 }
 
 
-static u8 llcp_tlv_version(u8 *tlv)
+static u8 llcp_tlv_version(const u8 *tlv)
 {
 	return llcp_tlv8(tlv, LLCP_TLV_VERSION);
 }
 
-static u16 llcp_tlv_miux(u8 *tlv)
+static u16 llcp_tlv_miux(const u8 *tlv)
 {
 	return llcp_tlv16(tlv, LLCP_TLV_MIUX) & 0x7ff;
 }
 
-static u16 llcp_tlv_wks(u8 *tlv)
+static u16 llcp_tlv_wks(const u8 *tlv)
 {
 	return llcp_tlv16(tlv, LLCP_TLV_WKS);
 }
 
-static u16 llcp_tlv_lto(u8 *tlv)
+static u16 llcp_tlv_lto(const u8 *tlv)
 {
 	return llcp_tlv8(tlv, LLCP_TLV_LTO);
 }
 
-static u8 llcp_tlv_opt(u8 *tlv)
+static u8 llcp_tlv_opt(const u8 *tlv)
 {
 	return llcp_tlv8(tlv, LLCP_TLV_OPT);
 }
 
-static u8 llcp_tlv_rw(u8 *tlv)
+static u8 llcp_tlv_rw(const u8 *tlv)
 {
 	return llcp_tlv8(tlv, LLCP_TLV_RW) & 0xf;
 }
 
-u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length)
+u8 *nfc_llcp_build_tlv(u8 type, const u8 *value, u8 value_length, u8 *tlv_length)
 {
 	u8 *tlv, length;
 
@@ -130,7 +130,7 @@ struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdres_tlv(u8 tid, u8 sap)
 	return sdres;
 }
 
-struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, char *uri,
+struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, const char *uri,
 						  size_t uri_len)
 {
 	struct nfc_llcp_sdp_tlv *sdreq;
@@ -190,9 +190,10 @@ void nfc_llcp_free_sdp_tlv_list(struct hlist_head *head)
 }
 
 int nfc_llcp_parse_gb_tlv(struct nfc_llcp_local *local,
-			  u8 *tlv_array, u16 tlv_array_len)
+			  const u8 *tlv_array, u16 tlv_array_len)
 {
-	u8 *tlv = tlv_array, type, length, offset = 0;
+	const u8 *tlv = tlv_array;
+	u8 type, length, offset = 0;
 
 	pr_debug("TLV array length %d\n", tlv_array_len);
 
@@ -239,9 +240,10 @@ int nfc_llcp_parse_gb_tlv(struct nfc_llcp_local *local,
 }
 
 int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
-				  u8 *tlv_array, u16 tlv_array_len)
+				  const u8 *tlv_array, u16 tlv_array_len)
 {
-	u8 *tlv = tlv_array, type, length, offset = 0;
+	const u8 *tlv = tlv_array;
+	u8 type, length, offset = 0;
 
 	pr_debug("TLV array length %d\n", tlv_array_len);
 
@@ -295,7 +297,7 @@ static struct sk_buff *llcp_add_header(struct sk_buff *pdu,
 	return pdu;
 }
 
-static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, u8 *tlv,
+static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, const u8 *tlv,
 				    u8 tlv_length)
 {
 	/* XXX Add an skb length check */
@@ -389,9 +391,10 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 {
 	struct nfc_llcp_local *local;
 	struct sk_buff *skb;
-	u8 *service_name_tlv = NULL, service_name_tlv_length;
-	u8 *miux_tlv = NULL, miux_tlv_length;
-	u8 *rw_tlv = NULL, rw_tlv_length, rw;
+	const u8 *service_name_tlv = NULL;
+	const u8 *miux_tlv = NULL;
+	const u8 *rw_tlv = NULL;
+	u8 service_name_tlv_length, miux_tlv_length,  rw_tlv_length, rw;
 	int err;
 	u16 size = 0;
 	__be16 miux;
@@ -465,8 +468,9 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
 {
 	struct nfc_llcp_local *local;
 	struct sk_buff *skb;
-	u8 *miux_tlv = NULL, miux_tlv_length;
-	u8 *rw_tlv = NULL, rw_tlv_length, rw;
+	const u8 *miux_tlv = NULL;
+	const u8 *rw_tlv = NULL;
+	u8 miux_tlv_length, rw_tlv_length, rw;
 	int err;
 	u16 size = 0;
 	__be16 miux;
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index cc997518f79d..eaeb2b1cfa6a 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -301,7 +301,7 @@ static char *wks[] = {
 	"urn:nfc:sn:snep",
 };
 
-static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
+static int nfc_llcp_wks_sap(const char *service_name, size_t service_name_len)
 {
 	int sap, num_wks;
 
@@ -325,7 +325,7 @@ static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
 
 static
 struct nfc_llcp_sock *nfc_llcp_sock_from_sn(struct nfc_llcp_local *local,
-					    u8 *sn, size_t sn_len)
+					    const u8 *sn, size_t sn_len)
 {
 	struct sock *sk;
 	struct nfc_llcp_sock *llcp_sock, *tmp_sock;
@@ -522,7 +522,7 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 {
 	u8 *gb_cur, version, version_length;
 	u8 lto_length, wks_length, miux_length;
-	u8 *version_tlv = NULL, *lto_tlv = NULL,
+	const u8 *version_tlv = NULL, *lto_tlv = NULL,
 	   *wks_tlv = NULL, *miux_tlv = NULL;
 	__be16 wks = cpu_to_be16(local->local_wks);
 	u8 gb_len = 0;
@@ -612,7 +612,7 @@ u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len)
 	return local->gb;
 }
 
-int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+int nfc_llcp_set_remote_gb(struct nfc_dev *dev, const u8 *gb, u8 gb_len)
 {
 	struct nfc_llcp_local *local;
 
@@ -639,27 +639,27 @@ int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 				     local->remote_gb_len - 3);
 }
 
-static u8 nfc_llcp_dsap(struct sk_buff *pdu)
+static u8 nfc_llcp_dsap(const struct sk_buff *pdu)
 {
 	return (pdu->data[0] & 0xfc) >> 2;
 }
 
-static u8 nfc_llcp_ptype(struct sk_buff *pdu)
+static u8 nfc_llcp_ptype(const struct sk_buff *pdu)
 {
 	return ((pdu->data[0] & 0x03) << 2) | ((pdu->data[1] & 0xc0) >> 6);
 }
 
-static u8 nfc_llcp_ssap(struct sk_buff *pdu)
+static u8 nfc_llcp_ssap(const struct sk_buff *pdu)
 {
 	return pdu->data[1] & 0x3f;
 }
 
-static u8 nfc_llcp_ns(struct sk_buff *pdu)
+static u8 nfc_llcp_ns(const struct sk_buff *pdu)
 {
 	return pdu->data[2] >> 4;
 }
 
-static u8 nfc_llcp_nr(struct sk_buff *pdu)
+static u8 nfc_llcp_nr(const struct sk_buff *pdu)
 {
 	return pdu->data[2] & 0xf;
 }
@@ -801,7 +801,7 @@ static struct nfc_llcp_sock *nfc_llcp_connecting_sock_get(struct nfc_llcp_local
 }
 
 static struct nfc_llcp_sock *nfc_llcp_sock_get_sn(struct nfc_llcp_local *local,
-						  u8 *sn, size_t sn_len)
+						  const u8 *sn, size_t sn_len)
 {
 	struct nfc_llcp_sock *llcp_sock;
 
@@ -815,9 +815,10 @@ static struct nfc_llcp_sock *nfc_llcp_sock_get_sn(struct nfc_llcp_local *local,
 	return llcp_sock;
 }
 
-static u8 *nfc_llcp_connect_sn(struct sk_buff *skb, size_t *sn_len)
+static const u8 *nfc_llcp_connect_sn(const struct sk_buff *skb, size_t *sn_len)
 {
-	u8 *tlv = &skb->data[2], type, length;
+	u8 type, length;
+	const u8 *tlv = &skb->data[2];
 	size_t tlv_array_len = skb->len - LLCP_HEADER_SIZE, offset = 0;
 
 	while (offset < tlv_array_len) {
@@ -875,7 +876,7 @@ static void nfc_llcp_recv_ui(struct nfc_llcp_local *local,
 }
 
 static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
-				  struct sk_buff *skb)
+				  const struct sk_buff *skb)
 {
 	struct sock *new_sk, *parent;
 	struct nfc_llcp_sock *sock, *new_sock;
@@ -893,7 +894,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 			goto fail;
 		}
 	} else {
-		u8 *sn;
+		const u8 *sn;
 		size_t sn_len;
 
 		sn = nfc_llcp_connect_sn(skb, &sn_len);
@@ -1112,7 +1113,7 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 }
 
 static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
-			       struct sk_buff *skb)
+			       const struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
@@ -1155,7 +1156,8 @@ static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
+static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
+			     const struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
@@ -1188,7 +1190,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-static void nfc_llcp_recv_dm(struct nfc_llcp_local *local, struct sk_buff *skb)
+static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
+			     const struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
@@ -1226,12 +1229,13 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local, struct sk_buff *skb)
 }
 
 static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
-			      struct sk_buff *skb)
+			      const struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
-	u8 dsap, ssap, *tlv, type, length, tid, sap;
+	u8 dsap, ssap, type, length, tid, sap;
+	const u8 *tlv;
 	u16 tlv_len, offset;
-	char *service_name;
+	const char *service_name;
 	size_t service_name_len;
 	struct nfc_llcp_sdp_tlv *sdp;
 	HLIST_HEAD(llc_sdres_list);
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 889fefd64e56..de2ec66d7e83 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -48,7 +48,7 @@ void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 			u8 comm_mode, u8 rf_mode);
 int nfc_llcp_register_device(struct nfc_dev *dev);
 void nfc_llcp_unregister_device(struct nfc_dev *dev);
-int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len);
+int nfc_llcp_set_remote_gb(struct nfc_dev *dev, const u8 *gb, u8 gb_len);
 u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len);
 int nfc_llcp_data_received(struct nfc_dev *dev, struct sk_buff *skb);
 struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev);
-- 
2.27.0

