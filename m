Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3225D13F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfGBOMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:12:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbfGBOMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:12:24 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 36EB5CE004227F3B0405;
        Tue,  2 Jul 2019 22:12:19 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 2 Jul 2019
 22:12:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <chunkeey@googlemail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] carl9170: remove set but not used variable 'udev'
Date:   Tue, 2 Jul 2019 22:12:07 +0800
Message-ID: <20190702141207.47552-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/carl9170/usb.c: In function carl9170_usb_disconnect:
drivers/net/wireless/ath/carl9170/usb.c:1110:21:
 warning: variable udev set but not used [-Wunused-but-set-variable]

It is not use since commit feb09b293327 ("carl9170:
fix misuse of device driver API")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/carl9170/usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 99f1897..486957a 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -1107,12 +1107,10 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 static void carl9170_usb_disconnect(struct usb_interface *intf)
 {
 	struct ar9170 *ar = usb_get_intfdata(intf);
-	struct usb_device *udev;
 
 	if (WARN_ON(!ar))
 		return;
 
-	udev = ar->udev;
 	wait_for_completion(&ar->fw_load_wait);
 
 	if (IS_INITIALIZED(ar)) {
-- 
2.7.4


