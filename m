Return-Path: <netdev+bounces-1323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AA06FD552
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FD691C20C78
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D654164B;
	Wed, 10 May 2023 04:49:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB64063E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:49:07 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2097.outbound.protection.outlook.com [40.107.95.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4162444A1;
	Tue,  9 May 2023 21:49:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agR36XFRCTApXT7bughLDqm+svUzGfZPT4ilgFe/RFi+M0dhPXrqDnBjkcoO4Dau/zxF+A/AdzatQWfvzriSDEHlJ7zCXnG/oebu+duZ8JIWEWCAgFnXFOoStlgkAobaO/rWwVkRdi3iDWemMBQ0Pas58pF61BmL7KpaV4qkzKghW7vjQNs4gTJ89OfZNXTZpJGWgf41NPUDBExirRBgF/PWoCWvf2rCbsYQOvpi3p24/Ka3zvxRL6rJNswsT9FrKXPWIC8bROr3QsQcUvNjfLyBH52uu5E0cxx7Q4iZY/F4JBj5ebRU8B6N94BoyN2ux3bjrm4VEyz1Kg65zFlh/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv27uHEJ7grTqKL++2C5W/zv+y5K4NmzAtlDkCcjcvY=;
 b=ahm4Os1p2foH9y/HmN/ucpSsdCEQwuaAbgWyXgp5wifhVbm65bn3jCI59A6zU5V1kCPMLWco0ju4kAxyCx77wlnNPmMq5vZF9edPDT2W8mlquYA4oTFOBGVoHiSiKyYaY2M9VShXgqpNI4ZwdA/zOiEvC/QVqH3xS3iii7jq1ATy2Tyvz8gYSlQgkfX+h9Dwu6hFbL9DjjRsplNdnCkUWzRWtdxo/QCJ8ECgA7dgWUZYrUTKuYPZV+PURb01dOYWGuE5Q2Pdpb8mir9AYs9Y2SPmqg5GRTg0PnMm9Q+a5LMLydI0JzDiLCVFEFkWjLIK+siXNeH/slmnSNCbybV9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gv27uHEJ7grTqKL++2C5W/zv+y5K4NmzAtlDkCcjcvY=;
 b=T6y+mv2TEySGxjSnRsiHxuClWhJNTzRd7UxIJV5T3nnTvPy8hcWS7ZFJ1XhSuujK2OJgHLsXzOFneuGz1+bhg/hCU3hexbf1rXVbOh5smLMWClmBkC0W7cUWOszkdWB/QJze3/YcJW4qcSu3iTMlviEF+jsf7q9yLt4ebqeW3HA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5142.namprd10.prod.outlook.com
 (2603:10b6:408:114::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 04:49:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8374:2506:121a:5612]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8374:2506:121a:5612%5]) with mapi id 15.20.6363.030; Wed, 10 May 2023
 04:49:02 +0000
