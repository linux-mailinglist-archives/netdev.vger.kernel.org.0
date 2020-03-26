Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9D19389F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgCZGa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:30:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50606 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZGa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:30:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id d198so5277230wmd.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vCywXrPM+RXAEKueJsXEcStE/qK7ypaCxILLHInXhdU=;
        b=QUz3aUqz1Rv8+NdlBs9WDYP0acjj85eQr33P0bHZF14w0L/OXQqD4J8hnK1uHOLkiB
         LVFsLgipEmJC5TfRBgIX9y0IA9vncYGdT+AXn2p2qjoFkGtpCNv9tkILnDCmjIhzNijT
         rnhO+AKCTr4+fAHqtInDJ5mTXf3L6NYPbDJuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vCywXrPM+RXAEKueJsXEcStE/qK7ypaCxILLHInXhdU=;
        b=rNlkoEQAlGZcrkqiVkawtT2nJsqdi3vWO3JSKr7vUOv/pRaOfZ/whoKCMCyw5kVsU7
         IKmfaDbiocfqUKemKfi+pMbPeKGLhv2zsZ2+xbLLzgJmomhufyemhGc15i9bMlxArdgK
         ruLf7DV4Dohbmc14yOapGJWwaokEU8KAuwoqPk+xU/u3dZaFRuhfKMFsGxDwKZK8k4cq
         l2rGnFwNcJzFoDgGVWaLLQaubM3aC4gZw9c81Ru5paPA0l1HEgBzvvEF7j6MKbhE2JV1
         Uj8TGPBzakEVZmlU5UohU0D/Hai9EMBSV47URPnNFck4mAsWVINyiAiFrLQlWDgA2gGK
         5zoQ==
X-Gm-Message-State: ANhLgQ1cBbHLV3i8aRqBbAD4MtKZXLEtklABdVInlkCOOy/uXdPxHXA8
        YZ5AfvkhgkVKgB3TTEhst+okRg==
X-Google-Smtp-Source: ADFU+vuETKn9nsol7DcUSPTtagosAIWGAA8HDjSfIpHJEldZvnNEa36ExuvBxz+dm4ehlO2tJ+BJnA==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr1380001wmk.125.1585204254056;
        Wed, 25 Mar 2020 23:30:54 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o9sm2155583wrw.20.2020.03.25.23.30.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:30:53 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 7/7] bnxt_en: Add partno to devlink info_get cb
Date:   Thu, 26 Mar 2020 11:59:03 +0530
Message-Id: <1585204143-10417-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585204143-10417-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585204143-10417-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add part number info from the vital product data to info_get command
via devlink tool. Update bnxt.rst documentation as well.

Example display:

$ devlink dev info pci/0000:3b:00.1
pci/0000:3b:00.1:
  driver bnxt_en
  serial_number B0-26-28-FF-FE-C8-85-20
  versions:
      fixed:
        board.id BCM957508-P2100G
        asic.id 1750
        asic.rev 1
      running:
        hw.addr b0:26:28:c8:85:21
        fw 216.0.286.0
        fw.api 1.10.1
        fw.psid 0.0.6
        fw.app 216.0.251.0

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Remove serial number information.
---
 Documentation/networking/devlink/bnxt.rst         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index a514664..1f28e2f 100644
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
index 493a9eb..e1061c4 100644
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

