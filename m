Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD01966D34D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbjAPXwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjAPXwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:47 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3693322A05;
        Mon, 16 Jan 2023 15:52:46 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DE3F39EF;
        Tue, 17 Jan 2023 00:52:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9NXyj08/VRkafMXUB3qax5P2d+sp7z57TdP+lU677PQ=;
        b=QoNpfy8VBKQeOx6xUXRguUzScp9m6a8QuHLmFjdrfJ4Hv+VB6QWFzA9/K5FJUXhtkFIpAe
        vVGRcUajt5L9FgpRePe0Gz1995DAO7uzFOlveXFzz/4nfK0BBWRxuzndc0GBIOusSzOJOA
        aOExxMBt49LfEq8zFMShRC/dRfg7sIzHt+9gS/RJdqZOCrfxHblHB7Me/YBO1zCm91LCMX
        dVMhyJzUqnldGcJVw0ArXJthYmR7NU6svZtEbAspTyvM/Ek+SHwGjvJ10I5iOdb84gGDMJ
        LnIu0QRkmDd032PAmLZQVnaDqiJnqz+Ix40SsKp4IUl3DsFay3+CNRoGom/QRA==
From:   Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 00/12] net: mdio: Continue separating C22 and C45
Date:   Tue, 17 Jan 2023 00:52:16 +0100
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADDjxWMC/zWNwQrCMBBEf6Xs2YWmsSr+injYpBubgzHshlIo/
 Xe3goc5PIZ5s4GyZFa4dxsIL1nzpxi4UwdxpvJizJMxDP3ge+cuWLhZ1obxPKJyZaFmG6wkDT2m
 0d+uIU7JM4FJAiljECpxPjRv0sZyFFU45fX3/IC/FJ77/gWfYfhdkwAAAA==
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Byungho An <bh74.an@samsung.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've picked this older series from Andrew up and rebased it onto
the latest net-next.

This is the third (and hopefully last) patch set in the series which
separates the C22 and C45 MDIO bus transactions at the API level to the
MDIO bus drivers.

The first patch is a newer version of the former "net: dsa: Separate C22
and C45 MDIO bus transaction methods", which only contains the mt7530
changes. Although posted as v1, because this is a new series, there is a
changelog included in the patch comment section.

The last patch is a new one, which isn't from Andrew's tree.

To: Sean Wang <sean.wang@mediatek.com>
To: Landen Chao <Landen.Chao@mediatek.com>
To: DENG Qingfang <dqfext@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Vladimir Oltean <olteanv@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
To: Russell King <linux@armlinux.org.uk>
To: Byungho An <bh74.an@samsung.com>
To: Nicolas Ferre <nicolas.ferre@microchip.com>
To: Claudiu Beznea <claudiu.beznea@microchip.com>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
To: Yisen Zhuang <yisen.zhuang@huawei.com>
To: Salil Mehta <salil.mehta@huawei.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
To: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>

---
Andrew Lunn (11):
      net: dsa: mt7530: Separate C22 and C45 MDIO bus transactions
      net: sxgbe: Separate C22 and C45 transactions
      net: nixge: Separate C22 and C45 transactions
      net: macb: Separate C22 and C45 transactions
      ixgbe: Separate C22 and C45 transactions
      ixgbe: Use C45 mdiobus accessors
      net: hns: Separate C22 and C45 transactions
      amd-xgbe: Separate C22 and C45 transactions
      amd-xgbe: Replace MII_ADDR_C45 with XGBE_ADDR_C45
      net: dsa: sja1105: C45 only transactions for PCS
      net: dsa: sja1105: Separate C22 and C45 transactions for T1 MDIO bus

Michael Walle (1):
      net: ethernet: renesas: rswitch: C45 only transactions

 drivers/net/dsa/mt7530.c                        |  87 ++++-----
 drivers/net/dsa/mt7530.h                        |  15 +-
 drivers/net/dsa/sja1105/sja1105.h               |  16 +-
 drivers/net/dsa/sja1105/sja1105_mdio.c          | 131 ++++++-------
 drivers/net/dsa/sja1105/sja1105_spi.c           |  24 +--
 drivers/net/ethernet/amd/xgbe/xgbe-common.h     |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c        |  91 ++++++---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c     | 120 +++++++++---
 drivers/net/ethernet/amd/xgbe/xgbe.h            |   7 +-
 drivers/net/ethernet/cadence/macb_main.c        | 161 ++++++++++------
 drivers/net/ethernet/hisilicon/hns_mdio.c       | 192 +++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c    | 237 ++++++++++++++++++------
 drivers/net/ethernet/ni/nixge.c                 | 141 ++++++++------
 drivers/net/ethernet/renesas/rswitch.c          |  28 +--
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c | 105 ++++++++---
 16 files changed, 906 insertions(+), 466 deletions(-)
---
base-commit: c941c0a15bee01a702d82793fe605326d453d9a7
change-id: 20230116-net-next-c45-seperation-part-3-f5387bcdf3ea

Best regards,
-- 
Michael Walle <michael@walle.cc>
