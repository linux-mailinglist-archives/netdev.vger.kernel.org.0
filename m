Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05044136DF1
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgAJNZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:25:32 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43450 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbgAJNZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:25:32 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9A7F44C006C;
        Fri, 10 Jan 2020 13:25:30 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:25:24 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 0/9] sfc: even more code refactoring
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Date:   Fri, 10 Jan 2020 13:25:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-0.499300-8.000000-10
X-TMASE-MatchedRID: DiKYqbzpKTEIoZsIlwjKBrdHEv7sR/OwWw/S0HB7eoOOzyCsYRwNaXv6
        cG7t9uXqugV/3O5rmoIN1izHZ6vquHqE/IIafU+/R/j040fRFpIO9z+P2gwiBWMunwKby/AXCh5
        FGEJlYgHcwnOQnf5T9QknAs9SasNwGAdnzrnkM485f9Xw/xqKXZLy/k4uPY3KxEHRux+uk8ifEz
        J5hPndGRIoAGjsgW59bEFmSix7zyUTUejhreLCuLxA2qT7XvRMlHeWHFWJt7dFfD71+Kg0zwVj8
        sOytbeRrdp5KYT9Em35KXJ/Tz1eERoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ6Ol5oRXyhFEVlxr
        1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.499300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662731-H2FRl75PzREq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splitting even more of the driver code into different files, which
will later be used in another driver for a new product.

This is a continuation to my previous patch series, and the one
before it.
There will be a stand-alone patch as well after this - after which
the refactoring will be concluded, for now.

Alexandru-Mihai Maftei (9):
  sfc: refactor selftest work init code
  sfc: move more tx code
  sfc: move more rx code
  sfc: move various functions
  sfc: move some ethtool code
  sfc: move a couple more functions
  sfc: move RSS code
  sfc: move yet more functions
  sfc: move RPS code

 drivers/net/ethernet/sfc/Makefile           |   4 +-
 drivers/net/ethernet/sfc/ef10.c             |  69 +--
 drivers/net/ethernet/sfc/efx.c              | 322 +-----------
 drivers/net/ethernet/sfc/efx.h              |  32 +-
 drivers/net/ethernet/sfc/efx_common.c       |  57 ++-
 drivers/net/ethernet/sfc/efx_common.h       |   4 +
 drivers/net/ethernet/sfc/ethtool.c          | 443 +----------------
 drivers/net/ethernet/sfc/ethtool_common.c   | 456 +++++++++++++++++
 drivers/net/ethernet/sfc/ethtool_common.h   |  30 ++
 drivers/net/ethernet/sfc/mcdi.h             |   2 -
 drivers/net/ethernet/sfc/mcdi_functions.c   |  40 ++
 drivers/net/ethernet/sfc/mcdi_functions.h   |   2 +
 drivers/net/ethernet/sfc/mcdi_port.c        |  78 ---
 drivers/net/ethernet/sfc/mcdi_port_common.c |  79 +++
 drivers/net/ethernet/sfc/mcdi_port_common.h |   4 +
 drivers/net/ethernet/sfc/net_driver.h       |   6 +-
 drivers/net/ethernet/sfc/rx.c               | 222 ---------
 drivers/net/ethernet/sfc/rx_common.c        | 510 +++++++++++++++++++-
 drivers/net/ethernet/sfc/rx_common.h        |  55 +++
 drivers/net/ethernet/sfc/selftest.c         |   7 +-
 drivers/net/ethernet/sfc/selftest.h         |   2 +-
 drivers/net/ethernet/sfc/siena.c            |   1 +
 drivers/net/ethernet/sfc/tx.c               |  95 ----
 drivers/net/ethernet/sfc/tx_common.c        |  94 ++++
 drivers/net/ethernet/sfc/tx_common.h        |   5 +
 25 files changed, 1353 insertions(+), 1266 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ethtool_common.c
 create mode 100644 drivers/net/ethernet/sfc/ethtool_common.h

-- 
2.20.1

