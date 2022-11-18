Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69816302B6
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKRXOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiKRXNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:18 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1F0C689F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p21so5809767plr.7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mYArZryzXG67A04meeckOSQ9eOWR6m+7bzxEQve3AkE=;
        b=r0gJXYtkkH5bz4HeUAR2FRim59BVBjX2t72s7dgkHM8oBglw3C3fl54wYPMLnvyoIo
         Ge+WMQuJPKO5GbLqOH9rmffBJxyXLmR/aw4Zc6qRM9jUr9y0psCnnFT35xDV6b74j2NT
         qhegCMk641KdZV5L4PIXkSkcsuHgm3WG7dum55Zia80JMcl/bUKBP8uWf898lwAY3WBa
         9AvqR6fkU8Vt7A4j0qoMLIoPG18wjrRrQnz5IvPLtcZuCsGG/1lbvQrbuYvLgUSxtuEp
         hrtQbAaNXknf7MIV4JAoRr9XdcqAaoMIYbxPAQSPneuFaPZtlQByPQUjn2BWoAC9X35q
         6qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYArZryzXG67A04meeckOSQ9eOWR6m+7bzxEQve3AkE=;
        b=xlFbl3b/zJEMXrgYUoUVnoojsUgZ+xOG4MVk2D9aaaBWr1IqBKNicb8qaTvOMosGW/
         TPJZMhcgfQWttTuc3BC0kcuVaj+fL+irmNrRbmrEj0SqcUsQvECTKt6lsAoBDVOT1lsV
         YuI/HqlTAbaAkyGav+GlbdcW6XGNY8FzTfK1XMzyUF2KODpH+jJIsdqRQ2Nhtn6Pl8hR
         pZ9TD6PhOJa/oLXHlpTpNZcttiwpr0/tdYcu4Rh7/ZEjCr1TaXPb1INsEF37o5kpjK1E
         bnvCdqGVwAad6elPywwWTxPyih8uLg8vrl7u9cZVp6Cpde3mVHQ/cweCOSmz3ByRiW+U
         9l0A==
X-Gm-Message-State: ANoB5pmaME0Fk3biJKuQVf9x+m/erxzByyPqO3pvFqnsAhqPm6wCWc9n
        s2CDUkAAGZ3JQ4skg21aQ4+9hCDyZS5Srg==
X-Google-Smtp-Source: AA0mqf7PZ8N+SPwc6ta8M90xhjh54jWW8IGJ8CBeU7JEoBuowEYFwf8eQjBJuT6yewrei2ZLn6DMtg==
X-Received: by 2002:a17:903:2342:b0:185:3d08:968b with SMTP id c2-20020a170903234200b001853d08968bmr1622277plh.49.1668812245833;
        Fri, 18 Nov 2022 14:57:25 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:25 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling VIF support
Date:   Fri, 18 Nov 2022 14:56:47 -0800
Message-Id: <20221118225656.48309-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the code to start and stop the VFs and
set up the auxiliary_bus devices, let's add the devlink
parameter switches so the user can enable the features.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/devlink.c  | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/devlink.c b/drivers/net/ethernet/pensando/pds_core/devlink.c
index 0568e8b7391c..2d09643b9add 100644
--- a/drivers/net/ethernet/pensando/pds_core/devlink.c
+++ b/drivers/net/ethernet/pensando/pds_core/devlink.c
@@ -8,6 +8,75 @@
 
 #include "core.h"
 
+static struct pdsc_viftype *pdsc_dl_find_viftype_by_id(struct pdsc *pdsc,
+						       enum devlink_param_type dl_id)
+{
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (pdsc->viftype_status[vt].dl_id == dl_id)
+			return &pdsc->viftype_status[vt];
+	}
+
+	return NULL;
+}
+
+static int pdsc_dl_enable_get(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry)
+		return -ENOENT;
+
+	ctx->val.vbool = vt_entry->enabled;
+
+	return 0;
+}
+
+static int pdsc_dl_enable_set(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+	int err = 0;
+	int vf;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (vt_entry->enabled == ctx->val.vbool)
+		return 0;
+
+	vt_entry->enabled = ctx->val.vbool;
+	for (vf = 0; vf < pdsc->num_vfs; vf++) {
+		err = ctx->val.vbool ? pdsc_auxbus_dev_add_vf(pdsc, vf) :
+				       pdsc_auxbus_dev_del_vf(pdsc, vf);
+	}
+
+	return err;
+}
+
+static int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
+				   union devlink_param_value val,
+				   struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (!pdsc->viftype_status[vt_entry->vif_id].supported)
+		return -ENODEV;
+
+	return 0;
+}
+
 static char *slot_labels[] = { "fw.gold", "fw.mainfwa", "fw.mainfwb" };
 
 static int pdsc_dl_fw_boot_get(struct devlink *dl, u32 id,
@@ -84,6 +153,18 @@ static int pdsc_dl_fw_boot_validate(struct devlink *dl, u32 id,
 }
 
 static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
+	DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_LM,
+			     "enable_lm",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     pdsc_dl_enable_get,
+			     pdsc_dl_enable_set,
+			     pdsc_dl_enable_validate),
 	DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_FW_BOOT,
 			     "boot_fw",
 			     DEVLINK_PARAM_TYPE_STRING,
@@ -93,6 +174,23 @@ static const struct devlink_param pdsc_dl_params[] = {
 			     pdsc_dl_fw_boot_validate),
 };
 
+static void pdsc_dl_set_params_init_values(struct devlink *dl)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union devlink_param_value value;
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (!pdsc->viftype_status[vt].dl_id)
+			continue;
+
+		value.vbool = pdsc->viftype_status[vt].enabled;
+		devlink_param_driverinit_value_set(dl,
+						   pdsc->viftype_status[vt].dl_id,
+						   value);
+	}
+}
+
 static int pdsc_dl_flash_update(struct devlink *dl,
 				struct devlink_flash_update_params *params,
 				struct netlink_ext_ack *extack)
@@ -195,6 +293,7 @@ int pdsc_dl_register(struct pdsc *pdsc)
 				      ARRAY_SIZE(pdsc_dl_params));
 	if (err)
 		return err;
+	pdsc_dl_set_params_init_values(dl);
 
 	devlink_register(dl);
 
-- 
2.17.1

