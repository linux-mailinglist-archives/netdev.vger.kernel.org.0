Return-Path: <netdev+bounces-1107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8166FC37E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78E111C20B0D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41840DDC0;
	Tue,  9 May 2023 10:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295BC8C06
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:09:46 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69304220
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:09:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bc070c557so10995605a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683626983; x=1686218983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVe674onQtEz3qbu2N4u6BX4TBUgejmmQjMq+AzzZ/k=;
        b=M3f+mORhEM8p09rt4hFAxwpgOL4ByomsEryKSr6sxGJ+sf+1zySFaiW5LVCfHHWkab
         XDkp0Sn2wUI/gr8ttKzF4/23T67uCD1eoabH7gsChDJLiDoMSlqu9NakdwpJFHsyPoSL
         qELuCisdPh4RdX434ZA4XLflba70dAQ/bhX5/WK1dBPWtariJz3s+rNbK2Amr60DBOmG
         Av4XihkuD+xLw+y/eeiO4COH8/Sj9+wGhHatLRg6L6XZ9zsdXxQkq9NkqqH1lZpHAAcj
         ZOjDJnXLEpk73+4UdSW5c699XMvcPbirdyS9LPich28xBKycfn88iyI2RBtIRjguDgt9
         D1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626983; x=1686218983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVe674onQtEz3qbu2N4u6BX4TBUgejmmQjMq+AzzZ/k=;
        b=WOY10XEsiKYBq/6cQOTpWBItZE0+eIeE2uGsefUTq0BE0d4bRymEj5VWpuuIIMgQHH
         hAb8p1IttPOy1n3B+g7zvjWls40CNIU+zqXAuz2hctsR5UXXU2h0cm5HY1eQeL1w4fGF
         fVMsCx7AiqMzkMofIMMGptZmRjzV86AHT5cW1ynO5sUvFzSC5vsutHG6hAxbjMnd1YL4
         a0wcrqzqGYdzhE+kqHdaFqhJNnvv7DwuAwfxQel4AK7c5jVFJcFkizqSlvJlR68Yi/qC
         XtcGDHdgGtv+SEDsbe2CqX2f+D4zm9b/QO/PPUMxk8S4x8Wr1FJcxYo4ei38xREWmmPK
         AIVA==
X-Gm-Message-State: AC+VfDy3f58GLNpJTGIp4NDEAFteKdoL1mMFcP3EepuHK3pcYgudVT2Y
	mg9tKD8XfDnrTmwLdTwnsP47YXZ865ozA+fgvDMyiw==
X-Google-Smtp-Source: ACHHUZ7JiWw+L0HfasjzeJhukL9hJQfdq/ClDYKBZrGWwix0rQFCDZ51doPaW6qL2lHJVJQwF9F0KA==
X-Received: by 2002:a17:907:7e8f:b0:969:e7da:fcb1 with SMTP id qb15-20020a1709077e8f00b00969e7dafcb1mr1940463ejc.13.1683626983065;
        Tue, 09 May 2023 03:09:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id jy11-20020a170907762b00b0094f3b18044bsm1111775ejc.218.2023.05.09.03.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:09:42 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	jacob.e.keller@intel.com,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net 1/3] net: allow to ask per-net netdevice notifier to follow netdev dynamically
Date: Tue,  9 May 2023 12:09:37 +0200
Message-Id: <20230509100939.760867-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509100939.760867-1-jiri@resnulli.us>
References: <20230509100939.760867-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

Currently, it is possible to register netdev notifier to get only
events related to a selected namespace. This could be done by:
register_netdevice_notifier_net()

Another extension which currently exists is to register netdev notifier
that receives events related to a namespace, where a netdev is. The
notifier moves from namespace to namespace with the selected netdev.
This could be done by:
register_netdevice_notifier_dev_net()

Devlink has a usecase to monitor a namespace and whenever certain netdev
appears in this namespace, it needs to get notifications even in case
netdev moves to a different namespace. It's basically a combination of
the two described above.

Introduce a pair of functions netdev_net_notifier_follow() and
netdev_net_notifier_unfollow() to be called on previously registered
per-net notifier asking to follow the given netdev.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/linux/netdevice.h |  6 ++++++
 net/core/dev.c            | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..63376dad8464 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2890,6 +2890,12 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
+void netdev_net_notifier_follow(struct net_device *dev,
+				struct notifier_block *nb,
+				struct netdev_net_notifier *nn);
+void netdev_net_notifier_unfollow(struct net_device *dev,
+				  struct netdev_net_notifier *nn,
+				  struct net *net);
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn);
diff --git a/net/core/dev.c b/net/core/dev.c
index 735096d42c1d..3458ed8f98f2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1868,6 +1868,32 @@ static void __move_netdevice_notifier_net(struct net *src_net,
 	__register_netdevice_notifier_net(dst_net, nb, true);
 }
 
+void netdev_net_notifier_follow(struct net_device *dev,
+				struct notifier_block *nb,
+				struct netdev_net_notifier *nn)
+{
+	ASSERT_RTNL();
+	nn->nb = nb;
+	list_add(&nn->list, &dev->net_notifier_list);
+}
+EXPORT_SYMBOL(netdev_net_notifier_follow);
+
+static void __netdev_net_notifier_unfollow(struct netdev_net_notifier *nn)
+{
+	list_del(&nn->list);
+}
+
+void netdev_net_notifier_unfollow(struct net_device *dev,
+				  struct netdev_net_notifier *nn,
+				  struct net *net)
+{
+	ASSERT_RTNL();
+	__netdev_net_notifier_unfollow(nn);
+	if (!net_eq(dev_net(dev), net))
+		__move_netdevice_notifier_net(dev_net(dev), net, nn->nb);
+}
+EXPORT_SYMBOL(netdev_net_notifier_unfollow);
+
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn)
@@ -1876,10 +1902,8 @@ int register_netdevice_notifier_dev_net(struct net_device *dev,
 
 	rtnl_lock();
 	err = __register_netdevice_notifier_net(dev_net(dev), nb, false);
-	if (!err) {
-		nn->nb = nb;
-		list_add(&nn->list, &dev->net_notifier_list);
-	}
+	if (!err)
+		netdev_net_notifier_follow(dev, nb, nn);
 	rtnl_unlock();
 	return err;
 }
@@ -1892,7 +1916,7 @@ int unregister_netdevice_notifier_dev_net(struct net_device *dev,
 	int err;
 
 	rtnl_lock();
-	list_del(&nn->list);
+	__netdev_net_notifier_unfollow(nn);
 	err = __unregister_netdevice_notifier_net(dev_net(dev), nb);
 	rtnl_unlock();
 	return err;
-- 
2.39.2


