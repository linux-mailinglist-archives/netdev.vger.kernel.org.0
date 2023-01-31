Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3461B682846
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjAaJKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjAaJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:09:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73644FCD3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:36 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id dr8so17993028ejc.12
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYJs8bLOFCkPkxmq+cxMEy/oQAGG1Sib6lPS6pwsww0=;
        b=VPEcYLSuThY/QZ+Tt583cvV93rPCADSBjrlaVuo6VkX/Hi5QPwNWJJwf7KitoHUk4A
         wyn5fakM8i+ZegDePooU6VFeMxyZrmv2q8jllsiwKBfnGRSYbM7UjSX107EvnJzXcDyR
         +xWLterNpTy1SpLEUBaefC9uuHTbP55gZd7SYCKBFbmCplbz0quY7bkISvr3++GDxD+V
         QHqNDv55sYzQ9PV0ChcCzMbAgK72q/HjIJ40YjwdhBiS81ZIqfGvqwi0OaWXtRAdxGk9
         i7k/G0u0n1KPlnRCzpvcsa9Vz4wP4YTIfh4l6KC7rZpRqeV4DIRIl6S2Jnmb0VL480bf
         ZKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYJs8bLOFCkPkxmq+cxMEy/oQAGG1Sib6lPS6pwsww0=;
        b=Ih5jVab2jtgpBhtXoj6UpistrM3qdC6brzYkcMA1Gf5KeVNK6jQcsg92eMnOidNwuC
         d3cDnnamJghEARR+9MKj48d2mumi2Iayp1teJvzaEPBG5Kfj3GNue0m2TA6F2/2HT5mk
         CPp4zzrZHXzTZoG8d2epY3qcWjzN+yp3OokQUHDgD+wji7zT/EzMVui1q4pTVL3Pk7/m
         NEZ8Uvqe99v+s/nuTZPhF9c7OVsmQh45OQ83CrrW/cVlELe49GC0kJE/+2AvZw4GXexu
         Ne2B7CPHuaWw0ccBHXS76PsBZwLVhD264r2/4NbABrAtGc+0o6Kw61WZSHu952TSpMHk
         Urhg==
X-Gm-Message-State: AO0yUKVXbpeC0FKaylEaz6j0hLiX1bhJIJNvKhi7PoSzET90PhrV4tPL
        CmIh9OeED2tbADh1Psf9Phe/pkt90regrJ9H/wc=
X-Google-Smtp-Source: AK7set8RDYfkxtNlOz44frRlhqhCBbblK3rA/03qCLDYBmF4Yh/1twkMhScdR1hPPWKlYRfVbMfetg==
X-Received: by 2002:a17:906:51ce:b0:879:9bf4:c2cd with SMTP id v14-20020a17090651ce00b008799bf4c2cdmr16744432ejk.68.1675155980912;
        Tue, 31 Jan 2023 01:06:20 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i4-20020a170906264400b0084d35ffbc20sm8120936ejc.68.2023.01.31.01.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:06:20 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: [patch net-next 3/3] devlink: rename and reorder instances of struct devlink_cmd
Date:   Tue, 31 Jan 2023 10:06:13 +0100
Message-Id: <20230131090613.2131740-4-jiri@resnulli.us>
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

In order to maintain naming consistency, rename and reorder all usages
of struct struct devlink_cmd in the following way:
1) Remove "gen" and replace it with "cmd" to match the struct name
2) Order devl_cmds[] and the header file to match the order
   of enum devlink_command
3) Move devl_cmd_rate_get among the peers
4) Remove "inst" for DEVLINK_CMD_GET
5) Add "_get" suffix to all to match DEVLINK_CMD_*_GET (only rate had it
   done correctly)

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 33 ++++++++++++++++-----------------
 net/devlink/leftover.c      | 32 ++++++++++++++++----------------
 net/devlink/netlink.c       | 36 ++++++++++++++++++------------------
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 3910db5547fe..bdd7ad25c7e8 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -140,21 +140,22 @@ devlink_dump_state(struct netlink_callback *cb)
 }
 
 /* Commands */
