Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E61C563826
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiGAQkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiGAQkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:40:14 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462927FF5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:40:12 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v14so4014619wra.5
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=6vgzevYN/hmvW8PZvTzUN/LdS6FMZS0iz0yw3fN9i3DARO5sC3d2QrSd0FOMlnq21R
         TJMdPiTnZ0vZrHZmjrZQQuI/vnNtjoB2svzXlh4gHAmqZUW902DA3MrcwlAweugBDtCH
         jVJCaPHIg7NzMXaqYoqRCnXnQaNUslkCgl28rejGaPnfa+RwuneBhyg4i/Cv6oHjJ6bM
         rMq1jIek1WjKiOUGz1fG20l/mqFSGdSFjPXCm4Gvj80bCcfweYxcHBQw6FTQTCgV4IoW
         U2laSdVwM0ImKyUnRxWPE0vbUFN/FraUEYecYC5SgMLyobiW9aIp4a8JHnq1jId9jJyy
         zNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=y8LnY0cWwZ+S1kG92vTxaaWOZNjSq26nKVyckb/6OEu35P5aD3Aq/PGqT7IsLHqvYF
         ehdpo8oTGJIL0SR7fS0tJ8PCKcD4TUZ9teBbgctVfxrd053LwLWvBICIt4xSMhwDeJ+x
         YaiOrNbWmuqEazS3V0MJTGSmNosqz107JOnTAeYeAC4QTQT5GeRQypKo6dAq9Hj2uLak
         fpv1dr15aXdotQasGvCM2y0wHoSiMP7+7T7u6P1ZG1H3/Ob/3Zfghk/TF0ek2SlR6ii7
         RQ8RU6VUl1GwqYYZm2qn4l68f0dEmywm/3kXo9BtBvyRRIfL9Ssf5qV74dBUS5yqMZUD
         /1YA==
X-Gm-Message-State: AJIora9yEBk9qNq9IiaVCW++3FnGV98fr0bfY1lP2InFkynCuOmpyo5h
        MUnLkyvy/5ojWdugsbqmbxM8pmXoxoajMF6P
X-Google-Smtp-Source: AGRyM1sgBhI0Nfy0KbXIZh+viHPvbMFVSD0/uz48PDQKDZ0+342GkOaUWhNa91bLAQpeIfinWB+DTA==
X-Received: by 2002:adf:e3cb:0:b0:21b:8de5:ec7d with SMTP id k11-20020adfe3cb000000b0021b8de5ec7dmr14746898wrm.714.1656693611023;
        Fri, 01 Jul 2022 09:40:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ba15-20020a0560001c0f00b0021bae66362esm19744442wrb.58.2022.07.01.09.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:40:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v2 1/3] net: devlink: move unlocked function prototypes alongside the locked ones
Date:   Fri,  1 Jul 2022 18:40:05 +0200
Message-Id: <20220701164007.1243684-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701164007.1243684-1-jiri@resnulli.us>
References: <20220701164007.1243684-1-jiri@resnulli.us>
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
---
 include/net/devlink.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b8f54a8e9c82..edbfe6daa3b5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1520,15 +1520,6 @@ void devl_unlock(struct devlink *devlink);
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
@@ -1550,9 +1541,13 @@ void devlink_set_features(struct devlink *devlink, u64 features);
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
@@ -1568,8 +1563,11 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
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

