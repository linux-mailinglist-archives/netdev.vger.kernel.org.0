Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B5407FB5
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhILT3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:29:35 -0400
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:2529
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236023AbhILT3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 15:29:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWvzNCDUFUSDtkGlTVCRIgfXuGLeKyjGgomeBT0BPqnyor/cesKs503gxHA5oxDfRKp4sFmbXuehuGbi8R+UKQNf7BqQMZzyX8WxjQ+YOPqXMwDYXAnlazYRFM/zsdMOfWUKaYcJ0s0oeRglXOl9aEVXxVSSD0vPpVxNqau2woRNku6L3X30AfS67si3dLkg/LnKTzKFmTTJH/YtfVwf7F+rfrd3ptwLLXBoN2F7hTQIAmvwMsgop4wJBYQEpU0fBKpIFqc1FeP+4rpo24vU4ET5DYsGnk1f5Dvnc6jUeivK7wtVGj4X4IAshdEYnyZpMvHn34X0U9U/70nRh22AHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bU/7edhyvdBGIG/wwLyyL0vOgNO8/u3sbdWT+394BK0=;
 b=LFH/kU1z3L9XwOtwkjAoyDlbra6lo0WqN8mSmq1XYcbFZXvaW2UshuGzpZNF3S//EQ/Pt2qGFmJ4awzTGPLrtS0fRe/Twb3bUmgwYKMpqCj2kZg84gBjSUj+9Mi3gRIjW3RNqDYJgYvfZE6NdnXv3YOi+eQCsb51wqgkHwwIidnuPPMdLying0ke8INdSCkkeAT7ajNc2PSFR+JWvJIjABcBTKcuRa0f6Wz92ZnJp+aCzfFyQBJkFxnyWnyOlfEfIF5zKk9b5se6XkCqKJ5sGfDimCkIyFj3mdj08G0tqXPgCFjWkVD08L7TpqvrSVcTMlUXPbQXpgQHQ70C8hwwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU/7edhyvdBGIG/wwLyyL0vOgNO8/u3sbdWT+394BK0=;
 b=F336EcyOUOzyNZhqJGSuptZu2NfnpMGGcG2G9BdwVYh32vPQLtBLgqjmHLttML8TNl2I6aurSsjRXozl7LUZkHm449byzekmNV6TcJ17mmXFPT6vfYP6xowiyZZoX9UhcRfL2iXvGJqVN+gSZDRqMz1/KpA9nf6+WxQpjcJxlTQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Sun, 12 Sep
 2021 19:28:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 19:28:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Date:   Sun, 12 Sep 2021 22:28:05 +0300