-extern const struct devlink_cmd devl_gen_inst;
-extern const struct devlink_cmd devl_gen_port;
-extern const struct devlink_cmd devl_gen_sb;
-extern const struct devlink_cmd devl_gen_sb_pool;
-extern const struct devlink_cmd devl_gen_sb_port_pool;
-extern const struct devlink_cmd devl_gen_sb_tc_pool_bind;
-extern const struct devlink_cmd devl_gen_selftests;
-extern const struct devlink_cmd devl_gen_param;
-extern const struct devlink_cmd devl_gen_region;
-extern const struct devlink_cmd devl_gen_info;
-extern const struct devlink_cmd devl_gen_health_reporter;
-extern const struct devlink_cmd devl_gen_trap;
-extern const struct devlink_cmd devl_gen_trap_group;
-extern const struct devlink_cmd devl_gen_trap_policer;
-extern const struct devlink_cmd devl_gen_linecard;
+extern const struct devlink_cmd devl_cmd_get;
+extern const struct devlink_cmd devl_cmd_port_get;
+extern const struct devlink_cmd devl_cmd_sb_get;
+extern const struct devlink_cmd devl_cmd_sb_pool_get;
+extern const struct devlink_cmd devl_cmd_sb_port_pool_get;
+extern const struct devlink_cmd devl_cmd_sb_tc_pool_bind_get;
+extern const struct devlink_cmd devl_cmd_param_get;
+extern const struct devlink_cmd devl_cmd_region_get;
+extern const struct devlink_cmd devl_cmd_info_get;
+extern const struct devlink_cmd devl_cmd_health_reporter_get;
+extern const struct devlink_cmd devl_cmd_trap_get;
+extern const struct devlink_cmd devl_cmd_trap_group_get;
+extern const struct devlink_cmd devl_cmd_trap_policer_get;
+extern const struct devlink_cmd devl_cmd_rate_get;
+extern const struct devlink_cmd devl_cmd_linecard_get;
+extern const struct devlink_cmd devl_cmd_selftests_get;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
@@ -182,8 +183,6 @@ struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
 
 /* Rates */
-extern const struct devlink_cmd devl_gen_rate_get;
-
 struct devlink_rate *
 devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
 struct devlink_rate *
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 16cb5975de1a..056d9ca14a3d 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1236,7 +1236,7 @@ devlink_nl_cmd_rate_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_rate_get = {
+const struct devlink_cmd devl_cmd_rate_get = {
 	.dump_one		= devlink_nl_cmd_rate_get_dump_one,
 };
 
@@ -1303,7 +1303,7 @@ devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
 }
 
