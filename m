Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15B1BFF78
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD3PC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:02:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:16558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbgD3PC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:02:59 -0400
IronPort-SDR: hMQ6/h2G8QL8K+n3KAiEKrrlu+u/pIrwmKJAZdcD64P1KOrHTOUKP1WTIWTvVRMzFrduVoq6EP
 jg6XwxkjM8Sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 08:02:58 -0700
IronPort-SDR: r1jUyWHRZkEWChP8YJLGCSIo4l7oiuL4IJe5rhtSZdpzW/8Z2SEVCiIzboGi5FXWKqjL6MJ9eX
 gkLDP14mYUAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="276544744"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 30 Apr 2020 08:02:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4AD4F11D; Thu, 30 Apr 2020 18:02:55 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/7] stmmac: intel: Fixes and cleanups after dwmac-intel split
Date:   Thu, 30 Apr 2020 18:02:47 +0300
Message-Id: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seems the split of dwmac-intel didn't go well and on top of that new
functionality in the driver has not been properly tested.

Patch 1 fixes a nasty kernel crash due to missed error handling.
Patches 2 and 3 fix the incorrect split (clock and PCI bar handling).

Patch 4 converts driver to use new PCI IRQ allocation API.

The rest is a set of clean ups that may have been done in the initial
submission.

Series has been tested on couple of Elkhart Lake platforms with different
behaviour of ethernet hardware.

Changelog v3:
- added the cover letter (David)
- appended separate fix as a first patch
- marked patches 2 and 3 with Fixes tag

Andy Shevchenko (7):
  stmmac: intel: Fix kernel crash due to wrong error path
  stmmac: intel: Fix clock handling on error and remove paths
  stmmac: intel: Remove unnecessary loop for PCI BARs
  stmmac: intel: Convert to use pci_alloc_irq_vectors() API
  stmmac: intel: Eliminate useless conditions and variables
  stmmac: intel: Fix indentation to put on one line affected code
  stmmac: intel: Place object in the Makefile according to the order

 drivers/net/ethernet/stmicro/stmmac/Makefile  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 160 +++++++-----------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |   5 -
 4 files changed, 68 insertions(+), 105 deletions(-)

-- 
2.26.2

