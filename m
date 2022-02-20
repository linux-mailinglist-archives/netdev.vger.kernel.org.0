Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646D24BCDA3
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiBTJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:06:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243488AbiBTJGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:06:45 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758F831919
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 01:06:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so689127pjw.5
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 01:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HfOcs845FH3udlQwQ+9qKjD6VpJOWPeDp/jF0QyG82w=;
        b=dgxJ3hdHCzlk0i9gAnTHXGek6YG2FaFWyBrhsc6+2wa+FXm1Bq/AqxG5CM6nUWYlnY
         fngrIhygchPNs1I9X/646ydflaeYr9id9jQmv/py9ls4M8b3uPqkCXB1y26jLoYesLmw
         QRpClAY2a0f+aHSwbXQDEelRXFtXoOzxsxvKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HfOcs845FH3udlQwQ+9qKjD6VpJOWPeDp/jF0QyG82w=;
        b=6sBYftwvVVsVTT+7+tbLAIPwPyEp7ffUL8/qVmGXO/rDlKd9i3aAdOc53JIHnZ/3OH
         ozpRpVWrw5HpSE/lmYG4icDjtB3wCSpkA0ZYcwN76M6naCeUmYcIEa9KnqjGVtJWA4kw
         gHwL+qGoC7JPRoXEhXiEJPpc0kdt1VthjzcXaJlKiyghjaKCzA7whNBBJVJVRQ/95m8I
         R/AF932IleMQToGWhWCbdhOO7jhcM5BTTXM1FJAM/wdxQvoGKLLNbNl2R2mMAutZdCV1
         shfWh9Q/qamCeE9reJ7foKj6Dk1ETg4vi/Zk5PwL2xXj+Gn20SmPTKbdyjK56qfwfLZ0
         6XGw==
X-Gm-Message-State: AOAM532yx+xo570BosRgVZehIzp9UPgB1epYsezTA17Iz4wxGs0aQOet
        t6i/YoYeflkPBjWgxW/s4j90I2kUvcEwXQ==
X-Google-Smtp-Source: ABdhPJx0bfEF40ECB+7NlhftrOebnuUmv61eCq0ltbvIAr4lq67WrAQZX2BjV8QN5KDyGwtQyCFjZw==
X-Received: by 2002:a17:902:ec83:b0:14f:ba2b:990c with SMTP id x3-20020a170902ec8300b0014fba2b990cmr353756plg.119.1645347984611;
        Sun, 20 Feb 2022 01:06:24 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090b068500b001b9bef22bf5sm4061865pjz.5.2022.02.20.01.06.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Feb 2022 01:06:24 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Subject: [PATCH net 7/7] bnxt_en: Fix devlink fw_activate
Date:   Sun, 20 Feb 2022 04:05:53 -0500
Message-Id: <1645347953-27003-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
References: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000313e8005d86f6eef"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000313e8005d86f6eef

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

To install a livepatch, first flash the package to NVM, and then
activate the patch through the "HWRM_FW_LIVEPATCH" fw command.
To uninstall a patch from NVM, flash the removal package and then
activate it through the "HWRM_FW_LIVEPATCH" fw command.

The "HWRM_FW_LIVEPATCH" fw command has to consider following scenarios:

1. no patch in NVM and no patch active. Do nothing.
2. patch in NVM, but not active. Activate the patch currently in NVM.
3. patch is not in NVM, but active. Deactivate the patch.
4. patch in NVM and the patch active. Do nothing.

Fix the code to handle these scenarios during devlink "fw_activate".

To install and activate a live patch:
devlink dev flash pci/0000:c1:00.0 file thor_patch.pkg
devlink -f dev reload pci/0000:c1:00.0 action fw_activate limit no_reset

To remove and deactivate a live patch:
devlink dev flash pci/0000:c1:00.0 file thor_patch_rem.pkg
devlink -f dev reload pci/0000:c1:00.0 action fw_activate limit no_reset

Fixes: 3c4153394e2c ("bnxt_en: implement firmware live patching")
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 4da31b1b84f9..f6e21fac0e69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -367,6 +367,16 @@ bnxt_dl_livepatch_report_err(struct bnxt *bp, struct netlink_ext_ack *extack,
 	}
 }
 
