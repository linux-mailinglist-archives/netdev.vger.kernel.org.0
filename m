Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE40B62ED9
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGIDbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbfGIDbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C2E6A83445D307F6E29;
        Tue,  9 Jul 2019 11:31:29 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:21 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 03/10] net: hisilicon: Cleanup for cast to restricted __be32
Date:   Tue, 9 Jul 2019 11:31:04 +0800
Message-ID: <1562643071-46811-4-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following warning from sparse:
hip04_eth.c:533:23: warning: cast to restricted __be16
hip04_eth.c:533:23: warning: cast to restricted __be16
hip04_eth.c:533:23: warning: cast to restricted __be16
hip04_eth.c:533:23: warning: cast to restricted __be16
hip04_eth.c:534:23: warning: cast to restricted __be32
hip04_eth.c:534:23: warning: cast to restricted __be32
hip04_eth.c:534:23: warning: cast to restricted __be32
hip04_eth.c:534:23: warning: cast to restricted __be32
hip04_eth.c:534:23: warning: cast to restricted __be32
hip04_eth.c:534:23: warning: cast to restricted __be32

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 31f13cf..d8f0619 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -530,8 +530,8 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 		priv->rx_phys[priv->rx_head] = 0;
 
 		desc = (struct rx_desc *)skb->data;
-		len = be16_to_cpu(desc->pkt_len);
-		err = be32_to_cpu(desc->pkt_err);
+		len = be16_to_cpu((__force __be16)desc->pkt_len);
+		err = be32_to_cpu((__force __be32)desc->pkt_err);
 
 		if (0 == len) {
 			dev_kfree_skb_any(skb);
-- 
1.8.5.6

