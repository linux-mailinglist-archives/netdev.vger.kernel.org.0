Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7652E4D5300
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244874AbiCJUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244776AbiCJUUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:20 -0500
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99D317FD0E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:18 -0800 (PST)
Received: (qmail 45314 invoked by uid 89); 10 Mar 2022 20:19:17 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 10 Mar 2022 20:19:17 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 03/10] ptp: ocp: Rename output selector 'GNSS' to 'GNSS1'
Date:   Thu, 10 Mar 2022 12:19:05 -0800
Message-Id: <20220310201912.933172-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As there are may be 2 GNSS outputs, rename the first one for clarity.
This also works around a parsing issue when specifying selectors.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 53b11c7f8fa0..c85ba3812b25 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -339,7 +339,7 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
  * 0: TS3 (and PPS)
  * 1: TS0
  * 2: TS1
- * 3: GNSS
+ * 3: GNSS1
  * 4: GNSS2
  * 5: MAC
  * 6: TS2
@@ -540,7 +540,7 @@ static struct ocp_selector ptp_ocp_sma_out[] = {
 	{ .name = "10Mhz",	.value = 0x00 },
 	{ .name = "PHC",	.value = 0x01 },
 	{ .name = "MAC",	.value = 0x02 },
-	{ .name = "GNSS",	.value = 0x04 },
+	{ .name = "GNSS1",	.value = 0x04 },
 	{ .name = "GNSS2",	.value = 0x08 },
 	{ .name = "IRIG",	.value = 0x10 },
 	{ .name = "DCF",	.value = 0x20 },
@@ -2288,7 +2288,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->ts0) {
 		ts_reg = bp->ts0->mem;
 		on = ioread32(&ts_reg->enable);
-		src = "GNSS";
+		src = "GNSS1";
 		seq_printf(s, "%7s: %s, src: %s\n", "TS0",
 			   on ? " ON" : "OFF", src);
 	}
@@ -2371,7 +2371,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 		else if (val & 0x02)
 			src = "MAC";
 		else if (val & 0x04)
-			src = "GNSS";
+			src = "GNSS1";
 		else
 			src = "----";
 	} else {
-- 
2.31.1

