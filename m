Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8371888DB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgCQPQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41803 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgCQPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id f11so9399891wrp.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WLiEmDVVw7z5M6PsK8r0Pu95NiIoskT/ZwOEHjMC7jw=;
        b=CRnOYRMcw2h8oJmvuaHIReuidU+lKHXznx+19NZXWttJVKqMGUwFfwC0v/rBPedjpj
         G6tt0qbqn7Jqnp5mdGwqiGo57PXzR0vhmchgQL37qMkCH420tMmXqAbh+vb031pHC16t
         u1fkrA7S2esLM1VN8fig5bVKM4GM8ZegzGhNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WLiEmDVVw7z5M6PsK8r0Pu95NiIoskT/ZwOEHjMC7jw=;
        b=dSaN64Vcjj4Bd53XtEyTQomhnedoHS2lrkxyEV8/05U/OLyT1lJPlXfQxpfO0DljSe
         91t88c3314zUUo7XxRNdSURdG9Z8EBmW21Z+KwHN2nxxI3mcAVUHwklLuELctRlU6rJO
         SLu4BYafA4TViKFaxM1/Cm4pkwsiI7WLkk+iopjZGIz9WAQHVfax4WJVOulqom9l4j63
         +pXNNoiJ2OdClLV9aPgnjHJ1C5KIADHIufP9F512fz8bu7ldmpsLdsAqRj34mP+8MI5A
         jg+qladBx7h1fL2Ha0xqU1vUM/vlyVzL75mrrtcvrUVUCD+S1PcSUHCMe/g6SXoDCfKj
         PzGQ==
X-Gm-Message-State: ANhLgQ230ptJ+F4rxbzx/t0F1cZtyrc5O6NZYITvRAQmD2ThRrN2Z6pL
        r7mkBI0DBPF9a/9EuKo1R01Y0pNfLRU=
X-Google-Smtp-Source: ADFU+vs7x8G4RC9jhycBPk6CVj5L/5/NWX3Wi3UhHb8Ut2gquDInN6ZflFPsOLhf4r1zTqIoLbsWYA==
X-Received: by 2002:adf:a30b:: with SMTP id c11mr6528179wrb.257.1584458208361;
        Tue, 17 Mar 2020 08:16:48 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:47 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 02/11] bnxt_en: Add driver HWRM spec version to devlink info_get cb
Date:   Tue, 17 Mar 2020 20:44:39 +0530
Message-Id: <1584458082-29207-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also update bnxt.rst documentation file.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 82ef9ec..2709161 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -57,6 +57,9 @@ The ``bnxt_en`` driver reports the following versions
    * - ``asic.rev``
      - fixed
      - ASIC design revision
+   * - ``drv.spec``
+     - running
+     - HWRM specification version supported by driver HWRM implementation
    * - ``fw.psid``
      - stored, running
      - Firmware parameter set version of the board
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index d3c93cc..4a623ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -425,6 +425,11 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	rc = devlink_info_version_running_put(req,
+		DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC, HWRM_VERSION_STR);
+	if (rc)
+		return rc;
+
 	if (strlen(ver_resp->active_pkg_name)) {
 		rc =
 		    devlink_info_version_running_put(req,
-- 
1.8.3.1

