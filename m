Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AC1211F78
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgGBJIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:08:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgGBJIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 05:08:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0DE9EB761AB513D54E7F;
        Thu,  2 Jul 2020 17:08:04 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 17:07:57 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        zhong jiang <zhongjiang@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>
Subject: [PATCH net-next] ksz884x: mark pcidev_suspend() as __maybe_unused
Date:   Thu, 2 Jul 2020 17:18:10 +0800
Message-ID: <20200702091810.4999-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain configurations without power management support, gcc report
the following warning:

drivers/net/ethernet/micrel/ksz884x.c:7182:12: warning:
 'pcidev_suspend' defined but not used [-Wunused-function]
 7182 | static int pcidev_suspend(struct device *dev_d)
      |            ^~~~~~~~~~~~~~

Mark pcidev_suspend() as __maybe_unused to make it clear.

Fixes: 64120615d140 ("ksz884x: use generic power management")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 24901342ecc0..2ce7304d3753 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -7179,7 +7179,7 @@ static int __maybe_unused pcidev_resume(struct device *dev_d)
 	return 0;
 }
 
-static int pcidev_suspend(struct device *dev_d)
+static int __maybe_unused pcidev_suspend(struct device *dev_d)
 {
 	int i;
 	struct platform_info *info = dev_get_drvdata(dev_d);

