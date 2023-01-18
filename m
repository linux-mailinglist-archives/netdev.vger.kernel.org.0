Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3EF672125
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjARPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjARPXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:49 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED6B19A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ss4so76772543ejb.11
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=So4EKtIsktS/ZgvQoRytqRmzbbbN8XW/1NYDBhCSUKQ=;
        b=1LhjN28L7AIwR4Ad9/g2dys33aKCF1lwf0b4JZ9c0dX7JV/KgE6L/+5pWlaha1o6O3
         0gayp/UGSky6OZ+kftxTS4WU5TIWridFd+SM2a8pneasmDxRpnoqvRUMjPNlgLtNdibQ
         q7g2NTgfYviW11ibhQjM7QXgCoyH6MvPZZevCv/JEx/hvvvWLdXvNkXgKIZaPebuefHW
         WuQLtbk+8bOsCxcIV+EP5fvATMrzsTxqxQizXgNEcKOUtXYn9xRURdWqjpCm60lhCXG3
         m4eEUUjPMLgK/bcfvlAhGyLPrx+REwq/Ol2EsyG/wHqRZvHd3ad4YoAeCg+Ywil6xAdi
         8p/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=So4EKtIsktS/ZgvQoRytqRmzbbbN8XW/1NYDBhCSUKQ=;
        b=NQ4s6/1OZXJ31VMU2NquizKEHj7Pa50b1X2zo5zp9p/pw7T+IJIvH43FFRBgWZRpka
         1tpy6sT+UCcmtOxY50uecq3lgdycNyKx7oJU+dRZj7h9VLvw9hU9hRSKOgDSBPsb/MaP
         3XQW9daxdvWCfTR+Z30pDQRdYz9D5aCPlbobB+zAEE1IgIcKUvFmmJqdFS9T20YnPaBi
         HWm1ffxDXsVo+gPv1vdzrcOvoxjofTiIgK3l7NlJv2u3YT3U6jnOT+eqYERCxM2yqmM+
         4uodzWEk1XRmYuqTi9e7JrgROx3ZANeBTxO0K4rm/ChLExZA6QPPumDoXP9xTnYB865k
         +Tlg==
X-Gm-Message-State: AFqh2kr9iGVYtp+VACY1CWG8GEF9mqojVXefSNRhQZAeWJj64AvtqaKr
        JkgGeCk+WeN9nWrPySPC0eHyWXiDAdYXbWRd9f1eoA==
X-Google-Smtp-Source: AMrXdXsd6CdjBzDvM3Dth7f/9XQn2OiykP9j9kSx5J4Zpt6eKa4ZQj5h0bcrvPPE926h/TmIhoRwcg==
X-Received: by 2002:a17:907:1107:b0:870:e329:5f2f with SMTP id qu7-20020a170907110700b00870e3295f2fmr7154150ejb.51.1674055281289;
        Wed, 18 Jan 2023 07:21:21 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906218a00b0073d796a1043sm14594830eju.123.2023.01.18.07.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:20 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 02/12] devlink: remove linecard reference counting
Date:   Wed, 18 Jan 2023 16:21:05 +0100
Message-Id: <20230118152115.1113149-3-jiri@resnulli.us>
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
index 32f0adc40c18..dd4e2c37cf07 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -193,7 +193,6 @@ struct devlink_linecard;
 
 struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
-void devlink_linecard_put(struct devlink_linecard *linecard);
 
 /* Rates */
 extern const struct devlink_gen_cmd devl_gen_rate_get;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6ba1baab80d3..c92bc04bc25c 100644
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
@@ -10266,7 +10256,6 @@ devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	}
 
 	list_add_tail(&linecard->list, &devlink->linecard_list);
-	refcount_set(&linecard->refcount, 1);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	return linecard;
 }
@@ -10282,7 +10271,8 @@ void devl_linecard_destroy(struct devlink_linecard *linecard)
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

