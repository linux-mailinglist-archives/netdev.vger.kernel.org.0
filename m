Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF891B4B56
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDVRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:10:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B42BC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q18so1395497pgm.11
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oo9uRPEJUdv9A686Mk0RlNJ/U+paXqfIsy50MEEAT+M=;
        b=rbBPKd52m0e7tEmgPkUzYuVIA2peJrYC+T+kgW1GuP7Psr8uoeQXq3+CjivO8a9DJr
         ouTBpo+j9U9+++S6tpQGlEG+L6V8DquHuI2l8hbJEJQDzMmpGn0GkaYsjXjEYq7zwma3
         qc2iriDd1mufINKo3EY/qvC1c9krjXjOwfOMRDIuNOu0V4PuYxOfbqgfaKXkw/PZSK3C
         favU/r+LJlOr3J+a6q7TbKQaHFBgZN2m4fweJLigck7dMzRJ7UwL7Jud+rBNsmk9//14
         40WuHuzMYfC/ZOv7mONjfX8aHCsk2LnGF5+eL01/2bir/FoKDmLHtLI8WWh0eMfdPmWR
         S39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oo9uRPEJUdv9A686Mk0RlNJ/U+paXqfIsy50MEEAT+M=;
        b=KjV0GtSGzL2VH0JgiSKCmcI5EUpL/Y/rMv9SjhfWAUjvE1NG8cHRv9DZxst4YGKIAa
         jSM+tz+IpfWa/MLTZ3zdekxCJ+qYU25AenImasO+0oo8tv1uoarkBF45H2LyS3Tphz93
         It0a4WUXEgGzk73kWRpg/R0ykWKBnDz9E2IZBdtt1zERNeZe2LZDd4Mfh6Q+PUoGeQ1F
         zjsk+hyBgKnpiQjIzb9o3eu8suaBJg1+BbYXILmvw4iQw5qWVCx1oWjDv0Cd29p310D+
         nhQCKjETIHq6izzZiwZ1Tmb5l+JFY1+Owj58Tpu2QORl0n/F6gEcSYqzBPP8g9UrKYMa
         PnmQ==
X-Gm-Message-State: AGi0PuYN/N3oHLFFnx6BbhyPQo3SLK0rbXvDHQbdLrYcHKG1YnR5OHdw
        SQVMQo79jzEb7BR+M95LzAA=
X-Google-Smtp-Source: APiQypKkss9lFz8HpfCP/cYg+TF4jsXxDydzIxdMtJ4K2d+F1h8097BrC1Vgh4a59PgsZ1XmkwjsQg==
X-Received: by 2002:a63:5645:: with SMTP id g5mr59272pgm.268.1587575423079;
        Wed, 22 Apr 2020 10:10:23 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id n16sm28549pfq.61.2020.04.22.10.10.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:10:22 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 2/5] net: openvswitch: set max limitation to meters
Date:   Thu, 23 Apr 2020 01:08:57 +0800
Message-Id: <1587575340-6790-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Don't allow user to create meter unlimitedly, which may cause
to consume a large amount of kernel memory. The max number
supported is decided by physical memory and 20K meters as default.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 57 +++++++++++++++++++++++++++++++++--------
 net/openvswitch/meter.h |  2 ++
 2 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index f806ded1dd0a..372f4565872d 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -12,6 +12,7 @@
 #include <linux/openvswitch.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
+#include <linux/swap.h>
 
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -137,6 +138,7 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 {
 	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	u32 hash = meter_hash(ti, meter->id);
+	int err;
 
 	/* In generally, slots selected should be empty, because
 	 * OvS uses id-pool to fetch a available id.
@@ -147,16 +149,24 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 	dp_meter_instance_insert(ti, meter);
 
 	/* That function is thread-safe. */
-	if (++tbl->count >= ti->n_meters)
-		if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
-			goto expand_err;
+	tbl->count++;
+	if (tbl->count >= tbl->max_meters_allowed) {
+		err = -EFBIG;
+		goto attach_err;
+	}
+
+	if (tbl->count >= ti->n_meters &&
+	    dp_meter_instance_realloc(tbl, ti->n_meters * 2)) {
+		err = -ENOMEM;
+		goto attach_err;
+	}
 
 	return 0;
 
-expand_err:
+attach_err:
 	dp_meter_instance_remove(ti, meter);
 	tbl->count--;
-	return -ENOMEM;
+	return err;
 }
 
 static int detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
@@ -266,18 +276,32 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
 
 static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 {
-	struct sk_buff *reply;
+	struct ovs_header *ovs_header = info->userhdr;
 	struct ovs_header *ovs_reply_header;
 	struct nlattr *nla, *band_nla;
-	int err;
+	struct sk_buff *reply;
+	struct datapath *dp;
+	int err = -EMSGSIZE;
 
 	reply = ovs_meter_cmd_reply_start(info, OVS_METER_CMD_FEATURES,
 					  &ovs_reply_header);
 	if (IS_ERR(reply))
 		return PTR_ERR(reply);
 
-	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
-	    nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
+	ovs_lock();
+	dp = get_dp(sock_net(skb->sk), ovs_header->dp_ifindex);
+	if (!dp) {
+		err = -ENODEV;
+		goto exit_unlock;
+	}
+
+	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS,
+			dp->meter_tbl.max_meters_allowed))
+		goto exit_unlock;
+
+	ovs_unlock();
+
+	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
 		goto nla_put_failure;
 
 	nla = nla_nest_start_noflag(reply, OVS_METER_ATTR_BANDS);
@@ -296,9 +320,10 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_unlock:
+	ovs_unlock();
 nla_put_failure:
 	nlmsg_free(reply);
-	err = -EMSGSIZE;
 	return err;
 }
 
@@ -699,15 +724,27 @@ int ovs_meters_init(struct datapath *dp)
 {
 	struct dp_meter_table *tbl = &dp->meter_tbl;
 	struct dp_meter_instance *ti;
+	unsigned long free_mem_bytes;
 
 	ti = dp_meter_instance_alloc(DP_METER_ARRAY_SIZE_MIN);
 	if (!ti)
 		return -ENOMEM;
 
+	/* Allow meters in a datapath to use ~3.12% of physical memory. */
+	free_mem_bytes = nr_free_buffer_pages() * (PAGE_SIZE >> 5);
+	tbl->max_meters_allowed = min(free_mem_bytes / sizeof(struct dp_meter),
+				      DP_METER_NUM_MAX);
+	if (!tbl->max_meters_allowed)
+		goto out_err;
+
 	rcu_assign_pointer(tbl->ti, ti);
 	tbl->count = 0;
 
 	return 0;
+
+out_err:
+	dp_meter_instance_free(ti);
+	return -ENOMEM;
 }
 
 void ovs_meters_exit(struct datapath *dp)
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f52052d30a16..fcde5ee647da 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -20,6 +20,7 @@ struct datapath;
 
 #define DP_MAX_BANDS		1
 #define DP_METER_ARRAY_SIZE_MIN	BIT_ULL(10)
+#define DP_METER_NUM_MAX	(200000ULL)
 
 struct dp_meter_band {
 	u32 type;
@@ -50,6 +51,7 @@ struct dp_meter_instance {
 struct dp_meter_table {
 	struct dp_meter_instance __rcu *ti;
 	u32 count;
+	u32 max_meters_allowed;
 };
 
 extern struct genl_family dp_meter_genl_family;
-- 
2.23.0

