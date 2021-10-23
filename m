Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1BA4384F9
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhJWTfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhJWTe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35CDC061220
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so418356plc.2
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CynPHgvVNALtuvl6Q420rj2tD64Sk2BhYb/uVf09C20=;
        b=B8wFdU4uVeG4pL1pgSVtTd+TsE3Ok10FVwQQPE7LCKvvGcghA75s5sJiCNt9SZCMP4
         sHn55WDNSDXdxsw/u4Kz5G3SQKb5UZOpq7Wu16dCxf0Q+NT3U3HU9t5+qHWEvs+arZKD
         oj8x32lvpS4aAADq660hF8e4x8jSAkZM8w2XI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CynPHgvVNALtuvl6Q420rj2tD64Sk2BhYb/uVf09C20=;
        b=r3C7aoNHAi/n98I5sb/owByfkgZLQPYYSWNSgUuhU2i+pNMrk0o9Xm51mGhcFlpDft
         S9G+aQ5mABmVOiTpljdJixtVYSxTtBChifBV9qOyU+VzJG6y/VZi6pAl1Adyrx+Ih/St
         kSnej5DI+gvr4h0DbLISomwb/zZmDCIzMB/R/3zyjY0v6PHUOMEL05z44wh/82xY4zVv
         eO8OKyc23aYj2i737fynH/gYtQiTD4GRh9WOm2jcO5O9Lbzu7gBm9tdylV07n5UovKiZ
         ml0lbIlBnmJomNJjDcKhQrNbkR3FyGCq1DybDX4yupuw54TXkaFODQkv5iRoKOpKGcYa
         8tXA==
X-Gm-Message-State: AOAM532tL0VIT28jyJcknM8wLd5undKyUr1b2FEEMKIy0UpxLhoWajXq
        A8jPwuon+h77c4l4UjrAIUOgQTZ+xtKL4A==
X-Google-Smtp-Source: ABdhPJyR/MVmfj7PvkuKFMWzR4cUntuKhDZZ+o+WRPbX5OCfBn1ynZsVdNVz8tBCXhhKb3J2VejCug==
X-Received: by 2002:a17:903:2306:b0:140:2880:5f5f with SMTP id d6-20020a170903230600b0014028805f5fmr6736787plh.51.1635017554822;
        Sat, 23 Oct 2021 12:32:34 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:34 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 13/19] bnxt_en: Retrieve coredump and crashdump size via FW command
Date:   Sat, 23 Oct 2021 15:32:00 -0400
Message-Id: <1635017526-16963-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000099911205cf0a307d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000099911205cf0a307d

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Recent firmware provides coredump and crashdump size info via
DBG_QCFG command. Read the dump sizes from firmware, instead of
computing in the driver. This patch reduces the time taken
to collect the dump via ethtool.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 31 +++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 +
 .../ethernet/broadcom/bnxt/bnxt_coredump.c    | 55 +++++++++++++++++--
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d619064ab330..4b6a291bb392 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7480,6 +7480,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_ERR_RECOVER_RELOAD;
 	if (!(flags & FUNC_QCAPS_RESP_FLAGS_VLAN_ACCELERATION_TX_DISABLED))
 		bp->fw_cap |= BNXT_FW_CAP_VLAN_TX_INSERT;
+	if (flags & FUNC_QCAPS_RESP_FLAGS_DBG_QCAPS_CMD_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_DBG_QCAPS;
 
 	flags_ext = le32_to_cpu(resp->flags_ext);
 	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED)
@@ -7543,6 +7545,32 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	return rc;
 }
 
+static void bnxt_hwrm_dbg_qcaps(struct bnxt *bp)
+{
+	struct hwrm_dbg_qcaps_output *resp;
+	struct hwrm_dbg_qcaps_input *req;
+	int rc;
+
+	bp->fw_dbg_cap = 0;
+	if (!(bp->fw_cap & BNXT_FW_CAP_DBG_QCAPS))
+		return;
+
+	rc = hwrm_req_init(bp, req, HWRM_DBG_QCAPS);
+	if (rc)
+		return;
+
+	req->fid = cpu_to_le16(0xffff);
+	resp = hwrm_req_hold(bp, req);
+	rc = hwrm_req_send(bp, req);
+	if (rc)
+		goto hwrm_dbg_qcaps_exit;
+
+	bp->fw_dbg_cap = le32_to_cpu(resp->flags);
+
+hwrm_dbg_qcaps_exit:
+	hwrm_req_drop(bp, req);
+}
+
 static int bnxt_hwrm_queue_qportcfg(struct bnxt *bp);
 
 static int bnxt_hwrm_func_qcaps(struct bnxt *bp)
