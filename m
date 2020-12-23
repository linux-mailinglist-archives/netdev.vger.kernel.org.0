Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F5A2E1715
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbgLWDFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgLWCTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0E32333D;
        Wed, 23 Dec 2020 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689904;
        bh=f78yVkOu3m3B+MmO4CWx/crRGEC09+OLcpZdW7IS3AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ4J6L75r7Hwg71ZFzBipqfyeYGhc82FOV57DT3tIj+Yh8RjbekbI4h4wfD2GmwSM
         c5q5mpKKwgxtrCgvpRPlKvffoSLURuThuZSCWwR7J8Y8UjEnlN1Lj5JKkyrXx9EZjt
         ZJAuSfmJB8+x+OXESTea6O1TZ3vxTf3UrGZLCcFLYTqNZQHUKBJ41jdGRkPmIvwC2S
         HhP87EUbkLQjFqLsxWm6MHqZ+V1HXnsIZR8UUk0J8yzVOvuT7KsLcJwvA0rsX3zuV2
         18TDz1Birzzu+OnSkzQ4/QMbj0kw8IGaITX5ebjYyrEOn4qgEvToAHPUaqk0f/kekp
         ro0qlK1X553ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 008/130] staging: wimax: depends on NET
Date:   Tue, 22 Dec 2020 21:16:11 -0500
Message-Id: <20201223021813.2791612-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9364a2cf567187c0a075942c22d1f434c758de5d ]

Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):

ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_alloc':
op-msg.c:(.text+0xa9): undefined reference to `__alloc_skb'
ld: op-msg.c:(.text+0xcc): undefined reference to `genlmsg_put'
ld: op-msg.c:(.text+0xfc): undefined reference to `nla_put'
ld: op-msg.c:(.text+0x168): undefined reference to `kfree_skb'
ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_data_len':
op-msg.c:(.text+0x1ba): undefined reference to `nla_find'
ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_send':
op-msg.c:(.text+0x311): undefined reference to `init_net'
ld: op-msg.c:(.text+0x326): undefined reference to `netlink_broadcast'
ld: drivers/staging/wimax/stack.o: in function `__wimax_state_change':
stack.c:(.text+0x433): undefined reference to `netif_carrier_off'
ld: stack.c:(.text+0x46b): undefined reference to `netif_carrier_on'
ld: stack.c:(.text+0x478): undefined reference to `netif_tx_wake_queue'
ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_exit':
stack.c:(.exit.text+0xe): undefined reference to `genl_unregister_family'
ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_init':
stack.c:(.init.text+0x1a): undefined reference to `genl_register_family'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20201102072456.20303-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wimax/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wimax/Kconfig b/net/wimax/Kconfig
index d13762bc4abca..4dcb5eba720a3 100644
--- a/net/wimax/Kconfig
+++ b/net/wimax/Kconfig
@@ -5,6 +5,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on NET
 	depends on RFKILL || !RFKILL
 	help
 
-- 
2.27.0

