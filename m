Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5803A1F48
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFIVrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFIVrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8DF9A64231;
        Wed,  9 Jun 2021 23:44:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/13] netfilter: nfnetlink_hook: add depends-on nftables
Date:   Wed,  9 Jun 2021 23:45:22 +0200
Message-Id: <20210609214523.1678-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nfnetlink_hook.c: In function 'nfnl_hook_put_nft_chain_info':
nfnetlink_hook.c:76:7: error: implicit declaration of 'nft_is_active'

This macro is only defined when NF_TABLES is enabled.
While its possible to also add an ifdef-guard, the infrastructure
is currently not useful without nf_tables.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 252956528caa ("netfilter: add new hook nfnl subsystem")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c81321372198..54395266339d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,6 +22,7 @@ config NETFILTER_FAMILY_ARP
 config NETFILTER_NETLINK_HOOK
 	tristate "Netfilter base hook dump support"
 	depends on NETFILTER_ADVANCED
+	depends on NF_TABLES
 	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
-- 
2.30.2

