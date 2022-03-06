Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E174CEA1C
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiCFI6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiCFI6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:34 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E18E1EECA
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:41 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id dr20so25959892ejc.6
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GfSSb7+i0bqUTwc6AvkcGUVXMXbSZgE8tY3iI0Vn6+g=;
        b=5Hls2rNMYZWcLT6eOhIgaXZ5BLGZPhTevMdqAl+kS4EUjlLI63sv5JniGokNdLHJGu
         1cxVIqieQRiOWgPcSRPam6JQRank6lrE0SUmQAVhxxPadiQlX7uohrxm+eF06w+r4cw2
         YzomAsKS4iO2TJKTDNMoQA/JboH3YJG022XSWhCIKEL9ZwUHcyxj6c1Edn8/N+YiQc90
         bUzLaWzRg2d4VC29SGBc5OI9X/HWkAwhiu7HpNnKOM3BP9pVvt1DpKyyVnGfLKgonrZc
         Yc/wlt2Jae5239SqGEOP2Y65bnRurOoaD5uUbEIw1HmQRhmFSqWRwIJmeThnbjov6+fh
         KcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfSSb7+i0bqUTwc6AvkcGUVXMXbSZgE8tY3iI0Vn6+g=;
        b=wmAmxKKgNL+yy72kzRf3mCaCJoYZWbYTCXMKqbY+JJVLw6qFNyMbIp3nn99C3jI0T8
         Ywv/dKlFOHysk32MzQxHLcPGZB5PxaBrbzzNWxdbOtMTzTmr30PVunKAIKhuzMdK1nfz
         xEUKFqIR4o4bnt0TOZg0qLSa7bnVdKqZ/eZHFctGJP9XXD2ra6ZuEwQsLSCuG4tRYxb+
         JEYm6xzoPjc084PHEkLyDfJrtIec8tVkrmZUOYtG1fxBA+tcMUQwudtHiU/Jn2dQ62TC
         T7721k8GWNM/C4WRgnlnxbb1jFOeNmS8hqTHrZpBziD4xjsKId75yD6s19388+67en7J
         s9lQ==
X-Gm-Message-State: AOAM533+XLotv63iO0VlVBpIlbUlft9Xxc0sCrXo/swJnLBubFuZEPzS
        9U6C+n2L5dmstJtgDba8OgCqwWD/hSm/PJi4
X-Google-Smtp-Source: ABdhPJxHU0G0abWFZ6vnrH+UGN1QQ4hBY0QNNmCp7v6GE9ORU9Q0DcQCVMjNQgvONVUqVjkqo8WEfg==
X-Received: by 2002:a17:906:7852:b0:5bb:1bdb:e95f with SMTP id p18-20020a170906785200b005bb1bdbe95fmr5289735ejm.435.1646557059769;
        Sun, 06 Mar 2022 00:57:39 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:39 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 3/6] ptp: Add free running time support
Date:   Sun,  6 Mar 2022 09:56:55 +0100
Message-Id: <20220306085658.1943-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp vclocks require a clock with free running time for the timecounter.
Currently only a physical clock forced to free running is supported.
If vclocks are used, then the physical clock cannot be synchronized
anymore. The synchronized time is not available in hardware in this
case. As a result, timed transmission with ETF/TAPRIO hardware support
is not possible anymore.

If hardware would support a free running time additionally to the
physical clock, then the physical clock does not need to be forced to
free running. Thus, the physical clocks can still be synchronized while
vclocks are in use.

The physical clock could be used to synchronize the time domain of the
TSN network and trigger ETF/TAPRIO. In parallel vclocks can be used to
synchronize other time domains.

Allow read and cross time stamp of additional free running time for
physical clocks. Let vclocks use free running time if available.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_vclock.c         | 20 +++++++++++++++-----
 include/linux/ptp_clock_kernel.h | 27 +++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index cb179a3ea508..3715d75ee8bd 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -68,7 +68,10 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	int err;
 	u64 ns;
 
