Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58A04F855B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbiDGQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiDGQ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:58:10 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282DF119855
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McfHegLSNhuKDzLZQKFb/Cc3XVeNyMVOgjpyeqiLL/62sGJFUK6Pb8OG9wNfdgRnGMjLKzph7AjAAWajDSbe8wcs2W6cmzvwD727qQiMIchboGyqbkhx2VNKZSQvjzvxYboori8OcEx9JXrAKOJZSmV6ckNyViubIoMBbJ5eCmsfZ0iZKHPYQlwTXUoQld3NNaMlQ5s/A6BZxQqMmMQDdwEqPf7SgG10AoSR/sI4gtZEcgCGBhzlmTj4GxH/3CZaOQYgfvrYzwFMzEe1lfbj5EFLBY/CRNExrVQM8YbPaZOeERgkGiVKf4CWbXq/qGcrjZzSZSEnSnLApFWGFIUC3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cT5p3zs136QMVpHIta0wGKUCTLxNvsdNh8SrRbihF1I=;
 b=lfIXSwTZ2XW9VhbcC59i+uY4pkAav/EDqlvISOSC3i8+nfWqCcH3gcj4lc0ycK8GtzJSAWETqVju6rHZMF02pWRVcMbp2rlkPLFyfeDfnIfTfN0EXA/DivLf26ioTB5ldOu0MAsG8CfSMDZlJAi2h5K4v6c7Y/5XH6XemQ/DIDkYj+pj+k4GaVDz4pNehk9NB7TS54SKCc+3ga2vagxkopRSSEZ7opQTAPsfBkQER3vZWJqbYYXKEI9oyvyWYzIZYyys0Gaw+VV9RKH7HndP/fVNlh+u0+ZPAR4va04pe9iQiKt8hDKIoi3grozeaMWIQFgo2l6nrrgpalRmWSBn5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT5p3zs136QMVpHIta0wGKUCTLxNvsdNh8SrRbihF1I=;
 b=ARjcokhSz18mD0MJeuzKUqqHNrhtzlAFNkHsGujK1RujR6azPKUXeOnGZ+3Y9klY+2VcIIZQsxGxE6KzSIk3lWoyN6jb+kX1jpPr8NZ3/odAxZKnxruL+BIbxocYsFtaK0i7HAAee/0wv+CfyGykDdpqP/TDHFyOH3Tm0U5Shok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4674.eurprd04.prod.outlook.com (2603:10a6:208:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 16:55:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 16:55:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 net] net: mdio: don't defer probe forever if PHY IRQ provider is missing
