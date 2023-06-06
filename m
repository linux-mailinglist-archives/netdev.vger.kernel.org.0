Return-Path: <netdev+bounces-8352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A781F723C8D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF96281584
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65A9290E9;
	Tue,  6 Jun 2023 09:08:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D35125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:08:27 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798F48F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:08:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0KH1ysgboSwkmsFm1ZHsVARyYFqL5Z2Rj/fKrZiCDBJe6FwzKeIPvFnavc0IeRT8Gw/4VIgYMjQkKCEbvHtJr0GMqx/HJNyqajTKEMlc10AW5UDF0+fejOG+6os1DHEDNj1sVDKEcENGd/1UERK0mLVip7fJnaN+D7+ME6opWbvfTxWMKXxFpgBRPgt+pPppl/os7YsJD5oXUszil3xb1kEgD9X63OqilrmTYLrjtqTztZvv3CuJjGk3T2fSFlVyXt3RrqfzKd3aISnRmGyefaGALIBEz5tX2PMsI6AQ819/GTaQXFr6LkKgzQkZaBwmIa8sqt4u4TbDA9GDwXuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDcamnDVyMHwqwZMXGctvdXppxusRPW+Egz9obY6mq4=;
 b=GzLOQ4I/M/KVObMyH9lKjvVz2mbBkBr2inJdqHZ7C7+jVQWl7ODBr4mUobhOC9vl8mRDXr2pT6045ZSVpB0mHeeAlB68sre92yCaZ5hhb+Z88xeLJRRBPJy0qpiJ/jG8cj2l+hRvmPZX7Bkn+1x7/zr+3tcW4WZhtC2tXtA5CoidEn8gzBknDQQHN+5/dgtIrPTt3ClpoahmalQfJy8SV4e555ikdVJcvh0OHwKAXEZMxCLyA/MM0BlEI2uDXfO7CzvWCdlxBJcfNapB+cdLnPtb/lf5i2yzIDULtzKkfOr3JsQEGaSUR8LscQzru/iRMPKHMCjyW0snFiMQiBHo1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDcamnDVyMHwqwZMXGctvdXppxusRPW+Egz9obY6mq4=;
 b=dsXvX+BSgDOe2pID6j0uPgEl+xXYLyXr4fl/HHHw1ON4yD2hMJQS+p+sz2VH3RSlfaiVC+Dmku2P1IoBMfYbE0RaXV+ZqMYoO6xmLQIdePPaRl1pkOO7fKWDHUdESu7FjDMXne1ir3Pkepqwac4RWYM3X8w1zNFodtWpFsZUMMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5802.namprd13.prod.outlook.com (2603:10b6:a03:3e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Tue, 6 Jun
 2023 09:08:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:08:24 +0000
Date: Tue, 6 Jun 2023 11:08:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net 2/4] net/mlx5e: Fix ESN update kernel panic
Message-ID: <ZH73gi4JgGu1MZkD@corigine.com>
References: <cover.1685950599.git.leonro@nvidia.com>
 <acc45e30ff0cf5220a3fda02411d22880878102f.1685950599.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acc45e30ff0cf5220a3fda02411d22880878102f.1685950599.git.leonro@nvidia.com>
