Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9E488D67
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbiAIXzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiAIXzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:55:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2283C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 15:55:05 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id q14so10545275plx.4
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 15:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mI2KRfliyGHH8+8ebvAcJ5DRn71GDH31oEAUkVY36MU=;
        b=HKEDJj047ZEfKK7WmXT4QO6kChgKWBe0oOeUdyAgdaBdUie+tnGug7igBcLHpoffZC
         bYT1FTdZG4A4PHeql8XRMrueJMWIFTxi4SBoEniGC1VCEESBTtW+4pmjOZW2nhNpD6Uu
         dz1FkyvIqYYAUpfCIVNSBfWOPoEYyX/fryysw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mI2KRfliyGHH8+8ebvAcJ5DRn71GDH31oEAUkVY36MU=;
        b=wj7OWcYH0QBkdPdatlq+W1uq3cmp7VCapP+BEmeybMPtLgUflFud8PVv605hNd9fyi
         8MVZr7H1yZqz3Yv38wwOmV53xwUyzAiYzBjPRa8ZhcyyFL+q982Jnw02Cqil/N424sW0
         Gb0QZAd0bFPB13ateXIPo1qEnNQx4QiLYVnRlUrFJCtSGQOY7uLXonqfLxla8Qf/qehX
         7AaQTIIAaOcnbs28SXVYlKf+9diOk9P5iAcPdFGaMU2pzBSFyYDbEXUaSgjVcJhKHJiD
         QTCmkBc616ppfSJZwYLB3bso236zqo+0F5TnXRwMCCQNHmDjP8L1J0IlMvGFQMgeRAkJ
         6qsw==
X-Gm-Message-State: AOAM530iBwHTbFzwGKieNq4q++nJ61llw3DT/xqky7F6y67AE2WL6WiR
        Ksj9GWXb21FSagT0RZj4n/ArIA==
X-Google-Smtp-Source: ABdhPJzIJhvTFN90rMpd8glYx3p5BSny+NT7kDcVXg8/zp3G0CNCBq4Ptt85gpc5W0ZcD76fi+bF+A==
X-Received: by 2002:a17:903:2344:b0:14a:37c4:721c with SMTP id c4-20020a170903234400b0014a37c4721cmr2438066plh.158.1641772504742;
        Sun, 09 Jan 2022 15:55:04 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ls6sm6948611pjb.33.2022.01.09.15.55.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jan 2022 15:55:04 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 1/4] bnxt_en: add dynamic debug support for HWRM messages
Date:   Sun,  9 Jan 2022 18:54:42 -0500
Message-Id: <1641772485-10421-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
References: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fd69d005d52ef23b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000fd69d005d52ef23b

From: Edwin Peer <edwin.peer@broadcom.com>

Add logging of firmware messages. These can be useful for diagnosing
issues in the field, but due to their verbosity are only appropriate
at a debug message level.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 +
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 68 +++++++++++++------
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4d7ea62e24fb..203d2ddb5504 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2086,6 +2086,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	u32 data1 = le32_to_cpu(cmpl->event_data1);
 	u32 data2 = le32_to_cpu(cmpl->event_data2);
 
+	netdev_dbg(bp->dev, "hwrm event 0x%x {0x%x, 0x%x}\n",
+		   event_id, data1, data2);
+
 	/* TODO CHIMP_FW: Define event id's for link change, error etc */
 	switch (event_id) {
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE: {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index bb7327b82d0b..a16d1ff6359c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -416,6 +416,32 @@ hwrm_update_token(struct bnxt *bp, u16 seq_id, enum bnxt_hwrm_wait_state state)
 	netdev_err(bp->dev, "Invalid hwrm seq id %d\n", seq_id);
 }
 
+static void hwrm_req_dbg(struct bnxt *bp, struct input *req)
+{
+	u32 ring = le16_to_cpu(req->cmpl_ring);
+	u32 type = le16_to_cpu(req->req_type);
+	u32 tgt = le16_to_cpu(req->target_id);
+	u32 seq = le16_to_cpu(req->seq_id);
+	char opt[32] = "\n";
+
+	if (unlikely(ring != (u16)BNXT_HWRM_NO_CMPL_RING))
+		snprintf(opt, 16, " ring %d\n", ring);
+
+	if (unlikely(tgt != BNXT_HWRM_TARGET))
+		snprintf(opt + strlen(opt) - 1, 16, " tgt 0x%x\n", tgt);
+
+	netdev_dbg(bp->dev, "sent hwrm req_type 0x%x seq id 0x%x%s",
+		   type, seq, opt);
+}
+
+#define hwrm_err(bp, ctx, fmt, ...)				       \
+	do {							       \
+		if ((ctx)->flags & BNXT_HWRM_CTX_SILENT)	       \
+			netdev_dbg((bp)->dev, fmt, __VA_ARGS__);       \
+		else						       \
+			netdev_err((bp)->dev, fmt, __VA_ARGS__);       \
+	} while (0)
+
 static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 {
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
@@ -436,8 +462,11 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		memset(ctx->resp, 0, PAGE_SIZE);
 
 	req_type = le16_to_cpu(ctx->req->req_type);
-	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET)
+	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET) {
+		netdev_dbg(bp->dev, "hwrm req_type 0x%x skipped, FW channel down\n",
+			   req_type);
 		goto exit;
+	}
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN &&
 	    msg_len > bp->hwrm_max_ext_req_len) {
@@ -490,6 +519,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	/* Ring channel doorbell */
 	writel(1, bp->bar0 + doorbell_offset);
 
+	hwrm_req_dbg(bp, ctx->req);
+
 	if (!pci_is_enabled(bp->pdev)) {
 		rc = -ENODEV;
 		goto exit;
@@ -531,9 +562,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		}
 
 		if (READ_ONCE(token->state) != BNXT_HWRM_COMPLETE) {
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
-					   le16_to_cpu(ctx->req->req_type));
+			hwrm_err(bp, ctx, "Resp cmpl intr err msg: 0x%x\n",
+				 req_type);
 			goto exit;
 		}
 		len = le16_to_cpu(READ_ONCE(ctx->resp->resp_len));
