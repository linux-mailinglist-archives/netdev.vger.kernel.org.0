Return-Path: <netdev+bounces-3712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0A1708662
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 329FF1C2118F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAF724E93;
	Thu, 18 May 2023 17:06:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9823C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:06:57 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2139.outbound.protection.outlook.com [40.107.244.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADC19F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dia0T7YzncViwfrVWAjILfZmp/dpwRWrUedGHpi62VOmOx/Xg3ln3Fzj89jXkoZNw7cMCoLx7toTJT7iaT4yCLii57CYFXUKTYvTf4ZBWESjfziInJ02aR+roeN1+Qke9vREnL3d3LbxRobuzr75frc07cwPc8ERuVb+Kd9qQky1w3OmCfpKX/+gN8oZ/tAKjTJuCPqUu+kwaHzij+tNEll9RY+QREA3ICJDGh/cEZXQ3xh+nuwE7m5iWq7Gm0RsnO3GjR5NdIUYF8jr/Gvm0ISZPOqfjQZgkioQZYxW0qmfey/+qxC9PQqHlajudvkTLnCmTR1kIuVIl/PwysLRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YhvwZiq71bpdUMtAZ6p2jxIjX620JDfN37A++HygGw=;
 b=kc+4s3bgHQwLiR/mMw6T8rK72cOImLOhp8CSAnkU6/Omb5RYKsls7Rs32wJ+EDOGQ8xZKA4pcvY2weQbN4iBHa5odtQbWcnJeYnHePZOpjjFcgdQYmlMPSAOT5CKDHuMtB7vYyX6V+xMFMsrFLMY/mtGkvDdAC3zox5z49kH1Hwp6GOoGFnzptW0WThEgpnWtfIuQaNJIwgd4T0no+y4X3WN4kmczkGkqqwsbHzI0xj+pgmd5CRMPDzT8XwSZz/rvDVbyI97R77fpMoehqwuP9ksMNXfoy88sGecj0+5tVLytEkvuIIJDBtY8dD6CMZUCYgRjIpNd9yVJt1q0jeA8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YhvwZiq71bpdUMtAZ6p2jxIjX620JDfN37A++HygGw=;
 b=uAFXZvE8jlfeFtIOcFztsauCt6/n7BdCMl1Eyf61Nra0hvFZaQQayszxnvU5YuFuNat0xFF013M8ST/O5GoEqnQc9h1gaNTzPfWDetlXkJK91pF0jrW00vLpM34L6CXbwjyYVtymtipmqevKx6Vq9BsYU2paruPHkHIIewByje0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5721.namprd13.prod.outlook.com (2603:10b6:a03:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Thu, 18 May
 2023 17:06:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:06:53 +0000
Date: Thu, 18 May 2023 19:06:47 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH net 3/3] ipv6: exthdrs: avoid potential NULL deref in
 ipv6_rpl_srh_rcv()
Message-ID: <ZGZbJz1z9ewog45h@corigine.com>
References: <20230517213118.3389898-1-edumazet@google.com>
 <20230517213118.3389898-4-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517213118.3389898-4-edumazet@google.com>
X-ClientProxiedBy: AM3PR05CA0106.eurprd05.prod.outlook.com
 (2603:10a6:207:1::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a99011d-0861-4d73-ebda-08db57c24742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JKxY+o2cDkIIOGuP8m6lwU0niPfkIRpN4SETjbxgU1TA9TDFbaru/y4n4Qihr61TSwW39KonR+5Ut/w6TuJd9+DW3PgfBur9JPB09xzHq7suwUdv7mN9v73d7Tw+zY3XMCeq/56EpyGNE0P/FEae8Bpf7wzwik/dm8pBxZJvKQEz3H8J9fWPrN/KY0RYApz+x13/JJZaYZMiIbO9Jcy6AyR23PDyH8ANfa3YYtDUr3GlmMVlOmuqdk47wtqU09xE/0xLLTf5I7fj8enjlu2nwbe0cXvY+Ko0qV7JASgf9cxh3+1Ntc32EN+rQB4hhfC0lV49vO5fM60wcTRCCaow+/6ZmEr3QlWe7ahyqNTsFQkeE0Ys6oFRS1ADv69ZRhBtBlzC3JYeclKO/k4e+Y9FH4WhSit+Hci98S1uQ07ZBNnJIjSKDJWPsHrEOWrhi0seaYI5f7ZctAq9SMfbQZX9U6SzN1ldmN2mVrVGxho5QtxxmGeEoAGlbGZAC2LCIh0PBWqVtXUYULv51ZBJdIShYBFUl7zaUEPIYW1WP6rPtH7kRwc4EqNgyWQQYcKEBSZdO3LtQeVLfze0O5l73GPNwugQQlaaHKABIFJixCtX4Rk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(66899021)(86362001)(66946007)(478600001)(4326008)(6486002)(66476007)(66556008)(54906003)(316002)(36756003)(4744005)(186003)(6506007)(6916009)(8676002)(2906002)(2616005)(44832011)(6666004)(5660300002)(6512007)(41300700001)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pMUtblD1G2PpTsve6gp1vUuCcdU0BuTJ0RTkCpXFlctWTu8/ze18LN7JsSYX?=
 =?us-ascii?Q?jZYMpMgDNnItawZ4IRn46HMyU8JoD8yloGpiSagE731FCuKG0hGXpOJ64TdV?=
 =?us-ascii?Q?j5uFeGecJvQphHj+jJHUZS8rAVfId5/ZcnCD51nOlbrQZadE+hlntrhqVsIT?=
 =?us-ascii?Q?jwH2iQrvNEatBuUhvZ74OL4WDnEg37XVXOWCumjf5Kfa8R8M2c3BdoeZWYi0?=
 =?us-ascii?Q?JKnB++VUuOAFOYSRV/dx2YModl9wT8bwYF9Df27VqfalBeza6eeDY9d+qQ15?=
 =?us-ascii?Q?JFl2InbZpabt577LYJMMYsKVi94UK8RkrQii6wBXKAbMIJgx8opLEKHFuHCp?=
 =?us-ascii?Q?QbUPFWKOzcPLCyu1eGxz2lhE5qfNvTt9gO/AWCLa8pgKvMj/ypZa2XxbXubh?=
 =?us-ascii?Q?mX+kACy3/DBCBHQZ7DjNx67RrpOcwY2TsjyqdyWE6CfXrHwqGKhQWuFMJ6Zu?=
 =?us-ascii?Q?zVCqdQmLQleK/XlGhkGArog2k91HQz3piOrgomt+5ZxZyAHhO1jvDwCF6bJQ?=
 =?us-ascii?Q?lH+M/pICw/GG8dLCXBL9qCc4xaSLPGckci4ysXe9X6WtM4U3gfYL00n+qk57?=
 =?us-ascii?Q?lICIz0iGItlb1aoMCAbnUydCjlDjzriMXNN8ZJ1afzLsbury55csjAP97joC?=
 =?us-ascii?Q?0JRy+kEsLQUQyMxmE9+ZdMO5Zm2q5jLtjyINWBI0/2TjCXb7hu8U2yLL5KrW?=
 =?us-ascii?Q?e1liY0b8XGZKXGpAo6dk7e2YaiIWGQ96OABDVBpK2sVg2D86J30vn/MrlOd2?=
 =?us-ascii?Q?6G5KogpmMIyGHnuDBHvJu2XqHYPjYRBiGBPKE5a+9SiM+SNnmSpf6NXYoU67?=
 =?us-ascii?Q?dotpcs7EMDGoROPhjUymZ1BkCZvVKkpe98NRrgnQzIuQqSyM1IYiWBbCTb+I?=
 =?us-ascii?Q?Tpzo5J8bs6tm07L3tNoBZpHF5C6Ks1zARz6fyTJxvzjmyyYG67VkL/G4u6gk?=
 =?us-ascii?Q?/R6AhH0IWsqjJP3ehnbN4EmhZ8ab9G01pjGXafDYqf1+1r8UzinwZBSV1CgR?=
 =?us-ascii?Q?xPHRl5bgItCWfkIIyRqh67crAaFCJhSYoNPLHP+qhv7qqumVzwmxe0AsKsRc?=
 =?us-ascii?Q?tvjLUuPFLu4Tpft83aHKXZyYpb4yhQw0UzT32lR33iU+lLG6M8FmoRRu8UCe?=
 =?us-ascii?Q?CWkYvOvSaxwKLeRHraWv4aWjNfr83T3cYs6pBifkkezScBU+5TkwpL/ajSvZ?=
 =?us-ascii?Q?U3XEENMoatrq4bEFdk7HeI34v7jQjVIwTiQsVt4IKDjZ+yJCC3/zotl58otd?=
 =?us-ascii?Q?+1X9rqmv1Kw+89kGg0WCKLz2eRUBxuz9BaQV6sDgs3KL6ESWC1Nt3eUcDusX?=
 =?us-ascii?Q?Ry9DzkNNKdjujccyEjFM6ZeOP1rM+z0SpoeRq+Bh4WopNgqEKLaqEu59sc0R?=
 =?us-ascii?Q?B+QuvD5GthWhJZ9onhEngrrokNXdZYCmKxRIIaUg1CX+Tti+Z/ZJl6NOuCv7?=
 =?us-ascii?Q?vl+UrZnAxUPVT9TcdPP+p9I7wO/iin2+zk2njJCDz4ILqUhfObHpIERR1ffD?=
 =?us-ascii?Q?LSArxBevdY1tUkXWJacixw8+Z5siGYJlVDEcTDN2p5+gaHdg2X9gWKaKnSaI?=
 =?us-ascii?Q?BTPjPR3Gr3zWyG+Mwa6FV/oarbxvdj6FrVF6JQsTdBfhqjbYOp8knu1KKuW7?=
 =?us-ascii?Q?zge1IVURoY4qg+2n3AFs9YWFTPwARdgDAgdwUB8rSdSkgB34pxL3hifE/vO2?=
 =?us-ascii?Q?D7FaBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a99011d-0861-4d73-ebda-08db57c24742
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:06:53.4970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLX2ZsnfyqWNPxu9mfzOvrztXhQ6B2Wj/XNODtEEOrktLkPWUNSmmcVnHB3YrdBa4ZFZDM//E2gK23kZbwh1xOpf4Wm8P+C0qCMhNBsxMm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:31:18PM +0000, Eric Dumazet wrote:
> There is some chance __in6_dev_get() returns NULL, we should
> not crash if that happens.
> 
> ipv6_rpl_srh_rcv() caller (ipv6_rthdr_rcv()) correctly deals with
> a NULL idev, we can use the same idea.
> 
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Lebrun <david.lebrun@uclouvain.be>
> Cc: Alexander Aring <alex.aring@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


