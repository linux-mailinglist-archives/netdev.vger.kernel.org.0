Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BCB3C14F5
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhGHOTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:19:11 -0400
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:12449
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229592AbhGHOTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 10:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDD5I2C5lHn/KH342uyMlNVueL76LaWQWRcT2wtaGL4ShSUnGWDT9Xxgk19TE7ouRGu1EJOq/NjCfLSDkoEjYkmFFqwtN9sP3TlmjF/lz3msuUkaK3mU1OAuotESST5FTQpbMqOGJFfv4vOFWZcgbBMR6LKwWiaD8Gpm/HP0XFm5YVE/fdWJSJYQCjkMzbPmvTkx71+kj7zdGgfYwUnq5n1Vd4llbLVFXrKN07ePR/ZGMvfHny5uDPUeF8aSg6nAAtojePwtq6J6V2ygDwEU1yg1hN9pzzKW4yw59wAk09pdI06ZqK35PLwtNkDCAK0D81wff98LJdNHJNYXJv1ZIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AE3cxfC0n5CvERAHRboZjnq/BP4DOV2T55Ry4u6w9dg=;
 b=Kk/L823dRAVH38G6cqPz4X5vzD0ZXF8TBu+aOPLQr9yasv0gRMQ0qDVztbJQLg+Y2TJz/VaUvYk/lr4+VCFcCpTgk96YMe9mcNxr/U6tZX/J5WiSs+JU7cvsIKh0cOMoTkngXbmNgENFfXbcpsnDi3S/s5D3TSbz5hkQX1kB88lvZkWNJ7iRVp7VtN4J2S4vQfs/t3WXAY+o2j7lt9UkWzoZVIDMCT29tcGdcNLVC1whRQbp5IiBf1O1qDI4QKmMlE6lRQ0lAXVXE9KUSBwRcE7UV9pcnEyCw1BRK34iWsNB4vV+/CNktGKydHAUoZd4qFLRbdwY9Hy725BF1bAijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.ozlabs.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AE3cxfC0n5CvERAHRboZjnq/BP4DOV2T55Ry4u6w9dg=;
 b=C9XcZgZt1yI970HIMmQ/Tt827FDCTMGPLuP7uGfssPVWQOHGqN7weYSGV8k/1OF+T+bx1J37dPEwniIvKutwSPIM5XrNZ/sIL/oSvT+S6ZJpW+MDVcldmLU5yfNJvekvOyscupzmNtozCe3YVYJXoXeErn7nvTWy1KtiWg39EhiuEkKE9DFlhLg3ESXZYOfVlLwgXk3kR9rj/SNrfPBaNHh6dM1VjHqkcc/9W9if0QCsHAkoWgpqU9p+fh5YXZn4e2frObjLuyiDM7BLpgusebk1U6R1c3HhdKJg61IjWnzpTC7N04RoZ1SXqZvMRmW61/Kur/jr6rlXVgWxQzSCGA==
