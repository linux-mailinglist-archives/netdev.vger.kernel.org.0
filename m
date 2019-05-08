Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0B17649
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfEHKvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 06:51:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39332 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfEHKvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 06:51:41 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hOKAh-0000qB-LQ; Wed, 08 May 2019 10:51:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: remove redundant assignment of l2_hdr to itself
Date:   Wed,  8 May 2019 11:51:35 +0100
Message-Id: <20190508105135.13170-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer l2_hdr is being assigned to itself, this is redundant
and can be removed.

Addresses-Coverity: ("Evaluation order violation")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 18711e0f9bdf..196a3d780dcf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -810,7 +810,7 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 			   u8 il4_proto, u32 *type_cs_vlan_tso,
 			   u32 *ol_type_vlan_len_msec)
 {
-	unsigned char *l2_hdr = l2_hdr = skb->data;
+	unsigned char *l2_hdr = skb->data;
 	u32 l4_proto = ol4_proto;
 	union l4_hdr_info l4;
 	union l3_hdr_info l3;
-- 
2.20.1