Date:   Thu,  7 Apr 2022 19:55:38 +0300
Message-Id: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 270f8c26-a767-429f-a758-08da18b77b48
X-MS-TrafficTypeDiagnostic: AM0PR04MB4674:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4674F12150CAD267DDAD5053E0E69@AM0PR04MB4674.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gRbRj87xj+rFeMHLJQSD6Lcrkcvy5dTNtGqWNJL6TUcgkMvPIwyyFxKi3yjW/zmUEcsdSjYeiWcJCd1rE2XuWkPcJvJAtNH7hpIAWdIBUHPrAm7n1csHiHUduL36d220JEa8yJk3/B6d+5tj8qPoXgREzjhlOAMiMhHDGUj1ebAkSyb74k0Eabmrp7ngBe9xbRsdvUsLBHSBGbIk/vfCSt014hU9X3GENuvxP0DsWrmlfLOImXcdcVlzIJRYjIPxejdqKVmxRwUPve0iJfdStfqCB9tkm2Ob2bj4Q7hGrkdNXn7wq77amFR01yvLQ51+GPqvrBEWbhfgAlemHj4vk8cT62qNEv7jd4QU0wGeyZ9YxX0YCuYyq51+nuY+3cc/DiTbqvwSyTviR7JZsJ3f+WP88wXG9v2wKRctBRLY6OHIfMn3lIeGenbP6BAWru7ttXwwqgrY5U22Bc/YEn3vp0n6dZreEp8pPdvFLJNenqlVUuObdX2KHNC1CaTE8aR5db0hTRzk/K5okSvzEfDgvPhXhAxNqTLej5s4Ei4fSkcWC4HIneITd5xqHidA/gJ/9taWiHQvIDbbu2FjYRkNRjSz5lt9PUS2hBq0vjnwqT0KxRXzVhb60hOsOk4iCFwTaZNxEKOmL/39QuJNinbJjRUnXO3eKeGYlc0vmkVR810kBWrpx9fjJQn1mMu/Ecn8DZaCGSdLIgLprbFW+DGakA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6486002)(7416002)(54906003)(6916009)(8936002)(2616005)(186003)(1076003)(83380400001)(36756003)(316002)(44832011)(508600001)(38100700002)(66946007)(26005)(38350700002)(52116002)(6512007)(6666004)(66556008)(66476007)(6506007)(4326008)(2906002)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9Yz0g5rTs/g8ajgJUYMdOW1YFdzGGNQ67QY/vWVmDzxTAbUC26xf11QYztg?=
 =?us-ascii?Q?fEZmFj2w7uDP8yeRF4d76xAX+a/6lOZP7vjIzkwFfeZShm6D5n1MzZ3Sq/7W?=
 =?us-ascii?Q?QJVsGWfGIsq9ie7xzBzlUjZBVopgRG6x6550Vww+lzDBC6VEWASb7ANdyw6S?=
 =?us-ascii?Q?II6vNyenYCF4kw7WvkTiWpjhx9rJztIYIW13uz1ZADxl7OdAeLksiZLDfoDa?=
 =?us-ascii?Q?YZH/DiabIzEIt3zUmoONGaLjPznNij+ThrZblvab6TJDcVrlVfVXYfZdMr9C?=
 =?us-ascii?Q?4F15yazEDK4mPpSuaaU95vfuzARdiwloSCkX+auZfkxwKsBMgvl/0QEnY9Ug?=
 =?us-ascii?Q?pgH3FGf6GLps+5MDXAL2YSzoFdrHKfpSHnkMp+K26Vjs7ecNE40/ZQ2S9Bfq?=
 =?us-ascii?Q?mFovQm66zKutHE6kLp32fiHjxtCDoS76UdyKSQ/Hl3YM8A0GrTh5dOVe8VPO?=
 =?us-ascii?Q?Lo9vuGSLisK79ChGtOolzOtpqdUc5mZ82Hpn7/q+mOsJoaIswmKgy71f86MJ?=
 =?us-ascii?Q?11qbQijninRn1DWuTlIUW8fdePRrGOXlR3Q41e8HPaf8urCtv8K3dYX/Uop9?=
 =?us-ascii?Q?2ccHcR6rKY3G1UbfoQhdtVTGgTxoygkPXTc+mNvU6So+BUQYB2UK7LZs717T?=
 =?us-ascii?Q?WMFktUJ41LaVinHAMQS5oxwbSvFSDJRmwF1jZKXh5NHngD7zCBJj4r8XlYoB?=
 =?us-ascii?Q?25moXyF/xwK4QsYzqyXKpoPzl+gObEL5WVVoXcb7iNJK5dFHdkMZGpCAWu1y?=
 =?us-ascii?Q?EPv2fXscBfrviOJTOKyHLzKWIcyX9+PAjzHI6fF+q46zO5SutTuejebSnAZP?=
 =?us-ascii?Q?rSWZw3H3cdU4bGzXTztXrUGwAePMQNNpJkRZWtbnS2bQ/5IPSANpT56kgMPK?=
 =?us-ascii?Q?nyJkSnM7Eb17NiIfqhjAb6ngihs7/3oce/q31x1Z/v4ypIkDGVDFnOtxxd1A?=
 =?us-ascii?Q?JnOi67Ssefy9VhgsKVKpnHMtG14tu40uLO9rFmY1iaUlKngcS+TZxeDV7NIC?=
 =?us-ascii?Q?9z9M2ZUSXP5lcrqsMMplO7Riug7VnbpG3QKy26amXR+GfMYCQhmsN/0gdJJ4?=
 =?us-ascii?Q?QJrjU0GTSQj78c57NxtlvAc0P+2079KmSRXIhGZYrjkYZFLyPMDcCTf8CHQm?=
 =?us-ascii?Q?NDEd/qyUFhmuGwW+oQ2B7nzmjquZzniYuk1YrgrQE1St/8fe4nuUaJYtYcVc?=
 =?us-ascii?Q?2G7r8fA2q/n8wpGzbq0iozmp0AvAxWXdg0tHPN2pwf79xzuPdqM58/rVfumw?=
 =?us-ascii?Q?eQu5/qTTFzejA1oluO88P6vQeNjJjZwFimAyrr9T37vqVGlGcvlqbjcAOCO1?=
 =?us-ascii?Q?f+D5JKsqKU8F4clR6B0hiaVXt/5VFIrxQk4/xl2CX/yumRn86bqXjsBR3H1X?=
 =?us-ascii?Q?xcqEVU6FnbOQyxp6Ii4mM5FGCz5cuyZnoWTcBjRx4h78jyrk7JwWsel0c13B?=
 =?us-ascii?Q?hL2bULErkLHdc8vWTRQpt5gH5FgvotiSAhNIKjKte4O0iam0R6AGMT/put9q?=
 =?us-ascii?Q?1FZoPfJfs1R0yx+L7MHzpI5xghRHJ2Xz01w9IHmCgQhRBpvJIdwnfJeQt5ke?=
 =?us-ascii?Q?xHrEgfqxCqNyynPO8v/M+D3NdpZrALJI0B5Kruv0ekImbVpwZQUIhrMb58MN?=
 =?us-ascii?Q?h3ebz98eP8aZu0M9vzak8UsYsiwdjtr5QHLXgxZrrJnrySsFgG0oRUOUiMly?=
 =?us-ascii?Q?MxDXPCa32daHF/c6pPpSe+bxKzcMKhvAr6UPeqbiWZY1kw1oy16PMYAna/YE?=
 =?us-ascii?Q?2kU37DxEaQhdKjrqTqBWJtATTrcUPP4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270f8c26-a767-429f-a758-08da18b77b48
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 16:55:55.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3bQz9DS6ZfMSU68n/dr3NvbxnTqURbhsGNzhYKXNPFRs0dVfZS3QWVY5Q7KN4DUnu6gs8tXygSn4kkb5vhgNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4674
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a driver for an interrupt controller is missing, of_irq_get()
returns -EPROBE_DEFER ad infinitum, causing
fwnode_mdiobus_phy_device_register(), and ultimately, the entire
of_mdiobus_register() call, to fail. In turn, any phy_connect() call
towards a PHY on this MDIO bus will also fail.

