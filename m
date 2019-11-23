Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB51C107DC2
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfKWI0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:53 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:43136 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKWI0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:52 -0500
Received: by mail-pj1-f68.google.com with SMTP id a10so4205187pju.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kVwJ8Erld/x5paBdF1eVtbl2KjLpFlw6CO4wo/CzaPs=;
        b=ZWhxdP1nKRshNydO2WSjHn+fe+YFjjObQ5O0bn8tDcV7+sxwUguMIpAKIXZXFYAUuk
         vyF2nmYY1bt6YvYN4g2OO1bnxjhGvsuO3qu1XiBsxa+lUm79XWfIDV4CMlSVXzHfvn7R
         TIO+SqoiI4TIDTa28Wypdr8YtFLSq6Fp4InSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kVwJ8Erld/x5paBdF1eVtbl2KjLpFlw6CO4wo/CzaPs=;
        b=rGaFvPuOJV+CJWXhsojw4W1oMiKrZeM+EjHMytNLS/Y4rXeWwDWylEnM0K9gWFEiUy
         uokcpIaTrOeYscC5ZklvBa3a0VGeguyHBbJfB4Qoq92fsMe+xFbQ/qe0VcPwmBnEeGJM
         jbsxEV7TP3WTzwAlAdHoDzuES+vJXLYbSYnH4nZvSSYB16pxd/0/HPznjotmEc2ZyOYv
         35WouI7KrmP3qw71tXf0uKVCQVWnmgtpHXNl5be4TVoxyupxpOISaOl41i93Lx+anbMg
         OQjsgD/bAl7rMJ+uTLzr7xILAyiB4VgJQmeJVEykaxE/IQPuvB0pE0aWiA4wPY5BytD0
         R+3g==
X-Gm-Message-State: APjAAAVGM02NHUhubFZ5+rcoH/N59TNRPlHGCkJBzNNG+Co9PHBg+//V
        z2UmgxVZ2fed9Q2DsWz6EPXOlQ==
X-Google-Smtp-Source: APXvYqwjITeEIpEuiGZdBVSYRbNpYGa30lBds5lEdaZX9QypJfzvRMEJKOwChom7/FU/ePKJmfAd5g==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr18636503ply.279.1574497611099;
        Sat, 23 Nov 2019 00:26:51 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:50 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 13/15] bnxt_en: Add support for flashing the device via devlink
Date:   Sat, 23 Nov 2019 03:26:08 -0500
Message-Id: <1574497570-22102-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Use the same bnxt_flash_package_from_file() function to support
devlink flash operation.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 20 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 7078271..acb2dd6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -14,6 +14,25 @@
 #include "bnxt.h"
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
+#include "bnxt_ethtool.h"
+
+static int
+bnxt_dl_flash_update(struct devlink *dl, const char *filename,
+		     const char *region, struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+
+	if (region)
+		return -EOPNOTSUPP;
+
+	if (!BNXT_PF(bp)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "flash update not supported from a VF");
+		return -EPERM;
+	}
+
+	return bnxt_flash_package_from_file(bp->dev, filename, 0);
+}
 
 static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 				     struct devlink_fmsg *fmsg,
@@ -225,6 +244,7 @@ static const struct devlink_ops bnxt_dl_ops = {
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
 	.eswitch_mode_get = bnxt_dl_eswitch_mode_get,
 #endif /* CONFIG_BNXT_SRIOV */
+	.flash_update	  = bnxt_dl_flash_update,
 };
 
 enum bnxt_dl_param_id {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index e455aaa..2ccf79c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2000,8 +2000,8 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 	return rc;
 }
 
-static int bnxt_flash_package_from_file(struct net_device *dev,
-					char *filename, u32 install_type)
+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
+				 u32 install_type)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 01de7e7..4428d0a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -81,6 +81,8 @@ extern const struct ethtool_ops bnxt_ethtool_ops;
 u32 _bnxt_fw_to_ethtool_adv_spds(u16, u8);
 u32 bnxt_fw_to_ethtool_speed(u16);
 u16 bnxt_get_fw_auto_link_speeds(u32);
+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
+				 u32 install_type);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
 
-- 
2.5.1

