Return-Path: <netdev+bounces-2764-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCCB703E12
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 632DE1C20BFF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CF019532;
	Mon, 15 May 2023 20:02:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A78D2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:02:46 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2135.outbound.protection.outlook.com [40.107.220.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C2AE707
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb+j7Fwvo3wQaBqDyAp3l06o0KW/Y4OhU+IhuOPfzLaO+jFRfZdt9hj2LgUKNTwY2j7RDgZpCNpRjcW9rYRmK1YNWseTeH1sW1Yu3Nn+w6F4zvtdFw6g0KFX3GSEsJNsdDaSgVr3zULT8YShIMrFsz6I0wrt3k+y2M76CWyXupWaePDLc2uihkLHcpggh5wGlP+q4vi56XmHGloE/MvGx4iMfbdp9ctku9MpcNK6bst916oEYK5eQXpvzpWEqgDReXdtA4bfTVr+iG2iw0hkua+BLNr5PyYbnNS/TbRCbZNs4vNr7/jd2y8TMDaRrYdY2Ze0uHLh2eaNbyq07C7piA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+RVTnENMdoB2NyvgegEShWDUIkLGZ77x8USlyzfNQ4=;
 b=bGAF4na3+nnl5cmTS2DlqILFW7Z3/CAPegoDzl3txLGhCnzDxgoSdYyjzn7jaBAn6iV+ddbaW/9ErXF0m+D5Z4a0Mod4YEC1KubRXqj0RfeZGIxWCM1UFID5NA50uEp27ZsViqS/IkmyUToQfx9WQ+wK8eL9W8gpX3v+Uc/nOZNfqYZYBdcp1pVzhVdL9D+rHLRhlBrR6raCsIwTcpK1RvDPcF8hV5g5Ai8i2EPsRp8T4tap6S8+jhjIp80Av2nLu5z9/EVbjgFUU5BbCQJMG3YytQ/y49PsfDLTwqo7qIM655S1RHxOuz8JAnmSpLLtMJe6N6KLZc4Lq1hd0xJvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+RVTnENMdoB2NyvgegEShWDUIkLGZ77x8USlyzfNQ4=;
 b=jPfaDmBOzAPJp57Ce+1mF8dSezBn4nxaHN/ntJi++kNupn2I+XI0OgqazHyDyL04hkkJdOvSREHcIkF2KRXULIHm7R+GUaz9yy+BQ8iQA/mo766de1jLp4cXw3I1xIR0dlMqg94eM6Vi7g9of8Jb1E1dvkkE9ukxeFbwWr3kSsM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6479.namprd13.prod.outlook.com (2603:10b6:408:194::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.13; Mon, 15 May
 2023 20:02:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 20:02:38 +0000
Date: Mon, 15 May 2023 22:02:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 2/4] net: hns3: fix hns3 driver header file not
 self-contained issue
Message-ID: <ZGKP1PKCocTAplDN@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-3-lanhao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515134643.48314-3-lanhao@huawei.com>
X-ClientProxiedBy: AM9P250CA0021.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ce6784-db4c-4d02-de9c-08db557f5537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4FMyKCPRym8Y6aaLK9dz/+dwr91NR6D3dxBlT/Mou8WiLLDbhqjuQeBfardxnx5fHcmJAlbqWgdZs0nRqiE3zrlONtdtMvWj4MmsCbPwgzJgud1FPfmUjJQpWCi4ulKEU6otQagzi3T8RkDJT4OFBvYHZHrTU29c0x8zxHzI4KVBPXhBeL+op9cdi3KYE34U3qXRGAJaGNf8oxbxRYwkgbG8TPZIhaPj/k8dxO1092SNu7RzaJ+JHagqhOBuJ0oXkSOf4fkq5g7Z/4NVk8b8BiC2hsUEEBG1ai7neVV2Q4PLq4pVeIhqf9U3GXnAp9FGYCfAGDCRucbeMCsZQbV5wsIGedK7zeTj4t7EV4bkfBIRZBS2MDrdVg8rhINQHjjRIKswTdcVWD5akOcH2Sa2qELxG7x1i2mvmtdqnUIKeSE8NyYDLe+57gzeHNLKcECX8W66RrzKap5v+Sy9/B/nomBX/Lr/yP2tMHdHXj9N2v3A1fEmfT6mROzBqHJl42vcReyUVDkQWtMbY7oc/u1i65OSn9bKkXKydeTf6yeNxV8MCyz/6EaCKFjgeEg2PS1w
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39840400004)(136003)(396003)(366004)(451199021)(316002)(6916009)(2906002)(66946007)(8676002)(5660300002)(44832011)(7416002)(8936002)(4744005)(66556008)(66476007)(4326008)(41300700001)(6666004)(86362001)(2616005)(478600001)(6486002)(36756003)(6512007)(186003)(6506007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?85fo3QPeDSl/Em1eIn3tKfB5priLyDKGmoMlUZVTZpImnRgJkLSLN97a1DyU?=
 =?us-ascii?Q?IvH7+klxOCLGVCMHnbP9O0YKqawlNDA5vljQA7LVlLhtDr5wIxJ/YaTGCwDs?=
 =?us-ascii?Q?sLmuDLz5RVIf1e3rj9sdbLq97dfWDjfEZeidCSUdcQCCB9jYNv+S6oRagS8L?=
 =?us-ascii?Q?hceBSo27SEntsOa11JCjc8DDM5TB6GbEo4LiIK7eJHDZHTiUPrvzuXc5zLqc?=
 =?us-ascii?Q?5NucWLu9yXN+xWlfGB3PLokY7CWD60RmlWo3F4H0HCUrbW6dofoBjfYmZ+qG?=
 =?us-ascii?Q?39P7yH9bqNkMuNwHRh3w+4F5nTfuJNEzcYkwCsk8lWs/qIn1J3iuFCvEeK2z?=
 =?us-ascii?Q?YeFaaIqGig8/PPG9o2H1AoWJTgyCRSIdVGGVwIf76Lwc+dSL0Fxkq+bMlxdg?=
 =?us-ascii?Q?vXvxB5W+jWugCM32byOaQXDyBSTB0FSeKqvV6fXk+waJTJdQUjY/Hp29p30N?=
 =?us-ascii?Q?ogPTFbK0ZA2yp4LADjyMGyPDMD3EYjYRzmrdrNeuTL01rDbzcXJmjFplDiPd?=
 =?us-ascii?Q?uGJUdvrWzmtabyAiQTvBnpbON4Jl/XHYMSNgrmWbuEMPAS72467Y8VORX+8I?=
 =?us-ascii?Q?6b7RtdVyv2wlEC1A81lz5k69SOHZ+0XrVSXCQRSqp8tQ+I6//2TgwYQLfMtf?=
 =?us-ascii?Q?FODj5vCAJK0IB1jctM4sQHfzTG14jS4oxLRWRdV6tw57+bH/odZwAUhJjCDH?=
 =?us-ascii?Q?OCtr4KQsGs5A5xpav+/vevGOif02Aans6pmBXJCULsraY4Njcn7b2dOlYIZa?=
 =?us-ascii?Q?RHoQCv7Z7sKXFUlKj+c9oDtpifU7u2kGxzGjv7bbwIbR9ushdkt36ymYuYk3?=
 =?us-ascii?Q?jtJWq4W3wetoVgCrbGSwPLnlLYMnzqXfTR26Hl4Xv2v6RjlJVQE9tH7MJRxh?=
 =?us-ascii?Q?TaZNYW6FwnFbBWUzF94C4pEafkKB9u6R69e/yxfX9zZ+5S9eYu9WDlFSimHg?=
 =?us-ascii?Q?JHpikWmFRiZf/ylVq6d9muFPFcNOUE8YHHhwFZjnJ3zhJWgRXL6M/rGrFDN/?=
 =?us-ascii?Q?Uu4e3nn5gMQiaYHZD5HH6bmpbl9iGcrLWf8ywRxa7Jh85cgeSSN568+OQg7L?=
 =?us-ascii?Q?HOQMIwNWg6ZDj+6Dl8Hexd8QlUQrWSFj2ZA1q9m6vXjf849KrCQD7MFS3VhX?=
 =?us-ascii?Q?Pmi8y9Z2S2Gn29EqD684/0I1IqZpjvYkcmvSwwIMm/3O2mK+E3AqJzF36GTR?=
 =?us-ascii?Q?vcedZq6C8iWkHH97PDAoZbOpeQ/p9aKJ7S8DjciqDFVI7g59+4tZgNMmKLJr?=
 =?us-ascii?Q?G7TeFgijyDkEpjCvLtMiuy4VJLg8zqZoJfCdMxIxGFG0ktPRSsyFWmej7kjo?=
 =?us-ascii?Q?lgz6c1zoKVpelo08zJyCNHfaPn7jus9ZHAgHiEsM5pKHWthk1ghQ48RmIaC0?=
 =?us-ascii?Q?N21PTQq+VIbJ0tokaIiUVGsguQ/vgtEc3dWXcKz6cq29aeMCrQuLxSCmUSxE?=
 =?us-ascii?Q?m0Rqbekp8DxswCufiwTKAeZC6Cs8i0bZ9JfgN3yuL6/P0QIprLBUWUagw/tZ?=
 =?us-ascii?Q?xlh2ZHx6GZ7J9e058NTa90keFi5WPfNP4kAWL6LFICPzMNWnQRSvgqJr2vpl?=
 =?us-ascii?Q?ntFtmbqsbL5rbSTZPy1H3FO15CfxCHu5DHFB0a+tQ2xqXKf9ubKIBT1agZrH?=
 =?us-ascii?Q?PVxqzqSuh5sutbDZIWpYd8759lYt0oUUPj7ReVipYG8OJA6dhk9htzj1F3og?=
 =?us-ascii?Q?LdEMpg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ce6784-db4c-4d02-de9c-08db557f5537
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 20:02:38.3352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LAFdplbxfcKDu1/4zEjSRms0rX0bTW9jrZO/bE2eZcqHucqc1rXn6seBN/KbaACN9RigOwB0Mt5vZQ3J1nVXIwOMo4pStC0Ca7uRZt0pWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6479
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:46:41PM +0800, Hao Lan wrote:
> From: Hao Chen <chenhao418@huawei.com>
> 
> Hns3 driver header file uses the structure of other files, but does
> not include corresponding file, which causes a check warning that the
> header file is not self-contained by clang-tidy checker.
> 
> For example,
> Header file 'hclge_mbx.h' is not self contained.
> It should include following headers: (1) 'hclgevf_main.h'
> due to symbols 'struct hclgevf_dev'. The main source file is hns3_enet.c
> 
> Therefore, the required header file is included in the header file, and
> the structure declaration is added to the header file to avoid cyclic
> dependency of the header file.
> 
> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>

Hi,

out of curiosity I'm wondering if you could provide some
more information on how you generated the warnings that you are
addressing here.