From: Colin Foster <colin.foster@in-advantage.com>
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	UNGLinuxDriver@microchip.com,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net v1] net: mscc: ocelot: fix stat counter register values
Date: Tue,  9 May 2023 21:48:51 -0700
Message-Id: <20230510044851.2015263-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: 6187f1a0-2d12-4e1d-9b2b-08db5111e05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B9sr9vTIHdpasAN8X9o36d4T27UxyBjeFC+eNNPn0AQ8BPNwEChyO8qZ1hH3tYsZ6AIO+OTbPEYCJRLPPBSfIOkLA163rJA+MsAyIcRHXEYm/XRjrKEMrdhU7hTKFhNKcBO8p2w4Mx0YBzfHCntUf9YvAUBfNAcQX8adZ+Elg4wYr61RmfBHzA7VcJB3QFU68bsSSpAlx20QnoEJJsWJFxuBkmnJ6ch4xhq11+nMy2U/i19OpfIbyX00hcT991tEaZmN6i2nClyPlqB7CYZ4t6juwULiBxkQWMAHXne7I+eVl/yiIB9KUfaIYdCC71uzlTeqm5odW/QsZc+2gqybvsv9rqLkJNZm+YvoEPkjWCdszwXnVI4ZJ7TaK79ys5pS7QVEjD1gUsLpZrKszLJIuXneKV696jUtNM7UchJaZ5PBdp6fT8w/TDfbXFt/f7p97QOHFs9i5xFyh9XwLCE5nF8/8t+J//Vgi/c63dum4Dah2QT+c+HR9DQ3jcejwonQeJx7z6GqYsCPec49JslJ9xD+OQ3CrpMT1qhFrTjovFES5wR1Bfz+8+cWNOFpTc6J/mTjRKPqNjZgSCe09MPzORFKcVBQMwsaaOVr4fEQFGC9HQZXkjftsUiqthg3lrvR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199021)(38100700002)(38350700002)(8936002)(8676002)(83380400001)(54906003)(2616005)(66476007)(66556008)(66946007)(4326008)(316002)(41300700001)(44832011)(7416002)(6506007)(1076003)(26005)(6512007)(186003)(478600001)(86362001)(2906002)(36756003)(6486002)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dGrdiQQC6aex8FjZBdATTpbmjVokPzDVIBpYN9R4yJhnmSzs3DwuTxnGoaE5?=
 =?us-ascii?Q?Y0Siv8XnqJmD1cc3NjQZ7LdwowTgIKrqB+N5isJ8/8fcsQo0kM1nX2oic141?=
 =?us-ascii?Q?jyFF6IQ36SBYGCVbkjp0R8lyIk/6bex1k7Ux9WrWnxfubAXJPvDyxZikjrpg?=
 =?us-ascii?Q?iEeE86XKDZ1tWEOxGL1wVofnjOV0lIzc2h32Mzc1CX3S1BcHgePwFrIs3MJA?=
 =?us-ascii?Q?yIU4u62cCgBtPWY3M95jwWJu6i85ydD79sfqqIdz+bwuuyrUIUZNvgiZtvBi?=
 =?us-ascii?Q?1hKF4Nw+F94KhwmehO1baCBVdaVcR6aJJcXIvsRlnePJvLe34YTuHamASP0Z?=
 =?us-ascii?Q?8LmZzX35iTlptf3FqxsVA8khhRgjjX588W04H0AUHgLJC8/oOVTf7h25i2eS?=
 =?us-ascii?Q?bwI75v3eDcnn+PB4/qdHYGzIzwY47nUc1IFghRAQOOMF/Ci4FPrK8tYpWR57?=
 =?us-ascii?Q?+3f2BafLxH7Yr3AaamfTCvbD4tP2SdpyCkSIkFP0dv+KkfECpMD9h8jo9QVi?=
 =?us-ascii?Q?rmbXLhHC5AH2+BkUYdI6OFjN2OOpnGj6CqNI4oBWUqPs1yb/jhduwoi7+MZc?=
 =?us-ascii?Q?DpN1BbP0/+DJg757DUv9VirlGw4rkjcmd7lCOHyJodHsQqufJbC5OKxGr+Wu?=
 =?us-ascii?Q?6mjPVaNELQQnyy7CCQTwqt70c9FfLpJGexgtpAJAegYGRgG+/6AsD7qPl0Zv?=
 =?us-ascii?Q?af64buCq2RNbkWZab6S/RKEnMpkhZaoXMLQPvaf7grYHQMpooxdYOUQqMbpt?=
 =?us-ascii?Q?Tyh2oRRKr0IufV/eJuHvqyGh2pQPDx2eFnovb6mQYlZOJc1zRIIPRCCWKdnw?=
 =?us-ascii?Q?LHL6vm1c4xg61dr8ltsCYqMgpfcashDFNwOPBpULyQDtVAkAwXQHnzXoEzO5?=
 =?us-ascii?Q?a67TUn1MhICF0WfNzNRZpWupsR4y3G762osiq4s4YmJCseoVnDYqyO6ODTx3?=
 =?us-ascii?Q?tsZAb7VK48gZjVS7iBWaN4CvCW0Gm623oRnTW4t14QGpInnB8Hb990QxFz06?=
 =?us-ascii?Q?VfqiQNcNhGev7MbUGeH4I67aI5hzp5aZz0uqiUElHf9K6dM1MRsALrcVEovr?=
 =?us-ascii?Q?x/zKJfpugd0FB77ZI5z6zHdGQN0OLTx46ef5dloaHkvLVym5OjBc9Q5G9mRL?=
 =?us-ascii?Q?h6MoUjdhipiimWSG4F8+/JjCk+o/OpVp527A37VW0LzkYi7RFY+ksSNxVHaU?=
 =?us-ascii?Q?KBQO9SJXeSd5PkXJC7GOkQmx4iY5EYVjIuXk4SLZ0Rp88zBNY1zVGVA2Lxwu?=
 =?us-ascii?Q?rb01bVwXdcGfylF8nwo9OOgL/SJrG1rmj2l7SWzFUk+06F9by3L+2wXERjaV?=
 =?us-ascii?Q?NPK8TWeGeFn4biQRh9fJ5zUKApEvyNbEZvS20UkS1nHGhgBlonXeH6lzWiJY?=
 =?us-ascii?Q?Xo/dUGkhfQpb5FdEm8/vCSM6qNKkjPexKrog+DFm8/msmsUPra/P+3oNZC4e?=
 =?us-ascii?Q?bWKR+qcKkAODQA1rwqSsKm/FusbQBldTBZHQ4T6TAg6bk8nK3Y92NDZuqh0y?=
 =?us-ascii?Q?sFC9PHPrpcKFNpDhJz34c5ud5qAB8ObsbyYNgU+vxAiY4DSg+z5TGEq/mwPP?=
 =?us-ascii?Q?ko4audMP2k2mbkc30RnQbJ2hgSMfyF9pzrEozzk8jejM5L6+sowZHfG35civ?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6187f1a0-2d12-4e1d-9b2b-08db5111e05e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 04:49:02.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYyOxlCAhxmEOol46y2qUlgE2upElNfCEfrwPOqZG/fMrs3XD+bxpbdpMWc/yLue9X++w5SNl7omUPtLPHIX7U8HDn5meqyg5zVsdOheA0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5142
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg
address, not offset") organized the stats counters for Ocelot chips, namely
the VSC7512 and VSC7514. A few of the counter offsets were incorrect, and
were caught by this warning:

WARNING: CPU: 0 PID: 24 at drivers/net/ethernet/mscc/ocelot_stats.c:909
ocelot_stats_init+0x1fc/0x2d8
reg 0x5000078 had address 0x220 but reg 0x5000079 has address 0x214,
bulking broken!

Fix these register offsets.

Fixes: d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/vsc7514_regs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index ef6fd3f6be30..5595bfe84bbb 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -307,15 +307,15 @@ static const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_4,		0x000218),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_5,		0x00021c),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_6,		0x000220),
-	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,		0x000214),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_0,		0x000218),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_1,		0x00021c),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_2,		0x000220),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_3,		0x000224),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_4,		0x000228),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_5,		0x00022c),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_6,		0x000230),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_7,		0x000234),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,		0x000224),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_0,		0x000228),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_1,		0x00022c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_2,		0x000230),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_3,		0x000234),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_4,		0x000238),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_5,		0x00023c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_6,		0x000240),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_7,		0x000244),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
 	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
-- 
2.25.1


