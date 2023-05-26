Return-Path: <netdev+bounces-5645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E70497124F5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AD362817B8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F880742CD;
	Fri, 26 May 2023 10:40:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E16D742C1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:55 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF3D1A6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:40:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2gH1wsVlCWGRoh9Gx20GZBEw193OKgPr0NS/p3yAL4mR2wdywzknI0VcalYsYHEz4iTqdMDVJXao14T3tZfhAFGyFyXOJ70YaiQ3RV1lu6oReV96DkoO/vMX+4atyTnThUl/SRfqBVuu+jJmxNjUEFQ2OuTEzE1a959u3xxXFSHqxcaDIWhFA6+SoNsuQAiwsip84s6oJECeZMnlldSmueDpewVtK9J39uvdLSLzQKjiKLbKUlS60PZpGfDhOaFzEE/XRFdbe8YJlzxI/xGl2zCJ3oi1Q2Gi//gLIs9cNnDDMovY8DyhlRL97eoygIkpVfaeAgqcFB7mP6SkmPerA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kU3zakTY2+yba9Wbc7t3kVPS/YsjsV1zO8T2TSxOVI=;
 b=Ywtv4Hk9szrt8+J/AlGJp1SpxDMtBAYNuDherDBtiVGhFMjwwGFQLIAbg33VF3UNthOLTdir/lUoRuQiWquWEhay2XgiduOt8MOuWFwdieNO7IJ9LgATPgdtn8J80tm/9wDYxw+OKG3pbLweJ1s2pCMvjONFxnQRXyQRsHoC4MotD8iDDeunj2SuzvnWQ44kwBbyk2EDQXtkmPx1AMB7RydeGbUunWKvWrzDWayYL4FpHeBWpqM/wZf2nYvQ6lzSsyM8Mr8OzjWIlNeyVtMrLmKr2q6PyT4Ys/XEw8dJ2wIXn91mSy5bn2hWMIm4PGZj0LG7h+qP+ZAij/SaGlqRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kU3zakTY2+yba9Wbc7t3kVPS/YsjsV1zO8T2TSxOVI=;
 b=jvMe+Q+tGtC/5MLwrn02dlSvgh1J3FaOwRuUYpOyzrOQ51tcFED7Lj58nE1yFghzdu5bAWmhKTuFSrbV39mlC2orkEUWavOG9wdaG5aq9lI1LF2++q/LWkdjv44tJF0cOMvVDdaAkcDNj8UfIHVA1h3rGBjyb2oJGU8Xry1mLPM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5465.namprd13.prod.outlook.com (2603:10b6:806:230::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 10:40:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 10:40:51 +0000
Date: Fri, 26 May 2023 12:40:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net 2/3] rtnetlink: move IFLA_GSO_ tb check to
 validate_linkmsg
Message-ID: <ZHCMrf89kk0XVopM@corigine.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
 <63779aa1c36d5bdcb6c004df23430372db351d46.1685051273.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63779aa1c36d5bdcb6c004df23430372db351d46.1685051273.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM9P193CA0029.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5465:EE_
