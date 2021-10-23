Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9D4384F5
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhJWTe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJWTeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46B2C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so6602516pgu.13
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jHIQlx9jjO5yDzCaZ7KKdVcTkba5a39ulfjKxvA43Is=;
        b=Ku6ekY5FsVGZXCpadAtcR+E1EZ5WZOdXWcYA0p/SIV6F/MpHl/GiG77stxjLHipgNt
         B/uvBNTg0Pgqhuw3cvPc8lKvVjJm0tukMTNZH3xcIjC7GmsEjUmBrkpJJre9gqGgem/S
         v3vWhkf89hLMj3UMK9MlezrNVq2IVPZ13miSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jHIQlx9jjO5yDzCaZ7KKdVcTkba5a39ulfjKxvA43Is=;
        b=KRsRSeA3NUghoRKd7iSRkFPCd3ylIs9AfptJkFG2ftXKFLQV4rjNKTwP7mC5tRLnNY
         qax/SZHROiT9gywhaWzvThO3BfIdZK+mjgda2j6d2KkIom/1m5Qhz5JJczhflLnNLEem
         a3DNeNV+7YRoft1inm7ZRaeaaGC8y0S45w04WqUISfuJrLdL3iz5yIg46ynwLo3to0zX
         OiEn30y2ZWTROAeGHnzHd5X1eaOB8moh9MJ1ZC0W3KXb6zf4dqUXOT5+HfUyzf47fO8G
         i2mSgueaMeq52aMgqEMQav+BJgK5/ur33OZEwpcXZqKgwW0WqkUO8V8dDsIJaPXSY4oX
         D2rw==
X-Gm-Message-State: AOAM532k3RPgUJXVR5KE3SM7a06dvhXgzTqjj8RF4bBh4/po2C8OYORd
        C3U8ZQHRPtKqlRdsU+h1vXyqlstcfeZyWg==
X-Google-Smtp-Source: ABdhPJwDQjrCs5jIvOs9YY8minvQx0pQYAgGfqyOXr8mhS1EgoHYDWTVI+EDYRztGLHK6vkOTBHNrg==
X-Received: by 2002:a05:6a00:1748:b0:44c:ca52:b261 with SMTP id j8-20020a056a00174800b0044cca52b261mr7875298pfc.17.1635017549939;
        Sat, 23 Oct 2021 12:32:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 09/19] bnxt_en: improve fw diagnose devlink health messages
Date:   Sat, 23 Oct 2021 15:31:56 -0400
Message-Id: <1635017526-16963-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004cd6a705cf0a3004"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004cd6a705cf0a3004

From: Edwin Peer <edwin.peer@broadcom.com>

Add firmware event counters as well as health state severity. In
the unhealthy state, recommend a remedy and inform the user as to
its impact.

Readability of the devlink tool's output is negatively impacted by
adding these fields to the diagnosis. The single line of text, as
rendered by devlink health diagnose, benefits from more terse
descriptions, which can be substituted without loss of clarity, even
in pretty printed JSON mode.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  19 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  25 ++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 131 ++++++++++++++----
 3 files changed, 148 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a766236d330f..d619064ab330 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2138,10 +2138,12 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			set_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state);
 		} else if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
 			type_str = "Fatal";
+			bp->fw_health->fatalities++;
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		} else if (data2 && BNXT_FW_STATUS_HEALTHY !=
 			   EVENT_DATA2_RESET_NOTIFY_FW_STATUS_CODE(data2)) {
 			type_str = "Non-fatal";
+			bp->fw_health->survivals++;
 			set_bit(BNXT_STATE_FW_NON_FATAL_COND, &bp->state);
 		}
 		netif_warn(bp, hw, bp->dev,
@@ -7604,6 +7606,7 @@ static int __bnxt_alloc_fw_health(struct bnxt *bp)
 	if (!bp->fw_health)
 		return -ENOMEM;
 
+	mutex_init(&bp->fw_health->lock);
 	return 0;
 }
 
@@ -7650,12 +7653,16 @@ static void bnxt_inv_fw_health_reg(struct bnxt *bp)
 	struct bnxt_fw_health *fw_health = bp->fw_health;
 	u32 reg_type;
 
-	if (!fw_health || !fw_health->status_reliable)
+	if (!fw_health)
 		return;
 
 	reg_type = BNXT_FW_HEALTH_REG_TYPE(fw_health->regs[BNXT_FW_HEALTH_REG]);
 	if (reg_type == BNXT_FW_HEALTH_REG_TYPE_GRC)
 		fw_health->status_reliable = false;
+
+	reg_type = BNXT_FW_HEALTH_REG_TYPE(fw_health->regs[BNXT_FW_RESET_CNT_REG]);
+	if (reg_type == BNXT_FW_HEALTH_REG_TYPE_GRC)
+		fw_health->resets_reliable = false;
 }
 
 static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
@@ -7712,6 +7719,7 @@ static int bnxt_map_fw_health_regs(struct bnxt *bp)
 	int i;
 
 	bp->fw_health->status_reliable = false;
