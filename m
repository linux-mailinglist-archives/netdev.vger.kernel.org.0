Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D401F4BE4
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFJDt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFJDt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:56 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15932078B;
        Wed, 10 Jun 2020 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760996;
        bh=R/vw++/BEhW/50SqjUMC+E131tom92oALsEW/zr2gko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjCfiNO+/FLDJUSfKBc1NhxIj5UDVQxk/msw4Br2HTMcMo+3+waXvC6ffijcQcKHg
         8w1FCZM2hUX3TZF17YoYuusNRQtik1oQ0gu27M13A5O5ICkdeSFTGmY4rAydB5kADR
         AhKYxcX4AORCIE9oXcZnyduG3UdsN7kwk8xFBMns=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 1/8] nexthop: Rename nexthop_free_mpath
Date:   Tue,  9 Jun 2020 21:49:46 -0600
Message-Id: <20200610034953.28861-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nexthop_free_mpath really should be nexthop_free_group. Rename it.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 400a9f89ebdb..5ebc47d5ec56 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -69,7 +69,7 @@ static void nexthop_devhash_add(struct net *net, struct nh_info *nhi)
 	hlist_add_head(&nhi->dev_hash, head);
 }
 
-static void nexthop_free_mpath(struct nexthop *nh)
+static void nexthop_free_group(struct nexthop *nh)
 {
 	struct nh_group *nhg;
 	int i;
@@ -109,7 +109,7 @@ void nexthop_free_rcu(struct rcu_head *head)
 	struct nexthop *nh = container_of(head, struct nexthop, rcu);
 
 	if (nh->is_group)
-		nexthop_free_mpath(nh);
+		nexthop_free_group(nh);
 	else
 		nexthop_free_single(nh);
 
-- 
2.21.1 (Apple Git-122.3)

