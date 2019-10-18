Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C541CDC310
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405188AbfJRKvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:51:33 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:54860 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfJRKvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 06:51:32 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iLPqz-00088O-RS; Fri, 18 Oct 2019 11:51:29 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iLPqz-00019R-Fp; Fri, 18 Oct 2019 11:51:29 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ptp_pch: include ethernet driver for external functions
Date:   Fri, 18 Oct 2019 11:51:28 +0100
Message-Id: <20191018105128.4382-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses a number of functions from the ethernet driver
so include the header to remove the following warnings from
sparse about undeclared functions:

drivers/ptp/ptp_pch.c:182:5: warning: symbol 'pch_ch_control_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:193:6: warning: symbol 'pch_ch_control_write' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:201:5: warning: symbol 'pch_ch_event_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:212:6: warning: symbol 'pch_ch_event_write' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:220:5: warning: symbol 'pch_src_uuid_lo_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:231:5: warning: symbol 'pch_src_uuid_hi_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:242:5: warning: symbol 'pch_rx_snap_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:259:5: warning: symbol 'pch_tx_snap_read' was not declared. Should it be static?
drivers/ptp/ptp_pch.c:300:5: warning: symbol 'pch_set_station_address' was not declared. Should it be static?

Should we include the header file from the ethernet driver directly
or if not, where should the declarations go?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/ptp/ptp_pch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index dcd6e00c8046..2bb1184b6359 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -20,6 +20,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/slab.h>
 
+#include <../net/ethernet/oki-semi/pch_gbe/pch_gbe.h>
+
 #define STATION_ADDR_LEN	20
 #define PCI_DEVICE_ID_PCH_1588	0x8819
 #define IO_MEM_BAR 1
-- 
2.23.0

