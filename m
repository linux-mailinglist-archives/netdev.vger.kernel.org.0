Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252C3D7AFA
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfJOQQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:16:06 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:54567 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfJOQQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:16:06 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKPUO-00085Y-4m; Tue, 15 Oct 2019 17:16:00 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKPUN-0004pH-GJ; Tue, 15 Oct 2019 17:15:59 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] davinci_cpdma: make cpdma_chan_split_pool static
Date:   Tue, 15 Oct 2019 17:15:58 +0100
Message-Id: <20191015161558.18506-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cpdma_chan_split_pool() function is not used outside of
the driver, so make it static to avoid the following sparse
warning:

drivers/net/ethernet/ti/davinci_cpdma.c:725:5: warning: symbol 'cpdma_chan_split_pool' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-omap@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index a65edd2770e6..37ba708ac781 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -722,7 +722,7 @@ static void cpdma_chan_set_descs(struct cpdma_ctlr *ctlr,
  * cpdma_chan_split_pool - Splits ctrl pool between all channels.
  * Has to be called under ctlr lock
  */
-int cpdma_chan_split_pool(struct cpdma_ctlr *ctlr)
+static int cpdma_chan_split_pool(struct cpdma_ctlr *ctlr)
 {
 	int tx_per_ch_desc = 0, rx_per_ch_desc = 0;
 	int free_rx_num = 0, free_tx_num = 0;
-- 
2.23.0

