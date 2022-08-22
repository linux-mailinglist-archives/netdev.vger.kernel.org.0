Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87459C48D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiHVRDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiHVRC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AE3F1F2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gi31so15993621ejc.5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6yGy5ggdrTF6whnWYjTmPZD20A772INL5AuSPGMVOJQ=;
        b=DVoTAkiZoH26qHyGdUL5kpXU9/ZKV7p+wf04j67vpQbg3GE53gTw9YDLz3rTvjp+qy
         JCgKqTWq/4lwL6zsf0dVNXa0Almo1IJ2ba0qzutVPRYb4JJEG65PAcjGFTeEUDCR8Bjn
         fDFo/ZuqhqjK5EpV68zxDQfLpyzrtpKGdjdTEUa3pmw0sZDsLNjdWYPbTHg0+n69HeqX
         kcr9pHxNXF9nOfFtAhUjoEiM94q0dINvYIUkUoWT198jUKLQUcVLjLAcKeOLr9Ij2tJ8
         vE8ghlnWjlbEKF7+hLIfQ3dgeWNhrvirsqYRghffSqwKZDV0ECqNtXo7y7L6fjkXtBuh
         3Vxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6yGy5ggdrTF6whnWYjTmPZD20A772INL5AuSPGMVOJQ=;
        b=I61mjWQZZUGARjaxm6w63lZQ3k0g2qus0HfN6o3PpjigAWcLTII7AYryZyeR/CbHOu
         +alYZlfbBIQyO5k2sj7n2PfhHwk1YvXPz4FCeTZG7n+HyMXgLHMdVc/oprpu9sYitEQq
         XPNnu7SiVGL26UX/bsfJxIFDYhLbWkGTHMDVaeSPwGkQRFaSZCmstUQrtm8iInI7156W
         6Pi53OZBdm/LwdiSjgZkCU+JKZfJrqUBSx+bMnGLptiXUf0EpQ3xpLpE2OjZrCB8UxmO
         10BJhw//NcS06S5m8JM+wW45Jn4VWVyGtDSnBga5wSokMQ0FKdA/8efjcS7YT4KC40NV
         EH+g==
X-Gm-Message-State: ACgBeo3K/XYbXhQZvChqu+Dw/Nu8BICF3Ree9GUYprwONiH6bCVXW8i/
        0lnV43pzgoO6B07JPgbbXRlrqyQeqTJyO2dP
X-Google-Smtp-Source: AA6agR7GrXu2/tMpYAPfEyCJ0tpuxj+AaoKzjRaskjYzH/kq6mehNrjp4slVTgf2KMqGqQB7LRY1SQ==
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr14143332ejc.762.1661187773627;
        Mon, 22 Aug 2022 10:02:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g21-20020a50d0d5000000b0043d6ece495asm4225edf.55.2022.08.22.10.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:02:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v2 3/4] net: devlink: limit flash component name to match version returned by info_get()
Date:   Mon, 22 Aug 2022 19:02:46 +0200
Message-Id: <20220822170247.974743-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822170247.974743-1-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Limit the acceptance of component name passed to cmd_flash_update() to
match one of the versions returned by info_get(), marked by version type.
This makes things clearer and enforces 1:1 mapping between exposed
version and accepted flash component.

Check VERSION_TYPE_COMPONENT version type during cmd_flash_update()
execution by calling info_get() with different "req" context.
That causes info_get() to lookup the component name instead of
filling-up the netlink message.

Remove "UPDATE_COMPONENT" flag which becomes used.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 drivers/net/netdevsim/dev.c |   3 +-
 include/net/devlink.h       |   3 +-
 net/core/devlink.c          | 105 ++++++++++++++++++++++++++++++------
 3 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 97fc17ffff93..cea130490dea 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1319,8 +1319,7 @@ nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
-					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5f47d5cefaa6..9bf4f03feca6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -624,8 +624,7 @@ struct devlink_flash_update_params {
 	u32 overwrite_mask;
 };
 
