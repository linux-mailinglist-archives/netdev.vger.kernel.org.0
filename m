Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1546435C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfGJIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:09:01 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:58047 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfGJIJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:09:01 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MZkxd-1hxa0r3rmR-00WjLd; Wed, 10 Jul 2019 10:08:43 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] netfilter: bridge: make NF_TABLES_BRIDGE tristate
Date:   Wed, 10 Jul 2019 10:08:20 +0200
Message-Id: <20190710080835.296696-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:elaCO7FAVfJUeOfRfMZ/SidxX1yW9xg/dTsF+eOAjseTF+HrSsh
 O/5o2LCc/QHx9+Dtt5SpGZwyRjo+WBMgSb1nYeNSEjJ5paUqiHeO5Lojl8GV/xsWVvNC+Vt
 d7lpKPCfcrQc7XOz4ar3qp5WIH4H5Zuanv+y7mswQGzCABkfTMOoe8W17qnU5aedb3udHHJ
 wb+VVASNuep4zWR8giESA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yMgse7shMA4=:LArjo+6xNg3a9zmYJxTdn+
 HOvd4nwyv98ntXVQMrMy9NQhoqgh8gFs8IwouZ5KzTK863X7uTeiUXjRHp/JFEcboyNL1a1H8
 HbNXt6gQQcr3Ca3esHg9nfmSUjxYFBNjnjP3DlbkMzQ4D6WzdLmWpG5gefkikmGjp8mcrP/Oo
 W+W9cndzhkGDuQ/byGySE2sE3a29dd5Sck5s3wMBHo0iuyH1kOC6Vv70VDSB+nfqC+TNpEksU
 g4Jxlhu83BHuX8mquA25nQfX7kaW0yr96SEgGbs9gdAiTTKoeC7Dhhtn3omqN0EXKuFCDCpBv
 tKtg8O7LTzxWnHCTD1hrgN07J1x1VDJm4hCfibRPuBz04zELQbpb7UpIG3fXAMuzQvG9LRP4j
 2a26VnmKI1bpfy9T1x4ZapFRW4t4JhCjD5zYcfbkUJrf0pSyj+T6KEXaWBwt9JnAzoF669t4x
 uEifEPpGoOsEvw9rcAe4Jmz8xSujIqpdNJYFd9gRJCd5vIlmQBc9zw4xuksStC74Rj8UTetGo
 CEpUXLHkpKcokBWIT+avQVeuCep7sxZ7GdpxgwgR1A9PZei2EyeNBtmyV5Hv+igVWAZ+r5kRl
 GwgaTBqj1B0IHgcAaIa3qqR4BNYWPgGJ6eHuRzcJqgqQA9k/tI7xVahXkSGuZtwFNRRxmrzC6
 XmSfJmz0CefDEhqPnCQDPzty208/msEKOarWMU/hx81rlZoiUc4KUErX7KFtnnUgBA0Acx4Vd
 ZGYexP96hzBT+6EqkaDrcVTEHIZ2cen3nHV5Gg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new nft_meta_bridge code fails to link as built-in when NF_TABLES
is a loadable module.

net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_eval':
nft_meta_bridge.c:(.text+0x1e8): undefined reference to `nft_meta_get_eval'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
nft_meta_bridge.c:(.text+0x468): undefined reference to `nft_meta_get_init'
nft_meta_bridge.c:(.text+0x49c): undefined reference to `nft_parse_register'
nft_meta_bridge.c:(.text+0x4cc): undefined reference to `nft_validate_register_store'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_exit':
nft_meta_bridge.c:(.exit.text+0x14): undefined reference to `nft_unregister_expr'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_init':
nft_meta_bridge.c:(.init.text+0x14): undefined reference to `nft_register_expr'
net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x60): undefined reference to `nft_meta_get_dump'
net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x88): undefined reference to `nft_meta_set_eval'

This can happen because the NF_TABLES_BRIDGE dependency itself is just a
'bool'.  Make the symbol a 'tristate' instead so Kconfig can propagate the
dependencies correctly.

Fixes: 30e103fe24de ("netfilter: nft_meta: move bridge meta keys into nft_meta_bridge")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/bridge/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 154fa558bb90..d0c75d7ec074 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -6,7 +6,7 @@
 menuconfig NF_TABLES_BRIDGE
 	depends on BRIDGE && NETFILTER && NF_TABLES
 	select NETFILTER_FAMILY_BRIDGE
-	bool "Ethernet Bridge nf_tables support"
+	tristate "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
 
-- 
2.20.0