+	bp->fw_health->resets_reliable = false;
 	/* Only pre-map the monitoring GRC registers using window 3 */
 	for (i = 0; i < 4; i++) {
 		u32 reg = fw_health->regs[i];
@@ -7725,6 +7733,7 @@ static int bnxt_map_fw_health_regs(struct bnxt *bp)
 		fw_health->mapped_regs[i] = BNXT_FW_HEALTH_WIN_OFF(reg);
 	}
 	bp->fw_health->status_reliable = true;
+	bp->fw_health->resets_reliable = true;
 	if (reg_base == 0xffffffff)
 		return 0;
 
@@ -11264,14 +11273,18 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	}
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
-	if (val == fw_health->last_fw_heartbeat)
+	if (val == fw_health->last_fw_heartbeat) {
+		fw_health->arrests++;
 		goto fw_reset;
+	}
 
 	fw_health->last_fw_heartbeat = val;
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
-	if (val != fw_health->last_fw_reset_cnt)
+	if (val != fw_health->last_fw_reset_cnt) {
+		fw_health->discoveries++;
 		goto fw_reset;
+	}
 
 	fw_health->tmr_counter = fw_health->tmr_multiplier;
 	return;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2873f600a7dd..bbbc63e882d1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1523,6 +1523,21 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_mem_init	mem_init[BNXT_CTX_MEM_INIT_MAX];
 };
 
+enum bnxt_health_severity {
+	SEVERITY_NORMAL = 0,
+	SEVERITY_WARNING,
+	SEVERITY_RECOVERABLE,
+	SEVERITY_FATAL,
+};
+
+enum bnxt_health_remedy {
+	REMEDY_DEVLINK_RECOVER,
+	REMEDY_POWER_CYCLE_DEVICE,
+	REMEDY_POWER_CYCLE_HOST,
+	REMEDY_FW_UPDATE,
+	REMEDY_HW_REPLACE,
+};
+
 struct bnxt_fw_health {
 	u32 flags;
 	u32 polling_dsecs;
@@ -1542,6 +1557,7 @@ struct bnxt_fw_health {
 	u8 enabled:1;
 	u8 primary:1;
 	u8 status_reliable:1;
+	u8 resets_reliable:1;
 	u8 tmr_multiplier;
 	u8 tmr_counter;
 	u8 fw_reset_seq_cnt;
@@ -1551,6 +1567,15 @@ struct bnxt_fw_health {
 	u32 echo_req_data1;
 	u32 echo_req_data2;
 	struct devlink_health_reporter	*fw_reporter;
+	/* Protects severity and remedy */
+	struct mutex lock;
+	enum bnxt_health_severity severity;
+	enum bnxt_health_remedy remedy;
+	u32 arrests;
+	u32 discoveries;
+	u32 survivals;
+	u32 fatalities;
+	u32 diagnoses;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index d6967b0233c9..5d9869a61305 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -71,43 +71,110 @@ static int bnxt_hwrm_remote_dev_reset_set(struct bnxt *bp, bool remote_reset)
 	return hwrm_req_send(bp, req);
 }
 
+static char *bnxt_health_severity_str(enum bnxt_health_severity severity)
+{
+	switch (severity) {
+	case SEVERITY_NORMAL: return "normal";
+	case SEVERITY_WARNING: return "warning";
+	case SEVERITY_RECOVERABLE: return "recoverable";
+	case SEVERITY_FATAL: return "fatal";
+	default: return "unknown";
+	}
+}
+
+static char *bnxt_health_remedy_str(enum bnxt_health_remedy remedy)
+{
+	switch (remedy) {
+	case REMEDY_DEVLINK_RECOVER: return "devlink recover";
+	case REMEDY_POWER_CYCLE_DEVICE: return "device power cycle";
+	case REMEDY_POWER_CYCLE_HOST: return "host power cycle";
+	case REMEDY_FW_UPDATE: return "update firmware";
+	case REMEDY_HW_REPLACE: return "replace hardware";
+	default: return "unknown";
+	}
+}
+
 static int bnxt_fw_diagnose(struct devlink_health_reporter *reporter,
 			    struct devlink_fmsg *fmsg,
 			    struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	u32 val;
+	struct bnxt_fw_health *h = bp->fw_health;
+	u32 fw_status, fw_resets;
 	int rc;
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
-		return 0;
+		return devlink_fmsg_string_pair_put(fmsg, "Status", "recovering");
 
-	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+	if (!h->status_reliable)
+		return devlink_fmsg_string_pair_put(fmsg, "Status", "unknown");
 
-	if (BNXT_FW_IS_BOOTING(val)) {
-		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
-						  "Not yet completed initialization");
+	mutex_lock(&h->lock);
+	fw_status = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+	if (BNXT_FW_IS_BOOTING(fw_status)) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "Status", "initializing");
 		if (rc)
-			return rc;
-	} else if (BNXT_FW_IS_ERR(val)) {
-		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
-						  "Encountered fatal error and cannot recover");
+			goto unlock;
+	} else if (h->severity || fw_status != BNXT_FW_STATUS_HEALTHY) {
+		if (!h->severity) {
+			h->severity = SEVERITY_FATAL;
+			h->remedy = REMEDY_POWER_CYCLE_DEVICE;
+			h->diagnoses++;
+			devlink_health_report(h->fw_reporter,
+					      "FW error diagnosed", h);
+		}
+		rc = devlink_fmsg_string_pair_put(fmsg, "Status", "error");
 		if (rc)
-			return rc;
+			goto unlock;
+		rc = devlink_fmsg_u32_pair_put(fmsg, "Syndrome", fw_status);
+		if (rc)
+			goto unlock;
+	} else {
+		rc = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
+		if (rc)
+			goto unlock;
 	}
 
