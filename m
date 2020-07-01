Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51813210E06
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbgGAOuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:50:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38926 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731549AbgGAOuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:50:35 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 72050600C3;
        Wed,  1 Jul 2020 14:50:34 +0000 (UTC)
Received: from us4-mdac16-15.ut7.mdlocal (unknown [10.7.65.239])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 720F68009E;
        Wed,  1 Jul 2020 14:50:34 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EC44680068;
        Wed,  1 Jul 2020 14:50:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 87311A4006B;
        Wed,  1 Jul 2020 14:50:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:50:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 00/15] sfc: prerequisites for EF100 driver, part 3
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Date:   Wed, 1 Jul 2020 15:50:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-2.868300-8.000000-10
X-TMASE-MatchedRID: 5KoKEb3SpS/hp80oBol0K/3HILfxLV/9APiR4btCEeYMrRrnLCZEmngS
        ql3zhup/bYeFBJB9B7Sr/+Gm/JK2ukohWBZ4QV+620204SCJw/rKIqAq0jIHitKpFIAeH1NQ2jN
        t44OdemWYylsHYM8AGVjt7H32pJq0qBl45GkJnh/o5fsYXP0fUNxWLypmYlZzVmuBRrtDjk4wV1
        2/6ktut+jTv1w7gtMPnpIOQbMyLrPC/SXuUCCGwaXZvcUfKhso3YSaHlnZL807q5eboi2wFSe6L
        5ZD16Ut9YzQeJgLrcYDy4lbBM2jQpuzp0H1hWRJJ+mFatzELCP54F/2i/DwjeD3XFrJfgvzTx9j
        hIf/nmwxRydHrznAXIlhn5N3n2f78RN7SKQNjMOcVWc2a+/ju685fLDYlgpSmyiLZetSf8nJ4y0
        wP1A6AEl4W8WVUOR/joczmuoPCq1nKruDOsxHhTX8XHN04kWucHIyHuhFnZnH9aZ586K6tklmPW
        UNVWaWJZbcHjjh+hZbsgpuEzyMA1F3r2+kaa8LGzymwzqPrJ0XxY6mau8LG3IJh4dBcU42f4hpT
        poBF9JqxGCSzFD9MrDMWvXXz1lrlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.868300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615034-w2Xrm5OPvfjP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continuing on from [1] and [2], this series assembles the last pieces
 of the common codebase that will be used by the forthcoming EF100
 driver.
Patch #1 also adds a minor feature to EF10 (setting MTU on VFs) since
 EF10 supports the same MCDI extension which that feature will use on
 EF100.
Patches #5 & #7, while they should have no externally-visible effect
 on driver functionality, change how that functionality is implemented
 and how the driver represents TXQ configuration internally, so are
 not mere cleanup/refactoring like most of these prerequisites have
 (from the perspective of the existing sfc driver) been.

[1]: https://lore.kernel.org/netdev/20200629.173812.1532344417590172093.davem@davemloft.net/T/
[2]: https://lore.kernel.org/netdev/20200630.130923.402514193016248355.davem@davemloft.net/T/

Edward Cree (15):
  sfc: support setting MTU even if not privileged to configure MAC fully
  sfc: remove max_interrupt_mode
  sfc: move modparam 'interrupt_mode' out of common channel code
  sfc: move modparam 'rss_cpus' out of common channel code
  sfc: make tx_queues_per_channel variable at runtime
  sfc: commonise netif_set_real_num[tr]x_queues calls
  sfc: assign TXQs without gaps
  sfc: don't call tx_limit_len if NIC type doesn't have one
  sfc: factor out efx_mcdi_filter_table_down() from _remove()
  sfc: commonise efx_fini_dmaq
  sfc: initialise RSS context ID to 'no RSS context' in
    efx_init_struct()
  sfc_ef100: add EF100 to NIC-revision enumeration
  sfc_ef100: populate BUFFER_SIZE_BYTES in INIT_RXQ
  sfc_ef100: NVRAM selftest support code
  sfc_ef100: helper function to set default RSS table of given size

 drivers/net/ethernet/sfc/ef10.c           | 77 ++++++-----------------
 drivers/net/ethernet/sfc/efx.c            | 14 ++---
 drivers/net/ethernet/sfc/efx_channels.c   | 61 ++++++++++--------
 drivers/net/ethernet/sfc/efx_channels.h   |  3 +
 drivers/net/ethernet/sfc/efx_common.c     | 14 +++--
 drivers/net/ethernet/sfc/efx_common.h     |  2 +-
 drivers/net/ethernet/sfc/ethtool_common.c | 14 +++--
 drivers/net/ethernet/sfc/farch.c          |  6 +-
 drivers/net/ethernet/sfc/mcdi.c           | 62 ++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h           |  1 +
 drivers/net/ethernet/sfc/mcdi_filters.c   | 58 +++++++++++++----
 drivers/net/ethernet/sfc/mcdi_filters.h   |  3 +
 drivers/net/ethernet/sfc/mcdi_functions.c | 57 ++++++++++++++---
 drivers/net/ethernet/sfc/mcdi_functions.h |  1 +
 drivers/net/ethernet/sfc/net_driver.h     | 44 ++++++-------
 drivers/net/ethernet/sfc/nic_common.h     |  3 +-
 drivers/net/ethernet/sfc/selftest.c       | 18 +++---
 drivers/net/ethernet/sfc/siena.c          |  4 +-
 drivers/net/ethernet/sfc/tx.c             | 50 +++------------
 drivers/net/ethernet/sfc/tx_common.c      |  6 +-
 20 files changed, 290 insertions(+), 208 deletions(-)

