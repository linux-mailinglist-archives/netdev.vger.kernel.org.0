Return-Path: <netdev+bounces-10577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0330772F306
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 343A7281293
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BFB39B;
	Wed, 14 Jun 2023 03:24:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CDD363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:24:09 +0000 (UTC)
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB404198;
	Tue, 13 Jun 2023 20:24:06 -0700 (PDT)
Received: from ed3e173716be.home.arpa (unknown [124.16.138.125])
	by APP-03 (Coremail) with SMTP id rQCowADX3SHEMolkIQROAg--.40109S2;
	Wed, 14 Jun 2023 11:23:48 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: vburru@marvell.com,
	aayarekar@marvell.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	sburla@marvell.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] octeon_ep: Add missing check for ioremap
Date: Wed, 14 Jun 2023 11:23:47 +0800
Message-Id: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADX3SHEMolkIQROAg--.40109S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFy3KFW7uF4Dur4fJFy3XFb_yoW8Xw4Upr
	yUWayDX34rtr43W3ZrXw1UJFn09a1Yy3s5Kr97Aanag3s3tFn8Aa48AF40v3yUKFZ5uF13
	tF1jy3Z3AFn7AaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjQBMtUUUUU==
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add check for ioremap() and return the error if it fails in order to
guarantee the success of ioremap().

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index e1853da280f9..06816d2baef8 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -969,7 +969,7 @@ static const char *octep_devid_to_str(struct octep_device *oct)
 int octep_device_setup(struct octep_device *oct)
 {
 	struct pci_dev *pdev = oct->pdev;
-	int i, ret;
+	int i, j, ret;
 
 	/* allocate memory for oct->conf */
 	oct->conf = kzalloc(sizeof(*oct->conf), GFP_KERNEL);
@@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)
 		oct->mmio[i].hw_addr =
 			ioremap(pci_resource_start(oct->pdev, i * 2),
 				pci_resource_len(oct->pdev, i * 2));
+		if (!oct->mmio[i].hw_addr)
+			goto unsupported_dev;
+
 		oct->mmio[i].mapped = 1;
 	}
 
@@ -1015,8 +1018,8 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
-	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
-		iounmap(oct->mmio[i].hw_addr);
+	for (j = 0; j < i; j++)
+		iounmap(oct->mmio[j].hw_addr);
 
 	kfree(oct->conf);
 	return -1;
-- 
2.25.1


