Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E271AF2CF
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDRRZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA75CC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so2826478pgg.2
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O10wsNpA1gLWNdvNreUMORJ05p7egTtAGrOIi2dZc1U=;
        b=sMwjRoaKQFjt8ke4hLUjpKQ98jAMuVh2Q26dgBdwIjEcA3ICI4Qq0wB5zqQLujC5g8
         FIyQQ/6mhUlNyJvfOTBd/mqzw5vIt487E8qrmFC1Y0n1d/UEPATP4sGitsIup5SWqAra
         OfbjCRTiu9ncpeflpKqvnobGA4w7VDegvJ/JxaUQBoKL+tyzqsrhQdqHYmsLusHbXt/F
         TFWayaQnyyMHzglAPxKAhewYQXPC3w68MTC58JH1aqZs3exuVU2Qq8+X58OrwAIMBil0
         thX1UNZ4QsAjsbV1DW1coUcpyhqcXq7u4SX4P9/SLYPTIK7WcJsuAyvRBhljlVKYSUoU
         /dmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O10wsNpA1gLWNdvNreUMORJ05p7egTtAGrOIi2dZc1U=;
        b=soHpzFMpNW23ffSJQY1AgVoPprZR1P45eApXSm9dGkQAI+zjfTIi/A1KJ0zM1VrZgU
         nLlUhW6Tui23BT3ePjbTnlIDrV/4pWC4Oq//aTT6jtUd8PRS3c1g/sheoTRAmnuhb+D2
         A33jfMB9npo2GMFSrT8EnOgSUYzjQMc/xSpwaC1jfYLpWlp5iNqoVsgR9BQqRu43gl+4
         QgrTCbP26SAJIOgm8Z9mL3TabX5QDNSAC2TGNnv8bdxqfNYCf8rIL+cDlzsF9dy8uxxq
         nYZxbP7kXSyVAGEfrNrik3Et/w+z8XJXumt82vLJvUOc7VaGteCW4sPqXB89hwISmNO6
         EhTg==
X-Gm-Message-State: AGi0PualQG3tVciDnrn/yMUqvLazXI+ZQBBmFgBFj5wex1BXlA0jkFiK
        09E+lgpvh4N8MjBYn+uqjraDQEDcwBM=
X-Google-Smtp-Source: APiQypLdh6m0YUFYRoJM3Pz1IW/VCVqbVtD53FiV723XXXOS9WBWbtqYTIs4Rz8h/GSPgjoj/EyygQ==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr8612631pgg.55.1587230713493;
        Sat, 18 Apr 2020 10:25:13 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:13 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 2/5] net: openvswitch: set max limitation to meters
Date:   Thu, 16 Apr 2020 18:17:00 +0800
Message-Id: <1587032223-49460-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Don't allow user to create meter unlimitedly,
which may cause to consume a large amount of kernel memory.
The 200,000 meters may be fine in general case.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 21 +++++++++++++++------
 net/openvswitch/meter.h |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 494a0014ecd8..1b6776f9c109 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -137,6 +137,7 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 {
 	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	u32 hash = meter_hash(ti, meter->id);
+	int err;
 
 	/*
 	 * In generally, slot selected should be empty, because
@@ -148,16 +149,24 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 	dp_meter_instance_insert(ti, meter);
 
 	/* That function is thread-safe. */
-	if (++tbl->count >= ti->n_meters)
-		if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
-			goto expand_err;
+	tbl->count++;
+	if (tbl->count > DP_METER_NUM_MAX) {
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
 
 static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
@@ -264,7 +273,7 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(reply))
 		return PTR_ERR(reply);
 
-	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
+	if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, DP_METER_NUM_MAX) ||
 	    nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
 		goto nla_put_failure;
 
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index d91940383bbe..cdfc6b9dbd42 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -19,6 +19,7 @@ struct datapath;
 
 #define DP_MAX_BANDS		1
 #define DP_METER_ARRAY_SIZE_MIN	(1ULL << 10)
+#define DP_METER_NUM_MAX	(200000ULL)
 
 struct dp_meter_band {
 	u32 type;
-- 
2.23.0

