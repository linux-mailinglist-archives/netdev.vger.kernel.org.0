Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582E418485B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCMNkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:40:11 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59818 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgCMNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:40:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 133DDC0FAA;
        Fri, 13 Mar 2020 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584106810; bh=t1pm7fKD92tjH8JBeBYBSHbf42hldqejbJpvYI28CJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=HKqB0i/fWg9Lt2naCYiuS0+CdVPXiMpTzPoy0NviRi3CdZlmOvoUi1PYf73UHxo2Z
         TxELNZ852GuTdjxmw25xp/RPOi1IunJHv+xcOJ88jcC/VGkZTrT7ldnQYk7e/8EHHn
         8pAq43RL0l+o2xJYdWhcchKnhkp3Zzuge5mPOhuhcYQuCWte+3eS8I+AhTDl3KbkUJ
         UMNMP4uyQMBF4hmW/24D4vjyPo6/41fergIsknOnIAZKkciasoA+Vd5KYBm1MuHEm4
         jiTL6FaFnnI5sd5wG7wp6ZqmgEujMPZX3BDYZSvrtOc01p6b58NtDZvdf4f8bl1mF+
         axRfIjC3Eh8pw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 000C7A005C;
        Fri, 13 Mar 2020 13:40:07 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: phy: xpcs: Link errors improvements
Date:   Fri, 13 Mar 2020 14:39:39 +0100
Message-Id: <cover.1584106347.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First set of improvements for XPCS that were developed after exhaustive
tests of Link Down / Link Up transitions.

As a side note, more fixes and improvements may come in the near future
as we are adding XLGMII support at 25G, 40G, 50G and 100G speeds for
both XPCS and stmmac drivers.

Patch 1/4, prevents reading old values from RX/TX fault.

Patch 2/4 and 3/4, signals the check link function for critical errors
that can disturbe link normal operation and that need XPCS reset.

Patch 4/4, resets the XPCS at probe so that we start from a well known
state.

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (4):
  net: phy: xpcs: Clear latched value of RX/TX fault
  net: phy: xpcs: Return error upon RX/TX fault
  net: phy: xpcs: Return error when 10GKR link errors are found
  net: phy: xpcs: Reset XPCS upon probe

 drivers/net/phy/mdio-xpcs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
2.7.4

