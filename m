Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C1107445
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 15:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKVOw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 09:52:57 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41113 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfKVOw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 09:52:57 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iYAIp-0006w3-BP; Fri, 22 Nov 2019 15:52:55 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/2] can: m_can_platform: remove unnecessary m_can_class_resume() call
Date:   Fri, 22 Nov 2019 15:52:51 +0100
Message-Id: <20191122145251.9775-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122145251.9775-1-mkl@pengutronix.de>
References: <20191122145251.9775-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pankaj Sharma <pankj.sharma@samsung.com>

The function m_can_runtime_resume() is getting recursively called from
m_can_class_resume(). This results in a lock up.

We need not call m_can_class_resume() during m_can_runtime_resume().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 2eaa3543d233..38ea5e600fb8 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -166,8 +166,6 @@ static int __maybe_unused m_can_runtime_resume(struct device *dev)
 	if (err)
 		clk_disable_unprepare(mcan_class->hclk);
 
-	m_can_class_resume(dev);
-
 	return err;
 }
 
-- 
2.24.0

