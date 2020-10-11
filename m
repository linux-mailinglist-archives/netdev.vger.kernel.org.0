Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E5528A6F3
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 12:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgJKKXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 06:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgJKKXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 06:23:32 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459F7C0613D6
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i2so11229916pgh.7
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NytSwevh7wbHFx2ANtUbe15026p0VcH4xRVPkKzUPuo=;
        b=BblzkU0iQ5/p6l1rB2BBXR36dgnG1jnE8ETkuRYJh9PVBL62nI3Kbf5NsKJc2KhaJj
         RAP+tXpEdwFlD7mGKTdCJMWO/hisjknsIiIwuF1mOzbv8cjlvft6x/SCLMkgDjvhphnD
         5xnZB+Uhuwv0HYNtRnjj1vdU+9z+2CHlCHeDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NytSwevh7wbHFx2ANtUbe15026p0VcH4xRVPkKzUPuo=;
        b=EE0bPWwdpszfTHXmk4qZXdy7TOtrqn5l6Kbui9v1sTtITboq8Q0KW70+Piy0K7RlSV
         Oh5jMbT+huxFrv+1v96buwpOmsGsoaVnMuZQRF5izCTyBmYN6b6JshVJLekxfwtOGQac
         FRFIcM/NUkLjsFYVroBwQNsqx/GlWRNp6yZBiLiDrk16BBSnWTzqCXakk2ahBWR7NlqL
         LMJemKDUeuYaD4eC1MFtoIIl9BCMS9sUnruaHgYYYIQCASreaCm7vCu5L+TLBQNIvzZB
         4T2NogjGIHCzZY9m//7UupGmGRPP0VfRO63CgO9UyfzQcfMmq3V8zUBQ+CFLIY5OogXn
         Czag==
X-Gm-Message-State: AOAM530a0dopYsYZ+kZLSeXtNF/0ulUL/jalc4QlHpyJckYN5kTtSUuN
        ryD+4bLlrvE5PSJzPUJannz/pNWDa+TXqQ==
X-Google-Smtp-Source: ABdhPJwU+gZCUvagSjgSSBrK75ElZJrWEP3FF+K6zs4Q2LmKqxf3/CiLg63iwtnroDZ/6S/5aTA5NQ==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr9406624pgh.273.1602411810661;
        Sun, 11 Oct 2020 03:23:30 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i1sm20155057pjh.52.2020.10.11.03.23.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 03:23:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 9/9] bnxt_en: Add stored FW version info to devlink info_get cb.
Date:   Sun, 11 Oct 2020 06:23:01 -0400
Message-Id: <1602411781-6012-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c884bb05b162923c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c884bb05b162923c

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This patch adds FW versions stored in the flash to devlink info_get
callback.  Return the correct fw.psid running version using the
newly added bp->nvm_cfg_ver.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 65e8da1f7a01..7631c2d4c19e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -408,6 +408,7 @@ static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
+	struct hwrm_nvm_get_dev_info_output nvm_dev_info;
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	union devlink_param_value nvm_cfg_ver;
 	struct hwrm_ver_get_output *ver_resp;
@@ -455,6 +456,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+			      bp->nvm_cfg_ver);
+	if (rc)
+		return rc;
+
 	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
 			      DEVLINK_INFO_VERSION_GENERIC_FW,
 			      ver_resp->active_pkg_name);
@@ -466,7 +473,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
 			ver & 0xF);
-		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 				      buf);
 		if (rc)
@@ -516,7 +523,43 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
 			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	if (rc)
+		return rc;
+
+	rc = bnxt_hwrm_nvm_get_dev_info(bp, &nvm_dev_info);
+	if (rc)
+		return rc;
+
+	if (!(nvm_dev_info.flags & NVM_GET_DEV_INFO_RESP_FLAGS_FW_VER_VALID))
+		return 0;
+
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW,
+			      nvm_dev_info.pkg_name);
+	if (rc)
+		return rc;
+
+	snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		 nvm_dev_info.hwrm_fw_major, nvm_dev_info.hwrm_fw_minor,
+		 nvm_dev_info.hwrm_fw_build, nvm_dev_info.hwrm_fw_patch);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, mgmt_ver);
+	if (rc)
+		return rc;
+
+	snprintf(ncsi_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		 nvm_dev_info.mgmt_fw_major, nvm_dev_info.mgmt_fw_minor,
+		 nvm_dev_info.mgmt_fw_build, nvm_dev_info.mgmt_fw_patch);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_NCSI, ncsi_ver);
+	if (rc)
+		return rc;
 
+	snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		 nvm_dev_info.roce_fw_major, nvm_dev_info.roce_fw_minor,
+		 nvm_dev_info.roce_fw_build, nvm_dev_info.roce_fw_patch);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
 	return rc;
 }
 
-- 
2.18.1


--000000000000c884bb05b162923c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgSkZZWdtFJlyZ
8xOLGO9gxD4vTpb0GTFZcwsvA7Vboc0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDExMTAyMzMxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIBkgylaHRzAuACoM3kKZqjSchN26tA/
5gr+WtaalHVz5xcIWV8nZKVV53m+5ChLp/3zCvrWWN9NPjuw9vUXx/yFVQCuWHYGTrSYmSryFSHb
P9XkDK/HpkOw9QwoorNh3PUQ616l6wri6itp+HruH4wwDDfw4PlnJX8Amq0nx8sAG1go9RiZqdCj
wcyzzMiEKa4cP5Hq9c76XTpt139K0DH1G9cQOSyWzsaS9R+jROm2MbTFT+pGvw6WpmPXcMnR2IhJ
pqzXHpCOes5IdahbkCtB5DBugFmx95mEokJT7NhZePB0l2flhijs9m39OJfMbMaWKVXrSPAzcSE3
UxWhCZo=
--000000000000c884bb05b162923c--
