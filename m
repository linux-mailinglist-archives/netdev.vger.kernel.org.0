Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3D5139615
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAMQYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:24:22 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:37118 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728828AbgAMQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:24:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C2582C05DD;
        Mon, 13 Jan 2020 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578932661; bh=U5PGyuzYKgsTK65LxsaS/H5tZz4kpujdOpV377i/AMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WP9flV1dSaev/vGxFPdJQ9kxfEJeOnkuyupAbk4CrBR6orqeeYf/lHO04DTTVShME
         AtsqnZN8otFL039ZkSmPr5d1iqXKiLNpZmOQ1dfKg79ixLs4S1uqf5sC7h+GwJLHTZ
         2oYmYjkLmUbajAt+pmO28E7FTn/eaGu4QrQhdXFddMajiipaAFABLX0DUrXyG5vY8r
         DvWc3KFz2LLs9JQHNO56uAasEAyJbui1xDn2Ts+ooYYrSkSstr/H6ZOrv91373lvQr
         1aMZZqZLVBILfIvdkgvbTCchXXGHuImn7dote85pB9EgPOCrV5wB4CR6g3IZg2FrMj
         9oZ2WAn4Bqa5A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 829CAA005B;
        Mon, 13 Jan 2020 16:24:18 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/8] net: stmmac: ETF support
Date:   Mon, 13 Jan 2020 17:24:08 +0100
Message-Id: <cover.1578932287.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the support for ETF scheduler in stmmac.

1) Starts adding the support by implementing Enhanced Descriptors in stmmac
main core. This is needed for ETF feature in XGMAC and QoS cores.

2) Integrates the ETF logic into stmmac TC core.

3) and 4) adds the HW specific support for ETF in XGMAC and QoS cores. The
IP feature is called TBS (Time Based Scheduling).

5) Enables ETF in GMAC5 IPK PCI entry for all Queues except Queue 0.

6) Adds the new TBS feature and even more information into the debugFS
HW features file.

7) Switches the selftests mechanism to use dev_direct_xmit() so that we can
send packets on specific Queues.

8) Adds a new test for TBS feature.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (8):
  net: stmmac: Initial support for TBS
  net: stmmac: tc: Add support for ETF Scheduler using TBS
  net: stmmac: xgmac: Add TBS support
  net: stmmac: gmac4+: Add TBS support
  net: stmmac: pci: Enable TBS on GMAC5 IPK PCI entry
  net: stmmac: Add missing information in DebugFS capabilities file
  net: stmmac: selftests: Switch to dev_direct_xmit()
  net: stmmac: selftests: Add a test for TBS feature

 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/descs.h        |   9 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  10 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  21 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  13 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   9 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  24 +++
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  12 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 207 ++++++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  96 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  21 +++
 include/linux/stmmac.h                             |   1 +
 17 files changed, 362 insertions(+), 84 deletions(-)

-- 
2.7.4

