Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0252DF23
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbiESVWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiESVWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:06 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F2ED8E9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:04 -0700 (PDT)
Received: (qmail 42787 invoked by uid 89); 19 May 2022 21:22:02 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 19 May 2022 21:22:02 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 06/10] ptp: ocp: constify selectors
Date:   Thu, 19 May 2022 14:21:49 -0700
Message-Id: <20220519212153.450437-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
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

The ocp selectors are all constant, so label them as such.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 26f7830388b0..e3269dc79b42 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -648,7 +648,7 @@ struct ocp_selector {
 	int value;
 };
 
-static struct ocp_selector ptp_ocp_clock[] = {
+static const struct ocp_selector ptp_ocp_clock[] = {
 	{ .name = "NONE",	.value = 0 },
 	{ .name = "TOD",	.value = 1 },
 	{ .name = "IRIG",	.value = 2 },
@@ -665,7 +665,7 @@ static struct ocp_selector ptp_ocp_clock[] = {
 #define SMA_SELECT_MASK		((1U << 15) - 1)
 #define SMA_DISABLE		0x10000
 
-static struct ocp_selector ptp_ocp_sma_in[] = {
+static const struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "10Mhz",	.value = 0x0000 },
 	{ .name = "PPS1",	.value = 0x0001 },
 	{ .name = "PPS2",	.value = 0x0002 },
@@ -683,7 +683,7 @@ static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ }
 };
 
-static struct ocp_selector ptp_ocp_sma_out[] = {
+static const struct ocp_selector ptp_ocp_sma_out[] = {
 	{ .name = "10Mhz",	.value = 0x0000 },
 	{ .name = "PHC",	.value = 0x0001 },
 	{ .name = "MAC",	.value = 0x0002 },
@@ -700,12 +700,12 @@ static struct ocp_selector ptp_ocp_sma_out[] = {
 	{ }
 };
 
-static struct ocp_selector *ocp_sma_tbl[][2] = {
+static const struct ocp_selector *ocp_sma_tbl[][2] = {
 	{ ptp_ocp_sma_in, ptp_ocp_sma_out },
 };
 
 static const char *
-ptp_ocp_select_name_from_val(struct ocp_selector *tbl, int val)
+ptp_ocp_select_name_from_val(const struct ocp_selector *tbl, int val)
 {
 	int i;
 
@@ -716,7 +716,7 @@ ptp_ocp_select_name_from_val(struct ocp_selector *tbl, int val)
 }
 
 static int
-ptp_ocp_select_val_from_name(struct ocp_selector *tbl, const char *name)
+ptp_ocp_select_val_from_name(const struct ocp_selector *tbl, const char *name)
 {
 	const char *select;
 	int i;
@@ -730,7 +730,7 @@ ptp_ocp_select_val_from_name(struct ocp_selector *tbl, const char *name)
 }
 
 static ssize_t
-ptp_ocp_select_table_show(struct ocp_selector *tbl, char *buf)
+ptp_ocp_select_table_show(const struct ocp_selector *tbl, char *buf)
 {
 	ssize_t count;
 	int i;
@@ -2093,7 +2093,8 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
  */
 
 static ssize_t
-ptp_ocp_show_output(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
+ptp_ocp_show_output(const struct ocp_selector *tbl, u32 val, char *buf,
+		    int def_val)
 {
 	const char *name;
 	ssize_t count;
@@ -2107,7 +2108,8 @@ ptp_ocp_show_output(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
 }
 
 static ssize_t
-ptp_ocp_show_inputs(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
+ptp_ocp_show_inputs(const struct ocp_selector *tbl, u32 val, char *buf,
+		    int def_val)
 {
 	const char *name;
 	ssize_t count;
@@ -2131,7 +2133,7 @@ ptp_ocp_show_inputs(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
 }
 
 static int
-sma_parse_inputs(struct ocp_selector *tbl[], const char *buf,
+sma_parse_inputs(const struct ocp_selector * const tbl[], const char *buf,
 		 enum ptp_ocp_sma_mode *mode)
 {
 	int idx, count, dir;
@@ -2192,7 +2194,7 @@ ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
 		 int default_in_val, int default_out_val)
 {
 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
-	struct ocp_selector **tbl;
+	const struct ocp_selector * const *tbl;
 	u32 val;
 
 	tbl = ocp_sma_tbl[bp->sma_tbl];
-- 
2.31.1

