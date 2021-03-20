Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CE342F4F
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCTThg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCTThQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:37:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC69C061764
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:37:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lNhPO-0000RZ-JT
        for netdev@vger.kernel.org; Sat, 20 Mar 2021 20:37:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C097E5FB3EB
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 19:37:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6A9E25FB3D7;
        Sat, 20 Mar 2021 19:37:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c23fe795;
        Sat, 20 Mar 2021 19:37:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Leon Romanovsky <leon@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [net 2/2] can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"
Date:   Sat, 20 Mar 2021 20:37:08 +0100
Message-Id: <20210320193708.348503-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210320193708.348503-1-mkl@pengutronix.de>
References: <20210320193708.348503-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 6417f03132a6 ("module: remove never implemented
MODULE_SUPPORTED_DEVICE") the MODULE_SUPPORTED_DEVICE macro was
removed from the kerne entirely. Shortly before this patch was applied
mainline the commit 59ec7b89ed3e ("can: peak_usb: add forgotten
supported devices") was added to net/master. As this would result in a
merge conflict, let's revert this patch.

Fixes: 59ec7b89ed3e ("can: peak_usb: add forgotten supported devices")
Link: https://lore.kernel.org/r/20210320192649.341832-1-mkl@pengutronix.de
Suggested-by: Leon Romanovsky <leon@kernel.org>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index f1d018218c93..f347ecc79aef 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -18,8 +18,6 @@
 
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
-MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-Chip USB");
-MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB X6 adapter");
 
 #define PCAN_USBPROFD_CHANNEL_COUNT	2
 #define PCAN_USBFD_CHANNEL_COUNT	1
-- 
2.30.2


