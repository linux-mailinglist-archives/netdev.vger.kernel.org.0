Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88E614EFA4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgAaPfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:35:24 -0500
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:12674
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:35:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzoLKqR0SUWzPX1T0ESEYg3wCCbbpA6/ZzFon82tbGqmvql01lN5Hg8X3oy0DHLmUfYkyQ9d9/uTMStWdbIkVe93v8roebCcqGpHTcPmtTBd+ombc/AGdQMpcFV1ogZPDQE5N5U3Dxws8ydZlGTNCUfnAfdX9m808teW8Vyq5hEXrKu+7tiJ6vUDS++S9Y6TAX1aMKulr7Sq9WbhI4cZxxy7rVRCiVVM1e/Wzj5gYuYzlFnNYbkOTorkN4cPBgCYeO5e37XcOK+TO7K+NCt/xsqrK6Oa7eQRr6kg2ReJQnwqeC9wGA1VBRFBvr+qYS3ftJnQoLWWSS/iJzDvxCACsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clFll6eNfoQrDQehZCKdxzep2tSqrv0KWx+dkgbUCTc=;
 b=jDrllZvxYPDom0lPEhkI2TvJEUf4jW2Oe5x3c3lBCuiRymOOSXB9qLV55P+POBSdJrxtCMlxvjP9wVwR8WfZmiRIqbgZP9WmmTFi3xVHwp+qO1tIBUseRi496q27WBbmvFUqg3hdWENvd42XxwxLSx/cd8Q7vmzyQ+Vpu8pK91z0rj+njngt2SG+ePJexXnUXwWjdfm+7UHjTGRiHF37WCeJBwnOhxqg9Y1REup7QdG6rjeJi+Xgit9Vb4vwI1hnJWM0H1hhI4NefSCNLIJFbdUv55ZoT2hAf5aQh2juYp6lit/lE37LsTIaNYLv96BiMxyValhtmx3WdZREJey9aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clFll6eNfoQrDQehZCKdxzep2tSqrv0KWx+dkgbUCTc=;
 b=o8en1PaudL3PJCFPqMEYDlN9bM4QM0t722I5p/OJFEsOc2YxQQn2xSvUnY120awtpJUk4jIeniw31bbw12e4M38+brUaFZ4k9N5KeAyIg0BZl8NyWQI8AdW2bnvaV6RqoGAnsps4ai0GfhBXmKAaN6+9u9IdA0HIVooPq/97cOI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:18 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:18 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/7] ACPI support for xgmac_mdio and dpaa2-mac drivers.
Date:   Fri, 31 Jan 2020 21:04:33 +0530
Message-Id: <20200131153440.20870-1-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:11 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15913266-e5f0-4be7-fca2-08d7a6632cb3
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6730006DFB74E322F082133F93070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(6666004)(478600001)(54906003)(7416002)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFYkQMSMcS3g2gWdBpTowxAFw1THbMGyh107udo76OUN7kjh1VpvBgaHfsFFmAx5nYFeyh3Uw0par63KGEW3FU9mDHhJCk0+PqOM/66eXLTuXqThrSf+zhJkHdbVViq++zHMIWrJX1HqbDzOsRsjQX+GuXA93sTfQjEbnhh/VdFztEz+WL0CnAgvtl82S3GQgvgoG0890OGPyixhU5VmWgaDw6M6auRQTK2FgzH9B7zATJEPbXuvtJnIR+1AUnKi8RZLObKF2N19YbBb9DYqobAALl2MzMBykwMUbE9HCCHuyJE4FwDCcrVBv6DV/v8aUSccAj2jslNsliNr64TLaCe6gjhFQ+/rmmUiT4aRfa8BXVxtGn5h81Qrd96Lm7Vgfo5oxJgj4lLWjU9YtJB2JX1BwwjRICsqUyrMXAQuly++wq9AbOqNMyC4kMmkE3OBRqXHs2mW3du8JzQDgHuiQm/Yy/S+gc01phjSsSS/XsYxcvUYjxF4CYpxI4At1oZPSPXpQyVL957Zq9uyrOA007iQys5HPhBB/kHWGGua658=
X-MS-Exchange-AntiSpam-MessageData: yEfY9LPLVOx6EEr1koTHQw2xvhR/0JjpJTYYi8p+wjHhqWY6JXl13gNac5KPakinbutuPjA4GkBLk7/Zl/B6KaxYGIidHCTuH1yL2Wwz7K44N61ePdOF6BuMTgP4KWaFpddgS+6LbLJfXTT+FORcpQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15913266-e5f0-4be7-fca2-08d7a6632cb3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:18.0949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7x5TjopqNzW2k7xQ54NGYlr63w0PaIn4xX5G0MfIxF3SdbsohjvJxPSHyEtywLEIdB9glXH5XntVTrXZ92uog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

This patch series provides ACPI support for xgmac_mdio and dpaa2-mac
driver. Most of the DT APIs are replaced with fwnode APIs to handle
both DT and ACPI nodes.

Old patch by Marcin Wojtas: (mdio_bus: Introduce fwnode MDIO helpers),
is reused in this series to get some fwnode mdio helper APIs.


Calvin Johnson (6):
  mdio_bus: modify fwnode phy related functions
  net/fsl: add ACPI support for mdio bus
  device property: fwnode_get_phy_mode: Change API to solve int/unit
    warnings
  device property: Introduce fwnode_phy_is_fixed_link()
  net: phylink: Introduce phylink_fwnode_phy_connect()
  dpaa2-eth: Add ACPI support for DPAA2 MAC driver

Marcin Wojtas (1):
  mdio_bus: Introduce fwnode MDIO helpers

 drivers/base/property.c                       |  43 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  78 ++++--
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  63 +++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   7 +-
 drivers/net/phy/mdio_bus.c                    | 244 ++++++++++++++++++
 drivers/net/phy/phylink.c                     |  64 +++++
 include/linux/mdio.h                          |   3 +
 include/linux/phylink.h                       |   2 +
 include/linux/property.h                      |   5 +-
 9 files changed, 450 insertions(+), 59 deletions(-)

-- 
2.17.1

