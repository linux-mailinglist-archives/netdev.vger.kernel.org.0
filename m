Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE0C5259BC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 04:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352236AbiEMClF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 22:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376553AbiEMCkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 22:40:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75B22637
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 202so6237303pgc.9
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WOacpN3GvprRtwIPAxNK5HUbMVMpQt+V5GmVqQngSOg=;
        b=Rs5OxDgo1ZnFU+JlVzYBAkAUbEh7QQOUcnKtkFcYoA4AYthjIWALWCc/U2xEjIFRVw
         MGGeaHlIaShJme+LGp8pdPnF2g7HpKC+YjYw+uWZqP0asqTET9arSWFhJ+FEejrrbtlQ
         joK+nxW4nfKt82lPKVwLQgXxRCmO6p8ZPVkl4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WOacpN3GvprRtwIPAxNK5HUbMVMpQt+V5GmVqQngSOg=;
        b=YKZAhuhOSLIQ9Y6WBfyh48NW22Uavs3JREKXikHjyi5+HifN7usLGeO9IxIpwSHcQb
         BHIPTwAINB+5z+PaCvSTNUR855PcYrPG1j/7vCL2mgWMljk+FyZ20xmdJZFK++yl3ya6
         Cz54fIs4sS5y3f607f8xAx6EaF2LDJCIA6Ptkj8pIiJvji5AKOTvFPyHW885bEbGXi6k
         VSFsrZRrW3aRSCprkV9YmmCeZvYog+Trb/AKMar+Oj0gbO/aMygUzsEvCiy8ig+uYWmy
         cuvaY0g7yVKCsI+WG2DCbngGy1qK1xBHHKNWEMokCcSMbsQTgjSAEjk1zK45+BIRSLX6
         LsLg==
X-Gm-Message-State: AOAM531qPb98Hqw7rHwzr+sjgAvhUMHK7XXf99GjC9L+FRe1/ojv4OXq
        1UlzzQ1OwjvFcmBCJ+8fuwVC5sH51lFiHA==
X-Google-Smtp-Source: ABdhPJzQsw52Jrzt1ClLFEcto+Y46/O6HC+nYRAamzopnFEDv9i0SqscmuNV1MrW5/U3k9Mcj3V0vQ==
X-Received: by 2002:a63:2265:0:b0:3db:6362:184b with SMTP id t37-20020a632265000000b003db6362184bmr2106378pgm.529.1652409642560;
        Thu, 12 May 2022 19:40:42 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t3-20020a1709027fc300b0015e8da1fb07sm587212plb.127.2022.05.12.19.40.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 19:40:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Subject: [PATCH net-next 4/4] bnxt_en: parse and report result field when NVRAM package install fails
Date:   Thu, 12 May 2022 22:40:24 -0400
Message-Id: <1652409624-8731-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
References: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d317d505dedb99e2"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d317d505dedb99e2

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

Instead of always returning -ENOPKG, decode the firmware error
code further when the HWRM_NVM_INSTALL_UPDATE firmware call fails.
Return a more suitable error code to userspace and log an error
in dmesg.

This is version 2 of the earlier patch that was reverted:

02acd399533e ("bnxt_en: parse result field when NVRAM package install fails")

In this new version, if the call is made through devlink instead of
ethtool, we'll also set the error message in extack.

Link: https://lore.kernel.org/netdev/20220307141358.4d52462e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 81 ++++++++++++++++---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +-
 3 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0c17f90d44a2..3528ce9849e6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -45,7 +45,7 @@ bnxt_dl_flash_update(struct devlink *dl,
 	}
 
 	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
-	rc = bnxt_flash_package_from_fw_obj(bp->dev, params->fw, 0);
+	rc = bnxt_flash_package_from_fw_obj(bp->dev, params->fw, 0, extack);
 	if (!rc)
 		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
 	else
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8a7f3f02ed90..7191e5d74208 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -23,6 +23,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/timecounter.h>
+#include <net/netlink.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
@@ -34,6 +35,13 @@
 #include "bnxt_fw_hdr.h"	/* Firmware hdr constant and structure defs */
 #include "bnxt_coredump.h"
 
+#define BNXT_NVM_ERR_MSG(dev, extack, msg)			\
+	do {							\
+		if (extack)					\
+			NL_SET_ERR_MSG_MOD(extack, msg);	\
+		netdev_err(dev, "%s\n", msg);			\
+	} while (0)
+
 static u32 bnxt_get_msglevel(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -2499,12 +2507,65 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 	return rc;
 }
 
