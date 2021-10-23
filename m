Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6CE4384FB
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhJWTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhJWTfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:35:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7CC061767
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g184so6623669pgc.6
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9hJ2MF3G239ANJAAegU4aqKH19TwWM2AUz2l2H4ke90=;
        b=JEhMANUjkgMpxFrxyQJWr5hKTR3SX7Rd/ETkGDmxHXSLpePcWUzUSSCigXNf8An/ap
         mO1n/KUK5VbFdhEUEAQMzaS1RuebugrTg3gVBw6Y0TMtOLhkM2coUcj42V0/1KJU1YP+
         9394euHF+ZY9qkRlpsBbNmlbgRYgsEDs5NmPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9hJ2MF3G239ANJAAegU4aqKH19TwWM2AUz2l2H4ke90=;
        b=cJMiMTaT3qAFm45uuEtgg1yYyJYsBd5/JWWp6PoopWxFyiamRfo8GdjM5QTfPkG3Y1
         pjQICDJ9FWyuePQmgITRp5YfO+Yuy4TUcPtezxNvjCulOLTMj8cQ+w930CopS+g9Ggao
         50/ZbiUqOYvZabYs2o4bao3iF5JB1VBefOCRjI4c4HeFBopzv4ckMU+wVsY7yodBfxBZ
         8aC6gwlhL3ZvHHJilPAbEsTmHlW4LGHFeigeCG8WSbxaJT9xtQbfXIHzT5yzdD+9QfVx
         U/voo/x/HLkdxRaNvGausMPjst34kIXa8JY0+yeCxFcbe2rbVfofB+t08BBqiO+/6Q+d
         DCYg==
X-Gm-Message-State: AOAM532H+YDp2x1CsuZlr5iW/orBhBrQ3GgPsTw9SusOVgrurufH23Ph
        R/USgQzCJP3b7yoYf7kiJuvV+w==
X-Google-Smtp-Source: ABdhPJwgpIur3okqRvLBroV5fGYNSJyH/DGDmHiYlgXb1mh7B9MsYQ7EKw8tsvmZdTnHYkXy8TZS2A==
X-Received: by 2002:a05:6a00:17a9:b0:44c:b95f:50a4 with SMTP id s41-20020a056a0017a900b0044cb95f50a4mr7954876pfg.6.1635017561195;
        Sat, 23 Oct 2021 12:32:41 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:40 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 18/19] bnxt_en: Provide stored devlink "fw" version on older firmware
Date:   Sat, 23 Oct 2021 15:32:05 -0400
Message-Id: <1635017526-16963-19-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f6e84505cf0a30fe"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f6e84505cf0a30fe

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
index bba5cb9f0fec..a502aea92952 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -906,8 +906,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
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


--000000000000f6e84505cf0a30fe
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGBg2/HGkLt9ky+08xB8WrOtItsLZq6C
1BaNxz81+Zz4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzI0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDM8PfTspT1ACFoc5bLR5d8xIyd875P1hRuN/E+KYoyW3BKI1qV
H/K4Mfg1pc9DBd4d1w8IA0fdGpzhrjbb8BWoNwHwsuM2pgY9mqO3JBewHoa+c3vquBIHytfeELBy
1wrzviTphhwoo1R48z/luYSMZdT9y6sje78spgWODBa7bCGdquGG9oCaipDoEzUlVtmFY6sx0akS
yqT+f41tRRCoNsZIuRqc+bPdFBKW4wLxz8CMLnEbr7vNjjh5aRLSqmjF9ZYtU+BKPMBjnFMHKpp6
8cnBIYIsCBTacvsrvOT1jxoaaGqjKIvNF/C0i7oKCTXQA1avQ88Tl257m75oMB11
--000000000000f6e84505cf0a30fe--