@@ -7552,6 +7580,9 @@ static int bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	rc = __bnxt_hwrm_func_qcaps(bp);
 	if (rc)
 		return rc;
+
+	bnxt_hwrm_dbg_qcaps(bp);
+
 	rc = bnxt_hwrm_queue_qportcfg(bp);
 	if (rc) {
 		netdev_err(bp->dev, "hwrm query qportcfg failure rc: %d\n", rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bbbc63e882d1..4165fffec886 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1961,6 +1961,9 @@ struct bnxt {
 	#define BNXT_FW_CAP_PTP_PPS			0x10000000
 	#define BNXT_FW_CAP_HOT_RESET_IF		0x20000000
 	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
+	#define BNXT_FW_CAP_DBG_QCAPS			0x80000000
+
+	u32			fw_dbg_cap;
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index 05896bf9750d..8961a6ffae87 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -361,13 +361,60 @@ int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len)
 	}
 }
 
+static int bnxt_hwrm_get_dump_len(struct bnxt *bp, u16 dump_type, u32 *dump_len)
+{
+	struct hwrm_dbg_qcfg_output *resp;
+	struct hwrm_dbg_qcfg_input *req;
+	int rc, hdr_len = 0;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_DBG_QCAPS))
+		return -EOPNOTSUPP;
+
+	if (dump_type == BNXT_DUMP_CRASH &&
+	    !(bp->fw_dbg_cap & DBG_QCAPS_RESP_FLAGS_CRASHDUMP_SOC_DDR))
+		return -EOPNOTSUPP;
+
+	rc = hwrm_req_init(bp, req, HWRM_DBG_QCFG);
+	if (rc)
+		return rc;
+
+	req->fid = cpu_to_le16(0xffff);
+	if (dump_type == BNXT_DUMP_CRASH)
+		req->flags = cpu_to_le16(DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_DEST_SOC_DDR);
+
+	resp = hwrm_req_hold(bp, req);
+	rc = hwrm_req_send(bp, req);
+	if (rc)
+		goto get_dump_len_exit;
+
+	if (dump_type == BNXT_DUMP_CRASH) {
+		*dump_len = le32_to_cpu(resp->crashdump_size);
+	} else {
+		/* Driver adds coredump header and "HWRM_VER_GET response"
+		 * segment additionally to coredump.
+		 */
+		hdr_len = sizeof(struct bnxt_coredump_segment_hdr) +
+		sizeof(struct hwrm_ver_get_output) +
+		sizeof(struct bnxt_coredump_record);
+		*dump_len = le32_to_cpu(resp->coredump_size) + hdr_len;
+	}
+	if (*dump_len <= hdr_len)
+		rc = -EINVAL;
+
+get_dump_len_exit:
+	hwrm_req_drop(bp, req);
+	return rc;
+}
+
 u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type)
 {
 	u32 len = 0;
 
-	if (dump_type == BNXT_DUMP_CRASH)
-		len = BNXT_CRASH_DUMP_LEN;
-	else
-		__bnxt_get_coredump(bp, NULL, &len);
+	if (bnxt_hwrm_get_dump_len(bp, dump_type, &len)) {
+		if (dump_type == BNXT_DUMP_CRASH)
+			len = BNXT_CRASH_DUMP_LEN;
+		else
+			__bnxt_get_coredump(bp, NULL, &len);
+	}
 	return len;
 }
-- 
2.18.1


--00000000000099911205cf0a307d
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBfeVhZ0bZOTEPhidSJlE7DH9757Fr9K
8Y2DcPjJkaBSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDUS94LIOd6yHIelRL7kz147Dv4eMDt8HtLd0P7GBQ8OlUI4p3c
8l50rC+f9B9yudRXnLw+4AFbdNQn10/nnQuCen5MmrekElKmjDxLfqzDaXhglO5Oe1tFLhdryn7T
qtnWiF/pASssxculTpIEWCI/LwFb34q+yPw1v+Md3RZDnaWe30vGZNhZ2lyHmQw0X5EOg1iwLkJw
/1KsgCflFV9C9D5Pqp6nLH3HU084oL1U51HnvTZoCkxc0jxk5ux9ZzRpMOnMoWvQ8WiKyrvnqjff
R2W2cnuP9dCdwyRBlLdJg2b6PeaKoqrltCn8GlSKwSPbMbo0lZiK06Y/fwYJk8GY
--00000000000099911205cf0a307d--
