Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440BA74D04
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391855AbfGYLZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:25:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41516 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbfGYLZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:25:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hqbry-0008Sh-7K; Thu, 25 Jul 2019 11:25:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: kvaser_pciefd: remove redundant negative check on trigger
Date:   Thu, 25 Jul 2019 12:25:09 +0100
Message-Id: <20190725112509.1075-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check to see if trigger is less than zero is always false, trigger
is always in the range 0..255.  Hence the check is redundant and can
be removed.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/can/kvaser_pciefd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 3af747cbbde4..68e00aad0810 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -652,9 +652,6 @@ static void kvaser_pciefd_pwm_stop(struct kvaser_pciefd_can *can)
 	top = (pwm_ctrl >> KVASER_PCIEFD_KCAN_PWM_TOP_SHIFT) & 0xff;
 
 	trigger = (100 * top + 50) / 100;
-	if (trigger < 0)
-		trigger = 0;
-
 	pwm_ctrl = trigger & 0xff;
 	pwm_ctrl |= (top & 0xff) << KVASER_PCIEFD_KCAN_PWM_TOP_SHIFT;
 	iowrite32(pwm_ctrl, can->reg_base + KVASER_PCIEFD_KCAN_PWM_REG);
-- 
2.20.1

