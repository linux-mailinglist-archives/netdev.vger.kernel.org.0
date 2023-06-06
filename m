Return-Path: <netdev+bounces-8350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BAA723C83
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AB50280FB3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2E5290E2;
	Tue,  6 Jun 2023 09:06:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21F125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:06:30 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA98E8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7GhtnkBG1kpomY4BqVpfkmZtzAlnZeh73qTSOBd6P1imSoXHE/h4d9s0LX8MYWn4qgf3GTUQcbML7MJZV5cjRB92HuvbTEuFt/L+yeMo9jgTQbQ5aqMPsWfAZ4JF87ZgdMYrdhz54J3cCaH+Lp/wkFLYkygPRAdTILNR2wcPF9tQ+wEnAUWkJd0yAnYSFWyWDVc+5jTESeDy0cLaR2Fu+DhPEhYq4geRmjLU26Z3Y5qOUNvlLLF2zujbqV2EewvReYMY7XKEQlDKCpU8F0gklUVGknIyOe8PXsXo2JiyFgeNp4uSUpDwpxrgB7SPbCo/m7FzK+rPjYRx/SBFcP3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/I6VqDFUrVcWUpHhlmrzDYAIOcMWa32iPyga0AAbFdM=;
 b=A6dX3nnsJJldvgr5pGwRw1n9hzDYnlnwpAwXf/M0gLa3oC16aICFjYJb3BFfg0azzSKTZTYUZ+gQ4gdOZWol+5jfHDvMPhYK+2Ah72ETkXxbWhfcm5wx6i4jIMgNm+a1qbDr4w0jQcO5wT3jYMHjtTnttgkLY2UZt7ZExDLydM4Ef0lfIZUyeQPMeGxQp/G6XD8aQtTH7oddEfLZYmDaoIy7tGv4BqHtbVx5go0t/hZlbcERqSXXDIQ+iefLiOM0EqyDCBpuA6wOjpuhDQuCpgGC8VHrowr+JEAFzwlb8X7eZZ7HS3VrHQsyaOO/U2BuIDSkvjymJdgSby0WgJagJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/I6VqDFUrVcWUpHhlmrzDYAIOcMWa32iPyga0AAbFdM=;
 b=bPj4+So3dM7QZJYRkF/bYO7nEZy43OQlQp8Z6YnIiihiyK3rUUVmH8px6fXZIgUGDsoGahdWAPaQtnAKQL0M+0a7VVEHC3j+Ahc0QYKpXcSz8YQNxiDmdoUDRO2fA+2N1VqYQppdPXnERvWo7M3mjS7uogrVdr4sE38ZXSWx8dk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5802.namprd13.prod.outlook.com (2603:10b6:a03:3e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Tue, 6 Jun
 2023 09:06:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:06:24 +0000
Date: Tue, 6 Jun 2023 11:06:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH ipsec-rc] xfrm: add missed call to delete offloaded
 policies
