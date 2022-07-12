Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C46571740
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGLKYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiGLKYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:24:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FD9ADD7E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:33 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k30so9500619edk.8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LRZpzzCnezxiVFDsIv5Ug+IvCUbPzwujTnmZf+fNANY=;
        b=oKKdpLOiFp0r/7SMO3ZEX6R3KwPqz9RgkIx+/e5s1FwMzAVv0dSV3U4okV4ma6Az8Y
         R1BzhlIffZ+rfweNZtbyg9t0Y+1zZ7ev8mrUztV6UbkKooeNMVae4wSv4v/ZuWq33jtF
         NjxnW4kD3HOQbiw9hFgXJY5PIoMmiF7jJS5/GFipbo6o8C1vbh+9D9adZGN9JJEvAmK0
         ufSxo7uFsb25L7FiwVozkNGWMs3CHXG0HXJ0Yw0CvurEj1i2yRWQPVVB+Mlr4IMKIOD0
         HNLbSdlzNTQ3hD6WiFQfTJpik3lbZNNLLNS/za71VN1JnHZWDUi9hYzLPc6rgQ70LBm7
         411Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LRZpzzCnezxiVFDsIv5Ug+IvCUbPzwujTnmZf+fNANY=;
        b=QfihaVwrcCqf6889Vv8RhJUlQpVtVjlJmjP0jBjiC6+b3FSNh+8NZhdVrf3AIZxfxy
         4sl7Dkchn2V6UzXvnQboCzRL8/U9NPtBITrJWgYcynJttu6nTDyUz2Ho6y7UDXBl8zQO
         f64h2hniB0XzBk9Y2gn+XNEjMAe5wrJ8ijDdqC1X9fXEP1UrkbLZAQ2SBO/RdhLrx0YK
         7Bt1yJl+ReeizDTrUOLfyOx5RY6xNvxPQLb0umBn0ZuuDdCPwLfXJsCXKGi0bD3roVo5
         M2SNHXqFbk1keTdVKL9NQCERufJi6YU21qgWh4mwWJNuTPzIADSAEGC72Y/I0LVSD+xU
         hsCg==
X-Gm-Message-State: AJIora9KgezdDccgvXgMWgX3N/yVj4zHsNnE5uWi+ppkzHsoA+iuqLAY
        vL7ZAhCX1eJeuf/YWWaSZTOeqHWhamen+BE8L6o=
X-Google-Smtp-Source: AGRyM1vFikqI8Ej4WtjzI3lyozLn6WwIdbxaEm9tRlZ6T9yBoQlwJrFhm0zlL445jb5Sbcoi2eSfFw==
X-Received: by 2002:a05:6402:1e95:b0:437:ce7f:e17a with SMTP id f21-20020a0564021e9500b00437ce7fe17amr30386872edf.169.1657621472121;
        Tue, 12 Jul 2022 03:24:32 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ga31-20020a1709070c1f00b0072b0d0511e3sm3609434ejc.28.2022.07.12.03.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:24:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v4 3/3] net: devlink: move unlocked function prototypes alongside the locked ones
Date:   Tue, 12 Jul 2022 12:24:24 +0200
Message-Id: <20220712102424.2774011-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712102424.2774011-1-jiri@resnulli.us>
References: <20220712102424.2774011-1-jiri@resnulli.us>
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
index 5150deb67fab..b1b5c19a8316 100644
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
@@ -1569,6 +1564,9 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
+int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
+void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
 struct devlink_linecard *
-- 
2.35.3