X-MS-Office365-Filtering-Correlation-Id: 0356bb45-da35-4c67-2e91-08db5dd5acf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Iu2pULO5uK4ds++gpf5FMag/SKsfUPsgHya6HhcMs6VjrGSRG2273fmeev8xNcsyvwUS0ooSbjSDMnQFhksCCbNOd10r4E387Fb5fWpATS/XZLqdLUrazPx2cVwp2ihefIz4dZIQZ7EP9TmF/oj3YVGEqTKmvhMXChmH6VYpDS4XI3qJD5rAuwa3lDF2gTypNpBIVXlbQPbZgd7sokd/ap2FqobEvdW9CisvaFCrDoLrJrw6yNny3RGGme6R8R8aop+HTdTsDbQGBYURitzTwxXcDDdI6fHSiWH6TdA0bgphxSaDLLMxhxvQ8yoDPuM7mxMvq+ZQ/mbU10db5IinypAobg7TPwEYehXvkXuGSwKW4IvjyM5DrVd/x2+xIH3soKVsHcUysUGpDGrwEdWevrsQZQash15DRQO4RdHVGP5WRuoHvcVSAkTXfFMWdye/+GTaB0Xx4+sZsxAsEwOfgIkNEmOOnEiV7BN30N6locO5fZXnqYLU5kxRB/iXVenZTiJqQo6CWezwh8TtuYzfxTtp/KgPFe/A0FQWjW7S/k2uFnmqom15zBo/8QRUVmq/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(136003)(376002)(346002)(451199021)(66946007)(6916009)(66476007)(4326008)(66556008)(36756003)(8936002)(8676002)(5660300002)(44832011)(316002)(54906003)(478600001)(6486002)(41300700001)(6666004)(38100700002)(6512007)(4744005)(186003)(2906002)(6506007)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FtC1LpVXEynUxEpVMVGTiydX4nb5ykSGLoBCwY5cpqEYSWCWrTkLw/BKvdIg?=
 =?us-ascii?Q?84ssDJxyOzQpsD8VOFiOXqoIGEIi8G07TsuOjDXL69ZOpji8PvP+9AoaDw2d?=
 =?us-ascii?Q?jMH4sl0JnaJmKOPlxYRwU7G2gOcOBtRLfPbQoS7p76nEHBa0J1Of33kAvvs8?=
 =?us-ascii?Q?x/xvx+8RpTSERVG1JZ7Sfb4Zpi+mlwoNrL3q5u41dJudJgNSEkACbfhdUqdx?=
 =?us-ascii?Q?QIznqyZtGUs0dMXLN7eA96aPUDIYbHlh5vWeNvHi+r387CpiBL1jCzxqFfO7?=
 =?us-ascii?Q?VGaaj64c1pnv6Axc7pfNtCrxkdVRnb1U46CayC5JUwcUYkCxzXnIfHJ/pLbD?=
 =?us-ascii?Q?d2a9tGSbIPz4eT2U9GixSt4TpLvdaFrLqCasNtRMDQUgGyLZRwUCjezzV0OU?=
 =?us-ascii?Q?If3GzYo+alFB8oMCPHFI94jZcKOkFYm2vovy9qI5NCTJQS/UfvVW4382wRuU?=
 =?us-ascii?Q?q8CDbfGiZU5ZyAkxWJe90GDqYamxb7qvSUoe0coerI6y44ATVBag6/a5jtpl?=
 =?us-ascii?Q?iF7WqmUn73PGBQhw6KygdL2P+w145rWsaquYoaEcr0R0DRccXrZEFL7KBHWO?=
 =?us-ascii?Q?OxQcRwm3uotR7+V3TWfvn7vCN0B9CytrpQuDILGRHhSW66lEE56Fe6Ep5Kgz?=
 =?us-ascii?Q?jq/n9QMKnscjhRJSQVnh34kGepEXRaJ99J1bHbi0MJ+IUtPSPk75I3S1xc3h?=
 =?us-ascii?Q?fErTIvpuQzkQ3Ai6Opz+VPs5ODPNlU2KxHOGlwzRSBGMEPuHRLcJoI2Z1ShN?=
 =?us-ascii?Q?aQLoZyVl5Boi95nCsLPJFbbQxnlG39Hi8xK//GkRYdpCe3PQ4YTblSBmUBRb?=
 =?us-ascii?Q?T/rM0I10xogxktqSu2ogYdybveCRRIbVRPKqGerQjouVtqN1gEDMxuCsDddu?=
 =?us-ascii?Q?1oq3LSrFYQR8ZHQbTBtVnI5qqsMBmXt7yeMLPh1W9+BwRIAz1jrAfqCH63H0?=
 =?us-ascii?Q?yApls52+WBDKWQN3mUrwqglxnKD5ExoNep4HCN5mkz5YwPh73LuCySWD3e+F?=
 =?us-ascii?Q?Jp12JTg2uFoaDtYbSTzZ2fcA8BUJrh8mtb8I5exf/e5862J2HYDUATJRaL4r?=
 =?us-ascii?Q?EC+nZcKAqYiPPWlmUJ4DF7vZ8BFl+NDQNEdMEgDbr7ZaeH0DgycxDI+TJaZv?=
 =?us-ascii?Q?Dq7hSEk8XdIXEiIogJf8fVFJZ4P5o+xXevnA8/+mkmAL0H3TOyXqYjZjDsef?=
 =?us-ascii?Q?VAKEWOJV35/s5diCe5jzaen5TOinYKrPQRru/CwI5gQq6kyWjTl/6v11k3AT?=
 =?us-ascii?Q?Yubj4RXEzjv7CXu4RwcgW6RTtoWM/htumlKmETEWIMbAZj4rVylt5WcjfIfb?=
 =?us-ascii?Q?rhQOtYaubdEnhbsesoYm0wXcix8If3idIRoG2DpP/BgmYB4CboznGr+hILs0?=
 =?us-ascii?Q?J673YsiZFPmLj0XkcaCGGj5tlVqB3nMVSWNlrqvYJUtpBz/xaVJUEtuWia7R?=
 =?us-ascii?Q?BkEJE1vL/yw0+yUxIEYySbU3801OwBJJnRxiOxpjQmAM5CpKWXrHN8/FMCto?=
 =?us-ascii?Q?d8N+uPAip+dTXcLUaH534M3lfXzrun6gKKT2rLDzu0VZHcictArco2gtpQf3?=
 =?us-ascii?Q?QLqvq9KCArFcWMScdvnHDEm0MP66MKseutB4lOBM5uSL3L6GqKGSA4+jO8D8?=
 =?us-ascii?Q?ybbDnQDCMX3TOG14HyUXFB8Va64K00DXme7W4YZqmXkgamenLVZqcmvLDepv?=
 =?us-ascii?Q?PgeL9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0356bb45-da35-4c67-2e91-08db5dd5acf7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 10:40:51.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b40jEtTxE/aZQrpZYvtnTlxoE4NepBGNXbuNuKlbtv3Q4x0ZG5/WZjs79Rc31NkGBfxY7maTPijSP2CcnpONF6dA1Xt3Xu2h71gfLzSfXh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5465
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 05:49:16PM -0400, Xin Long wrote:
> These IFLA_GSO_* tb check should also be done for the new created link,
> otherwise, they can be set to a huge value when creating links:
> 
>   # ip link add dummy1 gso_max_size 4294967295 type dummy
>   # ip -d link show dummy1
>     dummy addrgenmode eui64 ... gso_max_size 4294967295
> 
> Fixes: 46e6b992c250 ("rtnetlink: allow GSO maximums to be set on device creation")
> Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


