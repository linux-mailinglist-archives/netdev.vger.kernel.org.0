Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA8B62E9FD
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbiKRADE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiKRACh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:37 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A744B85EE6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReiOQpDe+44764rpNyKicRhUNH48cRSGaeb2MWRlXLwqOyDe+xx+ISzThGXgKiiDD8O+DiZaLZPD69k/il7y7h9kUU8R1m8MW2E4tsF8IgIa/8odI7QcZTG+3v8076bk7sVBbtve1G5bZp/gjpKWUze1Ov79gLKtshPcLlZ10d9SkObGa8AZxifK4O9nGjDLJhR2sRALtG77rCAhGkLwrRQU/8ukgZa7tLC/g0TFX1QWa8sMYgBv6Mlb1z1dlEbHoxutbLfS6gv2i0FOc1+ZQWdE40UY3g7wGUL0u7YXn9Btx4j6MgLCioMQ5lcA+0bbQkh4ukqv7McYkAhcLYnlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8PojE3JIbTS1j4f1EyOrFsVgSisa8C9hc4iU3XHaJU=;
 b=hSMuedZwadQRGRwJiioIJUy7dFBZD1Bo74nF0dZe0COHMR3BR8SKhDuIjAZ+5sfJKswhaLqhEnefSjQQ6jDbNOmI48kzyQuw7dvWpFWcriHqJogBV4x/gn0f7A5E8NEKyMkjKM9ZwMskRJ399NmV//KU+gC0C2aQjnglkp5OpAbiTkEqfqB65jLiVFGnsAKNDyFQk4lyrNvwPBfnCTjfQeYEfyauAZUGP+epI/hqgWqHcr+NKrIgTaN+LwIc9q8UIU0oFKrjupHwb5iJxy3RdgxTXL8c0S/30RMpOuDeiJNVe4BbqpoITwzg/BlLJPLGsI/Kak8X0t0T8NjJsfd8Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8PojE3JIbTS1j4f1EyOrFsVgSisa8C9hc4iU3XHaJU=;
 b=AlPhDEQ0iYcjvDSPb317jUMCjmqkDDmRp0Dksy5UoxeU3otTqwg0d4B7/2vv8OmwwFLEnv83PPI3EAM2ncowKih5ADrG9BpAYXjB1TddzZHbc+pA8k1BjRtn3jfthFCM2Amnvs0+CNiPd+UYYU8ZnU20/ymbY9l4degXadvE/oo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 7/8] net: phy: at803x: validate in-band autoneg for AT8031/AT8033
