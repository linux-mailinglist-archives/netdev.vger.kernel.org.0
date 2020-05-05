Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609131C56D3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgEEN3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:29:31 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:24885
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728934AbgEEN3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:29:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoYpEallwnYK20q/LlFCfS2RCiN027gazszsTyTD/+gx+qkUvhYBtpHcZ5w+9VchNrkF2ui4cV9D3gnYSwEiEPpyqr+rWToabqMnfkZjdObynz7On0lxh78Pg7pP6dcGF/VU60CafwzTbaeT+OELGlofG5P+KDR4PYA/96bbDxak25eieicivOXvAeFIKajiY7ESTbkm5Gk5XEhakzBOfNaDZA63lnoEn6Aci0NcFTAK4mWIRhV1j8oReXR9jbQSC4gTIdrSRU/Q3Yel9Xj3f2WETFMsfjYn2nxs+/2rUXywljosnRN2I+TsyD8+5iRFHXSWeVdLEn46EUwYDLeM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KqjGLIfGNH02rGgVlsn83th9wg7Goa8/vAgQ1OESI0=;
 b=G6SJcjcXmBfI1dQN4IF6W3uEnLwNtmuGhXTzesJDYCG/lbGEy7YQMPQGrjB4ka1pKOa1nuQ2F++vNvzWYtIsKGqa7pyHAaL49/cNWeltlXqeswxjz4PN6Zo2QoyvS5ttCOCmBo/GvnRBQfUHVzY6h4Ih2gcJ1av/VCB57KAmlfzNhGWamMMph2ZYXMvB5FDe3uUExFKhLWcGpCUOK8e6W9mbLhTOHCpmkWtTaAk1IN+cjLbg/17FTx+dYO4mGE3yvZ4ObI2kjPAkXIU2uZBbtwmfupSaXmCUsm8o6LqNW4Gri+hhAYexqYM6ApACfkpIHEZIB1TmandFnf/BO+Y6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KqjGLIfGNH02rGgVlsn83th9wg7Goa8/vAgQ1OESI0=;
 b=B3yJOG62ozG+BNe1QvxBDcvUlmxw9eSQJFvDqwq6fBp7rH8aOMSjjGHGd0uDlDYvettlKqgA1oBKw7c9H+KY5MxhjbLNbvDofuec1HDZGAMe+0T1WyVKNGbQSMRfPG3MjiEHPuBq81xgdW1VzSfpqYVNo+QYHSVPd5WRDtmSx+Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25)
 by DB8PR04MB5596.eurprd04.prod.outlook.com (2603:10a6:10:a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 5 May
 2020 13:29:26 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::4031:5fb3:b908:40e9]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::4031:5fb3:b908:40e9%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 13:29:26 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [net-next PATCH v3 0/5] Introduce new fwnode based APIs to support phylink and phy layers
