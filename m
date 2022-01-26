Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD95249D24D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbiAZTLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiAZTLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71D7C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 761F4616D7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11491C340EB;
        Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224275;
        bh=KytnyQ4aFYEF8ZyogdWdGGBu6KDhQ/wY9rsgAERWLpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myCcIRNdznzHvCMvJQH5xK0lJwQVZ4XX3c0J0KT3shESfip0C+8ityD7EDil+8R/x
         oTgkELLw0Bs2pTNtAoydMPTOuTxwGhYsNM9AyZ7jH2AkHxn3KkhM/5Dp5MNpvgWYKi
         GawJ6hcAqIUXl1m3JKLIInLQrZf6VTlBO8MRCjlNKg+mvAQxetOAAL+PlR3MvqYJ6y
         RQsUafgKENpCWQH454ThF8s0W1k21MAYBkSzNC11tg9Ly16Pumy/pVnKlh3TOfBzSY
         1rSk9XA1utEoqO5UY68KU20OczNk66wf6D2zGzqBK3zGovXEXCgjjpUIoWPreDrb7a
         CzqLR0uQtfFYA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: [PATCH net-next 05/15] net: remove bond_slave_has_mac_rcu()
Date:   Wed, 26 Jan 2022 11:10:59 -0800
Message-Id: <20220126191109.2822706-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No caller since v3.16.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: j.vosburgh@gmail.com
CC: vfalico@gmail.com
CC: andy@greyhouse.net
---
 include/net/bonding.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index 83cfd2d70247..7dead855a72d 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -698,20 +698,6 @@ static inline struct slave *bond_slave_has_mac(struct bonding *bond,
 	return NULL;
 }
 
-/* Caller must hold rcu_read_lock() for read */
-static inline struct slave *bond_slave_has_mac_rcu(struct bonding *bond,
-					       const u8 *mac)
-{
-	struct list_head *iter;
-	struct slave *tmp;
-
-	bond_for_each_slave_rcu(bond, tmp, iter)
-		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
-			return tmp;
-
-	return NULL;
-}
-
 /* Caller must hold rcu_read_lock() for read */
 static inline bool bond_slave_has_mac_rx(struct bonding *bond, const u8 *mac)
 {
-- 
2.34.1

