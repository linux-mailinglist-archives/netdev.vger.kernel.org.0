Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9504672133
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjARPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjARPXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:54 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393CA4859D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u19so84003890ejm.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpNdatRerecj0n8ypH1v/511GR4bTe0lvpgJSEFGqsE=;
        b=ghhkqrGCWLu1nYIsGVHNpmk+W1fm/FU4o/Ten1G77QtHlOoxmYqcLs3qPLGKSpTvSn
         Gj8W0SRkC4go0eKMdASzXneSotM49qH4nudakGUv70A/UbJnrKnMjx5ddBeERk2jeTNu
         WtBLwazn2pi6jF2glJ99V4gH5itI0Qt4HKhoFMI4GQJ4ja6TWeHK05JlOhrrSDtobMT3
         b+mpvKmGn+XcWrOarxVJL/Pckj4JykYdLGJa745VGb9+CMQo4cDQryawy0n/GIG+XPGE
         NVJb430iqKo0qohBZuJ7Uvi0cu8MUC1Nh4h+FOdKORPYe6ZS0BnGr6fMvs0oVCknNxiM
         PVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpNdatRerecj0n8ypH1v/511GR4bTe0lvpgJSEFGqsE=;
        b=N0d4IZQkqzXl98G72DDIz25fCwboQnDXTjB1yqkw4sxHBIGbcc/i7j4QIVux/cawwK
         8+6brY3aSk1p3HIAv4mLICcwKBXcu5olFP3WPHF1AjAiseysVobkonETW1MfTYQKevln
         R/i7NjsCBXVzfZnY6gcYlN77uvjpfUInP6bcyxekMfwHKcFRam83aTxr/5Y3b++Roy7s
         VStLQWOnBPhois5XT9/ySeQ9M8xfsvBSwKzSqAkRhyrXA4/2sBjZmagII65bEFiWB7mT
         Vze/FtwDaoNbDpjAppAc2eJAljK0NU4skiDkzZsvVOLcVRfd8nv3PzIavBDNEVvucTW/
         X2og==
X-Gm-Message-State: AFqh2kpDU/SzvtrLoZOIRBEe2yGbNxcrEf1KBVw332HJG5Y5bl8IlhqI
        SqZnX+sOG/XYyKnP7yS3QTZ9ueIn3dFlNpUE4HwjjQ==
X-Google-Smtp-Source: AMrXdXsSiTKIxMjbclQsL5lYqVXLqm1y6W6K73wL13iNhO1LVQ7el5fYSZE1SlKkrZuAD2/T7novEQ==
X-Received: by 2002:a17:907:20f6:b0:84d:21b2:735a with SMTP id rh22-20020a17090720f600b0084d21b2735amr7573325ejb.54.1674055298465;
        Wed, 18 Jan 2023 07:21:38 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906059100b007933047f923sm14806691ejn.118.2023.01.18.07.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 11/12] devlink: remove devlink_dump_for_each_instance_get() helper
Date:   Wed, 18 Jan 2023 16:21:14 +0100
Message-Id: <20230118152115.1113149-12-jiri@resnulli.us>
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

devlink_dump_for_each_instance_get() is currently called from
a single place in netlink.c. As there is no need to use
this helper anywhere else in the future, remove it and
call devlinks_xa_find_get() directly from while loop
in devlink_nl_instance_iter_dump(). Also remove redundant
idx clear on loop end as it is already done
in devlink_nl_instance_iter_dump().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2: new patch, unsquashed from the previous one
---
 net/devlink/devl_internal.h | 11 -----------
 net/devlink/netlink.c       |  5 ++++-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 10975e4ea2f4..75752f8c4a26 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -123,17 +123,6 @@ struct devlink_gen_cmd {
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
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index d4539c1aedea..3f44633af01c 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -207,7 +207,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 
 	cmd = devl_gen_cmds[info->op.cmd];
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
+	while ((devlink = devlinks_xa_find_get(sock_net(msg->sk),
+					       &state->instance))) {
 		devl_lock(devlink);
 
 		if (devl_is_registered(devlink))
@@ -221,6 +222,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 		if (err)
 			break;
 
+		state->instance++;
+
 		/* restart sub-object walk for the next instance */
 		state->idx = 0;
 	}
-- 
2.39.0

