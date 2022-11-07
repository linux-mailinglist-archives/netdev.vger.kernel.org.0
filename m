Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EEF61F6A1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiKGOw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKGOwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:52:24 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F065E1D0DE
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:52:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s12so8341823edd.5
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 06:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+V9Oj6Uilbq6QzM+r6L8LRZuE9a39ix8mwBwCYQnZY=;
        b=euhBabbw0WgFg7NAshgDwcOwdJIdxF/HSOZq+AMVJvs0JMExmdlgQWg69WEvrArfKy
         x8ztxrOnGiwsWgARfDZVOGO9X5j2qxngoqJxjYYkPMOxQOD5LfmpCi/2az+g7zPYQhw2
         aE4/VFy5pMA2+c/NsbGRuUim9zFJ15MxSDd8RYSoClywlppEMHtPAk8Y2XeTx5pTsvrC
         gc2X4BqGEFi/DL+ZcvZxy+QY6k2gJOoSs9OG3E04FFKPn/hC4ott55cHnp0so9A3Rxx/
         7ANj9QOta7cWt7RSuYy3yAhUFN96CbBSuUwn39KN0g9AK4bL8ZyNmT7jEVzc3NrgR/r9
         WyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+V9Oj6Uilbq6QzM+r6L8LRZuE9a39ix8mwBwCYQnZY=;
        b=MFX+Ig2w56zGk+Aj59SFW5iHCovy7SztwqSQLxeMP0TG7hiYqcKAW3Q3rxq9egTPhs
         XTlB3D4UvAUVKa41H5E7IVziJk8LbB98WmukwKJOKr29ico5fId+mO6P1mQv+NzBa2mV
         9woUH0Y9UiP9q1fJFghPc4x7vaHIFIwdfP9GcqGD+1xq5fsgKbVaP5nI3VmOicq991+P
         HAjHSzC3cckIq71bpdQX4kHbIlZa8/jN/5QAvZ6Fu2ABdv2cg4kPS0HepLebiR7LDPbv
         QbGAqvwV/65JdqjttwK3aMAiL3ROho/VUNGtnWLK3DRpzJ27v9d64Xv145vRyWu1HzOO
         qwcQ==
X-Gm-Message-State: ACrzQf3weDvlLCgnXM9q07XKwTLQFsMjABN4t012LfRbjb24VLPyi9Zf
        /FBXGwVCZzgWjPWrxLfY3UhnBZ/SU7QpAHD2wLE=
X-Google-Smtp-Source: AMsMyM6OayQVtLCX2aSsOG00BxXiEGmIsK3FFm4zS3aR6k9LhkCAT+k2iAcSCdMxPMYbBPZjBbZYug==
X-Received: by 2002:a50:85ca:0:b0:461:168c:83ab with SMTP id q10-20020a5085ca000000b00461168c83abmr50974210edh.359.1667832737524;
        Mon, 07 Nov 2022 06:52:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w23-20020aa7dcd7000000b00443d657d8a4sm4277665edu.61.2022.11.07.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:52:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next 1/2] net: introduce a helper to move notifier block to different namespace
Date:   Mon,  7 Nov 2022 15:52:12 +0100
Message-Id: <20221107145213.913178-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107145213.913178-1-jiri@resnulli.us>
References: <20221107145213.913178-1-jiri@resnulli.us>
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

Currently, net_dev() netdev notifier variant follows the netdev with
per-net notifier from namespace to namespace. This is implemented
by move_netdevice_notifiers_dev_net() helper.

For devlink it is needed to re-register per-net notifier during
devlink reload. Introduce a new helper called
move_netdevice_notifier_net() and share the unregister/register code
with existing move_netdevice_notifiers_dev_net() helper.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d45713a06568..6be93b59cfea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2828,6 +2828,8 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
+void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
+				 struct notifier_block *nb);
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3bacee3bee78..762d7255065d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1876,6 +1876,22 @@ int unregister_netdevice_notifier_net(struct net *net,
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier_net);
 
+void __move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
+				   struct notifier_block *nb)
+{
+	__unregister_netdevice_notifier_net(src_net, nb);
+	__register_netdevice_notifier_net(dst_net, nb, true);
+}
+
+void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
+				 struct notifier_block *nb)
+{
+	rtnl_lock();
+	__move_netdevice_notifier_net(src_net, dst_net, nb);
+	rtnl_unlock();
+}
+EXPORT_SYMBOL(move_netdevice_notifier_net);
+
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn)
@@ -1912,10 +1928,8 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
 {
 	struct netdev_net_notifier *nn;
 
-	list_for_each_entry(nn, &dev->net_notifier_list, list) {
-		__unregister_netdevice_notifier_net(dev_net(dev), nn->nb);
-		__register_netdevice_notifier_net(net, nn->nb, true);
-	}
+	list_for_each_entry(nn, &dev->net_notifier_list, list)
+		__move_netdevice_notifier_net(dev_net(dev), net, nn->nb);
 }
 
 /**
-- 
2.37.3

