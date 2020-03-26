Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF253193898
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCZG3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:29:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40700 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZG3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:29:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id u10so6306555wro.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l16SECPU6+s+EGp9FZXtuDONMcsGKrhWWZnsnzB88ag=;
        b=FWkKTF6z1v485w3mFdxlvhw7SIlr+pYaMnckEuhXu2ztbgbgAH+HOrclPeQhhtShsD
         Cf/Qlzu2Ar6Q8ygRyNSRFPx17xh/D+dDG3z00/HwvXqd6KrVRgUWGqFrncPXW1NpLcLp
         JNZFe/k4XraKHsE7ziSVPOp4w6d3vel7yZQO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l16SECPU6+s+EGp9FZXtuDONMcsGKrhWWZnsnzB88ag=;
        b=BEzKId2mJ1ncKBh1VrsrYe9Jy3PbPJ19JI1jyTUQQqZ4eTWewaWMYIAbGqk9hjRBnc
         n5pePL9VOCNC9LENtZSKGcp+eYMOTyWOX5s2c+s+GEqN6IbPIqKNK94pKjXzayrFMWWo
         uI9EDLYIcPoNSPOqVbAmrkYhC4QuPrr8JZm044UQ4w9ERQkTW+TrwGwgfGAEAyWqLitl
         2O0PDCjAsKnStDuVGGpR6csmqjhQywuzUMWsN+KF7/W95da+1UwFBfnBYUcITTfVlbKR
         IJ+ThpYkBaQW5zNCjFb5YcnQ5V6rPM3Okq9pNBlYM+i3LZP2+LJKZ1AjyCAPy7PzAOwg
         bJ9A==
X-Gm-Message-State: ANhLgQ2FiWLT7WGswMeyUE2pvBhu75BpWPgJsnCe6kd6jmL7TPU72qjz
        yvMajbLIWMAUZ5MQbSFMv5of5Q==
X-Google-Smtp-Source: ADFU+vupSqlOTsHFpFd7oVO0rciBugVsiUte3OO+QAOGG6JUL9vozm6ukniF5uS4zbWtLmn8U/81WQ==
X-Received: by 2002:a5d:6605:: with SMTP id n5mr7372559wru.303.1585204189881;
        Wed, 25 Mar 2020 23:29:49 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y200sm2106768wmc.20.2020.03.25.23.29.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:29:49 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 2/7] bnxt_en: Add fw.api version to devlink info_get cb.
Date:   Thu, 26 Mar 2020 11:56:59 +0530
Message-Id: <1585204021-10317-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Display the minimum version of firmware interface spec supported
between driver and firmware. Also update bnxt.rst documentation file.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Display the minimum version of fw spec supported between fw and
driver, instead of version implemented by driver.
---
 Documentation/networking/devlink/bnxt.rst         |  3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 15 ++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  5 +++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 82ef9ec..71f5a5a 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -63,6 +63,9 @@ The ``bnxt_en`` driver reports the following versions
    * - ``fw``
      - stored, running
      - Overall board firmware version
+   * - ``fw.api``
+     - running
+     - Minimum firmware interface spec version supported between driver and firmware
    * - ``fw.app``
      - stored, running
      - Data path firmware version
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 663dcf6..7bcd313 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7223,7 +7223,7 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 static int bnxt_hwrm_ver_get(struct bnxt *bp)
 {
 	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
-	u32 dev_caps_cfg;
+	u32 dev_caps_cfg, hwrm_ver;
 	int rc;
 
 	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
@@ -7243,6 +7243,19 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 			    resp->hwrm_intf_upd_8b);
 		netdev_warn(bp->dev, "Please update firmware with HWRM interface 1.0.0 or newer.\n");
 	}
+
+	hwrm_ver = HWRM_VERSION_MAJOR << 16 | HWRM_VERSION_MINOR << 8 |
+			HWRM_VERSION_UPDATE;
+
+	if (bp->hwrm_spec_code > hwrm_ver)
+		snprintf(bp->hwrm_ver_supp, FW_VER_STR_LEN, "%d.%d.%d",
+			 HWRM_VERSION_MAJOR, HWRM_VERSION_MINOR,
+			 HWRM_VERSION_UPDATE);
+	else
+		snprintf(bp->hwrm_ver_supp, FW_VER_STR_LEN, "%d.%d.%d",
+			 resp->hwrm_intf_maj_8b, resp->hwrm_intf_min_8b,
+			 resp->hwrm_intf_upd_8b);
+
 	snprintf(bp->fw_ver_str, BC_HWRM_STR_LEN, "%d.%d.%d.%d",
 		 resp->hwrm_fw_maj_8b, resp->hwrm_fw_min_8b,
 		 resp->hwrm_fw_bld_8b, resp->hwrm_fw_rsvd_8b);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5adc25f..cc57538 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1730,6 +1730,7 @@ struct bnxt {
 #define BC_HWRM_STR_LEN		21
 #define PHY_VER_STR_LEN         (FW_VER_STR_LEN - BC_HWRM_STR_LEN)
 	char			fw_ver_str[FW_VER_STR_LEN];
+	char			hwrm_ver_supp[FW_VER_STR_LEN];
 	__be16			vxlan_port;
 	u8			vxlan_port_cnt;
 	__le16			vxlan_fw_dst_port_id;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index d3c93cc..51abc6c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -434,6 +434,11 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	rc = devlink_info_version_running_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_FW_API, bp->hwrm_ver_supp);
+	if (rc)
+		return rc;
+
 	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
-- 
1.8.3.1

