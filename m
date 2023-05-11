Return-Path: <netdev+bounces-1670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBBD6FEBEE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6EA41C20EDD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7E127702;
	Thu, 11 May 2023 06:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A604371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:51:30 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2127.outbound.protection.outlook.com [40.107.100.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33874C13;
	Wed, 10 May 2023 23:51:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPndvNvM3hGGkrAuhCMWWXDxCDXmUrYA3CMP0G3nzozcR5a3TWujngQvfP7SyPfekAflceT6ETcATNoqazxnKYYWp8MVp3Y1A1IjXKOw21Q6mp39CmrVHzblVTE+4jLZPbXcgd7zNDMizyGHB80TxrgM+ugtc+O4UapaqC0PQBsMKQKTKeqoFcbpeHA/HPcG7vxby0fjldg48KyDZl0mP7W/tmw/gSbSedRf8+pLaVuJFrvZ96CDDm21CLZg17uMOfpb52ajReXimDB/21JbAIeVfXTUzC7xySW7KqnkSFKRwpcsUetfY8ywJSY3FM49IYFJdTTwbbHpnM9p8peNuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1O8tzz6MVRNSKBgeRFv0W200UwW80OpHQh9MwIx5eg=;
 b=IPyH3TyNXFny+RGgFPXK//gowh+Yzyo9qhl+enpAMFs1BglQHc59r8fGyKuD9iinB7rk1+Df4q8AbSY1lo9vf5TeceRF2uah1w1o0YUyEypuFenZnxp/kQgcZBINTq3sYcqCzqxaJGMrQnjZbUZ/5kqWf1q0OLGM/whZVd8L1ja4/eUj1frkqBc4AAkIYLWra7VULr+6AGeplDbZUkFWTwpI4AlB8buVj+IiXtYtWEnfIBuNj3kZS/3HZAxAp1gUhe4RcJpRQykZbT8e0VVoSSppx8yV7rKXsScyFxjGx+ArND38rV1vegpkKl+ZZw0pb2chkdi/LnLrSb5+vEg3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1O8tzz6MVRNSKBgeRFv0W200UwW80OpHQh9MwIx5eg=;
 b=tMq09jfj60QNxqNOYMU1b67gQL0hjQSlJdALBj46Ka8MrYpU0iZdYXtuPke2ANv9u8QBuknidXO0aTDyFYOUsxGDYmiDefvLBywvfyz92mkoCrylhZzdLfCoTcGBlkFXndq+iriWng0zKMQzIASMvPVnj8nFlNHrDXLYtWYi1sQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 BY1PR13MB6214.namprd13.prod.outlook.com (2603:10b6:a03:530::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18; Thu, 11 May 2023 06:51:23 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6363.032; Thu, 11 May 2023
 06:51:23 +0000
From: Louis Peens <louis.peens@corigine.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net] nfp: fix NFP_NET_MAX_DSCP definition error
Date: Thu, 11 May 2023 08:50:56 +0200
Message-Id: <20230511065056.8882-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0072.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::23)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|BY1PR13MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ccf6ff8-1937-43d4-b60c-08db51ec2210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7dVPkMc5nAMnZTxjdGjjjrcqV6KfT3tqDUbTkkz6rL4i9RZr6lqf5QUK6ZKEwclGX3HRad8dHNVcFCOz7EN08quZ7kRc+1K6LT3h+VK89qafJ2+BG8zZR6X5jmmc7ZMo4yES4KNzagv6lNJMEZ7Xelyu0vVrv+giXpFuPH/TIrfH0R2kWqqBwW78+76OJW5qTRn/7YTu7TbPJRhtIAN3D864jdvP84WI/GLWs8ogBPKNHE/woz6RiiWHrQe0QpSgYw/hSDqrUbfQRdrfw2ZR4/Ebm/jy+utJm/xB3ndNsh2rqPl9r8AIV8pkyTMD//isqN6i0nEVdmZFgCTV2Z/Ul/k/Zehv5xS09CGFtZhUWsP3ssOWpeiMEVHM9rDDbYLPScPjTuG7Zmu/yb2dHLC6RoWgm/WCoRnIBbbfrjf5BP5wRw4pMvdu3pgml7uujR5GNe8paMNU/FE0KhHrLLUoO8A8ASqfRyIjcdXv4r0PXmDMRolMbBOmCiA2MPpfRwrcV4p6MMIAcwiHpt545IV43c0UVK28ZhIhuFhJyEN+x8/2nBw3e9qAz3p6XQXdmhO1IZBc78vDxjVfyx2gFlTFJbv9FHwdyxzRDCrdGEN/QrPNFyRorKGb7nozWaHc7/k1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39830400003)(366004)(376002)(396003)(451199021)(26005)(36756003)(107886003)(2616005)(83380400001)(6506007)(55236004)(6512007)(186003)(1076003)(52116002)(6486002)(6666004)(4326008)(316002)(66476007)(66556008)(2906002)(66946007)(44832011)(5660300002)(8936002)(8676002)(86362001)(41300700001)(110136005)(478600001)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6sMsouefxiQnQnEMsQ+ljIAgwXqchV6mm8UPDw7SidY3Rtu3rgtgy2bg/3L9?=
 =?us-ascii?Q?pww2CDYCL+t7ghZdafKyzaa21DbFp+IsKqY02Upf5Hwakhgm9X7LvyyFrpdY?=
 =?us-ascii?Q?/1pWnqmZTnOQSt1cOYL77rG7y2z4H3NivkjsbUPSQ43hPvkjhi3iLhWXCHeK?=
 =?us-ascii?Q?KohsPvJjpVlopjAnWhXh6HDKP+UxgCOxVA2WA/V1AhkVvgmgfmOUixr5JmiD?=
 =?us-ascii?Q?DPdAanbFFnJZtFuFRc+NT4HPM7QEEGixSLrE1yuXPTVM0uwczf3cGPVSFeab?=
 =?us-ascii?Q?jLTjYoAcf2VueNh1u1TtXme+je6YCPTdYkItEvd0tCyraCW1pmU5XEKTP7bh?=
 =?us-ascii?Q?z522vD3gtYw2SawqbnpMSoObGzXbw+Ut8Se9kk6hxJr2MH5xR1XIyM3siCnN?=
 =?us-ascii?Q?S59vE/Yw2+EB7IwE6PR6YLike9dN4GXGxqMy9xEcIT2SojxYPD8pAdI2ssfA?=
 =?us-ascii?Q?MS1SzFTyevymoTFGiY2RNwaO90FTY7XkSy7EY2+G6vcswwrCLXz4XpY9642d?=
 =?us-ascii?Q?jsK4A0LkZy2kDK7fQh69NlVZZusXxQnLL8Y7guQKd2dGKGTFxPkPFSJ0UX6g?=
 =?us-ascii?Q?oEJdf9RhhUHIx928mJ7gAykrieI4V/0BeY/VVqS9obP0EbiUeBLdgfbaM61k?=
 =?us-ascii?Q?BTJDjq0Bbv1AvH+obtDQN3rjRdH4I9wkhaRcqBV/5XYTL6E0o68oGYfhzu53?=
 =?us-ascii?Q?0zWPGAML1K43VkNW2T0PDytR7de5pV8raf0VVbTVGgLNlQjNPqbuPEwp/IHk?=
 =?us-ascii?Q?Rv2ZXOiwgzTBb3MRDXD4gJT7t17dHhsQSVT4iUuszw/i5f6mS4xxBtvqgEin?=
 =?us-ascii?Q?XhrIWwgT5hJ0hd9ZPNjJNnriiz5tsxG6lP8TQJbAMqOuSpfEvZ2ZZslK8ym9?=
 =?us-ascii?Q?fZ9BY1v+/zgMDvT2kf7GbBuNm0r65ebAXSCQMaYfxdIjckL5SFRve3wpCIOq?=
 =?us-ascii?Q?66UOdzkhus8WoTUspVqSuo/H7/LKd4/U7Fp62+weOyCKyoZxvLBddqsFh+aJ?=
 =?us-ascii?Q?Lgsp5TrYeW0mFx7FTgXSelHyfncAURKcKwRYMrcygJovdV4gpCy42Bu6pEGt?=
 =?us-ascii?Q?djKmFFRlhcxx0UGMt0FhfqJ/rhXt1Xa8aA/+ATfG6b8YiywAE2Jttd4fSgG0?=
 =?us-ascii?Q?jDJQ3RXuFWUBpRFSY5aA/wJiReQbbGQ21UkNU4Gn04JGPH2pskPnM+ypHNaj?=
 =?us-ascii?Q?mpUwdcH6uJADPv/LKnXmvSeLXbYQGu4gIhEMWDXyWvsxUcPkUjWlMIwKKoKg?=
 =?us-ascii?Q?fSsRbwvF9zmwlLp0kGeniBHXNKL+zu7CH1qnIxXallPVunWec8W2J4MxuqXi?=
 =?us-ascii?Q?JbUIX5oNDV8QS4XQbAndKClkaTOK/kXERsbHSS0ifhCvXzAf1zMv7n1T6lYg?=
 =?us-ascii?Q?GMqbpn9QKAAu2FkZKuv50A+Ye+4ui4JZHcubUnV+Fzee0KDCycCDYQwnUbJH?=
 =?us-ascii?Q?A9ioOzEkriPuT7rz2wATW9R7ld3J47pE+octFAePTKGVPcwkZsqFsQuOYj82?=
 =?us-ascii?Q?XC5XmGQILKDe5mnnMZrbt3ncjnSfbYmUAL+OIk8jrKfE5+tOBz3EK/KtBnuJ?=
 =?us-ascii?Q?SmRH/LzY3KYTcNq8n1tCGvJq3dcz6jLhr50R+BfeLI3EBsUusf8G9bDuVCjQ?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccf6ff8-1937-43d4-b60c-08db51ec2210
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 06:51:23.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9MBJVp/+1D//KkIG4QIsYhSgcwXMLSbcRbBuym6sAaN+WHdxQb6O3q8EyEg0Iel1hjWMfDe7cd4FjhtcjiHnAi3RNmoSwX52T0hCz4owfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6214
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Huayu Chen <huayu.chen@corigine.com>

The patch corrects the NFP_NET_MAX_DSCP definition in the main.h file.

The incorrect definition result DSCP bits not being mapped properly when
DCB is set. When NFP_NET_MAX_DSCP was defined as 4, the next 60 DSCP
bits failed to be set.

Fixes: 9b7fe8046d74 ("nfp: add DCB IEEE support")
Cc: stable@vger.kernel.org
Signed-off-by: Huayu Chen <huayu.chen@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nic/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
index 094374df42b8..38b8b10b03cd 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.h
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -8,7 +8,7 @@
 
 #ifdef CONFIG_DCB
 /* DCB feature definitions */
-#define NFP_NET_MAX_DSCP	4
+#define NFP_NET_MAX_DSCP	64
 #define NFP_NET_MAX_TC		IEEE_8021QAZ_MAX_TCS
 #define NFP_NET_MAX_PRIO	8
 #define NFP_DCB_CFG_STRIDE	256
-- 
2.34.1


