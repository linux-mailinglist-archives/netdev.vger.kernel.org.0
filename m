Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C933646AFC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiLHItU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiLHItF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:49:05 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C24EC;
        Thu,  8 Dec 2022 00:48:51 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NSSVj4cnnz4f3r6C;
        Thu,  8 Dec 2022 16:48:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP1 (Coremail) with SMTP id cCh0CgAnG6rupJFj_X4FBw--.10136S4;
        Thu, 08 Dec 2022 16:48:48 +0800 (CST)
From:   Ye Bin <yebin@huaweicloud.com>
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     yebin10@huawei.com
Subject: [PATCH net-next] net: af_can: remove useless parameter 'err' in 'can_rx_register()'
Date:   Thu,  8 Dec 2022 17:09:40 +0800
Message-Id: <20221208090940.3695670-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAnG6rupJFj_X4FBw--.10136S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4rtry8Jw4xWr1UKFW3ZFb_yoWDZrbE9r
        yI9r18WF17tr43Kr15Cw4fXF1vk3yrGF4xXFySy34vv3WagFZ5Gw1kGF9xXr98Gryxtr15
        Wwn8Xr92gr1fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUboAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
        z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
        AF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
        IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s
        0DMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
        daVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

Since commit bdfb5765e45b remove NULL-ptr checks from users of
can_dev_rcv_lists_find(). 'err' parameter is useless, so remove it.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/can/af_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 27dcdcc0b808..ec3f7e658295 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -446,7 +446,6 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 	struct hlist_head *rcv_list;
 	struct can_dev_rcv_lists *dev_rcv_lists;
 	struct can_rcv_lists_stats *rcv_lists_stats = net->can.rcv_lists_stats;
-	int err = 0;
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
@@ -481,7 +480,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 					       rcv_lists_stats->rcv_entries);
 	spin_unlock_bh(&net->can.rcvlists_lock);
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(can_rx_register);
 
-- 
2.31.1

