Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09467682843
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjAaJKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjAaJJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:09:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DA274BC
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id dr8so17992591ejc.12
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuEI1RWae/38SVbnypszPZ92Z37tDJLAxJqgBbicgx4=;
        b=kHeiAxuC0FOBb53cgmDt3gALlsgRniWR0iLQyC2kSG6POGPluRtry/UY0LcGiBKaZK
         tWl+45d5gyJXtmujGouM3Kfst4KEoCPcmIgYidb+WGWPNERliyC2MkRGyrHi+ik35Zpb
         pt85k908BnvvzMSopgs+YHnANAwFpA4y9Jy3CLhVAYPU41TS5u8HAkhxliz7KZllF15y
         f+x5j1tDMVkMFohEYfUZkvo+WRf6HE4z1cJ6qbfz5UuBFlY4mizToOhHUAdDrXKyfMiM
         swjOCwZ2wTXkLAGwdeP/I207zkGL80M6XKdhrjCa4ZDcNxeMtlvUJYRq0zVyK398/Ii+
         JORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KuEI1RWae/38SVbnypszPZ92Z37tDJLAxJqgBbicgx4=;
        b=E6IVX/TiCQgafaHM4KsO2jrURL0DTiwiKtQWlCYJ7RtEexcfsrB/4XQQZylJa8h0xp
         DPFuocS21qYwjuDWK2TT7OBCH0U7vlGpDXhRbquiS3+fVSCh7jc2cLmujXgGli2p8w0f
         zL+baWtSAyzG9wLb8NIRWz/Xwd9WagYq/xv2J+mlgAiSO7d8Ji37amL62ea6cEKQS3z4
         xxtfh8EQU+lG8Ok3u5oIFgc40g3a8/QZIsLCALxy91c5a3klsg1dno6j1vtY9FuLqdpf
         9/+NyTggLw48jKgebb+I6uv/+FV51xuOyMkC0ypt9DyfH6vhe34ui+NWvjc66IdPnNYr
         xS7g==
X-Gm-Message-State: AO0yUKUkN56K0ydUgtnpfQ+TU8VJHUAKkuPN5nTttRR3CiOMS/+lBhhx
        pSzsypUPaOoaiZwatnCqtJscipciW5EF9Q8ymOM=
X-Google-Smtp-Source: AK7set8Aw8Nt0YQfB7pWraQmcPKeef0PRv2ujJzB0byo1QopFTBsxWFCO+X+Hi/2STp4ZEQhcGsNTw==
X-Received: by 2002:a17:907:6eab:b0:878:b890:38bb with SMTP id sh43-20020a1709076eab00b00878b89038bbmr3059386ejc.67.1675155977623;
        Tue, 31 Jan 2023 01:06:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d13-20020a170906344d00b0088385cd6166sm4925051ejb.195.2023.01.31.01.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:06:17 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: [patch net-next 1/3] devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
Date:   Tue, 31 Jan 2023 10:06:11 +0100
Message-Id: <20230131090613.2131740-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131090613.2131740-1-jiri@resnulli.us>
References: <20230131090613.2131740-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

To have the name of the function consistent with the struct cb name,
rename devlink_nl_instance_iter_dump() to
devlink_nl_instance_iter_dumpit().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h |  4 ++--
 net/devlink/leftover.c      | 32 ++++++++++++++++----------------
 net/devlink/netlink.c       |  4 ++--
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index ba161de4120e..dd4366c68b96 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -128,8 +128,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs);
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
 
-int devlink_nl_instance_iter_dump(struct sk_buff *msg,
-				  struct netlink_callback *cb);
+int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
+				    struct netlink_callback *cb);
 
 static inline struct devlink_nl_dump_state *
 devlink_dump_state(struct netlink_callback *cb)
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 92210587d349..1461eec423ff 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -8898,14 +8898,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -8919,7 +8919,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_RATE_GET,
 		.doit = devlink_nl_cmd_rate_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
 		/* can be retrieved by unprivileged users */
 	},
@@ -8967,7 +8967,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_LINECARD_GET,
 		.doit = devlink_nl_cmd_linecard_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 		/* can be retrieved by unprivileged users */
 	},
@@ -8981,14 +8981,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_POOL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9001,7 +9001,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_PORT_POOL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9016,7 +9016,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9097,7 +9097,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_PARAM_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9125,7 +9125,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_REGION_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
@@ -9151,14 +9151,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_INFO_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_info_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9213,7 +9213,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_GET,
 		.doit = devlink_nl_cmd_trap_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9224,7 +9224,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_GET,
 		.doit = devlink_nl_cmd_trap_group_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9235,7 +9235,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
 		.doit = devlink_nl_cmd_trap_policer_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9246,7 +9246,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_SELFTESTS_GET,
 		.doit = devlink_nl_cmd_selftests_get_doit,
-		.dumpit = devlink_nl_instance_iter_dump,
+		.dumpit = devlink_nl_instance_iter_dumpit,
 		/* can be retrieved by unprivileged users */
 	},
 	{
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 3f44633af01c..11666edf5cd2 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -196,8 +196,8 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
 };
 
-int devlink_nl_instance_iter_dump(struct sk_buff *msg,
-				  struct netlink_callback *cb)
+int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
+				    struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-- 
2.39.0

