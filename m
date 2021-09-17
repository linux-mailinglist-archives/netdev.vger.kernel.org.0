Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7776340F230
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhIQGTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:19:01 -0400
Received: from smtpbg701.qq.com ([203.205.195.86]:51010 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233290AbhIQGTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:19:00 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2021 02:18:59 EDT
X-QQ-mid: bizesmtp51t1631859439tz9bj66k
Received: from localhost.localdomain (unknown [113.57.152.160])
        by esmtp6.qq.com (ESMTP) with 
        id ; Fri, 17 Sep 2021 14:17:18 +0800 (CST)
X-QQ-SSF: 01400000002000C0C000B00B0000000
X-QQ-FEAT: YCCmCqA9s3N9VaeeyC+b69ueX0VfRMattPZVgGRvsQwNeb8S9y+g6VSp9pdtY
        BZ7Gm7hYWUXy9a+BkMcdma2P/DwLNCunqqJhpUzvv9n+erE78IJnvrGeiTfsjU0y5ZTpQXG
        9vLlbTnA/g+Ko3CMfO2N9mfdpc/gqWm33OJznkjkmTGL9aYSSZDtLGw9XknfLMxjyLPbqU3
        Yxe2Rl5IHDA7Iyf+m3qnYqhuFuADuOjFLpf1HZqGQocyoQY/13+K0KLSgbv0jYkciXxPzia
        Wz8JRGKGaT6e6Ugsaak/whqf/Ba0gkRfS38HZib2MEwS9z8SZfWAfJmUficC7PVQhdNrqgA
        FHnzOlnc0OHwsszvLmIMhzOC9qQG5tluzVvTODzPxW13ICxDJA=
X-QQ-GoodBg: 2
From:   Hao Chen <chenhaoa@uniontech.com>
To:     netdev@vger.kernel.org
Cc:     Hao Chen <chenhaoa@uniontech.com>
Subject: [net-next,v1] net: e1000e: solve insmod 'Unknown symbol mutex_lock' error
Date:   Fri, 17 Sep 2021 14:16:54 +0000
Message-Id: <20210917141654.8978-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After I turn on the CONFIG_LOCK_STAT=y, insmod e1000e.ko will report:
[    5.641579] e1000e: Unknown symbol mutex_lock (err -2)
[   90.775705] e1000e: Unknown symbol mutex_lock (err -2)
[  132.252339] e1000e: Unknown symbol mutex_lock (err -2)

This problem fixed after include <linux/mutex.h>.

Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 5b2143f4b1f8..f3424255bd2b 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -21,6 +21,7 @@
 #include <linux/ptp_classify.h>
 #include <linux/mii.h>
 #include <linux/mdio.h>
+#include <linux/mutex.h>
 #include <linux/pm_qos.h>
 #include "hw.h"
 
-- 
2.20.1



