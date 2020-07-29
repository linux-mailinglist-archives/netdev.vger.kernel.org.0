Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FFC23229F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgG2QYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:42201 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgG2QYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:39 -0400
IronPort-SDR: vB1WomO/vbdY80QrK+St08F5BTmf8DxxyrD8uu8KsLLr48TBjsYgk1Y0HEF+kCqnofm/dVqbkW
 Stoc6N2/4xhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982355"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:18 -0700
IronPort-SDR: 8wuUceVbHyCe3d4SEmoMSy7SR8qohuoLfCT3l3Ph6FlGL3zfLgIS71mzEUoFAxUeF36GPsPyAO
 Q3LQFnAkAXUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087619"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 15/15] ice: fix unused parameter warning
Date:   Wed, 29 Jul 2020 09:24:05 -0700
Message-Id: <20200729162405.1596435-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on PAGE_SIZE, the following unused parameter warning can be
reported:

drivers/net/ethernet/intel/ice/ice_txrx.c: In function ‘ice_rx_frame_truesize’:
drivers/net/ethernet/intel/ice/ice_txrx.c:513:21: warning: unused parameter ‘size’ [-Wunused-parameter]
        unsigned int size)

The 'size' variable is used only when PAGE_SIZE >= 8192. Add __maybe_unused
to remove the warning.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index abdb137c8bb7..a508d4f463e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -509,8 +509,8 @@ static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
 	return 0;
 }
 
-static unsigned int ice_rx_frame_truesize(struct ice_ring *rx_ring,
-					  unsigned int size)
+static unsigned int
+ice_rx_frame_truesize(struct ice_ring *rx_ring, unsigned int __maybe_unused size)
 {
 	unsigned int truesize;
 
-- 
2.26.2

