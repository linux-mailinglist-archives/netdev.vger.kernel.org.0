Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE22C4F36
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 08:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbgKZHQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 02:16:05 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:40348 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730639AbgKZHQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 02:16:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xia1@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UGaDlDq_1606374944;
Received: from rs3b04014.et2sqa.tbsite.net(mailfrom:xia1@linux.alibaba.com fp:SMTPD_---0UGaDlDq_1606374944)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Nov 2020 15:16:01 +0800
From:   Runzhe Wang <xia1@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Runzhe Wang <xia1@linux.alibaba.com>
Subject: [PATCH] NFC:Fix Warning: Comparison to bool
Date:   Thu, 26 Nov 2020 15:15:42 +0800
Message-Id: <1606374942-1570157-1-git-send-email-xia1@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch uses the shdlc->rnr variable as a judgment condition of
statement, rather than compares with bool.

Signed-off-by: Runzhe Wang <xia1@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 net/nfc/hci/llc_shdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 0eb4ddc..f178a42 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -319,7 +319,7 @@ static void llc_shdlc_rcv_s_frame(struct llc_shdlc *shdlc,
 	switch (s_frame_type) {
 	case S_FRAME_RR:
 		llc_shdlc_rcv_ack(shdlc, nr);
-		if (shdlc->rnr == true) {	/* see SHDLC 10.7.7 */
+		if (shdlc->rnr) {	/* see SHDLC 10.7.7 */
 			shdlc->rnr = false;
 			if (shdlc->send_q.qlen == 0) {
 				skb = llc_shdlc_alloc_skb(shdlc, 0);
-- 
1.8.3.1

