Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0671213DB5
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 18:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGCQof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 12:44:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33782 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgGCQof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 12:44:35 -0400
Date:   Fri, 3 Jul 2020 18:44:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593794673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9ea9d5TddSA41duE6kCNgQ2oPzz9NLkrv+RhRTlvCq0=;
        b=ztVNRYiF+lT6gvnldaQaFzyo29vZAteBhsUEMmorOOa3xMZpxvRaZVjw5Ym4oU8caAhH79
        k4EIb0fh/UrKXxdgybZ9Q7ZumdXZhoUKRN9I7hCYfQVYnxFvhcuPwB1ePEdSI2P4zoTBCH
        J7ov1k7FuxIRoThg8g+P/cupGj+kKpXj3wElDG4L7jK64LSqA6ZtN9eL01fBwNo4MN6wqq
        CL57DKV18AUCrMtLnsK0WayS7UIoMRQPvob/yHSdxRXPktg55UESaSX1+wrpcA0Jh2PYJS
        DlaXo2LCNXYFhYmbj6VZ5WCACzqr4qQfn2F5LlaFY69s1oVeiYwjbK8V3m05bg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593794673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9ea9d5TddSA41duE6kCNgQ2oPzz9NLkrv+RhRTlvCq0=;
        b=uN/Qv3IArFSJ/+xzP9sMKoeDaoSaHvb4aOHmnHC0f+8oeBb2TtsfXNcuDmyayAa93zcf/i
        gymbbEh8X9arq8CQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tglx@linutronix.de
Subject: [PATCH net] net/mlx5e: Do not include rwlock.h directly
Message-ID: <20200703164432.qp6pkukrbua3yyhl@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rwlock.h should not be included directly. Instead linux/splinlock.h
should be included. Including it directly will break the RT build.

Fixes: 549c243e4e010 ("net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
It would be nice if this could get into v5.8 since this include has been
added in v5.8-rc1.

 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index baa162432e75e..c3d167fa944c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -6,7 +6,6 @@
 #include <linux/rculist.h>
 #include <linux/rtnetlink.h>
 #include <linux/workqueue.h>
-#include <linux/rwlock.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 #include <net/netevent.h>
-- 
2.27.0

