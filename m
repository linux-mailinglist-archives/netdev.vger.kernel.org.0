Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0273D13AE96
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgANQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:09:40 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40714 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728699AbgANQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:09:38 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8B4D0C0620;
        Tue, 14 Jan 2020 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579018177; bh=lMsPxq+6nqsKDOeBMq7JTDZwDRAvL67CUWdXLkXkMqk=;
        h=From:To:Cc:Subject:Date:From;
        b=iffSGqxx8OFb+Pmq5zvInZjDB2S3nvyAmHaayuDazU2IvKr/ANqsV+5cZMMo8mEA7
         D/qW49WaOk4HilFsZS4A6AtLQpWaLJHDroppQP33m0JNSFWe0yPFn0Anbbg8bTjS9+
         NC5VtqbX5LZ3aE5VqaUl+HbTu18GVXyBoUFKuDW4bBBFWCjHssPmMRURjNyldKlSTd
         jOZVxY2F2e5aMUW8ntYKkUK21GyFdSAxBUD4StzGG/z/L8ThH3c4OIuxFdChJUTV0J
         /CyV16jzSwo0YukQ+a8zJk4cwoeD+HK9N3ktwFJPa3+MsS7cwCl8d4h6SGO0uaqTgz
         J/sl3s3Q7dV3A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 221CDA005B;
        Tue, 14 Jan 2020 16:09:34 +0000 (UTC)
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH net 0/4] net: stmmac: Fix selftests in Synopsys AXS101 board
Date:   Tue, 14 Jan 2020 17:09:20 +0100
Message-Id: <cover.1579017787.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set of fixes for sefltests so that they work in Synopsys AXS101 board.

Final output:

$ ethtool -t eth0
The test result is PASS
The test extra info:
 1. MAC Loopback                 0
 2. PHY Loopback                 -95
 3. MMC Counters                 0
 4. EEE                          -95
 5. Hash Filter MC               0
 6. Perfect Filter UC            0
 7. MC Filter                    0
 8. UC Filter                    0
 9. Flow Control                 -95
10. RSS                          -95
11. VLAN Filtering               -95
12. VLAN Filtering (perf)        -95
13. Double VLAN Filter           -95
14. Double VLAN Filter (perf)    -95
15. Flexible RX Parser           -95
16. SA Insertion (desc)          -95
17. SA Replacement (desc)        -95
18. SA Insertion (reg)           -95
19. SA Replacement (reg)         -95
20. VLAN TX Insertion            -95
21. SVLAN TX Insertion           -95
22. L3 DA Filtering              -95
23. L3 SA Filtering              -95
24. L4 DA TCP Filtering          -95
25. L4 SA TCP Filtering          -95
26. L4 DA UDP Filtering          -95
27. L4 SA UDP Filtering          -95
28. ARP Offload                  -95
29. Jumbo Frame                  0
30. Multichannel Jumbo           -95
31. Split Header                 -95

Description:

1) Fixes the unaligned accesses that caused CPU halt in Synopsys AXS101
boards.

2) Fixes the VLAN tests when filtering failed to work.

3) Fixes the VLAN Perfect tests when filtering is not available in HW.

4) Fixes the Ethernet DT bindings for AXS101 board.

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
Cc: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-snps-arc@lists.infradead.org
---

Jose Abreu (4):
  net: stmmac: selftests: Make it work in Synopsys AXS101 boards
  net: stmmac: selftests: Mark as fail when received VLAN ID != expected
  net: stmmac: selftests: Guard VLAN Perfect test against non supported
    HW
  ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

 arch/arc/boot/dts/axs10x_mb.dtsi                   |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 32 +++++++++++++++-------
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.7.4

