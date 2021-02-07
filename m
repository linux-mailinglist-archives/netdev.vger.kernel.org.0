Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C743122B2
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhBGI3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:29:47 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48925 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhBGI1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 234CF5801DE;
        Sun,  7 Feb 2021 03:23:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=qEI07eSV7E9uv+rbHf/QMr/pTUGjDN+xKFvrzCzswxE=; b=TL3Sna+H
        8NPb7sndTWya8R8xDcfB+ZeJUCclYj/psIXUQ3htxsF0YDb9k0WzOt22sXQGjhuL
        qWgZdPiMcvVCJhlqo+T7TdevjOJ5NStGBel3GN/RUXObV4pp/KJ41sNmqjbWhNVQ
        qZOqz9eBOUZIdHRs2Ux5GS8d2SBKmDcchI6s/ayPZru2ZgiRt6gGmmSODGh9w+ug
        by/IGtK1Jh/JxZq9es1H6hnRrvo/66z+L4pmxhnnenOstI42N8OvpT8oJMqLNGaj
        fyO5+j/tqpl8xUsKAeOqmxn7qtkgpAL4QvreKgkTlEsol6xevdJzdi4pFGZaptBz
        8KZyI5/8tIEtZw==
X-ME-Sender: <xms:lKMfYDzBN_QPqFIjJmiJgMe4WFOOTWMusxHLcaIC_K3a0RsvHjVpKg>
    <xme:lKMfYLRKn4Zzbt-FH_SWH8lKA8h5tIXms-ztcgv2eOedYHwGhxLdJh4ETEBbAGJS8
    BQcAI9FWLUQc_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lKMfYNXeQFzUjeTh9hLmh4I-Sxt9awiyyaJVZeLOj7FVNSl4OaPfEw>
    <xmx:lKMfYNiqEfeaUkValoQd9RMC6VIV4BF2fB9hEgVXtraytgcocDk9Rw>
    <xmx:lKMfYFCSZx0q9-jZEv8D7fi-Ycmzf1M6-Iv2YkKRA1iG1ghSiJH-XA>
    <xmx:lKMfYJ0maf4FVTX3rqFSUexLVoABpAz7KsjZE8iq_mNyqO9D-KipBg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 175A71080057;
        Sun,  7 Feb 2021 03:23:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] netdevsim: fib: Do not warn if route was not found for several events
Date:   Sun,  7 Feb 2021 10:22:54 +0200
Message-Id: <20210207082258.3872086-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The next patch will add the ability to fail route offload controlled by
debugfs variable called "fail_route_offload".

If we vetoed the addition, we might get a delete or append notification
for a route we do not have. Therefore, do not warn if route was not found.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 6b1ec3b4750c..b93bd483cf12 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -406,7 +406,7 @@ static void nsim_fib4_rt_remove(struct nsim_fib_data *data,
 	struct nsim_fib4_rt *fib4_rt;
 
 	fib4_rt = nsim_fib4_rt_lookup(&data->fib_rt_ht, fen_info);
-	if (WARN_ON_ONCE(!fib4_rt))
+	if (!fib4_rt)
 		return;
 
 	rhashtable_remove_fast(&data->fib_rt_ht, &fib4_rt->common.ht_node,
@@ -482,7 +482,7 @@ static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
 	struct nsim_fib6_rt_nh *fib6_rt_nh;
 
 	fib6_rt_nh = nsim_fib6_rt_nh_find(fib6_rt, rt);
-	if (WARN_ON_ONCE(!fib6_rt_nh))
+	if (!fib6_rt_nh)
 		return;
 
 	fib6_rt->nhs--;
@@ -565,7 +565,7 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	int i, err;
 
 	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
-	if (WARN_ON_ONCE(!fib6_rt))
+	if (!fib6_rt)
 		return -EINVAL;
 
 	for (i = 0; i < fib6_event->nrt6; i++) {
-- 
2.29.2

