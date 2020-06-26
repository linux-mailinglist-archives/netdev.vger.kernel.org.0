Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E820B062
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFZL0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:26:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47952 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728440AbgFZL0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:26:14 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6FCAC2005A;
        Fri, 26 Jun 2020 11:26:13 +0000 (UTC)
Received: from us4-mdac16-64.at1.mdlocal (unknown [10.110.50.158])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6D6C6800A4;
        Fri, 26 Jun 2020 11:26:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.7])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0D0DF40070;
        Fri, 26 Jun 2020 11:26:13 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C6A284C0051;
        Fri, 26 Jun 2020 11:26:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:26:07 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 00/15] sfc: prerequisites for EF100 driver, part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Date:   Fri, 26 Jun 2020 12:26:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-0.640600-8.000000-10
X-TMASE-MatchedRID: 1TaJMlLTWxKfJebeMR+nc7mQWToO0X1/Ww/S0HB7eoMda1Vk3RqxOD3+
        knT9EPAGiSkku02xGQknXlmC+rVSfEEckgEbMMejcI7vRACwF0KC7C2rJeUToXCHlyx4X5j243v
        GoPn/75m4IMdLeG0TQQnRB/uQaN84qMoNkl6nr0QMOWxRtywg+uP6p+9mEWlC+Z4lF/CW5gbiyr
        ZwH5WBj2zInwDQzcyxU71X33iML0MFHH1v6HnZquRtoi29GwN2JUTtJHiqjwNTorRIuadptEwSe
        VQnSS/FGz/3jhmCvFaRk6XtYogiau9c69BWUTGwC24oEZ6SpSmb4wHqRpnaDv55z/8fb+Har0bT
        tInoXidn8oQvkJlj866PoC3XKjLLMGajPw+ByZiIgOqqKXRJNe1vSeJPiKjnVp5cLqEWA9zJCc+
        skyHwse19DVI++epMmpVdReMayPPYX68FmWzgr7JqpzuBzRvlw2tMTSg0x74=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.640600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593170773-Apn7JBYElTgF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This continues the work started by Alex Maftei <amaftei@solarflare.com>
 in the series "sfc: code refactoring", "sfc: more code refactoring",
 "sfc: even more code refactoring" and "sfc: refactor mcdi filtering
 code", to prepare for a new driver which will share much of the code
 to support the new EF100 family of Solarflare/Xilinx NICs.
After this series, there will be approximately two more of these
 'prerequisites' series, followed by the sfc_ef100 driver itself.

Edward Cree (15):
  sfc: update MCDI protocol headers
  sfc: determine flag word automatically in efx_has_cap()
  sfc: extend bitfield macros up to POPULATE_DWORD_13
  sfc: don't try to create more channels than we can have VIs
  sfc: refactor EF10 stats handling
  sfc: split up nic.h
  sfc: commonise ethtool link handling functions
  sfc: commonise ethtool NFC and RXFH/RSS functions
  sfc: commonise other ethtool bits
  sfc: commonise FC advertising
  sfc: track which BAR is mapped
  sfc: commonise PCI error handlers
  sfc: commonise drain event handling
  sfc: commonise ARFS handling
  sfc: extend common GRO interface to support CHECKSUM_COMPLETE

 drivers/net/ethernet/sfc/bitfield.h       |   34 +-
 drivers/net/ethernet/sfc/ef10.c           |  100 +-
 drivers/net/ethernet/sfc/efx.c            |  119 +-
 drivers/net/ethernet/sfc/efx.h            |    8 -
 drivers/net/ethernet/sfc/efx_channels.c   |    7 +
 drivers/net/ethernet/sfc/efx_common.c     |  134 +-
 drivers/net/ethernet/sfc/efx_common.h     |    6 +-
 drivers/net/ethernet/sfc/ethtool.c        |  913 ---
 drivers/net/ethernet/sfc/ethtool_common.c |  911 +++
 drivers/net/ethernet/sfc/ethtool_common.h |   36 +-
 drivers/net/ethernet/sfc/mcdi.c           |   10 +-
 drivers/net/ethernet/sfc/mcdi.h           |    5 +-
 drivers/net/ethernet/sfc/mcdi_filters.c   |    8 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h      | 6933 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/net_driver.h     |    4 +
 drivers/net/ethernet/sfc/nic.c            |   46 +
 drivers/net/ethernet/sfc/nic.h            |  298 +-
 drivers/net/ethernet/sfc/nic_common.h     |  273 +
 drivers/net/ethernet/sfc/ptp.c            |    5 +-
 drivers/net/ethernet/sfc/ptp.h            |   45 +
 drivers/net/ethernet/sfc/rx.c             |  236 +-
 drivers/net/ethernet/sfc/rx_common.c      |  245 +-
 drivers/net/ethernet/sfc/rx_common.h      |    6 +-
 drivers/net/ethernet/sfc/siena.c          |    1 +
 24 files changed, 8672 insertions(+), 1711 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/nic_common.h
 create mode 100644 drivers/net/ethernet/sfc/ptp.h

