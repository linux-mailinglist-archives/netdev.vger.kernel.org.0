Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558F43FBBC
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhJ2Lum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:50:42 -0400
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:24800
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229556AbhJ2Lum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:50:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1B0t8T2gvwbqcjcZpc5MlIpsUSjbhbP98efxaFEsdbDHRJIzkPW+yuN8DexO+DJWWfWh8avZPfKieGh6oG126anY86/xycpQaayvGgWOHXLnq6x4i9OJGVvsMO39YvaQL/vh3yFBanO6CLdAwj4wGOdfjx0S4EQRuHqdq3XPbu3qvmepFcla5Wnb0uCHm2WU6Atny7K/Yh1CtytuNgzx7moPuPhgc3aXUprVFY7uYNOj7KnZtwLykJCHpM0AbQ3eob4Sa8oatfQ2mmNqCdilhOlKg+KCVxmAuspaw34xamkFfN1vm8XV0/g0pFasMLSrCveSynwS6/C+sHDHscvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MVZndbcHO12R31T2zRQ5u/20++i9cI/d2ar/UND6WI=;
 b=ZdxHgJpP2MwxQaeqy1QA38MtUkX/saWLf5KGq5M+uKCfBp4K+wjeJnnQmPnoCrr7RsSTbdw+H2R8ahNeTOxX6BdRbjA4YmbNvOoOCbsa8QKCCvdqzNOcerVhBaHQp6gQBR/svyD356ykkoX+sxKUkvu7C5aJX8WlxG4zmOhZE6XnQ/QzLgNztQdaBY4wVQOQNMy21lavBVNbVCn5SoOUlm8vf4Vd9mLRPUWZX0SY8LyjuuVSCHXNx4s//cyYZ21dyLF4REAgv+CV6+g+soPvdT94jwbFw/+Q9wc7dp3yYCZTIGn//YDSjBUfX7Owh+A3eAAWi/pcqvJSLR2YHMurjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MVZndbcHO12R31T2zRQ5u/20++i9cI/d2ar/UND6WI=;
 b=rfM7H/WLJwT3bEtlcrve72px7/PcT7jJzRJYqV7KHUNx3yEt/5yDPL3w6yKsT7Z4lpk7EzANZBF6qVxSxYd376sjJJJ8REO5H1J0/dQLM1pyYVrs7UG7yDAOvA7R7TzFMuStu9lJYAN8/9b4fq/bOxF0dUY9HUqK2Q/myG1PcSzgDEs0Icobu3YXkBh1zzPpPQ6wnJuR4tVW5Bs6wncVsAuoXKChJSa7iI7yJFY8kxv+TOvrluDBXPv5j61btdqMPFAyrgxkyDXaolmfjbxb0xohYeUojc282GQwsMhAyKpBrjzvsiXW22ITzqeGq0DoLMMK9aKx++V3lZiMFIWmiQ==
