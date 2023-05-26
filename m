Return-Path: <netdev+bounces-5581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BED467122F5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 310051C21013
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E936111B5;
	Fri, 26 May 2023 09:03:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D884111A3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:03:25 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FDB194
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iroPr9RcIF5IDBDa8OZ/KRs/FT9fHmOiItKKU5bvFLtTP4M1lmoO84KCEAiblUPGibIdKXGy/Di3wWo8yzAbb5U9bOuQ7EbEm2Kl+OUbthVJTgfSYf03sO1e1mdQZyoB96I6Eq5jocG7h/NU6SHL/rv/qdihM5Ey+we/KzyOfBdwYx16yU6A8oUO3+MyyBdLelNqytVuis20yO8qQzCx6m9Hn7tEVUhw0CpACpwh2arZEgzh8vPYVO+In5a+K9U4QeqfenPD0/a4dsG2syg5CaJ+uucNN3S4PZ+k+0MkJcRaaCSj/p0y7q2AhFRUvIwvtv6EDURWyVPHSWUhL/7D0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0bMrUBLOQtS4ItdYCV4TqjDL7cy3XODdwoqyM+FSLA=;
 b=BkYKk8KFJVh/5JOkD9pZoBguUz32waHtQXReAILcm0YsXEL6ch8Sj+vPxEkT4hviufc3a8NN9I/dyvKUJzelp/5ueFfRT3ft5zUYjItyhyJUeiqltmfSjL+AeBg/7Qq+OBW/vZ8eavlEZBtHdl4UreOmKVFr42oXmlM6kNr7fqc11gYiRrhSsB3LARkK0riDAl4+Uq8VsW+Z6tCIkXL7cZ3wEBEaJPR/ADbiksY0i9nTThxG/QWmYvuCUvso9kMmzuvY/F0/ekY4D6svROHN8FAH2Je6/Y+Bi8C1HWvcZ9g+kvmC3wtdk53brGZMAZak7nPKwXzn4vYDesDzkl3WWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0bMrUBLOQtS4ItdYCV4TqjDL7cy3XODdwoqyM+FSLA=;
 b=jLW/RWo1/dtZVNOY4QYS0f8WttFaP05oGKhNfz9qXbMJlPrTAVHK1UoGpfvtz6C6s5Wp/2aJoDUZPggzbAOB30JX2DTljZHbuYZH3Is1DHPi9Vg7f2PdK0Nj1TARgwySVqVW1rMCbiXNbLo5D4DUMRpQuEGbiaXhinvl4JDT6d4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6252.namprd13.prod.outlook.com (2603:10b6:8:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Fri, 26 May
 2023 09:03:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:03:19 +0000
Date: Fri, 26 May 2023 11:03:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com
Subject: Re: [PATCH net] tls: improve lockless access safety of
 tls_err_abort()
Message-ID: <ZHB10INz2OEy7v7D@corigine.com>
References: <20230525051741.2223624-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525051741.2223624-1-kuba@kernel.org>
X-ClientProxiedBy: AM0PR01CA0118.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: ad94062a-0cf0-412a-e0d4-08db5dc80cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2uLlSwzx9H3baY3o+DD+5Ut+QrQlxeElUt8Qubnjo894PeZbzXnTlxA2+3jtVd4OuSQPF043v3eDNOMBSpaBoNhqpYgYNupP46KbjGdgU751B5REmF1hKrC1cR+nUb/o7dymasdM9rBWfqcTZN+vRnwIgtbGa+0wH7XOFjohxOe9MBnNa43hycP2BNQD3qHvoASvpc6Z3qtxe5HeISEKPIgOAgpNPGhfqbWiF1lQtZGvmIxI7ykJgdeQjdXE+sgirwnOF0mCEvtsDBs7IxR7eZhmtQ3lw8uls+5L0j7BtkQaFK3CTD2ZkSVInB0vN1P/u0gVG41EXmXG47DZAL2mjwQ0TPIHVEMxf092dROmy/gE3S0VG3SX3kxnWVJUfyMQGue6GZ5xCoxVSGWDVYXOoghlhH/W+DxqYeoWcH/Y3DjXY9VPWmhS8//FcnZGIID4y8khrfjS9xWbFXrAAck2PitG1M9yQWPi+chSqKEUc8qbXqeUhz+q7CQnT8geJ8v9ef1nxBiM/pVCCLI/ZaIMt9CtENqp3gIQ7Bz6Hi1KNP2QiwXM27YWFq0CiWUWqIq/peO2WWrd2w/YyTVK9ddi2d/Tm9GjV1+8LdbeLJe2SaU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(136003)(346002)(366004)(376002)(451199021)(316002)(38100700002)(36756003)(6666004)(5660300002)(6486002)(41300700001)(8936002)(8676002)(478600001)(44832011)(86362001)(83380400001)(2616005)(6506007)(66946007)(66556008)(66476007)(186003)(2906002)(4326008)(6512007)(4744005)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?saV0np7zrovhr9OCwk/q7Yhy+W/2CEY6MOh5uQaXJGjbQqi2FTh+OSxDfk57?=
 =?us-ascii?Q?5MCcP4DR+PC+VMtiD3rZipTDzgdtQpIrQg4PQeUzDJOrTG+bopk2AUGsN9Y1?=
 =?us-ascii?Q?y//HAk1ErCl3O1bjyaJbvf+FNNLWxetZlwi0Ujh5sj5d85uKT2Gxqn3LpbJh?=
 =?us-ascii?Q?XZ9bIFrLxjUdjlecbi574n/AV0IONJ0asPg2Il6RnOFgT0GchT0czUhPMRNP?=
 =?us-ascii?Q?3fNrBh0sUZtNMLl8kMLn/pR07lqInjMtyxGzSLASzpTPJPOod/d/Mx/WfjvH?=
 =?us-ascii?Q?8uwyIEHmucKCtcQxz6wNrVIDrglZIV/qASMlsQxxHgg4Iy0vGC8DF7sFYoCd?=
 =?us-ascii?Q?BcaqCWTydtDSGkDepewsJxIsgiE0pHUn1aejNqSVKMJoUJTnmRcLNw2sRo00?=
 =?us-ascii?Q?bJRWKHVbaXp/gnoFPyIUhjPAAnVrVDqLFCysSJpVblZG4Sjw8Hj1fO8dlAI1?=
 =?us-ascii?Q?6TJg4cy3kqJx6WhgmYNRJAG728u+uXk2LPHab/s1jvJUutrNUkpoTVRahZJ8?=
 =?us-ascii?Q?VW9xPBOpc2ldbzPXyHK5lN2Uh0for+AjcS5YpeL1iKm0poKr0V6UCv0qNR32?=
 =?us-ascii?Q?MIgZ42B/f2jjfQ8dbOcc4cQtMb1fO+9Y4O7u+5YiXum2nchxvXe8h6jzjFqf?=
 =?us-ascii?Q?832DWf5f4nHiw3ah7bNg7E/Qu4J2Gf0FPx+LrtRz6gH77iQ0V4joWTcUyQ0S?=
 =?us-ascii?Q?wDmUVX10XIsABR6px1uwwTMsstbpaUwf8wQOF1lm/iat8Jl0rdxsY/7ofip6?=
 =?us-ascii?Q?uG7LUwYTmsamNicV6D+F078St+TMCwhRxZDQGX5jfznVb8Yg3Kom5q4J+2TR?=
 =?us-ascii?Q?Ohf1vK9jWLJ7k+4L1gtS2LajtvO6ytfRLiUWSxRwq/n8ywWT6xh2C6VHKkK8?=
 =?us-ascii?Q?H4cWvqTRDPXh0r9TV6Cp4wY7UpnRVjumTDQQzwfbSYMEJSdvMeRAK9/xhQzm?=
 =?us-ascii?Q?3AgXPR0lRgZNELYWxdRxS0fNnObDwhK1Ejol8+TSUfDPQ1gy6xF8tE7s5y+h?=
 =?us-ascii?Q?0E8t/z1XqD9ySZRNPJk1GwDkv71J96zdFOvuMtPwsh7t3L45/275+ci7i/hh?=
 =?us-ascii?Q?UPcUt9u8uA0cFHVIuGJEQY4xFz8CbE1gFiLpY7d+sPnhPTu7n7EeFTd5FRJx?=
 =?us-ascii?Q?5GePov3gYLTk0oBsVbFfM5UfrAaMWjEr+B0bRCLrwdQZ+rKVTRSc5oWIkWZR?=
 =?us-ascii?Q?lDT2PKPnlSX3MlzfZJwy0O3Ink68ijCxumcFbNs+/XsmMr/nej1p8RVQig9H?=
 =?us-ascii?Q?mmeafOLjMNdE3lk4pwyWny90NSkVl43JxSVhvgz9W+NgiiY4RavStwRl8Qbb?=
 =?us-ascii?Q?i+l/XDE5LlEAInaBwVWiN7lXYXx1ZbW205iiJArx/KK6N/qqCoengtecG8AG?=
 =?us-ascii?Q?U2ZZUPJVgKgp6P9M5gr3I/ClS57QheqFg14axsnId2jbF/zEAZlyyUVX79fz?=
 =?us-ascii?Q?K+w4KHEyko8FIUCYqipNERHf8YfgzoLhbXfh/xB/yDSXsF3vWNhXdboNt5uC?=
 =?us-ascii?Q?Pw68XJ5dZgV6NnMY4F5/IO+y5wAiVF7Zg9AgzMJg6iu7tz8YT8xyojjFAM8o?=
 =?us-ascii?Q?5R7taUVD4E8OCL95h16O7xtf2FvBehbCpSeIn/Du/LSs0BUIIk6aeZT+MmXf?=
 =?us-ascii?Q?VrLTrqg3LWyBs/u6Xb93FBgxLHCn4XoYNeP78Rx2cajHKAGiXkATHcFqT2rS?=
 =?us-ascii?Q?Xzd8BQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad94062a-0cf0-412a-e0d4-08db5dc80cf6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:03:19.6928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zeIzbKJWDMmnNilYZhmxTYPG/cJqcUxWV2J+HCJMwFf/YRNAaWic/6lOtiAVQmVJGyrL0rb7P0kprmMw/qCOjB+eW4nIVWRfwb8fjYRrGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:17:41PM -0700, Jakub Kicinski wrote:
> Most protos' poll() methods insert a memory barrier between
> writes to sk_err and sk_error_report(). This dates back to
> commit a4d258036ed9 ("tcp: Fix race in tcp_poll").
> 
> I guess we should do the same thing in TLS, tcp_poll() does
> not hold the socket lock.
> 
> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