Received: from DM5PR08CA0035.namprd08.prod.outlook.com (2603:10b6:4:60::24) by
 DM5PR12MB1738.namprd12.prod.outlook.com (2603:10b6:3:112::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.19; Thu, 8 Jul 2021 14:16:27 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::b9) by DM5PR08CA0035.outlook.office365.com
 (2603:10b6:4:60::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Thu, 8 Jul 2021 14:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.ozlabs.org; dkim=none (message not signed)
 header.d=none;lists.ozlabs.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 14:16:27 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 14:16:25 +0000
Subject: Re: [netdev/net][ppc][bisected 8550ff8] build fails
 net/core/dev.c:6020:19: error: dereferencing pointer
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        netdev <netdev@vger.kernel.org>, <paulb@nvidia.com>
CC:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        <davem@davemloft.net>, sachinp <sachinp@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <0683b4ff-43eb-029d-b28d-e98bb41516a4@linux.vnet.ibm.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a843e17c-0709-e48a-8d4f-f3995666678f@nvidia.com>
Date:   Thu, 8 Jul 2021 17:16:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0683b4ff-43eb-029d-b28d-e98bb41516a4@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db1656f5-0353-4df3-e2a4-08d9421af9a7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1738:
X-Microsoft-Antispam-PRVS: <DM5PR12MB173866A5506E7A7BED67A2ABB8199@DM5PR12MB1738.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aq/MZCy6VSUqFDHxWunlLIyViZqkAHpyLvdlQwznGarnpS9l7q92mXujOfI6nXp6mU4VJpCzzl7F0o3dYelnR7YFGNUNA3uv0Be+pyNJ7/ZyEtOlZ4uoQQNRF+RUWBNqUGxWxmUQSL2CFGrXl4XfM8jluTK0KCYbqAKILuetwcmcvsmFutXSFgs7wl9fLj8X1Fu7kxiRcMOM1zJUmmYBIAy1XmZUvhjR+6IbzU3vs60xSVXQJTvMMXY5CWxpy+Byetm2It8zf36eP7EuexVpuRQQpwPLdsXSJIFLiPPboc2E/Jvs3LTkTdK/lbCV0pEBakABQLljyVEwnL6Q18xGiScTK6yCWhfoE8TIe1FjjGkNzKfyK8eeobQQFf9FRekoJZwjdG8FGZtqvB3fpkRnGZr1t+qgtcNtjD5HCa/VNBzZwZCl5APe90HNy0M5+GmoRz53SnquhsofiLOFZHRrZ/+jrO24+m0lK/3ojQQHfe99OzV1Qo8bVCv+FCnpMwWdJVimsBPqCQxVR+3zHs9aoy9WjGaRYvoYhoXRanDAo4BdRYgkzxZ779MnrEu+RlAHCV+XGRgMEiApSTeZv6Jpis4IGQ1iK/z1pXLlrj9VS5TU+IUhiAE4x4rv/k5L0KZVY1dq4oIidIPcpsDFkbLBExei/Czj1FxsXbjiDSxjCAqh4aFrnYlsCNHgu8+G0wzBa/FM+JtM+tj75n9X6ZAQ2Zvr0aivhYof5zj3SA6awU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(82310400003)(36860700001)(110136005)(36756003)(54906003)(82740400003)(86362001)(16576012)(83380400001)(2906002)(26005)(36906005)(31686004)(47076005)(316002)(5660300002)(336012)(4326008)(356005)(8936002)(426003)(53546011)(7636003)(31696002)(2616005)(478600001)(6636002)(186003)(16526019)(8676002)(70586007)(70206006)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 14:16:27.3308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db1656f5-0353-4df3-e2a4-08d9421af9a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1738
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 9:29 AM, Abdul Haleem wrote:
> Greetings
> 
> netdev's net branch fails to build on my PowerPC box with error
> 
> net/core/dev.c: In function 'gro_list_prepare':
> net/core/dev.c:6015:51: error: 'TC_SKB_EXT' undeclared (first use in this function); did you mean 'TC_U32_EAT'?
>      struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
>                                                     ^~~~~~~~~~
>                                                     TC_U32_EAT
> net/core/dev.c:6015:51: note: each undeclared identifier is reported only once for each function it appears in
> net/core/dev.c:6020:19: error: dereferencing pointer to incomplete type 'struct tc_skb_ext'
>       diffs |= p_ext->chain ^ skb_ext->chain;
>                     ^~
> make[2]: *** [scripts/Makefile.build:273: net/core/dev.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [scripts/Makefile.build:516: net/core] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1847: net] Error 2
> make: *** Waiting for unfinished jobs...
> 
> Which was included due to below commit
> 
> commit 8550ff8d8c75416e984d9c4b082845e57e560984
> Author: Paul Blakey <paulb@nvidia.com  <mailto:paulb@nvidia.com>>
> Date:   Mon Jul 5 13:54:51 2021 +0300
> 
>      skbuff: Release nfct refcount on napi stolen or re-used skbs
>      
>      When multiple SKBs are merged to a new skb under napi GRO,
>      or SKB is re-used by napi, if nfct was set for them in the
>      driver, it will not be released while freeing their stolen
>      head state or on re-use.
>      
>      Release nfct on napi's stolen or re-used SKBs, and
>      in gro_list_prepare, check conntrack metadata diff.
>      
>      Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
>      Reviewed-by: Roi Dayan <roid@nvidia.com  <mailto:roid@nvidia.com>>
>      Signed-off-by: Paul Blakey <paulb@nvidia.com  <mailto:paulb@nvidia.com>>
>      Signed-off-by: David S. Miller <davem@davemloft.net  <mailto:davem@davemloft.net>>
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..177a5aec0b6b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6008,6 +6008,18 @@ static void gro_list_prepare(const struct list_head *head,
>                          diffs = memcmp(skb_mac_header(p),
>                                         skb_mac_header(skb),
>                                         maclen);
> +
> +               diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> +
> +               if (!diffs) {
> +                       struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +                       struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +                       diffs |= (!!p_ext) ^ (!!skb_ext);
> +                       if (!diffs && unlikely(skb_ext))
> +                               diffs |= p_ext->chain ^ skb_ext->chain;
> +               }
> +
>                  NAPI_GRO_CB(p)->same_flow = !diffs;
>          }
>   }
> 
> kernel config is attached
> 
> @paul, could you please have a look into this ?
> 
> -- 
> Regard's
> 
> Abdul Haleem
> IBM Linux Technology Center
> 

Hi,

This looks the same reason as Floarian fixed,
missing CONFIG_SKB_EXTENSIONS and CONFIG_NET_TC_SKB_EXT.
Fix was sent by Floarian titled "[PATCH net] skbuff: Fix build with SKB 
extensions disabled".

Thanks,
Roi
