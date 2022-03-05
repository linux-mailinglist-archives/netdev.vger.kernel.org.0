Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623884CE3B9
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiCEI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiCEI4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:56:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4977B25553B
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:11 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso12477473pjj.2
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ASlRKYmDCMm9ejST+ewaFE7nCTOcKLOVzdDTGLrzEdA=;
        b=JDFE8a2jXaq/4I/PJV2Txsse8kFf03aVl28Ntnzi8NYAcRF0zlBVtbV+GM9kN7am5e
         Y+CSBBc0ADIcs4kSJRexTULogQo6ucxuAN66jcH7e0zm5uDJ7vek2J2PAiJNZXYZEU+b
         5jb/rwrBPvpqr0gESLh2V93KSFoPVS+/4hNpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ASlRKYmDCMm9ejST+ewaFE7nCTOcKLOVzdDTGLrzEdA=;
        b=EL5abIc/FYC2U2+3Koq8LMI2Oct1gJ9d4aWE7ZFxFvMmwu0b1xYQNCGPw8Tsf0fnI1
         MxPQ1wqSBv1+zavvAjB5Q6CBHzuDwKsXOjI3lcMlNcduOnGgils2T8UVhuk0xaX3ekl3
         2QK2RMXVOUZIwV91lJZsZqRDiE8TdlmiU439/jbQfF/R7Bg3fwlShtKExWpz5kmMH4z+
         GGwFpCQq+t2X5s9xFLinOJdCuPT+StWEqhkEiZJllcuu9xXWv2tkn9aQ+yQAxRiKcwgA
         SA01dXiuw5E9gFXH69WTS2AmtlRMVIlF3f4gCwmRihVwaCjmphtX41HHXgYOVYabbQHf
         S8yg==
X-Gm-Message-State: AOAM5315IKyexJvi5VobODCkDxWutU5YZWXZlQPvqDw2ODSOONmiQAzx
        VrIxlaV9lKtXeIHG4gsKniGv7w==
X-Google-Smtp-Source: ABdhPJzI81Q51SmIUrZ+FM4bo/y805JJmBiNYxgVZOZmSSPCLrVSrq6ovPKy4k/M7KJ/qJtObh/EzA==
X-Received: by 2002:a17:902:eccf:b0:151:6a35:8498 with SMTP id a15-20020a170902eccf00b001516a358498mr2629015plh.131.1646470510452;
        Sat, 05 Mar 2022 00:55:10 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:10 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 8/9] bnxt_en: implement hw health reporter
Date:   Sat,  5 Mar 2022 03:54:41 -0500
Message-Id: <1646470482-13763-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f1d12605d974c9b3"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f1d12605d974c9b3

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

This reporter will report NVM errors which are non-fatal.
When we receive these NVM error events, we'll report it
through this new hw health reporter.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 19 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 33 +++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 73 +++++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 4 files changed, 126 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2de02950086f..63b8fc4f9d42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2061,6 +2061,22 @@ static void bnxt_event_error_report(struct bnxt *bp, u32 data1, u32 data2)
 	case ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD:
 		netdev_warn(bp->dev, "One or more MMIO doorbells dropped by the device!\n");
 		break;
+	case ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM: {
+		struct bnxt_hw_health *hw_health = &bp->hw_health;
+
+		hw_health->nvm_err_address = EVENT_DATA2_NVM_ERR_ADDR(data2);
+		if (EVENT_DATA1_NVM_ERR_TYPE_WRITE(data1)) {
+			hw_health->synd = BNXT_HW_STATUS_NVM_WRITE_ERR;
+			hw_health->nvm_write_errors++;
+		} else if (EVENT_DATA1_NVM_ERR_TYPE_ERASE(data1)) {
+			hw_health->synd = BNXT_HW_STATUS_NVM_ERASE_ERR;
+			hw_health->nvm_erase_errors++;
+		} else {
+			hw_health->synd = BNXT_HW_STATUS_NVM_UNKNOWN_ERR;
+		}
+		set_bit(BNXT_FW_NVM_ERR_SP_EVENT, &bp->sp_event);
+		break;
+	}
 	default:
 		netdev_err(bp->dev, "FW reported unknown error type %u\n",
 			   err_type);
@@ -11887,6 +11903,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_FW_ECHO_REQUEST_SP_EVENT, &bp->sp_event))
 		bnxt_fw_echo_reply(bp);
 