-	if (val >> 16) {
-		rc = devlink_fmsg_u32_pair_put(fmsg, "Error code", val >> 16);
+	rc = devlink_fmsg_string_pair_put(fmsg, "Severity",
+					  bnxt_health_severity_str(h->severity));
+	if (rc)
+		goto unlock;
+
+	if (h->severity) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "Remedy",
+						  bnxt_health_remedy_str(h->remedy));
 		if (rc)
-			return rc;
+			goto unlock;
+		if (h->remedy == REMEDY_DEVLINK_RECOVER) {
+			rc = devlink_fmsg_string_pair_put(fmsg, "Impact",
+							  "traffic+ntuple_cfg");
+			if (rc)
+				goto unlock;
+		}
 	}
 
-	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
-	rc = devlink_fmsg_u32_pair_put(fmsg, "Reset count", val);
-	if (rc)
+unlock:
+	mutex_unlock(&h->lock);
+	if (rc || !h->resets_reliable)
 		return rc;
 
-	return 0;
+	fw_resets = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Resets", fw_resets);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Arrests", h->arrests);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Survivals", h->survivals);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Discoveries", h->discoveries);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Fatalities", h->fatalities);
+	if (rc)
+		return rc;
+	return devlink_fmsg_u32_pair_put(fmsg, "Diagnoses", h->diagnoses);
 }
 
 static int bnxt_fw_recover(struct devlink_health_reporter *reporter,
@@ -116,6 +183,9 @@ static int bnxt_fw_recover(struct devlink_health_reporter *reporter,
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 
+	if (bp->fw_health->severity == SEVERITY_FATAL)
+		return -ENODEV;
+
 	set_bit(BNXT_STATE_RECOVER, &bp->state);
 	__bnxt_fw_recover(bp);
 
@@ -165,6 +235,7 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 void bnxt_devlink_health_fw_report(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
+	int rc;
 
 	if (!fw_health)
 		return;
@@ -174,20 +245,32 @@ void bnxt_devlink_health_fw_report(struct bnxt *bp)
 		return;
 	}
 
-	devlink_health_report(fw_health->fw_reporter, "FW error reported", NULL);
+	mutex_lock(&fw_health->lock);
+	fw_health->severity = SEVERITY_RECOVERABLE;
+	fw_health->remedy = REMEDY_DEVLINK_RECOVER;
+	mutex_unlock(&fw_health->lock);
+	rc = devlink_health_report(fw_health->fw_reporter, "FW error reported",
+				   fw_health);
+	if (rc == -ECANCELED)
+		__bnxt_fw_recover(bp);
 }
 
 void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy)
 {
-	struct bnxt_fw_health *health = bp->fw_health;
+	struct bnxt_fw_health *fw_health = bp->fw_health;
 	u8 state;
 
-	if (healthy)
+	mutex_lock(&fw_health->lock);
+	if (healthy) {
+		fw_health->severity = SEVERITY_NORMAL;
 		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
-	else
+	} else {
+		fw_health->severity = SEVERITY_FATAL;
+		fw_health->remedy = REMEDY_POWER_CYCLE_DEVICE;
 		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
-
-	devlink_health_reporter_state_update(health->fw_reporter, state);
+	}
+	mutex_unlock(&fw_health->lock);
+	devlink_health_reporter_state_update(fw_health->fw_reporter, state);
 }
 
 void bnxt_dl_health_fw_recovery_done(struct bnxt *bp)
-- 
2.18.1


--0000000000004cd6a705cf0a3004
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPhFCWfRC+/m/nn7v5mYfzWvw9BpoA6C
tM7kVBb9AzLWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIzMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB3eNOSLSTZaxyNPQL16TAUipEVR1HGtAMR7T5QMmid6Yy5VED1
oAsWk5mFvnHMr42ldYQ3G7DZ/l/C5P70ZuxT/tZHk1kVrutGLm6r1jdihq1vG5FCijUBdyP0N7jE
4k9txZt+dvAztMY5C054xu9TljnAeFdZw8Nw4+ojTRtnl8UltKqxBHFUgf+KLg3LM5w5pxAojIli
MMqPTkNzYXYE4yAR1uaylOt35Tld8cbkE677UzW4aLJOgC2Yfrv+y0qWe7vDbFAT66XHKw7Cu2Km
gWc4B2AuuwJItiyWGY7L+edLp7TZ4Ih14nw9T+9sI1ZDKTCGYigKUpwnAIv0j8B6
--0000000000004cd6a705cf0a3004--