Date:   Fri, 18 Nov 2022 02:01:23 +0200
Message-Id: <20221118000124.2754581-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 429a3131-95d5-4ba3-ec1e-08dac8f826cb
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaIe4XypwfYrB+gUk4CrvfQPsx7H4m+2SS42sLpN2Tzn+MVQRe4mwsrdotN7JPPAz/wmVcKJgnzSg7XNDBVwLtncCsTE0cvhw1cyVg+P43yZ/SCjvP679EQa8lvAuuC+Y9Su+dHbiJt/4xoqjYR72YDKc89mX1cYY6kolZ/QA4xaQMwZ/3xKZe7xM/HMJ9RAKI3vnzIbOP8SYbSEZCDJ5mpc4hzKrYVWcGa+C0hP3Rs9RtjKqB7LXYCrEfO4SXWxr02kzhcSwfuP5Nu6iSu/wptcal9/ZxcxnGLiozKHERI9V9l7UmvzWTCNiIq9LlEvseomFMrT3SGWGvrLIMQ1CRyakLxvRKDxJLZFz3yIgo1iffyRKt4nDl6ebAYi8G8KDNwe4yQAruqK7bIXE7OkYMJoHn5Vb0CbsI1PirmcapGISnpxpnHEGkuvqkdJ8lwhSngx9qqeGaBO71gH+65X/lzVDDvafXlS+fViNnJcdCQLqyPjvyy7orsMcLjImvQLgrAhH0ZuAuxKlnFRv9zaYhikof0IqQC+K2bdYDFfG7/Y5U2YhSMw20UAUVPuXMk/Kwcz+Sd54o8Mtcr96/jwX3zMyTpoIQL9CVhi4XYCrlTfhWnaH+d1cdelPmNZvWq+3w+l5WI7XTHJ4BN2Q1i2ujQ1Wr8lGSYbCGgUtt97Fq0kvXGU7DdsaC6+fYWJVcJPEmTTCbvtkl188xEKj6KSV11AnpIc13kc8xDpIlBgbKc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(966005)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(15650500001)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n+czTti1tdbncreoJ1K4hhgijUFZD7XCoVjJWNxCcSxh2Jin0U2U6IolQcVT?=
 =?us-ascii?Q?QltSq3v9gUxGOeDPRcxinjalxT0OdoJEQMwTxPCBR+iOIgMtwYT2FPScNcNc?=
 =?us-ascii?Q?Wc9SptGD65iehAXsBN4+oULF+fyhgzvF8PemkTJpUHO+pTeKfp3sOjBssw94?=
 =?us-ascii?Q?GNqryLNX0nb9c6Tq+tMrEChBpiVdrqPXcIMTDGYB6RmN+BrZ397GmhVnoRQY?=
 =?us-ascii?Q?sfh8JpIL2RmRalLvUyEKDvNPgTID2qkpI1/4aJD0FCMhmtXtj+XLS1vYN/RY?=
 =?us-ascii?Q?yg/MNulO9qqycG78SScFG/GpVMnkwKbqCKtHyh5UMvhvZ4DKvFgBcd4tTVgP?=
 =?us-ascii?Q?aqlPH25RTSq8NSUD/0nW8+/8ZezgnGaDUcpdR4mBe9Twwr+HkDqanAezk9L0?=
 =?us-ascii?Q?nll7ZTbPloZO6rbgxrKfSc0z2+FJbRHdLdCAm3CKFAaiDoj0lFZ/KUR0r+Zr?=
 =?us-ascii?Q?yGFbiI8Akj8Bptd/TbQTNRGX7OyqrLMXj/Ej235PU1jy+Aqte2LBQKK+XAjW?=
 =?us-ascii?Q?l27AAJWu1mtnQHJdpb9ixJVtLewRe0WfTfJPOadoeMFGpeVn9U76bfLgTDaJ?=
 =?us-ascii?Q?0ramj4KHDoT9lRC0Bd4Kt34o6zP1KFhTORBbazCKH+KRQRBJxSQLT8Id9ZVn?=
 =?us-ascii?Q?NQaF/aZQ/E32VDp5ckJDUZLupRYLEbCWXA9E/gOtq6N1rQ+85P9CNO82TBhR?=
 =?us-ascii?Q?f1Gp0M1pPxgRpJ4v1lPcsyvBCrNsvacfAAfgIgMwAFEgCy+vQPVvJiDBMxUm?=
 =?us-ascii?Q?DSOYMUaXyuK5NN8Kgr0gn645XxZEIoYwJP1XPAmr6T1lT6354SF/EoPR+Y97?=
 =?us-ascii?Q?2JXRVwubByFf658We5Q0ULer3y8qpY8M9DYBN8540c71otNmYa/gc2v/QFBu?=
 =?us-ascii?Q?eGe2Wa9/4Xxl7MZrIqU8ZkKuqRbbxOZl3OKUMbou+Pjf8NBPVswIU0i1LQyq?=
 =?us-ascii?Q?jsS+SXImN8KGUdWJWCnMfL9pvugha/ZJp0STCF9swBFfEb1L5DO71icp7Pzd?=
 =?us-ascii?Q?+CW+85w/hiE1Pa3Twc/dbYSuq6MWPH4Ycx0gMkyAlwobuVoFMjuUV5ZZLOmQ?=
 =?us-ascii?Q?j1kuoZRp4KtpkDyWzUjbdgaVb8UeaS5JN6q23a6n2Z6gmm1/48jVsEWsjMlv?=
 =?us-ascii?Q?1iHn7PSKr4XVwVvZUY3+0FvsLcuJYepg78Fuf3pq9G9qlgNFmSgdBpnackc+?=
 =?us-ascii?Q?E1x4+iDH1nFjU3YKCNeYsfW0MJno+YE0R09wvtjcz3HT4F2Zr+f7YwGCH02Q?=
 =?us-ascii?Q?CR2EcT79DYCTXp/BQ3a2+ZccLDeKMVY2UpvJJ0BHLPIJQv8AdEWQ5AxdVXs8?=
 =?us-ascii?Q?tzkMsYfm+NtIHLnOxiWhA2LeOV7+4WVmpe3xBUDGpviumcPGgGkBDfMaZqEN?=
 =?us-ascii?Q?s9u6xoeCfuBMDw5ZjfC+EDhCd0BiJJNojTD1fx0+fdc33I+LjvQ33fCweNih?=
 =?us-ascii?Q?zuNNIzd0VvaR0iGXws7hBKjd7xWNaR4FYILgc3Bsf0XFfZiaehyzdcRwmTzu?=
 =?us-ascii?Q?eBNq9lJTZUnJJ2fNq3oDz4VmZVQO6R51RLX7R7qPZpsoCI7lrvl0XXgnul+n?=
 =?us-ascii?Q?zQtdIX5dSc15RuQX1nj7bGNpss02GPXylix5MpIodv54ZhzBk+0glgxYMAB9?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429a3131-95d5-4ba3-ec1e-08dac8f826cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:15.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWEM0mJZbHcILn3ViSezx+mgUK8HHPkqcw401NcpZLtF7b4R9YVY/FlS9fbgsnctCo7i1ZClyqOcnmE2wND4PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow drivers which migrate from phylib to phylink and have old device
