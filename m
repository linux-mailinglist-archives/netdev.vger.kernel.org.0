Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA673806E9
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhENKKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:10:15 -0400
Received: from m12-17.163.com ([220.181.12.17]:41817 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhENKKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0TI7G
        cZmBng9jgXTxLtSA1LfuJloaVczfNyICETxh3Y=; b=FFy4XNAdU6mrbcj1GCUeD
        s29fRH2deZ9LfisRtF9TP7jwlRri+Iz2t8yPjx5jDzrQuXbNXQQFTyxnr18PQUuK
        OttDgOOmn0DWL19jabAvaZtlwTSrHhpcVoP1g3Johww1/KQkBjPstVddh1mDmIl8
        b7ufHghxcdf+RVXH+HZ4AA=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp13 (Coremail) with SMTP id EcCowABXfoIITJ5gaY921A--.10274S2;
        Fri, 14 May 2021 18:08:12 +0800 (CST)
From:   zuoqilin1@163.com
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] net: Remove unnecessary variables
Date:   Fri, 14 May 2021 18:08:06 +0800
Message-Id: <20210514100806.792-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowABXfoIITJ5gaY921A--.10274S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF4Dur13CF47GF1UuF43Awb_yoWfXrXEkF
        n29FZ7WF90vw4kuw13W3y3Zr4UZFnYqF4kuFWDWFWUAw13A34rJFn7CrnrKFyrWw4Yvr1a
        g3s8C347C34j9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8VbytUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRQySiVPALxBVgQAAsq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

There is no need to define the variable "rate" to receive,
just return directly.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 net/can/proc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index d1fe49e..b3099f0 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -99,8 +99,6 @@ static void can_init_stats(struct net *net)
 static unsigned long calc_rate(unsigned long oldjif, unsigned long newjif,
 			       unsigned long count)
 {
-	unsigned long rate;
-
 	if (oldjif == newjif)
 		return 0;
 
@@ -111,9 +109,7 @@ static unsigned long calc_rate(unsigned long oldjif, unsigned long newjif,
 		return 99999999;
 	}
 
-	rate = (count * HZ) / (newjif - oldjif);
-
-	return rate;
+	return (count * HZ) / (newjif - oldjif);
 }
 
 void can_stat_update(struct timer_list *t)
-- 
1.9.1


