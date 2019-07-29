Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9E78CEE
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387671AbfG2NfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:35:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:16211 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbfG2NfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:35:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="173235928"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jul 2019 06:35:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BC33935A; Mon, 29 Jul 2019 16:35:14 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 00/14] NFC: nxp-nci: clean up and new device support
Date:   Mon, 29 Jul 2019 16:35:00 +0300
Message-Id: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few people reported that some laptops are coming with new ACPI ID for the
devices should be supported by nxp-nci driver.

This series adds new ID (patch 2), cleans up the driver from legacy platform
data and unifies GPIO request for Device Tree and ACPI (patches 3-6), removes
dead or unneeded code (patches 7, 9, 11), constifies ID table (patch 8),
removes comma in terminator line for better maintenance (patch 10) and
rectifies Kconfig entry (patches 12-14).

It also contains a fix for NFC subsystem as suggested by Sedat.

Series has been tested by Sedat.

Changelog v4:
- rebased on top of latest linux-next
- appended cover letter
- elaborated removal of pr_fmt() in the patch 11 (David)

Andrey Konovalov (1):
  NFC: fix attrs checks in netlink interface

Andy Shevchenko (11):
  NFC: nxp-nci: Add NXP1001 to the ACPI ID table
  NFC: nxp-nci: Get rid of platform data
  NFC: nxp-nci: Convert to use GPIO descriptor
  NFC: nxp-nci: Add GPIO ACPI mapping table
  NFC: nxp-nci: Get rid of code duplication in ->probe()
  NFC: nxp-nci: Get rid of useless label
  NFC: nxp-nci: Constify acpi_device_id
  NFC: nxp-nci: Drop of_match_ptr() use
  NFC: nxp-nci: Drop comma in terminator lines
  NFC: nxp-nci: Remove unused macro pr_fmt()
  NFC: nxp-nci: Remove 'default n' for the core

Sedat Dilek (2):
  NFC: nxp-nci: Clarify on supported chips
  NFC: nxp-nci: Fix recommendation for NFC_NXP_NCI_I2C Kconfig

 MAINTAINERS                           |   1 -
 drivers/nfc/nxp-nci/Kconfig           |   7 +-
 drivers/nfc/nxp-nci/core.c            |   2 -
 drivers/nfc/nxp-nci/i2c.c             | 134 +++++++-------------------
 drivers/nfc/nxp-nci/nxp-nci.h         |   1 -
 include/linux/platform_data/nxp-nci.h |  19 ----
 net/nfc/netlink.c                     |   6 +-
 7 files changed, 41 insertions(+), 129 deletions(-)
 delete mode 100644 include/linux/platform_data/nxp-nci.h

-- 
2.20.1

