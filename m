Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32F7660D64
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjAGJtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAGJtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:39 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B20B7CDC3
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:38 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q9so2748660pgq.5
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoEHwXzLbpBliuhj4P0C0mBQBdx5o51jhZCfofp/CmI=;
        b=ednn2dRYnWBi0sLb/O/LQRYStwes54njbudpOFa/vW3+moV6RbkBn7nhGR691hnLOy
         GB4jdT88yht9VprngDy2ZF7m9kpjbOQAFGKyoYSH+8gcHFOaNg2sHVukukAGkE+2vFhA
         d2aG+1IlpmYCcpImBB4p8IpXsO2asCdQSXXg4ZCKeG7szKy/u+XakMcr4JAA2k0vytz1
         E5I6xb/wh9XlQL3hVKBAS0JDnVY/efo9IVUQM8VHqua1iDTNrj0zkPRx47vpCRftpSUd
         H/dD1NKDIo4Zzmm4fTcXody7zbQCAAB5LrTGdCL7OU//DXyied8axiYknKwNypI2jKmP
         C7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IoEHwXzLbpBliuhj4P0C0mBQBdx5o51jhZCfofp/CmI=;
        b=cf6UT0YUQz9CeoV6hUMGptFpYPEBYA3D1SlTgifpKA/O0R7mLCfc2OcmbemySGC5qk
         mRi7l31tzK2qYkin77pTuSKH1T284repIkkQTZPbcYESDXaTCArH20N5CzFjvWVjzvro
         SmbWqqMjNCEhvfDV/ybSO+scuAJSD3UtzX7rJF/awK6SUJNA/Dto1XLgKhqLeRwEfj8O
         gub0Uc1UfN+klGQshoQk8t6yaPRa/zqISsYMm7EnFkSrcvKizQat4EkyJLDQzwxmk1sc
         uNk3waW+7LjQLZ3b/YKCrIxDOOegdRi5bfRzv0sI5vArQU0g2tHJagynvPF/Wn1+BqZI
         levg==
X-Gm-Message-State: AFqh2kpjqgWPrcEnFVkUZEStwokDGgu82B2YWytyZ3K1/cflPoIgMd7G
        6hlf/PeQxENp4MIJBPCOgc6unqZAIeS14y/1hhTZhg==
X-Google-Smtp-Source: AMrXdXu6QH52w6hpdEkF8SSVA39JcW3OZy5Tqd5HNchyYdm7NV0L+4ElYPKeeDjzEZeJEqOuGdKHGA==
X-Received: by 2002:a62:a514:0:b0:580:8c2c:d0ad with SMTP id v20-20020a62a514000000b005808c2cd0admr50900485pfm.13.1673084977908;
        Sat, 07 Jan 2023 01:49:37 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id p29-20020aa79e9d000000b00574db8ca00fsm2429270pfq.185.2023.01.07.01.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 7/8] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
Date:   Sat,  7 Jan 2023 10:49:08 +0100
Message-Id: <20230107094909.530239-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107094909.530239-1-jiri@resnulli.us>
References: <20230107094909.530239-1-jiri@resnulli.us>
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

Benefit from recently introduced instance iteration and convert
reporters .dumpit generic netlink callback to use it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 12 +----
 net/devlink/leftover.c      | 87 ++++++++++++++++---------------------
 net/devlink/netlink.c       |  6 ++-
 3 files changed, 44 insertions(+), 61 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 52d958c1c977..2b0e119e7b84 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -121,17 +121,6 @@ struct devlink_gen_cmd {
 			struct netlink_callback *cb);
 };
 
-/* Iterate over registered devlink instances for devlink dump.
- * devlink_put() needs to be called for each iterated devlink pointer
- * in loop body in order to release the reference.
- * Note: this is NOT a generic iterator, it makes assumptions about the use
- *	 of @state and can only be used once per dumpit implementation.
- */
-#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
-	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
-					       &state->instance));	\
-	     state->instance++, state->idx = 0)
-
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *
@@ -162,6 +151,7 @@ extern const struct devlink_gen_cmd devl_gen_selftests;
 extern const struct devlink_gen_cmd devl_gen_param;
 extern const struct devlink_gen_cmd devl_gen_region;
 extern const struct devlink_gen_cmd devl_gen_info;
