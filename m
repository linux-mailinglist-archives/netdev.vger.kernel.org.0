Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2A43F808
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhJ2Hux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhJ2Hus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:48 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D63C061766
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:20 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t11so6277776plq.11
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d30l1HSQbKcC9GXbPG0gK5JzYOHJLV/wYfuYV64aNfM=;
        b=iAUX4MipLFI8Cb8kOGHT8OKzxwGpmR1m/GAv+3ElntN++PmWH/ifM6RdX6pulw1cP1
         ZbH0b2GlBzgfXClqX1ztG+whFI5Lr2HjOt67yOtnpATG1wrqf1dYmPEoleygPIRFsZbg
         DymDyr7cnfd+VTUZPIikFlJf5wY6CaG1cunI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d30l1HSQbKcC9GXbPG0gK5JzYOHJLV/wYfuYV64aNfM=;
        b=YNvGyuBYd3oEQromi2zQMwnjPxsmAgWMdnE2tTeQqaDjvxOXxZ9HsSIGJD0NUwtzNy
         zK6Z9r/iHUuDDINUrB7M2hrfuRorzxAXZ9wfIhejZNB6xpTiajdgdybP9mV2K4qbk5Sf
         0FwOOFggZUii6P2uy+UP3Pbm4RZTKK4s39aPC2q2VncPdCaUkr8r3A4qQEGOXZyX0iH0
         bWxgzS6w3B2USp2mKEyYp5U83/b0qHQQU7p97iV3D7ysO6P82u7Vjfh2QhUsb/lD4TNI
         43Dg1sXFQVRM6WO4NZQOr1v285l8CSRhbb2gk50rQIsrvVuyXuR9nJw+6oNXKgwtns1a
         9/4g==
X-Gm-Message-State: AOAM532yEq4zCDAwAGU02p3IDxrXQkgU/daeHqMa1RSG4kz9SNGfaprf
        84Q25dQZpAC0TwolZcL0JY8aMQ==
X-Google-Smtp-Source: ABdhPJzmY89OYkpNlBa7s7/nZyJ8AP94tOQL9d45VH+w3xPSysryCVKPdmWkvYawuwEM5GE/fc8Mng==
X-Received: by 2002:a17:902:e20c:b0:141:b7eb:18fe with SMTP id u12-20020a170902e20c00b00141b7eb18femr203078plb.81.1635493699572;
        Fri, 29 Oct 2021 00:48:19 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 06/19] bnxt_en: improve error recovery information messages
Date:   Fri, 29 Oct 2021 03:47:43 -0400
Message-Id: <1635493676-10767-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000c4ba305cf790ddb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000c4ba305cf790ddb

From: Edwin Peer <edwin.peer@broadcom.com>

The recovery election messages are often mistaken for errors. Improve
the wording to clarify the meaning of these frequent and expected
events. Also, take the first step towards more inclusive language.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 20 ++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 80fff3d8b31f..517ce16ff7eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2150,17 +2150,18 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
+		char *status_desc = "healthy";
+		u32 status;
 
 		if (!fw_health)
 			goto async_event_process_exit;
 
 		if (!EVENT_DATA1_RECOVERY_ENABLED(data1)) {
 			fw_health->enabled = false;
-			netif_info(bp, drv, bp->dev,
-				   "Error recovery info: error recovery[0]\n");
+			netif_info(bp, drv, bp->dev, "Driver recovery watchdog is disabled\n");
 			break;
 		}
-		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
+		fw_health->primary = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
@@ -2170,10 +2171,13 @@ static int bnxt_async_event_process(struct bnxt *bp,
 				bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
 		fw_health->last_fw_reset_cnt =
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		status = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+		if (status != BNXT_FW_STATUS_HEALTHY)
+			status_desc = "unhealthy";
 		netif_info(bp, drv, bp->dev,
-			   "Error recovery info: error recovery[1], master[%d], reset count[%u], health status: 0x%x\n",
-			   fw_health->master, fw_health->last_fw_reset_cnt,
-			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
+			   "Driver recovery watchdog, role: %s, firmware status: 0x%x (%s), resets: %u\n",
+			   fw_health->primary ? "primary" : "backup", status,
+			   status_desc, fw_health->last_fw_reset_cnt);
 		if (!fw_health->enabled) {
 			/* Make sure tmr_counter is set and visible to
 			 * bnxt_health_check() before setting enabled to true.
@@ -11469,7 +11473,7 @@ static void bnxt_force_fw_reset(struct bnxt *bp)
 	}
 	bnxt_fw_reset_close(bp);
 	wait_dsecs = fw_health->master_func_wait_dsecs;
-	if (fw_health->master) {
+	if (fw_health->primary) {
 		if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU)
 			wait_dsecs = 0;
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
@@ -12141,7 +12145,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			return;
 		}
 
-		if (!bp->fw_health->master) {
+		if (!bp->fw_health->primary) {
 			u32 wait_dsecs = bp->fw_health->normal_func_wait_dsecs;
 
 			bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e56f2a27c67a..16d33d00973e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1536,7 +1536,7 @@ struct bnxt_fw_health {
 	u32 last_fw_heartbeat;
 	u32 last_fw_reset_cnt;
 	u8 enabled:1;
-	u8 master:1;
+	u8 primary:1;
 	u8 fatal:1;
 	u8 status_reliable:1;
 	u8 tmr_multiplier;
-- 
2.18.1


--0000000000000c4ba305cf790ddb
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDQA857oro3Aw3smq2e7jVEzjZMhGF4q
sqM+uooKJ86kMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA846S84YzqE4F70yuHxxo6jRbN31iKucGWBu5BY9/B4ugJKntt
ewwhA2Jf4AK/MYCzjn9wDDFXlggu/zjqiBIbFzT6oeYKG+lFKNHHAiI42XKVXPIToCMLr2h3zy8W
LfCtahOqS9zMY7+LGbTgO6V8TK8eQSsyX8BcN0xyLTEYaWGUloQekKwdJsdlSrBPtx4nSPOnKn6n
JcbBlJRhHSYDC1HKLMHATiXUWmevkebD7bGlgTw+QfoXmF5BZj72QA060ECfJy+1LLnLpS3Er7+6
HS0b+cJeRSn0xrf4ui2OFxdokguRhH0h2dRGbjr0leDzoDgUlhpyfmfH3aIoQCAq
--0000000000000c4ba305cf790ddb--
