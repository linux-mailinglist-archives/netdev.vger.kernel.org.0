Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D90AA1FB9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfH2Pu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:50:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:60696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727207AbfH2Pu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 649A3AF79;
        Thu, 29 Aug 2019 15:50:26 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 00/15] ioc3-eth improvements
Date:   Thu, 29 Aug 2019 17:49:58 +0200
Message-Id: <20190829155014.9229-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my patch series for splitting out the serial code from ioc3-eth
by using a MFD device there was one big patch for ioc3-eth.c,
which wasn't really usefull for reviews. This series contains the
ioc3-eth changes splitted in smaller steps and few more cleanups.
Only the conversion to MFD will be done later in a different series.

Changes in v2:
- use net_err_ratelimited for printing various ioc3 errors
- added missing clearing of rx buf valid flags into ioc3_alloc_rings
- use __func__ for printing out of memory messages

Thomas Bogendoerfer (15):
  MIPS: SGI-IP27: remove ioc3 ethernet init
  MIPS: SGI-IP27: restructure ioc3 register access
  net: sgi: ioc3-eth: remove checkpatch errors/warning
  net: sgi: ioc3-eth: use defines for constants dealing with desc rings
  net: sgi: ioc3-eth: allocate space for desc rings only once
  net: sgi: ioc3-eth: get rid of ioc3_clean_rx_ring()
  net: sgi: ioc3-eth: separate tx and rx ring handling
  net: sgi: ioc3-eth: introduce chip start function
  net: sgi: ioc3-eth: split ring cleaning/freeing and allocation
  net: sgi: ioc3-eth: refactor rx buffer allocation
  net: sgi: ioc3-eth: use dma-direct for dma allocations
  net: sgi: ioc3-eth: use csum_fold
  net: sgi: ioc3-eth: Fix IPG settings
  net: sgi: ioc3-eth: protect emcr in all cases
  net: sgi: ioc3-eth: no need to stop queue set_multicast_list

 arch/mips/include/asm/sn/ioc3.h     |  357 +++++-------
 arch/mips/sgi-ip27/ip27-console.c   |    5 +-
 arch/mips/sgi-ip27/ip27-init.c      |   13 -
 drivers/net/ethernet/sgi/ioc3-eth.c | 1039 ++++++++++++++++++-----------------
 4 files changed, 667 insertions(+), 747 deletions(-)

-- 
2.13.7

