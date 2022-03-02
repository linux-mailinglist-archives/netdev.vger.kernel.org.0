Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21EC4CB162
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiCBVgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiCBVfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:51 -0500
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4300A4B412
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:07 -0800 (PST)
Received: (qmail 65807 invoked by uid 89); 2 Mar 2022 21:35:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 2 Mar 2022 21:35:06 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 5/5] docs: ABI: Document new timecard sysfs nodes.
Date:   Wed,  2 Mar 2022 13:34:59 -0800
Message-Id: <20220302213459.6565-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
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

Add documentation for the tod_correction, clock_status_drift,
and clock_status_offset nodes.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 Documentation/ABI/testing/sysfs-timecard | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-timecard b/Documentation/ABI/testing/sysfs-timecard
index 97f6773794a5..5bf78486a469 100644
--- a/Documentation/ABI/testing/sysfs-timecard
+++ b/Documentation/ABI/testing/sysfs-timecard
@@ -63,6 +63,18 @@ Description:	(RW) Contains the current synchronization source used by
 		the PHC.  May be changed by writing one of the listed
 		values from the available_clock_sources attribute set.
 
+What:		/sys/class/timecard/ocpN/clock_status_drift
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Contains the current drift value used by the firmware
+		for internal disciplining of the atomic clock.
+
+What:		/sys/class/timecard/ocpN/clock_status_offset
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Contains the current offset value used by the firmware
+		for internal disciplining of the atomic clock.
+
 What:		/sys/class/timecard/ocpN/gnss_sync
 Date:		September 2021
 Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
@@ -126,6 +138,16 @@ Description:	(RW) These attributes specify the direction of the signal
 		The 10Mhz reference clock input is currently only valid
 		on SMA1 and may not be combined with other destination sinks.
 
+What:		/sys/class/timecard/ocpN/tod_correction
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) The incoming GNSS signal is in UTC time, and the NMEA
+		format messages do not provide a TAI offset.  This sets the
+		correction value for the incoming time.
+
+		If UBX_LS is enabled, this should be 0, and the offset is
+		taken from the UBX-NAV-TIMELS message.
+
 What:		/sys/class/timecard/ocpN/ts_window_adjust
 Date:		September 2021
 Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
-- 
2.31.1

