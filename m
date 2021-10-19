Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7ED4331F6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhJSJRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:17:38 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:31760 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234511AbhJSJRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 05:17:37 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J8VJZg018153;
        Tue, 19 Oct 2021 02:15:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=mFheHQJ6WdWVbOFR2iqet41nB7ohpEtAMAWJRLQBtLw=;
 b=qBIfDjs+zgBW+UgnGgn4JC5mUo90pbHL7uL2eFQWqaGfE+5ZGWq7Si7mx1u6UU5hCTPF
 5rNyKQ8fKyZqlD6toNIZAp+qv7+XGD4tnOR8+u/5leS3tHONQ23WsroJNjNRVod1aPPp
 HC+Xqbk9BdYgFCOI993Bu6Dxp7NxKGrHx1IttofcHaqANRnaeo8uakc7wTbCMhHPGBuU
 rGPO93T/HSB1VT1MVxfXtt1lCuiq9V4R6Ri2dtybqRZccQIpFE4ntCEqhokUzWwjn+O1
 XmHLAkfOKxUkCe7Qz37D0BCOpkWMyVFJn3Im2MBEwACg3y7EiGOXcBtxlmAj+sxPNsfd Sg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bsmtb088h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 02:15:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tll2JYk11RXpnwL31TIBLEuRqCLstS+1AsYfu/SzaJuvCGVJ/GrEkWEIS3iHbEeJnY4hBlIpBOzL99x5cnaNTsQ+GI5oCxtMqDu0DB5Z8rZugkMabLC3b/2JQIDeMsgqjMA4FT9aiE8UId4UZLFv5R7X8h2mR2+0P89NpHCRg4Fx3rjjLMWdn+NZGVfD3QNwvfJcTMdjB6U91YonOoz9KDVOXdmRhAI3WB3lgf+glbstONV6GnfMZIXy3kWaeHAtxj60cNFZzXwB0H7K32Nj9L3tNsXJaMkpv03mIeKsF6eWEDnA4G61zzpsFG4AeaYRl5NSdnQvQFOB7YwmDNNhKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFheHQJ6WdWVbOFR2iqet41nB7ohpEtAMAWJRLQBtLw=;
 b=VchNTyTme9LwRU7eiKLohraH87vfn7zSERzZ76L9hyyMScmFEgUSu56/XcDeO/W6TUyxJqRlMrlFb/U9mqnqIUXcwAnlz764O4oeaSg9DDb4TULaJfPvGsDkaiAqKEeuss0AH9RESXGzltwa/ypb9KzvfbzSh22cR3BDW1xIFDHkB0HG/EHNE1Jp6clno+X4EOp0p4tgeekd5UJYbYEcbo0JGP6BLCCQGTAsFFawqf+0PG5pbzQv4AYuTvNg/MABsjM5gvzpryDKPyXwl1fDMUAz0dzsZe9GAgro3w52ZwSOo7/Lxu/f1U6j/8ZKg083UonamGrftfkyDheJsh4Ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=none action=none
 header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 09:15:02 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14%8]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 09:15:01 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, ramesh.shanmugasundaram@bp.renesas.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meng.li@windriver.com
