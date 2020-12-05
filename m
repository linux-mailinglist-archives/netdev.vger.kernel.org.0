Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3302CFE1A
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgLETT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:19:27 -0500
Received: from mail-am6eur05on2131.outbound.protection.outlook.com ([40.107.22.131]:50144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbgLETTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmkDkDzklWTIwSOCMk7CcVbLqh4dlewyqiSJk6YIYmOIRSssMfhQWVYkGYtGwfelBBkFs8EwQzGJRcE9hw6nNFg4p1MlORPApZmii0K4QM3fI44BSecE8RKXvW0W1dmdqVt26d4mx59ORd4NvDhNWg+FDv5A12cWBjxZeZSkshGWh0ORgFUN4Z9OyXXay9J2Vme6eKU2GOSB4CAdOngLepE641nUTP9YwosFhrrN0rqHGzB+o5+16SrCRengWC2RbsFsROHb2SGgS89cCHLlcNBu+lzGeGRV19ZGxDoAJFSOUZUnnmxP20gJuEUIQqRjf5HGdlJSbiapT50lExOuNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74AwuYD7tIlZeGJl3TpO+C6fy2U26V8Sr/Ae9opE6+Y=;
 b=XyN7fJD0ME6LYbIz0GMs3nQZ5h8ZNLTolj3liqGdvhqzlQ6usdYA75aaGRaJbpXGz0QD4k9Ns6iVQgjfzk3KAUU+3YWwuFazwqAV/ZC3DuAFwfzhcBiDcsjrTno6e2wNTnptdiUWxye7yKx+PwMWGArLnYy/IOjqScJCv/JqtLwbronqyhtc/sxl/fBXom7hmUad1v7vLrAaYSNLCn4JT5tSNyP2vL/AAWQWJhwV3PRiIR0zbnlkF0n+BFlsjwofXkOh1q4H7ZR11DVdwfEDRWNqATny2Af/lqyOa7roDxmyXA0tBH0XW8OjDXu6abPKGTsQJTjPQdNfeo5wFdl01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74AwuYD7tIlZeGJl3TpO+C6fy2U26V8Sr/Ae9opE6+Y=;
 b=eRV2mjOgrkz1yOlln+CTBMYZ9gxiqiiPm4e18y7uYEJpx0BlQRWYcTQGsBQIOjyjU8MjaQm3ppphC0rxiMH77RBqowmDzt5K3hu1ADCpjtH8Lv8kLx1GyksKMWPetwEH9X7rjjIOG4e4G9XRwcW6NfyMIZWRdBmvz3c4J25jV40=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:20 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:20 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] ethernet: ucc_geth: remove unused read of temoder field
