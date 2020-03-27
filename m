Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A554219542D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgC0Jhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:37:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54299 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0Jhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:37:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id c81so10689783wmd.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XhhpLzfapqrY15cIXnuhpl4Gh6lePVazE90jqwSKcYA=;
        b=FtqePiUtNcv+Kxoo7wv1tdSQ50PfTW2/XO+RaPQCeyyhJ9oEBhCJojwY6wYdCx4Lj0
         /882ZgHB5XyFGpUnX6Do8i3Dn+0AyCgNV1xgZiB3JmlWOURm6McmhDUbsE6CzFkzrvw/
         Z4aSWGHRUBbqdlrM0LnuT9c7Q3lbDqbN84zEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XhhpLzfapqrY15cIXnuhpl4Gh6lePVazE90jqwSKcYA=;
        b=l0VKxoFAeKoWrmvvzULp2qMUhr2V4P96S0uMkzOKyHpUVMTF8cf1i9QGpYX41FMnNG
         Lzb6aUY5/I04gf+Djo112pst78S51Zg9hPJFGwBB7EIrBEZA+cWzuOkDXTiS31n8R6+H
         5zXdy9exv1ArlAysnxxcM3LwArRRK14hlVLr8yqNVDp8yaeun1VTdKSR4BsSzGlS5luj
         j0OL4fKzKbnqqNVkmqlWqHLAoczEui/eT5GTyRTuSZ9mLpma6eINGiiiYGI7d7P+3RzE
         qLBfnJXztmqXyqR22oBz2vYSJsGT7uTy43rBlJyovcmCCNMb1kWyoSbUgXQUSNcLQibk
         DwMg==
X-Gm-Message-State: ANhLgQ2PSdNO/HQWiidujjsONu7V5C+8GreaEuYi66XqUp/EE5xg6r/2
        hOMbOl9sQzTWjcOqLd7CXDQSKw==
X-Google-Smtp-Source: ADFU+vtdsdpv+R5roKvKQEI4qP6vtDXV5v4YrrEtIFdYZXxXuy87RejYVKanoLIHYrn8O8hpj3y0XQ==
X-Received: by 2002:a1c:1d8e:: with SMTP id d136mr4669326wmd.26.1585301863539;
        Fri, 27 Mar 2020 02:37:43 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v7sm5385107wrs.96.2020.03.27.02.37.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:37:42 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 5/6] bnxt_en: Add partno to devlink info_get cb
Date:   Fri, 27 Mar 2020 15:05:50 +0530
Message-Id: <1585301751-26044-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585301751-26044-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301751-26044-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add part number info from the vital product data to info_get command
via devlink tool. Update bnxt.rst documentation as well.

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Remove serial number information.
---
v3->v4: Remove example display.
---
 Documentation/networking/devlink/bnxt.rst         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 7ab34c9..9818118 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -51,6 +51,9 @@ The ``bnxt_en`` driver reports the following versions
    * - Name
      - Type
      - Description
+   * - ``board.id``
+     - fixed
+     - Part number identifying the board design
    * - ``asic.id``
      - fixed
      - ASIC design identifier
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 39c2ac4..0c8283b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -403,6 +403,14 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	if (strlen(bp->board_partno)) {
+		rc = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			bp->board_partno);
+		if (rc)
+			return rc;
+	}
+
 	sprintf(buf, "%X", bp->chip_num);
 	rc = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
-- 
1.8.3.1

