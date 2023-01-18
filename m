Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DEB67212C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjARPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjARPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:53 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B892387F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:36 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v13so15974659eda.11
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zATwc450yXsToqEuc8W2qcmYj93ecT95/D0Oxce2p+w=;
        b=TZAcz3OdMJ4AP/XI9KREtLebgQ0Rz0vBK0qgOSBIzHLTIOUTuOgXENv1IIGXMePISW
         BUdYJbw9LQlVWhE0t0aWZUbhlxj8ujAE6ONITYHzWXmBfyV4QB5K0KiGrisfpkfr52gT
         W/8Y4Vf2rKR7xEc+AMaLz8m7XXEg0e4CEO2B5ZTQ6Aa89e+EkI1TIV1k+1koeDyRNgCX
         HuRz2HH4NE5krDEH4hsND/e4V8H/LY5x0Y12Oqxg04mfYKNaoAYiOFFWBR84c7OsRwsM
         ZQ+CD1PFqSKqB7pj7HOc6paeJnl8n9zsSMOe1bIex4wRbJGYafYNUMlEyrvriULgTJCX
         8MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zATwc450yXsToqEuc8W2qcmYj93ecT95/D0Oxce2p+w=;
        b=OhhDYmegO721xrEFV3ss0XfacxjwUSnqgXq3T/YspDpSoserYGBKbVa6+1o68MUKIc
         6wO7ByZZyxjZ3snvsy+JcXWHULbAUu05NQ+3SqLiBxamOa7juu1ZdpjcsZGyhmD5uC9W
         Kwh1VM+NRrtPcRX5P/hDgPd3MyAsI5u8OCA6SVF8F0up8Omu+XC+MWoITJOowFQAm7Sd
         JvE35Qx0hnhFaGNSuXAo6FinBEykFCIGTwhQ8XtvQYujzsa7OMByXdunHrV3o6w4e1k8
         jSSTipyKOviGJ36qbOmk+DaPxmS9Y8OLr+TktrKCboY+aTqJ6zlE21YDR1e65eqljyp3
         EsKA==
X-Gm-Message-State: AFqh2kqJGDMq/fEVJVGFMc3TxOtwT8xNJRShaajpHOQ4ukLm932En2b7
        TZjNxjliVdAdQX5/dPYrPryGNKQgExnkAwwAgTn06Q==
X-Google-Smtp-Source: AMrXdXvvH0QcbgYgMgfhQ9I5LdIbp9OMxyysUd2r3G96JZnbAIkpPYgaAu3BG6bWhPflLBy+ak4xWw==
X-Received: by 2002:a05:6402:2b97:b0:479:ab7d:1dad with SMTP id fj23-20020a0564022b9700b00479ab7d1dadmr7909400edb.32.1674055294605;
        Wed, 18 Jan 2023 07:21:34 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id cq22-20020a056402221600b00499703df898sm12404976edb.69.2023.01.18.07.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 09/12] devlink: convert linecards dump to devlink_nl_instance_iter_dump()
Date:   Wed, 18 Jan 2023 16:21:12 +0100
Message-Id: <20230118152115.1113149-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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
index bdb83014b4b5..d8f8e4bff5b4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -167,6 +167,7 @@ extern const struct devlink_gen_cmd devl_gen_info;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
+extern const struct devlink_gen_cmd devl_gen_linecard;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 70eebf4a61c8..8bb4c2710688 100644
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
@@ -9010,7 +9002,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
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

