Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5102E76A6
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgL3GqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:46:14 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51612 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgL3GqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:46:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UKD9.Mt_1609310714;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKD9.Mt_1609310714)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 14:45:30 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     asmadeus@codewreck.org
Cc:     davem@davemloft.net, kuba@kernel.org, ericvh@gmail.com,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] 9p: fix: Uninitialized variable p.
Date:   Wed, 30 Dec 2020 14:45:13 +0800
Message-Id: <1609310713-84972-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer p is being used but it isn't being initialized,
need to assign a NULL to it.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 net/9p/trans_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 93f2f86..d4d635f 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -342,7 +342,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
 		/* kernel buffer, no need to pin pages */
 		int index;
 		size_t len;
-		void *p;
+		void *p = NULL;
 
 		/* we'd already checked that it's non-empty */
 		while (1) {
-- 
1.8.3.1

