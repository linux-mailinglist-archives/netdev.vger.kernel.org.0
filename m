Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91284D5307
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245038AbiCJUUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244776AbiCJUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:29 -0500
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA1182BE5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:27 -0800 (PST)
Received: (qmail 76478 invoked by uid 89); 10 Mar 2022 20:19:26 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 10 Mar 2022 20:19:27 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 10/10] docs: ABI: Document new timecard sysfs nodes.
Date:   Thu, 10 Mar 2022 12:19:12 -0800
Message-Id: <20220310201912.933172-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
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

Add sysfs nodes for the frequency generator and signal counters.

Update SMA selector lists for these, and also add the new
'None', 'VCC' 'GND' selectors.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 Documentation/ABI/testing/sysfs-timecard | 94 +++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-timecard b/Documentation/ABI/testing/sysfs-timecard
index 5bf78486a469..220478156297 100644
--- a/Documentation/ABI/testing/sysfs-timecard
+++ b/Documentation/ABI/testing/sysfs-timecard
@@ -37,8 +37,15 @@ Description:	(RO) Set of available destinations (sinks) for a SMA
                 PPS2   signal is sent to the PPS2 selector
                 TS1    signal is sent to timestamper 1
                 TS2    signal is sent to timestamper 2
+                TS3    signal is sent to timestamper 3
+                TS4    signal is sent to timestamper 4
                 IRIG   signal is sent to the IRIG-B module
                 DCF    signal is sent to the DCF module
+                FREQ1  signal is sent to frequency counter 1
+                FREQ2  signal is sent to frequency counter 2
+                FREQ3  signal is sent to frequency counter 3
+                FREQ4  signal is sent to frequency counter 4
+                None   signal input is disabled
                 =====  ================================================
 
 What:		/sys/class/timecard/ocpN/available_sma_outputs
@@ -50,10 +57,16 @@ Description:	(RO) Set of available sources for a SMA output signal.
                 10Mhz  output is from the 10Mhz reference clock
                 PHC    output PPS is from the PHC clock
                 MAC    output PPS is from the Miniature Atomic Clock
-                GNSS   output PPS is from the GNSS module
+                GNSS1  output PPS is from the first GNSS module
                 GNSS2  output PPS is from the second GNSS module
                 IRIG   output is from the PHC, in IRIG-B format
                 DCF    output is from the PHC, in DCF format
+                GEN1   output is from frequency generator 1
+                GEN2   output is from frequency generator 2
+                GEN3   output is from frequency generator 3
+                GEN4   output is from frequency generator 4
+                GND    output is GND
+                VCC    output is VCC
                 =====  ================================================
 
 What:		/sys/class/timecard/ocpN/clock_source
@@ -75,6 +88,85 @@ Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
 Description:	(RO) Contains the current offset value used by the firmware
 		for internal disciplining of the atomic clock.
 
+What:		/sys/class/timecard/ocpN/freqX
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Optional directory containing the sysfs nodes for
+		frequency counter <X>.
+
+What:		/sys/class/timecard/ocpN/freqX/frequency
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Contains the measured frequency over the specified
+		measurement period.
+
+What:		/sys/class/timecard/ocpN/freqX/seconds
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) Specifies the number of seconds from 0-255 that the
+		frequency should be measured over.  Write 0 to disable.
+
+What:		/sys/class/timecard/ocpN/genX
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Optional directory containing the sysfs nodes for
+		frequency generator <X>.
+
+What:		/sys/class/timecard/ocpN/genX/duty
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Specifies the signal duty cycle as a percentage from 1-99.
+
+What:		/sys/class/timecard/ocpN/genX/period
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Specifies the signal period in nanoseconds.
+
+What:		/sys/class/timecard/ocpN/genX/phase
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Specifies the signal phase offset in nanoseconds.
+
+What:		/sys/class/timecard/ocpN/genX/polarity
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Specifies the signal polarity, either 1 or 0.
+
+What:		/sys/class/timecard/ocpN/genX/running
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Either 0 or 1, showing if the signal generator is running.
+
+What:		/sys/class/timecard/ocpN/genX/start
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Shows the time in <sec>.<nsec> that the signal generator
+		started running.
+
+What:		/sys/class/timecard/ocpN/genX/signal
+Date:		March 2022
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) Used to start the signal generator, and summarize
+		the current status.
+
+		The signal generator may be started by writing the signal
+		period, followed by the optional signal values.  If the
+		optional values are not provided, they default to the current
+		settings, which may be obtained from the other sysfs nodes.
+
+		    period [duty [phase [polarity]]]
+
+		echo 500000000 > signal       # 1/2 second period
+		echo 1000000 40 100 > signal
+		echo 0 > signal               # turn off generator
+
+		Period and phase are specified in nanoseconds.  Duty cycle is
+		a percentage from 1-99.  Polarity is 1 or 0.
+
+		Reading this node will return:
+
+		    period duty phase polarity start_time
+
 What:		/sys/class/timecard/ocpN/gnss_sync
 Date:		September 2021
 Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
-- 
2.31.1

