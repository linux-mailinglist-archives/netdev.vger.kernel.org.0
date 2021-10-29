Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43F143F811
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhJ2HvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbhJ2HvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:51:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1FEC061745
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b1so4995187pfm.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cIFDjYZPyB+EWKhcK59c5SnHZR3e2h9j3tD+fUo9824=;
        b=FOscuavoZDMpFLjY5MVdD/bCDPg3axASXmB8Y5AeqjvltlK0m9bSUa2WfJut9ZjooQ
         94kfDaX8zpZQdzEKYUCdjprwPdMA6YWTvMF7SjqNw/Y9+Rz5ILc1wwN3cjPmNGx3S2W0
         tK3OmOzwxk5n645KrdbU1R6x4avmL8uhQVyrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cIFDjYZPyB+EWKhcK59c5SnHZR3e2h9j3tD+fUo9824=;
        b=NFNvvl4l2Q1iZDpRawBQLBlWaJucQQOm7s9oDLJmxIg7CBkpKDSV9U1+GgyHYhgPLn
         u51r0GhutPGjEX63kroOcYC4BthIJXyBxb50PEPlWCP2G4bV0hvd2DZS7tFWkunjXOud
         6Dv4AFHmhy5enKwovhpP7hL5HpWKwoXc5O37G7IJgT1HKSkFYpQkv+tAm3G4X+ar09lN
         5nVvMkQpKa5kKy/JtsoXGnqzUhWn4DfxnEK9PV06rEMxruZJdu4kNRCh5dl0f3ssjXTf
         tVNT/SRo4RKgQZX++3vc19wROyfQlBMN0i4cD2KrFJkgkyASt/jsVVKEYDit6yKsxnQ6
         RuVQ==
X-Gm-Message-State: AOAM531c+Gyt/jh1o/OqPvmVFhbRc1dQp1YfoqDq/s//NMycXtaPDjZX
        /6TROnZh915/aUGyh6JQGESxs+ae6RWNOw==
X-Google-Smtp-Source: ABdhPJwVNOSMRvik8rCdiQwKAMNEdvKaveVfAodWP7mBluiJqaR7dIx+69h+Bg8+2HTL5mMGAsoZNw==
X-Received: by 2002:aa7:9197:0:b0:44d:a2e9:72cf with SMTP id x23-20020aa79197000000b0044da2e972cfmr9565919pfa.38.1635493713946;
        Fri, 29 Oct 2021 00:48:33 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:33 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 18/19] bnxt_en: Provide stored devlink "fw" version on older firmware
Date:   Fri, 29 Oct 2021 03:47:55 -0400
Message-Id: <1635493676-10767-19-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000eaa01005cf790dfe"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000eaa01005cf790dfe

From: Vikas Gupta <vikas.gupta@broadcom.com>

On older firmware that doesn't support the HWRM_NVM_GET_DEV_INFO
command that returns detailed stored firmware versions, fallback
to use the same firmware package version that is reported to ethtool.
Refactor bnxt_get_pkgver() in bnxt_ethtool.c so that devlink can call
and get the package version.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 41 +++++++++++++------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  1 +
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 4007b2ac8ca4..ce790e9b45c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -915,8 +915,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	rc = bnxt_hwrm_nvm_get_dev_info(bp, &nvm_dev_info);
 	if (rc ||
-	    !(nvm_dev_info.flags & NVM_GET_DEV_INFO_RESP_FLAGS_FW_VER_VALID))
+	    !(nvm_dev_info.flags & NVM_GET_DEV_INFO_RESP_FLAGS_FW_VER_VALID)) {
+		if (!bnxt_get_pkginfo(bp->dev, buf, sizeof(buf)))
+			return bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+						DEVLINK_INFO_VERSION_GENERIC_FW,
+						buf);
 		return 0;
+	}
 
 	buf[0] = 0;
 	strncat(buf, nvm_dev_info.pkg_name, HWRM_FW_VER_STR_LEN);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 334ada053246..8188d55722e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2832,39 +2832,56 @@ static char *bnxt_parse_pkglog(int desired_field, u8 *data, size_t datalen)
 	return retval;
 }
 
-static void bnxt_get_pkgver(struct net_device *dev)
+int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	u16 index = 0;
 	char *pkgver;
 	u32 pkglen;
 	u8 *pkgbuf;
-	int len;
+	int rc;
 
-	if (bnxt_find_nvram_item(dev, BNX_DIR_TYPE_PKG_LOG,
-				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
-				 &index, NULL, &pkglen) != 0)
-		return;
+	rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_PKG_LOG,
+				  BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
+				  &index, NULL, &pkglen);
+	if (rc)
+		return rc;
 
 	pkgbuf = kzalloc(pkglen, GFP_KERNEL);
 	if (!pkgbuf) {
 		dev_err(&bp->pdev->dev, "Unable to allocate memory for pkg version, length = %u\n",
 			pkglen);
-		return;
+		return -ENOMEM;
 	}
 
-	if (bnxt_get_nvram_item(dev, index, 0, pkglen, pkgbuf))
+	rc = bnxt_get_nvram_item(dev, index, 0, pkglen, pkgbuf);
+	if (rc)
 		goto err;
 
 	pkgver = bnxt_parse_pkglog(BNX_PKG_LOG_FIELD_IDX_PKG_VERSION, pkgbuf,
 				   pkglen);
-	if (pkgver && *pkgver != 0 && isdigit(*pkgver)) {
+	if (pkgver && *pkgver != 0 && isdigit(*pkgver))
+		strscpy(ver, pkgver, size);
+	else
+		rc = -ENOENT;
+
+err:
+	kfree(pkgbuf);
+
+	return rc;
+}
+
+static void bnxt_get_pkgver(struct net_device *dev)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	char buf[FW_VER_STR_LEN];
+	int len;
+
+	if (!bnxt_get_pkginfo(dev, buf, sizeof(buf))) {
 		len = strlen(bp->fw_ver_str);
 		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len - 1,
-			 "/pkg %s", pkgver);
+			 "/pkg %s", buf);
 	}
-err:
-	kfree(pkgbuf);
 }
 
 static int bnxt_get_eeprom(struct net_device *dev,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 4f7eaba65dcb..6aa44840f13a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -55,6 +55,7 @@ int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 			     u8 self_reset, u8 flags);
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type);
+int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
 
-- 
2.18.1


--000000000000eaa01005cf790dfe
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGVBGb8TFBI7DJ6PwpwpX6dm8wZeHJZw
gu+tljRstj76MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCVf2N9VdyWqASdw6vlmR2NiyDHrIM8Tk0eeovkml/yZTpG03zV
WiuazbaVs3go0tFwAsa6phvI6+r7L5JXj6na5odme4M2Fav2csMdHhkVgy01fW3Ppr64iHh8sl/j
m9m2TrLMq+VIu4ttJBdwCkjl0Iq1cpSYMhi6s3lUyV3f1Gt56zFX/kbavwKTJVs5QmMGzcAVNTZQ
S3eTyJUIsbNE3dAxBv4n0lBEYbilBWYntaqhniNmGF1MQMbLQtyKrEGJRMY8oStnL01q3SQM0VGc
5tCBMxB4kEzWAsxYI+X4cuuVKxkuf0B5hrTdTR64BuoV5ouHbzi03OllJeSKafj3
--000000000000eaa01005cf790dfe--