+extern const struct devlink_gen_cmd devl_gen_health_reporter;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c5feda997932..59fa5f543e8f 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7749,70 +7749,59 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 }
 
 static int
-devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
+					    struct devlink *devlink,
+					    struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_health_reporter *reporter;
+	struct devlink_port *port;
+	unsigned long port_index;
+	int idx = 0;
 	int err;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_health_reporter *reporter;
-		struct devlink_port *port;
-		unsigned long port_index;
-		int idx = 0;
-
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
-
-		list_for_each_entry(reporter, &devlink->reporter_list,
-				    list) {
+	list_for_each_entry(reporter, &devlink->reporter_list, list) {
+		if (idx < state->idx) {
+			idx++;
+			continue;
+		}
+		err = devlink_nl_health_reporter_fill(msg, reporter,
+						      DEVLINK_CMD_HEALTH_REPORTER_GET,
+						      NETLINK_CB(cb->skb).portid,
+						      cb->nlh->nlmsg_seq,
+						      NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			return err;
+		}
+		idx++;
+	}
+	xa_for_each(&devlink->ports, port_index, port) {
+		list_for_each_entry(reporter, &port->reporter_list, list) {
 			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
-			err = devlink_nl_health_reporter_fill(
-				msg, reporter, DEVLINK_CMD_HEALTH_REPORTER_GET,
-				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-				NLM_F_MULTI);
+			err = devlink_nl_health_reporter_fill(msg, reporter,
+							      DEVLINK_CMD_HEALTH_REPORTER_GET,
+							      NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NLM_F_MULTI);
 			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
 				state->idx = idx;
-				goto out;
+				return err;
 			}
 			idx++;
 		}
-
-		xa_for_each(&devlink->ports, port_index, port) {
-			list_for_each_entry(reporter, &port->reporter_list, list) {
-				if (idx < state->idx) {
-					idx++;
-					continue;
-				}
-				err = devlink_nl_health_reporter_fill(
-					msg, reporter,
-					DEVLINK_CMD_HEALTH_REPORTER_GET,
-					NETLINK_CB(cb->skb).portid,
-					cb->nlh->nlmsg_seq, NLM_F_MULTI);
-				if (err) {
-					devl_unlock(devlink);
-					devlink_put(devlink);
-					state->idx = idx;
-					goto out;
-				}
-				idx++;
-			}
-		}
-next_devlink:
-		devl_unlock(devlink);
-		devlink_put(devlink);
 	}
-out:
-	return msg->len;
+
+	return 0;
 }
 
+const struct devlink_gen_cmd devl_gen_health_reporter = {
+	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
+};
+
 static int
 devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
@@ -9179,7 +9168,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
-		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index b18e216e09b0..3f44633af01c 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -187,6 +187,7 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_PARAM_GET]		= &devl_gen_param,
 	[DEVLINK_CMD_REGION_GET]	= &devl_gen_region,
 	[DEVLINK_CMD_INFO_GET]		= &devl_gen_info,
+	[DEVLINK_CMD_HEALTH_REPORTER_GET] = &devl_gen_health_reporter,
 	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
 	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
 	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
@@ -206,7 +207,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 
 	cmd = devl_gen_cmds[info->op.cmd];
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
+	while ((devlink = devlinks_xa_find_get(sock_net(msg->sk),
+					       &state->instance))) {
 		devl_lock(devlink);
 
 		if (devl_is_registered(devlink))
@@ -220,6 +222,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 		if (err)
 			break;
 
+		state->instance++;
+
 		/* restart sub-object walk for the next instance */
 		state->idx = 0;
 	}
-- 
2.39.0