+/* Live patch status in NVM */
+#define BNXT_LIVEPATCH_NOT_INSTALLED	0
+#define BNXT_LIVEPATCH_INSTALLED	FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL
+#define BNXT_LIVEPATCH_REMOVED		FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE
+#define BNXT_LIVEPATCH_MASK		(FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL | \
+					 FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE)
+#define BNXT_LIVEPATCH_ACTIVATED	BNXT_LIVEPATCH_MASK
+
+#define BNXT_LIVEPATCH_STATE(flags)	((flags) & BNXT_LIVEPATCH_MASK)
+
 static int
 bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 {
@@ -374,8 +384,9 @@ bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 	struct hwrm_fw_livepatch_query_input *query_req;
 	struct hwrm_fw_livepatch_output *patch_resp;
 	struct hwrm_fw_livepatch_input *patch_req;
+	u16 flags, live_patch_state;
+	bool activated = false;
 	u32 installed = 0;
-	u16 flags;
 	u8 target;
 	int rc;
 
@@ -394,7 +405,6 @@ bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 		hwrm_req_drop(bp, query_req);
 		return rc;
 	}
-	patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_ACTIVATE;
 	patch_req->loadtype = FW_LIVEPATCH_REQ_LOADTYPE_NVM_INSTALL;
 	patch_resp = hwrm_req_hold(bp, patch_req);
 
@@ -407,12 +417,20 @@ bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 		}
 
 		flags = le16_to_cpu(query_resp->status_flags);
-		if (~flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL)
+		live_patch_state = BNXT_LIVEPATCH_STATE(flags);
+
+		if (live_patch_state == BNXT_LIVEPATCH_NOT_INSTALLED)
 			continue;
-		if ((flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE) &&
-		    !strncmp(query_resp->active_ver, query_resp->install_ver,
-			     sizeof(query_resp->active_ver)))
+
+		if (live_patch_state == BNXT_LIVEPATCH_ACTIVATED) {
+			activated = true;
 			continue;
+		}
+
+		if (live_patch_state == BNXT_LIVEPATCH_INSTALLED)
+			patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_ACTIVATE;
+		else if (live_patch_state == BNXT_LIVEPATCH_REMOVED)
+			patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_DEACTIVATE;
 
 		patch_req->fw_target = target;
 		rc = hwrm_req_send(bp, patch_req);
@@ -424,8 +442,13 @@ bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 	}
 
 	if (!rc && !installed) {
-		NL_SET_ERR_MSG_MOD(extack, "No live patches found");
-		rc = -ENOENT;
+		if (activated) {
+			NL_SET_ERR_MSG_MOD(extack, "Live patch already activated");
+			rc = -EEXIST;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "No live patches found");
+			rc = -ENOENT;
+		}
 	}
 	hwrm_req_drop(bp, query_req);
 	hwrm_req_drop(bp, patch_req);
-- 
2.18.1


--000000000000313e8005d86f6eef
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEII2+fHFME7wLtfDvkAcAY5A0uklPIzt3
0DuN69oxGwUmMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDIy
MDA5MDYyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA+tdhlQGROh5OBMj+WYa5TzixIydxvhAMMzcTrASip4ar2YiGa
arxB98lQvEWo9yx6UEajJoP8idLPshINhL2bhTXfHNpvYxlgXoFSbnYeSfQpu0ZKHk5r5wkShyyS
eY+iuhEN9mM+oT0q2la60vzKWLyuo60+q69Tk2qX8WKbZ4AhoyV8f9jWxqtveNoQr68Cz7IUYDSp
yJCS37bHBfTuCD5LrDoVNVlXGCfN1fDfL8eG7nUqAs0HLfYfjt6mjsHRXAJHzme5hkEpZiYX9UwP
I2rRyWuAjO+lZ/wGqf1axnuEK78PoN3J2lqM4+cYdtvarPqY4wpBll95muYbTOUE
--000000000000313e8005d86f6eef--
