Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ACF6C8F82
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjCYQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjCYQmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:42:51 -0400
Received: from bgl-iport-3.cisco.com (bgl-iport-3.cisco.com [72.163.197.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0179EC42;
        Sat, 25 Mar 2023 09:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1564; q=dns/txt; s=iport;
  t=1679762570; x=1680972170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jXwmHBkZwD6FXbeoybFbsEbinYtApBspwJP2EDwlSEo=;
  b=aVp2u7qsvs5HgdTt4QdXSulZ5Rnofx9xYdWzmzJMhHtMqOoks9ptGjjD
   9HdJlK05jpe3Y3dy1/10zW8cJczaLQWCCkhpGrd1FpVMyMp/6vm7Ll7Vn
   CMjsj1CAoyNuqtZIQKIlRLfWodeBUh+OOWGPpOPElxkWlXOFWBS2lYpP2
   M=;
X-IronPort-AV: E=Sophos;i="5.98,290,1673913600"; 
   d="scan'208";a="9163683"
Received: from vla196-nat.cisco.com (HELO bgl-core-3.cisco.com) ([72.163.197.24])
  by bgl-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 25 Mar 2023 16:42:46 +0000
Received: from bgl-ads-3583.cisco.com (bgl-ads-3583.cisco.com [173.39.60.220])
        by bgl-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 32PGgkFr013150
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 25 Mar 2023 16:42:46 GMT
Received: by bgl-ads-3583.cisco.com (Postfix, from userid 1784405)
        id 618CCCC1296; Sat, 25 Mar 2023 22:12:46 +0530 (IST)
From:   Shinu Chandran <shinucha@cisco.com>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shinu Chandran <shinucha@cisco.com>
Subject: [PATCH] ptp: ptp_clock: Fix coding style issues in ptp_clock
Date:   Sat, 25 Mar 2023 22:12:32 +0530
Message-Id: <20230325164232.2434190-1-shinucha@cisco.com>
X-Mailer: git-send-email 2.35.6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 173.39.60.220, bgl-ads-3583.cisco.com
X-Outbound-Node: bgl-core-3.cisco.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,
        SPF_NONE,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed coding style issues in ptp_clock.c

Signed-off-by: Shinu Chandran <shinucha@cisco.com>
---
 drivers/ptp/ptp_clock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 62d4d29e7c05..8fe7f2ce9705 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -129,6 +129,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		err = ops->adjtime(ops, delta);
 	} else if (tx->modes & ADJ_FREQUENCY) {
 		long ppb = scaled_ppm_to_ppb(tx->freq);
+
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		err = ops->adjfine(ops, tx->freq);
@@ -278,11 +279,13 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	/* Register a new PPS source. */
 	if (info->pps) {
 		struct pps_source_info pps;
+
 		memset(&pps, 0, sizeof(pps));
 		snprintf(pps.name, PPS_MAX_NAME_LEN, "ptp%d", index);
 		pps.mode = PTP_PPS_MODE;
 		pps.owner = info->owner;
 		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
+
 		if (IS_ERR(ptp->pps_source)) {
 			err = PTR_ERR(ptp->pps_source);
 			pr_err("failed to register pps source\n");
@@ -347,9 +350,8 @@ static int unregister_vclock(struct device *dev, void *data)
 
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
-	if (ptp_vclock_in_use(ptp)) {
+	if (ptp_vclock_in_use(ptp))
 		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
-	}
 
 	ptp->defunct = 1;
 	wake_up_interruptible(&ptp->tsev_wq);
-- 
2.35.6

