Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5B5EEEF9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiI2H3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiI2H3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24041133CA3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:07 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v28so761272wrd.3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4dPMWhRmVPQSB9Jj6g8AUp8OQc0k0NdxHflXHucvzWY=;
        b=BRDELzk+x/f+hO9X05Gf0kRVvX17dR6l5BforSD1pc8MeLg86H88T2/0mWzISrgMWh
         HQgLd27fQFo3pQ458sen8Wy2420sk1PPqsN7O6AR4tNWNAdmYxyud0s53SOmHckzhZht
         9luJVPlfgkDxbxTdx1rsQdHIu+e81OVKMAJq0aSQhiUND03Db6dkw9dmt3wLhSKTvbPP
         y6xrKEyLeiLJniogpZ5kWwRdgqvnJ3RcdWvMaAveXb9X0dDBTI3rKQocS/PL1zR7HeKS
         5IJvZ24YO6HwMi7upDHq0HS4CeaViab0fKPU7Ri4LLTdmM21rsh1lkXJFcAzHnRGce1n
         mLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4dPMWhRmVPQSB9Jj6g8AUp8OQc0k0NdxHflXHucvzWY=;
        b=RpRx7t+ryhIwVQHUAu0ek1mTe0BdQ2H7AfmCPhvl335B19PLm/6TLaiutaMN9agNEK
         6xQtYQo0/2kGVranCI4EXaEcdNxfCiZozp2lVgJ5FfKwZUENcpSGtZl9hzkS+WWk0evy
         QwhWpuVgXVdHCIJ76uANyUeffBE71nEmMrHPONIycKx+iNq18kR5z3HlYLVEVKECd+rD
         g3Y+EBahTAqP2QaRTx1SaFp7OTeby0freXYdcNPf0WVhwYq5aDk2VvjXHePDkyFpQfNx
         VjAO7O0trOwLqjfyPdmuNwz30c/zP9qbTwr2GY8dIH2S6pNJ7ostV5apQe6NWlil8rps
         OfYA==
X-Gm-Message-State: ACrzQf3CBcTu9lMmlw8OERJGDNl33toLVxJICuCakmG1FjIyIyYa7Pvd
        JfK5ouu/LIZwERYzbb1vOHU65UKLgFuOR9ke
X-Google-Smtp-Source: AMsMyM713KtE1MTrGtjm04mX7GqX2tnQquL4wFpvw0vHCfTs81OsgUPhDA0EVkslLUmMFfQbaipGDA==
X-Received: by 2002:a05:6000:2c8:b0:22a:efdf:ecc0 with SMTP id o8-20020a05600002c800b0022aefdfecc0mr1145192wry.57.1664436545576;
        Thu, 29 Sep 2022 00:29:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e6-20020a05600c4b8600b003b482fbd93bsm3439030wmp.24.2022.09.29.00.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 1/7] net: devlink: introduce port registered assert helper and use it
Date:   Thu, 29 Sep 2022 09:28:56 +0200
Message-Id: <20220929072902.2986539-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
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

Instead of checking devlink_port->devlink pointer for not being NULL
which indicates that devlink port is registered, put this check to new
pair of helpers similar to what we have for devlink and use them in
other functions.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7776dc82f88d..f5bfbdb0301e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -371,6 +371,11 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	return ERR_PTR(-ENODEV);
 }
 
+#define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
+	WARN_ON_ONCE(!(devlink_port)->devlink)
+#define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
+	WARN_ON_ONCE((devlink_port)->devlink)
+
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
 {
@@ -9869,7 +9874,8 @@ int devl_port_register(struct devlink *devlink,
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
 
-	WARN_ON(devlink_port->devlink);
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9952,8 +9958,8 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
 				    void *type_dev)
 {
-	if (WARN_ON(!devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
@@ -10072,8 +10078,8 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 {
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->attrs = *attrs;
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
@@ -10096,8 +10102,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
@@ -10123,8 +10129,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
@@ -10151,8 +10157,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_SF);
 	if (ret)
@@ -10267,8 +10273,8 @@ EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard)
 {
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->linecard = linecard;
 }
 EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
-- 
2.37.1

