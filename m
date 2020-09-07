Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10625FED7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgIGQYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:24:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:32786 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730381AbgIGQNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:13:10 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7830C60077;
        Mon,  7 Sep 2020 16:13:08 +0000 (UTC)
Received: from us4-mdac16-62.ut7.mdlocal (unknown [10.7.66.61])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 75CA380094;
        Mon,  7 Sep 2020 16:13:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0605828004D;
        Mon,  7 Sep 2020 16:13:08 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9C61F1C0068;
        Mon,  7 Sep 2020 16:13:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:13:02 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/6] sfc: ethtool for EF100 and related improvements
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Date:   Mon, 7 Sep 2020 17:12:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-1.269100-8.000000-10
X-TMASE-MatchedRID: zbMzDzyPR0JcobUo5TVGLf3HILfxLV/9r4ukWaaTegDsrUu5tR5UaFG9
        NSlPn0S25xR9fSTunK5WO5mjsSOMnyXWu5LW+2sli3TrOhAURKEML/BvUnxaM0l/J9Ro+MAB8R5
        WqcJEt8h2of1NbcqgU/Dv8KQ86H71lc7KTsTAuCW7B1QwzOcQD/6lpfpte41hhZcOON9ondt576
        my5IxjuqxIDtAdLqLmUXD9TOZfGat/aFyHeBlucodlc1JaOB1Teouvej40T4hwGpdgNQ0JrNKXO
        h9lf/Zv4vM1YF6AJbZFi+KwZZttL42j49Ftap9Ero1URZJFbJsAkO3wt/N+kJbBUvmo2zcLCFWA
        GXGnBG6DC9R+E167OMY11dIYEQ5saJ23IA+JueMcjPmKnyq8hIDQ9VymILbsjLXm6Fs0mN+QRHK
        5EcWCeFIypztSlSisEpGw8LptO86qtDFfJ0jAb5C8bGExn/XN
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.269100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495188-T579txIhUvQB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the ethtool support to the EF100 driver that was held
 back from the original submission as the lack of phy_ops caused issues.
Patch #2, removing the phy_op indirection, deals with this.  There are a
 lot of checkpatch warnings / xmastree violations but they're all in
 pure code movement so I've left the code as it is.
While patch #1 is technically a fix and possibly could go to 'net', I've
 put it in this series since it only becomes triggerable with the added
 'ethtool --reset' support.

Edward Cree (6):
  sfc: don't double-down() filters in ef100_reset()
  sfc: remove phy_op indirection
  sfc: add ethtool ops and miscellaneous ndos to EF100
  sfc: handle limited FEC support
  sfc: remove EFX_DRIVER_VERSION
  sfc: simplify DMA mask setting

 drivers/net/ethernet/sfc/ef100_ethtool.c    |  41 ++
 drivers/net/ethernet/sfc/ef100_netdev.c     |   4 +
 drivers/net/ethernet/sfc/ef100_nic.c        |  19 +-
 drivers/net/ethernet/sfc/efx.c              |  20 +-
 drivers/net/ethernet/sfc/efx_common.c       |  38 +-
 drivers/net/ethernet/sfc/ethtool_common.c   |  45 +-
 drivers/net/ethernet/sfc/mcdi.h             |   1 -
 drivers/net/ethernet/sfc/mcdi_port.c        | 593 +------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 604 +++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_port_common.h |  15 +-
 drivers/net/ethernet/sfc/net_driver.h       |  49 --
 drivers/net/ethernet/sfc/selftest.c         |  12 +-
 12 files changed, 688 insertions(+), 753 deletions(-)

