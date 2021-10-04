Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1B842171C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhJDTRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:39 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:55525
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233981AbhJDTRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKJayh9PXSR6my25WPl7gwrZthLGd4ga9sgr7kEFpzCltBem4IUiCnkN+KaEcAZqN6A3U9xILRX96Th11GvuU+tAnQpjlziYgEYAXXFe+/8/euVQl9TvysLPUd6OtURkdI6TY1XKY4FJzBqlbhD0XyLdFPa3Y+XH9RApcn8mqXrad0q479slhRdbPiILlLNQNcZ9Ylstk0T6vMeLBT71CN0iKcyHx1ezna0zLImWNMFpzMOtYZ5KDDFPiHNcBB9ve9yThj3JkB4vSI529ZkyyMl43NSjgnsBRok6F9vbGJmPJw7XSgAc20U+xUnPxFvy9VtbbwZo1LAcd9mGCRzjWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qHSsZkuEbDQhYO+AtzFoOxOqwGyUgjIEjaR4GAeuAU=;
 b=bUobJNOMgNpESCdOY3nCqCrIxkSCQ8SBkJNEFVizc+h6mkCylUznRdCSGjrmqp70hmLQwizIJol1onQbFuC9HzxtsS8wQxClIcPTCOliHBUYwAF6gX4MzbwAgebzBY8vbjarl96rjRQNxQkOyLUiQ5pofDr4dJm4Wz+969YwCof//EIG5KXDKifRe15lk7plmpKjCSDEc+zb5ZgBRPJ+jgvvTllqUh89d0QZ0LEqvAcdO90CxyT4EEIHq3V39gOysgbTTZBHp8X2NiybWyjMgDLJKz5nIqBVOhHahuVWDKqJYtsQwH0xMMNtupys6VHkVoyKPTFaxmO/dMnHEHs8cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qHSsZkuEbDQhYO+AtzFoOxOqwGyUgjIEjaR4GAeuAU=;
 b=QF/s6XhYUlIDS2wjJjLOiRvfOpiCewh46CD8wfYOffpM+/iACvxD29+SJfkph5MvGHB/Qo3327U+qWw0LYp26YVcoTjKqCkZ5T2xZDr5Owyzb0fOzpu8Rqwjc/Kqait07DzLZKbfpZ/Fe3LgSsIAT4bSeUnVmKVflrYwYy8KqzQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:46 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Rob Herring <robh@kernel.org>,
        Robert Hancock <robert.hancock@calian.com>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: [RFC net-next PATCH 00/16] Add support for Xilinx PCS
