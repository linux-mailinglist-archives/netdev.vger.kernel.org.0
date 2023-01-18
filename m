Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43D67212B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjARPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjARPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:53 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0711A970
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u19so84003167ejm.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+HKDcAyKjTAUcx44xJMfm/g/IX8ETh/jVwJCpJOZwM=;
        b=F3q6qMK7ca7srBEeXipzyKgO+2AzX2v38VLPB6gdhG8AIqVNvc8Bi5hN6nJy8vZrVt
         hwZKEbO0pcCAGmF2ql0FwDxv9fd4doYR22mSf4HgWmV4FXc9Cy1cuWXs/TPtPf0fb2Jt
         f/vH5IQmqLwrFgJv2nPczZeV4adqRFekfeRB0jrwopWyQ8OR51oPlQUy6JWlFj628eH7
         mPVL7Jb/sO0lyvrDtmt/Vl+0Tc6kC/qSXfUAkBZlAx+e0tTZTALe1wNsb/Wb9eIDvDvt
         3QJOkJC1QoSFzpjqgq8CAJa8DrI3Cct/upiv9Xl3gANYJl8UJ6AJVzDW/dy+d9ZF82Ma
         lSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+HKDcAyKjTAUcx44xJMfm/g/IX8ETh/jVwJCpJOZwM=;
        b=1enck8SljOYbe4/96l+J7qgpgS1Ebh1csavl66nfgMgxLKRvNDZeCVbV6babSopfVe
         MaI/IbI5VS67q2RFpo83dfsDzS1vpnBXErrPAJKjSbv4xU9wx0bKpwNQcQl+lWtYtVnw
         BJY3LuuuozDeryPlOqWPju7AYWJq1j4Z9yP/Jm6AZcmmoz5XAicxNBGh+yqVfuj0iXPC
         VxbXAW6xSU/sCQyLnUoND8JYBvei+IpzFqIgXvvHZww4OQGv79uhP0XedcfnF9TPxrxr
         Y8qkAY8l3mRDh6yZBms5lijY6yqa+1MvsSdmQ/XyQYA8uQ7P2MI1ZEoWsVu85fCgJSRG
         FhSg==
X-Gm-Message-State: AFqh2ko/LDKSA1kPXSJ8ClYRVFrGZevxVZghYCW1EUhDcAW/ANr+E9AI
        eKxAsOXflWc01AMPlcjiafFAbEd6eCw/XpHZ7rb5Xg==
X-Google-Smtp-Source: AMrXdXvObJeie/U1dOWYet/cYR27BoafEW5mYZ3cpk0p48CcVnTvEtQ4d3j5mDMOgEsRxCZn0VpkKQ==
X-Received: by 2002:a17:907:6d21:b0:805:1e6e:6777 with SMTP id sa33-20020a1709076d2100b008051e6e6777mr27949408ejc.23.1674055292726;
        Wed, 18 Jan 2023 07:21:32 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906300b00b008675df83251sm7865548ejz.34.2023.01.18.07.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 08/12] devlink: remove reporter reference counting
Date:   Wed, 18 Jan 2023 16:21:11 +0100
Message-Id: <20230118152115.1113149-9-jiri@resnulli.us>
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
index a56dd70a10e0..70eebf4a61c8 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7269,7 +7269,6 @@ struct devlink_health_reporter {
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
-	refcount_t refcount;
 };
 
 void *
@@ -7328,7 +7327,6 @@ __devlink_health_reporter_create(struct devlink *devlink,
 	reporter->auto_recover = !!ops->recover;
 	reporter->auto_dump = !!ops->dump;
 	mutex_init(&reporter->dump_lock);
-	refcount_set(&reporter->refcount, 1);
 	return reporter;
 }
 
@@ -7435,13 +7433,6 @@ devlink_health_reporter_free(struct devlink_health_reporter *reporter)
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
@@ -7453,7 +7444,7 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 	devl_assert_locked(reporter->devlink);
 
 	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
+	devlink_health_reporter_free(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7697,7 +7688,6 @@ static struct devlink_health_reporter *
 devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 				       struct nlattr **attrs)
 {
-	struct devlink_health_reporter *reporter;
 	struct devlink_port *devlink_port;
 	char *reporter_name;
 
@@ -7706,17 +7696,12 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 
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
@@ -7775,10 +7760,8 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
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
@@ -7786,13 +7769,10 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
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
@@ -7866,7 +7846,6 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
@@ -7874,15 +7853,12 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 
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
@@ -7896,11 +7872,7 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		reporter->auto_dump =
 		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
 
-	devlink_health_reporter_put(reporter);
 	return 0;
-out:
-	devlink_health_reporter_put(reporter);
-	return err;
 }
 
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
@@ -7908,16 +7880,12 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
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
@@ -7932,36 +7900,27 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
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
@@ -7976,10 +7935,9 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
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
@@ -7997,8 +7955,6 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
 unlock:
 	mutex_unlock(&reporter->dump_lock);
-out:
-	devlink_health_reporter_put(reporter);
 	return err;
 }
 
@@ -8013,15 +7969,12 @@ devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
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
 
@@ -8030,21 +7983,15 @@ static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
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

