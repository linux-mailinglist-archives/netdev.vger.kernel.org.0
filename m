Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B010C267973
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 12:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgILKYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 06:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgILKYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 06:24:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46FC061573;
        Sat, 12 Sep 2020 03:24:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c3so2113150plz.5;
        Sat, 12 Sep 2020 03:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K41lXPEXhtriRTvEA20PbR1JTl5zSR6Y019sMKtFmvQ=;
        b=YgPeku7XYoG9gbJgAjzf7i7Nz7UM8Y+vvomXWKqboc/J71cO8KeMFeQc7IUaOxgLz6
         dO3D+1NjwZKGspHfN5B5T7TXDsIqdp6iv71wn7MehaN5TnqAcHaWS/KllTWn5VVUmkO3
         +43Tqu47KdbhI4+Qmd0Sa8mli4f7vVWK/vhP6AU8DAhx30jYrl5p0iPY7Zcj/XvNyAFv
         PEA9dzDmXp1dHw6+nU1goQ0Fp5ThR7egU+dJtCmppGmAvVRHX6n7J1SmGXQvB2bLHuCO
         4yA3rTpj6XppKs+le43FZ8HVtM6nMnzIutV9GO9eMYwmz9KAmzuX6RuK2nHy3qMKiQML
         jnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K41lXPEXhtriRTvEA20PbR1JTl5zSR6Y019sMKtFmvQ=;
        b=U5TiXBL0mNqz+us/DG38vUCjOjOBwifwZfcoUYet0NV8nHRu5dVoivAznjpZebFR+J
         5dU0E2LpU6uRYb6qIlUjK6yF33857DXYXXKck8DHMYg5CAOJdnHmEcF2pZH3YVO/rXzk
         YifQjQuvQ9iQpcPpXboFQW2JYSKL9TtgQ67DpXeSywPoZHYuEuow8CZMHZgl3raKERws
         mvkaHYCYvwMGGGjXIq6ChG0faAT//r9mAiEBa34u4iIY15Xmic/w2KdAAFX7MUsfL/Xp
         BDg+xooSCxvAg2X97ko5ChPDTJ9QLHpkFdvZwMCE5gqydnErOiU1FWnGx6hKQbR88J6b
         yUxw==
X-Gm-Message-State: AOAM530LTWZ9zqK2HUl7zLKISGLmVhM77MNzTdEwrIQLKz1KGH9Imfae
        TE9XFCjm582SjLMLE7Lnkg==
X-Google-Smtp-Source: ABdhPJzs5WmlP13J6EpGQ2ny/5LqUYvMuasn077V89lvM37mWRZCgAzk1psfpLgIuTMedkyqXde6lw==
X-Received: by 2002:a17:902:d913:b029:d0:cbe1:e712 with SMTP id c19-20020a170902d913b02900d0cbe1e712mr6314346plz.32.1599906257759;
        Sat, 12 Sep 2020 03:24:17 -0700 (PDT)
Received: from localhost.localdomain (n11212042027.netvigator.com. [112.120.42.27])
        by smtp.gmail.com with ESMTPSA id 203sm4722682pfz.131.2020.09.12.03.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 03:24:17 -0700 (PDT)
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
Subject: [Linux-kernel-mentees] [PATCH net] tipc: Fix memory leak in tipc_group_create_member()
Date:   Sat, 12 Sep 2020 06:22:30 -0400
Message-Id: <20200912102230.1529402-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <000000000000879057058f193fb5@google.com>
References: <000000000000879057058f193fb5@google.com>
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
Decoded syzbot reproducer in pseudo-C:

	fd0 = socket(AF_TIPC, SOCK_DGRAM, 0);

	sockaddr_tipc.family = AF_TIPC;
	sockaddr_tipc.addrtype = TIPC_ADDR_NAMESEQ;
	sockaddr_tipc.scope = 0;
	sockaddr_tipc.addr.namesq.type = TIPC_RESERVED_TYPES + 1;
	bind(fd0, &sockaddr_tipc, sizeof(sockaddr_tipc));

	tipc_group_req0.type = TIPC_RESERVED_TYPES + 1;
	setsockopt(fd0, SOL_TIPC, TIPC_GROUP_JOIN, &tipc_group_req0, sizeof(tipc_group_req0));

	fd1 = socket(AF_TIPC, SOCK_STREAM, 0);

	tipc_group_req1.type = TIPC_RESERVED_TYPES + 1;
	tipc_group_req1.scope = TIPC_CLUSTER_SCOPE;
	setsockopt(fd1, SOL_TIPC, TIPC_GROUP_JOIN, &tipc_group_req1, sizeof(tipc_group_req1));

 net/tipc/group.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index 588c2d2b0c69..553cf08b4d76 100644
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
+			return -1;
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

