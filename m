Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9418193E8D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgCZMEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:04:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51299 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZMEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:04:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id c187so6190249wme.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l16SECPU6+s+EGp9FZXtuDONMcsGKrhWWZnsnzB88ag=;
        b=MSmXvN0xbrUaoBMP7TsEvu6hj8w6WL2T9y+xYe16VH6PTDCSN0LCTOmKRiLTvOfKbr
         0PwcR4dVSgbt9Abl5rxiTMBQEPOgrOPa54gLM3pkCc+xXCc9yFrhhEbMSHB3Q00XHmpi
         81/A86XdgomKgUMAVQE74tbcnXY5ufoG4j9v4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l16SECPU6+s+EGp9FZXtuDONMcsGKrhWWZnsnzB88ag=;
        b=TpHpO74pp5guCghVapIXhPrrssncx2edh6hn+kH0Xaf5jAwx3MyiPMGQbNNVOD4+H4
         XuXd/pDwgAO4OsWXh4fDhbSM7ltfW9Q0tl1vS6tmAZ+9rF1orc/pmYUr5bMEXwXIhem8
         GB2aL7MWi7LMPyE3uTu5NtkuQVkBtAgOFvVxYtbknc4cVKjxDcYbgvL+bp8BvE3+lG5q
         qcN0D03d++ZhgaiyiBdvqzEVPXCWDABy2hnV3sxmwMj5I5AJ2V/5y81WPizCxitfIQPG
         y7XxdfqDjPj6QD6/KxjpCqmHO6mMQjb39jVtAxNmEyD4bELlWTU5UBI7d7GqJ+r4VMm4
         J6Yw==
X-Gm-Message-State: ANhLgQ1sY9ddR94kJthZjijEGQNRyzVa46vJcxr1EKWQ8oHfpm1MkbXB
        /6gh9aBlsurlGua+JpjyHyN0og==
X-Google-Smtp-Source: ADFU+vtUXmM04OC9Ha6rPPPO9IZ7Wh/Td4K0iq9wvR2yjtCEJTgGdE6vRktkwZccy6+bNOhqCntLtw==
X-Received: by 2002:a05:600c:25a:: with SMTP id 26mr2854882wmj.85.1585224281248;
        Thu, 26 Mar 2020 05:04:41 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k84sm3316637wmk.2.2020.03.26.05.04.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:04:40 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v3 net-next 2/5] bnxt_en: Add fw.api version to devlink info_get cb.
Date:   Thu, 26 Mar 2020 17:32:35 +0530
Message-Id: <1585224155-11612-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
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