-	err = pptp->info->gettimex64(pptp->info, &pts, sts);
+	if (pptp->info->getfreeruntimex64)
+		err = pptp->info->getfreeruntimex64(pptp->info, &pts, sts);
+	else
+		err = pptp->info->gettimex64(pptp->info, &pts, sts);
 	if (err)
 		return err;
 
@@ -104,7 +107,10 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	int err;
 	u64 ns;
 
-	err = pptp->info->getcrosststamp(pptp->info, xtstamp);
+	if (pptp->info->getfreeruncrosststamp)
+		err = pptp->info->getfreeruncrosststamp(pptp->info, xtstamp);
+	else
+		err = pptp->info->getcrosststamp(pptp->info, xtstamp);
 	if (err)
 		return err;
 
@@ -143,7 +149,9 @@ static u64 ptp_vclock_read(const struct cyclecounter *cc)
 	struct ptp_clock *ptp = vclock->pclock;
 	struct timespec64 ts = {};
 
-	if (ptp->info->gettimex64)
+	if (ptp->info->getfreeruntimex64)
+		ptp->info->getfreeruntimex64(ptp->info, &ts, NULL);
+	else if (ptp->info->gettimex64)
 		ptp->info->gettimex64(ptp->info, &ts, NULL);
 	else
 		ptp->info->gettime64(ptp->info, &ts);
@@ -168,11 +176,13 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	vclock->pclock = pclock;
 	vclock->info = ptp_vclock_info;
-	if (pclock->info->gettimex64)
+	if (pclock->info->getfreeruntimex64 || pclock->info->gettimex64)
 		vclock->info.gettimex64 = ptp_vclock_gettimex;
 	else
 		vclock->info.gettime64 = ptp_vclock_gettime;
-	if (pclock->info->getcrosststamp)
+	if ((pclock->info->getfreeruntimex64 &&
+	     pclock->info->getfreeruncrosststamp) ||
+	    pclock->info->getcrosststamp)
 		vclock->info.getcrosststamp = ptp_vclock_getcrosststamp;
 	vclock->cc = ptp_vclock_cc;
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 554454cb8693..b291517fc7c8 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -108,6 +108,28 @@ struct ptp_system_timestamp {
  * @settime64:  Set the current time on the hardware clock.
  *              parameter ts: Time value to set.
  *
+ * @getfreeruntimex64:  Reads the current free running time from the hardware
+ *                      clock and optionally also the system clock. This
+ *                      operation requires hardware support for an additional
+ *                      free running time including support for hardware time
+ *                      stamps based on that free running time.
+ *                      The free running time must be completely independet from
+ *                      the actual time of the PTP clock. It must be monotonic
+ *                      and its frequency must be constant.
+ *                      parameter ts: Holds the PHC free running timestamp.
+ *                      parameter sts: If not NULL, it holds a pair of
+ *                      timestamps from the system clock. The first reading is
+ *                      made right before reading the lowest bits of the PHC
+ *                      free running timestamp and the second reading
+ *                      immediately follows that.
+ *
+ * @getfreeruncrosststamp:  Reads the current time from the free running
+ *                          hardware clock and system clock simultaneously.
+ *                          parameter cts: Contains timestamp (device,system)
+ *                          pair, where device time is the free running time
+ *                          also used for @getfreeruntimex64 and system time is
+ *                          realtime and monotonic.
+ *
  * @enable:   Request driver to enable or disable an ancillary feature.
  *            parameter request: Desired resource to enable or disable.
  *            parameter on: Caller passes one to enable or zero to disable.
@@ -155,6 +177,11 @@ struct ptp_clock_info {
 	int (*getcrosststamp)(struct ptp_clock_info *ptp,
 			      struct system_device_crosststamp *cts);
 	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
+	int (*getfreeruntimex64)(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts,
+				 struct ptp_system_timestamp *sts);
+	int (*getfreeruncrosststamp)(struct ptp_clock_info *ptp,
+				     struct system_device_crosststamp *cts);
 	int (*enable)(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *request, int on);
 	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
-- 
2.20.1

