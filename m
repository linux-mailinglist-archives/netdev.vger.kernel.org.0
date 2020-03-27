Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C75195428
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgC0JhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:37:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38359 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0JhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:37:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so10562924wrv.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WIOJvD+qI3Pz8TP5n9WY9mwIGhj8zmOv/alwKMCbjxc=;
        b=HljasrwWfHU7pOrte52zx6kumirOpTllRi34goidT3fuOv4IyInReEXy9Ap1m7dkHQ
         E10qHFMQFtTSQibZ1nWlu3MB8GUkaIE7J8MZACtg2udLYXmT0661+nnbSaaFKq0RNJfX
         FZsR2OUPl7g5IklBVrA0MyDa18q62SND3BEo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WIOJvD+qI3Pz8TP5n9WY9mwIGhj8zmOv/alwKMCbjxc=;
        b=TsPwrELTM7lF94conj7gYYs5zX9rsVxN60sd7ceWvGQmVYEHQEfUgctKMygwE+WqJ2
         b66oQmfknFKGJur9ot/AfhgLbd8c3t/VHYH4hSi+kGAzxut7PWeX6xs6dMuQlYbbQXHy
         5W+v7ktAzBTJ7BrYXK9x7TIw96EMN2i3Bii9AkLCEz9pYzKfm7JmCZxOMd7bnIuzgI/+
         Cv1byTzeGlYt4F+8hO+0NYuWfQTjPJNmLGZKvyjvgxvn9svfaa/W6a1hwk119r3iIKoS
         /SYn0IfQfazppk83I0KlK0XlHNvv6040+L5X0QwAq/pUmiTq93GkXSGkssVUHI3YHX0x
         sCnA==
X-Gm-Message-State: ANhLgQ1WyOuBgBc1aVpjxhWMY9fBmUlvtX7xdzN/2Pa9rPnocubrWPsZ
        7yEQE1ouzqQisim9HyHx6V+6oQ==
X-Google-Smtp-Source: ADFU+vu48hD6XSImn1MexhXIi+FtQtq6H22f9WVIOG2CNiRVPFTmw31YWVNeeWFR2ME7bCJUoFdIEA==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr14633320wrv.92.1585301821791;
        Fri, 27 Mar 2020 02:37:01 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g186sm7607450wmg.36.2020.03.27.02.36.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:37:01 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 2/6] bnxt_en: Add fw.mgmt.api version to devlink info_get cb.
Date:   Fri, 27 Mar 2020 15:04:52 +0530
Message-Id: <1585301692-25954-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
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
v3->v4: Rename "fw.api" to "fw.mgmt.api"
---
 Documentation/networking/devlink/bnxt.rst         |  3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 15 ++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  6 ++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 82ef9ec..7ab34c9 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -66,6 +66,9 @@ The ``bnxt_en`` driver reports the following versions
    * - ``fw.app``
      - stored, running
      - Data path firmware version
+   * - ``fw.mgmt.api``
+     - running
+     - Minimum firmware interface spec version supported between driver and firmware
    * - ``fw.mgmt``
      - stored, running
      - Management firmware version
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1ea8028..3861dff 100644
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
index eaf20e3..a1e9d33 100644
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
index d3c93cc..39c2ac4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -475,6 +475,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	rc = devlink_info_version_running_put(req,
+				DEVLINK_INFO_VERSION_GENERIC_FW_MGMT_API,
+				bp->hwrm_ver_supp);
+	if (rc)
+		return rc;
+
 	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
 		rc = devlink_info_version_running_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, mgmt_ver);
-- 
1.8.3.1