This is not what is expected to happen, because the PHY library falls
back to poll mode when of_irq_get() returns a hard error code, and the
MDIO bus, PHY and attached Ethernet controller work fine, albeit
suboptimally, when the PHY library polls for link status. However,
-EPROBE_DEFER has special handling given the assumption that at some
point probe deferral will stop, and the driver for the supplier will
kick in and create the IRQ domain.

Reasons for which the interrupt controller may be missing:

- It is not yet written. This may happen if a more recent DT blob (with
  an interrupt-parent for the PHY) is used to boot an old kernel where
  the driver didn't exist, and that kernel worked with the
  vintage-correct DT blob using poll mode.

- It is compiled out. Behavior is the same as above.

- It is compiled as a module. The kernel will wait for a number of
  seconds specified in the "deferred_probe_timeout" boot parameter for
  user space to load the required module. The current default is 0,
  which times out at the end of initcalls. It is possible that this
  might cause regressions unless users adjust this boot parameter.

The proposed solution is to use the driver_deferred_probe_check_state()
helper function provided by the driver core, which gives up after some
-EPROBE_DEFER attempts, taking "deferred_probe_timeout" into consideration.
The return code is changed from -EPROBE_DEFER into -ENODEV or
-ETIMEDOUT, depending on whether the kernel is compiled with support for
modules or not.

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: export driver_deferred_probe_check_state, add driver core
        maintainers

This will not apply to stable kernels prior to commit bc1bee3b87ee
("net: mdiobus: Introduce fwnode_mdiobus_register_phy()"). I am planning
to send an adapted patch for those when Greg sends out the emails
stating that the patch fails to apply.

 drivers/base/dd.c              | 1 +
 drivers/net/mdio/fwnode_mdio.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index af6bea56f4e2..3fc3b5940bb3 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -296,6 +296,7 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 	return -EPROBE_DEFER;
 }
+EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..1c1584fca632 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	int rc;
 
 	rc = fwnode_irq_get(child, 0);
+	/* Don't wait forever if the IRQ provider doesn't become available,
+	 * just fall back to poll mode
+	 */
+	if (rc == -EPROBE_DEFER)
+		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
 	if (rc == -EPROBE_DEFER)
 		return rc;
 
-- 
2.25.1

