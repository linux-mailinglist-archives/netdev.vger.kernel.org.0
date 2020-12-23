Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011F02E15BA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgLWCwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgLWCVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C5422525;
        Wed, 23 Dec 2020 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690069;
        bh=fjgtExWZPnGJ3WXsk0hpeCWTgmFczn/s8VSI2lMl0as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoqtuYGuNbtGot8PqVYFNAuGyJJP2V66+aSEe6aXaQD0nVqk4h+vdt/bwC8c2XJsm
         QuHOIcKW5ImOd0UvLC8QMHIy7oX9fhLd/m6rJ7z5xS6gHYaoo0RzD5oNDa/nXhne4X
         23byY2+uCUKiDUopV6TnFno6EXAwzsKSEtMWONzR7f/Qvan5Tfo/GadZmTzMYhnRo/
         gXjPW/YwyK18K0c3udHJTUYuWP/U1Myr8ROL34v2newhgaGRP3tTy2CDKkrFbUbJsq
         h/gbVDGdVOct9wQAhdV2Y9eamn8r/KCw6tup4cc6wDpagzN2/IVxIHVD0Zh3amXHS4
         fXj8Oj7EKkfOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 04/87] staging: wimax: depends on NET
Date:   Tue, 22 Dec 2020 21:19:40 -0500
Message-Id: <20201223022103.2792705-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index e4d97ab476d58..945bdf4738eb6 100644
--- a/net/wimax/Kconfig
+++ b/net/wimax/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on NET
 	depends on RFKILL || !RFKILL
 	help
 
-- 
2.27.0

