Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84828B137
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgJLJLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbgJLJL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:11:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F07FC0613D2
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:11:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so13637262pgf.9
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wKVcZbh83k6X/F14A+ztOkjMdocn7bFn38YmFQmh5vQ=;
        b=gmsr73QMhy44nj2bUAT5Nu2x64BPwQjJKIgVIdVt0t+0Puc+DBwhg+nUVlg7ejQVeQ
         oHj9vPjQ2uneN1RI8kymY9G+B/7tpXU1NxarTKjif82tj9rQRL/S2lmetE8Lxg8O68Qr
         ezRpzMOYDMxZX22wG/jfMbGN4zBQVHXeZx3BU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wKVcZbh83k6X/F14A+ztOkjMdocn7bFn38YmFQmh5vQ=;
        b=E+AyX7mFuk5aI7aWRr6VHKI9iIFymoVLxWQcc2ws2VMqA2FE63mOGO0Byc8HzU/gc1
         Vi34FByUMjH25s2o6XcEmm4MA/pMNY9I6ov2G9cj6RAUKeS/A7VuI71tNnH8bgq5pidw
         AmVap5B+eCMh7lM/hAYZjNE0jQMR6Ez8mmUuSMSBtW9+Qa/Sh1ZleDRXNzWU3D1bjQtS
         81p1bRh1631nPGlhz8ATzZuKB4iwfjNc5IWcO42yctGa7Ykz6ldI2Rb4grNUrgxlB16m
         Wez4jcYxBUS5ZY6/0nsZYuD7fyzLV9Ocir4pJNMYJuWD33Lk2QhQPuVjagy3HYYnY5eP
         3ilg==
X-Gm-Message-State: AOAM532sz0rrdUStVf9UHiI8AHZXGSVgXsuHNHbOqR4SXX0dpXMekgPt
        2to28uLWm38CtbLcsG2+oXbl/5LgDShkdQ==
X-Google-Smtp-Source: ABdhPJy978tl0KNWJ9glZaS9pIMPXOl7V5IExBq5LgvETfdBAkg/9gextptUIFj05UF6ckNwpuwCjw==
X-Received: by 2002:a62:ab0e:0:b029:156:1dfe:ae74 with SMTP id p14-20020a62ab0e0000b02901561dfeae74mr3729906pff.7.1602493886539;
        Mon, 12 Oct 2020 02:11:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id jy19sm1275932pjb.9.2020.10.12.02.11.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 02:11:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 9/9] bnxt_en: Add stored FW version info to devlink info_get cb.
Date:   Mon, 12 Oct 2020 05:10:54 -0400
Message-Id: <1602493854-29283-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602493854-29283-1-git-send-email-michael.chan@broadcom.com>
References: <1602493854-29283-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e3616705b175ae8f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e3616705b175ae8f

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This patch adds FW versions stored in the flash to devlink info_get
callback.  Return the correct fw.psid running version using the
newly added bp->nvm_cfg_ver.

v2:
Ensure stored pkg_name string is NULL terminated when copied to
devlink.

Return directly from the last call to bnxt_dl_info_put().

If the FW call to get stored version fails for any reason, return
success immediately to devlink without the stored versions.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 47 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0be9b46baaca..184b6d0513b2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -410,6 +410,7 @@ static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
+	struct hwrm_nvm_get_dev_info_output nvm_dev_info;
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	union devlink_param_value nvm_cfg_ver;
 	struct hwrm_ver_get_output *ver_resp;
@@ -457,6 +458,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+			      bp->nvm_cfg_ver);
+	if (rc)
+		return rc;
+
 	buf[0] = 0;
 	strncat(buf, ver_resp->active_pkg_name, HWRM_FW_VER_STR_LEN);
 	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
@@ -469,7 +476,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
 			ver & 0xF);
-		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 				      buf);
 		if (rc)
@@ -517,7 +524,43 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
-	return bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	if (rc)
+		return rc;
+
+	rc = bnxt_hwrm_nvm_get_dev_info(bp, &nvm_dev_info);
+	if (rc ||
+	    !(nvm_dev_info.flags & NVM_GET_DEV_INFO_RESP_FLAGS_FW_VER_VALID))
+		return 0;
+
+	buf[0] = 0;
+	strncat(buf, nvm_dev_info.pkg_name, HWRM_FW_VER_STR_LEN);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW, buf);
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
+
+	snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		 nvm_dev_info.roce_fw_major, nvm_dev_info.roce_fw_minor,
+		 nvm_dev_info.roce_fw_build, nvm_dev_info.roce_fw_patch);
+	return bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
 }
 
-- 
2.18.1


--000000000000e3616705b175ae8f
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgPmC2NSwLarG0
FXVpRgwZAYLYkPhi7+ec2R6fNFla0tEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDEyMDkxMTI2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE8NgN3GQEb78ak9LSOZDndwv3a8UHFM
rkDC58HnZmW6LJzu+MrTeP8Kc1w9llRy5Qk/ePO9lH0PjG/NQ5pqiQCce3i5BZemDmTsdeKVWwSi
iYomyFYH/YE/HaWjaTQ5FgjNfu9TpMa+GgwpJzh1lsWM7uxUW3SHvLtuWBTF5IaULZv7vcvhDoCx
rhf1y+3YCvSnmYCvQd5P8aT/pNZWm8VeiCKslW/9gkcSQuFkpWNTnf2wVvQz/l7OL+cbVlEROm6M
VpP9bL+zvWj1c1nMXc+aLEl74ooLBdXzvS9KITbQp004twigOsWiP5X6DABdxFmHFcpmXpVHmgsP
UGpxP+k=
--000000000000e3616705b175ae8f--