@@ -565,7 +595,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 				if (resp_seq != seen_out_of_seq) {
 					netdev_warn(bp->dev, "Discarding out of seq response: 0x%x for msg {0x%x 0x%x}\n",
 						    le16_to_cpu(resp_seq),
-						    le16_to_cpu(ctx->req->req_type),
+						    req_type,
 						    le16_to_cpu(ctx->req->seq_id));
 					seen_out_of_seq = resp_seq;
 				}
@@ -585,11 +615,9 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
 		if (i >= tmo_count) {
 timeout_abort:
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
-					   hwrm_total_timeout(i),
-					   le16_to_cpu(ctx->req->req_type),
-					   le16_to_cpu(ctx->req->seq_id), len);
+			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
+				 hwrm_total_timeout(i), req_type,
+				 le16_to_cpu(ctx->req->seq_id), len);
 			goto exit;
 		}
 
@@ -604,12 +632,9 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-					   hwrm_total_timeout(i),
-					   le16_to_cpu(ctx->req->req_type),
-					   le16_to_cpu(ctx->req->seq_id), len,
-					   *valid);
+			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
+				 hwrm_total_timeout(i), req_type,
+				 le16_to_cpu(ctx->req->seq_id), len, *valid);
 			goto exit;
 		}
 	}
@@ -620,11 +645,12 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	 */
 	*valid = 0;
 	rc = le16_to_cpu(ctx->resp->error_code);
-	if (rc && !(ctx->flags & BNXT_HWRM_CTX_SILENT)) {
-		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			   le16_to_cpu(ctx->resp->req_type),
-			   le16_to_cpu(ctx->resp->seq_id), rc);
-	}
+	if (rc == HWRM_ERR_CODE_BUSY && !(ctx->flags & BNXT_HWRM_CTX_SILENT))
+		netdev_warn(bp->dev, "FW returned busy, hwrm req_type 0x%x\n",
+			    req_type);
+	else if (rc)
+		hwrm_err(bp, ctx, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
+			 req_type, token->seq_id, rc);
 	rc = __hwrm_to_stderr(rc);
 exit:
 	if (token)
-- 
2.18.1


--000000000000fd69d005d52ef23b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAHj25zCndi/D+TPy+MbejwZpfuu231u
ZM7neI95O/jIMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTIzNTUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBCtqpI9mykGlKXTjHMXD3w9clVYYQJUEGeqwgszI+WRBhQmzOy
TPq7vFB6nR2N6rpXbYDpuMhRInZtBx9K5RzZnrZuerRqax5KwZI9D7oHG1Bf1vPxcpPSFS9otwSj
8hlOCIHmsgLZPYoW9wNVwr2O81oJY2mc+QC3B+26kQOmSdstC0pbP+VQUR9JDca461FXEdpVHysw
ffK7jEE0L9QKd5S17kqMKJsIk+2wNy5wFlzQIx9ykbA2iiG2gnAcG6VtirmyIdZt/ItSNB0vWQpa
8gnka5r+Wekfn1187W2m0z6VOkdHOrqP5sDzHbqSZ4OLAS2iI9HwBiONCd16Xp6O
--000000000000fd69d005d52ef23b--