X-ClientProxiedBy: AM9P192CA0011.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: d0201542-4f66-4aae-68cd-08db666d955f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rajN15KtVzjuWRumvZ+nfRiXnZguicaK6n+W/WVFmZm+0psI5HW3QXDpXwetAw9KqwXHqA7ECKU9NES8NTSo3wk7ssAhdmJEGIkI9hyXc3Bs/jazeqXr+ih3LONw3NHqfjlSs44PZBE//ntgrdyPrBkS+w2dMuNKYsoq8wAM8LKPHhvvz8DHcOxe+GR+E6vxuRZSs9SEN9CLUi90pHaZ3WJ6UlVCmGJ7KSOABGDf0ilStfxBf5nSTEN7gaTMPvo5jocdFIktRUbmSCoF+kphpqrtGbQkOMOeV9svaMx8JbKnH1xft+RVyexhjUjR4yRjsiM6wjsy9QnAx4BO2QnmD4KyNNz318brOLAlmFY/3sNs+IMNSJvGILn4ap3gBTlkHounVuuOFyxxf6Qx2AfovdaVP7E4gaSvUs391f9JVMn+V9HeEfQC+UKKkevR6vvZSLxbT0YMQbRCAySXIpQoOskF0DlumQ9zZTc3qUN2JUUbPQfwGKNK7NaWirWFrlAj9XUOalAysy8+Iwayz2A+OoUEqis9hAshnJqJOI8EvdtZRUy/mQB8E/OtIlyVIeHJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(451199021)(6486002)(6666004)(6506007)(186003)(6512007)(83380400001)(2616005)(36756003)(86362001)(38100700002)(54906003)(44832011)(5660300002)(316002)(41300700001)(6916009)(8936002)(8676002)(66476007)(66946007)(66556008)(4326008)(478600001)(15650500001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UZtUwk/ly9WbKUCsUbaci8aROJ60IX1ptHM0pOeInk0kDBEywXEEP4sKa/9V?=
 =?us-ascii?Q?rfadR8N1OJ0Hs68R8mnH7mtlT9M6XxW8mjf/piAMkU6lmUFeJ23Q7pvhT0jF?=
 =?us-ascii?Q?fC9UUwohOIy1YIChDv0O6DHJLThId5ZuC0T6fTUNafYD7mMlOMI3KrQ/KulY?=
 =?us-ascii?Q?b0U/b3wrMXCLhY2zVYIGTxFihipNTEG30P5icqWL1EnjiSsuI119y9jkaawp?=
 =?us-ascii?Q?FSTxpVicW+clXkWfxlB5FtAuBtVs2WRttJBtNPIxi4kuhMRaZniuruHrat8d?=
 =?us-ascii?Q?lysuh8AILGxDD0lRDX4LkYldCYNTLmsyMG4QaAztYR6c3T7YHEoefDCTtzeC?=
 =?us-ascii?Q?Uvx/PMHS30aCqvDNG6UztCjiFzIV/x1GcTTNEorwzJsu/xlJNgoT7Z96jgdu?=
 =?us-ascii?Q?8f8fU8EdaGKGYmpDnQfXpcmll220VTGnfjBhvjRqXKd5Rv7ZIyYimmMLJ2/I?=
 =?us-ascii?Q?V2G+EWtmVD7DvCRl7HaBhnCPdjqEBwiHbHlAoGL4yRfgDjPxQNt7FknWDiZ0?=
 =?us-ascii?Q?sTiKv0DmvFjfekdTv6Droj76XNENUSklDUZ+/3dQFVW1ury0ab/uG/aqeLoz?=
 =?us-ascii?Q?9v3ZCziTOKvr8M8/Xl4ePvKw01vZG1LRzwihY+m+kV5IiVYPqH9ekBNMv4qK?=
 =?us-ascii?Q?F6sp3W6BKP5vTtw8oFhtNP1cXLYgR+RaHvOyxpFbpST+7AMm5FggSegPbmmt?=
 =?us-ascii?Q?9wTplZKBtMRiwSR+AYCs64ZkDdnyP2Q7rg3AfM2Kwnm9Ikv2yui4/QX/Pbt9?=
 =?us-ascii?Q?VW7vF7vu0FsJ3UXk5qUqsgom46bD6Mpd2bcrkGgqMnmutvFsGgsWxlKcI9sT?=
 =?us-ascii?Q?P05MsFtuGO/DsJiQEcdbfU08NcruXMikfuY4tYLwGrrKgAgYHz8hTqWDQd4x?=
 =?us-ascii?Q?93FZ5M1OqJo2j47c7KkGJ4PLxtm+BRVk8Chj7acKxc7VTR5T13NsZfEkHs0N?=
 =?us-ascii?Q?hw1iUsu1DELGFjzaKn9wlqZDdJMoRBVuYZN1Ga9fCk8BjwmK4zFGADIaHjxT?=
 =?us-ascii?Q?6uvfl4/vsM9ymJrVt42PRSTjGj+fk0eqy2mCT7okJA0tDF4fPLlrRMtgXPOJ?=
 =?us-ascii?Q?fNJ4qVZ+lsBPft8OhWPma6eQRtvmYaA8b30lSrHMI19U24lEttJwK9I53IyD?=
 =?us-ascii?Q?FWaHVqnTEE/pb/5a2j+2uYFMzWwBkB9NbVKr/ZwlkA3uR1iFsCJcifEpvrpz?=
 =?us-ascii?Q?j8URylAkhPkbLr9MSwq7kgOSHkmslHzDutitnriMga9ssGhfQ+rcC+IW+aXi?=
 =?us-ascii?Q?AVR9hScgS9bG+PM5amgP9T1w3WVOqNk+D8d7xBc3NRGdCUZncA52KPYQFxIu?=
 =?us-ascii?Q?Mgp7ukt81sVk9OI3RUY0pqjSCK67OqYeiZtP9OTh/ejOPLyWR7RYQdWnNfB2?=
 =?us-ascii?Q?ltBiAA5c+UhC5xgyVniOz+4Cu/iYyqaRZbdsjgEmnuIUrbJJamF3ikStMxME?=
 =?us-ascii?Q?1CMd8O/dUoiBnBFifveNGRGx5S5S+CIljKL54S0LNN/M1YdG5WWhOPm/LbRP?=
 =?us-ascii?Q?Dw2Yj4P5sXSDb7idGJ7CUAyUnk6+JBmoKNv+6Vf5VuBdMNHryo5S+hjWuqGg?=
 =?us-ascii?Q?Z0/zJobelZr4lRY960K1cCdODsg26nEopTIBJybAwE6TXChuRL9yHyz782Z2?=
 =?us-ascii?Q?0sPwdKI3nDxF7RqskyMm9wmE+lOXzOLKUdNtBwMev1aTH07pqWoHuQi6Hn/5?=
 =?us-ascii?Q?4YkB6A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0201542-4f66-4aae-68cd-08db666d955f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:08:24.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUcsckmoQDgIM7/EMxnV94y5f84FKYdgVL0XX8bh/4a5BbHauu6VMvYRBQVWOF4VyDe/uWnS8b7CITJvLV8dzMLYPpkcQB+fDXcOP++ybrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:09:50AM +0300, Leon Romanovsky wrote:
