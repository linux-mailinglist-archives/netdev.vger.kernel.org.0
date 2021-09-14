Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E0640B03B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhINOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:06:49 -0400
Received: from mail-eopbgr50068.outbound.protection.outlook.com ([40.107.5.68]:57254
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233438AbhINOGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:06:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pog3TfLIIW4MyPCEuxcmvuO1lASEYmL0N0X9mSFGQhpc2jRjpVn5ADn6l8QBSuAiw9Ot488pbB5MvxiKBgyqAG/5k2f1qv3Js0rfmlrDodZGqtIgngmwqOpxdjB/HvH3rrTh4R6KkqUnH1lEzc5ddSa9qfeIBW8B0jx0KmejiOI+V6BR7o8XhTuMhfFhdThEz+rPQKPfgCe9k1widtKO7GxrWITJS4XDpxUD6UbrZhSdPNwDIUzadSH4nEMcSGXIlDBK3Vxv4spjMYtOsRhTnN/Sj+IQ+OdqlgG9X9mwwRCsQ/G/X2jI7xuMOAgwErFTVSPoIQf/xK2TZ7vEz3K7gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0xF5QpYAFM0jv4Pch+wfC4CZWotiEPSjZ19Pk5akRYk=;
 b=nI/69ftkEz7TpsZC7Pu3eFxhj78j0A6kF0j9OaEQRWR74Dtez64EFv6uLujUAmtjZXySmz6hUJQvwIKldSblCTXLgglKeepYjYFDnQvX9LFy/huVbUTmsv7lY73nHFZISO6IcSTJvYG9jZNNYbL27epLxknZokEJeVUDDvOPymGxkPzpzH+YCF6v+l/JF6Jk145ONrlhOFs22izAspL+jMhOcaEiwgNqLhjLJnhLj+IxjoaGQlhpZGet7pcgwpzbCaViBitVQR6SDj0hXYgS//bEQ26f6F8CR44OTb443hm7GSFAmr+kdcLCVU9e+qRuxTFDz2jGyB55gzqfDohY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xF5QpYAFM0jv4Pch+wfC4CZWotiEPSjZ19Pk5akRYk=;
 b=rgnTXzmGu71ZNG/F3ZVYa8959YX/3jKtafn/Mj+u65qrmIXzbiKdn8Z7/juSsHKmq4AQnqu6bN8quDY0fCmOMKWuLNNQhiV8J8z1WqAXAqsCNFDzepOeoauVfxHvsCkjT3tlY4XU5/677cUAH88YfUuwoFTy4h2qduNQE1Snas8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 14:05:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 14:05:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] Revert "net: phy: Uniform PHY driver access"
