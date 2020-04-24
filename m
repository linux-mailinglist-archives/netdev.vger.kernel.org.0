Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D31B6BC9
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 05:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgDXDQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 23:16:59 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:3072
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725982AbgDXDQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 23:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/8eldznQLvZrO904IQrt350kuFHzGkwB/yO1fn/o22wZpMw+rcZQpzgf+z265Hy4PMlTUHeo0jOpQ5RJJwHgW5FzAP5xqyBm/JHN9S7Ry69IPcbCrov6YEJIWp31ZUGnuSbY9wQ/lSU5+KUW/hVzT7dWqGQixU0SdIAa+LT0Njzr13qLvVcGr5s/W1QXlPfgGDoFCZbRFJfje/76rqji7gh7ar0Mqs7r9DKBX5nEuSqHOhkNRmGcUSkDugBwCFRsUT867R5P1v83yC/NUVJjY9Gt7UumsW5swB6e+MQQYiGv8uCeaCDyTSS1Y/Sc1I3ZwmR1yiW19N9ga8kVYRYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJrrKFcJj3+4b7N2H1iiMO/M4JRjznloM8XjSAKSD8k=;
 b=f1CmnYcVsLYpaMSVNkKKv02WKV0Dj682avmlorXVwMYmK5af09uvVyNY3hFa3eKJ0/Lwj3LHRzRGOKRnnpX6q3aI4KEh95ePJm8HSOcN4Gm2cwfE6ApSArHKPgc3//8+D7KZAiYHXm6rj9MRP9MuZ3YXBYO80msS63rb+wmOwOwaE3qdPculyYMmPavICjThzHWVWvtNZPLMTGZ9ZvW9FbjWadIws/DeTu5O/HvDRII+JqbBTCDPNPqDzd10aEUYEbyeDymb4AXyj7zLHPXS4ZwipLOrgepvFfcMFbnvRDQTYcnJJd7TwP3MKL1vVNbOOLObguOoxOnVAdpnfuHt1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJrrKFcJj3+4b7N2H1iiMO/M4JRjznloM8XjSAKSD8k=;
 b=AO8VnscdxjPszv+bw8fdlmeHQU47kfxYuvHTHIMjxoNbtW1vgQDrJWoOkddXHGHE090kKIjU4RCY2749Uj+ffsRl+9HnLcpAAdudNvPt+t4Y6i5tVKzAMcd/6v6zh6MSfHF+C8Z5X4ReVp5QmL+M2jaMG+ytqlP9674ro4M+OXk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6788.eurprd04.prod.outlook.com (2603:10a6:208:18e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 03:16:54 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 03:16:54 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Varun Sethi <V.Sethi@nxp.com>, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [net-next PATCH v1 0/2] Introduce new APIs to support phylink and phy layers
Date:   Fri, 24 Apr 2020 08:46:15 +0530
Message-Id: <20200424031617.24033-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0122.apcprd01.prod.exchangelabs.com (2603:1096:4:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 03:16:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a18e40c-2bc5-464a-b9c0-08d7e7fdf07e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6788:|AM0PR04MB6788:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6788154F4A9CE76419D7739FD2D00@AM0PR04MB6788.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(2616005)(8676002)(956004)(5660300002)(8936002)(81156014)(186003)(6506007)(16526019)(26005)(54906003)(86362001)(110136005)(52116002)(55236004)(2906002)(1076003)(4744005)(316002)(478600001)(44832011)(66946007)(6512007)(6666004)(6486002)(1006002)(7416002)(4326008)(66556008)(6636002)(66476007)(110426005)(921003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCsP/QPRSPAUxNxZJ4eoa/zz3EqRmHC9TArQJt+q6J2FiJbRSCh1AlejB+s9hyUOLP9eS0Z0mnDPcKjhY7XGEDqSb2xybYlS0F0tFU2h8xM+GWBbC1nIxeL9ozn++5O/URn/fZkC2L4Uk7P9kqnl+zn+HRAxcoDyePBdCqrnHiRxdvGSZnB+g7tHuyCPoC3VAW7kIbHooN4e7dq6RrWAahcI07Dde6ISmZjjTZfY0KQkBCjj6EGFuSBv7VyO9FzqsqFJz2HFwZ4/nZ+HG8EQ6i/RvwuxhdiAt9d0tF6r2KeD5MWRD4ucQ4YpVqvjkX+vm6lPz0CKty2mn9Ot1eWl4eng1SvvvZ320KIVcZqmoeqH2tbKCv1VV5/qDO2Za3UdhGJW+vNkIYXOXpX0LjoHcuT6kIS1qEQ+xjj9gqOgp4SxYQJUey4ZiC7eMNUePmrLrWz628vuweiNpOQavHq5Pbvy0XJ8Dr2LvuHwK6ylBCq8m//f6dCWVKsjELXsUAPz/pAF54xLFpkfjOhgz4Ms3A==
X-MS-Exchange-AntiSpam-MessageData: Ebr4Z3QciwkNvQ42QuOa4Qnxz+R0EyuBx6m22qZ3d/H7ND9J7RlthYWoVnRtpdk+uZDtvfl1POf50jm1kvVS1lYmBgn89XNwlxbat1vflMBsvIw5Qb3es8+oH9RAFMo+irCn/KX4HldLcJNwEwrJkA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a18e40c-2bc5-464a-b9c0-08d7e7fdf07e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 03:16:54.8071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIkOqWZBfwx9u6+XtJPAOcqqltcxh5pUFPpa0Ka+38xLCvrHeetoeSFEhoEV179VDLIGB1vMGckIksGs1dJlQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6788
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following functions are defined:
  phylink_fwnode_phy_connect()
  phylink_device_phy_connect()
  fwnode_phy_find_device()
  device_phy_find_device()

First two help in connecting phy to phylink instance.
Remaining two help to find a phy on a mdiobus.


Calvin Johnson (2):
  device property: Introduce fwnode_phy_find_device()
  phylink: introduce phylink_fwnode_phy_connect()

 drivers/base/property.c   | 41 ++++++++++++++++++
 drivers/net/phy/phylink.c | 90 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  6 +++
 include/linux/property.h  |  5 +++
 4 files changed, 142 insertions(+)

-- 
2.17.1

