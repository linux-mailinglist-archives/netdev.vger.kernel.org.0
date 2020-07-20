Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970902255AE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGTB6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:58:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43938 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTB6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:58:49 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E4B2874390DD2BBF0128;
        Mon, 20 Jul 2020 09:58:46 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.238) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:58:40 +0800
Subject: [PATCH v2] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <christophe.jaillet@wanadoo.fr>, <john.wanghui@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
 <20200719100522.220a6f5a@hermes.lan>
From:   Bixuan Cui <cuibixuan@huawei.com>
Message-ID: <866b4a34-cd4e-0120-904f-13669257a765@huawei.com>
Date:   Mon, 20 Jul 2020 09:58:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200719100522.220a6f5a@hermes.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warning: [-Werror=-Wframe-larger-than=]

drivers/net/ethernet/neterion/vxge/vxge-main.c:
In function'VXGE_COMPLETE_VPATH_TX.isra.37':
drivers/net/ethernet/neterion/vxge/vxge-main.c:119:1:
warning: the frame size of 1056 bytes is larger than 1024 bytes

Dropping the NR_SKB_COMPLETED to 16 is appropriate that won't
have much impact on performance and functionality.

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
v2: Dropping the NR_SKB_COMPLETED to 16.

 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index b0faa737b817..f905d0fe7d54 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -98,7 +98,7 @@ static inline void VXGE_COMPLETE_VPATH_TX(struct vxge_fifo *fifo)
 {
 	struct sk_buff **skb_ptr = NULL;
 	struct sk_buff **temp;
-#define NR_SKB_COMPLETED 128
+#define NR_SKB_COMPLETED 16
 	struct sk_buff *completed[NR_SKB_COMPLETED];
 	int more;

--
2.17.1


.



