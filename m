Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30AB34DE53
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhC3CZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:25:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15387 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhC3CYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:24:43 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8YBp1vN5zmVBS;
        Tue, 30 Mar 2021 10:22:58 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 10:24:29 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Karsten Keil <isdn@linux-pingi.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next v2 2/2] mISDN: Use LIST_HEAD() for list_head
Date:   Tue, 30 Mar 2021 10:24:15 +0800
Message-ID: <20210330022416.528300-2-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330022416.528300-1-liushixin2@huawei.com>
References: <20210330022416.528300-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to declare a list and then init it manually,
just use the LIST_HEAD() macro.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
---
 drivers/isdn/mISDN/dsp_core.c   | 7 ++-----
 drivers/isdn/mISDN/l1oip_core.c | 4 +---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 8766095cd6e7..386084530c2f 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -177,8 +177,8 @@ MODULE_LICENSE("GPL");
 /*int spinnest = 0;*/
 
 DEFINE_SPINLOCK(dsp_lock); /* global dsp lock */
-struct list_head dsp_ilist;
-struct list_head conf_ilist;
+LIST_HEAD(dsp_ilist);
+LIST_HEAD(conf_ilist);
 int dsp_debug;
 int dsp_options;
 int dsp_poll, dsp_tics;
@@ -1169,9 +1169,6 @@ static int __init dsp_init(void)
 	printk(KERN_INFO "mISDN_dsp: DSP clocks every %d samples. This equals "
 	       "%d jiffies.\n", dsp_poll, dsp_tics);
 
-	INIT_LIST_HEAD(&dsp_ilist);
-	INIT_LIST_HEAD(&conf_ilist);
-
 	/* init conversion tables */
 	dsp_audio_generate_law_tables();
 	dsp_silence = (dsp_options & DSP_OPT_ULAW) ? 0xff : 0x2a;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 62fad8f1fc42..2c40412466e6 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -230,7 +230,7 @@ static const char *l1oip_revision = "2.00";
 
 static int l1oip_cnt;
 static DEFINE_SPINLOCK(l1oip_lock);
-static struct list_head l1oip_ilist;
+static LIST_HEAD(l1oip_ilist);
 
 #define MAX_CARDS	16
 static u_int type[MAX_CARDS];
@@ -1440,8 +1440,6 @@ l1oip_init(void)
 	printk(KERN_INFO "mISDN: Layer-1-over-IP driver Rev. %s\n",
 	       l1oip_revision);
 
-	INIT_LIST_HEAD(&l1oip_ilist);
-
 	if (l1oip_4bit_alloc(ulaw))
 		return -ENOMEM;
 
-- 
2.25.1