Message-ID: <ZH73CjnLlHj8l3iE@corigine.com>
References: <45c05c0028fd9bbd42893966caee2a314af91bab.1685950471.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c05c0028fd9bbd42893966caee2a314af91bab.1685950471.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ea591d-47b7-4cb6-d57f-08db666d4de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uSZl5H9MBdTjmjjgpYvO4qyBM3UobW9U2SmRkJ7B3pCi8PPesE2cJU7nXoUy/WgAbJTGSNfxo2EeM6XYx8Vt1Kq92CS0eom7DYbuh360M+P949rl4ldRetkG2RRx0KY+ErgU7GdVbnWPGtyCC+GuqwSAySffHlbYC31eg8FfuW+vkoPpFplaF+qPcczgryS91sJsTkIRVXppu4h5tUr1LiJv4ax/aZeQx6o+FLVpFT9j0qSVmODSiRIMFoC12+9FyXXinS4r0qKFcmemEWPTm2gabWy+Y6PCiZSwXj7rPFWZzgaAbWOMePGHW8I05O89hQsSFtiyznFaNOLOSSP5bU6FJGBWF1CiTbOapbNhfYQ9hR2kKE5NQDA0uaYUsI7oVgD+0oP6+rGlRMSM+dOsUK5N/6d8XV+Rd9lmi63u7GQuMj9GVrbsKLARUlbK1YYKFJ7NgwrD5tkQY4xRzbOMRQ+A/EVrWlpOdmFHxP7yA0m6dMgPqqQRBMpGpAColn0vYINM50GjgOt3qyaJUFEchP3Fe7LE68aheqHmEaKb4BEJuPaf04jCYk1h6FL9SK0t
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(451199021)(6486002)(6666004)(6506007)(186003)(6512007)(83380400001)(2616005)(36756003)(86362001)(38100700002)(54906003)(7416002)(44832011)(5660300002)(316002)(41300700001)(6916009)(8936002)(8676002)(66476007)(66946007)(66556008)(4326008)(478600001)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ETs0lZld86rwH/KkqMwb2+6qxnXUYUJGXHx7r8u7/PxRv8Bk2ZC/5JhPXKjF?=
 =?us-ascii?Q?9z45PAU3yRdT09dMGqZ0IQAK6ibGlmojTo1qNWCsJrgwqZVA+ENxiFMDP7HM?=
 =?us-ascii?Q?ZSQtJwsjwNCkUdv6J0ACWxIHOeEtrionCEkn2NTecHYiDPmgh+jm5gOptadl?=
 =?us-ascii?Q?t/sajPU1q0LYc63o2qbUQExNpLpyskiLdr02uQLhz+KLucDoJqzuWDYLeIEP?=
 =?us-ascii?Q?n/gOJP71HST2Dh0i2snKfdeipiiOJ/BG/2ixhwG2EHKg2j/2Sn1aW+RBzbo7?=
 =?us-ascii?Q?UlVaUfopEee0kqvdSAMpVMwfXr6LvPrXG4DZIiKKMYKPgMuL5akqtbvKzFWK?=
 =?us-ascii?Q?wCUvk0vknojzboPR1WJle6mjB6OK7DeWiHpxuaQMriDVoNmYFBl038ALJlkl?=
 =?us-ascii?Q?d/U5+ZwIfIxFkn8q079NwfnYjqGkIpZQ8AqPDp+hpQV5vqsD4QDbYtSWG0Vw?=
 =?us-ascii?Q?rgu5mr3hjajXAWSI7JCBIc5DTp8jIfnBkfwI5mXC1/y7JHstwLOwGDMQX5d8?=
 =?us-ascii?Q?0qIakzPzmPut80Ern01Kf2iJSLGtG26TWc0prKIrgsfYceCxibYcGvbPMykI?=
 =?us-ascii?Q?ziEF2NNLh+BgsKPT20uOgIL6C2y3CCyV2opjxSIQevYBhGHeSa8aEFqUD0rm?=
 =?us-ascii?Q?4rQYnKb4xCAH42PoI1f5yawdG1b0BmnHMZWLeasqx/fM3g8Pb2IQOrHatEPo?=
 =?us-ascii?Q?AEfyTN08ggJ5ptD3VsypiVRfkMNeAAuL9oxa3aVD4sUfapQ8RQn3U7Cp7ny2?=
 =?us-ascii?Q?DlcNBqEv4ayCXMvnWpbp34AG0xXwYRDSCZlwEwtj7vWlqmE+m0L3acEm4GpY?=
 =?us-ascii?Q?lbGa8UC/9a1Y4V96+9KuedJYL0GjQJwjIBzdrasOuPy99qY6fBsZ1dWyvahb?=
 =?us-ascii?Q?+S3jVARJb0W/paOppjWL/D8NpImmQeGryCo1VTtYxIM09ykQ4jsvxaMnch2W?=
 =?us-ascii?Q?Beimk/LISL2Afe6UAFpaD99SiAbNJCjByEpul/9R1y7M5XsmOhZqmYLlUkgF?=
 =?us-ascii?Q?Gnc80QrqQPVEE0zXrrgJ13PXH/2qgwQMpMGXYy8mmhCC7oFggN7DVpsNLdfD?=
 =?us-ascii?Q?HucDbQ9JKICWEMB4IkYvWUT5/YXCOTfU8nrQBwQW5hedKIXzWpoTAc+k1Bsi?=
 =?us-ascii?Q?fNNAdAOrCIIjmVslV41VNVcnTG8P7exuhcgc5ZCpo/FRmG1xhm5ju623jX+5?=
 =?us-ascii?Q?9fFYSWt+TiAECUSb8y+Se4bIitNJZ1xIYlM3nkqCF3hganITjdB7ubZvsQ0E?=
 =?us-ascii?Q?qMQn9JxB/uaDfoShf7y7OGGq7Wsbd1vaY5pcUsQuE1rZD/M2NTJNtOgqHaQ/?=
 =?us-ascii?Q?nD+fdPPp9VEyK3jxXsKKF4lds26qx8R+13486RkD/P1tnXzxmscYMAcMcStf?=
 =?us-ascii?Q?fz6FDCy8jjhH/fXb1OePhYeWO7L8GMGtGy+ZFctnaa56dVaSQiVygkqlZ38O?=
 =?us-ascii?Q?t5gpV+3oPUnIhVGI4NPobBmKUPyM7K0sPILIyMow0KyWTiDzSFvmCr8yeilh?=
 =?us-ascii?Q?eYLicqZOWfqphEh+7KPaNAtE+XAXGZFCcreBjbRw6D8qEyLOraxq/bwSR4Qx?=
 =?us-ascii?Q?+Jiak+mDcXaQ//z/x0Y6v62fCSNd4eZNfTQm0JMj3tDUpIeFUaoDmSh3qseA?=
 =?us-ascii?Q?dnwLvuka40z9yVo253A3gnK/iZVD/IGHdOmsTSn4hnIxOziaJgEPNYYK2KXq?=
 =?us-ascii?Q?W1/0gA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ea591d-47b7-4cb6-d57f-08db666d4de0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:06:24.8292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/Ku5t2Yr4MFRiA5sUmcSkk/klS2gsmUuaJzsGgD3NCZJtjvhIquXIe0+wo2a9AErRXw1Macl+vj+oh7VS2tnVh+i8VndiYg645hT/85yMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:36:15AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Offloaded policies are deleted through two flows: netdev is going
> down and policy flush.
> 
> In both cases, the code lacks relevant call to delete offloaded policy.
> 
> Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


