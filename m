Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826616EDB4D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjDYFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbjDYFpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:45:10 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CF47DA9;
        Mon, 24 Apr 2023 22:45:03 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33P5iYDh025758;
        Tue, 25 Apr 2023 00:44:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682401474;
        bh=EshFoB8Mkf7rfZOTlHpL7ZYxF50voA5/6L7VAz4DBuk=;
        h=From:To:CC:Subject:Date;
        b=A8UEcL8kzWG6LYxClhrFz3/cwk7rXeRHd1Cpd/M08VryRSrzMW4j3YKxhRpkPHIf0
         4+QZSsORPe74PHudM3LwvU8O5wIK99EGS3D384XvVqf6oB72c4U+tRgkTCeeX8IxfT
         6cTqA+GMYMygl83nS93dRteddrEJxdakDwnH7m6Y=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33P5iY8x025760
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 00:44:34 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 00:44:34 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 00:44:34 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33P5iURn124283;
        Tue, 25 Apr 2023 00:44:31 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [RFC PATCH 0/2] DP83867/DP83869 Ethernet PHY workaround/fix
Date:   Tue, 25 Apr 2023 11:14:27 +0530
Message-ID: <20230425054429.3956535-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds a workaround for the DP83867 Ethernet PHY to fix packet
errors observed with short cables, when both ends of the link use the
DP83867 Ethernet PHY. This issue is described in Section 3.8 at [0].

Also, for the DP83869 Ethernet PHY which supports both RGMII and MII
modes of operation, support is added to allow switching to MII mode by
configuring the OP_MODE_DECODE Register in Section 9.6.1.65 at [1].

Regards,
Siddharth.

---
[0]: https://www.ti.com/lit/an/snla246b/snla246b.pdf
[1]: https://www.ti.com/lit/ds/symlink/dp83869hm.pdf

Grygorii Strashko (2):
  net: phy: dp83867: add w/a for packet errors seen with short cables
  net: phy: dp83869: fix mii mode when rgmii strap cfg is used

 drivers/net/phy/dp83867.c | 15 ++++++++++++++-
 drivers/net/phy/dp83869.c |  5 ++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.25.1

