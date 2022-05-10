Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DFB520D9C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 08:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiEJGKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiEJGKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:10:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253C7275D3;
        Mon,  9 May 2022 23:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L49ipIE674svkX7c05jlMVsLz2wWoJs0hixRmkXeh+NO2Nk0fW8dgczNLwrNmcuDTj6Vc7l/SHCwkZsj0N+VldwCxToG/0cE5BmXRvzZjB7cj5w5U+H5DvdjAfSRMfWSCok7dI9rhY4sfIa+8ty2MeLs1NtLsLIgtpGrqQfH+Kq0brNwAgrEO0Jlpo5v7+kJVMKBVHaBUhvVHeGlb1HnvdtwacEQQlJHbN8xQ3TyrDap2GiOjeKEYza3TVMfGvAGewj2JvU0mlzIew2EHWyubYR8h1NTn2OsJ2Ljc85Fh0JTy7eARu4NVkk9Q/dDwK23AFeNL6jePrMD9SxxPJFiXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkzkSr2aZc/+KrCQz/n/nGGw7eob6gmJQlGU7IPvfBU=;
 b=kFeYz3oHl6S1utM1fjZT63PxS6XLcgmJa8zsdvmxs9in9dxcTRP78AXje9fGTm8n1oabKYtCGP68q6H6EmfIf6Tl9Kb1dL2KbKV8rQnrUXTI6ItgJTMuDKilmbYtgynvY6eNRvf4rhehEw5sKHKbaBr7Kla5AQWL9ao9jnX0txsqaH/v3RePdFpMuMfnWMazs214vCg2WwS5wJGgsq0QPTivWcbrCElQAMHT87Gi38gXFlH+PUhC1oIYh+lNhNtyVDdzmf8MGkiwGbFrOlaAM4Rp6aAUGGe27zNIrOf+60EbyTkgpNdOqVe1lrDDEGjedA1n/qvc24IQpl9rOgUWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkzkSr2aZc/+KrCQz/n/nGGw7eob6gmJQlGU7IPvfBU=;
 b=KcX+GsjVHyVLzJ2lZ1wcAekXENLClJk1yoEAPY/ZCFxyU/eh4IvrgiIu07OrtduilM31T69B8dIyI5DCc7eNDU8en2X9lJrYlkwMBasYfW8cJwI4+Itu1LKRRaLWjsuwlFNs6rA75cDsntxKuQH42FWcvi0ypakk9J3hey9sUi3y8UL5PmPOy+degb2JByYk8ipJ4zQtJb234SM9pzjHLeK+BVVd+IWq14Gm/XMZC0YJsM260BTHgfO9pRhN3cM8vIB9hxgri24MNNciXHnTyuP6Pvz438SB3kct2UGxnciE9CQfzMTQXuVcobHEcW/3LYgSjwMyPEWzdYaVSI8qmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 06:06:20 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 06:06:20 +0000
Date:   Mon, 9 May 2022 23:06:19 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Changcheng Liu <changchengx.liu@outlook.com>,
        linux-rdma@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: correct ECE offset in query qp output
