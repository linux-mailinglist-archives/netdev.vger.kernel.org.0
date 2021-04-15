Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16403605A8
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhDOJ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:29:00 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:4673
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229820AbhDOJ25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:28:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHSyOm67EJM5536NRjdSr26/vTwpQhL8Ya26SiG9sRoC4hZvYQkZrcfbphar7vZrDH9HX2RIr1HVCEfX7nHpgg/Ds3z4n+GBwxxSsyff17jMIQ/vUKoaCjTSVjjYOQ4VNs1qWkKrpzHbHdQ9vvH3OQui8md1eAUR48XEfeXnSqa7uz1lAhTd9oDpz8X51PRg9+MGMpTDKecLxd+cJdTajKfnCMwPIjsndtuUr0GcKka00W7i0uRMOoM5kGi/R1c9vd5uiB7cCEu4IKQS7t6nW9mjJs2CANtWvNo9NSZ3G2El2kmOd3lZ36+J65Mao7mMPEBVSX8pBGgwKWZv6RFaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7mbt6UEczqd871tQqTFjuQ8blQONPVKI1WLvLLpVgM=;
 b=CfA6i9L7Gz2FXGTRZM5dwBG8lMbWjuhVGteDBMCiFw2hKnk0Geor/ESw031dC893/e3ZC0DGWw9Ere0nhezhIyNYs+wk1JIl5TNtUS/PGReafFTcIivI56f1bQlEsn2qqgpiAiq7tKwX4hJ3TbcG6NI2U8Y8UaFMoZHweke3xq0BMyVJOcWFMHDWEnypsECvPYFDNJ6Ox1VaaI7R354CbhlsHuJ6ZopAM2aFSMItz9opT3OE9YTtuIacvAnFOks7G8QenMWw8OojDtqXbzTyoOcoXnfta9I2dkjIybQeu5b6CivOk511SX81DdJqC74bBrZa9zAmpoOT+hoER17dYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7mbt6UEczqd871tQqTFjuQ8blQONPVKI1WLvLLpVgM=;
 b=I42VceCL2Iu7lAD3zMhpuCX5F0k788StDmx49Y4s6GKHFKDnVAnZjlhQ9JBRPpXgqSATEwl0NVttvEjsz0nls05rpYkum1fqswGk3l8vgWeHeEQLXi1phg/RG8+MDsq0CnbQgytP5/xGd/kzJ5vEmU5WefJ16240mAqS7dJu3So=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB6126.eurprd04.prod.outlook.com (2603:10a6:803:102::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 09:28:31 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 09:28:31 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 0/2] TJA1103 driver