-const struct devlink_cmd devl_gen_inst = {
+const struct devlink_cmd devl_cmd_get = {
 	.dump_one		= devlink_nl_cmd_get_dump_one,
 };
 
@@ -1359,7 +1359,7 @@ devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_port = {
+const struct devlink_cmd devl_cmd_port_get = {
 	.dump_one		= devlink_nl_cmd_port_get_dump_one,
 };
 
@@ -2137,7 +2137,7 @@ static int devlink_nl_cmd_linecard_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_linecard = {
+const struct devlink_cmd devl_cmd_linecard_get = {
 	.dump_one		= devlink_nl_cmd_linecard_get_dump_one,
 };
 
@@ -2392,7 +2392,7 @@ devlink_nl_cmd_sb_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_sb = {
+const struct devlink_cmd devl_cmd_sb_get = {
 	.dump_one		= devlink_nl_cmd_sb_get_dump_one,
 };
 
@@ -2530,7 +2530,7 @@ devlink_nl_cmd_sb_pool_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_sb_pool = {
+const struct devlink_cmd devl_cmd_sb_pool_get = {
 	.dump_one		= devlink_nl_cmd_sb_pool_get_dump_one,
 };
 
@@ -2738,7 +2738,7 @@ devlink_nl_cmd_sb_port_pool_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_sb_port_pool = {
+const struct devlink_cmd devl_cmd_sb_port_pool_get = {
 	.dump_one		= devlink_nl_cmd_sb_port_pool_get_dump_one,
 };
 
@@ -2973,7 +2973,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_sb_tc_pool_bind = {
+const struct devlink_cmd devl_cmd_sb_tc_pool_bind_get = {
 	.dump_one		= devlink_nl_cmd_sb_tc_pool_bind_get_dump_one,
 };
 
@@ -4785,7 +4785,7 @@ devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
 					 cb->extack);
 }
 
-const struct devlink_cmd devl_gen_selftests = {
+const struct devlink_cmd devl_cmd_selftests_get = {
 	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
 };
 
@@ -5271,7 +5271,7 @@ devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_param = {
+const struct devlink_cmd devl_cmd_param_get = {
 	.dump_one		= devlink_nl_cmd_param_get_dump_one,
 };
 
@@ -5978,7 +5978,7 @@ devlink_nl_cmd_region_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return 0;
 }
 
-const struct devlink_cmd devl_gen_region = {
+const struct devlink_cmd devl_cmd_region_get = {
 	.dump_one		= devlink_nl_cmd_region_get_dump_one,
 };
 
@@ -6625,7 +6625,7 @@ devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_info = {
+const struct devlink_cmd devl_cmd_info_get = {
 	.dump_one		= devlink_nl_cmd_info_get_dump_one,
 };
 
@@ -7793,7 +7793,7 @@ devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
 	return 0;
 }
 
-const struct devlink_cmd devl_gen_health_reporter = {
+const struct devlink_cmd devl_cmd_health_reporter_get = {
 	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
 };
 
@@ -8311,7 +8311,7 @@ devlink_nl_cmd_trap_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_trap = {
+const struct devlink_cmd devl_cmd_trap_get = {
 	.dump_one		= devlink_nl_cmd_trap_get_dump_one,
 };
 
@@ -8524,7 +8524,7 @@ devlink_nl_cmd_trap_group_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_trap_group = {
+const struct devlink_cmd devl_cmd_trap_group_get = {
 	.dump_one		= devlink_nl_cmd_trap_group_get_dump_one,
 };
 
@@ -8817,7 +8817,7 @@ devlink_nl_cmd_trap_policer_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_cmd devl_gen_trap_policer = {
+const struct devlink_cmd devl_cmd_trap_policer_get = {
 	.dump_one		= devlink_nl_cmd_trap_policer_get_dump_one,
 };
 
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 33ed3984f3cb..7a332eb70f70 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -177,23 +177,23 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 	devlink_put(devlink);
 }
 
-static const struct devlink_cmd *devl_gen_cmds[] = {
-	[DEVLINK_CMD_GET]		= &devl_gen_inst,
-	[DEVLINK_CMD_PORT_GET]		= &devl_gen_port,
-	[DEVLINK_CMD_SB_GET]		= &devl_gen_sb,
-	[DEVLINK_CMD_SB_POOL_GET]	= &devl_gen_sb_pool,
-	[DEVLINK_CMD_SB_PORT_POOL_GET]	= &devl_gen_sb_port_pool,
-	[DEVLINK_CMD_SB_TC_POOL_BIND_GET] = &devl_gen_sb_tc_pool_bind,
-	[DEVLINK_CMD_PARAM_GET]		= &devl_gen_param,
-	[DEVLINK_CMD_REGION_GET]	= &devl_gen_region,
-	[DEVLINK_CMD_INFO_GET]		= &devl_gen_info,
-	[DEVLINK_CMD_HEALTH_REPORTER_GET] = &devl_gen_health_reporter,
-	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
-	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
-	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
-	[DEVLINK_CMD_TRAP_POLICER_GET]	= &devl_gen_trap_policer,
-	[DEVLINK_CMD_LINECARD_GET]	= &devl_gen_linecard,
-	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
+static const struct devlink_cmd *devl_cmds[] = {
+	[DEVLINK_CMD_GET]		= &devl_cmd_get,
+	[DEVLINK_CMD_PORT_GET]		= &devl_cmd_port_get,
+	[DEVLINK_CMD_SB_GET]		= &devl_cmd_sb_get,
+	[DEVLINK_CMD_SB_POOL_GET]	= &devl_cmd_sb_pool_get,
+	[DEVLINK_CMD_SB_PORT_POOL_GET]	= &devl_cmd_sb_port_pool_get,
+	[DEVLINK_CMD_SB_TC_POOL_BIND_GET] = &devl_cmd_sb_tc_pool_bind_get,
+	[DEVLINK_CMD_PARAM_GET]		= &devl_cmd_param_get,
+	[DEVLINK_CMD_REGION_GET]	= &devl_cmd_region_get,
+	[DEVLINK_CMD_INFO_GET]		= &devl_cmd_info_get,
+	[DEVLINK_CMD_HEALTH_REPORTER_GET] = &devl_cmd_health_reporter_get,
+	[DEVLINK_CMD_TRAP_GET]		= &devl_cmd_trap_get,
+	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_cmd_trap_group_get,
+	[DEVLINK_CMD_TRAP_POLICER_GET]	= &devl_cmd_trap_policer_get,
+	[DEVLINK_CMD_RATE_GET]		= &devl_cmd_rate_get,
+	[DEVLINK_CMD_LINECARD_GET]	= &devl_cmd_linecard_get,
+	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_cmd_selftests_get,
 };
 
 int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
@@ -205,7 +205,7 @@ int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int err = 0;
 
-	cmd = devl_gen_cmds[info->op.cmd];
+	cmd = devl_cmds[info->op.cmd];
 
 	while ((devlink = devlinks_xa_find_get(sock_net(msg->sk),
 					       &state->instance))) {
-- 
2.39.0

