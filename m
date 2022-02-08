Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1ED4AD0E2
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347289AbiBHFc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347053AbiBHEv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:29 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A3AC0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i17so16800364pfq.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W9SJ+JIzO4YpVyuc5zFzbPz+F4qocdc922RikmWgzPc=;
        b=f7NKvLmzXK26V3rNDS+bqdDoQE7dqy8zfhDrHxxUS1KMht8VfKAYh7n2rI2xV4Yr3m
         4X/UjQfHaxsnc8r1FLM0anXliRogUTXm8/H7UB/8SJW8S0KedSQW5RizHBQAMeBjCzH2
         ZswftST/LDPR2nUVPno42fGXTP2Arq0/ZvEjFIrz+brpXDk3TPq6xVghr4XtjK2Z1ZML
         mzCMeG9NcohE1gK5DcqletIW0VmKZ6BkGivoQCkpbtwUftvfezp+K0SxRHHGRtaHgWVm
         tnFgVBctuGIHwfey1CiMvGq+TcQdJdJmkvk6q+OKLA6mulhFcucEKUXJO1wiwV3v0x2C
         D/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W9SJ+JIzO4YpVyuc5zFzbPz+F4qocdc922RikmWgzPc=;
        b=OHU8+UzKIyx3iR6ZnKmDk1GxHTG9gIWxsJRadHavHFrPdi64mwkIxEhBSnUfW67poM
         fRCB6gbgwSZyuCe9wSdkcbjLp5iMrPiWPCk6J2708qAvsPqWN2bqVM192QrP2g+Dbg73
         A348cR2rSZ96NFlI+Kie2OXa7/24KsgIomu/4LKNazpAcfN6FDf2CndX1vskzXmvfADo
         8mK39HKyvAtvTZ4Kd9ZwAzcTEzC78dMudY30cdl6tEEcFI9pbj4JZb9NFkST/O3kbHN0
         Txog/iJnWsWThHwabLTo2x2vnS4Lxpjp1iE2T98rtqpQiP5qmX9kOXFOSJs1EwPi9JdI
         vLYQ==
X-Gm-Message-State: AOAM5323nE7BTa+rkciN2zoMfS9GP7DDF7lf22RzgF7NuNFxM0QrUWK6
        A39/cm+bfAeqWrjTXUbRW9TK1eNz4Ho=
X-Google-Smtp-Source: ABdhPJycInHtNDnnLFZUw4wpjRnSeni4sBjbMiMCOLPiAkznQmDS7/E0sUM3vLUwzPFvZGqVFpZTlA==
X-Received: by 2002:a05:6a00:cd2:: with SMTP id b18mr2640350pfv.63.1644295888060;
        Mon, 07 Feb 2022 20:51:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 11/11] net: remove default_device_exit()
Date:   Mon,  7 Feb 2022 20:50:38 -0800
Message-Id: <20220208045038.2635826-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For some reason default_device_ops kept two exit method:

1) default_device_exit() is called for each netns being dismantled in
a cleanup_net() round. This acquires rtnl for each invocation.

2) default_device_exit_batch() is called once with the list of all netns
int the batch, allowing for a single rtnl invocation.

Get rid of the .exit() method to handle the logic from
default_device_exit_batch(), to decrease the number of rtnl acquisition
to one.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/core/dev.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f662c6a7d7b49b836a05efc74aeffc7fc9e4e147..e39c2897f6475dfa77c478603cfced76ba0b9078 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10848,14 +10848,14 @@ static struct pernet_operations __net_initdata netdev_net_ops = {
 	.exit = netdev_exit,
 };
 
-static void __net_exit default_device_exit(struct net *net)
+static void __net_exit default_device_exit_net(struct net *net)
 {
 	struct net_device *dev, *aux;
 	/*
 	 * Push all migratable network devices back to the
 	 * initial network namespace
 	 */
-	rtnl_lock();
+	ASSERT_RTNL();
 	for_each_netdev_safe(net, dev, aux) {
 		int err;
 		char fb_name[IFNAMSIZ];
@@ -10879,22 +10879,22 @@ static void __net_exit default_device_exit(struct net *net)
 			BUG();
 		}
 	}
-	rtnl_unlock();
 }
 
 static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 {
-	/* Return with the rtnl_lock held when there are no network
+	/* Return (with the rtnl_lock held) when there are no network
 	 * devices unregistering in any network namespace in net_list.
 	 */
-	struct net *net;
-	bool unregistering;
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	bool unregistering;
+	struct net *net;
 
+	ASSERT_RTNL();
 	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
 		unregistering = false;
-		rtnl_lock();
+
 		list_for_each_entry(net, net_list, exit_list) {
 			if (net->dev_unreg_count > 0) {
 				unregistering = true;
@@ -10906,6 +10906,7 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 		__rtnl_unlock();
 
 		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+		rtnl_lock();
 	}
 	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
@@ -10921,6 +10922,11 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 	struct net *net;
 	LIST_HEAD(dev_kill_list);
 
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list) {
+		default_device_exit_net(net);
+		cond_resched();
+	}
 	/* To prevent network device cleanup code from dereferencing
 	 * loopback devices or network devices that have been freed
 	 * wait here for all pending unregistrations to complete,
@@ -10933,6 +10939,7 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 	 * default_device_exit_batch.
 	 */
 	rtnl_lock_unregistering(net_list);
+
 	list_for_each_entry(net, net_list, exit_list) {
 		for_each_netdev_reverse(net, dev) {
 			if (dev->rtnl_link_ops && dev->rtnl_link_ops->dellink)
@@ -10946,7 +10953,6 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 }
 
 static struct pernet_operations __net_initdata default_device_ops = {
-	.exit = default_device_exit,
 	.exit_batch = default_device_exit_batch,
 };
 
-- 
2.35.0.263.gb82422642f-goog

