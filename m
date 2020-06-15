Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3E1F97D4
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgFONCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:02:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:45787 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbgFONCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:42 -0400
IronPort-SDR: 53Wvwqqqq49dy76PVFloim9EW3SnfouneDBWMiW/aNgdW+mIKBf8mp00Qek2kGZ5c8ozh3R59B
 l8xHjP+LYFUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 06:01:46 -0700
IronPort-SDR: OU8DO0k8mLpXw9MLtDYXiZbdcioSozvvKSXEzILToNUeFRhzlKL3MkC65JNli+pfgB4/xVcXYW
 /1kPUGzRuuDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="290687912"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 15 Jun 2020 06:01:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id A470F190; Mon, 15 Jun 2020 16:01:39 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 0/4] thunderbolt: XDomain and NHI improvements
Date:   Mon, 15 Jun 2020 16:01:35 +0300
Message-Id: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small series improves the "data" path handling when doing host-to-host
connections over TBT/USB4 cable. First patch delays setting nodename upon
first connect to allow the userspace to fill in host name. Rest of the
series deal with the NHI (TBT/USB4 host interface) HopID allocation so that
by dropping the E2E workaround which was never used, we can use DMA rings
starting from 1 to transfer data over the TBT/USB4 fabric.

Mika Westerberg (4):
  thunderbolt: Build initial XDomain property block upon first connect
  thunderbolt: No need to warn if NHI hop_count != 12 or hop_count != 32
  thunderbolt: NHI can use HopIDs 1-7
  thunderbolt: Get rid of E2E workaround

 drivers/net/thunderbolt.c     |  4 +-
 drivers/thunderbolt/nhi.c     | 30 ++---------
 drivers/thunderbolt/switch.c  |  7 ++-
 drivers/thunderbolt/xdomain.c | 94 ++++++++++++++++++++---------------
 include/linux/thunderbolt.h   |  2 -
 5 files changed, 64 insertions(+), 73 deletions(-)

-- 
2.27.0.rc2

