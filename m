Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02D11D72EF
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgERI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgERI3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:29:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DB8C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:29:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so10738568wrt.5
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U5liFecwyBrLmBSIzEkq/w2j7Xj0bza48kc+Bx/i2kw=;
        b=RHN0gPkabPGCjfcSF/35B+Y+X7rN7NY0uKz9iFzvXnBaThSaOdt0dF6U08T57PfsXY
         UT0DxngusWbkNJXfqagJUvfXNxSZuVM61S5I1b0gjR/UZS4GG8MRcMAFNHF892HKq1H+
         hn0Zps2CpjuX0H6+3dQwvoTQdTGbJPi1frXg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U5liFecwyBrLmBSIzEkq/w2j7Xj0bza48kc+Bx/i2kw=;
        b=Mv8vdMkyomXvR9JG5pN0otxy1+llo8YJrM/u2JoM8ijXk5Ln0OcaMXEPAD8jveTCLB
         ocluX27DGX+OW6hCXqinegdTUqB36y2+CzMEY73Knp8vbNJreqrNIDlWBv4Mf35/b/ow
         04mcc+pxgPARLaFzR/8wMEHv53gBSIZ5h5qOwXuPbmMhYemWMmgwFWuPgHHgzYJL+CRc
         c1BXzMsIlyVVjaDg4ROH6Eo+b9yHch3EMrX/upEaPtmDZlEVIk/p6r/JM498MNdTwtyF
         2VhFNfk71raorcYlTRyEZ8gzHKcm5/LbRDWey8ddvKqFp3mN5J5qmFPWtL7ldsJu6oBt
         WxrA==
X-Gm-Message-State: AOAM533u/JGzUvmyvwDSs3kWNmCRv4FK1kcLL8l7BnJhpbs6TGs9bry0
        sLKeXQ91Lp/LaPCXacsqivfemyJfkvc=
X-Google-Smtp-Source: ABdhPJzbLpKMBlz/IMX1xT/h8zF6acG4+m40mL8OSOsRKmfqWf1XadCk7T2WBOyfMNymes+Q4TFAiQ==
X-Received: by 2002:adf:dc86:: with SMTP id r6mr17830857wrj.45.1589790588954;
        Mon, 18 May 2020 01:29:48 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m7sm15350144wmc.40.2020.05.18.01.29.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 01:29:48 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 1/4] devlink: Add new "enable_hot_fw_reset" generic device parameter.
Date:   Mon, 18 May 2020 13:57:16 +0530
Message-Id: <1589790439-10487-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new "enable_hot_fw_reset" generic device parameter to enable
or disable hot firmware reset capability on the device.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index d075fd0..ba75437 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -108,3 +108,9 @@ own name.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
+   * - ``enable_hot_fw_reset``
+     - Boolean
+     - Enable hot firmware reset on the device. When enabled, device supports
+       hot firmware reset capability which will be able to reset the running
+       firmware or upgrade/downgrade of flashed firmware without a driver
+       reload.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ffc1b5c..57377bf 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_HOT_FW_RESET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_HOT_FW_RESET_NAME "enable_hot_fw_reset"
+#define DEVLINK_PARAM_GENERIC_ENABLE_HOT_FW_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b76e5f..32fb8e6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_HOT_FW_RESET,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_HOT_FW_RESET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_HOT_FW_RESET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

