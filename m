Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A324519389B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgCZGaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:30:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52968 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:30:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id z18so5253952wmk.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nMgRInYm5EcLhOwJzJbTfgaZsC41eL0hVit2N55QZBU=;
        b=JgHvoublbWJU5zDDZueadtY+GizMAt9xfMJw6O3twoVT1lPWLIqtsy1U3W1qt58XT9
         rb8Geev0IGQ4ke2WRb6qiYeJcWD6Kx7EMNSrYZbHfLUke/oHpd7Gro6l2ysUa3fUBg7R
         e0Nh2NGH8nXTdp7agO0LoKDBkQLLUwTi0cFvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nMgRInYm5EcLhOwJzJbTfgaZsC41eL0hVit2N55QZBU=;
        b=ot9qSC14K0P8Ki2vmv1+PT64SQi2sMIxFjxz9GfAA1HAr9Zi1aUVAqGk7Bup59VhIc
         QlChup2bMeq7GCBSpyc04fgdwMlAXzCrHXQAPzas+1XjaAgTfWofOx+0y7UGzb3CkYqF
         j73VMOdvEd/U8w0uDZEZj7dRIW5yNmfgRsQp8xmLKe+3y4ZdY+TDCh+jnxQUrBs21C08
         CSX2uA3VapWIBnwNzTROSfXiRjnAAzslqrciZnFDNRoY0ZrZoK0JrB7iUaHLEgwaLQvH
         mCFvs7DPvyhxig3Kxh3e2CMmtLZ8lBARiCrW9j4tP+4Uba9nWjZv7GsyvuFucFR3UfvH
         x66A==
X-Gm-Message-State: ANhLgQ0Nv0v2bZgS70p11JnUcRGfePJ0wZnDYNGgOACJTANNs/607aTr
        ZOSc/prw+DTslsLw55NXkgU9KA==
X-Google-Smtp-Source: ADFU+vuQ31eUuCG49wHG8RXoN1BBGYUoCrlE+nHpWwetjUuaClwRZGXuGJosaGoxJ3hpN/vhFFEJ9g==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr1377267wmk.125.1585204209655;
        Wed, 25 Mar 2020 23:30:09 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y200sm2106768wmc.20.2020.03.25.23.30.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:30:09 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 4/7] bnxt_en: Add hw addr to devlink info_get cb.
Date:   Thu, 26 Mar 2020 11:57:01 +0530
Message-Id: <1585204021-10317-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also update bnxt.rst documentation file.

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Remove mutlihost base hw addr info.
---
 Documentation/networking/devlink/bnxt.rst         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 71f5a5a..a514664 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -57,6 +57,9 @@ The ``bnxt_en`` driver reports the following versions
    * - ``asic.rev``
      - fixed
      - ASIC design revision
+   * - ``hw.addr``
+     - stored, running
+     - Hardware address of the interface
    * - ``fw.psid``
      - stored, running
      - Firmware parameter set version of the board
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 51abc6c..493a9eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -425,6 +425,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	sprintf(buf, "%pM", bp->dev->dev_addr);
+	rc = devlink_info_version_running_put(req,
+				DEVLINK_INFO_VERSION_GENERIC_HW_ADDR, buf);
+	if (rc)
+		return rc;
+
 	if (strlen(ver_resp->active_pkg_name)) {
 		rc =
 		    devlink_info_version_running_put(req,
-- 
1.8.3.1