Date:   Tue, 14 Sep 2021 17:05:15 +0300
Message-Id: <20210914140515.2311548-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0150.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR01CA0150.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 14 Sep 2021 14:05:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ae1dc5f-718c-46c2-93d4-08d97788b508
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4816CDA24B5BBF50D5754C06E0DA9@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6qGrBGiv97EDxtS4EwHxh6NKdJeVdC/89jdl31eWxoseknDqKG18LVq66Cg9uBoAgOKsXEZ8t1p+jaBxNza4EIZO2D4L0CKdU86J5SGUS/aMORfb3zKnaPxbs4edgDoQ16RrpjY8516lLraSiGCApt8efsuLVj4UmK4uvrovGGE7BJcL4k8LqlL2JPiQxO03YkK3fA0giNzr3RFEMP/J50L01AF7p039OSiQJttEv2D3xpdHPqj+8w+dmraN2k7B8mP7vIEklvqwlpxm6uSfxi/REVNl1OaSL6ZrYlP/vm2lV5PtD+CsWZNMUSHf2zIsePjcXLW3Dmln772/gjSfcJw0vUzf+t2v1GOPVtkDnhGLp3A5v9CRgjqkFFNYtEumRQuk/CAGp5hVN+3bJfjULtP26HOE29KAbWQ+9pf9RYf9oMoNlkB09fFt+SSoQFFlt8ji+ABS1Hm1p3TcvfD4wHbkmc605Y3X5bXSBkrh7bU+aNz0POGC58B0/nTYWk2FPIXBxtbVTYmaAdO1rC8w5ht9ua22bEi92n/4vnV4Pnuv17XFaedcjMOKQqz/6Zn1yiiC/QHlLyNnLkR+To+ApOjJv2Hph4QM46KXfoWFjnC5rtbc/zeMlIKXjMXQ6W1U+p3X/SNT2nqh6Q6SF2nVrkwAxMvZ+xixQYVZF5VDglx/fXhXSakQzwjCRJfDyQ+chM+9CnnZoz8uN67AZmM9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(2906002)(6486002)(6666004)(4326008)(26005)(8676002)(1076003)(6916009)(38350700002)(316002)(66946007)(186003)(8936002)(5660300002)(66556008)(6506007)(6512007)(66476007)(86362001)(38100700002)(2616005)(956004)(54906003)(52116002)(478600001)(36756003)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?08MHWFHoxrMQxWjJ/EEURJYmKpsQB/r9yImnX030MFOUZMGCy6vYI0LgW4gQ?=
 =?us-ascii?Q?gnrf+EE1wOfcjIeIpNiQaSnRujgLHa8BRMVMu5kLGJek8AcqOY27b/h0J2Pg?=
 =?us-ascii?Q?eTlahGgXllxRsCXHw6yCTf9xJRCSs5CO/wQGFrzKnpQvN8dwSuOmZlrMimAY?=
 =?us-ascii?Q?gjh/HPIpWuGLjxdDLPFj8HHLndzWqTW30v3f53ffC0grMax/U8clWZKXFWr7?=
 =?us-ascii?Q?4oyE4B9iFkIn1jdPG3Yr1eN1bvSUCjoU8s1A579s07B+ryfTQSBO8qn/Jw4U?=
 =?us-ascii?Q?3Vt3bqPPNydpWvm47MLRdSRRrM24WdrBe9xNVJwZreYoq7E9X9CHJtQ4vwM+?=
 =?us-ascii?Q?zZpUFrEwITt1+W5ekX8WwXCN2IcotIjADodo3nDGGsC3zoa4O0FRYox2Tlva?=
 =?us-ascii?Q?sc5pLAovNZynkqbj23D/yfLn0tObF37cw9wtUQgNyXDdYCpDvBzvWZRyJ0LZ?=
 =?us-ascii?Q?M6f4HIubrOK+riyaIOmkfX+/d49j77DvOaZF3PLH7Wtx1xqz8TS4LrVDLMSU?=
 =?us-ascii?Q?bzKzBjim5TAyqutc7DleIIOD/wJERPoq1omX03P5lbDtsJj9GLLDhqK+zroY?=
 =?us-ascii?Q?cUtH2Va4IwsX4QWUekFMO0vo/a/pZ4j3MbgQCD1CJ5XhPX8rHKNRKXwQGbjk?=
 =?us-ascii?Q?hMDR13yAWKw/oZCRHXU6uTiSZ7moJs5/1HQ4q4XuuJfKMwMSv0BUnmtIs4tt?=
 =?us-ascii?Q?u94alU8bMnzgEJ/4ftWTpgQEVupToDv05//vhyHF0O9OK4XyDBy0vucqMoOD?=
 =?us-ascii?Q?F2xbaaD+BU9QERnOH5R4Ys10lIcIM3M1eHl8586mrYw6w/+iu4luHLKCau9R?=
 =?us-ascii?Q?sFro8uN4J84uAWaNK7mmsCGO1tjuHeNZbwa/S1P5yXIRlxi3c60YVDPDKRaB?=
 =?us-ascii?Q?d204Vp/przRjbkwUCRSDBMuq879e1oaMy6l54cyp5tDdKzWrlTeRzBGkAcaX?=
 =?us-ascii?Q?xTKvlu+r+X3Zkev/XsemLA6DJlUOm+Z2RTBOTDeot0fh2dJh9TZEsGcC/lJs?=
 =?us-ascii?Q?r+wojKWuW64mvkEizsxyQdUNNU7T8i5SJiEkA7pWR5rTDzqcC2cvx3j9rFCz?=
 =?us-ascii?Q?5leV3Dj/n+RqaLLSDRUihviioq82q+a9v4vAybEKQxmojNL6q71yPbL4AoTD?=
 =?us-ascii?Q?/91cEVRxBMbTp/lx5U4S9eMOxaUlOZzfjr6z78n6XRBoiBR9IS//62J8Pcgm?=
 =?us-ascii?Q?4bkEUo3DdmAG2VZlmU6qyA6PD32Buer4+pTfTe1N4BU1uOpExGSk55VyywoY?=
 =?us-ascii?Q?Rqn+I2aUHL/WmrcY5CHl2ooT/BwRrvEYbDIzDHnQQemoz0UwrzZSHdLcbWpr?=
 =?us-ascii?Q?foa1YVnaxxRQ7IXp1P9nRqAd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae1dc5f-718c-46c2-93d4-08d97788b508
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 14:05:28.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqA9aDMdsDmIs5rt77zJe3muSRFzNCCbFFkq8uDZQG3n4TehlegNrprUqN1n9Sa1USFRDkxK+6t3I6e+upMU2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6, which did
more than it said on the box, and not only it replaced to_phy_driver
with phydev->drv, but it also removed the "!drv" check, without actually
explaining why that is fine.

