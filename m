Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC47F267E7F
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgIMIHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgIMIHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:07:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6FC061573;
        Sun, 13 Sep 2020 01:07:00 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so3864455pjb.0;
        Sun, 13 Sep 2020 01:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PiRXJ912GcTHzMS72bOz8QrdAfQcqmOEUJxAFOgJvbg=;
        b=QGc9lwWgf5NerXkqu9+ZoGieDaatgMHiEiU2p5UIPkj4EDENI6TbqavtyFb4suN9Ri
         9QsJiLZgNhHpQ9Yl3k029NQIXmFo5NM3xdYUIzfqF65ZptNKk2g2ZUkBVjGRnqpvBrJu
         He+bTf07W/6726d7WxHQjfhPGPG9cHfu+En8pS5luqTgcz67v/JZi2qMdoCWaD+KApZv
         H1ZkSm6MfIhIkQiP6awHN/VSrHkZLHDTmCJnstJPgE5BXSSwDcL2Z9D6Pg3t9kE67jhi
         ES+8LvB+KDf4C6SonfgkXEWE3avd9N0+Jxk4xsw6kIAklW/9XtqzIj7t1AbN1Tn/EClv
         OoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PiRXJ912GcTHzMS72bOz8QrdAfQcqmOEUJxAFOgJvbg=;
        b=IN0zV5knixT237VAODIs4aIbfaL5tAgrqDO7xjcNklmSsKkbJplHm6wcHIlXNxGn9C
         iC0lwWZSj4DOU6Nntk9dPHt9QMNggI4VwANXdOE08Ros99vlY/GGQ05LcN9CyLh9EfSo
         SRNmWoySmW6R6aRUDLFrOtBgmUJimkhiSTUe0ru3qdWF565cSdOrh8jXfPKcBUIUcpZ+
         GNv7U2MM403iD9fSZxWgsc9l1M5t6x3220XAWRM+s0XMzInCO5ViUkh9LmuRU8fD+bH1
         Mt/Cx2r2lmCLmk4YTJVIi72awDVEfgFz5e3wRffMrJ/CMkNYMfAfNysjCP36dnvSDrIG
         3Z+g==
X-Gm-Message-State: AOAM530KEUAZRsVSNX71yHEqIpiy1MSIlrm2oSfdZADJFvxFrLwCQ7FR
        1e5e/fzUsfeGLSK7anQW76YhjmWXnWv/
X-Google-Smtp-Source: ABdhPJwX2uWrqEI++fVuamaLjbp0qx3XQ7+4q46NmkFCE1ctQepGve1woAqfwChaoqeZAqlygrfpxw==
X-Received: by 2002:a17:902:8306:b029:d0:cbe1:e7aa with SMTP id bd6-20020a1709028306b02900d0cbe1e7aamr9546517plb.27.1599984420118;
        Sun, 13 Sep 2020 01:07:00 -0700 (PDT)
Received: from localhost.localdomain (n11212042027.netvigator.com. [112.120.42.27])
        by smtp.gmail.com with ESMTPSA id q190sm7119793pfc.176.2020.09.13.01.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 01:06:59 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hillf Danton <hdanton@sina.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net v2] tipc: Fix memory leak in tipc_group_create_member()
Date:   Sun, 13 Sep 2020 04:06:05 -0400
Message-Id: <20200913080605.1542170-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200912102230.1529402-1-yepeilin.cs@gmail.com>
References: <20200912102230.1529402-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_group_add_to_tree() returns silently if `key` matches `nkey` of an
existing node, causing tipc_group_create_member() to leak memory. Let
tipc_group_add_to_tree() return an error in such a case, so that
tipc_group_create_member() can handle it properly.

Fixes: 75da2163dbb6 ("tipc: introduce communication groups")
Reported-and-tested-by: syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Link: https://syzkaller.appspot.com/bug?id=048390604fe1b60df34150265479202f10e13aff
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Change in v2:
    - let tipc_group_add_to_tree() return a real error code instead of -1.
      (Suggested by David Miller <davem@davemloft.net>)

 net/tipc/group.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index 588c2d2b0c69..b1fcd2ad5ecf 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -273,8 +273,8 @@ static struct tipc_member *tipc_group_find_node(struct tipc_group *grp,
 	return NULL;
 }
 
-static void tipc_group_add_to_tree(struct tipc_group *grp,
-				   struct tipc_member *m)
+static int tipc_group_add_to_tree(struct tipc_group *grp,
+				  struct tipc_member *m)
 {
 	u64 nkey, key = (u64)m->node << 32 | m->port;
 	struct rb_node **n, *parent = NULL;
@@ -291,10 +291,11 @@ static void tipc_group_add_to_tree(struct tipc_group *grp,
 		else if (key > nkey)
 			n = &(*n)->rb_right;
 		else
-			return;
+			return -EEXIST;
 	}
 	rb_link_node(&m->tree_node, parent, n);
 	rb_insert_color(&m->tree_node, &grp->members);
+	return 0;
 }
 
 static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
@@ -302,6 +303,7 @@ static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
 						    u32 instance, int state)
 {
 	struct tipc_member *m;
+	int ret;
 
 	m = kzalloc(sizeof(*m), GFP_ATOMIC);
 	if (!m)
@@ -314,8 +316,12 @@ static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
 	m->port = port;
 	m->instance = instance;
 	m->bc_acked = grp->bc_snd_nxt - 1;
+	ret = tipc_group_add_to_tree(grp, m);
+	if (ret < 0) {
+		kfree(m);
+		return NULL;
+	}
 	grp->member_cnt++;
-	tipc_group_add_to_tree(grp, m);
 	tipc_nlist_add(&grp->dests, m->node);
 	m->state = state;
 	return m;
-- 
2.25.1

