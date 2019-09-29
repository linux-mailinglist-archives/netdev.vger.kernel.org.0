Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF84C1A1F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfI3CJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35912 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729394AbfI3CJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so4681864pfr.3
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6HgZPQKZxL7r1/wQsfui/0kmuRXOheA/g5FosFtqYiw=;
        b=iCkatR+EiXQmd0aOKiofwhZDVV90FVsy0Clt1u/z1dAoYAj1CVv+DpJthktY3Bm03u
         LnK2wWAOdm0Fn0kyy5XPtz72PtG3Iga1YN6UWsKQGysonStODP2x3R617gGwsbwujqWL
         GQgxNqqe/fSi2CvKCql4ROElB3L9pP9Hn1bIj4J9M6Ewvb1PivMwGqskds9fTM0PDnnF
         +/qbrmrh1XhvtT8t8yyP85mNlBjCio4aNm1RkGlRlecTu6MtCSuGtlP4an3MPSHFdVHS
         bM/hNp3CmPHX+k4xAowP8ZrbyYiJdESoCCjEsp8ryNikowq+myurZ4qBorNaObfSR/+c
         8Cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6HgZPQKZxL7r1/wQsfui/0kmuRXOheA/g5FosFtqYiw=;
        b=V2LiuxqAc6ThBO6wGFKJDbxi4efxwBqQmqPAVAdih+L8upZO+4PeV+aMxu1ZUevR98
         7QwFGsMhhe93vj4uTYGkM93s7yBuBF5HCSq3faeJGGatgF7E+7sqth7oqJD2badaBjzX
         AcJblA4NEbID1gtzx9I6f19X9gtEh760/kIEMMp+d2/MCbQCCy1BxzE8rXP/nqWagsSP
         6WaCQYmXNVzPUWcb5Tppurm0WFM4fyjKtyuj+ZEUXhlCuSVR83GBBAQUjbAMLoOgHZlW
         fKpngTFMrEd1cC7Yp0J8bwDKA+kV/X1cD6g/I/4jQ/h8lh3HyWYfx0Ik72qUfkX8oOA7
         hVmA==
X-Gm-Message-State: APjAAAUxNbZEN6ty9hfvzo2vOx/JjAk3iLFvalCkWXTw/oOL7yoT9WQ0
        y5iVQaqOrLoyrsPWL2xymCLDj3/q
X-Google-Smtp-Source: APXvYqwPL2XwElQHeiKkz2ytP7Dn7K6d2rc1ujax5nEWofrx2yXa+UhrhBGrxoEJL9SEodiiceQiQg==
X-Received: by 2002:a63:e116:: with SMTP id z22mr22347565pgh.424.1569809351056;
        Sun, 29 Sep 2019 19:09:11 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:10 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 6/9] net: openvswitch: simplify the flow_hash
Date:   Mon, 30 Sep 2019 01:10:03 +0800
Message-Id: <1569777006-7435-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 5257e4a..c8e79c1 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -440,13 +440,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
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

