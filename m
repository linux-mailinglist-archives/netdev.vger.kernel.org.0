Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098A223AE2D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHCUap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:30:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41292 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgHCUap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:30:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B9373200FF;
        Mon,  3 Aug 2020 20:30:43 +0000 (UTC)
Received: from us4-mdac16-67.at1.mdlocal (unknown [10.110.49.162])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B7550800AD;
        Mon,  3 Aug 2020 20:30:43 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4B28E100072;
        Mon,  3 Aug 2020 20:30:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0EED9140080;
        Mon,  3 Aug 2020 20:30:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:30:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 00/11] sfc: driver for EF100 family NICs, part 2
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Date:   Mon, 3 Aug 2020 21:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.002
X-TM-AS-Result: No-2.624000-8.000000-10
X-TMASE-MatchedRID: MdQd6M758ujhp80oBol0K/LHPaGCgb3t6QiT3SsBfyFUjspoiX02F6bT
        a68ieFBIG+j22xW0Pjkgk2UlrwLN1BrO9MgKMDqQAZ0lncqeHqEEa8g1x8eqF6tkcxxU6EVIhnO
        LyflyxrPi5dRj2g5sp/mpjDPjqvkiikLATHHwCKm1u/qNjkzEXHqLr3o+NE+IHdFjikZMLIdcpk
        b9zUI7BOGgS4rOorYrKqt2FG1/DdBNfs8n85Te8oMbH85DUZXy3QfwsVk0UbsIoUKaF27lxXBVm
        zs14l2chN2l3rUFqDmIyYozKXXDhkln/eaBodWi6HJUGVq/Y6TMIitkJH+Jly66g3xTtgzmxTbz
        lFrN+Nr0VwhZAvaKGlrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7Pnl+rL5VW+ofZc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.624000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596486643-9lfvc3XFOoWG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements the data path and various other functionality
 for Xilinx/Solarflare EF100 NICs.

Changed from v2:
 * Improved error handling of design params (patch #3)
 * Removed 'inline' from .c file in patch #4
 * Don't report common stats to ethtool -S (patch #8)

Changed from v1:
 * Fixed build errors on CONFIG_RFS_ACCEL=n (patch #5) and 32-bit
   (patch #8)
 * Dropped patch #10 (ethtool ops) as it's buggy and will need a
   bigger rework to fix.

Edward Cree (11):
  sfc_ef100: check firmware version at start-of-day
  sfc_ef100: fail the probe if NIC uses unsol_ev credits
  sfc_ef100: read Design Parameters at probe time
  sfc_ef100: TX path for EF100 NICs
  sfc_ef100: RX filter table management and related gubbins
  sfc_ef100: RX path for EF100
  sfc_ef100: plumb in fini_dmaq
  sfc_ef100: statistics gathering
  sfc_ef100: functions for selftests
  sfc_ef100: read pf_index at probe time
  sfc_ef100: add nic-type for VFs, and bind to them

 drivers/net/ethernet/sfc/ef100.c        |   2 +
 drivers/net/ethernet/sfc/ef100_netdev.c |  16 +
 drivers/net/ethernet/sfc/ef100_nic.c    | 657 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h    |  48 ++
 drivers/net/ethernet/sfc/ef100_rx.c     | 150 +++++-
 drivers/net/ethernet/sfc/ef100_rx.h     |   1 +
 drivers/net/ethernet/sfc/ef100_tx.c     | 367 ++++++++++++-
 drivers/net/ethernet/sfc/ef100_tx.h     |   4 +
 drivers/net/ethernet/sfc/net_driver.h   |  21 +
 drivers/net/ethernet/sfc/tx_common.c    |   1 +
 10 files changed, 1255 insertions(+), 12 deletions(-)

