Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AD51CA17B
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 05:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEHD2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 23:28:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4291 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbgEHD2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 23:28:34 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD250219FAB06A086AD7;
        Fri,  8 May 2020 11:28:31 +0800 (CST)
Received: from huawei.com (10.175.101.78) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 8 May 2020
 11:28:26 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <yangyingliang@huawei.com>
Subject: [PATCH net-next] ieee802154: 6lowpan: remove unnecessary comparison
Date:   Fri, 8 May 2020 11:52:08 +0800
Message-ID: <1588909928-58230-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of dispatch is u8 which is always '<=' 0xff, so the
dispatch <= 0xff is always true, we can remove this comparison.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/ieee802154/6lowpan/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/6lowpan/rx.c b/net/ieee802154/6lowpan/rx.c
index ee17938..b34d050 100644
--- a/net/ieee802154/6lowpan/rx.c
+++ b/net/ieee802154/6lowpan/rx.c
@@ -240,7 +240,7 @@ static inline bool lowpan_is_reserved(u8 dispatch)
 	return ((dispatch >= 0x44 && dispatch <= 0x4F) ||
 		(dispatch >= 0x51 && dispatch <= 0x5F) ||
 		(dispatch >= 0xc8 && dispatch <= 0xdf) ||
-		(dispatch >= 0xe8 && dispatch <= 0xff));
+		dispatch >= 0xe8);
 }
 
 /* lowpan_rx_h_check checks on generic 6LoWPAN requirements
-- 
1.8.3