Date:   Sat,  5 Dec 2020 20:17:26 +0100
Message-Id: <20201205191744.7847-4-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a686bcc6-f3b3-4238-acfc-08d899528663
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13631875B659F13B2921926593F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rHsFAnszMS0tNpzuRTuyz73L1gl6wbTPXqPXO+2chdSpc9bsSRPi95qmV4J3fddMkwsPbUWmk8ZoAuMn+rPShBJanwApdqruoyCLCUZH8f72vFC+/2EJlNNEdlNIT7JkYE5NxnkPg9APwd2wPT20F7qA15sjtHX4Co7pR4uMAjGoFTsBy0/bTTmgKwVgtwZ77XsDeGa0qOHqDr/DuG0FXZlp11+hDS2YJl4cXRRMxGIp67kdYzltTsDeZQxm0iWJNiKJ0LHLHidOwzRU9IVx52Ro0Fw1T4kbv40IgCHMi2c7RN/gqSXadW21gMfot6yEw82OiDwmucn89PeBCmnzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lTc5fznCjD6lD38hsnKV547ogVzxDP0+GS+7BpZbhZuG0Fd7aGnJ+E1Sdibe?=
 =?us-ascii?Q?vUV8tzmp3+jNQacARxhS1yQCa46QXgmRw1sKW4m10C8xRgytm8OIkniixH90?=
 =?us-ascii?Q?FsBvbtjZf8NVKQ/Vy6GPBIge5qmVQ2ZNExnqxTtwcxuTjZ42n+qkXGjyYmzE?=
 =?us-ascii?Q?XjZJDUAxZ/1Yi80rV8fCg4qKCjj4s/DelxNxtNzi9dQkv+NNnANHDpZYUQCd?=
 =?us-ascii?Q?wlpZevj50LKiNRCiNlSEA1Jf09GIjzWP7XX3+l+97ZnMkzYocPgwzwJT8tl4?=
 =?us-ascii?Q?H8B2Ajp95gvUv4Un3LVqe5IDpArbRUjeQzZVtiHlyoab77ALETstig9+R0yJ?=
 =?us-ascii?Q?SfB98Wzr4DqYtknZkxr/+HOk8QALDFpDFrWFn9YMX5yqLnIqX8Gr/Nih/KMP?=
 =?us-ascii?Q?CfhaVI2MF3PUdsAiJxg5hx42WHmvG7+poMhReFrLS0f4JGF/wOs5hvQuHfWx?=
 =?us-ascii?Q?2/fd3RYOSyJqyN6WylkxEQjb5tN1+U1OTr/1KvuLio767phoX+Nz7OEtrqV6?=
 =?us-ascii?Q?wuNyT/ynHMnxU4QN0RIrUOfz9O6CV41DpNauahk5PZKh2G5u+9VHk3UfXhN0?=
 =?us-ascii?Q?EvGOXXJWPe/76A0hil8Y9k/9FLlQl9e5TyBepYpY79OWQYITyxLAz6ngR6dl?=
 =?us-ascii?Q?lrXLU2E3ZyzGZtbSd86jerbCHKDRvDRok3OQ876nWuLCRbvyQ9Qp0jtvlT9H?=
 =?us-ascii?Q?RbgVG7S1c1/sKYrPAM/lj/RTYJBc7Q/zqHFviiVBxk9u1Hs3LETs5Ma4Qctr?=
 =?us-ascii?Q?X34JnO8tfweTnD9RestomxRF+3Tq23avPY070HiuI8cNfYTBhFC7vu87hSqc?=
 =?us-ascii?Q?VYpmYL+h1CQanH1P0T++50mee0rNJr0fD7Xizj0gYeU/gpO02IYjEMjD+PpE?=
 =?us-ascii?Q?sHj2zThKJYAREVx7/OzKMN9vkH52t2/l1UOr7iWFOs/wUH5LS0t2LJhsiQ5J?=
 =?us-ascii?Q?R0Tlo22gEeMK1u/iAr1ejGld/VGiBCD09qvbUMyBiLzXeHrekhj+EPY/oyPo?=
 =?us-ascii?Q?LDuB?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a686bcc6-f3b3-4238-acfc-08d899528663
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:19.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iuuut0wqIn4v4w8F43qYLXkSbR1MoaU7cBtvJEOhbYRevNztb7qI/EXEaA1l+qcmRT8tOTq2obWNvsY9HM6AHVY7ReyNBQgaFlsYx4QsYMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In theory, such a read-after-write might be required by the hardware,
but nothing in the data sheet suggests that to be the case. The name
test also suggests that it's some debug leftover.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 380c1f09adaf..6446f2e562c9 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2359,7 +2359,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	u32 init_enet_pram_offset, cecr_subblock, command;
 	u32 ifstat, i, j, size, l2qt, l3qt;
 	u16 temoder = UCC_GETH_TEMODER_INIT;
-	u16 test;
 	u8 function_code = 0;
 	u8 __iomem *endOfRing;
 	u8 numThreadsRxNumerical, numThreadsTxNumerical;
@@ -2667,8 +2666,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	temoder |= ((ug_info->numQueuesTx - 1) << TEMODER_NUM_OF_QUEUES_SHIFT);
 	out_be16(&ugeth->p_tx_glbl_pram->temoder, temoder);
 
-	test = in_be16(&ugeth->p_tx_glbl_pram->temoder);
-
 	/* Function code register value to be used later */
 	function_code = UCC_BMR_BO_BE | UCC_BMR_GBL;
 	/* Required for QE */
-- 
2.23.0

