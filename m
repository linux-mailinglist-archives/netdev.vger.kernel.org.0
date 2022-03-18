Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCDD4DD365
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiCRDCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiCRDCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:02:01 -0400
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A81F47E5;
        Thu, 17 Mar 2022 20:00:40 -0700 (PDT)
Received: from excmbx-17.um.gwdg.de ([134.76.9.228] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <alexander.vorwerk@stud.uni-goettingen.de>)
        id 1nV2r0-000Eop-2n; Fri, 18 Mar 2022 04:00:38 +0100
Received: from notebook.fritz.box (10.250.9.199) by excmbx-17.um.gwdg.de
 (134.76.9.228) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2375.24; Fri, 18
 Mar 2022 04:00:37 +0100
From:   Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <stf_xl@wp.pl>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Subject: [PATCH] iwlegacy: 4965-rs: remove three unused variables
Date:   Fri, 18 Mar 2022 04:00:25 +0100
Message-ID: <20220318030025.12890-1-alexander.vorwerk@stud.uni-goettingen.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.250.9.199]
X-ClientProxiedBy: excmbx-11.um.gwdg.de (134.76.9.220) To excmbx-17.um.gwdg.de
 (134.76.9.228)
X-Virus-Scanned: (clean) by clamav
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following warnings showed up when compiling with W=1.

drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_stay_in_table’:
drivers/net/wireless/intel/iwlegacy/4965-rs.c:1636:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
  struct il_priv *il;
                  ^~
drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_alloc_sta’:
drivers/net/wireless/intel/iwlegacy/4965-rs.c:2257:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
  struct il_priv *il;
                  ^~
drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_sta_dbgfs_scale_table_write’:
drivers/net/wireless/intel/iwlegacy/4965-rs.c:2535:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
  struct il_priv *il;
                  ^~

Fixing by removing the variables.

Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 9a491e5db75b..5e4110a1e644 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -1633,9 +1633,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 	int i;
 	int active_tbl;
 	int flush_interval_passed = 0;
-	struct il_priv *il;
 
-	il = lq_sta->drv;
 	active_tbl = lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
@@ -2254,9 +2252,7 @@ il4965_rs_alloc_sta(void *il_rate, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct il_station_priv *sta_priv =
 	    (struct il_station_priv *)sta->drv_priv;
-	struct il_priv *il;
 
-	il = (struct il_priv *)il_rate;
 	D_RATE("create station rate scale win\n");
 
 	return &sta_priv->lq_sta;
@@ -2532,12 +2528,10 @@ il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct il_lq_sta *lq_sta = file->private_data;
-	struct il_priv *il;
 	char buf[64];
 	size_t buf_size;
 	u32 parsed_rate;
 
-	il = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
-- 
2.17.1