Subject: [PATCH] driver: net: can: disable clock when it is in enable status
Date:   Tue, 19 Oct 2021 17:14:16 +0800
Message-Id: <20211019091416.16923-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:202:2e::24) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR06CA0012.apcprd06.prod.outlook.com (2603:1096:202:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Tue, 19 Oct 2021 09:14:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c6ece2-ac8a-4f4b-7931-08d992e0ee23
X-MS-TrafficTypeDiagnostic: PH0PR11MB4901:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB49012384531E52049183CF7BF1BD9@PH0PR11MB4901.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33A2Spc4jZlukxYDAhLQcABkgLKg7GBBLgnBY96w8WdYiFpVjfUQ+JEHg4OfmP/xKvRb0HOiGofol47JY0A6Rguc3ClkLLIStL2oWER4ht98oTjF+sWoT+K3GrYOEXgpiY52rKopetMzUwWuBqckXWLFEhmIp6FC/fBcrAhnvKxlCV9aOSYff1xsw9Sy3qjAbxRjw5Nzrq7LT4lib/BkKOlcqI6gk+L/hWayDAMZWggD0Bi1gRyGQIEYKegkz0slx+i4DBn4mE780lxHfRzrJIpNWrKdLt1lpKNGu6JpCqANHFLYptGcM0brUI6rgW/CpTIpW7qwIpXAoMZHfx4FZNEsnwSu+DrVsMtfdnW9EXY98o9NHqx83J5vSW5KYFDSLutCAEvFQ7O6SO34FsBGdICM4wk1gtAJh3IaBR4Qdu8Piy5O0WmfvayFB/RAJFMRP52ptreGaGhkjlAe6KzaQ2BMmBiar9z7uffE6y9a14tju6qi9NTgrGsurSl7LeGwVwftIsKwK0KJc61EzbJu9rgMKeI99DzbSxBJa/lbV/I5xxMy6sT6WWcevRoTqnwFUCDOGMCC7KzodcVznDpIWk49u8ZKjpr35wQlY5org4zp6OA0d6OHigfH834syhvEgjUdv6vx688N4Kr3SQE5SIkcCMPOeMcGVsEHM6OTtTyPO6KuRfOHT7mzmn3VVVI5Q5S2dsEG9dUN/j6MTCzlKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(6666004)(8676002)(36756003)(508600001)(2906002)(52116002)(86362001)(66476007)(66556008)(83380400001)(1076003)(7416002)(5660300002)(6512007)(6486002)(8936002)(66946007)(38350700002)(38100700002)(316002)(2616005)(6506007)(956004)(107886003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TKWuEZxlB9gU0CWhdVVOGRaRZAHsqhDtM8pfmLphu/P2AMQCEf8yK7/ceGGq?=
 =?us-ascii?Q?iloWwctfOhlNoaiMwPaE0EN2aSOo0huHYwZVz3PnTv/kebCu7pZg9Jx+y5Vs?=
 =?us-ascii?Q?41fys0r7t0EpJSkptmai73Iy7FVtIOUoNDh7ynulRfyMzYDthzOFYiflkQuO?=
 =?us-ascii?Q?mXLaaZ+gYiQv5WX6MRFrK0W5ez2SSG4iY7ymZ0UjP92F3e18vBGCUzvpFcjh?=
 =?us-ascii?Q?NJtUZBCxSFiBzb2zxPfA8beD4QmWuIZ5lbJxGoydnkpmE3qlBoaCiaH8bTVM?=
 =?us-ascii?Q?GHrbT1j/wCk+T5MhmFPqN8UiQN2+W7KOQX/Za2hsi8+v9+2kJQ41xAbYBtMk?=
 =?us-ascii?Q?WoK2Qe+HuqkXX9gmxwVyhlONxAF1rTK/2xpIUlzArSgMuMy5fs7D236Ql7uW?=
 =?us-ascii?Q?OCEczNgmln/BWODaLcCksOdEUUcdTYdfV116I/Ams+XUauGoE7MzEvdIZasy?=
 =?us-ascii?Q?1U/Y7MVEbQWHtEwo6oNywbR26BMuPz5SLE9brk5l+odeZyPQtNB2kXjU66o3?=
 =?us-ascii?Q?MdrtWLAYfUdge4iSxa+XUknPStuiWMBLo0IjFH4R5Khh7epTLtfxMf7Ur6MH?=
 =?us-ascii?Q?/Ruf2Ylq85KvnaR7BVjMzVzBqq4pEHLfHHy/Ar+ogm5GXdQCxt9N8oDQOOWy?=
 =?us-ascii?Q?o77wNeGqlAmdQOCUiFunHUjSw31A42U8ZBvPUI2DGfagf4QBxEereshT7vxc?=
 =?us-ascii?Q?ixQxZmSNIlVhDzIzUyCj60fTr0Y+nlqzjRdj9K6BY2y5Fjmx4Yj9l4tInqMJ?=
 =?us-ascii?Q?9HOxM+/JakuCLQOOpLxPVUdi3xPqFTzTu2wnQw0qo6Ymom56C//rcvCGvrzz?=
 =?us-ascii?Q?UwD6cpZ2RTq1M2jDa6VyP67743RNKFUNLKVz7NH7rdgtxUo6cpkpLE7WWe8I?=
 =?us-ascii?Q?TsQdkg3nR0BSJjgYI6U81MTXYPHl6Vd2hf9DOpVctHZMTMlDxr/XOdDCOVsF?=
 =?us-ascii?Q?bHWDzVQnThhYFZYsDVsqnE3hM/xJ0yb6+QcgPyIhZm7yDyIGJspxMx3wVUhP?=
 =?us-ascii?Q?cBDrMwyW+Ly+D5a6N3Ld8h7sviqLvMedptQ/GlEY5OcouSFCAt/DcBDF/QkT?=
 =?us-ascii?Q?BVf+cNIG3wfGZciKH2NsxxQ2WWk+lp8PruAHac9qqriELRiza+iNFE26Bpll?=
 =?us-ascii?Q?cgVPanCXD9LR0P3yPgSNNo/z+hBffLH6zwTvPs3Me4Cgv6wZonD1O9jAbSIR?=
 =?us-ascii?Q?KPMUwueUzmQM2HxrAcgLmhvA9JPsGyV+mO2ittTbDe8s00KpMuafKRFnwmMs?=
 =?us-ascii?Q?R+PwYirEpxF/l+/k95TEoFez7fZMcKJ6ksrxN/U8DjfY4FxnGMB7GGPY0qgD?=
 =?us-ascii?Q?OuDzmtn8RFdAm2HC/6BXLYqr?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c6ece2-ac8a-4f4b-7931-08d992e0ee23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 09:15:01.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: her1UKag0IzzHyZIfP9nzXixZ5Jll2UibgO1xndOC3xLh8Qbb+jAtDa9MUWCnHki2wP1gG+o/pgrdmdoB6Fg4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-Proofpoint-ORIG-GUID: 9AiDFZcj2Zba1GiuMmqxmBtyRPn9Qi-2
X-Proofpoint-GUID: 9AiDFZcj2Zba1GiuMmqxmBtyRPn9Qi-2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=559
 impostorscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If disable a clock when it is already in disable status, there
will be a warning trace generated. So, it is need to confirm
whether what status the clock is in before disable it.

Fixes: a23b97e6255b ("can: rcar_can: Move Renesas CAN driver to rcar dir")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/can/rcar/rcar_can.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 48575900adb7..e340e32cd145 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -15,6 +15,7 @@
 #include <linux/can/led.h>
 #include <linux/can/dev.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/of.h>
 
 #define RCAR_CAN_DRV_NAME	"rcar_can"
@@ -857,7 +858,9 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
 	writew(ctlr, &priv->regs->ctlr);
 	priv->can.state = CAN_STATE_SLEEPING;
 
-	clk_disable(priv->clk);
+	if(__clk_is_enabled(priv->clk))
+		clk_disable(priv->clk);
+
 	return 0;
 }
 
-- 
2.17.1

