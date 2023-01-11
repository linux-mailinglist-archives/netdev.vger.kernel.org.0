Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F187C665706
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbjAKJLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238429AbjAKJLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:18 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8029E14D2F
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:07:58 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d15so16115004pls.6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjlnjF7/wigyhylf//IR0tnhIogpKkLHRBH6x7FvKS8=;
        b=noQHgVNxtTVaxxKQcaSs1lrMWzTuiT33ZKTz2bXRmH5EvYDUdRoLxKpQ0nzlMLUSns
         XtperYKsMlUX9uO0lEoqNBPJtIrMrRqZgwJhORqk2mj2C7RJCPNg3Usjf1Go3hNjAXbb
         kD8t6iHDaLEM2uOvSV0sieYCAzilEoZatyOTwKcCCBlnYZ3VgAFgXswq48ZcVu1Zq6VD
         V7Rplhis5iGmLCIBLw5djhEE91Po2xKSn6CK7ArHMJCA69r2RtYlnLv1M032Hv85UcAz
         64NNDPSXSeG3zJRmPS4GpxyGEh05MMPsRRuYvKFtcDguRLgr0S5waodeO7+5LyRA+f9u
         AKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjlnjF7/wigyhylf//IR0tnhIogpKkLHRBH6x7FvKS8=;
        b=zI9eDT2LJdxvfwcoXnvd0i6UGmfcJsOIRryEmRP0+GX6zpCWc8fTGTzj69G518tjnv
         kg/2V6W7ZKTpDPGfQpqghyo0/obKzYIl/SpkSuzQ11uHqcb7buKfRxtkS29nxpCSxUWa
         E5tllgN6OxKg1xz3HP0xeg+kp946DExCg62P8ElEGdVDx0lzHWAox+0aFOpySEjw9hzg
         RHBsW3rLqaQflmm6feybe01NQly6+k83JdSB+0YqNLYjZxg6gBTUazTh/x9VA2wHKzcQ
         Wl0lGMuEULeUzMfdDq3sgslz+wiL7bZjH4Ul8uInJV3+FqIH7KV1Qpn9b70EWKgEW684
         9mIg==
X-Gm-Message-State: AFqh2kp1yVTj+IMSfNg0XpfIwk46TzD7vq5K8/QyK1ISv+SDHdFnevEV
        BY32FRL+tSl+fci0CnVovR6H8LqsvdlPXH4NFdLn0Q==
X-Google-Smtp-Source: AMrXdXt9ahxEhEAYli0gVIABSy58jmfnIXobM+vgTJzbXsY55dAy8HWIAsV121e1mEPMLoCeDPGkAg==
X-Received: by 2002:a17:902:ebc9:b0:189:a6be:85db with SMTP id p9-20020a170902ebc900b00189a6be85dbmr79658594plg.39.1673428078008;
        Wed, 11 Jan 2023 01:07:58 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id j6-20020a170903024600b001869f2120a4sm9604050plh.94.2023.01.11.01.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:07:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 02/10] devlink: remove linecard reference counting
Date:   Wed, 11 Jan 2023 10:07:40 +0100
Message-Id: <20230111090748.751505-3-jiri@resnulli.us>
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

As long as the linecard life time is protected by devlink instance
lock, the reference counting is no longer needed. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
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
index a466bb114186..d5bc46984039 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -192,7 +192,6 @@ struct devlink_linecard;
 
 struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
-void devlink_linecard_put(struct devlink_linecard *linecard);
 
 /* Rates */
 extern const struct devlink_gen_cmd devl_gen_rate_get;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index aec397e717f6..46f5575802ef 100644
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
@@ -10271,7 +10261,6 @@ devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	}
 
 	list_add_tail(&linecard->list, &devlink->linecard_list);
-	refcount_set(&linecard->refcount, 1);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	return linecard;
 }
@@ -10287,7 +10276,8 @@ void devl_linecard_destroy(struct devlink_linecard *linecard)
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

