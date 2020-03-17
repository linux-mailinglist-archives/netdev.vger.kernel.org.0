Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A06188901
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCQPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:19:33 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:43591 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCQPTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:19:33 -0400
Received: by mail-wr1-f50.google.com with SMTP id b2so19961655wrj.10
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F2EoniD9q59QcGSZkFJ21djfcf8TAZLpIday6fp5nnI=;
        b=GmnSBLBv8vdx+ldc+QPZPVShuoIETvB23CnhxfIAHELVk/qM9OnlPZo8+vA9SZUNPw
         rcVeNXxFCiGKBP2dUGRGnLywhsTwwKIxeR/BY+xs0TeZN9OELWgduGpUPitzQvMg6UB7
         lwjt6AGX1pRRM4LlDjthgNyZuXwYDG0iXNF3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F2EoniD9q59QcGSZkFJ21djfcf8TAZLpIday6fp5nnI=;
        b=CztLiMB4w3SlP5wDTnnqCaq+VIL4DAiq5WtJtkFDYVD+PjzD1F+aqncL+TSitBJ48p
         lEZmeIXAUcwk0W74nzFHT1EPy5/xYGAeXjRE6rqc487MnxarOJX87s6diS5MNaeQIUiD
         IEYCGBzKP0gyc0mzVjiecoMiHVrcEaZSoBrvj1zfpb/90lFPKmnY5SFLs9tNLTVlcfms
         J8OdVVEmnE/Ylnm/USk9AGKT7rhpGFh0DH0vI7zRy0rwYQzB3oGA2AYAobDvaURMUGkP
         NS9e+20vPD6zMcVTpUazrbfJS7JgkDRjLi3QZWtcx3v6RiTLLtDlISyLGmVVOv0oryHp
         Jrag==
X-Gm-Message-State: ANhLgQ2j/zGpzjT6VRJXNCMGzwH9VC7rh/kjqRPZnlY9PqlhlZbwwKtx
        K3oyjoAR4/hfYgvRbz/3CmhHRg==
X-Google-Smtp-Source: ADFU+vv2sSevjYR09qBcSfX7hL+tfwmidf4pyOyNfMAxVk++sPW1OwqxvgVaU9xZzIECDak4ooT4xA==
X-Received: by 2002:a5d:4004:: with SMTP id n4mr6381409wrp.48.1584458371280;
        Tue, 17 Mar 2020 08:19:31 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z19sm4363534wma.41.2020.03.17.08.19.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:19:30 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 09/11] devlink: Add new enable_ecn generic device param
Date:   Tue, 17 Mar 2020 20:47:24 +0530
Message-Id: <1584458246-29370-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Add new device parameter to enable/disable handling of Explicit
Congestion Notification(ECN) in the device.

This patch also addresses comments from Jiri Pirko, to update the
devlink-info.rst documentation.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-params.rst | 5 +++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index da2f85c..0e6c965 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -106,3 +106,8 @@ own name.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
+   * - ``enable_ecn``
+     - Boolean
+     - Enable handling of Explicit Congestion Notification(ECN) in the device.
+       When enabled hardware may set the code point to Congestion
+       Encountered(CE) before dropping the packet.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index e130d24..825a8f9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -404,6 +404,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -441,6 +442,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_NAME "enable_ecn"
+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f51bebc..116d887 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3012,6 +3012,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_ECN_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_ECN_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

