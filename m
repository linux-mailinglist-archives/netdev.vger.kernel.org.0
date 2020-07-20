Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BD722578A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGTGY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:24:26 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:44744 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgGTGY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 02:24:26 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-05 (Coremail) with SMTP id zQCowACX3g6LOBVf0Ub9AQ--.44249S2;
        Mon, 20 Jul 2020 14:24:12 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, vulab@iscas.ac.cn,
        kw@linux.com, colin.king@canonical.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns: use eth_broadcast_addr() to assign broadcast address
Date:   Mon, 20 Jul 2020 06:24:10 +0000
Message-Id: <20200720062410.7773-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowACX3g6LOBVf0Ub9AQ--.44249S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW5uFyxCr17AF47JryDtrb_yoWfWrb_WF
        yj9F4rWw4UKryFya1rta9rurySv3Z0qw18uF42yrZ3JasxGr13Xa40vF4UAr1DWa17uF93
        KrsFqaySya42vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        GF1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUe5rcDU
        UUU
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAQDA18J9gK2zwAAsX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to use eth_broadcast_addr() to assign broadcast address
insetad of memset().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index 1c5243cc1dc6..acfa86e5296f 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -1724,7 +1724,7 @@ static void hns_dsaf_setup_mc_mask(struct dsaf_device *dsaf_dev,
 				   u8 port_num, u8 *mask, u8 *addr)
 {
 	if (MAC_IS_BROADCAST(addr))
-		memset(mask, 0xff, ETH_ALEN);
+		eth_broadcast_addr(mask);
 	else
 		memcpy(mask, dsaf_dev->mac_cb[port_num]->mc_mask, ETH_ALEN);
 }
-- 
2.17.1

