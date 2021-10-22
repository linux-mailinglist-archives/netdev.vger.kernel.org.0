Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67306438092
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhJVXXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJVXX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 744DF61057;
        Fri, 22 Oct 2021 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944870;
        bh=Mvz46oOEMIh0Tug4TtVgfCUXV2RCwd1rZlGET4PwoQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uufpR8gWucYo7piqNBT177wDI5tbf9YbaEVrlmLKFEj43a7wBlF29+9pG2OEOtVBg
         3KZpYNfyUz5j2hQPxz+U1/rk3ivLTYvCZROB7pKyN67lAOxxSCqZZ6u3WD0BTHcGUq
         6dzYAxD8Kj1own2uYUpEhu0iPX5oS3oAr4gSaBevxKhxfi2uGfO0OD5I23v7X/SbxB
         Gx8b0RfaH7wP791G+GYwI7SCU9kQyan6SoSlZ2X+riCAegvd2O+bQoelfAqgNWD5Ey
         GR6Hc6XghU2wIkCuvVmQ190fF77NaOqeq1OVM2SfA6VxQZhYcqqvlOSE/zPAf4h/P9
         P+2LigY8ZHZLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        george.mccollister@gmail.com, marco.wenzel@a-eberle.de
Subject: [PATCH net-next v2 5/8] net: hsr: get ready for const netdev->dev_addr
Date:   Fri, 22 Oct 2021 16:21:00 -0700
Message-Id: <20211022232103.2715312-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_create_self_node() may get netdev->dev_addr
passed as argument, netdev->dev_addr will be
const soon.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: george.mccollister@gmail.com
CC: marco.wenzel@a-eberle.de
---
 net/hsr/hsr_framereg.c | 4 ++--
 net/hsr/hsr_framereg.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index e31949479305..91292858a63b 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -76,8 +76,8 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
  * frames from self that's been looped over the HSR ring.
  */
 int hsr_create_self_node(struct hsr_priv *hsr,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN])
+			 const unsigned char addr_a[ETH_ALEN],
+			 const unsigned char addr_b[ETH_ALEN])
 {
 	struct list_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node, *oldnode;
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index d9628e7a5f05..bdbb8c822ba1 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -48,8 +48,8 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 void hsr_prune_nodes(struct timer_list *t);
 
 int hsr_create_self_node(struct hsr_priv *hsr,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN]);
+			 const unsigned char addr_a[ETH_ALEN],
+			 const unsigned char addr_b[ETH_ALEN]);
 
 void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 			unsigned char addr[ETH_ALEN]);
-- 
2.31.1

