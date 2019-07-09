Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560F76316B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfGIHCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:02:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2191 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfGIHCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 03:02:38 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 127BF232B05D5409DAFF;
        Tue,  9 Jul 2019 15:02:34 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 15:02:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <wenxu@ucloud.cn>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <coreteam@netfilter.org>,
        <netfilter-devel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nft_meta: Fix build error
Date:   Tue, 9 Jul 2019 15:01:26 +0800
Message-ID: <20190709070126.29972-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If NFT_BRIDGE_META is y and NF_TABLES is m, building fails:

net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
nft_meta_bridge.c:(.text+0xd0): undefined reference to `nft_parse_register'
nft_meta_bridge.c:(.text+0xec): undefined reference to `nft_validate_register_store'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 30e103fe24de ("netfilter: nft_meta: move bridge meta keys into nft_meta_bridge")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/bridge/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index fbc7085..ca3214f 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -12,6 +12,7 @@ if NF_TABLES_BRIDGE
 
 config NFT_BRIDGE_META
 	tristate "Netfilter nf_table bridge meta support"
+	depends on NF_TABLES
 	help
 	  Add support for bridge dedicated meta key.
 
-- 
2.7.4


