Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123693AB563
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhFQOIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:08:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7361 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhFQOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:08:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G5NzX2lrNz6yLC;
        Thu, 17 Jun 2021 22:02:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:06:32 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:06:32 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 5/6] net: hdlc_ppp: remove unnecessary out of memory message
Date:   Thu, 17 Jun 2021 22:03:18 +0800
Message-ID: <1623938599-25981-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
References: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes unnecessary out of memory message,
to fix the following checkpatch.pl warning:
"WARNING: Possible unnecessary 'out of memory' message"

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_ppp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index fb5102c1afc6..aec9cc4d5b48 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -219,10 +219,9 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 
 	skb = dev_alloc_skb(sizeof(struct hdlc_header) +
 			    sizeof(struct cp_header) + magic_len + len);
-	if (!skb) {
-		netdev_warn(dev, "out of memory in ppp_tx_cp()\n");
+	if (!skb)
 		return;
-	}
+
 	skb_reserve(skb, sizeof(struct hdlc_header));
 
 	cp = skb_put(skb, sizeof(struct cp_header));
-- 
2.8.1

