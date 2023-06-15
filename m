Return-Path: <netdev+bounces-11115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCE073192B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8EA428176C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6B48F71;
	Thu, 15 Jun 2023 12:49:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010DC53AF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:49:47 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D78C212B;
	Thu, 15 Jun 2023 05:49:45 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qhhrc2k6dzpW4f;
	Thu, 15 Jun 2023 20:47:12 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 20:49:42 +0800
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, YueHaibing
	<yuehaibing@huawei.com>
Subject: [PATCH net-next] net: sched: Remove unused qdisc_l2t()
Date: Thu, 15 Jun 2023 20:48:10 +0800
Message-ID: <20230615124810.34020-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is unused since switch to psched_l2t_ns().

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/sch_generic.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 12eadecf8cd0..e92f73bb3198 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1190,20 +1190,6 @@ static inline int qdisc_drop_all(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_DROP;
 }
 
-/* Length to Time (L2T) lookup in a qdisc_rate_table, to determine how
-   long it will take to send a packet given its size.
- */
-static inline u32 qdisc_l2t(struct qdisc_rate_table* rtab, unsigned int pktlen)
-{
-	int slot = pktlen + rtab->rate.cell_align + rtab->rate.overhead;
-	if (slot < 0)
-		slot = 0;
-	slot >>= rtab->rate.cell_log;
-	if (slot > 255)
-		return rtab->data[255]*(slot >> 8) + rtab->data[slot & 0xFF];
-	return rtab->data[slot];
-}
-
 struct psched_ratecfg {
 	u64	rate_bytes_ps; /* bytes per second */
 	u32	mult;
-- 
2.34.1