Date:   Tue,  5 May 2020 18:59:00 +0530
Message-Id: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0096.apcprd03.prod.outlook.com
 (2603:1096:4:7c::24) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0096.apcprd03.prod.outlook.com (2603:1096:4:7c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Tue, 5 May 2020 13:29:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5d39be49-08a9-4376-3e3c-08d7f0f854e5
X-MS-TrafficTypeDiagnostic: DB8PR04MB5596:|DB8PR04MB5596:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5596E5653AD9F35A3DBB5608D2A70@DB8PR04MB5596.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0394259C80
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GCyFamQlcHktj4UaEgGWpMG81e33T/QAOlhLRoi+x3pvH3P760BPTpHbSY+qblqEwcXPmODs802FQTMvDbPRJyPwNOi2KzFu4QeWpmnHmlGducnk2juUj6imMN95RPE+rNxsd3dj5NwZpzSUHBPo2vbkZmy9pOlaIuI+9ZujDYMV2WlxxHZhQRiEQQ02ZW47QmT3m8cHTcek3/niyuL+yDX6INKmlKZ4MeS53lT+fH58JT4ldq2ZCJIGV0VkiKjsBr8NRA4TGrE4izv+CYEmE8pQDQ5CdqiWRGF7rz/3oUE+CZ0bD2YJYnlrr+/EJNvnzu0M3E71CVvSnsrWaF7tnGrrGID9+24c7a68eKgghDk999rXdN956jAwDYjQ/73H5yA/IRVkARxljfKlccQGmkEmF3Kxg6wlpHfhTn7wOSLzmoLJ0l4qrU/Svg8gh85TjLSjcyAhqrU5Z1P3IlqG3YUsTWZMJ5TyBK0Odts62OsC9prP9hNNaXoN3ZTjcaHiRMsIyu53P1mB4ePm1ENBZRQLze14B6/GxPgQfoz5Oqs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5643.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(6486002)(5660300002)(44832011)(26005)(55236004)(66556008)(66946007)(66476007)(498600001)(6506007)(52116002)(4326008)(956004)(2616005)(2906002)(186003)(1076003)(16526019)(7416002)(6512007)(86362001)(110136005)(54906003)(6666004)(8936002)(1006002)(8676002)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q3Imx/o0XQXqP40+msoWrO8aIGStXRDU5IoUBYwK4rnlBFese5iprXYjtIoTYCMbd92n2+EVLxAg4wUV0OCkIXb689smv+HvcxRrEYyexB+IKLe6aS60bQlJWWyY4wIm6OHtGLE73f5KcjEn+si6truYn06I2C6HbJJfBPFCmWq7IVPcVDch8ghY1HY0EFYPVWG3oVOmkCFzkL9ZRLYifu+lWzumIJILCS7QWqH5zG0zxIIdkH/ZX/cnspa0PwbAyzp/OSObT8AbQ/uOSh2dD+HH0hg5CZJw+z6ebG3ALzKOvu/FoXvskBg+MUdKeB1M/QST/zv2QtCGqgTdaWulEiA/tQtYII21PfSiNIMH5Lpw1fqD1qKraRTi0XT1BzQd2iwjNYlhFA5ohOPEAIq+oGADEQUDaK/2pFmMqrnraH3xnGeaCKm5Vf39W7HtUFAoyD+WNY70bTVlX21/SjFQOKO6BEXkhrnmezSJthkLfzaf5xw58VBF58U2NdGpCBlcb2gi/t00C724tUUVMy1wGJhxKTDfnbc14ZrNlGFChNMGj8D1fanwdJHu9ty9jpqZuasHgt15XN9naLtSEpShRhUNvU2FmIobu0B0TFwIwm5CqWtUYpz7ngc1k4psrjffWNy42SegMoA0GnE2Sl9DlHTB174Zl/qctAEEbPdagmz0LiOcqRa1eoR2On2m4Aj478rjU1XulFv3Lm/KGJk/qKE6szc5WUrYpaP5qwq5NqLSTf/IKczWQKMUtJNH2829qP8gPvw28LvWmxxSGzUtx0PaDlAVGm/hZsuSYCkc4Q4=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d39be49-08a9-4376-3e3c-08d7f0f854e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 13:29:26.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAeFHhzGDcqrUCyQt/ekW1Qw1PYn9h68a17jXP9PoZryX6ez4vsJXBBTTeiHqLh/WCZ6T6RaeqLpZpmMaBAOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5596
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following functions are defined:
  phylink_fwnode_phy_connect()
  fwnode_phy_find_device()
  device_phy_find_device()
  fwnode_get_phy_node()
  fwnode_mdiobus_register_phy()
  fwnode_get_phy_id()

First one helps in connecting phy to phylink instance.
Next two help in finding a phy on a mdiobus.
Next one helps in getting phy_node from a fwnode.
Last two help in getting phy_id and registering phy to mdiobus

Changes in v3:
  move fwnode APIs to appropriate place
  stubs fwnode APIs for !CONFIG_PHYLIB
  improve comment on function return condition.
  remove NULL return check as it is invalid
  remove unused phylink_device_phy_connect()
  Introduce two functions to register phy to mdiobus using fwnode

Changes in v2:
  move phy code from base/property.c to net/phy/phy_device.c
  replace acpi & of code to get phy-handle with fwnode_find_reference
  replace of_ and acpi_ code with generic fwnode to get phy-handle.

Calvin Johnson (5):
  net: phy: Introduce phy related fwnode functions
  net: phy: alphabetically sort header includes
  phylink: Introduce phylink_fwnode_phy_connect()
  net: phy: Introduce fwnode_get_phy_id()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()

 drivers/net/phy/mdio_bus.c   |  41 ++++++++++++++
 drivers/net/phy/phy_device.c | 102 ++++++++++++++++++++++++++++++-----
 drivers/net/phy/phylink.c    |  48 +++++++++++++++++
 include/linux/mdio.h         |   2 +
 include/linux/phy.h          |  24 +++++++++
 include/linux/phylink.h      |   3 ++
 6 files changed, 206 insertions(+), 14 deletions(-)

-- 
2.17.1

