Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC83A46774F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbhLCM2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:36 -0500
Received: from mail-co1nam11on2092.outbound.protection.outlook.com ([40.107.220.92]:63725
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244247AbhLCM2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znjb+21G0QS6FkEAnwlnrcp6LO5TYbTkxLd2K/dJdyvYHdXruE3K0tWIpNYRuXZSbH50geYQ7mDP/3fkcG4hNrE31/tTieuV4M5prluo8eQlXrCceH2PR1dSYJbKJw/KIoWfIxZaedgpAqmzq8x0uJlDSxDkPDcUZOLx3ViaPzpHI7kcjay8iCXYE24xMh186WMTvZAZrFsuJug9cLwii/8ELOCvHYkkxqoOKWzFVNND5aBr/YYGHCd/P2JOb9EK9O4f+JhickccZpGqUmGXI7iQEMnGGbfmJLdja2Ztg1n3q21h145/W2/P08wYtP+kKDwHqr7UHw9XqhdsqYndFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qGuUV7Fn2LtfbftPKlaN1D3mNogN4NqNv0+Wsw7CRI=;
 b=BaROHjc4ty07K0sOGY6AXYhs7Yj+PDTs5zsidxkYMjupqwTIvZJEFv2fp291/Ta1/MmgaW1MsS0W0Xqs7NOk7/EDYPsBm3WWPnc5ii1kniOSwn+rrcnz5vbYhA2YgIgEcxo6cAKp9E/dWB5hKTceHd9SW6BluKKOy/X/awlVRSqUNB3fKueSNgqBJuD8AVAgWOjULzZaWrlKH87236w55qQMDCLFD3HCk1Bv/N7cfwG3bIWBNFitAT+jCpBIRCD2abm+ydLNJmhhNBpAdRTEH3AvaNksivYq3O8aKptaYFXgBWw4XOhvVv7qHJL79cFVsuWJhChitPpaNVxjDNYJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qGuUV7Fn2LtfbftPKlaN1D3mNogN4NqNv0+Wsw7CRI=;
 b=Wp3K/AsagAhd1Q+Czw0vPNX+6zmMM6el/J+TvFxNphkRS/50YWnzfqg/vKcsEnTeJjJbTJl6z0GpVl3AeZXqGgt4X5ijdNDvWvIOghsRmWD6s1Um5x/yPN/IqW8u3gMsPlXqv4KYE5NOK4GVE2Jw1NbophLZJ4Q7rTjOIFIjxiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5283.namprd13.prod.outlook.com (2603:10b6:510:f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 12:25:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 04/12] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
Date:   Fri,  3 Dec 2021 13:24:36 +0100
Message-Id: <20211203122444.11756-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59614945-9656-49d2-6977-08d9b657f28d
X-MS-TrafficTypeDiagnostic: PH0PR13MB5283:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5283F9745D7613E2406C8F6CE86A9@PH0PR13MB5283.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHg+eaHG5FaK9w6vdHOg+xpSAiQXSAIvvRC0NVogeZDolHbyx0AnEE0Gp3ypYhQfGWUTlMAKJcjsQ1JefaclW0ToIXDZOXYYnIsb+h1keOcIGRqQ0LVKVWfT2pBfqdGXdN2mexQ0ENfvgBOFend+PCRyJYMkpMWal2ft9v+d5GFUkI4E8Kh6ZaM62TeenixuR/rMb3f9p5qzvGX0Yl0SAtHVePrpwXndMTTPC2ScnZPgIMAykbsw8COGEIEibde2vN1t7v8ZRkQ8M4Xv+HM+ygwC0A0hleLkc574V9dL3uMj7o5GpMjvoHYmQiGbup+r1qHzvCEv0ju/AD4VbPLptNZnmIzcbTJMmlz3vvRwSKwOLhhjF/7p+3O8gfMrfsBNvB8mpQgrWqxG+VUOaGsxbz+Y3UdpJkDTmHk+oGXEKdSg0G7anuoEBZyCCaR9MZKhyu4fDL3uL1BlNA7PuNqpOYDkcXMo6cwEqr2dSvA3RzuTvXUFpjmkTqQN1RC2sFRfGyfoqwVsz9g0YbF+L0YYYH5kiLKfKnCbiixdY2cfWzLs7Xq0hu2I/z2fCcSo5Ug1vIkfuqx/jJY1hR9M4xFCFcNlAfq9nQIi11wSpR98TWcYtpSbN03UShC+xlwjqnnnP3WW17XrVJt0yJTyBiIoIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(346002)(376002)(136003)(396003)(86362001)(52116002)(36756003)(44832011)(4744005)(508600001)(186003)(83380400001)(6666004)(6486002)(66946007)(6916009)(5660300002)(316002)(2616005)(66476007)(8676002)(6506007)(8936002)(107886003)(2906002)(6512007)(54906003)(38100700002)(1076003)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AurayV1lW0cknAl3zeM+Jy6eKSVFX0mZW2En3gXaFEojE4E87PtZXpXy0FgL?=
 =?us-ascii?Q?fqs+z877d8eMxMKHca+OARgaUiTeLxSSGHWhE5og5S9VFI5pr1tdJiwOEahY?=
 =?us-ascii?Q?BHF33lNNimGwlmQrIEk6XXeCkNXsiX+KiNQEM+783OksqVGv0mE/zOiCbsai?=
 =?us-ascii?Q?ImARTUdg7E6Xo1KFKbSmGO0PdrKcYLNsCPcHzFDlpHuDYsPgNe1ANDZVgyMu?=
 =?us-ascii?Q?ldrOgdhlsqpdGZA2FsrUvpabAHkHot92G+OB2RJzjtE49k4iNTg/IAAUyGtf?=
 =?us-ascii?Q?eLxxqk89Wa8oPWl1yaY73C9r75Q+u3WXGo2Kiy1B8wTMzopI1eJnKm/81i78?=
 =?us-ascii?Q?VYkR1NK6eakLEkd8IjdStUwD2tBjIXtPFqxft2dPcIYXt54kL826kvkiSqNg?=
 =?us-ascii?Q?IxE30arTEvSaxzOly6I0KARX2jiBq8/aDHc6aX45qsqX5SxVBiWk85shp6s1?=
 =?us-ascii?Q?rBJ0CiqNubKuCfCq+gb3e1Sry7e6PTFTGBP9H1T0fTp5I8pRQtOBlnJLM9qz?=
 =?us-ascii?Q?ilg+pRIOLr2Vd3yOxxkt34mp7oep0j4orwG6V2rxxxusp3YdC1zEcD2rPnIX?=
 =?us-ascii?Q?saWcDaCqlQHm9oxcIcwJ/sVSiGiR/RKQk0jiVY+YbjieRe2wPG34llucKBtk?=
 =?us-ascii?Q?60Ay3Nf3dkPbks1ZnKnqWn0CTjJ4/687r89IpsKRKcYUwgI1MbYmCvHYkjyd?=
 =?us-ascii?Q?50kJfIO568vEwVaJlBlsYbnIpaEvhffjNSoSTxs+uU5+dfG/ZkyQ4SvCuAGj?=
 =?us-ascii?Q?UUo43Z9qGbERlrCVnjdkY9BLMXGkMXiuazfNmBZZXtGB83a5i6OFHKmlt6MV?=
 =?us-ascii?Q?NintqtHWqvufzy9uHdvh7ZW/a8yZALMnDvGHE/u1kiyMcbMxBRuzVdiwvksE?=
 =?us-ascii?Q?xTRxMNR1Dbcd/oxizfJVO8UdIFrWTMqJvBRTND52gWjnhFp0bOFWcWwPKE49?=
 =?us-ascii?Q?T8epZlgRPCmKFucJc4Xbvr+X6pemP6nGqbc1vmccgw3WW4oDklj5Ml5G/KU/?=
 =?us-ascii?Q?02XUgmyPrqjAvY18MDetT57i6vzNKNr7i2zyQA+w6z8PX2SlZGvybkxVSnId?=
 =?us-ascii?Q?m4XRgOaw8l/MXOW2NL5hVbXll1h9o2eu4x23h8y1Bz1vD0ZTpvbWzc07pGsl?=
 =?us-ascii?Q?AgHGVyNY7qvMPHImD9Fwrw6Yq7X/w6o35tx8w4XQHyd6QMKzRCJomu1fEV/+?=
 =?us-ascii?Q?TIwO50oCt26L123sDtozRPOMWAsWMFkscqGNa03HjuJho+2MFdVagrCyxiaM?=
 =?us-ascii?Q?REtGd8x4sRp5myqu93Y7tD8BBC8EgAmOOLpQ4mY39QG4WuEJuY9LDtw8ooGH?=
 =?us-ascii?Q?lFtb9GWGqeYpiOSc/ejV6jo0wRNXeH4vA8BHGGF2we82OyW5U+WzYV7CCZk/?=
 =?us-ascii?Q?E2TAmgh47L13W5SXgyCcEk2NrgPBP73iKSE1lutbxx57EuDU5UUEqykw2ANc?=
 =?us-ascii?Q?X6OJyaus/8inepn+pa8Z6Mw7V5a5jcdfQeU7uLLmZNlmTAGmsT2ogMWtR5h7?=
 =?us-ascii?Q?9puwKuV6v6QNIL6XQFtRG1lhm7uTB+Kb7koi3BKp59irOzzUHOsvA1FNGPcw?=
 =?us-ascii?Q?+sPucx1zQjfyiqSnKWEQHf4BvHr7TWYWs12Gq4pwe3Cdj0ftlO9p6ly+7P8Z?=
 =?us-ascii?Q?zTUFf55IcuFXjOKfZ/bIQ8+9xHuXxpHOyV/YLv86dLWu8GvcPUmrj2mlhe/q?=
 =?us-ascii?Q?4H2ni1Jipv7wxU6XqwY3nIsANDlsZXtvydpJH5RelbeqMRieOvnhplCd7f1T?=
 =?us-ascii?Q?g0RCkGphZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59614945-9656-49d2-6977-08d9b657f28d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:10.0127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZtucRQa5I7DSCPiVnuvzgvPsyIqpIbuflQ0ijjUq9b6x0AaHlked3LM3f4LzKN/S9DP1qsAKsf3eTiReMnGbpoWOXMwT050C6KyAhAIaBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We need to return EOPNOTSUPP for the unsupported mpls action type when
setup the flow action.

In the original implement, we will return 0 for the unsupported mpls
action type, actually we do not setup it and the following actions
to the flow action entry.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d9d6ff0bf361..7a680cae0bae 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3687,6 +3687,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
-- 
2.20.1

