Return-Path: <netdev+bounces-8736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C33537256F7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202801C20CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD6A7482;
	Wed,  7 Jun 2023 08:08:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3761C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:08:48 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8D0E79;
	Wed,  7 Jun 2023 01:08:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODtw/HcsXfeEF9uT9zxMXFzXyZIVokLAaTb1SWRlmDgXkIr+ZUC3VGDDAzYmR7Dr76wAlOmvIGXsqtOO0W+L8P5W36Eg6/wltVh591OYuYOrulf35gsD/cDNe8oBBgu8AzUgOxkIja+DABMw//7mvxX6P3qtRkr6Gb0jpyG7MayoHTNrvjxTDoPRoJQJbIjyAhUrNz/DymDI0ImO2b1U7lGZeodvr32NyYNAeMqJElE1a+xSdyAv8TGn/m38kTBvjRV8OGKELChFEcZ8Jx5eJLDLAepaaXkxCGhuyiYR4ey6qaZOKSf2arFH7uSrf6JnNrYNPFVGVfhx7kKXL7HSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1G0aWMn9mUQs9+guqQ3nuWY0l9QWwz6/vs47KN7opO4=;
 b=SEU9WENDMD6eDxqP4nJVVE37LqnKubLYM1fpufHkNXhdYcDBqaXNuc1+J3Jtc4QNvMyK/mN8oU9qrnlXbT8OFRvJGGeCgHmEulAvIOo1wUhk83dLmFURMraUki91EWE/T9TCaVN81hChWT6+j2yG1VnTDXW8WvKHdZWy9wsKhNrsEN14Wgm0dBwrbsuOQqGVt0malWKRVReKhNIic6co+/5+k78+FAYvnx4BAVSoDPS+42UZXN4H/JPFM/O0ZC/Ty6an7w4Nxi2NTJXDy5s/hzJtANaq1zK3cfRAl+CKbgpGs+MFwk82f2zMKfbzcz/7rblwPYvT7Jo7wTIwdj0zzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1G0aWMn9mUQs9+guqQ3nuWY0l9QWwz6/vs47KN7opO4=;
 b=uYxIWWJnzn6KtAVNK1mrQZ53gKXZuI8inXh9R1uDctUrdKDfBa1h9OKNxOhyDn7VrysFGxmT7LLNT/Hpw1L5PP1uhXzq6H7xUzXcifR7PBIbuU+ZZsZJgw9SIcB7GyZE5giL+PNJmnG7wgQ5RbXxk1j7+e/RmYpufXbxOoEajCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4522.namprd13.prod.outlook.com (2603:10b6:610:62::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 08:08:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 08:08:34 +0000
Date: Wed, 7 Jun 2023 10:08:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org,
	Derek Chickles <dchickles@marvell.com>,
	Satanand Burla <sburla@marvell.com>,
	Felix Manlunas <fmanlunas@marvell.com>,
	Nick Terrell <terrelln@fb.com>
Subject: Re: [PATCH net-next v2] net: liquidio: fix mixed module-builtin
 object
Message-ID: <ZIA6/CBlDN4CyA3h@corigine.com>
References: <20230606171849.2025648-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606171849.2025648-1-masahiroy@kernel.org>
X-ClientProxiedBy: AM0PR03CA0078.eurprd03.prod.outlook.com
 (2603:10a6:208:69::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: 135e0db1-d40c-40c3-85fa-08db672e63b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HwBA63AhULEnKJABqoGUpidyjUb/N8Gyt7IoP3yGK24CAV075ngCvCQIi3nBREA+cr2u5lFWOfvYL4M7JbcmIHFNgXerUlNNZdQoom4Qzly/R2kSID0uKZXwfIK/65Q26er4ZvbVHld0kmWSfUZZ688vA4Xfui9IRMoyBEK7FXThzV3Xxbcv3MDLOQ0nJ2reqdNenXhkrrHSqzL80e9/4kF1p7sUkph4IfQumoexcRdSErr8Y8BbTJw2VVocoH/lnIjOCj938JpwVbNYEwRu3V2t8+Nw9l9/lXQoSuPRzkh9+luMmhTOpl68MOizWfeU+FvwL5G1WK9Q5OwD5Gj9N6HEqYgIaL5bo71zrgpd8yl5m4zGryVl+vPFSz8zosz8FLwS3DWRTWP32t/EqjZMZ9TZyEcWO5Cj1RQcNcRNPBPtqKCExGajvfuqR995u5AC9yX5Ba8jwlEyaa1aOxt1HQGV2aePz8NjSjj3P5bVuK/uh8XB1h/xkm7uKBqwFTOXv8R5pHSRao/9OkFf+ioJraTxWtDCnXGPxwjIXmh+NO8u1v7TMrhVi2ZgZtYZSI4L
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39840400004)(451199021)(478600001)(66556008)(8936002)(8676002)(44832011)(7416002)(5660300002)(36756003)(86362001)(4744005)(2906002)(54906003)(66946007)(6916009)(66476007)(316002)(4326008)(38100700002)(41300700001)(2616005)(6512007)(6506007)(83380400001)(6486002)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lne5tTuKHA89yg3SXK4kA1xQw/AZOpqK6brDz6JvTHK9DNu0iyFpB9hHbKUp?=
 =?us-ascii?Q?D0KuWmPxipqMNK/VZ+LyxEPLx8LmIRN6n7bEvdNxRgYjV4PD7W8Gpp0mter7?=
 =?us-ascii?Q?3z5P9ZMsxYnr9y4RXIZSN27oQwI8bjGjIpXi/0HGquMRdhezleCC55L91TWi?=
 =?us-ascii?Q?Ygu7PSAPlbUCywnDQY8iIKaWncHFvioiffGKXJGcxz/iKUsMn1jepvMdAGmX?=
 =?us-ascii?Q?bJeWO+aNrxpViPJgnmlB7brjaNZ9/JALaAJ3UpYeijoELc5Ix6lbMmGd6pt6?=
 =?us-ascii?Q?HI9VF3ZGE1APQyDb3otiRNc7RotGPxFW4gYGR43KXZXRoAfMGQVv3insT/+Y?=
 =?us-ascii?Q?bEEhdHoK92WhhIakOam+iZyN29DRqugNjMUbsbSl49T0MjylqiMaM9MW6DgD?=
 =?us-ascii?Q?Wjor215c2R6S42EvV93fw7eCdmzs9q2AS/4ov7tuwjDw9PHT94q4DBXQQrz4?=
 =?us-ascii?Q?2aRMhw67Mk5QsQyuLUpDi67txbYMxKIKIQfldXcmrJE9jFOZRWzEucH4CBhk?=
 =?us-ascii?Q?fRfdX3ozrT2rjtyq3i8YYylL02mepIZnH4y+cBJ8RuKx72RtqVQDwWGxMJSa?=
 =?us-ascii?Q?zZDy/o1DIFRKP9GLOHc7dKoLeFdHTN48Cf81wGWlrAVFW6zZ3djFDj03ilug?=
 =?us-ascii?Q?yftOdjUST9jjk4G2Ald4Z1sK/VN+qZwaoMq2l0Q8RO2r8XEms4sNziG67etf?=
 =?us-ascii?Q?BHUA3G4Ehjn/owLHcs61A4THSGYNTyUiEFkrxH+uPCf+tXjLD2dOAPOsFTFc?=
 =?us-ascii?Q?Ad7Y1qluvW3PbxUrHYwO6hRqK0vJcbgzxrDj01bSs3E43kifrmw60T/rqvEz?=
 =?us-ascii?Q?vKpkxf/h5C1hGFpwhmYhSQ5IhWBw4ogjRWz36an+dqmXMqN7bgXVI7OVnbpG?=
 =?us-ascii?Q?AFn9PWyRBxenw+W3U+TNBkbbQo2MAZRk7ClqTX8vetbTFKeYonyTp/fvXz9O?=
 =?us-ascii?Q?HTmDg9mLnBaOaIanpOCKqktofwFKusXHQHt5Zb3R+PAVGZsjF6DWuhi4k1sl?=
 =?us-ascii?Q?W9mPJLHvMzGPqVGclwt3XefFvXXnUU4fblA4pCG8etpWhTvrnvgASC38Mawg?=
 =?us-ascii?Q?lVPCD2jXwoK+/GbOXqcUENESHjeuOl4XEKd1FyYovIMlmNhwb2eltApjhNpG?=
 =?us-ascii?Q?ZgAUnAoCMhZM9o/IWqGUigWHOp8Y8P08wjHJUD6HE7MYJbn4GtTV8Kg3NqCv?=
 =?us-ascii?Q?u+fOt9HEC/hdw415mpp1brxskSqOcUzoOKS3zZEsOzXJLmaUiJC5wwRH0nPc?=
 =?us-ascii?Q?u0lkWTNbUMmcneTWboXGhXBK2Tq1jkuiizQ65EOxK8NMzMAOEoowOCAkX5yK?=
 =?us-ascii?Q?q7r0mocINSBCHEkhS1+3RwJqL0FjDqwJPwogBOtoQX7NDp6PFpKQH6ICFj9Z?=
 =?us-ascii?Q?eaf0NcCmhOhzsOg6CigbX0EfuwOei1wFNtU8DDI9Nj2qcleNHJ7uo361PHUz?=
 =?us-ascii?Q?nrxW5z7yLZ4N9tFBV8GBlatumnH/ZnTe6k+yWr8IP7IGFGpDvwEIBl29T5uw?=
 =?us-ascii?Q?SuLhgYD8CITXI2v/yyuD+P/RQtfWrVlgZNBsQKfaGTdu/jEWpYTWTMNUBCfW?=
 =?us-ascii?Q?w3Ia5Crrn2JBiogN/07FbRmMWA++eFXxKS0cmzpe3h2MnzBs8MGmrkKE6Fu3?=
 =?us-ascii?Q?222pejbNyCMmjYbKv78xOuYD4MiZRvRcL8Onf5MJmf4a6o7a8vsB3f9EKCou?=
 =?us-ascii?Q?lZ7HhQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135e0db1-d40c-40c3-85fa-08db672e63b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:08:34.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uaRePOnqx2ObAMs/QdviNOfKt64sy4qZfkPtuJgOeocFcfBUZsNYx+J9Sd4X/Ku+/kphCz67booGUVo9BgkvAcO4J6/bY+ElkGjiyypSL3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4522
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 02:18:49AM +0900, Masahiro Yamada wrote:
> With CONFIG_LIQUIDIO=m and CONFIG_LIQUIDIO_VF=y (or vice versa),
> $(common-objs) are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules.
> 
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
> 
> Introduce the new module, liquidio-core, to provide the common functions
> to liquidio and liquidio-vf.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
> 
> Changes in v2:
>   - Export lio_get_state_string
>   - Remove $(common-objs) from Makefile

Thanks. FWIIW, I did verify that an x86_64 allmodconfig build
runs successfully. Apologies to all for missing that in v1.