tree blobs to work with the AR8031/AT8033 on-board PHY in the SGMII
SERDES side mode.

This would allow DT breakage like the one fixed by commit df392aefe96b
("arm64: dts: fsl-ls1028a-kontron-sl28: specify in-band mode for ENETC")
to be avoided in the future.

We know from experimentation with NXP SoCs that the PHY doesn't pass
traffic if in-band autoneg is enabled but fails to complete. We also
know that it is in principle possible to disable in-band autoneg in the
PHY. This would require disabling autoneg in the fiber page, and then
keeping the fiber and copper page speeds in sync, as explained by
Michael Walle here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210212172341.3489046-2-olteanv@gmail.com/

But since the PHY driver does not currently handle the complexity of
keeping those speeds in sync, we can safely say that no MAC attached to
the AT8031/AT8033 in SGMII mode has in-band autoneg disabled.

I have no motivation to add support for disabled in-band autoneg. I just
need the driver to report that it requires this enabled, which will
make phylink promote a MLO_AN_PHY connection to MLO_AN_INBAND. This is
enough to keep everyone happy.

These PHYs also support RGMII, and for that mode, we report that in-band
AN is unknown, which means that phylink will not change the mode from
the device tree. Since commit d73ffc08824d ("net: phylink: allow
RGMII/RTBI in-band status"), RGMII in-band status is a thing, and I
don't want to meddle with that unless I have a reason for it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- s/inband_aneg/an_inband/
- drop unnecessary support for PHY_AN_INBAND_OFF

 drivers/net/phy/at803x.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 349b7b1dbbf2..2ef6ac92fecb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1355,6 +1355,15 @@ static int at803x_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, ret);
 }
 
+static int at803x_validate_an_inband(struct phy_device *phydev,
+				     phy_interface_t interface)
+{
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		return PHY_AN_INBAND_ON;
+
+	return PHY_AN_INBAND_UNKNOWN;
+}
+
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
 {
 	int val;
@@ -2076,6 +2085,7 @@ static struct phy_driver at803x_driver[] = {
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.validate_an_inband	= at803x_validate_an_inband,
 }, {
 	/* Qualcomm Atheros AR8032 */
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
-- 
2.34.1

