Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC961251158
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 07:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgHYFIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 01:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgHYFIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 01:08:31 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E8C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:31 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x69so9923489qkb.1
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FI2UnJ/X8NvGHm8mLmPd1GT0d0e6cisliRlUJ+8A4vY=;
        b=qPeKIRW97sYAD/VNMp84ep48tVT5/GDf3JNg77jCOou/t0QAO2Pcbl3iT7WSyBqJKv
         GGXbgb29IVk8P/M++pnaNqtChcp3Nf1sK5L6DFWeF7T7b4R+OXWHSgwIOTcGd0WvUHQc
         JTFhIrtfsZxzkhCNKPh2zOt8AG/p9KUS0TZJ7xJKwcT8ewl836doEIHjfcke1Qjp8lVC
         58BKpr0u55tit2v8pfGT2rwh4UkmQVh33dpm/dl7aDw1ovpjRl5DK2PAKQAST3JyLa2A
         aERG4P98u39m9eJBqLRD85dg2JjY6cfwHp3yVYByYItsuywaNV6GiR9lQtFyNCOZrgU5
         tNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FI2UnJ/X8NvGHm8mLmPd1GT0d0e6cisliRlUJ+8A4vY=;
        b=d41zVkOSVxzLy2Xxh1cOwuWIP8DI7IDfJpTipX1R0SHNLYpumhp5EnQVQupBsl36Rn
         s7fH3YcZlvDapbgea2FhQzp+SyM1UzxHoLkz+0+NDV4y3iUkC7paadD4P7N7k0XkqIFN
         EsocsH/Xj/EJJgI7TFVEQ2FAyZH+zM+VdYsexhTEDznRP5wDI9KYkdJ0SpiaxMQ582Yo
         vUdmmwuvcKfnS/Jpkp283gUTOD58wAUm3qMcQT92AQr6tMGxd0drmpR1coHR6wacRZ6g
         iDV9c7+XznsVGQg3MvzmK3kR11uIFWb/VlP40JLwKubIiqFUZFrnXqMuj0x42a0AKWtf
         nEGg==
X-Gm-Message-State: AOAM532B6TuKe6ML/qqki7uGelAnqGqyd6Q/mYwxbAMW8n6VFEvYi1zf
        NKnxJdI+KJ0YWh/619dALTo=
X-Google-Smtp-Source: ABdhPJxma5fhsBsSCkmGonPWIOj/Y8QWyc4BYBe27ChRgtNVyljC0RSI2tBmeDCI42yOmWbkiKdySg==
X-Received: by 2002:ae9:e507:: with SMTP id w7mr7660279qkf.264.1598332110601;
        Mon, 24 Aug 2020 22:08:30 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 16sm7261723qkv.34.2020.08.24.22.08.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 22:08:30 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 3/3] net: openvswitch: remove unnused keep_flows
Date:   Tue, 25 Aug 2020 13:06:36 +0800
Message-Id: <20200825050636.14153-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

keep_flows was introduced by [1], which used as flag to delete flows or not.
When rehashing or expanding the table instance, we will not flush the flows.
Now don't use it anymore, remove it.

[1] - https://github.com/openvswitch/ovs/commit/acd051f1761569205827dc9b037e15568a8d59f8
Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 6 ------
 net/openvswitch/flow_table.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 98dad1c5f9d9..d8545ae38e4e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -166,7 +166,6 @@ static struct table_instance *table_instance_alloc(int new_size)
 
 	ti->n_buckets = new_size;
 	ti->node_ver = 0;
-	ti->keep_flows = false;
 	get_random_bytes(&ti->hash_seed, sizeof(u32));
 
 	return ti;
@@ -479,9 +478,6 @@ void table_instance_flow_flush(struct flow_table *table,
 {
 	int i;
 
-	if (ti->keep_flows)
-		return;
-
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
@@ -601,8 +597,6 @@ static void flow_table_copy_flows(struct table_instance *old,
 						 lockdep_ovsl_is_held())
 				table_instance_insert(new, flow);
 	}
-
-	old->keep_flows = true;
 }
 
 static struct table_instance *table_instance_rehash(struct table_instance *ti,
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 6e7d4ac59353..d8fb7a3a3dfd 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -53,7 +53,6 @@ struct table_instance {
 	struct rcu_head rcu;
 	int node_ver;
 	u32 hash_seed;
-	bool keep_flows;
 };
 
 struct flow_table {
-- 
2.23.0

