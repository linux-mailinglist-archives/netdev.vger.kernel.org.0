Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50BE20228F
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgFTISJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 04:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTISJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 04:18:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA74C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so2323398wme.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=io4V8SC8rI7cJsoOKYF4DR8CjD1CDcayM7HhrY3rLSk=;
        b=Zi/p310eBGmGxde2E1Ymu7jvXjXAWTl9A1YwLmewX+Y7BBjhHlq6tRaQTSVXQ2dzfE
         d/pT1ZCCCXgY0QNXp4Bla5g3CukKSQ0hVarc9SSuL72rG0SrRqLwBgfr+MBhreM3huT3
         7Fnsb+N6P0MEnS9edtr8YMwkcvcojWUmDMqNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=io4V8SC8rI7cJsoOKYF4DR8CjD1CDcayM7HhrY3rLSk=;
        b=DvBTpPK0vw/hH87t2m15UC37oZmchwbvFtebe4+ZPvo6vCaXvHQRUJUXQ9ccn7jNxU
         4H5tWIL8zfO6OJ1r3mExl59EljAfHcMs9uxo0R7LbIj0YTQUplknI/ttsOczKfOagsyo
         3ZJUd0oD548hOfaIMg8+vopJykBGBJHpG/NRhQE8qPZ6Za7HvglthmmxjeiaxBHRojaw
         8RclTe5jOyS4jshEmZzCb+g/EAR3E57ohRiYIY/X+/Blv3yen21Fz3MGXA4leKjz13bx
         Q6uN6wEkOvTor33TTss+85ErIufYGXskc9IIuYlNNq+gHxMzb1ecktnkHyavgOjFQvhJ
         4MBA==
X-Gm-Message-State: AOAM533T3wvWqc6yR9WuEUeSQLVdcVNPCMd/E7PXWHSUD010ML0hma1F
        zkxbZlCBSuEtZnTwrCOd8OTm10j+E18=
X-Google-Smtp-Source: ABdhPJxdigguHS75aPVgzp+hpOrlh9BjP8fLqZib3c/BYTtuDE3O7nv2g7M3o0DiYEJaDoaxgOXPAg==
X-Received: by 2002:a1c:3286:: with SMTP id y128mr7237046wmy.29.1592641086778;
        Sat, 20 Jun 2020 01:18:06 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b201sm9354152wmb.36.2020.06.20.01.18.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 01:18:06 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jacob.e.keller@intel.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 1/2] devlink: Add support for board_serial_number to info_get cb.
Date:   Sat, 20 Jun 2020 13:45:46 +0530
Message-Id: <1592640947-10421-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Board serial number is a serial number, often available in PCI
*Vital Product Data*.

Also, update devlink-info.rst documentation file.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 12 +++++-------
 include/net/devlink.h                             |  2 ++
 include/uapi/linux/devlink.h                      |  2 ++
 net/core/devlink.c                                |  8 ++++++++
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 3fe1140..d80c846 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -44,9 +44,11 @@ versions is generally discouraged - here, and via any other Linux API.
        reported for two ports of the same device or on two hosts of
        a multi-host device should be identical.
 
-       .. note:: ``devlink-info`` API should be extended with a new field
-	  if devices want to report board/product serial number (often
-	  reported in PCI *Vital Product Data* capability).
+   * - ``board_serial_number``
+     - Board serial number of the device.
+
+       This is usually the serial number of the board, often available in
+       PCI *Vital Product Data*.
 
    * - ``fixed``
      - Group for hardware identifiers, and versions of components
@@ -201,10 +203,6 @@ Future work
 
 The following extensions could be useful:
 
- - product serial number - NIC boards often get labeled with a board serial
-   number rather than ASIC serial number; it'd be useful to add board serial
-   numbers to the API if they can be retrieved from the device;
-
  - on-disk firmware file names - drivers list the file names of firmware they
    may need to load onto devices via the ``MODULE_FIRMWARE()`` macro. These,
    however, are per module, rather than per device. It'd be useful to list
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1df6dfe..a8ceb7b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1262,6 +1262,8 @@ int devlink_info_serial_number_put(struct devlink_info_req *req,
 				   const char *sn);
 int devlink_info_driver_name_put(struct devlink_info_req *req,
 				 const char *name);
+int devlink_info_board_serial_number_put(struct devlink_info_req *req,
+					 const char *bsn);
 int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_name,
 				   const char *version_value);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 08563e6..06eb29c 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -451,6 +451,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
+	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2cafbc8..a97c169 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4378,6 +4378,14 @@ int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
 }
 EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
 
+int devlink_info_board_serial_number_put(struct devlink_info_req *req,
+					 const char *bsn)
+{
+	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
+			      bsn);
+}
+EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
+
 static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 				    const char *version_name,
 				    const char *version_value)
-- 
1.8.3.1

