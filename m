Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70249479DCA
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhLRVua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:30 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234670AbhLRVuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVPfVFKxH/PNQwH2xDLzVWcbNVqp+YuM0Kmr1Fb5bLowRkox5NCQD6IsHIKwoAoSjFyiig9P7Rs8d+n4ZmKw2KO8dC/X2udVmE7YMyBDBx1NTpkF77ofxfbNnTOBWQ3HhqpCBt/8LC88GfPvVyAroLYIEKxA5g9+Y/pg7oyK2g/NpNow0lioYb5mD0YGkAhWg+3rqy8BfNx9Huca61tG28JGfcaCddWcV6+aNEL6D9HRRV6wGwdaKcytNOpS3Hp2JqJlr01VMhpr4mxlp5+3hTO55yQqN/AJAnw5DdwXOrVaNftoXqn4gV16fL77ljJ5tpwsF/Juyb8JMkmKyjFcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CfnaYeUYuUx7UDcFfzImjqT+OGRjX5JarYlmVy9yik=;
 b=ABLmnqKR+t4fplYKR64JXckdtnvSpSRMnh5bAOvO+bjvATL6M5DyyalyA3z77HCq4Kkkq0klwGohnspY1JvqDjdzF9Jlo/vA8cRKB3hUl/5NtT62M1kPqNiWwBbSPbtGhhxdn8S2/+wcPs5d8ITWHewghhKWVx6JZCbEWzZJE/5eKiBUiex96mrXr98+VTJnWgsTzywb7Dk0bTOH7otakEWXL9KeYjym9twW4cWZvAs6nuVUjUjvlxO0ipQOf6kQqAA57Q1x7S+LblmY1FGLX3r/gfm4I5pfXPsKfCgGocoNj1kwJ+msqbtHLxXIs6rD4TD9ilsKhpxZLCua7Ju3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CfnaYeUYuUx7UDcFfzImjqT+OGRjX5JarYlmVy9yik=;
 b=KWgZjo+VQEPZneMaZHFsXbfJdfpt3gegQ9SyBxT4Udcg7ZLSlc0B/UO5rpOSulrT+6D1Uei7Wz1zViVOYGdU7XCiPwJ/6s9JvUV8uxtZtFWV+jqXJtzXclR7X/MfDvuKyHOHyGYjbUFRcqN+R1Um4+cXK1f6Q7vEwQ4pq1mnXrw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 13/13] mfd: ocelot: add ocelot-pinctrl as a supported child interface
