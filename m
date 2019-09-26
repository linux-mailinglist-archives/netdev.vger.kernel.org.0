Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B83BF8DD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfIZSLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:11:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:22811 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:11:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:11:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="364882870"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 11:11:17 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v3 0/7] new PTP ioctl fixes
Date:   Thu, 26 Sep 2019 11:11:02 -0700
Message-Id: <20190926181109.4871-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains patches to fix the various drivers which implemented
external pin input/output support. The drivers did not explicitly reject
unknown/unsupported flags.

Changes since v2:
* Split the external timestamp changes to separate patches per-driver
* Change the check for external timestamp flags to always accept all three
  current flags.
* Add cc for authors of the PTP support, hopefully receiving feedback

Jacob Keller (7):
  ptp: correctly disable flags on old ioctls
  net: reject PTP periodic output requests with unsupported flags
  mv88e6xxx: reject unsupported external timestamp flags
  dp83640: reject unsupported external timestamp flags
  igb: reject unsupported external timestamp flags
  mlx5: reject unsupported external timestamp flags
  renesas: reject unsupported external timestamp flags

 drivers/net/dsa/mv88e6xxx/ptp.c               |  6 +++++
 drivers/net/ethernet/broadcom/tg3.c           |  4 ++++
 drivers/net/ethernet/intel/igb/igb_ptp.c      | 10 +++++++++
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 10 +++++++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  4 ++++
 drivers/net/ethernet/renesas/ravb_ptp.c       | 10 +++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  4 ++++
 drivers/net/phy/dp83640.c                     |  8 +++++++
 drivers/ptp/ptp_chardev.c                     |  4 ++--
 include/uapi/linux/ptp_clock.h                | 22 +++++++++++++++++++
 10 files changed, 80 insertions(+), 2 deletions(-)

-- 
2.23.0.245.gf157bbb9169d