+#define MSG_INTEGRITY_ERR "PKG install error : Data integrity on NVM"
+#define MSG_INVALID_PKG "PKG install error : Invalid package"
+#define MSG_AUTHENTICATION_ERR "PKG install error : Authentication error"
+#define MSG_INVALID_DEV "PKG install error : Invalid device"
+#define MSG_INTERNAL_ERR "PKG install error : Internal error"
+#define MSG_NO_PKG_UPDATE_AREA_ERR "PKG update area not created in nvram"
+#define MSG_NO_SPACE_ERR "PKG insufficient update area in nvram"
+#define MSG_ANTI_ROLLBACK_ERR "HWRM_NVM_INSTALL_UPDATE failure due to Anti-rollback detected"
+#define MSG_GENERIC_FAILURE_ERR "HWRM_NVM_INSTALL_UPDATE failure"
+
+static int nvm_update_err_to_stderr(struct net_device *dev, u8 result,
+				    struct netlink_ext_ack *extack)
+{
+	switch (result) {
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TYPE_PARAMETER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_INDEX_PARAMETER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_DATA_ERROR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_CHECKSUM_ERROR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_NOT_FOUND:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_LOCKED:
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_INTEGRITY_ERR);
+		return -EINVAL;
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PREREQUISITE:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_FILE_HEADER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_SIGNATURE:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_STREAM:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_LENGTH:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_MANIFEST:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TRAILER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_CHECKSUM:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_ITEM_CHECKSUM:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DATA_LENGTH:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DIRECTIVE:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_DUPLICATE_ITEM:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_ZERO_LENGTH_ITEM:
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_INVALID_PKG);
+		return -ENOPKG;
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_AUTHENTICATION_ERROR:
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_AUTHENTICATION_ERR);
+		return -EPERM;
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_CHIP_REV:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_DEVICE_ID:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_VENDOR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_ID:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_PLATFORM:
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_INVALID_DEV);
+		return -EOPNOTSUPP;
+	default:
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_INTERNAL_ERR);
+		return -EIO;
+	}
+}
+
 #define BNXT_PKG_DMA_SIZE	0x40000
 #define BNXT_NVM_MORE_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_MODE))
 #define BNXT_NVM_LAST_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_LAST))
 
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
-				   u32 install_type)
+				   u32 install_type, struct netlink_ext_ack *extack)
 {
 	struct hwrm_nvm_install_update_input *install;
 	struct hwrm_nvm_install_update_output *resp;
@@ -2567,12 +2628,11 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 					  BNX_DIR_EXT_NONE,
 					  &index, &item_len, NULL);
 		if (rc) {
-			netdev_err(dev, "PKG update area not created in nvram\n");
+			BNXT_NVM_ERR_MSG(dev, extack, MSG_NO_PKG_UPDATE_AREA_ERR);
 			break;
 		}
 		if (fw->size > item_len) {
-			netdev_err(dev, "PKG insufficient update area in nvram: %lu\n",
-				   (unsigned long)fw->size);
+			BNXT_NVM_ERR_MSG(dev, extack, MSG_NO_SPACE_ERR);
 			rc = -EFBIG;
 			break;
 		}
@@ -2613,7 +2673,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 
 		switch (cmd_err) {
 		case NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK:
-			netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure Anti-rollback detected\n");
+			BNXT_NVM_ERR_MSG(dev, extack, MSG_ANTI_ROLLBACK_ERR);
 			rc = -EALREADY;
 			break;
 		case NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR:
@@ -2641,8 +2701,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 			}
 			fallthrough;
 		default:
-			netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x cmd_err :%x\n",
-				   rc, cmd_err);
+			BNXT_NVM_ERR_MSG(dev, extack, MSG_GENERIC_FAILURE_ERR);
 		}
 	} while (defrag_attempted && !rc);
 
@@ -2653,7 +2712,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	if (resp->result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
 			   (s8)resp->result, (int)resp->problem_item);
-		rc = -ENOPKG;
+		rc = nvm_update_err_to_stderr(dev, resp->result, extack);
 	}
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
@@ -2661,7 +2720,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 }
 
 static int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
-					u32 install_type)
+					u32 install_type, struct netlink_ext_ack *extack)
 {
 	const struct firmware *fw;
 	int rc;
@@ -2673,7 +2732,7 @@ static int bnxt_flash_package_from_file(struct net_device *dev, const char *file
 		return rc;
 	}
 
-	rc = bnxt_flash_package_from_fw_obj(dev, fw, install_type);
+	rc = bnxt_flash_package_from_fw_obj(dev, fw, install_type, extack);
 
 	release_firmware(fw);
 
@@ -2691,7 +2750,7 @@ static int bnxt_flash_device(struct net_device *dev,
 	if (flash->region == ETHTOOL_FLASH_ALL_REGIONS ||
 	    flash->region > 0xffff)
 		return bnxt_flash_package_from_file(dev, flash->data,
-						    flash->region);
+						    flash->region, NULL);
 
 	return bnxt_flash_firmware_from_file(dev, flash->region, flash->data);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 6aa44840f13a..a59284215e78 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -54,7 +54,7 @@ int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
 int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 			     u8 self_reset, u8 flags);
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
-				   u32 install_type);
+				   u32 install_type, struct netlink_ext_ack *extack);
 int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
-- 
2.18.1


--000000000000d317d505dedb99e2
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC5aRUeOWmlVdt6GxeA6kd4F2s+qnFsh
v8adbACdbpBtMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUx
MzAyNDA0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCxa2lyJpl3zScm9xLLK0+i3d9RatXAlZ+nJVKSeziH5+T8PS/+
/VvYj1D3ejWWH7QmLxVxgJtoVqB51DtuTWzUzU6/N/x4ZoJ/x13khb1wUakjwhjqPsPRqutyI6t+
8Nl9qLuj46DBIPyHbYVPcRvTXWoVGoGm1SzU3xDK/yKPmveQ0fyKq/Q9qtOYLfSCHkNr1Y5UMNBm
G1OwXfGMDMRgvZUEBSOUDgPw2dEXvyPdtvwgtr68+A6bXGr82kJfZeznltnorljrDwaieTTGzq7Z
gO5YTP6TQYv6vWwoP31jpTv8ooSA4oS3aAINoI12ZJ7Xtfc9jf90U2FHFANNiPi6
--000000000000d317d505dedb99e2--