Date:   Mon,  4 Oct 2021 15:15:11 -0400
Message-Id: <20211004191527.1610759-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3915f66-ccb6-49c3-cb29-08d9876b5e3c
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7434BB91C1F2679D93EA2A7F96AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2YwIzVWBnUo3uRXdQRE0AvXjMPCo2gNBFl9oIbr9WGg4s273xFV19yywmeqvpZHFp7F+gqh6MI87NUpecRyALi8hiFN0KCJRladHpf2B1LsB1qb8fTyCXFUIDhDPOuElBc/uOPELL6h5VRhwSvxSIr80swuo7h21RSAeIejg8IUWf+j9r7pEYpj9aCU4k9VgDmmd8QJe9TAsBbhA3fVR3BIROE6XgHazrOB7P0XoDVx5j2Pu+fO/bft1yhpOy5MUyH2YLKPX7juWZ0XenFUo4+CBx1/vS8P42DcJp3zAnYX13vagbKgTo8TwSflskDNyGPqNTvqgB6EEiGOVeMUgBt3FEeM1nURvYzE82fKt6RV5C9s7yMPaLcMJVJ5lcVH1gDRSCUe6ywkI33m7ad3b5Mw4xc7NnJf1U+dLWUdZP3GMjkG46VFTNcVXJSabc8T7Nq759w7uQ581zNApm7/48fvBYF+nM/14jjjyj8UUNY5i4z6LUl2eWjbg2JwJ85s12R9xBNPHOMXr3TymvfMGnqPZydr7pLgo6t4vhXTDyUXXejvYqDUmx0sg2zKfPNPLndnA/RH6LN049MHJfFMWP831bLxQnYsDMd+p88ZbTi7/poyOq8ytaT4z+TTXBNRBB4gR6dVIllJ2y+ruFPYTFALlIBL16k+1X69xWVSlv4YhHamKmMWGGnG7gNHSR9e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(7416002)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRccyvAWnElJXvjDj6+xXFrYToLp3UKkTJCCNQF1UycCWZyIB96O7yZp65So?=
 =?us-ascii?Q?E6WkN+r/dWq54ueWo7Btc+upCKKUkECkVdHSRJYHOtLmDPz+auIVDxg1guHm?=
 =?us-ascii?Q?OaNkxnPHY+/3/T3qC95c5bczJ0wP+VgjiwI1uImAUPCCPThYBfgNp2OZcqeW?=
 =?us-ascii?Q?4tzlKM2BdrFVy1Llxh4kHqLmV0vhs6X1+GKfYY6IE1Rr2dDtChCmFfSpkEVY?=
 =?us-ascii?Q?ZiKjXDAV0Vc50joyOZxB0KmE0Z/m3TWIncBrVmB8WKAzKhvnjyP7ek8Yjrif?=
 =?us-ascii?Q?Z1tukFvH3PnfYFJol2bKinxEstIQgYtbSLwMpqMrsRCX28HFjmD4OVrjpa9+?=
 =?us-ascii?Q?pHTM0h3BrVfHBQA2nr1j7/p4MMsLkBsF1oXHeDG/IG5M4jbcI8xaRK0g5bcW?=
 =?us-ascii?Q?hUy0fq0z//zGiSFMXzl9LgnWQmcOAxI9TjR2jcvExcJua+A61Hu29OL30HIY?=
 =?us-ascii?Q?rVFe8gD+IfVoTzmwI5l26+KCvYduvxsdhP7wF51sf5gGaGTuuDzqi/RwHtd7?=
 =?us-ascii?Q?ATbLCy3jH+KgIiD4r9tJTdTNeLKw8oCuggbozjv+aFTwKtRRWrytk7IXUQ9y?=
 =?us-ascii?Q?eMy20AlO9Drli/RauvRMumro6UKyJ9hmKXjXZgqJ872FksLjWkj/SjQfdSH8?=
 =?us-ascii?Q?bQIqooicLt2Wa1wEqKtYdpNR9oTl+BA/Brr2fbbXwj9gK2x5VzHStahV0iIj?=
 =?us-ascii?Q?N5mgYGmulQyhpKLiJJMsem+2J9cM57lB3BKdyO9WwyslR6Sn9ZRZ8tukAO6n?=
 =?us-ascii?Q?E7OHVZjNIBBCUHJb7kT5ykmQRrUwJEOt/cVjS73Ht8wZKssTDJEWCTAchanr?=
 =?us-ascii?Q?cWbrmCsEXx0mMDZj+XtuSAg9bbnfZGTf3O0oMJLli6Z/WT2RqVs0uERUhI6W?=
 =?us-ascii?Q?AkasaEOPrUQZNPDZtP60PqaZC3cGSGbbjoEpWvxtl4xev41leujr5nyRnTBe?=
 =?us-ascii?Q?vPAeGmGIKLDKXl2/OMS0fRsDBoDKr6R0DWLs8Kd5Utw9vFUMLmQCmCJ1SnAa?=
 =?us-ascii?Q?f409Wk84iWytLl+agqa8M2MIvPir9puEVgD9R0Ccym9cz3DA9fejbv2KK3aJ?=
 =?us-ascii?Q?ltQSJqGiNOtp83sg47SkhVIB4XbftSoY7RFIJhHLg8f/9A7fzcoPnsj7sA1F?=
 =?us-ascii?Q?P9J4eGITp2jJ9zTIqU4NPJ7qle2YBIZWyLrgK/u1NJNUgHs1nibpk/usv3QP?=
 =?us-ascii?Q?KxDSgPsYI26TY6PfG1KoJtywMDQ7NhVUi8Lz0fkOsqnarGhd80uE9DTvPRka?=
 =?us-ascii?Q?ZBObWgOS1PZ4TGoBZNwmcol3hyAB0OQjpFrC/HWwUvYJJvak9kimlOfLr1+2?=
 =?us-ascii?Q?4H8+X4lTW2FwXT4h887ixKz0?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3915f66-ccb6-49c3-cb29-08d9876b5e3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:46.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5k0gxq4lvSPY8ByGHawmx/1OI3iDqTyr3CmFJEqiH2O7iIA2kjHat20tMdwuFRb9hopioCTWioJwkqGQhfplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds experimental support for Xilinx PCS devices. It is
experimental because while I believe I have the Linux side mostly
sorted, I have yet to achieve any data transfer. Adding support for this
device has required some plumbing work related to PCSs in general, and I
would appreciate feedback in that area. In general, I have not tested
these changes outside of my particular setup, though I do have the
ability to test the macb changes using the internal PCS in the future.


Sean Anderson (16):
  dt-bindings: net: Add pcs property
  dt-bindings: net: Add binding for Xilinx PCS
  net: sfp: Fix typo in state machine debug string
  net: phylink: Move phylink_set_pcs before phylink_create
  net: phylink: Automatically attach PCS devices
  net: phylink: Add function for optionally adding a PCS
  net: phylink: Add helpers for c22 registers without MDIO
  net: macb: Clean up macb_validate
  net: macb: Move most of mac_prepare to mac_config
  net: macb: Move PCS settings to PCS callbacks
  net: macb: Support restarting PCS autonegotiation
  net: macb: Support external PCSs
  net: phy: Export get_phy_c22_id
  net: mdio: Add helper functions for accessing MDIO devices
  net: pcs: Add Xilinx PCS driver
  net: sfp: Add quirk to ignore PHYs

 .../bindings/net/ethernet-controller.yaml     |   5 +
 .../devicetree/bindings/net/xilinx,pcs.yaml   |  83 ++++
 MAINTAINERS                                   |   6 +
 drivers/net/ethernet/cadence/macb_main.c      | 375 +++++++++++-------
 drivers/net/pcs/Kconfig                       |  19 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-xilinx.c                  | 326 +++++++++++++++
 drivers/net/phy/phy_device.c                  |   3 +-
 drivers/net/phy/phylink.c                     | 335 ++++++++++++----
 drivers/net/phy/sfp-bus.c                     |  12 +-
 drivers/net/phy/sfp.c                         |   5 +-
 include/linux/mdio.h                          |  17 +
 include/linux/phy.h                           |   1 +
 include/linux/phylink.h                       |  17 +-
 14 files changed, 963 insertions(+), 242 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/xilinx,pcs.yaml
 create mode 100644 drivers/net/pcs/pcs-xilinx.c

-- 
2.25.1

