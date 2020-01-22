Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69D71452C8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgAVKld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:41:33 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45555 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729095AbgAVKld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:41:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so2778817pls.12
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 02:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dAVnQSTBZvk8T7JsVRXarrGTByGGE+qwObO5zK8rmZA=;
        b=JEt6Xd+kquRlo7HoIL8TDOFAAlvHDse7O8SK3b5KrfxDowM0XREQSZNmuI5k2rV2Wg
         GmuT3CPney/IzBpBmRKU8CAnIWWwGmlJvmr6AOnPmlRkwAfqh/0nEWEp/dwLImnLIOkZ
         Xv20E++DpCC4LXumx1rockm75EssOo5FU6D/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dAVnQSTBZvk8T7JsVRXarrGTByGGE+qwObO5zK8rmZA=;
        b=Kjpf9Zfyf2GSIkK966cmApZmnSGnqX8rfmI6eU/B7n00BBy8kr03mLrzTFuEaM7WCh
         MqSzE1f7WMYUKkerVnPqKM68z7n/0pfBJViNyZpCVPTNlGWsdReydUaJ60/CTyiE4vnY
         JhDbf2r8kfNeuB9iob/dMgz2sZNmt8qKtnTgR6fQCPfQnWAExRaX7Qr6XUYBK1NFW+6A
         Hmmsq02mk3kEjf32TzSGMTW8sb3OIoiLh9XtwT197ivvl7tjRATfh9pJZd6MHtF6G6S2
         pQ9vBtufu21WvPT7+VjF3LB62kNGVUpoz5TpePS7fOuf83RM2Vz7Gh/7UPM98wgpJa1V
         s2zw==
X-Gm-Message-State: APjAAAXgLtkk7sj9MW0CROz9v6fcrrkf2OGtbmFUdAcTDFEOljL/ojHS
        4QDbSZTUZHjspnp1QLTcHHWt2Q==
X-Google-Smtp-Source: APXvYqwAl3mlpm9PPbNTY8Fc+EJwL5lr3C/5EaxRdnuEbGeuNWrbq5sx2ZsLFoIvNxXVxbzTJrfDQQ==
X-Received: by 2002:a17:902:9009:: with SMTP id a9mr10150394plp.124.1579689692088;
        Wed, 22 Jan 2020 02:41:32 -0800 (PST)
Received: from dhcp-10-123-153-81.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r14sm45014321pfh.10.2020.01.22.02.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 02:41:31 -0800 (PST)
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, vasundhara-v.volam@broadcom.com,
        netdev@vger.kernel.org, jiri@mellanox.com,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH] devlink: Add enable_ecn boolean generic parameter
Date:   Wed, 22 Jan 2020 16:10:46 +0530
Message-Id: <1579689646-13123-1-git-send-email-pavan.chebbi@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enable_ecn - Enables Explicit Congestion Notification
characteristic of the device.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---
 include/net/devlink.h | 4 ++++
 net/core/devlink.c    | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5e46c24..52315dd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -403,6 +403,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -440,6 +441,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_NAME "enable_ecn"
+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64367ee..298dcd1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
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

