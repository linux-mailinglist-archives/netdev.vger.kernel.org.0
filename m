Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F6C23464F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgGaMzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:55:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47510 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728607AbgGaMzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:55:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 692FB200A0;
        Fri, 31 Jul 2020 12:55:21 +0000 (UTC)
Received: from us4-mdac16-31.at1.mdlocal (unknown [10.110.49.215])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 676AB800AD;
        Fri, 31 Jul 2020 12:55:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1022D40075;
        Fri, 31 Jul 2020 12:55:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C82E640070;
        Fri, 31 Jul 2020 12:55:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 31 Jul
 2020 13:55:15 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 00/11] sfc: driver for EF100 family NICs, part 2
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Date:   Fri, 31 Jul 2020 13:55:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25574.002
X-TM-AS-Result: No-1.581300-8.000000-10
X-TMASE-MatchedRID: cznJElmH2WHhp80oBol0K095wQijrwBLAPiR4btCEeYb9oq6FrYQ3Npn
        xAxinA0S/U1piLvbK8tuidpPpsZ/nwvpfXyH90tsCWlWR223da4r9gVlOIN/6iqvyaxpdQ5ccdQ
        cKpNhse00Pm9yXkpRHvWbSPEtOJtO9rqf24A6kyu7B1QwzOcQD9ST/TZ3TTpFHWtVZN0asTjSlz
        ofZX/2b+LzNWBegCW2RYvisGWbbS+No+PRbWqfRK6NVEWSRWybM2sjB5DRnNud8Eyb4trhMX7AP
        w5hR7I5MlxkOsgbypOtOhGSvjN6zygGGozIA3eknchT1nq76TklCLqScji108vKzKtzgdJ/kERy
        uRHFgnhSMqc7UpUorBKRsPC6bTvOqrQxXydIwG+qgpxQSEwcOA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.581300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25574.002
X-MDID: 1596200121-C_kDf1KKroz7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements the data path and various other functionality
 for Xilinx/Solarflare EF100 NICs.

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
 drivers/net/ethernet/sfc/ef100_nic.c    | 643 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h    |  48 ++
 drivers/net/ethernet/sfc/ef100_rx.c     | 150 +++++-
 drivers/net/ethernet/sfc/ef100_rx.h     |   1 +
 drivers/net/ethernet/sfc/ef100_tx.c     | 368 +++++++++++++-
 drivers/net/ethernet/sfc/ef100_tx.h     |   4 +
 drivers/net/ethernet/sfc/net_driver.h   |  21 +
 drivers/net/ethernet/sfc/tx_common.c    |   1 +
 10 files changed, 1242 insertions(+), 12 deletions(-)

