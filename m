Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B53929FF
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhE0Iud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbhE0IuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:50:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E442AC061357
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgo-0002JS-65
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CB4D962D432
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1854462D3E1;
        Thu, 27 May 2021 08:45:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bd38402a;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, zuoqilin <zuoqilin@yulong.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 05/21] can: proc: remove unnecessary variables
Date:   Thu, 27 May 2021 10:45:16 +0200
Message-Id: <20210527084532.1384031-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

There is no need to define the variable "rate" to receive, just return
directly.

Link: https://lore.kernel.org/r/20210514100806.792-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/proc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index d1fe49e6f16d..b3099f0a3cb8 100644
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
2.30.2


