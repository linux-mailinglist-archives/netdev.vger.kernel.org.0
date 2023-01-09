Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7164662F41
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbjAISfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbjAISdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E33D1C403
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:49 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s3so4306724pfd.12
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KG0NHEiaqGtDUJf5bExR7XlbgtrQz/VrywdrXUDUVew=;
        b=cEv+Djbuud97xuJVMwhZd7UWYxJke00keZyPIDOBkFZWeEbDwWRsMIZTso913LvxTA
         l+f+lRaGJrxCSfOpbBlfGuwPJYQKQYjLvSYlJO6HfylFegsnRzm2e5SXX1XRFImaxZki
         2Cs82ouKD/bVoE92EMCbzD6AHHRYU02J26ErTD0BI8HAZFWHkNAkOxwo2BiFtl5m0MIw
         isdRLcsZ7s/ty6vW5PspsA9jUEK6HJJOzDl17Xm0pAsxpUgeMfAbHYE+9+N9IzmUGjBp
         V6MSw1u9LhAhQFoHwrvS3AxhgcARmbjMFK/B1d945MjXqX+BzkPQJmz9VwcTqHAUPatY
         pM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KG0NHEiaqGtDUJf5bExR7XlbgtrQz/VrywdrXUDUVew=;
        b=JqAdaWVuqi9WZFcZt9eF0pWtMvRfFF5eTAA1GqCmNSmG4/EPmAm22H/itL2ikTboJI
         0HAEdtzWIdJgwD1F22L6Iv6V6wn2m3mCPkp3anOytce0Su9lgMXodcakOifjA2iBwLTV
         g6j/5oDHT3B+yqXF1jPQIjrFpttfKHlbhvs6PfHTPdpICT2LZ8Ofi+W9d4Ma7+wNtJLo
         PzlLqBfeq85BQ6EKhZZ63pK6sE3jl18TlUpvuMTEfYJb9SaxrYIwWXB57fe4753FlnMj
         JcqHvP+LfCc2AmXqzUR2HvwKNjxHhUJQ2Qh2cxpxBvgCkpYjbKqK2Z56khuVQ9b1RmjS
         JbXA==
X-Gm-Message-State: AFqh2koU5udItFNJYFnh+Mot4G9l7SYpRTZJD6XNBVidyY8m4oHbffty
        g9L6GfVyoKdudjOs9feMM0BVxUq8UE1KsqGdIzkbAA==
X-Google-Smtp-Source: AMrXdXvapinYGGijRlgsNkrFyfAuWPoztwrAWLfmVWJPNp7BgCw5OdbYUQMtpW0QFZZ8ZeB9GV/UBA==
X-Received: by 2002:a05:6a00:4398:b0:582:7675:8b5a with SMTP id bt24-20020a056a00439800b0058276758b5amr27262631pfb.33.1673289108864;
        Mon, 09 Jan 2023 10:31:48 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id p29-20020aa79e9d000000b00574db8ca00fsm6344222pfq.185.2023.01.09.10.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:48 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 07/11] devlink: remove reporter reference counting
Date:   Mon,  9 Jan 2023 19:31:16 +0100
Message-Id: <20230109183120.649825-8-jiri@resnulli.us>
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

As long as the reporter life time is protected by devlink instance
lock, the reference counting is no longer needed. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3
- fixed typo in patch description
---
 net/devlink/leftover.c | 113 +++++++++++------------------------------
 1 file changed, 30 insertions(+), 83 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 70b8a9f15ac3..c512ddb6bd5e 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7266,7 +7266,6 @@ struct devlink_health_reporter {
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
-	refcount_t refcount;
 };
 
 void *
@@ -7325,7 +7324,6 @@ __devlink_health_reporter_create(struct devlink *devlink,
 	reporter->auto_recover = !!ops->recover;
 	reporter->auto_dump = !!ops->dump;
 	mutex_init(&reporter->dump_lock);
-	refcount_set(&reporter->refcount, 1);
 	return reporter;
 }
 
@@ -7416,13 +7414,6 @@ devlink_health_reporter_free(struct devlink_health_reporter *reporter)
 	kfree(reporter);
 }
 
