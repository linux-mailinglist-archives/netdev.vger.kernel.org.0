Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E7C2B7109
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgKQVkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQVkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 16:40:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F9EC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 13:40:18 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1kf8hx-0002vq-VC; Tue, 17 Nov 2020 22:40:13 +0100
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1kf8hx-0003ix-Ct; Tue, 17 Nov 2020 22:40:13 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kernel@pengutronix.de, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1] ptp: document struct ptp_clock_request members
Date:   Tue, 17 Nov 2020 22:38:26 +0100
Message-Id: <20201117213826.18235-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's arguable most people interested in configuring a PPS signal
want it as external output, not as kernel input. PTP_CLK_REQ_PPS
is for input though. Add documentation to nudge readers into
the correct direction.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
Prompted by Richard's comment here:
https://lore.kernel.org/netdev/20180525170247.r4gn323udrucmyv6@localhost/
---
 include/linux/ptp_clock_kernel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index d3e8ba5c7125..0d47fd33b228 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -12,6 +12,19 @@
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock.h>
 
+/**
+ * struct ptp_clock_request - request PTP clock event
+ *
+ * @type:   The type of the request.
+ *	    EXTTS:  Configure external trigger timestamping
+ *	    PEROUT: Configure periodic output signal (e.g. PPS)
+ *	    PPS:    trigger internal PPS event for input
+ *	            into kernel PPS subsystem
+ * @extts:  describes configuration for external trigger timestamping.
+ *          This is only valid when event == PTP_CLK_REQ_EXTTS.
+ * @perout: describes configuration for periodic output.
+ *	    This is only valid when event == PTP_CLK_REQ_PEROUT.
+ */
 
 struct ptp_clock_request {
 	enum {
-- 
2.29.2

