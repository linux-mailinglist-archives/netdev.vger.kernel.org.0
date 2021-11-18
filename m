Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939654553AC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbhKRESS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242866AbhKRESH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E86D61B97;
        Thu, 18 Nov 2021 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208907;
        bh=PTqCpbwq93f2tydjM7GHvVfMh97Dm2j/qCiybeViXBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwYmyMUbX0T+fWqb3JQMHsef3x1nG3hkHWkYbK00HVdWuHDonDrywg6Uw+Vl2t8D2
         vbvuZifOwbQeZTyv2jIG0/9P7VkMIwpkGmJNe7SBkmu4Eokh4gx/15UUqRiR0lrLfu
         hnUpw9oR2dU7O9dGKhShkLKAZwSc2QydsSEbXUXScHo46tR1f54auSVHLJ+6xuxto6
         wP7Lg9flYmEhdbjoqMRy4DLop+KfpkTWZpIR3t+74OHT9bqlvfV6gJiNSWy5c8ngNk
         pBlL1759vuguSqzLD2f3fhAnyIDEADrRPcdVXoFDuKx5lezoqYzbP8/gpqAsWssD14
         NMHB08HxOYdbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/9] net: unexport dev_addr_init() & dev_addr_flush()
Date:   Wed, 17 Nov 2021 20:14:58 -0800
Message-Id: <20211118041501.3102861-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
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

