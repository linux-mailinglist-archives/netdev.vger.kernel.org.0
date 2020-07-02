Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242082119FA
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGBCLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:11:40 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:35216 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727074AbgGBCLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 22:11:39 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-01 (Coremail) with SMTP id qwCowABHKOnuPv1edTKFAg--.63408S2;
        Thu, 02 Jul 2020 09:57:02 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        mpe@ellerman.id.au, akpm@linux-foundation.org, wenwen@cs.uga.edu,
        adobriyan@gmail.com, dan.carpenter@oracle.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] net: cisco : use set_current_state macro
Date:   Thu,  2 Jul 2020 01:57:01 +0000
Message-Id: <20200702015701.8606-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowABHKOnuPv1edTKFAg--.63408S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrWkCFWkGF1xCr1kWry5XFb_yoWxCrcEka
        10qF9akryUW3Wj9rsrCF43AryFv3y3X3Z5Za1IqFW5Ca1UZry5JFy5ZFnrJr47WryUCr13
        ArnrXFyYy3sIvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF
        7I0E8cxan2IY04v7MxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUo38nUUUUU
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAwEA102YPvBIQABsS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use set_current_state macro instead of current->state = TASK_RUNNING.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/wireless/cisco/airo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 827bb6d74815..f0bcb67095f1 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -3113,7 +3113,7 @@ static int airo_thread(void *data) {
 				}
 				break;
 			}
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&ai->thr_wait, &wait);
 			locked = 1;
 		}
-- 
2.17.1

