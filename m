Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE313472D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAHQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:06:32 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43604 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbgAHQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:06:31 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 45A7260007C;
        Wed,  8 Jan 2020 16:06:29 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:06:24 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 00/14] sfc: code refactoring
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Date:   Wed, 8 Jan 2020 16:06:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-1.178800-8.000000-10
X-TMASE-MatchedRID: zZPFt0T/L0VD/MGHLum03pxVZzZr7+O7DmTV5r5yWnp+SLLtNOiBhkFG
        uw+l+IJd6Efa2in+vIv5fCAmw1KRHEgMxOkBoMP0xi///JpaHQMvV5f7P0HVDAVwF1Qcvctuouh
        IsT8EDFmt2/peTn4i5BRRlRwitBdJNo3mPlHYPyKolIr4dI9j7+lUxvXGcRIycBqXYDUNCaz+bp
        nisGGokKdepjGFSN7iU8PGMvdw2WyjxYyRBa/qJX3mXSdV7KK4mVLlQk0G3GfCttcwYNipX6Lm7
        9W+wVodlSOQ4E0tjFBKeJhVFbsv9BpQNTEm3YowJbSz0JaefOaMTlXmNyEl09MIMg/A6cb6iOWx
        zLtVQJAYd5oLNfLxtUSnXm+74riPfObqGK9JplminaV/dK0aEhK3Vty8oXtkps2YVnJpfNg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.178800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499590-w9mIz060KePi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splitting some of the driver code into different files, which will
later be used in another driver for a new product.

Alexandru-Mihai Maftei (14):
  sfc: add new headers in preparation for code split
  sfc: further preparation for code split
  sfc: move reset workqueue code
  sfc: move mac configuration and status functions
  sfc: move datapath management code
  sfc: move some device reset code
  sfc: move struct init and fini code
  sfc: move some channel-related code
  sfc: move channel start/stop code
  sfc: move channel alloc/removal code
  sfc: move channel interrupt management code
  sfc: move event queue management code
  sfc: move common rx code
  sfc: move common tx code

 drivers/net/ethernet/sfc/Makefile           |    7 +-
 drivers/net/ethernet/sfc/ef10.c             |    3 +
 drivers/net/ethernet/sfc/efx.c              | 2139 +------------------
 drivers/net/ethernet/sfc/efx.h              |   39 +-
 drivers/net/ethernet/sfc/efx_channels.c     | 1232 +++++++++++
 drivers/net/ethernet/sfc/efx_channels.h     |   55 +
 drivers/net/ethernet/sfc/efx_common.c       |  999 +++++++++
 drivers/net/ethernet/sfc/efx_common.h       |   61 +
 drivers/net/ethernet/sfc/ethtool.c          |    3 +
 drivers/net/ethernet/sfc/farch.c            |    1 +
 drivers/net/ethernet/sfc/mcdi.h             |    1 -
 drivers/net/ethernet/sfc/mcdi_functions.h   |   30 +
 drivers/net/ethernet/sfc/mcdi_port.c        |   50 +-
 drivers/net/ethernet/sfc/mcdi_port_common.h |   53 +
 drivers/net/ethernet/sfc/net_driver.h       |   13 +-
 drivers/net/ethernet/sfc/nic.h              |    6 +
 drivers/net/ethernet/sfc/rx.c               |  376 +---
 drivers/net/ethernet/sfc/rx_common.c        |  375 ++++
 drivers/net/ethernet/sfc/rx_common.h        |   42 +
 drivers/net/ethernet/sfc/selftest.c         |    2 +
 drivers/net/ethernet/sfc/siena.c            |    1 +
 drivers/net/ethernet/sfc/siena_sriov.c      |    1 +
 drivers/net/ethernet/sfc/tx.c               |  296 +--
 drivers/net/ethernet/sfc/tx_common.c        |  310 +++
 drivers/net/ethernet/sfc/tx_common.h        |   31 +
 25 files changed, 3270 insertions(+), 2856 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_channels.c
 create mode 100644 drivers/net/ethernet/sfc/efx_channels.h
 create mode 100644 drivers/net/ethernet/sfc/efx_common.c
 create mode 100644 drivers/net/ethernet/sfc/efx_common.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_functions.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port_common.h
 create mode 100644 drivers/net/ethernet/sfc/rx_common.c
 create mode 100644 drivers/net/ethernet/sfc/rx_common.h
 create mode 100644 drivers/net/ethernet/sfc/tx_common.c
 create mode 100644 drivers/net/ethernet/sfc/tx_common.h

-- 
2.20.1

