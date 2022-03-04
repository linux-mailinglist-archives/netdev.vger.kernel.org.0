Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6114E4CCD68
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiCDFrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiCDFrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:47:04 -0500
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFAE179A17
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:46:17 -0800 (PST)
Received: (qmail 47352 invoked by uid 89); 4 Mar 2022 05:46:16 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 4 Mar 2022 05:46:16 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [RESEND PATCH net-next] ptp: ocp: Add serial port information to the debug summary
Date:   Thu,  3 Mar 2022 21:46:15 -0800
Message-Id: <20220304054615.1737-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the debug summary page, show the /dev/ttyS<port> mapping.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index cfe744b80407..5e3e06acaf87 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2109,6 +2109,14 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	sma_out = ioread32(&bp->sma->gpio2);
 
 	seq_printf(s, "%7s: /dev/ptp%d\n", "PTP", ptp_clock_index(bp->ptp));
+	if (bp->gnss_port != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS1", bp->gnss_port);
+	if (bp->gnss2_port != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS2", bp->gnss2_port);
+	if (bp->mac_port != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "MAC", bp->mac_port);
+	if (bp->nmea_port != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "NMEA", bp->nmea_port);
 
 	sma1_show(dev, NULL, buf);
 	seq_printf(s, "   sma1: %s", buf);
-- 
2.31.1

