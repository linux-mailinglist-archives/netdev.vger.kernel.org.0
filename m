Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C6333A53B
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 15:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhCNOuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 10:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhCNOt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 10:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DBFD64EBD;
        Sun, 14 Mar 2021 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615733396;
        bh=VHKIE50piqyOvnhJEl4FBj+OWtugKxt41D39+4b3pN8=;
        h=From:To:Cc:Subject:Date:From;
        b=WRBUySr/XoinO8FjjdYUNJIefMRDh1PyxWIahO7TJ5Uyn8gmhWWYwJF8JSPh6+j5l
         c0+fQnAZJf7t7woxvY2d1y+gu/k+laWSFoULsoxNqErp+L3uaFm+Gxmi+elDe03w1F
         8R2hiTael74nUdnm4+QCmf4tQCHYCXW7WTJFtFzm3NdQHb8tm/Qa6W/R3vgsBO8viY
         Stf8xgOnGr+J+IpeCLQMVzCy2PR340crmuzC5c0Zq5VYk9NVAK+KvftlbWfrHd1Jp8
         X0GD+Wk2lglXdO82y7QJrjjrGXoj47sss5Uxniebbqj4gWGUexKKL843ZOoQo0JRpk
         FIEuiWDwP1QDA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, weiwan@google.com,
        nbd@nbd.name, pabeni@redhat.com, edumazet@google.com,
        hannes@stressinduktion.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: export dev_set_threaded symbol
Date:   Sun, 14 Mar 2021 15:49:19 +0100
Message-Id: <9ee5ba9ca7506620b1a9695896992bfdfb000469.1615733129.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For wireless devices (e.g. mt76 driver) multiple net_devices belongs to
the same wireless phy and the napi object is registered in a dummy
netdevice related to the wireless phy.
Export dev_set_threaded in order to be reused in device drivers enabling
threaded NAPI.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2bfdd528c7c3..18f82ca47655 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6770,6 +6770,7 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 
 	return err;
 }
+EXPORT_SYMBOL(dev_set_threaded);
 
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
-- 
2.29.2

