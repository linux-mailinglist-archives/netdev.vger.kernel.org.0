Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43554CE3B3
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiCEIz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiCEIzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:55:55 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3402525B6
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e6so9465708pgn.2
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ktL21C6yJ/8g9EUyS5/aJvlisDdS/FCE22KeszpBEF0=;
        b=MtPXPJ5E8O0fZ2yjip9YX94rXFd9kZGtGx/MtzW2flIBwwk6jq5WOYWzpM2xQ/C+26
         1ERLmZpr/a2qwdc0jnYPbBY8Xp30fJmbn081yFkjuO06jBbzqqaEhruqpziZhIZgFUKq
         RtctlAjnfOSKuKWKx76Q/eKShOzuuzgmfsMLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ktL21C6yJ/8g9EUyS5/aJvlisDdS/FCE22KeszpBEF0=;
        b=kCxedWT18eNQEHcxeeO+FFAr7f9p+mWrISG/BfWtD1/4b0eJ5j8H4IuUSWP3lxY5qb
         8kEzicskItLzmJd4moO4d9y7isNs72gPP3/CdgLKF1jcj1xPSCxKIz/J64Jjh2WGDOo2
         TGJmpi3zUapXzZLM8yJpbSngXaVLab5r3NwjxKnZ1abI/7hqluN9tJGi0LxxDtzVfLZP
         gA7jKiLmpf7HvDTSAm3/7kwHGJapOsVluxIrFKPdv4UxPFMsMNKtafxilwPze+fVGXoj
         Ye3fVXH/55PtberFQaqLPnQK6WO0rO6zrCg564a9SnYCbjqPVs8ayi9uqPGRDoBjsQA0
         6tmQ==
X-Gm-Message-State: AOAM532PRNzoDX9WsL9fGBT64Xbfcg1D+6IN9IoAj1cJhOQsJz8qocpa
        Xd/X/nTrxpis0MpRNU+CqfQSRQ==
X-Google-Smtp-Source: ABdhPJxa2B07xfbmCZ6AxQpM9ZOfLCADrxbEuyteACtUHSIcvOdvL8c+saxZ3oehHLYXLQwoAjUMzA==
X-Received: by 2002:a63:2b4d:0:b0:36c:7c39:b66c with SMTP id r74-20020a632b4d000000b0036c7c39b66cmr1984066pgr.583.1646470505213;
        Sat, 05 Mar 2022 00:55:05 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:04 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 3/9] bnxt_en: parse result field when NVRAM package install fails
Date:   Sat,  5 Mar 2022 03:54:36 -0500
Message-Id: <1646470482-13763-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009fb13905d974c95e"
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

--0000000000009fb13905d974c95e

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

Instead of always returning -ENOPKG, decode the firmware error
code further when the HWRM_NVM_INSTALL_UPDATE firmware call fails.
Return a more suitable error code to userspace and log an error
in dmesg.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 44 ++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a3151af9a279..3927ceb581da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2496,6 +2496,48 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 	return rc;
 }
 
+static int nvm_update_err_to_stderr(struct net_device *dev, u8 result)
+{
+	switch (result) {
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TYPE_PARAMETER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_INDEX_PARAMETER:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_DATA_ERROR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_CHECKSUM_ERROR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_NOT_FOUND:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_LOCKED:
+		netdev_err(dev, "PKG install error : Data integrity on NVM\n");
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
+		netdev_err(dev, "PKG install error : Invalid package\n");
+		return -ENOPKG;
+	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_AUTHENTICATION_ERROR:
+		netdev_err(dev, "PKG install error : Authentication error\n");
+		return -EPERM;
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_CHIP_REV:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_DEVICE_ID:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_VENDOR:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_ID:
+	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_PLATFORM:
+		netdev_err(dev, "PKG install error : Invalid device\n");
+		return -EOPNOTSUPP;
+	default:
+		netdev_err(dev, "PKG install error : Internal error\n");
+		return -EIO;
+	}
+}
+
 #define BNXT_PKG_DMA_SIZE	0x40000
 #define BNXT_NVM_MORE_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_MODE))
 #define BNXT_NVM_LAST_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_LAST))
@@ -2650,7 +2692,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	if (resp->result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
 			   (s8)resp->result, (int)resp->problem_item);
-		rc = -ENOPKG;
+		rc = nvm_update_err_to_stderr(dev, resp->result);
 	}
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
-- 
2.18.1


--0000000000009fb13905d974c95e
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEII9lE+rD5jHkN83Q6cklSLF1s8j+D6kL
rv54Wluwj9C8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBDLesIk9JVpWyrJxpTxo0E4YgrisBOPMdbc+OmO5DhR2PIO3E/
ooPQdpwXwo07HLq1OWjNkH1gIO6AYl13YygYCwsxZaolKe4S77dkmIFeNBit4JSgtY/d7n3EnFkp
Y/25GzC5R67WN1kkglAnWMVvfoZ9WU1FYsfHlFusU1u6ywC80gW39OQaw08r/Y7OULZvTwHDEgsC
/unOo2cjDlRBAYPZTVvcCD72L0USx99vV3VBYmiLg6S7e3LD6g/ZWvGaPSEVQ7JhMv9UhGxQZaEi
pmNOdwP4JOxTbZyIG2quFn2xHAalzP1nLBQGzv8OD0GcJATZzUomm1y0on+gz6hm
--0000000000009fb13905d974c95e--
