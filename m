Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E6216AA8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGGKpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:45:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7816 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbgGGKpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 06:45:47 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8D29F4FB3C1B64CF29E5;
        Tue,  7 Jul 2020 18:45:42 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 18:45:34 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Martin Habets" <mhabets@solarflare.com>,
        Qiushi Wu <wu000273@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] sun/cassini: mark cas_resume() as __maybe_unused
Date:   Tue, 7 Jul 2020 18:55:43 +0800
Message-ID: <20200707105543.7256-1-weiyongjun1@huawei.com>
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

drivers/net/ethernet/sun/cassini.c:5206:12: warning:
 'cas_resume' defined but not used [-Wunused-function]
 5206 | static int cas_resume(struct device *dev_d)
      |            ^~~~~~~~~~

Mark cas_resume() as __maybe_unused to make it clear.

Fixes: f193f4ebde3d ("sun/cassini: use generic power management")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/sun/cassini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 95c07cc84053..e04c3d73a246 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5203,7 +5203,7 @@ static int __maybe_unused cas_suspend(struct device *dev_d)
 	return 0;
 }
 
-static int cas_resume(struct device *dev_d)
+static int __maybe_unused cas_resume(struct device *dev_d)
 {
 	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct cas *cp = netdev_priv(dev);