That patch in fact breaks suspend/resume on any system which has PHY
devices with no drivers bound.

The stack trace is:

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
pc : mdio_bus_phy_suspend+0xd8/0xec
lr : dpm_run_callback+0x38/0x90
Call trace:
 mdio_bus_phy_suspend+0xd8/0xec
 dpm_run_callback+0x38/0x90
 __device_suspend+0x108/0x3cc
 dpm_suspend+0x140/0x210
 dpm_suspend_start+0x7c/0xa0
 suspend_devices_and_enter+0x13c/0x540
 pm_suspend+0x2a4/0x330

Examples why that assumption is not fine:

- There is an MDIO bus with a PHY device that doesn't have a specific
  PHY driver loaded, because mdiobus_register() automatically creates a
  PHY device for it but there is no specific PHY driver in the system.
  Normally under those circumstances, the generic PHY driver will be
  bound lazily to it (at phy_attach_direct time). But some Ethernet
  drivers attach to their PHY at .ndo_open time. Until then it, the
  to-be-driven-by-genphy PHY device will not have a driver. The blamed
  patch amounts to saying "you need to open all net devices before the
  system can suspend, to avoid the NULL pointer dereference".

- There is any raw MDIO device which has 'plausible' values in the PHY
  ID registers 2 and 3, which is located on an MDIO bus whose driver
  does not set bus->phy_mask = ~0 (which prevents auto-scanning of PHY
  devices). An example could be a MAC's internal MDIO bus with PCS
  devices on it, for serial links such as SGMII. PHY devices will get
  created for those PCSes too, due to that MDIO bus auto-scanning, and
  although those PHY devices are not used, they do not bother anybody
  either. PCS devices are usually managed in Linux as raw MDIO devices.
  Nonetheless, they do not have a PHY driver, nor does anybody attempt
  to connect to them (because they are not a PHY), and therefore this
  patch breaks that.

The goal itself of the patch is questionable, so I am going for a
straight revert. to_phy_driver does not seem to have a need to be
replaced by phydev->drv, in fact that might even trigger code paths
which were not given too deep of a thought.

For instance:

phy_probe populates phydev->drv at the beginning, but does not clean it
up on any error (including EPROBE_DEFER). So if the phydev driver
requests probe deferral, phydev->drv will remain populated despite there
being no driver bound.

If a system suspend starts in between the initial probe deferral request
and the subsequent probe retry, we will be calling the phydev->drv->suspend
method, but _before_ any phydev->drv->probe call has succeeded.

That is to say, if the phydev->drv is allocating any driver-private data
structure in ->probe, it pretty much expects that data structure to be
available in ->suspend. But it may not. That is a pretty insane
environment to present to PHY drivers.

In the code structure before the blamed patch, mdio_bus_phy_may_suspend
would just say "no, don't suspend" to any PHY device which does not have
a driver pointer _in_the_device_structure_ (not the phydev->drv). That
would essentially ensure that ->suspend will never get called for a
device that has not yet successfully completed probe. This is the code
structure the patch is returning to, via the revert.

Fixes: 3ac8eed62596 ("net: phy: Uniform PHY driver access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: reworded commit message.

 drivers/net/phy/phy_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9e2891d8e8dd..ba5ad86ec826 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -233,9 +233,11 @@ static DEFINE_MUTEX(phy_fixup_lock);
 
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
+	struct device_driver *drv = phydev->mdio.dev.driver;
+	struct phy_driver *phydrv = to_phy_driver(drv);
 	struct net_device *netdev = phydev->attached_dev;
 
-	if (!phydev->drv->suspend)
+	if (!drv || !phydrv->suspend)
 		return false;
 
 	/* PHY not attached? May suspend if the PHY has not already been
-- 
2.25.1

