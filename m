Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A44AC758
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359713AbiBGR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbiBGRSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:39 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F23C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i186so14154071pfe.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZWsV/Q/92/ziNxuz2yNYUYJtM7LiQqqzaRRVAP5luY0=;
        b=MarH6reczKbc/XLSLlzrSd5OzTyWDR8nYgQ74vrSTzPE+hRL3B5i3ISrsJNqNfBVZb
         FZEv5GWtuxy3RTeXKd102LKkXLv0eTV6v/KmzdExhtH5j2uIxLpUWF/QbTIDJlcmlUJ2
         rsasuxNSbAc8prD/1OEsFvHGzu/Qt7w5IFkYF9rrPtonqs07FgsFiFOj/ThDmCsr66yD
         Rn9ux4/ElKhQgAzO0S5vsUgYGf284RVJpsSRbjC1ejdSlPtvCJKCtDPeSGO4V/HXsM2Q
         JS91gKdcwnqT6V/F/Vmhx6N25SpC+E5YBOArncbndzq4579UmFYC81+ZwuezT1xIbHvP
         ONmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZWsV/Q/92/ziNxuz2yNYUYJtM7LiQqqzaRRVAP5luY0=;
        b=PIGRtnB1ZZ07qXILIlvZpqh2vo99HTBJY9X+oE1fsSTLKDvwr3i9a7JG65eDIk1MRb
         g6sGLwBObMCP1V2JkmmDVplW0RDBoMNezTEzh4T2axdq9gKTKT4lpaSX/RiCkxTpN/8c
         +WvvSAOHE/J+5TMf3IZEtfuTOrE+uaEuo82d56QCtvH9N8x9vK6XL/CKO2NfyRjB2x7k
         yAAmHRzWYRepnbS/L0K5mq8KmsK8oZYwOGsEGPBgEAi5MlO0MAM+wq/RCaV5HPZUnmse
         pGHDRmL+cq3FN4uIcDBaf+rZAPjBNPbVEDNS6EzId2bnADN8su6i++G4lTlmpf8Yj4FN
         lB5A==
X-Gm-Message-State: AOAM533JielXdK2mlxwwbrSO8FVSmJ4s6OMTmSqY8YeZLhW1ih/Xaiu2
        SuTxyrTFxDz1sOk3AIkZyuQ=
X-Google-Smtp-Source: ABdhPJy5H4QWWzqwskoPRt17RU7L8CGFN9skqT+K3ztM0ALx2hv7Tw1OATHuUjOhy278DZ1Clt9SQQ==
X-Received: by 2002:a63:e84f:: with SMTP id a15mr311846pgk.191.1644254315545;
        Mon, 07 Feb 2022 09:18:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 11/11] net: remove default_device_exit()
Date:   Mon,  7 Feb 2022 09:17:56 -0800
Message-Id: <20220207171756.1304544-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
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

