Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0989DD423C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfJKOF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:05:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40443 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJKOF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:05:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id d26so5865023pgl.7
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bbwVTMUAZQTJCANcvOXtOltf12CCuf2zm8x25zYgp2s=;
        b=jQaT9cYINMGp2NE1qxiK361UDjGr0NTof9MDMVy+Np1nNgWYKETlaaVwn53PgKEZVO
         0OIMMnH3mRm51vMrY57zZ1GmKf4e97VMxxz4D74kV0IOCMTLiU/yupnLjKlfXZ0jGjir
         OliSD5ATvcli8FMxM2VNqV7siJVLPR7H5Grcdolp8SXeDysScOH6hrpiiKm9dTglXb0G
         Hmv1rYDLwTFMcB0NgJb8Y0XhRwKdrVrVyH7mPXXsn3BNO+jR93T8Dm9K6mXcjZWI4gwT
         lUcQPr+Smo8ZwNk8n+/eLFx8QtouOL1Xii0kouFcPZn5LM3h0dk48b5haerbSqW+8IeI
         /9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bbwVTMUAZQTJCANcvOXtOltf12CCuf2zm8x25zYgp2s=;
        b=b04r5U5xOoXQVumAM2Y1BflR48RbAp+asS+ZzqP0RaqARetA7ltQQNxI+6HcW4/Q6V
         53KZIbZvwx1+kXe1LrYs01A1qpuBRYe3gaFIJiHSeFQTd/pggHG5TbhqEK11NSIFLRwW
         Yl97/+SKC0QD1/KKix45BRTb0tGtPwIg9ClKlB7fMimYwoHNtgOnydh/v7P9SdrT/fNd
         Z2nFVZwmlqxPzcol1BJpiISqCWjCol8EEc4W3hRGpHnynG4qVsvQv9V/flynGYu8oqTa
         IwFB9XNuI5krPR4bFdTNpGdWdTgB0RHZsLYyolAe4LY0LSq0uUAtD6jWo6Rx9W79Oqql
         0m4Q==
X-Gm-Message-State: APjAAAX0a6ORU+Qn1nu8EinkHVgueBFEGslqx0MgcCTc+43z8b5tU4DK
        Z8WZSgRAHqhkvaoQMxl7j2U=
X-Google-Smtp-Source: APXvYqwKEedgo7Bxb4cdznR2Ls/Y9bj5XzjZHYQR2OZc2clRp2Bac6FMzVtLFymV+29Fa7cPeAFTEw==
X-Received: by 2002:a63:cf4a:: with SMTP id b10mr16313682pgj.86.1570802758624;
        Fri, 11 Oct 2019 07:05:58 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.05.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:05:58 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 06/10] net: openvswitch: simplify the flow_hash
Date:   Fri, 11 Oct 2019 22:00:43 +0800
Message-Id: <1570802447-8019-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Simplify the code and remove the unnecessary BUILD_BUG_ON.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 1b99f8e..7aba5b4 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -430,13 +430,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 static u32 flow_hash(const struct sw_flow_key *key,
 		     const struct sw_flow_key_range *range)
 {
-	int key_start = range->start;
-	int key_end = range->end;
-	const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
-	int hash_u32s = (key_end - key_start) >> 2;
-
+	const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
 	/* Make sure number of hash bytes are multiple of u32. */
-	BUILD_BUG_ON(sizeof(long) % sizeof(u32));
+	int hash_u32s = range_n_bytes(range) >> 2;
 
 	return jhash2(hash_key, hash_u32s, 0);
 }
-- 
1.8.3.1

