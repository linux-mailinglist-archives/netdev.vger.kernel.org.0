Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF3E9563
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfJ3Dsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37117 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Dsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id u9so575419pfn.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ASrSp+rkR8/SjaoCrbjVWatjKFN8vKJUh+GjjuOta+c=;
        b=qP7ULM3I8p7gf5SOp/iqSNUPz8e7gtnjUBXq8tbs2JOkg/5PzRWU/LQae51IVx3KkD
         dQowWqaWJSyIAJaCNnANB7hq19nXIe2LQ3O0cVSsWZDQZ1MucF3UomoRJAQn6fkXHIZY
         YoG3Nk9gNMS/+C5LG8fha/Z4qA1bAQj518uZH/JPBDcS1bZoenuwRNxh5+KxgX1UJCy6
         pPZxmFPenaOXM14HI7Av5eGuZVmLBXXEiYgaTe+6fqfmES+CZX8mn5pWwQUr6xyqStjm
         0s8a8EK2HQOCHs45K/YcXa6WzDyuPRNrZ8JwxfRWQW9GLqT5rIFw7MzEMcK9Sa3Kz8Oj
         K5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ASrSp+rkR8/SjaoCrbjVWatjKFN8vKJUh+GjjuOta+c=;
        b=LGhiPnPe+ldKhuIvjUh6IsGp/uBKhmKtVBFWLynudk1mVXa8+jm1RrJElZzb6Xb77z
         dPQReMwr2NpMXgCeZJjFk/GmQ5LyjtwwyOVp0Zn2GlnslB0R+4tOh1FQZqAs6rIif7n7
         WiWx97BPTUjtq0mLUq/q6W1zRtRjKp0bAG1aJopm4RQcTsW36DL82BbwdeXCHtHEr5oQ
         +OBgVDkDIrb0jkY63otW6wxmehEhVKebRG/z3CV6aj6XB+WmPX0NirpWGWicLnYcjyXV
         v1AAUuLYgJsh9/0hljFRKIjnlLOl/w4ghiClA3GXYVhKDUVUf+bviHazJaRtRpEwICSA
         lNUQ==
X-Gm-Message-State: APjAAAUyg03zlyc88OBU1euZn2lhIKxnp29Ks0EuwwXNOV3idd111QxE
        co/91mZ4iG2X1oAjDjk1MNg=
X-Google-Smtp-Source: APXvYqweSx2W8WHv6o8XbaAYCKljMCEP63RbL9WuIuR286p94wu923Fz8uAvA4sUvYYP+VdwutatHw==
X-Received: by 2002:a63:f30c:: with SMTP id l12mr194797pgh.354.1572407326366;
        Tue, 29 Oct 2019 20:48:46 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:45 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 06/10] net: openvswitch: simplify the flow_hash
Date:   Sat, 19 Oct 2019 16:08:40 +0800
Message-Id: <1571472524-73832-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Simplify the code and remove the unnecessary BUILD_BUG_ON.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
---
 net/openvswitch/flow_table.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index a10d421..3e3d345 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -432,13 +432,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
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

