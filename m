Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E965EBC98
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiI0IBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiI0IAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:00:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D53B0B36
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:49 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x18so13673641wrm.7
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4dPMWhRmVPQSB9Jj6g8AUp8OQc0k0NdxHflXHucvzWY=;
        b=zfvPUua/tqfRcQWkvDbPvRThHk60O+hsZgk6ahX55R8eyYf9GLw9kyPN1oDSNcZU7F
         BGfwkxzZRDepJ/+n6TLLOnaRckmZ1H6pSE2wXEKOx7NJ6BY9sYMtlvBVPfzhA+4E9tS1
         zRnOTRO1dEd5Fet6iduQunlS1cVH5hyBn4dY/x13etuhVkX/tY2zU6LhwbBsrnEa686u
         6DO3vwxL02cRNtU/C9OOzSJOWPvDi4Wi2ZqC6meQO9BcvbqgkZ+zO595hc6DrxpJfYET
         gKiVpPcwOuvaKOHU71AfXGAr7Njv+D5gYSrVhIaeHDyLIwabaR9CMWiXtLHOaNxCGgu5
         QRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4dPMWhRmVPQSB9Jj6g8AUp8OQc0k0NdxHflXHucvzWY=;
        b=XKG6BJD6sZ8cUIfdOdaRQjmM+eV1ohWWwHuqyTl2vX405SdTuxnyYbKkz7sq3JGsPo
         PA0rC/MzrgBEfFS2iAsE1Z5442KJGZx0YBCxWJF9Rm++H1nsfS6ReuKbnkLAplU4+yxo
         +rlfKgdIEhgC5jceklYwy+EcTH6phNuz2XIlSK32hLl/QTNrE1X/DgtG0M3oID26Qof8
         reEc8dG6K1tLek561ykkelh8kOAA5YpaqcfxOqEIouKT3mK7ANwPjztCr6/KX3is4Ad7
         3lrwdtFiAo6Vy3ga9yEaP8zfEElQW/nY9+6erAMCdI8nFJhS/ZZGoy9ByymVhXUpSTVb
         Fj7A==
X-Gm-Message-State: ACrzQf1r1gCcllmW3E7D418IXWgduamR5m21GR3PMwczSjDD+BwQubVX
        GxWnVvWTAyE48/N9xhH+h3HFk5ve1DjsrKJh
X-Google-Smtp-Source: AMsMyM41CVSb+InihPQYk6kJtycajjTVNDTDs51kG+Jr+UZJHW5Nr5Rvbz8aP5hwkw/WxiBjrR2W6g==
X-Received: by 2002:a05:6000:1541:b0:22a:3b77:6ef4 with SMTP id 1-20020a056000154100b0022a3b776ef4mr15733554wry.303.1664265408933;
        Tue, 27 Sep 2022 00:56:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d3-20020a5d4f83000000b0022cc157bf26sm531583wru.85.2022.09.27.00.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 1/7] net: devlink: introduce port registered assert helper and use it
Date:   Tue, 27 Sep 2022 09:56:39 +0200
Message-Id: <20220927075645.2874644-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220927075645.2874644-1-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
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