Date:   Sat, 18 Dec 2021 13:49:54 -0800
Message-Id: <20211218214954.109755-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6294ba-e5bc-4d8a-32d6-08d9c270601a
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56336A2C9C207FC1E9B74F96A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTynI8wa6R+WG4cUimEBDf3iBoPw2bk4NzzZObBXk349u4eDQtIt8xavVIEne4DomotfNUK1hCLVDtYE5poLWYszrobo5hpto91Mx8S4Yr/7gb94MHdj/M/pVqwfenwCAKqDD8SKyBiPJbIym8xyju72sE/dyACBMn5biVbnDKTlu2gfFueFRXoXEHSYSrfUQVWymTLu69DJ7iEMnLT2/MASIPsVrgFBiB/y9+y6pSran6ls15wB3lr25nGf82hihq/tuuwkGjkjkTHceqlLXyJB6tiNc9sRdxRosuY8x5HbmXXlbsXXj/NkuHC8H0gWl157j2TUPXuMqKKCPtmpj4qZ8UuWEeJPqNWBbwyF6Txb78pamONKOy3hPkkD/TPcGYYSceLyNiwrQ55qFqpntgu9p0Ufvx2t/2srw5tAE+E0HaQ9fcCBUwdsjBSU/KYAtq5JNHska9qriOMmCGKOYOpXi9zU6x+PFqRKBk3CrEhpEdR7mE95D8f7rPbNEDPwz9v1EEzGYVaCCqt5phRgTpBYvKI7Vg6gSYeTyWM6f1iQ47pVIKc4HD5BqQij81oWrg+ogHWewUNUAH2hiCOlxcctxeG3mUWmjfCBYVcXMGSWfPzZXgxusHz35tKIygVddNmdpBvBh2DItCbpvqtHPZtr4p0yagNkScQWwY3SU11l9SZz6uy/48q37RYJvfhHxvtL+ZyBM+s/LEUF4cTO/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vxbVbJ2cDePuS7+ML4qL6JlmteSU/+yVKVLnnIdezk9050tOfRi78E8gOLCe?=
 =?us-ascii?Q?pcMwIg55+NCnAM02lU0jVFwDQthxB0AZ3tiUZjc+omh2Bgvu61D8dgA4HUH1?=
 =?us-ascii?Q?wWBrwC69dft2NrbG9/P8vrhIFJIPOflD2bkkkM4GSnoAFXRZn4w/JBxOBu2F?=
 =?us-ascii?Q?ZiP6FzUGsedera2QvLoACSHE2yS94qa/VcchZrIuEDCyIcs4c56ayptjm0MG?=
 =?us-ascii?Q?5felnf0dtXEQAD8HRfk8ypcs9jj83cMWxtjMRV0YtoFYbtHEj4NPHhTDWsql?=
 =?us-ascii?Q?b0k7uKPF2y8mkKoZUVJU1hxUKVFI59L1NDErnoY4IiBm/LzaJ1gUlasLquTA?=
 =?us-ascii?Q?gfYTXmztjndM9MLrdVpWMcN4+AiZylINQwV8liiGn39v8UB4cgwsyosLiPRO?=
 =?us-ascii?Q?AQg8dYCm1S/6WlE2O20kGSKTy6dPqJKr6mDpSwose+73eZrUB/Xs5RfLaL1z?=
 =?us-ascii?Q?VJKd8rv6WwV0DEoDpk72LlbRBaG2shiuVtq2vP7qqE4+wDCntKSeWBrHf/i2?=
 =?us-ascii?Q?tcpnE/YpBnzHiZ/+iLfN3UW7qgYAV7d9C0gn+g+BsQhuOPCKYcaUKZRLOzdV?=
 =?us-ascii?Q?rrFcfrjQtlPgZRwz95ccEgkS8s0pbVdHjQNLzqcbtdd5/DzNmg+V27v/1daz?=
 =?us-ascii?Q?rsOUlmb4k2tfdDR806jf4rGSfX2K+HnMsivp+lagMdK3efyjmuJMpHatYJpE?=
 =?us-ascii?Q?vE78gvrR2M/UuHTPuEKaa8q/3Hdb6J+a7O/p1pWdJdl8oirGITHZ+Z+S2ABJ?=
 =?us-ascii?Q?HVmIK5u56dOeps0qK99S2ga1bMmwHkphTzMGcCDyT3mfUIcsaIPe09Ip9LLL?=
 =?us-ascii?Q?3qJhHrg/cLS9To/WQMybzFfJmcHoGdfpnQJSENMxyOtcQHx2VWMLeAOETScX?=
 =?us-ascii?Q?MCFsMvqHA2Fq2o0DghWYOp2pLr+pHx4G46yXBvxiEQqezjec94+wJZBrkXoo?=
 =?us-ascii?Q?Bzk5nEr42I8yKfIVEHqzrU24buQl33laRIBd1EY68F9bF24UacopJ66mh7eB?=
 =?us-ascii?Q?Pr5p//X4EGDs8AIhWj9xwYLs9zQnHSvUE4R1LwFkyIR89c+HwRS4DX0TV/CP?=
 =?us-ascii?Q?X+amEd5DSw3/Ftt2yrLj0sMaQ3HlAh8Q5Mqa90hjA8n70Gkx8kXqX3ks6J23?=
 =?us-ascii?Q?aU9ymGGq2RzQxXUqwOoWiO/u7Iy30eaOZR7Ox0+cPDQo5kpnyRINcyeQxfIz?=
 =?us-ascii?Q?gjMf89IFZtupsx2LT7JrjIbQ5lfKQm+h+3lfRGejJgW3LWg8pi/Mt5HsWLrj?=
 =?us-ascii?Q?XpKL/OZ10rsUIPi5/zcdn6U/YleITZgUzpEzYNuVFCZsK9bh8ehZfLHFC8cg?=
 =?us-ascii?Q?659W3VjUZ1qXCg/9GkJZVJWmqYpwUj9xSGBEnQfUqEKY/O989Wo6OEDspm6d?=
 =?us-ascii?Q?3I4eW5idk0bE6S0IH0GbiUbKn+ZR72CSA/UWS+a4CMZprDjAUrfGhDiTI5NU?=
 =?us-ascii?Q?S8EYGUD7ZxRMrnl6kybM6bf+Y+IGOMwEjfgLW8j/KGTyLFx0rlQ2FpS+GlIy?=
 =?us-ascii?Q?qBctESVxEPeN7iCtSMnalIOM10b0je+5Wbp30NzLLSdYZHKr4M7GFuD1pW+W?=
 =?us-ascii?Q?LamqPAK4sVnDgv8M/BW0w0x6swdeylVqaa30pfr6m3gEkiAaCSF/7CMNYa5O?=
 =?us-ascii?Q?ODsbgOllNeFLXEWrM7AudhSP1S8yUo4JKUV3uLZS+tzFJFddp2Qpudbumaxu?=
 =?us-ascii?Q?PXcfnOOp7lBTJFtEPFEyLvcAEJI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6294ba-e5bc-4d8a-32d6-08d9c270601a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:15.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxJ9YxZfSRcz2TkpUp+A7edsWuMvOnIoDYClRA13JiPkC9lRRxX7rw4ZQ1xB3Hf8TiJ9W/87KefJc6pFnn16VN1qlvQ29mjo1C+cdh/9Q6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-pinctrl device is able to be utilized by ocelot_mfd. This simply
enables that child driver.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index c67e433f467c..71e062934812 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -113,7 +113,22 @@ static const struct resource vsc7512_miim1_resources[] = {
 	},
 };
 
+static const struct resource vsc7512_pinctrl_resources[] = {
+	{
+		.start = 0x71070034,
+		.end = 0x7107009f,
+		.name = "gcb_gpio",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
 static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "pinctrl-ocelot",
+		.of_compatible = "mscc,ocelot-pinctrl",
+		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
+		.resources = vsc7512_pinctrl_resources,
+	},
 	{
 		.name = "ocelot-miim1",
 		.of_compatible = "mscc,ocelot-miim",
@@ -164,6 +179,10 @@ int ocelot_mfd_init(struct ocelot_mfd_config *config)
 
 	ret = mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
 			      ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(dev, "error adding mfd devices\n");
+		return ret;
+	}
 
 	dev_info(dev, "ocelot mfd core setup complete\n");
 
-- 
2.25.1