-#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
-#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
+#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(0)
 
 struct devlink_region;
 struct devlink_info_req;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2682e968539e..17b78123ad9d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4742,10 +4742,76 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+	void (*version_cb)(const char *version_name,
+			   enum devlink_info_version_type version_type,
+			   void *version_cb_priv);
+	void *version_cb_priv;
+};
+
+struct devlink_flash_component_lookup_ctx {
+	const char *lookup_name;
+	bool lookup_name_found;
+};
+
+static void
+devlink_flash_component_lookup_cb(const char *version_name,
+				  enum devlink_info_version_type version_type,
+				  void *version_cb_priv)
+{
+	struct devlink_flash_component_lookup_ctx *lookup_ctx = version_cb_priv;
+
+	if (version_type != DEVLINK_INFO_VERSION_TYPE_COMPONENT ||
+	    lookup_ctx->lookup_name_found)
+		return;
+
+	lookup_ctx->lookup_name_found =
+		!strcmp(lookup_ctx->lookup_name, version_name);
+}
+
+static int devlink_flash_component_get(struct devlink *devlink,
+				       struct nlattr *nla_component,
+				       const char **p_component,
+				       struct netlink_ext_ack *extack)
+{
+	struct devlink_flash_component_lookup_ctx lookup_ctx = {};
+	struct devlink_info_req req = {};
+	const char *component;
+	int ret;
+
+	if (!nla_component)
+		return 0;
+
+	component = nla_data(nla_component);
+
+	if (!devlink->ops->info_get) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "component update is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	lookup_ctx.lookup_name = component;
+	req.version_cb = devlink_flash_component_lookup_cb;
+	req.version_cb_priv = &lookup_ctx;
+
+	ret = devlink->ops->info_get(devlink, &req, NULL);
+	if (ret)
+		return ret;
+
+	if (!lookup_ctx.lookup_name_found) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "selected component is not supported by this device");
+		return -EINVAL;
+	}
+	*p_component = component;
+	return 0;
+}
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
+	struct nlattr *nla_overwrite_mask, *nla_file_name;
 	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
 	const char *file_name;
@@ -4758,17 +4824,13 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
 		return -EINVAL;
 
-	supported_params = devlink->ops->supported_flash_update_params;
+	ret = devlink_flash_component_get(devlink,
+					  info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT],
+					  &params.component, info->extack);
+	if (ret)
+		return ret;
 
-	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
-	if (nla_component) {
-		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
-			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
-					    "component update is not supported by this device");
-			return -EOPNOTSUPP;
-		}
-		params.component = nla_data(nla_component);
-	}
+	supported_params = devlink->ops->supported_flash_update_params;
 
 	nla_overwrite_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
 	if (nla_overwrite_mask) {
@@ -6553,18 +6615,18 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_info_req {
-	struct sk_buff *msg;
-};
-
 int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
 }
 EXPORT_SYMBOL_GPL(devlink_info_driver_name_put);
 
 int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_SERIAL_NUMBER, sn);
 }
 EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
@@ -6572,6 +6634,8 @@ EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
 			      bsn);
 }
@@ -6585,6 +6649,13 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	struct nlattr *nest;
 	int err;
 
+	if (req->version_cb)
+		req->version_cb(version_name, version_type,
+				req->version_cb_priv);
+
+	if (!req->msg)
+		return 0;
+
 	nest = nla_nest_start_noflag(req->msg, attr);
 	if (!nest)
 		return -EMSGSIZE;
@@ -6654,7 +6725,7 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
-	struct devlink_info_req req;
+	struct devlink_info_req req = {};
 	void *hdr;
 	int err;
 
@@ -12321,8 +12392,8 @@ EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
+	struct devlink_info_req req = {};
 	const struct nlattr *nlattr;
-	struct devlink_info_req req;
 	struct sk_buff *msg;
 	int rem, err;
 
-- 
2.37.1