Date:   Thu, 15 Apr 2021 12:25:36 +0300
Message-Id: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR02CA0177.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::14) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR02CA0177.eurprd02.prod.outlook.com (2603:10a6:20b:28e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 09:28:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3da4a3e5-8cb7-4583-a67c-08d8fff0d57c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6126:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6126E3F5F909E459EFA9C2879F4D9@VI1PR04MB6126.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aF6RntlJ3CxKL1R8Od7/qQHMunvj/QaIGWPyQ8jB0jBxGHABdF1btlMcJpuMSCtb8HTrb9Dlcqm9QIudYnmU5rS+sj/+xXlg1F2DuG6WCOt2h4hzCCmZhVQw6ullrnqR70qr74WqEr/LCYFj69DoHQDO1RfriCRS7c+DCuxOTZn2xK2ofz+35zvEFa9/oXx6Bbdtd7ec+0bxQjQO6VO0SHnAiNRc+yi9GDujFQfHeS51EfMule5oCeHsng4Ls+Uiksj/I+cWFQltBBIC0RoLxOCEpS695CF9iUJtQX+s7qQuxpJGWiW2Fo+gAhuvPszq0E9Gp3rsAjBn/URQfnsGQxs8orbDskSREOcNbFOukuoeBgfDrDtR+0t8QkNTdKAmWPzfHDFrrfrciCqHiDgWLic0cZRMI9/9oOgW72jqYs6B8twPV+Du08w0wQaBBYI2cEbwv62gAMzijwfv9uujpE00N+CJNLaMuOsAAfYkxp/NfxL35nYrNLxl65QtW+zetduVxftHuwdy7G3T/AlmV0mJwNuAUAcLjabfqu88g45LVkPes/aLCX1/g6sCWAk3M/oaVU0s/JJlGQYUZHPpy6Gt/+JjkWOwdmqy+aG8ZgEH/1/yietkdzv692vGZqGT6V2C/zg83ZZzrJduPJbb1bsNruZZbk4giFzfwOm1Rbb6t7tsBPAGL5umC8V44xb/LAR8cESDpvvRZ98NhyMEfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(956004)(26005)(1076003)(8936002)(316002)(38350700002)(4326008)(2616005)(6506007)(38100700002)(16526019)(69590400012)(186003)(478600001)(2906002)(5660300002)(66556008)(66946007)(66476007)(8676002)(6486002)(86362001)(83380400001)(52116002)(6512007)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mnzbiZBvbVFx9By6s0vOhq8AoMTRYJwh8E9D3ZfateqoKa7z6khJRWiKKC3O9ElqDitTIFDTkiJtR8zZ5eYtvTZWy1n813tv54Qof2Xuhs5HVhrLlC6DYe4UH7l9rtSs0V3lctn+6fD1wpt6EpBt0ejsb8wfKAvJ8F03Xl4SJnwdlssVjH7gkNBEqONevUArUo1Ve8Myk2+fwEqZpGVB1HlUqvfJk3LWlqwQUhaRBtm0M7g5I1ixV9k67CcblYZVfKBFejBaLtG8FSa0jr9qaM0DH6lidEDou7DuL+30/rjllEPuCeyZR1v+bYFQCrzDsQzbd7mC2tY8Endc0bULs3PmKmdOBRXJKT47XTM3xg90s9zEnlVSlChQzDMqlDBjc2ZeuWMvppFvsXenR1UktMZ+fG+JYzB3MIG+NZ6fcnqthaKlJSi8iNMg6N7o/+UxWWgHs/UGS875w/oEMzCstZU3/QsY0K3KeR7kuIykub+rdY5cFPhhnNMLkI3V16DDbJ9oiqTYeTGzH48lfV8SDWF+NHKoVLAwRYFWa88Px5gIgedM3XbSv/gPlLoGuHPNfzNU5GxJvNdTKY39OTQQnSSLi6+biV+jgHUpXl7563WOSikK9HAlHLO6PpgWxpKPAckcKRENZN794fF/cM58+TRXlINzIVZ4I8il2T9/s5IlL9SpNDldLLuKs6UHq5wlkW2+mbRf8y95w0xncmltn9oP8zAY9mQ5q1HpCXpXBhsPksckQOheqcm2O4GCEdHb
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da4a3e5-8cb7-4583-a67c-08d8fff0d57c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 09:28:31.3914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Fx4RMq61eZwBdxZNBZqwSXEl4vEnwmSe22uODoOEk0JSZhXIlVzSBUAXrELbzrZTVicjdYgQpzGiafXNP4c1qaf8oIpGr/NIgtC4gwEvCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small series adds the TJA1103 PHY driver.

Changes in v2:
 - implemented genphy_c45_pma_suspend/genphy_c45_pma_suspend
 - set default internal delays set to 2ns(90 degrees)
 - added "VEND1_" prefix to the register definitions
 - disable rxid in case of txid
 - disable txid in case of rxid
 - disable internal delays in rgmii mode
 - reduced max line length to 80 characters
 - rebased on top of net-next/master
 - use genphy_c45_loopback as .set_loopback callback
 - renamed the driver from nxp-c45 to nxp-c45-tja11xx
 - used phy phy_set_bits_mmd/phy_clear_bits_mmd instead on phy_write_mmd where
 I had to set/clear one bit.

Radu Pirea (NXP OSS) (2):
  net: phy: add genphy_c45_pma_suspend/resume
  phy: nxp-c45: add driver for tja1103

 MAINTAINERS                       |   6 +
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c | 607 ++++++++++++++++++++++++++++++
 drivers/net/phy/phy-c45.c         |  43 +++
 include/linux/phy.h               |   2 +
 6 files changed, 665 insertions(+)
 create mode 100644 drivers/net/phy/nxp-c45-tja11xx.c


base-commit: 5b489fea977c2b23e26e2f630478da0f4bfdc879
-- 
2.31.1

