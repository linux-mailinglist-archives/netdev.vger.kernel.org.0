Return-Path: <netdev+bounces-4297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A2770BED1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01DCE280F2E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E703F134C9;
	Mon, 22 May 2023 12:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9886AD4C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:55:05 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2135.outbound.protection.outlook.com [40.107.93.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC379A9;
	Mon, 22 May 2023 05:55:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQWWtdUwA2mcTW/OKBp6397oRKJ3bCC9A4XgMqUQ8mqlf5x45esm8z5+UWpIapKfIY09Q72a7cwrRDhkX2wsy70bTBotbTOuHa5jgM15GA0gOM37E53CG36DCyFDJvNtq9nQ0+Yv7VyxDpkuPwJmscIbIPCvqZApWwYURR9yygRfiPOiwkr8zD3rPH2QUy+J4zhIA9adfxNa+GeXt92Hmf9pwwUrQcWcQ1im8D5DOgwH/OrM0Z8rQ02cDfyfvc9wqisC5Fyu87vjOc9KFgFKR9nrVk6rSqSfw6KUC9Iw5nPPhLvp6DjYse1foQfDFzR/v4POlsScCUxtZs3DJmHcuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F5G40iar9MLcq+X768mf6nxOHyBJ7nbNzjz4G0ZhF4=;
 b=I/nEVsMeM1NPCAjW6Kl4C+2RCa/nSbQGN6zNek86TzRhzqtR/UDm4HhAKJMVtHblAAECuxjpEvhPoXyCXCOg6FhipGmyviFTYgbOrlLK65EbnKRzIhJvNlRm+pYsZ1TFyoVW7r8J2N9JxRlTl3kw4VqIv4vWCYBQIMi2FqKZM2cLCiq3Z+yUybHuXY+Ff+d4z/OdVdTPFgjn52uJWy72NCAkaClhluFYHKUR7KFEE0m2kDixZ9saQ6OuQs9jDs+ulx85m4UWdhTVdYlL+dnJfssis9/We2AfjP10jJsnmjZUG4BInYC1g8PA0XcO+Vx0H3Ny2gWzZhGtzdWrmcUoIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F5G40iar9MLcq+X768mf6nxOHyBJ7nbNzjz4G0ZhF4=;
 b=svru0RYp7ojVp1sMGoRNstXJlpWMDZ0ycQIz3UheUb/+sfLMWkpsV/yI62UyIDodTVAvi7BqQu39JV5vNJea+bkMaNt4yrRBg5FDtu6eHNur3Iynnm5wSotndlvJc06mumL8NL5JUqd87Ht3vGdrBOYrX4bIHYXcoRqWP2qXRSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5468.namprd13.prod.outlook.com (2603:10b6:806:233::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:55:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:55:01 +0000
Date: Mon, 22 May 2023 14:54:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Glauber Costa <glommer@parallels.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] sock: Remove redundant cond of memcg pressure
Message-ID: <ZGtmH/0ytVZkkmCP@corigine.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-5-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522070122.6727-5-wuyun.abel@bytedance.com>
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5468:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e29651-c14c-47b7-f2ef-08db5ac3c162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uDvXNlBMdiPbb8AdBoALNUZbp5CpqeEuo6majkI7XyTA02XNGVQXTFq5+/HD5pHo+nbKJdMUd1aTIl4enFzzlyQoCeiTRu6SW9H2Dfv7ToW8beQVkgnwlJlR4RUZOeGe8zodhsAlAgXhN1Chgh0YX7UixMXraAMzcwr5wm5OAQ7zN/Mj5j00qXwjDSaFdV+499ayHh+xTf8QC1U6iFk097BPgQF20Hlz/C9HPByBa32wTmkYBI2yYBCC375u44HYbaPj9SUYBxNZ8SeAN1EZX+Zhbcx/cHrShErho9xGhx8ab+cf+zitIrm48c+wJOwJp2uSUEWSkvkmb8mNbapjgyjSlUlyZX0YSoDcfWIJQKycop2m7hucO713lF6GrzsByBNjMHhfElRQkX9BJdOOC2HjSsZphZDZUwuBRPFWae6wnPcbHGhfBPnO5B/prqS+2ImFTZ0NhuwU1exMdn0nWTu/r2oLxYtRtxFZQ5woi8EiU9NmrxvE6llLKsvLixXDgCWPlahXUnIXou64Zo310y5u+qscikkx15G0yPUneiHs3UDrK0j3Mq7osXVHCaXM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39840400004)(136003)(376002)(451199021)(6666004)(478600001)(66556008)(6512007)(6506007)(66476007)(4326008)(6916009)(316002)(41300700001)(66946007)(54906003)(6486002)(8676002)(8936002)(5660300002)(86362001)(44832011)(2906002)(83380400001)(38100700002)(2616005)(186003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NxeTx1k0M7k8eah0dVNzdWoAod46osZN4VbhonBHVjv4ZiCUyibi2dbwRVV7?=
 =?us-ascii?Q?7ZiVN4LgtxgdhsEOrXs4ONBR1LppIyLW317yzOzKB+ItK7RmdLAkZGLNTz1a?=
 =?us-ascii?Q?DNkv2PmiBy067qjeN9x1CB+uD7HVYzzyCy/j6CS0THzBn01tT+vH5OoOPTgL?=
 =?us-ascii?Q?Wyd4FTs9n+iaMKM81COx450Abpeir9l2CVx7Xon/JJDvOm/IiYcJjGECvzKf?=
 =?us-ascii?Q?wj2UQOtqHXp7CKJ4AwVII7aD8x1W4UhQIwyTDA+w5nMvA0/ZVLb6DpbiLzgb?=
 =?us-ascii?Q?xQSDr9ddnieyBEkqLXro49LrsXRXVHFzFmwdMWEC1/zGZKrL9SU77ixa3Xuo?=
 =?us-ascii?Q?DF7IQ3bj/PGQ3F37KFir0ZgaxDjVXoWAWgOv1Vsm1JSJRpZVFNNdHLNTp3AG?=
 =?us-ascii?Q?/0nXWX2s9KZHypDoTNT26hio+kaWae1ZBx+AfwxfvTnSBpGRQNf1MF2rJgGb?=
 =?us-ascii?Q?gTXolPDuG+peC2DSb3MKHDxp2FA8h6opTpzrpoqYiS1IWmx3AbFI+Gy+hvJK?=
 =?us-ascii?Q?97QdQt/bhPNBzrsfoWbBjYbWPhe/ZOUaxNfcq3iMH8bZ6wzhl1DOx3wOYHSj?=
 =?us-ascii?Q?C5yZakcbrzHmsY3jhibbLBQMJ3Not0v+snWPinEpSHK+F9F5Ka/Xuk7aa9zh?=
 =?us-ascii?Q?825uKFJIjRQbn4I42fK0dl3akRIAVM4OcvymGSfrNU3PxVdtoFGHdthxVNu7?=
 =?us-ascii?Q?gLt1thKUrcgbjw+rWZ4z+GYv/GL5JWxxSoM3QVq6r2IJXjsMRkIAaR4ywhGi?=
 =?us-ascii?Q?4l1TBChBpXkbtsrOAXlgY/4ZWvChcp1vgJ2jXhPWhjgjqIt4omu7aoA2/OhR?=
 =?us-ascii?Q?sacNStYgWtIp3SqfB/n+QuFqnoW7SlKlDBCPQXVaU2A9OB3WRgrEReMIwZK6?=
 =?us-ascii?Q?RLwGKqFy4MsMIsDYoZQreKyJ631oVJ2TJ1KHOjFSQCr2eMvlgwHF3qfCWh5D?=
 =?us-ascii?Q?mVUcUUO+/ikrkfvZy7wg1GL+ymmqKx9zJhoU0d0DlDIbWK2DRFenB0TWXcdx?=
 =?us-ascii?Q?IFWWNlau9RnxmIAqz7cYsfLOpIc14TWO55DxcXIAJY99O/799EMcDFblzM/B?=
 =?us-ascii?Q?uYGROOugvCfmIY4m6M4p69gcmT/27ubkepLfUx4Mjk+9hrQl/nPV3acR6DlS?=
 =?us-ascii?Q?8GFeLl5jZp9+cQ06vNWyAhDjh5osDO8kYv2/LYC0yuc1kIaheK0DBSfZns1C?=
 =?us-ascii?Q?UjBDiWQcfaBYWB56qgyoj/I5vLKZGi0G05r7yXXdTavw5ueUE86h7hd0DZ5u?=
 =?us-ascii?Q?YU300grRFLu44Yj9zLA0pD9MJXn2qUgnGCIe+f+VW15YCU+qx29iw66EShQx?=
 =?us-ascii?Q?rKY9IiNBb4tbUL7mfxoALllz9yXHyRZ8u/IcmBp+phu8AQMz0Rrve5+GdfWf?=
 =?us-ascii?Q?clmWTWo8gPFWesvWIndN+M03UcN3XNvWwOdI5cip22CAOBUZixye9F5UQJFN?=
 =?us-ascii?Q?GPxBEIRcOZCQsGedgJDhQ3DtKNmc6tBgpvO3qG8G9EuhRHDsgIK9vHNTogmU?=
 =?us-ascii?Q?vYCZxn0MeX9jOC61SptmGxVAUYPv9Kv5c/wE/WsRwnnWNyK5i0Fs8HVbgJNq?=
 =?us-ascii?Q?frTIhzMZ8zEZuGpZVCopGATG+86nQ4WMFm3/59N2Nwe64DGkVhvDGTzwdu+w?=
 =?us-ascii?Q?CMQ5saz4oyB+9G7vNnpYMNDkiu2E85fNeB0cnd0e168FvCP4QlH78Hv6T1d1?=
 =?us-ascii?Q?2q3LbQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e29651-c14c-47b7-f2ef-08db5ac3c162
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:55:01.4074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecQlltXcBHUKXaE+qGqO2XLlz2UQe4KX5azisMiv9rWqfdetAJYrGTCY76OGsYTGHs1Ysj7bhz6H14NiqNoD7TbOK0EggJ0DOZEZBNX92jQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5468
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:01:22PM +0800, Abel Wu wrote:
> Now with the preivous patch, __sk_mem_raise_allocated() considers

nit: s/preivous/previous/

> the memory pressure of both global and the socket's memcg on a func-
> wide level, making the condition of memcg's pressure in question
> redundant.
> 
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>  net/core/sock.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 7641d64293af..baccbb58a11a 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3029,9 +3029,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  	if (sk_has_memory_pressure(sk)) {
>  		u64 alloc;
>  
> -		if (!sk_under_memory_pressure(sk))
> +		if (!sk_under_global_memory_pressure(sk))
>  			return 1;
>  		alloc = sk_sockets_allocated_read_positive(sk);
> +		/*
> +		 * If under global pressure, allow the sockets that are below
> +		 * average memory usage to raise, trying to be fair among all
> +		 * the sockets under global constrains.
> +		 */

nit:
		/* Multi-line comments in networking code
		 * look like this.
		 */

>  		if (sk_prot_mem_limits(sk, 2) > alloc *
>  		    sk_mem_pages(sk->sk_wmem_queued +
>  				 atomic_read(&sk->sk_rmem_alloc) +
> -- 
> 2.37.3
> 
> 