Message-Id: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0161.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR08CA0161.eurprd08.prod.outlook.com (2603:10a6:800:d1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 19:28:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202bfc4f-7143-4cbc-7802-08d976237806
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3968C858A0EC65FDE01D0A8BE0D89@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kt/nOPrqhsbFv/NIh73Wa2j1MUyAooZxVV8w+0gTivsEJrU2mc1rpUdgG9RPEVSf0ZqOxHx1Jog66tz0Eff/SwVXUvdk+Mr6bMUnJSFLnA5oX8j5gVWl1TgxBTR1fYHkgwFcDeNbwJ9Wgu8Q3b/Kbh5+qh4AJH9J/N0PGD8UaMpAuiHlAYWNO02OnlEV4bhHTxEaPh+pu4Y+MvSzaHt93hTmaMsHX+sN9KzDZtkgoE6hQPAT126iZK3YMBnWG7v+7U8OFGKRfIcqfNgYX1fpf0sMnkZSx63DnX23uIfeKSzq723QqHmwh1KaNw0Wn5tY5f86JJj5gTfsw5GCH2yVyB394FpyICW0XLSp6ttDIO2Mrq9SwRezA0jHd2S3IiIRtxczmhpAMKP7og7NtkImHfF5SLU6KopTIxREpLdb3XAu/O8taeLN0zNsr2+DTLKoscmGWWKBSpULCuf0k6Nd6oZf67pSmwR+pxbWaDwFW/1GYalP1yDkcm36RNvbWnUXg7tFvarLy/dx6KTHsvyy3kLNL4YJR5INgHoD+STi8nXBpTCKZv3HAfRphm8S3CIieU29yCv+TAP/3PL39nfC4z3H0o32LkEeADgp6eFtZmCognZWTNfFGQGVWFGBEqPDtKI8tTfzs4+1eN5/l09Cy4Mb3xx1ltf85IA2AWWmKmCOizY+hCeGimfHFB1htZHrcJqkPzb5XkcCuSqdgf16Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(478600001)(8936002)(2906002)(1076003)(54906003)(66556008)(6916009)(4326008)(38100700002)(6666004)(26005)(316002)(66946007)(66476007)(86362001)(186003)(5660300002)(52116002)(44832011)(83380400001)(6506007)(6486002)(6512007)(2616005)(956004)(38350700002)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DyV7AHIRETsn4kF2SmYFftswNtJsldjgWVUP6X7lvp/dc3n//OqP7yOshmgk?=
 =?us-ascii?Q?1PvkjNSk2FLX5m9gcA2f7GY6rrXzca9aRz53MCJTbJ1ohjVYu1yVYbvgy5Bj?=
 =?us-ascii?Q?elBdHHFlobEu4LPdy/JWBx72BkCCOQw7yEDAaTutSL7fVd3uHeQJ6sDFOhjG?=
 =?us-ascii?Q?KdxlafFi6ERD9ySjfuiVqbVcv0laEPCGqnBUAjQ51uuvIh9gs6Nw0LPZmQD5?=
 =?us-ascii?Q?jgwIgms3+isXxeA/LTqozkpzr2hS6IPOJtdDoaXCIKIIKfXIW+l/2dAk2uCi?=
 =?us-ascii?Q?mE2UrX4PTiB244AaJXoySmwoxT+WKXJSH5JAotxdS/7Jq0afu4uIvptwQdCH?=
 =?us-ascii?Q?b/Hd3rNIBMFLnw0bmrRILQBYyQKoZP0cVlCr6chqQvgXeRw2Jp8HVM56tMQh?=
 =?us-ascii?Q?ooWrebWcwhkKO+F96pnjCvA8MDwep8aNBeiVBSwV+cTm9Cvu3XMFxoaM1Ixv?=
 =?us-ascii?Q?+diM/XLSviseoQSRyOmjj0nlR6rgAMrBcABaX2g8iniVx5jk5VEm0fAvn9AT?=
 =?us-ascii?Q?XFFGlCFgKZ/BfWPJPf/6aFt41A5nGF4adh4HO0nhM/TgfIAwPaHsaHik8yfj?=
 =?us-ascii?Q?/Taiq1STODz1mRLu+v2zOjoUJtWoInv41LHENrWIK8ubMqaBV5FNTd/SGb0B?=
 =?us-ascii?Q?4GKGEu10tjBZLuvCtI/hVgQFJ76B7ocffDOgU6NOIEUj2gMxWZ8I7A0OW3Lk?=
 =?us-ascii?Q?oUFe4j+74Bl81MtsgisV5ntYve3JUURLQE2K7Im07tVLze/TAzPU5XvJvaFM?=
 =?us-ascii?Q?pCVLoshHN11fBzdDlVQAG6EjbDE+iDcROafByjPNZWNpYNeKAaFpO5fzpUM0?=
 =?us-ascii?Q?R8vBUUydXoJ2blv6aJCBX9geRTVzqoRcEpY9JXKJTJcCE8Mr4hbDDjyh4JqX?=
 =?us-ascii?Q?l2KPER4Z8SVvX05GBhbQXsc+Vhl7ME/KHHtdV1fx+ut6o50QzyA1nDSUqduV?=
 =?us-ascii?Q?bR2HBVPrg7oc5SfvM9h2POIE+SIIPs3QTj6Rr3n35Gi9FWdGva2uz9Hq8nLa?=
 =?us-ascii?Q?wj44DvW4IuQum5bK4vxJSlF/KTJLMJ2Wu0vqSnw0H8pRDj23UXCLtrLZimb7?=
 =?us-ascii?Q?FONNylYnrmEji/sc5sahUYKkU2/H5s57em3NiTQY9ynQCdkBKrYauu/5aaZS?=
 =?us-ascii?Q?70Pr/JH5T/eFdnmYSZ5fTfZS6t6nVUJ6EjTwImOd/igERZ+gHeSWiHOIwyhz?=
 =?us-ascii?Q?Bdki2LZrWh3ectHWLQ1r+1p9dOxhHRg8XO9tCgHHuxtusywicp36xvvhv4/m?=
 =?us-ascii?Q?7tVE7p1C8pKcYypRoQXnxDJJGsBK9a1J+kTLQ39pE4LQqWsEb0QvwqK0al9r?=
 =?us-ascii?Q?bob0lGLcswU9EMZfWtZe+F2i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202bfc4f-7143-4cbc-7802-08d976237806
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 19:28:16.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JI9KCq9qadxSM7g/8/+MI6a5iNuMpQCOCe3qvHy36LbbEfhAuNUmkmqCqXzCVDQtfFFzaQISV9md1IZ2Ajj/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6.

I am not actually sure I follow the patch author's logic, because the
change does more than it says on the box, but this patch breaks
suspend/resume on NXP LS1028A and probably on any other systems which
have PHY devices with no driver bound, because the patch has removed the
"!phydev->drv" check without actually explaining why that is fine.

Examples why that is not fine:

- There is an MDIO bus with a PHY device that doesn't have a specific
  PHY driver loaded, because mdiobus_register() automatically creates a
  PHY device for it but there is no specific PHY driver in the system.
  Normally under those circumstances, the generic PHY driver will be
  bound lazily to it (at phy_attach_direct time), but since no one has
  attempted to connect to that PHY device (yet), it will not have a
  driver.

- There is an internal MDIO bus with PCS devices on it, for serial links
  such as SGMII. If the driver does not set bus->phy_mask = ~0 to
  prevent auto-scanning, PHY devices will get created for those PCSes
  too, and although those PHY devices are not used, they do not bother
  anybody either. PCS devices are usually managed in Linux as raw MDIO
  devices. Nonetheless, they do not have a PHY driver, nor does anybody
  attempt to connect to them (because they are not a PHY), and therefore
  this patch breaks that.

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

Fixes: 3ac8eed62596 ("net: phy: Uniform PHY driver access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

