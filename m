Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9606C8F75
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCYQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCYQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:33:08 -0400
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Mar 2023 09:33:05 PDT
Received: from bgl-iport-4.cisco.com (bgl-iport-4.cisco.com [72.163.197.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691971999;
        Sat, 25 Mar 2023 09:33:04 -0700 (PDT)
X-IPAS-Result: =?us-ascii?q?A0BDAADxIB9klxjFo0haHAECAgEHARQBBAQBgXwHAQwBg?=
 =?us-ascii?q?3gsEhgujHFfiRKCNYhFA4c6ij+CDQEBAQ0BAUQEAQE+AYoCJjQJDgECBAEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEDAQEFAQEBAgEHBBQBAQECAjgFDjeFdYcDCwEpHSZcAgk8C?=
 =?us-ascii?q?IJ+gigBAzEDsh8WBQIWgQGEcpkoChkoDWgDgWSBQQGENyOCaYQrhw44T4EVg?=
 =?us-ascii?q?TyCLIFTTYJxhXIEgiSWUwEDAgIDAgIDBgQCAgIFBAIBAwQCDgQOAwEBAgIBA?=
 =?us-ascii?q?QIECAICAwMCCA8TAwcCAQYFAQMBAgYEAgQBCwIFAgoBAgQBAgICAQUJAQMBA?=
 =?us-ascii?q?wELAgIHAgMFBgQCAw0CAQEDAgICDQMCAwIEAQUFAQEQAgYEBwEGAwsCBAEEA?=
 =?us-ascii?q?wECBQcDBgMCAgICCAQSAgMCAgQFAgICAQIEBQIHBgIBAgICBAIBAwIEAgIEA?=
 =?us-ascii?q?gIEAxEKAgMFAw4CAgICAQkLAgMHBAIDAwEHAgIMAQMYAwICAgICAgEDBwoEC?=
 =?us-ascii?q?wIFAQIBBAsBBQENBAICAgICAwIBAQMGCAYDCgIFBAMDBgkPDwgFAwEEAwIDA?=
 =?us-ascii?q?gEICwIDAgIECAIDAQICAQYCAwECAgECAgELAQECAwUCAhEBAgICAgIBAQIDA?=
 =?us-ascii?q?gMBBwECAhwGBAUDAwQCAgEEAQICBAQFCwIEAwEBAQICAgIDAgsDBQMBBgMDC?=
 =?us-ascii?q?gcEAQgCBgMEAgUEAwQEBgICAgICAQQBBAoDAgQEAwMGAwkCAgwCFAISBgEEC?=
 =?us-ascii?q?wsEAQICAg0DBAYCAwMCBQgEAgICAgIDBgIHBAICAwMCAgMDBwMBAgICAwEEB?=
 =?us-ascii?q?QYDAgQCAQMCBAICBAMEAQcCAgICAwECAgMDAQIBBgMCAgUCAgEIAgMCAgICA?=
 =?us-ascii?q?wMOAQEBAgoCAwEBAQUEAgIEBAQEAQICAgICDAMCAgIDAgQDAgIDEgMCBQIED?=
 =?us-ascii?q?AECBAICBwICAgICAgICAQICAgIDBQQCAQIDAwIEBQMDAgIDAgIFAQMEAQcEA?=
 =?us-ascii?q?gIGAwIFBgICBQEDBAECAhIDAwMCAgIBAgEBAgMHCQYCCQQBBhIDAwIEAgcDA?=
 =?us-ascii?q?gIEAgIBAgoCAgMCAgICAgQCCAIFBQIoAwMCIAMJAwcFSQIJAyMPAwsJCAcMA?=
 =?us-ascii?q?RYoBgwHDCgENAEUEgcHBioOBgIGAwQBCgsFBAUIAQIBAQYCBAIHCQwCAQYBB?=
 =?us-ascii?q?QICAwIBAwICAQYDAQICAgIFCgMEBQMKCQMBAQQDAgECAQIDAgMHAwIEAgMBA?=
 =?us-ascii?q?gMEBgYBCQQGBQ0DBAICAQIBAQMEBAQCAgECAgMBBAICAQEDAwMCAgIDBAIDA?=
 =?us-ascii?q?wsECgcEAgEFCwQCAwIBAQMHCQQCAgYBAgQCAgICAgIDAQEDCQQCAQMCAgQDB?=
 =?us-ascii?q?gIBAgEJBQIBCQMBAgEDBAEDCQECAgQJAgQHBQoCAgICCAICDgMDAgEBBAICB?=
 =?us-ascii?q?AUJAQIHAgUBAQMFBwICAQICAQQDAQkEAQIDAgEBAxIDAwEEAgUDAw0JBgICA?=
 =?us-ascii?q?QMCAQ0DAQIBAgMBBQUXAwgHFAMFAgIEBAEHAgIDAwMCAQIJBgEDAQUCDgMCA?=
 =?us-ascii?q?gQGAQIBAQIDEAUBAQEBFwEDBAIDAQQDAQECAQIDDwQBBAUMAxAMAgQBBgIIA?=
 =?us-ascii?q?gIDAwECAwUBAgMEAgEICgICAgIJAgoDAgMBAwUBAwIJAwEFAQIHAgYBAQECA?=
 =?us-ascii?q?ggCCAIDCwEDBQYCAgEFAgECAgUDBQICAgIEDQIFAgICBQECBwQCAgIDAQICB?=
 =?us-ascii?q?gUBAgcHAgUCAgIDAwoEBAcEAQICAQEFAQIBAwMBBAECAQIFAwYCAgICAQICA?=
 =?us-ascii?q?QEBCAICAgICAgMEAgiaWgIBgmeBDk53lAmDI4tTgheBM51TZQpkgyCaf4VtG?=
 =?us-ascii?q?jKpPgEulzyRPpIHhCwCBAYFAhY1gS46gVtNI4EBgjZSGQ+OLBaTUTk0OwIHC?=
 =?us-ascii?q?wEBAwmLQwEB?=
IronPort-Data: A9a23:0EAvwqrkq0o1/4gnT+6fdO79NNdeBmIFZRIvgKrLsJaIsI4StFCzt
 garIBnXOPmMYDPxfN52a4qy8UwAuJLTy9RnTgJpqX03F3sS8OPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7xdOCn9xGQ7InQLlbGILas1htZGEk1GE/NtTo5w7Ri2tUy3IDga++wk
 YqaT/P3aQfNNwFcagr424rbwP+4lK2v0N+wlgVWicFj5DcypVFMZH4sDf3Zw0/Df2VhNrXSq
 9AvY12O1jixEx8FUrtJm1tgG6EAaua60QOm0hK6V0U+6/RPjnRa70o1CBYTQXwUth+wlu1z8
 sgOuLXrbTYvF4TdyM1IBnG0EwkmVUFH0LXIJT20ttaeiheAeHr3yPIoB0YzVWEa0rktRzgQr
 rpBeW9LNEzra+GemNpXTsF3hsUlMcLrNasUu2prynfSCvNOrZXrEvyUu4UIhl/cgOhcH/nva
 O0/dgBgdRSdU0IUK0UHM6MHybLAan7XKm0E9w39SbAMy27e0AB8zpDzP9fPPN+HX8NYmgCfv
 G2u12D4BAwKcd+S0zyI9lqyieLV2yD2QoQfEPu/7PECqEbP3XELBQcLTlahifa8g0+6HdlYL
 iQ84CslraEo+EesRdnnVhuQr3uNvxpaUN1Ve9DW8ymTzqONsljcAGEYCDVAc9ch8sQxQFTGy
 2NlgfvSRgFFibSoS0iAtbq99heDPwE8PD8rMHpsoRQ+3/Hvp4Q6jxTqR9llEbKogtCdJQwc0
 wxmvwBl2+1O0ZJjO7GTuAme02jw+sChohsdv12PBgqYAhVFiJlJjmBEBF6y0BqtBJidRwDQ4
 j0CktTY5+EVBpbLnyuIKAnsIF1Lz6reWNE/qQc+d3XEy9hK0yT5Fb28GBkkeC9U3j8sIFcFm
 nP7twJL/4N0N3C3d6JxaI/ZI510kvm+RY66DaGPMIYmjn1NmOmvoX8Giam4gj6FraTQufpX1
 WqzKJz1Vi9KVcyLMhLmHbx1PUAXKtAWnDOPGs+TI+WP2ruFb3ndUqYeLFaLdYgEAFCs/m3oH
 yJkH5LSkX13CbSmCgGOqNJ7ELz/BSVibXwAg5cMLbDrz8sPMDxJNsI9Npt7JdE5xP4LyrqgE
 7PUchYw9WcTTEbvcW2iAk2Popu2NXqjhRrX5RARAGs=
IronPort-HdrOrdr: A9a23:ho18GKltddupuPIrcXtebZNEJtLpDfIn3DAbv31ZSRFFG/FwWf
 rAoB19726QtN9/YhAdcLy7VZVoIkmsl6Kdn7NwAV7KZmCP0wGVxepZg7cKrQeNJ8SHzJ8/6U
 +lGJIOb+EZyjNB/KLH3DU=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.98,290,1673913600"; 
   d="scan'208";a="9166282"
Received: from vla196-nat.cisco.com (HELO bgl-core-2.cisco.com) ([72.163.197.24])
  by bgl-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 25 Mar 2023 16:31:57 +0000
Received: from bgl-ads-3583.cisco.com (bgl-ads-3583.cisco.com [173.39.60.220])
        by bgl-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id 32PGVv3Z003744
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 25 Mar 2023 16:31:57 GMT
Received: by bgl-ads-3583.cisco.com (Postfix, from userid 1784405)
        id 002E5CC1296; Sat, 25 Mar 2023 22:01:56 +0530 (IST)
From:   Shinu Chandran <s4superuser@gmail.com>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shinu Chandran <s4superuser@gmail.com>
Subject: [PATCH] ptp: ptp_clock: Fix coding style issues
Date:   Sat, 25 Mar 2023 22:01:35 +0530
Message-Id: <20230325163135.2431367-1-s4superuser@gmail.com>
X-Mailer: git-send-email 2.35.6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 173.39.60.220, bgl-ads-3583.cisco.com
X-Outbound-Node: bgl-core-2.cisco.com
X-Spam-Status: No, score=2.7 required=5.0 tests=DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_PASS,
        SPF_NONE,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed coding style issues

Signed-off-by: Shinu Chandran <s4superuser@gmail.com>
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

