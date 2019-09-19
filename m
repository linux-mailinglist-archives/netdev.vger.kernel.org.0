Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5D8BEDBE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbfIZIre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35667 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfIZIrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id y10so1052177plp.2
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xn09ODc7huSMK4P7ZxrxGCNOImb30lD/7/46RF0Tnv8=;
        b=Swzji5DfzzPdgDpF4YLaL4DIsla65I6Cxl87kdPfEPmhwIMzPJr13DcVAkdLTOr8MJ
         elxpiWIlIbIO0Uyw8Dt9v5bAZERx0ROsc88I4Ok4OANBCNzLJITQKNGbAZriyHQJE0IA
         /kYD7yQrODgzqoPtb6zzaf8okDd/OBhOHjLhTR4+/1S4qMchU+9vMVmREqBqFF1EU2HM
         /iBPQinTnFL6R59USLJXMCWXvA7aRKOhEdrxIXFjnwWMcqOtS4yeMvtOOiZZOXxZv+aP
         jTOaQmj/y4+qdkpT9a2Qj8hbJr7w9IhaghmKNQzMUFCjbeKIitvRiMOr8rahTUtlSGyB
         mjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xn09ODc7huSMK4P7ZxrxGCNOImb30lD/7/46RF0Tnv8=;
        b=CgwzXGhEY/aAFFGLmL22KMhjJ35rkKJeAcUV3XIsMO3DTj1VQzQXjZHQ7jJKr8SjjU
         LqVAo8rAFWVsTG6fTx6pff4Wk/SCqawDPwk6dAme3RQlgxVorQL3DkugM8g6Kifjul/5
         e23t4aoVq5/Bs+/USdSdCH8ftETz4QFrZ5Y6do8D16RElmZqTuPDmlAmCRq0tNQ1bWhv
         LtQ2sEFSbdxSVfc+XL6IWXdV9OlkXbGAFSQHheoCrAu77gg4GJkAhKQH+specJep+7yR
         N5wexgD3iNTKZFmQ4cnMotBeMJ0fxWQbuQ+LENlnDC1I9iVlo9ACLHzjZv7Qq8FFx7pj
         UJFw==
X-Gm-Message-State: APjAAAUzQiiJZi8jnTSdvoMWcVa/b0/zSxYjJqRuNY+BQSstEEeVoW1m
        eXoFXE3NQPfdyHUziQbrOiE=
X-Google-Smtp-Source: APXvYqzq242T1drYw04Q+1Ta4OmMmg083ojX5MWW/1+hDuAmr8fr8I9FID17SicaHl5qMI83R4g1Jw==
X-Received: by 2002:a17:902:bd4a:: with SMTP id b10mr2633124plx.305.1569487652778;
        Thu, 26 Sep 2019 01:47:32 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:32 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 6/7] net: openvswitch: simplify the flow_hash
Date:   Fri, 20 Sep 2019 00:54:52 +0800
Message-Id: <1568912093-68535-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 2d74d74..223470a 100644
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

