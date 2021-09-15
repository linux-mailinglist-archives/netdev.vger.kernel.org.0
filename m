Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D015840BD92
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhIOCR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:17:57 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:48030 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhIOCR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:17:56 -0400
Received: (qmail 54598 invoked by uid 89); 15 Sep 2021 02:16:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 15 Sep 2021 02:16:37 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 00/18] timecard updates for v13 firmware
Date:   Tue, 14 Sep 2021 19:16:18 -0700
Message-Id: <20210915021636.153754-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This update mainly deals with features for the TimeCard v13 firmware.

The signals provided from the external SMA connectors can be steered
to different locations, and the generated SMA signals can be chosen.

Future timecard revisions will allow selectable I/O on any of the 
SMA connectors, so name the attributes appropriately, and set up 
the ABI in preparation for the new features.

The update also adds support for IRIG-B and DCF formats, as well
as NMEA output.

A ts_window_adjust tunable is also provided to fine-tune the 
PHC:SYS time mapping.
--
v1: Earlier reviewed series was for v10 firmware, this is expanded to
    include the v13 features.

Jonathan Lemon (18):
  ptp: ocp: parameterize the i2c driver used
  ptp: ocp: Parameterize the TOD information display.
  ptp: ocp: Skip I2C flash read when there is no controller.
  ptp: ocp: Skip resources with out of range irqs
  ptp: ocp: Report error if resource registration fails.
  ptp: ocp: Add third timestamper
  ptp: ocp: Add SMA selector and controls
  ptp: ocp: Add IRIG-B and DCF blocks
  ptp: ocp: Add IRIG-B output mode control
  ptp: ocp: Add sysfs attribute utc_tai_offset
  ptp: ocp: Separate the init and info logic
  ptp: ocp: Add debugfs entry for timecard
  ptp: ocp: Add NMEA output
  ptp: ocp: Add second GNSS device
  ptp: ocp: Enable 4th timestamper / PPS generator
  ptp: ocp: Have FPGA fold in ns adjustment for adjtime.
  ptp: ocp: Add timestamp window adjustment
  docs: ABI: Add sysfs documentation for timecard

 Documentation/ABI/testing/sysfs-timecard |  174 +++
 drivers/ptp/ptp_ocp.c                    | 1305 +++++++++++++++++++---
 2 files changed, 1343 insertions(+), 136 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-timecard

-- 
2.31.1

