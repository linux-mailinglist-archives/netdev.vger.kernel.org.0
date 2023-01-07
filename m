Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D879660D60
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjAGJto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjAGJtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65877CDCD
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so7746678pjq.1
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFZzyYy3cnyXRONunaM6t3i0ymLdSSoZouxoDeB1fZE=;
        b=VeO446ZWNR51vEVB91pQR7VdNPY9KEFW9OXSu/bg7xbBkZEv4sLyBFNZsXzPjDp67G
         eJjUlcwpiCrUeETNzN3esGYCcZARRlh4cv8jR+y+hHTOWArKoy91C8AH35HMmStGa8B/
         NETkb4tVo9co72765rgaJBRWn/ql+4+FsF3Cci5emtwJ3bj5tjUSXTUOUhjDA7jfv6tP
         iQAk7Y2TVanNjv/amArxnAZN/OrmvzKDleg2fEHQ8eVHO2JxPg47QhTHU+1tu98ycPD/
         IHIEX1DlC8P5i368yh8l+VJN4G7143XShM4RB5YSJ2+UVrpyglfZRCHuxEmInJ5zuVmw
         05Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFZzyYy3cnyXRONunaM6t3i0ymLdSSoZouxoDeB1fZE=;
        b=FtE2j6kf7PhsKxeqUemFvhlU/oyjnPE+xTjba+m6qxXnknhLXwLXTJbzQ3n0N3wjZT
         SN5AX5cYkF8jJprvESBcTWyjYJWkwrFjJ4HzfYSrWf1Oxq9+DtaqyRE7T4I+bg5vz/Dd
         jHqbkozXKWp2HSIaqMUcDOckICiJG5g4JvkMo9mmM3v8dFVfzgMpa09PReY1bXfEALCY
         8CSd1lBfo4MooptBBzp88GGiTLsCISTvIodLwXsdjeRkLPU4dWU4kz1Ji77bs4zUjHSv
         C4FOokSFd9+VaPKKQCwMEx4NiAB2sRkrSS8CZ0WjpVyxRmXaHwPEmm3M6P4ljlNv0Yav
         yKXQ==
X-Gm-Message-State: AFqh2kqzhmr/ak0OfGAuYzz2K+6KfOgGXj6d0igrBMmCCq2YDfmKfjLu
        qHJZgsCS9itbGYmAtSTrBFZFx2fUvrtlYtF73EFw3w==
X-Google-Smtp-Source: AMrXdXv8zB9aJ7TVmuPAw2G2U0Mo8Kh8AzIMpz39dPoZlJsX1Q3TDxLPqLvGeHSPir+E0Q6ngyUeKw==
X-Received: by 2002:a17:90a:bb98:b0:226:da41:1e0a with SMTP id v24-20020a17090abb9800b00226da411e0amr6389720pjr.27.1673084963374;
        Sat, 07 Jan 2023 01:49:23 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id kx6-20020a17090b228600b0021900ba8eeesm4214172pjb.2.2023.01.07.01.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 3/8] devlink: remove linecard reference counting
Date:   Sat,  7 Jan 2023 10:49:04 +0100
Message-Id: <20230107094909.530239-4-jiri@resnulli.us>
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

As long as the linecard live time is protected by devlink instance
lock, the reference counting is no longer needed. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 14 ++------------
 net/devlink/netlink.c  |  5 -----
 2 files changed, 2 insertions(+), 17 deletions(-)

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