+	if (test_and_clear_bit(BNXT_FW_NVM_ERR_SP_EVENT, &bp->sp_event))
+		bnxt_devlink_health_hw_report(bp);
+
 	/* These functions below will clear BNXT_STATE_IN_SP_TASK.  They
 	 * must be the last functions to be called before exiting.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 447a9406b8a2..fa0df43ddc1a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -516,6 +516,21 @@ struct rx_tpa_end_cmp_ext {
 	  ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_MASK) >>\
 	 ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_SFT)
 
+#define EVENT_DATA2_NVM_ERR_ADDR(data2)					\
+	(((data2) &							\
+	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_MASK) >>\
+	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_SFT)
+
+#define EVENT_DATA1_NVM_ERR_TYPE_WRITE(data1)				\
+	(((data1) &							\
+	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_MASK) ==\
+	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_WRITE)
+
+#define EVENT_DATA1_NVM_ERR_TYPE_ERASE(data1)				\
+	(((data1) &							\
+	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_MASK) ==\
+	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_ERASE)
+
 struct nqe_cn {
 	__le16	type;
 	#define NQ_CN_TYPE_MASK           0x3fUL
@@ -1528,6 +1543,21 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_mem_init	mem_init[BNXT_CTX_MEM_INIT_MAX];
 };
 
+enum bnxt_hw_err {
+	BNXT_HW_STATUS_HEALTHY		= 0x0,
+	BNXT_HW_STATUS_NVM_WRITE_ERR	= 0x1,
+	BNXT_HW_STATUS_NVM_ERASE_ERR	= 0x2,
+	BNXT_HW_STATUS_NVM_UNKNOWN_ERR	= 0x3,
+};
+
+struct bnxt_hw_health {
+	u32 nvm_err_address;
+	u32 nvm_write_errors;
+	u32 nvm_erase_errors;
+	u8 synd;
+	struct devlink_health_reporter *hw_reporter;
+};
+
 enum bnxt_health_severity {
 	SEVERITY_NORMAL = 0,
 	SEVERITY_WARNING,
@@ -2045,6 +2075,7 @@ struct bnxt {
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
 #define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
 #define BNXT_FW_ECHO_REQUEST_SP_EVENT	23
+#define BNXT_FW_NVM_ERR_SP_EVENT	25
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
@@ -2145,6 +2176,8 @@ struct bnxt {
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 	enum board_idx		board_idx;
+
+	struct bnxt_hw_health	hw_health;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0c17f90d44a2..a802bbda1c27 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -241,6 +241,69 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.recover = bnxt_fw_recover,
 };
 
+static int bnxt_hw_recover(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+	struct bnxt_hw_health *hw_health = &bp->hw_health;
+
+	hw_health->synd = BNXT_HW_STATUS_HEALTHY;
+	return 0;
+}
+
+static const char *hw_err_str(u8 synd)
+{
+	switch (synd) {
+	case BNXT_HW_STATUS_HEALTHY:
+		return "healthy";
+	case BNXT_HW_STATUS_NVM_WRITE_ERR:
+		return "nvm write error";
+	case BNXT_HW_STATUS_NVM_ERASE_ERR:
+		return "nvm erase error";
+	case BNXT_HW_STATUS_NVM_UNKNOWN_ERR:
+		return "unrecognized nvm error";
+	default:
+		return "unknown hw error";
+	}
+}
+
+static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
+			    struct devlink_fmsg *fmsg,
+			    struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+	struct bnxt_hw_health *h = &bp->hw_health;
+	int rc;
+
+	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(h->synd));
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_write_errors", h->nvm_write_errors);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_erase_errors", h->nvm_erase_errors);
+	if (rc)
+		return rc;
+	return 0;
+}
+
+void bnxt_devlink_health_hw_report(struct bnxt *bp)
+{
+	struct bnxt_hw_health *hw_health = &bp->hw_health;
+
+	netdev_warn(bp->dev, "%s reported at address 0x%x\n", hw_err_str(hw_health->synd),
+		    hw_health->nvm_err_address);
+
+	devlink_health_report(hw_health->hw_reporter, hw_err_str(hw_health->synd), NULL);
+}
+
+static const struct devlink_health_reporter_ops bnxt_dl_hw_reporter_ops = {
+	.name = "hw",
+	.diagnose = bnxt_hw_diagnose,
+	.recover = bnxt_hw_recover,
+};
+
 static struct devlink_health_reporter *
 __bnxt_dl_reporter_create(struct bnxt *bp,
 			  const struct devlink_health_reporter_ops *ops)
@@ -260,6 +323,10 @@ __bnxt_dl_reporter_create(struct bnxt *bp,
 void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct bnxt_hw_health *hw_health = &bp->hw_health;
+
+	if (!hw_health->hw_reporter)
+		hw_health->hw_reporter = __bnxt_dl_reporter_create(bp, &bnxt_dl_hw_reporter_ops);
 
 	if (fw_health && !fw_health->fw_reporter)
 		fw_health->fw_reporter = __bnxt_dl_reporter_create(bp, &bnxt_dl_fw_reporter_ops);
@@ -268,6 +335,12 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct bnxt_hw_health *hw_health = &bp->hw_health;
+
+	if (hw_health->hw_reporter) {
+		devlink_health_reporter_destroy(hw_health->hw_reporter);
+		hw_health->hw_reporter = NULL;
+	}
 
 	if (fw_health && fw_health->fw_reporter) {
 		devlink_health_reporter_destroy(fw_health->fw_reporter);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index b8105065367b..056962e4b177 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -74,6 +74,7 @@ enum bnxt_dl_version_type {
 void bnxt_devlink_health_fw_report(struct bnxt *bp);
 void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy);
 void bnxt_dl_health_fw_recovery_done(struct bnxt *bp);
+void bnxt_devlink_health_hw_report(struct bnxt *bp);
 void bnxt_dl_fw_reporters_create(struct bnxt *bp);
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp);
 int bnxt_dl_register(struct bnxt *bp);
-- 
2.18.1


--000000000000f1d12605d974c9b3
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPH7NEFmpsN+CU/PU/IguuL2QatjaUFW
V2gfuZD3Ch9IMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCAdDLjFGddj7bUR5kL8WHGYqpQLHlRtrUL56pMu8EuU5koxYRl
mhgHDmVHpIjtAT8Z9QmJCAMmlDFa1AhcPBG6GNqL1lKxi1ROKd/N39KocI/USrOiyRgTF4NRdHhM
mSfwCFqsBZgvyJU0Xx+c0tffAFEuEjKXL+q+T+Omk96zVDi6c4MosRGTTyRqvQTyBW4ObeizF3rD
obeedyuY+bQQrzMgE2IkOzi/XU3GW3uRHpL71hj5sF8XKKkKEUlW5gjyc8JJNZN4oaQ9qMAwCFWe
2w0xVEdRQfJ3sp6lSIMCyph0N5CEWlfiFulPPtD/fu3G4EMyBHspDTb5YpWxtIzz
--000000000000f1d12605d974c9b3--
