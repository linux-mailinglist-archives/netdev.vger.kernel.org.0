Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC3662F3C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbjAISez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbjAISdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:51 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D93C1A069
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:52 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e10so6481411pgc.9
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGFv4w/4fbY+z3qnkfvjUK8MMxEmwI9RBZlkS0NuLmk=;
        b=42S78XH4Kc6xMiCGs6DRta3Wx04RfhGrvlBMH/OykEADuDx+91VNNi9sfKLpHLlE4E
         VR6bJWRgsLVHltaCfd4hxNTiTTCsxqOJubOQmK0vh4BzUjWv8LNnLe4dy8UZby7cFsBa
         ee5VjCca73rJFbHg3dbZ8r4EY+RQxmnYCYjLyhKMOf3xvssxM4sw29BeIx1/P/ljSVNE
         uEq+aEx51Ap9l6kFRg5IPfmqe0Ezx++u6mUze1oZIS0pB0WuTocpMuTxkLvlpJtrlrFm
         wHJmgspZdB/hqnxnG0a2h5jlu0wavLYh1xIdj8UNVSCk/zIvcCdB+vzvaXn9IVYO3aHB
         5YNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yGFv4w/4fbY+z3qnkfvjUK8MMxEmwI9RBZlkS0NuLmk=;
        b=s7IMFh5A+eBbXyAXcydSraqzvUeOdqn54h6R9V5hYGcb5ID+F9ljbCrtGPido+sx2e
         6JLNUs/zCVq6axFe2EZVf2djuHGkFmNng0h/SYrPi/vUNJ7ILhk7eYdvNvcmKKeVCEgY
         TsXGXIZEGL9jBSZLobUJjMXUkUeqDk3JkINEYIegMvLKb23gzgg0JhOIwIl+Ib0S/mhW
         wBWYUa0R509QSS2SlMPDexRzq7Nh10I/kzGlR0QtOxoUij9hwxPdfTY8p4LFUJXcvvHy
         Han+rXlulXIUbfCM0OefWbOFxnGqjc2V95cVqSbuAGXfRUkYlOmG9Bgx4yzHWDLzJP+V
         YCrw==
X-Gm-Message-State: AFqh2krjQFh6vDzjO1KlV7Mq0i5GCB87azjIKRoz67xu/290hSc8Wwz1
        /hetEnTX+QU2rws+TP1J183Rwlnjet0LexXojz6YyQ==
X-Google-Smtp-Source: AMrXdXuLhDBc9Ih+X3oAnY96agjTVJZQjm1KrlRxeKqh3vpG21BAqbSc7xLJGwPjEEHDzImECey5YA==
X-Received: by 2002:aa7:8809:0:b0:580:cc63:dcdc with SMTP id c9-20020aa78809000000b00580cc63dcdcmr54853970pfo.7.1673289112275;
        Mon, 09 Jan 2023 10:31:52 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id e11-20020a056a0000cb00b00582e4fda343sm4815672pfj.200.2023.01.09.10.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:51 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 08/11] devlink: convert linecards dump to devlink_nl_instance_iter_dump()
Date:   Mon,  9 Jan 2023 19:31:17 +0100
Message-Id: <20230109183120.649825-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
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
index 733e28c695d4..a6a6342270b7 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -165,6 +165,7 @@ extern const struct devlink_gen_cmd devl_gen_info;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
+extern const struct devlink_gen_cmd devl_gen_linecard;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c512ddb6bd5e..c5feda997932 100644
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
@@ -8996,7 +8988,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
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

