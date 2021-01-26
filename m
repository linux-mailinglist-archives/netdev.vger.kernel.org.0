Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4A303C25
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405408AbhAZLwt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 06:52:49 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2798 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405391AbhAZLwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:52:45 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DQ4mD6Sw0z13kBH;
        Tue, 26 Jan 2021 19:50:04 +0800 (CST)
Received: from dggema723-chm.china.huawei.com (10.3.20.87) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 26 Jan 2021 19:52:01 +0800
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 dggema723-chm.china.huawei.com (10.3.20.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 26 Jan 2021 19:52:01 +0800
Received: from dggeme752-chm.china.huawei.com ([10.6.80.76]) by
 dggeme752-chm.china.huawei.com ([10.6.80.76]) with mapi id 15.01.2106.002;
 Tue, 26 Jan 2021 19:52:01 +0800
From:   liaichun <liaichun@huawei.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] bonding: fix send_peer_notif data truncation
Thread-Topic: [PATCH net] bonding: fix send_peer_notif data truncation
Thread-Index: Adbz18rVysmNrOYZRKCbpwP7nrVB2g==
Date:   Tue, 26 Jan 2021 11:52:01 +0000
Message-ID: <e27dd20165a14d99bc2b406061e60bcd@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.224]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

send_peer_notif is u8, the value of this parameter is obtained from u8*int, the data may be truncated.
 And in practice, more than u8(256)  characters are used.
Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")

Signed-off-by: Aichun Li <liaichun@huawei.com>
---
 include/net/bonding.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h index 0960d9af7b8e..65394566d556 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -215,7 +215,7 @@ struct bonding {
 	 */
 	spinlock_t mode_lock;
 	spinlock_t stats_lock;
-	u8	 send_peer_notif;
+	u64	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
 	struct   proc_dir_entry *proc_entry;
--
2.19.1

