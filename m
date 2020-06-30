Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAE620F417
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbgF3MCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:02:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35550 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgF3MCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:02:39 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DD92860081;
        Tue, 30 Jun 2020 12:02:38 +0000 (UTC)
Received: from us4-mdac16-46.ut7.mdlocal (unknown [10.7.66.13])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DC300200A0;
        Tue, 30 Jun 2020 12:02:38 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.39])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6DDB71C0057;
        Tue, 30 Jun 2020 12:02:38 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2735F8007A;
        Tue, 30 Jun 2020 12:02:38 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:02:33 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 01/14] sfc: move NIC-specific mcdi_port declarations
 out of common header
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <ed79646e-3c0e-a3ee-dac2-a86a5b5c257e@solarflare.com>
Date:   Tue, 30 Jun 2020 13:02:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-1.958700-8.000000-10
X-TMASE-MatchedRID: YwWjki3vT3U5NXlWWXBFjkjBb8q+S/OCL3CpqoxHGN4KQo6lRC5cFa6P
        KQSZCnDq8XVI39JCRnSjfNAVYAJRAs11iH9zkl9ET7O/YHJhINBLXPA26IG0hN9RlPzeVuQQIg8
        BFa7OCtzWOjFTe37S5JTGiAZtLnco+Dh1wKIt5dAHtOpEBhWiFpKLNrbpy/A0RwQM92B8ku7i0n
        VT9rWZ+SKq+ucuBo9XbOo++6sx6CR09yt1Yp3gnw97mDMXdNW381hDEI6KFM2/md2adk3dRD/IJ
        /33MGoxv9iQKTTStm13oCF5IgP2qU1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFNYSs
        j5NFs1pOV74QZful4OGVC4YQOuzF7LBrvg6H4rA/0NltFWkF3useU1RrPGHwtZW33XObJNA1KL9
        7I8kLu8nchi6+KxM7WswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eWeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.958700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593518558-aLUVXWPt5EfM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are implemented in mcdi_port.c, which will not be linked
 into the EF100 driver; thus their prototypes should not be visible in
 common header files.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c      |  1 +
 drivers/net/ethernet/sfc/mcdi.h      |  4 ----
 drivers/net/ethernet/sfc/mcdi_port.c |  1 +
 drivers/net/ethernet/sfc/mcdi_port.h | 18 ++++++++++++++++++
 drivers/net/ethernet/sfc/siena.c     |  1 +
 5 files changed, 21 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port.h

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index efc49869320f..a3bf9d8023d7 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -10,6 +10,7 @@
 #include "io.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
+#include "mcdi_port.h"
 #include "mcdi_port_common.h"
 #include "mcdi_functions.h"
 #include "nic.h"
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index db9746a751d4..10f064f761a5 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -354,15 +354,11 @@ int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out);
 int efx_mcdi_wol_filter_remove(struct efx_nic *efx, int id);
 int efx_mcdi_wol_filter_reset(struct efx_nic *efx);
 int efx_mcdi_flush_rxqs(struct efx_nic *efx);
-int efx_mcdi_port_probe(struct efx_nic *efx);
-void efx_mcdi_port_remove(struct efx_nic *efx);
 int efx_mcdi_port_reconfigure(struct efx_nic *efx);
-u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
 void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
 void efx_mcdi_mac_start_stats(struct efx_nic *efx);
 void efx_mcdi_mac_stop_stats(struct efx_nic *efx);
 void efx_mcdi_mac_pull_stats(struct efx_nic *efx);
-bool efx_mcdi_mac_check_fault(struct efx_nic *efx);
 enum reset_type efx_mcdi_map_reset_reason(enum reset_type reason);
 int efx_mcdi_reset(struct efx_nic *efx, enum reset_type method);
 int efx_mcdi_set_workaround(struct efx_nic *efx, u32 type, bool enabled,
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index b807871d8f69..212ff80e923b 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -10,6 +10,7 @@
 
 #include <linux/slab.h>
 #include "efx.h"
+#include "mcdi_port.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
 #include "nic.h"
diff --git a/drivers/net/ethernet/sfc/mcdi_port.h b/drivers/net/ethernet/sfc/mcdi_port.h
new file mode 100644
index 000000000000..07863ddbe740
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_port.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2008-2013 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ */
+
+#ifndef EFX_MCDI_PORT_H
+#define EFX_MCDI_PORT_H
+
+#include "net_driver.h"
+
+u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
+bool efx_mcdi_mac_check_fault(struct efx_nic *efx);
+int efx_mcdi_port_probe(struct efx_nic *efx);
+void efx_mcdi_port_remove(struct efx_nic *efx);
+
+#endif /* EFX_MCDI_PORT_H */
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 6462bbe2448a..ffe193f03352 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -21,6 +21,7 @@
 #include "workarounds.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
+#include "mcdi_port.h"
 #include "mcdi_port_common.h"
 #include "selftest.h"
 #include "siena_sriov.h"