> From: Patrisious Haddad <phaddad@nvidia.com>
> 
> Previously during mlx5e_ipsec_handle_event the driver tried to execute
> an operation that could sleep, while holding a spinlock, which caused
> the kernel panic mentioned below.
> 
> Move the function call that can sleep outside of the spinlock context.
> 
>  Call Trace:
>  <TASK>
>  dump_stack_lvl+0x49/0x6c
>  __schedule_bug.cold+0x42/0x4e
>  schedule_debug.constprop.0+0xe0/0x118
>  __schedule+0x59/0x58a
>  ? __mod_timer+0x2a1/0x3ef
>  schedule+0x5e/0xd4
>  schedule_timeout+0x99/0x164
>  ? __pfx_process_timeout+0x10/0x10
>  __wait_for_common+0x90/0x1da
>  ? __pfx_schedule_timeout+0x10/0x10
>  wait_func+0x34/0x142 [mlx5_core]
>  mlx5_cmd_invoke+0x1f3/0x313 [mlx5_core]
>  cmd_exec+0x1fe/0x325 [mlx5_core]
>  mlx5_cmd_do+0x22/0x50 [mlx5_core]
>  mlx5_cmd_exec+0x1c/0x40 [mlx5_core]
>  mlx5_modify_ipsec_obj+0xb2/0x17f [mlx5_core]
>  mlx5e_ipsec_update_esn_state+0x69/0xf0 [mlx5_core]
>  ? wake_affine+0x62/0x1f8
>  mlx5e_ipsec_handle_event+0xb1/0xc0 [mlx5_core]
>  process_one_work+0x1e2/0x3e6
>  ? __pfx_worker_thread+0x10/0x10
>  worker_thread+0x54/0x3ad
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xda/0x101
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x29/0x37
>  </TASK>
>  BUG: workqueue leaked lock or atomic: kworker/u256:4/0x7fffffff/189754#012     last function: mlx5e_ipsec_handle_event [mlx5_core]
>  CPU: 66 PID: 189754 Comm: kworker/u256:4 Kdump: loaded Tainted: G        W          6.2.0-2596.20230309201517_5.el8uek.rc1.x86_64 #2
>  Hardware name: Oracle Corporation ORACLE SERVER X9-2/ASMMBX9-2, BIOS 61070300 08/17/2022
>  Workqueue: mlx5e_ipsec: eth%d mlx5e_ipsec_handle_event [mlx5_core]
>  Call Trace:
>  <TASK>
>  dump_stack_lvl+0x49/0x6c
>  process_one_work.cold+0x2b/0x3c
>  ? __pfx_worker_thread+0x10/0x10
>  worker_thread+0x54/0x3ad
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xda/0x101
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x29/0x37
>  </TASK>
>  BUG: scheduling while atomic: kworker/u256:4/189754/0x00000000
> 
> Fixes: cee137a63431 ("net/mlx5e: Handle ESN update events")
> Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


