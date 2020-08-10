Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1A2400F1
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 04:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgHJCie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 22:38:34 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:35750 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbgHJCie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:34 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowABHTxsfszBfrMpoAQ--.26273S2;
        Mon, 10 Aug 2020 10:38:23 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     snelson@pensando.io, drivers@pensando.io, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()
Date:   Mon, 10 Aug 2020 02:38:07 +0000
Message-Id: <20200810023807.9260-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABHTxsfszBfrMpoAQ--.26273S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1UKw4UGFWDCw17uryfJFb_yoW8Gw1xpa
        1xJFy2vr1UXF4I9an7Xw4kZa45X3yxGrW3Grsru3s3uwnrJFW8XF48KFW8XFW0kFZ5CF10
        vF1qy3W3ZFs5A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK
        6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbZ2-5
        UUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQUEA102ZfUVcgAAsX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "devm_kcalloc".

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1944bf5264db..26988ad7ec97 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -412,7 +412,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 	new->flags = flags;
 
-	new->q.info = devm_kzalloc(dev, sizeof(*new->q.info) * num_descs,
+	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
 				   GFP_KERNEL);
 	if (!new->q.info) {
 		netdev_err(lif->netdev, "Cannot allocate queue info\n");
@@ -462,7 +462,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		new->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
 	}
 
-	new->cq.info = devm_kzalloc(dev, sizeof(*new->cq.info) * num_descs,
+	new->cq.info = devm_kcalloc(dev, num_descs, sizeof(*new->cq.info),
 				    GFP_KERNEL);
 	if (!new->cq.info) {
 		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
-- 
2.17.1