-static void
-devlink_health_reporter_put(struct devlink_health_reporter *reporter)
-{
-	if (refcount_dec_and_test(&reporter->refcount))
-		devlink_health_reporter_free(reporter);
-}
-
 /**
  *	devl_health_reporter_destroy - destroy devlink health reporter
  *
@@ -7434,7 +7425,7 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 	devl_assert_locked(reporter->devlink);
 
 	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
+	devlink_health_reporter_free(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7678,7 +7669,6 @@ static struct devlink_health_reporter *
 devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 				       struct nlattr **attrs)
 {
-	struct devlink_health_reporter *reporter;
 	struct devlink_port *devlink_port;
 	char *reporter_name;
 
@@ -7687,17 +7677,12 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
 	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
-	if (IS_ERR(devlink_port)) {
-		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
-		if (reporter)
-			refcount_inc(&reporter->refcount);
-	} else {
-		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
-		if (reporter)
-			refcount_inc(&reporter->refcount);
-	}
-
-	return reporter;
+	if (IS_ERR(devlink_port))
+		return devlink_health_reporter_find_by_name(devlink,
+							    reporter_name);
+	else
+		return devlink_port_health_reporter_find_by_name(devlink_port,
+								 reporter_name);
 }
 
 static struct devlink_health_reporter *
@@ -7756,10 +7741,8 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!msg)
+		return -ENOMEM;
 
 	err = devlink_nl_health_reporter_fill(msg, reporter,
 					      DEVLINK_CMD_HEALTH_REPORTER_GET,
@@ -7767,13 +7750,10 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					      0);
 	if (err) {
 		nlmsg_free(msg);
-		goto out;
+		return err;
 	}
 
-	err = genlmsg_reply(msg, info);
-out:
-	devlink_health_reporter_put(reporter);
-	return err;
+	return genlmsg_reply(msg, info);
 }
 
 static int
@@ -7847,7 +7827,6 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
@@ -7855,15 +7834,12 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 
 	if (!reporter->ops->recover &&
 	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
-	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
+		return -EOPNOTSUPP;
+
 	if (!reporter->ops->dump &&
-	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		return -EOPNOTSUPP;
 
 	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		reporter->graceful_period =
@@ -7877,11 +7853,7 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		reporter->auto_dump =
 		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
 
-	devlink_health_reporter_put(reporter);
 	return 0;
-out:
-	devlink_health_reporter_put(reporter);
-	return err;
 }
 
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
@@ -7889,16 +7861,12 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
 		return -EINVAL;
 
-	err = devlink_health_reporter_recover(reporter, NULL, info->extack);
-
-	devlink_health_reporter_put(reporter);
-	return err;
+	return devlink_health_reporter_recover(reporter, NULL, info->extack);
 }
 
 static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
@@ -7913,36 +7881,27 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->diagnose) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->diagnose)
 		return -EOPNOTSUPP;
-	}
 
 	fmsg = devlink_fmsg_alloc();
-	if (!fmsg) {
-		devlink_health_reporter_put(reporter);
+	if (!fmsg)
 		return -ENOMEM;
-	}
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
-		goto out;
+		return err;
 
 	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
 	if (err)
-		goto out;
+		return err;
 
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
-		goto out;
-
-	err = devlink_fmsg_snd(fmsg, info,
-			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
+		return err;
 
-out:
-	devlink_fmsg_free(fmsg);
-	devlink_health_reporter_put(reporter);
-	return err;
+	return devlink_fmsg_snd(fmsg, info,
+				DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
 }
 
 static int
@@ -7957,10 +7916,9 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&reporter->dump_lock);
 	if (!state->idx) {
 		err = devlink_health_do_dump(reporter, NULL, cb->extack);
@@ -7978,8 +7936,6 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
 unlock:
 	mutex_unlock(&reporter->dump_lock);
-out:
-	devlink_health_reporter_put(reporter);
 	return err;
 }
 
@@ -7994,15 +7950,12 @@ devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->dump)
 		return -EOPNOTSUPP;
-	}
 
 	mutex_lock(&reporter->dump_lock);
 	devlink_health_dump_clear(reporter);
 	mutex_unlock(&reporter->dump_lock);
-	devlink_health_reporter_put(reporter);
 	return 0;
 }
 
@@ -8011,21 +7964,15 @@ static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->test) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->test)
 		return -EOPNOTSUPP;
-	}
-
-	err = reporter->ops->test(reporter, info->extack);
 
-	devlink_health_reporter_put(reporter);
-	return err;
+	return reporter->ops->test(reporter, info->extack);
 }
 
 struct devlink_stats {
-- 
2.39.0

