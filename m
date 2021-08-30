Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABAC3FBF9E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbhH3Xxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:53 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:39663 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239212AbhH3Xxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:45 -0400
Received: (qmail 77105 invoked by uid 89); 30 Aug 2021 23:52:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 30 Aug 2021 23:52:50 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 11/11] docs: ABI: Add sysfs documentation for timecard
Date:   Mon, 30 Aug 2021 16:52:36 -0700
Message-Id: <20210830235236.309993-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch describes the sysfs interface implemented by the
ptp_ocp driver, under /sys/class/timecard.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 Documentation/ABI/testing/sysfs-timecard | 141 +++++++++++++++++++++++
 1 file changed, 141 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-timecard

diff --git a/Documentation/ABI/testing/sysfs-timecard b/Documentation/ABI/testing/sysfs-timecard
new file mode 100644
index 000000000000..a473b953b4d3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-timecard
@@ -0,0 +1,141 @@
+What:		/sys/class/timecard/
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This directory contains files and directories
+		providing a standardized interface to the ancillary
+		features of the OpenCompute timecard.
+
+What:		/sys/class/timecard/ocpN/
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This directory contains the attributes of the Nth timecard
+		registered.
+
+What:		/sys/class/timecard/ocpN/available_clock_sources
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) The list of available time sources that the PHC
+		uses for clock adjustments.
+
+		====  =================================================
+                NONE  no adjustments
+                PPS   adjustments come from the PPS1 selector (default)
+                TOD   adjustments from the GNSS/TOD module
+                IRIG  adjustments from external IRIG-B signal
+                DCF   adjustments from external DCF signal
+                ====  =================================================
+
+What:		/sys/class/timecard/ocpN/available_sma_inputs
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Set of available destinations (sinks) for a SMA
+		input signal.
+
+                =====  ================================================
+                10Mhz  signal is used as the 10Mhz reference clock
+                PPS1   signal is sent to the PPS1 selector
+                PPS2   signal is sent to the PPS2 selector
+                TS1    signal is sent to timestamper 1
+                TS2    signal is sent to timestamper 2
+                IRIG   signal is sent to the IRIG-B module
+                DCF    signal is sent to the DCF module
+                =====  ================================================
+
+What:		/sys/class/timecard/ocpN/available_sma_outputs
+Date:		May 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Set of available sources for a SMA output signal.
+
+                =====  ================================================
+                10Mhz  output is from the 10Mhz reference clock
+                PHC    output PPS is from the PHC clock
+                MAC    output PPS is from the Miniature Atomic Clock
+                GNSS   output PPS is from the GNSS module
+                GNSS2  output PPS is from the second GNSS module
+                IRIG   output is from the PHC, in IRIG-B format
+                DCF    output is from the PHC, in DCF format
+                =====  ================================================
+
+What:		/sys/class/timecard/ocpN/clock_source
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) Contains the current synchronization source used by
+		the PHC.  May be changed by writing one of the listed
+		values from the available_clock_sources attribute set.
+
+What:		/sys/class/timecard/ocpN/gnss_sync
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Indicates whether a valid GNSS signal is received,
+		or when the signal was lost.
+
+What:		/sys/class/timecard/ocpN/i2c
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This optional attribute links to the associated i2c device.
+
+What:		/sys/class/timecard/ocpN/irig_b_mode
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) An integer from 0-7 indicating the timecode format
+		of the IRIG-B output signal: B00<n>
+
+What:		/sys/class/timecard/ocpN/pps
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This optional attribute links to the associated PPS device.
+
+What:		/sys/class/timecard/ocpN/ptp
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This attribute links to the associated PTP device.
+
+What:		/sys/class/timecard/ocpN/serialnum
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RO) Provides the serial number of the timecard.
+
+What:		/sys/class/timecard/ocpN/sma1_out
+What:		/sys/class/timecard/ocpN/sma2_out
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) These attributes specify the signal present on the
+		associated SMA connectors.  May be changed by writing one of
+		the listed values from the available_sma_outputs attribute set.
+
+What:		/sys/class/timecard/ocpN/sma3_in
+What:		/sys/class/timecard/ocpN/sma4_in
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) These attributes specify where the input signal on the
+		associated connector should be sent.  May be changed by writing
+		multiple values from the available_sma_outputs attribute set,
+		separated by spaces.  If there are duplicated destinations
+		between the two connectors, SMA4 is given priority.
+
+		Note that not all combinations may make sense.
+
+		The 10Mhz reference clock is only valid on SMA4 and may not
+		be combined with other destination sinks.
+
+What:		/sys/class/timecard/ocpN/ttyGNSS
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This optional attribute links to the TTY serial port
+		associated with the GNSS device.
+
+What:		/sys/class/timecard/ocpN/ttyMAC
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	This optional attribute links to the TTY serial port
+		associated with the Miniature Atomic Clock.
+
+What:		/sys/class/timecard/ocpN/utc_tai_offset
+Date:		September 2021
+Contact:	Jonathan Lemon <jonathan.lemon@gmail.com>
+Description:	(RW) The DCF and IRIG output signals are in UTC, while the
+		TimeCard operates on TAI.  This attribute allows setting the
+		offset in seconds, which is added to the TAI timebase for
+		these formats.
+
+		The offset may be changed by writing a signed integer.
-- 
2.31.1

