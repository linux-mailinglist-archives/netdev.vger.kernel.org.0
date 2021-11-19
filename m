Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB22457084
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhKSOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235816AbhKSOZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1538061B1E;
        Fri, 19 Nov 2021 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331720;
        bh=PTqCpbwq93f2tydjM7GHvVfMh97Dm2j/qCiybeViXBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5+WUcZToWHilblI+KXRoFNMGyKPf9p4FT0pvSgJSnnrNJAEeRmiwX5omBfAGqo/9
         T6+eyuXoSbe/ZiU/eRhJh2D3pZ3oPz6OtV7Zq0F+CnNxyNxjD/jFlOOC9KGE6fa1Xd
         9kHvN/U/OF384CVcShRDPCFoKEKPUg1HQbjbPFr9B4mYpryk59t/ccpFb0EAXoKt4S
         aHaMBaN6RdEpgSNSCr6dGqSckyN5Wf96/bLvYokMwYFATEyXoBjkHFtzyEXSz4V7U4
         JMgdNQiuKa2q+K8y1hu8zvvTEGPvWRBPL5e1YKuqKqGNLUcJNoO3a4tlDiANbItkvb
         nhXdvuTuimblw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/7] net: unexport dev_addr_init() & dev_addr_flush()
Date:   Fri, 19 Nov 2021 06:21:52 -0800
Message-Id: <20211119142155.3779933-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no module callers in-tree and it's hard to justify
why anyone would init or flush addresses of a netdev (note
the flush is more of a destructor, it frees netdev->dev_addr).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev_addr_lists.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index ae8b1ef00fec..a23a83ac18e5 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -513,7 +513,6 @@ void dev_addr_flush(struct net_device *dev)
 	__hw_addr_flush(&dev->dev_addrs);
 	dev->dev_addr = NULL;
 }
-EXPORT_SYMBOL(dev_addr_flush);
 
 /**
  *	dev_addr_init - Init device address list
@@ -547,7 +546,6 @@ int dev_addr_init(struct net_device *dev)
 	}
 	return err;
 }
-EXPORT_SYMBOL(dev_addr_init);
 
 void dev_addr_mod(struct net_device *dev, unsigned int offset,
 		  const void *addr, size_t len)
-- 
2.31.1

