Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DCF66570C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbjAKJM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238309AbjAKJLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:47 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D2C1209A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:15 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c85so7628789pfc.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9m0IkEPPKgnaLZVYgkLNZGrK12L6G9JTLAZlZEcknsU=;
        b=jl8jxK5kU24HXkCANvcJpf1r9TJuSTOPGQ6fXE5lSNsCDDvGizWTMxlBy9B2Cn+yBz
         YvmonSsoWUmnxwPvIIFVTY21GSN66aY/mBtbLML9Zx1UIQcEZOJSRiLwtnNzvG8ocWTb
         tiErDBpUaXfQkCcMgnAWxtnBaL8U2AnfZcm4PGsOGQGoFixj79/bNxlwaikVntCWBbJe
         BHfslDrSqCkSe2wo+lk5R1ICz+cG/Cd5n4G81vqYUvkrzqF0SDaGOB0j3W3UIVCLbC4N
         93z6IlGVwh40fI1mUUsaCZhWfZrVSADrVnBRcqY9vE32O0usYz//JGRQWdP6Fafg673l
         6Xpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9m0IkEPPKgnaLZVYgkLNZGrK12L6G9JTLAZlZEcknsU=;
        b=rmMjuc//9vGRo0lYHdVB05y/6HglR9hq5K99MclVm2XFaoCSEjrQEk5+hTaNEXWc5U
         krM2pTyWD2KFY//tLMUFeLPjZzRloz0IYjoWQj89X49jL1bt8X4NGmpUJapKMTLPK5RZ
         G+PSDL9mMZ6OZDZZSFmzvqwXpKModwdMsuMxN7e03rmdGmomQyi5/wiexYKSO0THHFWj
         9IR2craVNM9OaQhNq8EfwZLvXDtlBplVqeSpm+EWB7NcOfOSKYj6ymRwwvJs03ttSeBT
         5qmlcgbRKcLCscavmM+IEvgSnHP0Qs6QgvnVGt4H/gXU49a384udNeoAyOeBiAob6Jze
         cXYA==
X-Gm-Message-State: AFqh2kob8spB8ifhj4wCU7tO6YtHe2W0IndinC6a/4gblE7jnHKcDLV9
        79fCdk0xdnacShsjlwviz9tpvJ2ufkc1pzpBiERdzQ==
X-Google-Smtp-Source: AMrXdXsbn9j2VYL15Rw4Cv1nqraSfUFkmycW4FJWfv47Ja/a9AUO/IDNSSNc7HJjZa3QAsQwXUS3gQ==
X-Received: by 2002:aa7:8f8e:0:b0:581:c0ee:3a5e with SMTP id t14-20020aa78f8e000000b00581c0ee3a5emr42874285pfs.20.1673428095224;
        Wed, 11 Jan 2023 01:08:15 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id g15-20020aa796af000000b00581d62be96dsm9475256pfk.197.2023.01.11.01.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 07/10] devlink: convert linecards dump to devlink_nl_instance_iter_dump()
Date:   Wed, 11 Jan 2023 10:07:45 +0100
Message-Id: <20230111090748.751505-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
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
linecards .dumpit generic netlink callback to use it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/devlink/devl_internal.h |  1 +
 net/devlink/leftover.c      | 64 ++++++++++++++++---------------------
 net/devlink/netlink.c       |  1 +
 3 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 7eb32c35ad81..3a3bbc0afad9 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -166,6 +166,7 @@ extern const struct devlink_gen_cmd devl_gen_info;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
+extern const struct devlink_gen_cmd devl_gen_linecard;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6072436318c3..4d335095eef2 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -2105,50 +2105,42 @@ static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
-					      struct netlink_callback *cb)
+static int devlink_nl_cmd_linecard_get_dump_one(struct sk_buff *msg,
+						struct devlink *devlink,
+						struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_linecard *linecard;
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		int idx = 0;
-
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
+	int idx = 0;
+	int err = 0;
 
-		list_for_each_entry(linecard, &devlink->linecard_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			mutex_lock(&linecard->state_lock);
-			err = devlink_nl_linecard_fill(msg, devlink, linecard,
-						       DEVLINK_CMD_LINECARD_NEW,
-						       NETLINK_CB(cb->skb).portid,
-						       cb->nlh->nlmsg_seq,
-						       NLM_F_MULTI,
-						       cb->extack);
-			mutex_unlock(&linecard->state_lock);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(linecard, &devlink->linecard_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-next_devlink:
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		mutex_lock(&linecard->state_lock);
+		err = devlink_nl_linecard_fill(msg, devlink, linecard,
+					       DEVLINK_CMD_LINECARD_NEW,
+					       NETLINK_CB(cb->skb).portid,
+					       cb->nlh->nlmsg_seq,
+					       NLM_F_MULTI,
+					       cb->extack);
+		mutex_unlock(&linecard->state_lock);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_linecard = {
+	.dump_one		= devlink_nl_cmd_linecard_get_dump_one,
+};
+
 static struct devlink_linecard_type *
 devlink_linecard_type_lookup(struct devlink_linecard *linecard,
 			     const char *type)
@@ -8999,7 +8991,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_LINECARD_GET,
 		.doit = devlink_nl_cmd_linecard_get_doit,
-		.dumpit = devlink_nl_cmd_linecard_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 		/* can be retrieved by unprivileged users */
 	},
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 3f2ab4360f11..b18e216e09b0 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -191,6 +191,7 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
 	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
 	[DEVLINK_CMD_TRAP_POLICER_GET]	= &devl_gen_trap_policer,
+	[DEVLINK_CMD_LINECARD_GET]	= &devl_gen_linecard,
 	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
 };
 
-- 
2.39.0

