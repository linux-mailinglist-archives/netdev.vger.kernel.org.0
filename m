Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D429C20722E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390677AbgFXLfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:35:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48498 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389234AbgFXLex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:53 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 394B41A0219;
        Wed, 24 Jun 2020 13:34:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2DA1D1A01F2;
        Wed, 24 Jun 2020 13:34:52 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EB8EE2047A;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] dpaa2-eth: fix recursive header include
Date:   Wed, 24 Jun 2020 14:34:20 +0300
Message-Id: <20200624113421.17360-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-eth.h header file includes dpaa2-eth-trace.h which includes
back dpaa2-eth leading to a recursion in the include path. Fix this by
removing the include of dpaa2-eth.h in the trace header.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
index 9801528db2a5..5fb5f14e01ec 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
@@ -10,7 +10,6 @@
 
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include "dpaa2-eth.h"
 #include <linux/tracepoint.h>
 
 #define TR_FMT "[%s] fd: addr=0x%llx, len=%u, off=%u"
-- 
2.25.1