Message-ID: <20220510060619.hmuwrwgplnhlfcnc@sx1>
References: <OSZP286MB1629E3E8563657C551711194FEFB9@OSZP286MB1629.JPNP286.PROD.OUTLOOK.COM>
 <Ym+/WnWceotzny4f@unreal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Ym+/WnWceotzny4f@unreal>
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dedf8fc-5842-4b60-2ad1-08da324b33ec
X-MS-TrafficTypeDiagnostic: MN2PR12MB4062:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB40628ED4880E1340B8775A8CB3C99@MN2PR12MB4062.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QISp2YUQatmn+FHW3vzSqOvrD+Hr4GDWOrg47V1h2IdGdYt0e0Fw9xdPgAzzKow52bA8ToBw0gDUfSQWr+v+J+SX+DixTo3LeZFBO2hy20pE9l8vHD1YjO8O+9I+SLEJNbSmdSXVd+C2QN01bXQcct8yqrwORdvVTpHiZ6EIIDpmTUTRew0/hlI88h1NPcz1Q9b0uFW+o+jwKUVFTTT8XXB79rmZXt4WZPJcirtOHWuEyIuDlBW078MdaCkOtbcQXjc6ZDPzqZWr1ThGLApXnSwm25CiRYg7e4YOPwFBjvwuhVnTuERH4LbDrX1kzYfiSQ9gz2yo7ymmaK2XXLlCElEN9Bp2qswgaXlXuZxStBAMLRxAp2DDdbuJ6ottF0lx/kb+jg6qbAy6ZBdApxOsgdK/AVP4YU+zmK8WOtWRm/6ETiw+8DBhqDsCa9/dTFNENzpQB0CNtjr0tszfWkps4F4KErnUo4evLdHmrIst5VgXP2fAYo+TgbYKYFq5qrAmiaBllHFatatNDizjOyxrP2lds8ss23THS7w5aXWI655IA7rzLw3eZgjhikqn+l7/TedRpsrHTT0Aa/nnlqNGOAShzM17ObSjGMmPQ8gdid3SiRxz8HoY2dgAlrEnRcYn2lQGKklE3DB4YbiYVTf1CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(6916009)(66476007)(66946007)(66556008)(2906002)(8936002)(54906003)(1076003)(8676002)(4326008)(316002)(9686003)(6512007)(53546011)(6506007)(508600001)(3716004)(33716001)(5660300002)(186003)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7T6pHlhDnirJRX3dahXzkZHPpGkSANlyEON05bYg9t6lEqgMnn4Cp7dZSPeG?=
 =?us-ascii?Q?4a6jjkKVO8JZ6eOMvjcGmMJwXYy2H8jpBZRJe1evObxmJh8BE3UPnanO3gNI?=
 =?us-ascii?Q?3OFs+Rb20k3rbavF0T1XtYUYl/OXiqTSCf3gDUKbacKJ3N59RtCnKUZ+lFVE?=
 =?us-ascii?Q?C0H8dOWiS2a5Uw/ZBb4rqfN/5CpfS0zkCywvwkLWgTvCnlSyvaCdmkuEhD7x?=
 =?us-ascii?Q?ExjFiB7YQb6Z9y0B+8p2U+rwb3KvEVhPIOH9Gw9DUDiG2hjWLdfdwhZfiaAd?=
 =?us-ascii?Q?5zQEcVEibBvdIPKDUjPtWb1HoER9z5A7B+4uSd4utlALn1ZAIRXRpfNf6I+D?=
 =?us-ascii?Q?jiewIfNuiH6JlUropTk9EIWb3txbfdoc43dV5RVl2RAKbw/U/IaYBhVqy2Fu?=
 =?us-ascii?Q?/cJj/NzK3AMvA3cBmWv7+Gj5xKqwnp+EVqgt+v2M2lS9K5BXAbxy6logoN2s?=
 =?us-ascii?Q?tRL2B8hqrOBmLJU+Uj3YMwDgvwjL8JAScTqEB9Yn1Hn0i0rvOfrW4opdwjNU?=
 =?us-ascii?Q?YoCu0dVeANTKuoTGcRp8u3aYuhU9G1nqOGeh64bCxNZLP376M1oCM9pdycrn?=
 =?us-ascii?Q?xgYlnJM5SJ9X7VeuQ/x7F6Yv9+nazy2XVRgv8/mc5L7LpvYe+01/BJ1RtmH8?=
 =?us-ascii?Q?7XOhaBfYMHG3hchrc7x2mD9x49EygDykXFbAe6Z/3ZpKkTVAXeFZbaLFYocb?=
 =?us-ascii?Q?+vGsLqZPx0cXw+CIqmslSjS571pekGbCRH3sFrC9gXU9OIqOxvNVMqut9zEL?=
 =?us-ascii?Q?WhglNPWapB4+1FpS4oXR/N1LIg3jh++bU/qmxp+0Qfkdp+z6N8hAymzFgpaB?=
 =?us-ascii?Q?D9OknCbdPHEzKRaZBzcoSSyQYqUXK7cxstuXDMdTqTTnNIZB6tp9a2XFWQcA?=
 =?us-ascii?Q?FG1JhrWeZw8JWH42nNXvlYe0uxqv4aJIml2pUDbNii0YJukxyHSIru1hjCbN?=
 =?us-ascii?Q?RxtSrvglNmeqefY9fofU5cbVlNZPf08lPSz6UIrz5H4UUN/pOf3FSDeJHAiD?=
 =?us-ascii?Q?+RSgeK6BRjzcL8C4s9agjoyyQfQn0Dmh61v/792Mtv2kW8moC4p19VXuoPm3?=
 =?us-ascii?Q?m0nWFDT2yJ6ogtchOiVj5Q7lpAGzMMINUPAHOTYE16B+/+D06DDPxn94W4Ou?=
 =?us-ascii?Q?t3tXQsTMbhz64X394hq6FXN5vnDDcg9LHTy1hw6s/AkzlRwUTSXMyCx6rF/M?=
 =?us-ascii?Q?vCG+EvixceNYWzYTC8pTAW/+T3MeOwOrUiDDLWXojfsoczl3NBLAPe7eW5kw?=
 =?us-ascii?Q?xywLrT3zqc3nMrcf7XOY773iXG993PrEIQjT34I5wAlygdJe22tWA3JWolrH?=
 =?us-ascii?Q?40btnXMScMbVy1jxCzPRuueIk76zhwraCXhBdVDIot1A/GjOfG6SNHo7cCXr?=
 =?us-ascii?Q?5vBuwdkDxVeFXC6HHuHSRaCfTsN5L8i9XK0tn3pZpdq55MjxApay+oGjhrUK?=
 =?us-ascii?Q?7K2eENhFHav3oB23zhpF9KxpxIKWxdckCnEoJskD9wWoAFlaw7KGpRM2X/fy?=
 =?us-ascii?Q?HCVWHTIVwQwqrXflCIZk3oddZ7T4MVsJ4fKxMJFJIFH6k7KPY7jRH3wjkQin?=
 =?us-ascii?Q?QIIm10Y3Q3e9U2uScnxCePO/ORu/nTRGsaQAtmOoDY8j7OXT8HPaDzYc4TfJ?=
 =?us-ascii?Q?4qOhPNgC4uE/kfoOStmOXAt0QHrr+LshBHTgaQ/rKSA+xBk6ayzk9aE0mG3I?=
 =?us-ascii?Q?gSRwft8e3FUnnS3cRi8ETqwQxm2/J9e0wQEpHnVGgURs/9xvYz1HJgYnJQUa?=
 =?us-ascii?Q?QWAPqwxq1GD9N1YtQ8zlESPqZqlA3YDUOdFWfNq3VBTP+XE+IXb+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dedf8fc-5842-4b60-2ad1-08da324b33ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 06:06:20.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/JyZalVk1fzJNAJbITmGiFqvcH6yf4ZxgdyHpKSpKq3jWoUWk6kq0wEXrJV6FmQ3JUwrdVFuBPdiXkXAZ0sYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 May 14:24, Leon Romanovsky wrote:
>On Tue, Apr 26, 2022 at 10:06:11PM +0800, Changcheng Liu wrote:
>>
>> From cd2890fc0f756d809f684768fabb34b449df6d29 Mon Sep 17 00:00:00 2001
>> From: Changcheng Liu <jerrliu@nvidia.com>
>> Date: Tue, 26 Apr 2022 21:28:14 +0800
>> Subject: [PATCH] net/mlx5: correct ECE offset in query qp output
>>

Patches withtout a target branch [net] or [net-next] are invisible to
netdev patchwork, please for next time add a target branch to the title.

>> ECE field should be after opt_param_mask in query qp output.
>>
>> Fixes: 6b646a7e4af6 ("net/mlx5: Add ability to read and write ECE options")
>> Signed-off-by: Changcheng Liu <jerrliu@nvidia.com>
>
>Saeed,
>
>Do you plan to add new patches to mlx5-next?
>This change can go to that branch as this field is not used in current
>code at all.
>

I don't mind, i will apply to net-next-mlx5, and keep it there until the end of
this release until i am sure it introduces no conflicts,
I don't see any point of putting this in mlx5-next at this time.

