Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33E3538BEC
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244482AbiEaHYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244484AbiEaHYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:24:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D17992D19
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:24:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso662294wmn.4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ni37zg8wJMIqWdLXTPMPqfiSmjWqSOnRg5snf0H+sfM=;
        b=zt23VpMiGtj7SZlT++FCGDCRIZhrZkVdCAK3lfMWJK46Wg5zOlJyGB+L0if0bGUcOz
         fnxs0aQJuiAYuUvDFee44XO99SwgU0XeOEcvv6oz4n3mV23uKPXQ9F5t6IgNIRxJu9TO
         /Ys3XBPXSqXaNmNDuqtIMzLs3AqKVwaHB1udvW5fBrHCada6Y01mi7E25bPmpPoOERiy
         D7/JbmqqgxKPTl56UficN0SVXrvdp7m3X+tgMfEzjvohdz2u7TFG+C0mru9gRe4zCVYS
         d4VV7AWt6zXlTskoDeX3ot1266+WEglWcuGVukCC3m11uakNEggRuXna7ZVv/OUw5i1j
         ppqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ni37zg8wJMIqWdLXTPMPqfiSmjWqSOnRg5snf0H+sfM=;
        b=RzCV+PaL29hJ8GQgfYJQ05KiB/QJNQz9wZmNDBzS3la00dCMMl6OA50OEYfe15ErgI
         BOk8yB0S6CJQ9xUKmRqv70gbjg14b7hleU8t5nxZeSQiiQLPrHzYUgt8AE2mdNbFUe4E
         D+KV1MWbUMz1xKXnBgkHZdQae0yOtUT2mWR2IJTKICLQZGrKZZOW6leKNORddDsa+vnx
         XqaPdQQJT0ZrErj5LAjrOUpSLAl+7PX1pOtLCxgA4WBW5bXIZGyB9dTTjK57HoDgMaJi
         TwJi+QyS5giBO19NYh3wLgndzlR7HPHNhL5bpjpN6cvbV2Fe0ai802fmbuP1GlaidXD6
         IZqg==
X-Gm-Message-State: AOAM530Tq4xIIKWo69bIHfNHokn950SvxUSmEEidIoDj9rbYLQVuSC/e
        Ae/GXUlt7Rm5c++TzKsugFlsKFWFT65pYa4a
X-Google-Smtp-Source: ABdhPJzqMb+f1u6+5s9Q1/ExdOASLOc9mOlZqvF1jNwxIGnZutVQJdAln6Hh4yp6e5oG6XeM95VsrQ==
X-Received: by 2002:a7b:cc0d:0:b0:381:220e:a3a0 with SMTP id f13-20020a7bcc0d000000b00381220ea3a0mr22143232wmh.59.1653981883218;
        Tue, 31 May 2022 00:24:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f15-20020a5d58ef000000b0020d117a4e00sm10611597wrd.105.2022.05.31.00.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 00:24:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com
Subject: [patch net-next RFC] net: devlink: extend info_get() version put to indicate a flash component
Date:   Tue, 31 May 2022 09:24:41 +0200
Message-Id: <20220531072441.3943232-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.1
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
match one of the versions returned by info_get(), marked by new flag.

Whenever the driver is called by his info_get() op, it may put multiple
version names and values to the netlink message. Extend by additional
helper devlink_info_version_running_put_ext() that allows to specify a
flag that indicates a particular version name represents a flash
component.

Use this indication during cmd_flash_update() execution by calling
info_get() with different "req" context. That causes info_get() to
lookup the component name instead of filling-up the netlink message.

Fix the only component user which is netdevsim. It uses component named
"fw.mgmt" in selftests.

Remove now outdated "UPDATE_COMPONENT" flag.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 11 +++++--
 include/net/devlink.h       |  7 +++--
 net/core/devlink.c          | 62 ++++++++++++++++++++++++++++++-------
 3 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 57a3ac893792..bd553e52ad44 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -995,7 +995,13 @@ static int nsim_dev_info_get(struct devlink *devlink,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, DRV_NAME);
+	int err;
+
+	err = devlink_info_driver_name_put(req, DRV_NAME);
+	if (err)
+		return err;
+
+	return devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30", true);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
@@ -1323,8 +1329,7 @@ nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
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
index 2a2a2a0c93f7..a0a88d92d94e 100644
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
@@ -1677,6 +1676,10 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_name,
 				     const char *version_value);
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 bool is_flash_component);
 
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg);
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5cc88490f18f..8d950a338a24 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4736,6 +4736,12 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+	const char *lookup_name;
+	bool lookup_name_found;
+};
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
@@ -4756,12 +4762,24 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	if (nla_component) {
-		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
+		const char *component = nla_data(nla_component);
+		struct devlink_info_req req = {};
+
+		if (!devlink->ops->info_get) {
 			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
 					    "component update is not supported by this device");
 			return -EOPNOTSUPP;
 		}
-		params.component = nla_data(nla_component);
+		req.lookup_name = component;
+		ret = devlink->ops->info_get(devlink, &req, NULL);
+		if (ret)
+			return ret;
+		if (!req.lookup_name_found) {
+			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
+					    "selected component is not supported by this device");
+			return -EINVAL;
+		}
+		params.component = component;
 	}
 
 	nla_overwrite_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
@@ -6361,18 +6379,18 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
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
@@ -6380,6 +6398,8 @@ EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
 			      bsn);
 }
@@ -6387,11 +6407,18 @@ EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
 
 static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 				    const char *version_name,
-				    const char *version_value)
+				    const char *version_value,
+				    bool is_flash_component)
 {
 	struct nlattr *nest;
 	int err;
 
+	if (req->lookup_name && !req->lookup_name_found && is_flash_component)
+		req->lookup_name_found = !strcmp(req->lookup_name, version_name);
+
+	if (!req->msg)
+		return 0;
+
 	nest = nla_nest_start_noflag(req->msg, attr);
 	if (!nest)
 		return -EMSGSIZE;
@@ -6420,7 +6447,7 @@ int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_FIXED,
-					version_name, version_value);
+					version_name, version_value, false);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
 
@@ -6429,7 +6456,7 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 				    const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value);
+					version_name, version_value, false);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
 
@@ -6438,16 +6465,27 @@ int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
-					version_name, version_value);
+					version_name, version_value, false);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
 
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 bool is_flash_component)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
+					version_name, version_value,
+					is_flash_component);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
-	struct devlink_info_req req;
+	struct devlink_info_req req = {};
 	void *hdr;
 	int err;
 
@@ -11992,8 +12030,8 @@ EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
+	struct devlink_info_req req = {};
 	const struct nlattr *nlattr;
-	struct devlink_info_req req;
 	struct sk_buff *msg;
 	int rem, err;
 
-- 
2.35.1

