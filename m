Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0208C662F44
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbjAISfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbjAISdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:49 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F48C5C90F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:35 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id jl4so10445676plb.8
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGH2umzstJcoUIftcaNq/0Cr9ZzBsFWtZGJU7pf21kY=;
        b=Uj9p43JqJqS3UGrbfc84MGNMQ/9vdkY9t6FmW3CU2al1czv3l4CfSfn8TFd2cfbqWj
         kOcb5wSwUh68U0NLXqHY457OSHmsEIbvBMBtgxMB+bYP1ixXU/1ODgU1uGeiWk2c3sxZ
         fHFsT/x1Wn3hCuUrri5JicMTsevfdnzNL9VPhv7sauQqkEaifoLz2YKFB0AQEVcbi4hS
         guWp+0HA0PmQNXJb7EHg02CdMGbuwt4dBg78EYBxRURg/ILgP8BM99OmzMECke0BCSEt
         7t3yFmZYgb6IbmVwrz64vxprVdtUwysHZyGU0sLy8RkfR+ud5ITMu2IVKQEcHD7sOe/F
         QVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WGH2umzstJcoUIftcaNq/0Cr9ZzBsFWtZGJU7pf21kY=;
        b=R3y+aXx/doZWUMHpgJp86gtUTuAf4M5caWNsIhAAxDBet7/RrxeM9rwQo0L7bOEkOj
         +nvpyEu5uh2M8ZD8VPcvg/e065OnhLZKyzslycerGQzVvoNrTV6QGHNz1IlpB96n+CzN
         Ubmo9ONtMS1hYOgOCtummSaTuWAG+uNmI1HdGgyn8vRrv8YZXwAB9WmJkTL0ozGqFZ5Q
         N1ci7racpjifIs/FtB5GJFmUMUljqgU8TRsP1ocJbr7eRmGsWbrXinzOej8jUFe0C4wb
         +mxK+MTmUXIUcEkgJhtYWpfTgJHtrYeBckxzeDsx6cWofYvYndunodNQMb2EdnGxjCUI
         /UvQ==
X-Gm-Message-State: AFqh2kpWEQkmiB0mqStnEP9bNf3xwpzq2M4lRUnFkWtHh+D4brVlTjYL
        vzR7V1H0jiMZMSndarDa35u3vsX3ltoAxkhIH1CGjQ==
X-Google-Smtp-Source: AMrXdXs+VRsaXG0kG3XIR78h+KXJWOhq0JiOwSB+Yx7a598nHrkRJnMH1Bb9wsUAQlyFuvcQPO/FBA==
X-Received: by 2002:a17:902:6bc6:b0:192:c36c:f115 with SMTP id m6-20020a1709026bc600b00192c36cf115mr27323265plt.66.1673289094934;
        Mon, 09 Jan 2023 10:31:34 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b001913c5fc051sm6411804plg.274.2023.01.09.10.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 03/11] devlink: remove linecard reference counting
Date:   Mon,  9 Jan 2023 19:31:12 +0100
Message-Id: <20230109183120.649825-4-jiri@resnulli.us>
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

As long as the linecard life time is protected by devlink instance
lock, the reference counting is no longer needed. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- removed devlink_linecard_put() prototype from devl_internal.h
- fixed typo in patch description
---
 net/devlink/devl_internal.h |  1 -
 net/devlink/leftover.c      | 14 ++------------
 net/devlink/netlink.c       |  5 -----
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index ca49ad31027c..61c707c4f9a3 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -191,7 +191,6 @@ struct devlink_linecard;
 
 struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
-void devlink_linecard_put(struct devlink_linecard *linecard);
 
 /* Rates */
 extern const struct devlink_gen_cmd devl_gen_rate_get;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 4b01b15f8659..2208711b4b18 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -37,7 +37,6 @@ struct devlink_linecard {
 	struct list_head list;
 	struct devlink *devlink;
 	unsigned int index;
-	refcount_t refcount;
 	const struct devlink_linecard_ops *ops;
 	void *priv;
 	enum devlink_linecard_state state;
@@ -285,7 +284,6 @@ devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
 		linecard = devlink_linecard_get_by_index(devlink, linecard_index);
 		if (!linecard)
 			return ERR_PTR(-ENODEV);
-		refcount_inc(&linecard->refcount);
 		return linecard;
 	}
 	return ERR_PTR(-EINVAL);
@@ -297,14 +295,6 @@ devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
 	return devlink_linecard_get_from_attrs(devlink, info->attrs);
 }
 
-void devlink_linecard_put(struct devlink_linecard *linecard)
-{
-	if (refcount_dec_and_test(&linecard->refcount)) {
-		mutex_destroy(&linecard->state_lock);
-		kfree(linecard);
-	}
-}
-
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -10268,7 +10258,6 @@ devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	}
 
 	list_add_tail(&linecard->list, &devlink->linecard_list);
-	refcount_set(&linecard->refcount, 1);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	return linecard;
 }
@@ -10284,7 +10273,8 @@ void devl_linecard_destroy(struct devlink_linecard *linecard)
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
 	list_del(&linecard->list);
 	devlink_linecard_types_fini(linecard);
-	devlink_linecard_put(linecard);
+	mutex_destroy(&linecard->state_lock);
+	kfree(linecard);
 }
 EXPORT_SYMBOL_GPL(devl_linecard_destroy);
 
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index b5b8ac6db2d1..3f2ab4360f11 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -170,14 +170,9 @@ static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
 static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 {
-	struct devlink_linecard *linecard;
 	struct devlink *devlink;
 
 	devlink = info->user_ptr[0];
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
-		linecard = info->user_ptr[1];
-		devlink_linecard_put(linecard);
-	}
 	devl_unlock(devlink);
 	devlink_put(devlink);
 }
-- 
2.39.0

