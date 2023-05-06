Return-Path: <netdev+bounces-687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7306C6F906F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA3CA1C21B16
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058701FA5;
	Sat,  6 May 2023 08:07:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D93156EB
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:07:34 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9047D84;
	Sat,  6 May 2023 01:07:32 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VhsmiiL_1683360447;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VhsmiiL_1683360447)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 16:07:29 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: dario.binacchi@amarulasolutions.com
Cc: wg@grandegger.com,
	mkl@pengutronix.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] can: bxcan: Remove unnecessary print function dev_err()
Date: Sat,  6 May 2023 16:07:25 +0800
Message-Id: <20230506080725.68401-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The print function dev_err() is redundant because
platform_get_irq_byname() already prints an error.

./drivers/net/can/bxcan.c:970:2-9: line 970 is redundant because platform_get_irq() already prints an error.
./drivers/net/can/bxcan.c:964:2-9: line 964 is redundant because platform_get_irq() already prints an error.
./drivers/net/can/bxcan.c:958:2-9: line 958 is redundant because platform_get_irq() already prints an error.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4878
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/can/bxcan.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index e26ccd41e3cb..7b285eeb08a1 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -954,22 +954,16 @@ static int bxcan_probe(struct platform_device *pdev)
 	}
 
 	rx_irq = platform_get_irq_byname(pdev, "rx0");
-	if (rx_irq < 0) {
-		dev_err(dev, "failed to get rx0 irq\n");
+	if (rx_irq < 0)
 		return rx_irq;
-	}
 
 	tx_irq = platform_get_irq_byname(pdev, "tx");
-	if (tx_irq < 0) {
-		dev_err(dev, "failed to get tx irq\n");
+	if (tx_irq < 0)
 		return tx_irq;
-	}
 
 	sce_irq = platform_get_irq_byname(pdev, "sce");
-	if (sce_irq < 0) {
-		dev_err(dev, "failed to get sce irq\n");
+	if (sce_irq < 0)
 		return sce_irq;
-	}
 
 	ndev = alloc_candev(sizeof(struct bxcan_priv), BXCAN_TX_MB_NUM);
 	if (!ndev) {
-- 
2.20.1.7.g153144c


