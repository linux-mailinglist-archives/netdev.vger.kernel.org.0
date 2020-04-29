Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3731BD6AD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 09:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgD2H5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 03:57:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3337 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbgD2H5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 03:57:15 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1755BB7622E649D10F75;
        Wed, 29 Apr 2020 15:57:13 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Apr 2020 15:57:06 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] ptp: ptp_ines: convert to devm_platform_ioremap_resource
Date:   Wed, 29 Apr 2020 07:58:20 +0000
Message-ID: <20200429075820.103452-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper function that wraps the calls to platform_get_resource()
and devm_ioremap_resource() together.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/ptp/ptp_ines.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 52d77db39829..7711651ff19e 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -783,16 +783,10 @@ static struct mii_timestamping_ctrl ines_ctrl = {
 static int ines_ptp_ctrl_probe(struct platform_device *pld)
 {
 	struct ines_clock *clock;
-	struct resource *res;
 	void __iomem *addr;
 	int err = 0;
 
-	res = platform_get_resource(pld, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pld->dev, "missing memory resource\n");
-		return -EINVAL;
-	}
-	addr = devm_ioremap_resource(&pld->dev, res);
+	addr = devm_platform_ioremap_resource(pld, 0);
 	if (IS_ERR(addr)) {
 		err = PTR_ERR(addr);
 		goto out;



