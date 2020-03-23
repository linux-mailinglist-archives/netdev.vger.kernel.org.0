Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAACE196726
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgC1Pqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:46:36 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39136 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgC1Pqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:46:36 -0400
Received: by mail-pj1-f67.google.com with SMTP id z3so4585907pjr.4
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7T0gpUg1KYguFzYbM6Ar8rC1c+eZds8dxyLFu0Xgo10=;
        b=f2asgbEI6ieB4Ellt7Dy+LgThprY4DwL6LP2pb1mHFUt/fhb1amGL5S1VHCf9IDkVY
         yDnTd0JDJcLG7InQoZcEysqBVWBbiHtb4BjYOzSk6z61B5GDJms6wurNd5/Cu86YTyTp
         R2nH70bBQUVyXAHkgBGI3s4BChjOTmn9IGL/59MYYI0ucy/qHpKGxx2l+eqqSSq81ZsJ
         MPjYobP5g2NNBZ8AvryADDiwV+q/XwbZZwG96hR3oIX1digTh8ABSep4AceewWNoO+0h
         WceB+ECejsuulKK2mQxvPPnVliGFAs3xUjzv6i0sSeQtfFBp6vKpuGVp/fD28NXeofq1
         /nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7T0gpUg1KYguFzYbM6Ar8rC1c+eZds8dxyLFu0Xgo10=;
        b=Xhs4S/503R/FaHK/m1io027f5YNW8gQlxP9OJw16mIOjQ9nt7/spOz3gp5Y4EuZbru
         yihU5hxNYd4bTd9E4qsCgHPpFzjbi7egaMw9XK3xQmkNJW9DHWNZIQm5KKsGrdIgcaQT
         k8SRBkZS0BYph4AGJXC9piseJ14Lv4i1MiF6gIwpi+snfYL6FxrudlWPdi6n/OzbGps0
         j10I5oYIVFiZjhGkQXm2DjTuSPqwS+FgELhEauFTcBKop+SQ/8QAlRjq0piuzUM6m/JX
         c8jq3MOnlQJUafwRMlXCyrvo9z0aX/ZyHH2H7wO3bx5taDyV2vipgkyo8jXVb27hsHON
         5vJA==
X-Gm-Message-State: ANhLgQ37CUAlCqU9ZbiNKAZl01EAhcaKAvDH/QbEPFFhRSJjfbnb1jmM
        a/q4IUHxZENx0BW8keHc1xg=
X-Google-Smtp-Source: ADFU+vuXMBfgXsUSdwm9V8vkQDauHQHz2qMbbvGESUoHFAu2q7sZwPho4nmk6FJhUfBHgMWuMwfhmA==
X-Received: by 2002:a17:90a:1784:: with SMTP id q4mr5387627pja.174.1585410395479;
        Sat, 28 Mar 2020 08:46:35 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id q185sm6375218pfb.154.2020.03.28.08.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 08:46:35 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Andy Zhou <azhou@ovn.org>
Subject: [PATCH net-next v1 2/3] net: openvswitch: set max limitation to meters
Date:   Mon, 23 Mar 2020 21:10:38 +0800
Message-Id: <1584969039-74113-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Don't allow user to create meter unlimitedly, which
may cause to consume a large amount of kernel memory.
The 200,000 meters may be fine in general case.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 14 +++++++++-----
 net/openvswitch/meter.h |  3 ++-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 98003b201b45..5efd48e024f0 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -256,7 +256,7 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(reply))
 		return PTR_ERR(reply);
 
-	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
+	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, DP_MAX_METERS) ||
 	    nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
 		goto nla_put_failure;
 
@@ -284,13 +284,17 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 
 static struct dp_meter *dp_meter_create(struct nlattr **a)
 {
+	u32 meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
+	struct dp_meter_band *band;
+	struct dp_meter *meter;
 	struct nlattr *nla;
-	int rem;
 	u16 n_bands = 0;
-	struct dp_meter *meter;
-	struct dp_meter_band *band;
+	int rem;
 	int err;
 
+	if (meter_id > DP_MAX_METERS)
+		return ERR_PTR(-EFBIG);
+
 	/* Validate attributes, count the bands. */
 	if (!a[OVS_METER_ATTR_BANDS])
 		return ERR_PTR(-EINVAL);
@@ -304,7 +308,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 	if (!meter)
 		return ERR_PTR(-ENOMEM);
 
-	meter->id = nla_get_u32(a[OVS_METER_ATTR_ID]);
+	meter->id = meter_id;
 	meter->used = div_u64(ktime_get_ns(), 1000 * 1000);
 	meter->kbps = a[OVS_METER_ATTR_KBPS] ? 1 : 0;
 	meter->keep_stats = !a[OVS_METER_ATTR_CLEAR];
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index bc84796d7d4d..9ff7a9200d0d 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -17,7 +17,8 @@
 #include "flow.h"
 struct datapath;
 
-#define DP_MAX_BANDS		1
+#define DP_MAX_METERS	(200000ULL)
+#define DP_MAX_BANDS	1
 
 struct dp_meter_band {
 	u32 type;
-- 
2.23.0

