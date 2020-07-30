Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B29233480
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgG3Obq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:31:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45216 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729578AbgG3Obp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:31:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3B8BB600D6;
        Thu, 30 Jul 2020 14:31:45 +0000 (UTC)
Received: from us4-mdac16-28.ut7.mdlocal (unknown [10.7.66.60])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2A181200A4;
        Thu, 30 Jul 2020 14:31:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A7F6322005B;
        Thu, 30 Jul 2020 14:31:44 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 427087000A2;
        Thu, 30 Jul 2020 14:31:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:31:38 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 00/12] sfc: driver for EF100 family NICs, part 2
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Date:   Thu, 30 Jul 2020 15:31:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25572.005
X-TM-AS-Result: No-1.797600-8.000000-10
X-TMASE-MatchedRID: ChT4X4IKJLrhp80oBol0K0hwlOfYeSqxqV3VmuIFNEsaV9cxC+J6t/WK
        GThQ2qZNyZCMukEZBUIv/xyNTHf44VXKKbgrtyh88jbzfqNu/QTr3E41VlKsfS9kwp67RNMuyJN
        a6DYLgM2XUzspP39qoDS5Jiy15YFyCKGbCJcIygaeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0
        ePs7A07VgO4hFamrGGX0jTPeVzxFyWyyAzWFpWu3vnIb3QXQEgZOCNEE6eOSV7TLrZ5xlqXijVS
        WaPuVTTyW87KjGT4olLTBygj1Rtym/jGSEhw1ywfObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsL
        yY4gH4tVyvbTg/runA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.797600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596119505-oaWxDsG_Rpb5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements the data path and various other functionality
 for Xilinx/Solarflare EF100 NICs.

Edward Cree (12):
  sfc_ef100: check firmware version at start-of-day
  sfc_ef100: fail the probe if NIC uses unsol_ev credits
  sfc_ef100: read Design Parameters at probe time
  sfc_ef100: TX path for EF100 NICs
  sfc_ef100: RX filter table management and related gubbins
  sfc_ef100: RX path for EF100
  sfc_ef100: plumb in fini_dmaq
  sfc_ef100: statistics gathering
  sfc_ef100: functions for selftests
  sfc_ef100: add ethtool ops and miscellaneous ndos
  sfc_ef100: read pf_index at probe time
  sfc_ef100: add nic-type for VFs, and bind to them

 drivers/net/ethernet/sfc/Kconfig         |   1 +
 drivers/net/ethernet/sfc/ef100.c         |   2 +
 drivers/net/ethernet/sfc/ef100_ethtool.c |  44 ++
 drivers/net/ethernet/sfc/ef100_netdev.c  |  20 +
 drivers/net/ethernet/sfc/ef100_nic.c     | 643 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h     |  48 ++
 drivers/net/ethernet/sfc/ef100_rx.c      | 150 +++++-
 drivers/net/ethernet/sfc/ef100_rx.h      |   1 +
 drivers/net/ethernet/sfc/ef100_tx.c      | 368 ++++++++++++-
 drivers/net/ethernet/sfc/ef100_tx.h      |   4 +
 drivers/net/ethernet/sfc/net_driver.h    |  21 +
 drivers/net/ethernet/sfc/tx_common.c     |   1 +
 12 files changed, 1291 insertions(+), 12 deletions(-)

