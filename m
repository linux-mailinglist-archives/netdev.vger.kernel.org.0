Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D3057043C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiGKN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiGKN0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:26:16 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5675F45F4D
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p4so3054090wms.0
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fz3F1UTwnNLL198Xk4dkHDF/wp/3Gh7QQ7oUhOfA6FE=;
        b=cWmH0i8XhxyJp48GlYia/1UsbIm760XWjo8gNuPJJZer1BKvZMeozF8R5NyFH/lz2K
         BgiEALrTq1HcrcuLDbe/OIQhSMXebYy2xcEPWP0b/10nMXQ7+9SRBMAYEITb24XtCmoV
         RBReqNViVFb0XxywtK9v0SNiCkniLMBwzpzj32BlZb0QtJePIpEpHHAc6IIIeyUGNdbj
         Wb+4pxQvEOR9+4XGPrKqojmZRf5q2Vxirsm8T7LCBAxk+U2VrXSt3EEoQyejci5cKCK4
         SkUa5Zq0xuMTEcU5nWqdFuNzextDrK/R6oVzk5gv3+GPxRhrnUuh1eNPUjmU49DcUCLU
         dBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fz3F1UTwnNLL198Xk4dkHDF/wp/3Gh7QQ7oUhOfA6FE=;
        b=D9Rgw6sYzQoeBKt8OpG5hfbZQd0i/Q+SkiqIVyaKf4HDYZYyaG8pQBfWcitNqIxftV
         BfG3X4cuFkOavgcR+5COCUvm+uoUa5OALZ+bPvHibNtRnp+maMFXkHYy6YRB89Cx/MOJ
         MOWsm7IqwCUVKqpWJIw31jGJYP67d2MwmOQBwwo+q0oYmlmKhafT4bDYwKp4tP0YADJl
         k4YsUm2j3g5UHzT7pab88OTXyrDbN8h0Ued3SLtUK+mM4TXOdm/wop4VQP8QBGxVFNz2
         fTCBAgKNAfDP57abSGM4N35EzN7HBYwg+RoY5Tk1tUaSfMXd6GOUgMWBH7uZpGy/ux+Z
         G03A==
X-Gm-Message-State: AJIora/qFMedS1Kbieb7ONYK00AE6cVA2d7tcC2buR+0IxCaayfDJ8Ny
        OXPCkiy5CcrHG3N8rXUEywqHF5/L4fvevSiKvp8=
X-Google-Smtp-Source: AGRyM1tzh2yY4m8NxuelsKeInaKFhbjePUQpvnsoLu4WTgpGcKPa0XpycpRY8hGUNuiuCZhfN3OoMg==
X-Received: by 2002:a7b:c8d1:0:b0:3a2:e502:79c0 with SMTP id f17-20020a7bc8d1000000b003a2e50279c0mr9241389wml.196.1657545973914;
        Mon, 11 Jul 2022 06:26:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d500f000000b0021d905477dfsm5717587wrt.86.2022.07.11.06.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:26:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3/repost 3/3] net: devlink: move unlocked function prototypes alongside the locked ones
Date:   Mon, 11 Jul 2022 15:26:07 +0200
Message-Id: <20220711132607.2654337-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220711132607.2654337-1-jiri@resnulli.us>
References: <20220711132607.2654337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Maintain the same order as it is in devlink.c for function prototypes.
The most of the locked variants would very likely soon be removed
and the unlocked version would be the only one.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..be9d7a49a4c3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1521,15 +1521,6 @@ void devl_unlock(struct devlink *devlink);
 void devl_assert_locked(struct devlink *devlink);
 bool devl_lock_is_held(struct devlink *devlink);
 
-int devl_port_register(struct devlink *devlink,
-		       struct devlink_port *devlink_port,
-		       unsigned int port_index);
-void devl_port_unregister(struct devlink_port *devlink_port);
-
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
-void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
-void devl_rate_nodes_destroy(struct devlink *devlink);
-
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
@@ -1551,9 +1542,13 @@ void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+int devl_port_register(struct devlink *devlink,
+		       struct devlink_port *devlink_port,
+		       unsigned int port_index);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
+void devl_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
@@ -1569,8 +1564,11 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
+int devl_rate_leaf_create(struct devlink_port *port, void *priv);
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
+void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
+void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
-- 
2.35.3