Authentication-Results: blackwall.org; dkim=none (message not signed)
 header.d=none;blackwall.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5087.namprd12.prod.outlook.com (2603:10b6:5:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 11:48:12 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 11:48:12 +0000
Message-ID: <c09158a8-f94c-5e33-db31-59430501e631@nvidia.com>
Date:   Fri, 29 Oct 2021 14:48:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net] selftests: net: bridge: update IGMP/MLD membership
 interval value
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org
References: <20211029105343.2705436-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211029105343.2705436-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 11:48:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12c48107-7b97-4264-a6d5-08d99ad1fc39
X-MS-TrafficTypeDiagnostic: DM4PR12MB5087:
X-Microsoft-Antispam-PRVS: <DM4PR12MB508779705856E858682714BBDF879@DM4PR12MB5087.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmGROEKbrzViEeILW37IYIq8X19mdQfpkCo2tCFnd00I9UDhCZFP4ejAkUfc3ZrR7XP8dnOIV/jjBV4+ktTM1Ql6sHlP6l0q92PVWOVoQ73NhfJZFEZ4AKexKt1z7f0+v8C39lqoppkYWUFVCDs/CQ828tj+ZmZbKJgan6tKry2BthU61ZNyzO1ER5WanMWFArsRmyBUCKS9OCl9tEahRpH82UPLWq92kFzmsOlj3O26UQ2sHRAOmfjWvkP7A6SjyFbIm2BxexQunC/mEXStIHSUdw5GBJ0EBus4dkqbELDarTud9BLRxKud/xcDa98UzOJL7fOZYM8fF0xP1jOX2hlIE5tFtnAM0DFXpmOiTizbtg8YY/GTeeuHnWFfauHLwZcVLIjYgjn9tMzidAcrWoFw0vl8rFvja+jupY+TmtcWw5/DUiRLc/HeKf1OZ3m0sFV3U9cHNI32TWXBGyPSOHAEYw3VUvWnVx6IKnnmF6FNESEDDtItXTX993NW4cid7AHFNB9AVTQ7Cz0wwTkBzqegyT6crOnYUIe64S+k+Md+IvvbmFMnSQM9q7qOqQfQgvBlnBZwfsM/uzjAYnZ6zqggjtju8LGf/MEM7JcZRJRmDtNYn+gONbv0Ye2s6ZmmRr2DOaPZ8Y62WCIMWqeULx/8m8sUNZRbe6OqD69iE/AlBKHZo1dOBo4oooG9TQHw7XAGqIh0Bn5tyypHdn655wWdtTFGPsugIfx0c2qGVKqbs5rSq1oa/fKfsBDH61HC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2616005)(186003)(31686004)(26005)(31696002)(6666004)(86362001)(2906002)(6486002)(38100700002)(66556008)(4326008)(5660300002)(66476007)(8676002)(83380400001)(53546011)(66946007)(508600001)(956004)(316002)(15650500001)(16576012)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODNVaGJEcnNtKzl4MVhMSXhUSktETHpaOXh5UElrV0FLMXN5Zm9WWlY5RWZi?=
 =?utf-8?B?MzhJcVlNWlROVzVzVmVhMzN2YlI4M3R3VWg2WWhoUkpWNDlSbWZxOGFzM0lv?=
 =?utf-8?B?aE1rR2oyYjI2MzVOb005eEdhWE45NUpTOERIeE5IZmNIQUxiYUlobnUvTmVK?=
 =?utf-8?B?L2xXaEhVMTRKeWhWWWJGV21sRlpEN1pHZ3hlZzNZall1MEVhT0NLWGQrNjNU?=
 =?utf-8?B?VEdxZ0FMWlV6QVJHTnFvc0VwS1B4WWE4MUQvbTU3d2xmczJnd213S2taSTBy?=
 =?utf-8?B?SXdzWHY1YWs1WW9qMHhDSUh0ZEZjS3owZkFhV3VSYUxINUNOQ3c5Kzh0Qkhh?=
 =?utf-8?B?eU1PS2dkNUxrRTFOclZRVmxHVHhiR3dhdTVOaU9SNExWbkZlRVpMVnphclFy?=
 =?utf-8?B?eUJrMTZhODB5T3RtTUtGVDBuRVJBa3VTUGFvWnUvQ3FGd3dBa0lESHBWd2JF?=
 =?utf-8?B?WTdROGxUWEFqck1MbkpOejJZNkE3bkxuRVo1d3pBUmR6Q3F1Q0xnSDZvWER4?=
 =?utf-8?B?RG9CVDREbDVqcVpHUml0cG11dTA1RHh5TU81eWV3NDNRazNXMm9NN3ppWXRr?=
 =?utf-8?B?Mm1GeE9MSUUxR1dYRnRhL1lqdGVmUjNqQ1lGN1NGdmQ0WW1uNHpZSFJOdi9X?=
 =?utf-8?B?NXEwdzNpUzUvUDAzZ05YcHNPdnY4eHgzVVB2Q2pGOWh3aXRtdWQyWG9SdUNE?=
 =?utf-8?B?ZXZwNE5mZENza2lNbk1OU0NpbXlKQUcxUjBVZ1M4N3J4V052aElvNmMvTVdz?=
 =?utf-8?B?OUpndVF3U2hzbFZOL21HSUV0NFVnOVFUeEpGTnQ2V21pdVFEZjFsd0hMQmZ4?=
 =?utf-8?B?VjdaUU5CMllWaG5Rd2VJdW5hZXgweVdqT3VpMS8zTTVhRCtrS3U0ZXIrN0s4?=
 =?utf-8?B?Qkg0azV0UldUN1hlN0g0Nk9ldDZ3T3E1a3JDM29VR3pSMFg1Nnp2NWNsdmtz?=
 =?utf-8?B?dElmM01vOE1LYmFRNENRakpqckdQSy83MEJ3VFhYWlREdGxFQ0YrT1FzZHVu?=
 =?utf-8?B?Tkt3eENPT1MyUUd6enByV2VJcXJaaitibi9NUW93cmg5TWhQQXQ5UWVxWWxV?=
 =?utf-8?B?dHVoMjI0dGN2Y2N0algzVzBCai9ONjlpYzMyYklNMFlKWHJWeWliRVZZQTJr?=
 =?utf-8?B?b3hmS0daUFlraWE4NW9VdUZBSEtjZ0l2cjRmYklldWp5aXBXbzg4ZFNsRUVB?=
 =?utf-8?B?Q3Q2SE1yVGZCTHJZS1oydlNqL1AyZHl4UnRNc2hGR09WVFRrNUdWbGFnU2Rx?=
 =?utf-8?B?VE9LVTY0ZE56R2NHa0lIdHFlQ2NCMC9LRUpoMXFxWGFjUDZvK1pSNmJKRlVY?=
 =?utf-8?B?MXFGTjZ4a0pkM0VkSW1CYXRPdlpNRXo0UGJnMGdsOU44TUoyMW1xcWlmNE9O?=
 =?utf-8?B?VmxlSDE2R3preHVUeEdMSGJQUWRqSjF5elRjdXR2aHJ4WkRoRE9yM3IwclNa?=
 =?utf-8?B?SkNMbU9HWFZPcWVCdkR5TUROQUp2aHVUYU0xWjVKUlhYL0dMbXBMU1hSZnRU?=
 =?utf-8?B?bGp5aFMveXVHdjQ5TU9aczNvOGV4NmxPejUwTHVZZ0o3cW9nenNhWk1zTC9w?=
 =?utf-8?B?ZnZBTXlyV2NCc0tvUHBhTDJjWXViWmc3ZmxJU2Z3c2QvYTd2QUxWOVlpdE1L?=
 =?utf-8?B?dDhUQ0VMZjcvblh1UzRYY1FxZGt3UFVKSDJkd0dXeW5lSmQzd0JZZEpmZFpE?=
 =?utf-8?B?SDlMUkJzeUl5VTJ5Z1ZHY2ZnNk80RUJKbWpsaDBRWmxXVVdaeklOYXd6b2Z0?=
 =?utf-8?B?bzhDOHd0VExMbmh1Qkk4ZlBiaTd4VW9wNGlLdFB2VmdjWEpBWUNzbVBMdWFK?=
 =?utf-8?B?SzBmRGtFYlZEUUVtclRFMnBYNU5uS0ZWbWtjUWI1REMvZis4Wm53VzBEaTVB?=
 =?utf-8?B?dDN0d2xxTXF5RTNzajJrcFhjQmZReEZ4aUxDbXh6Wnd1SzhnZVNqRUVpWFIw?=
 =?utf-8?B?aUozbmdDTkZOUjBkb0dNdW8va1BTTVlLSUg5NHNVcytuYUtrYkgwSnhJc3Y4?=
 =?utf-8?B?TXZLc2hvYUNNY1pYQzZkQTBsSEFQNEJnZ3IyVjIyUDdKSWZHNUxzT3ZBMWMz?=
 =?utf-8?B?ZUdOaDltVkxubDgzeTA5ZlJ1a05ObVA0NDliWDMxdHVlVU1HNktlK3NUa2tU?=
 =?utf-8?B?VnlWSWs1VXRZREtVNGRMU3dJNWp5ZWw3c016MVdrZ0NnbFQ5SCt2SXE5NytF?=
 =?utf-8?Q?wP3ucyHnB3gBu5kEz8qUHDI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c48107-7b97-4264-a6d5-08d99ad1fc39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 11:48:12.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HG2J0b5VykJoemAZ2HpNT4tUS6whLACPD2VfayHv4WsyvnzHT7k6XqIJeHJ2Cp2jZoKYcV9O+fCR+xAcLus2bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2021 13:53, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When I fixed IGMPv3/MLDv2 to use the bridge's multicast_membership_interval
> value which is chosen by user-space instead of calculating it based on
> multicast_query_interval and multicast_query_response_interval I forgot
> to update the selftests relying on that behaviour. Now we have to
> manually set the expected GMI value to perform the tests correctly and get
> proper results (similar to IGMPv2 behaviour).
> 
> Fixes: fac3cb82a54a ("net: bridge: mcast: use multicast_membership_interval for IGMPv3")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/bridge_igmp.sh | 3 +++
>  tools/testing/selftests/net/forwarding/bridge_mld.sh  | 3 +++
>  2 files changed, 6 insertions(+)

Self-NAK, sorry for the noise but I'd prefer to have these values set by a single
command, no need to be different and also to reset to defaults afterwards, I'll
send v2 to do that.


