Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0D953B5CB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiFBJOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiFBJOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:14:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E6F11142
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 02:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHI2rFCPXd/raamR4cA+Kmvvv5pd0Py0Od+HqwMoEE2FMrJsHhLvaBj5lLJGwPOTHXA87NB8JDiu3MWdgm9ZGsWE0+C89jFhRG24FgX9l1RwpLa6vwItJ/XNH0DA8Kq9u7mTTh/pgBBeIOzj+sGWehSsPBQSBg9o8E2L6jup06en2a9LLDB4m6+h4EEVd8Il4Nrojvnqg6Tu2gXsOyI+JiTVffUeolROtk0QyEn2qRWKjk7FfhOhJwsvfdCtOXQtI3f53JGwoaM/f3AHHgCVNMQk9xExAzn2D3XcXeTLWZTowKWaTcTSE8Fl9Ey10PE7VOAdRXJ11vi3fowJczbOIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKu6CChpN1Yoldg8uDXvD3abjA3Fam5hYH0Iggb+6PM=;
 b=IbqgmVHlP7Lv6ElXf2gENgXBGjZVeA+BaUWdglUQrMfsLuZYDLZ321mRBC++ZR6hvC0Yegh1Owi4zU5Pham0zQhVyhC9MeRJ7a/FEFX7gXbD7tPlIw1E1CF1Vlo6LvPltiWrW59JP9Um70Jeio97hz7AAN0kihN5znyOiBDFZrYwGRwj3C4jTeYtmDZ+wsegqlYd0bBC4Og7XaRzT5Jxq9BjmweYVZ7k0Qe7lilXWBf5qYY+dVCvEN9Ga+wVNH6FjmthqgFO9WVMUlS+6cNTsuVEtnS6znQFK7oSRk+FBfCmcX8JM9nfRl8Lk9rE0clIHN2DnA2VUQxaZZDL2GLK5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKu6CChpN1Yoldg8uDXvD3abjA3Fam5hYH0Iggb+6PM=;
 b=jBpEPzZIYPE0Ktk6ee1EYw6BqkDZ+IQivZftEBfORKplPizoDKZiIZMyMyfGPJNLKxkU8G8HetMK0L5RL6Ot3U8POVAtu8R+YKgvYK8WA5gXNcdR5HaFfNYOPGZwhTA76fYEnOaMGS8/Ug3i+VP1ugs/I4G08L/5Nlk94mAiMb/V0TeKb67C889jnIHf4ViCIAMIDB8gRODVRksSv9zKEUkBJIUDVH7LLQE8b5/buPm6QA//A6e/box9m8nB6Vty8et0BdZZleDIvqzSb3ValP6TbnMdtlLOPR0bh9t+5fKtNnOeTkeJoG4neb0azbcugWyNavqw5qiiw0RaaGWIog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 09:14:03 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 09:14:03 +0000
Message-ID: <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
Date:   Thu, 2 Jun 2022 12:13:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        tariqt@nvidia.com
References: <20220601122343.2451706-1-maximmi@nvidia.com>
 <20220601234249.244701-1-kuba@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220601234249.244701-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0387.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::14) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19832a2b-9955-42e2-46af-08da44783c89
X-MS-TrafficTypeDiagnostic: DM6PR12MB4217:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB42175212833706E9DD78DCFFDCDE9@DM6PR12MB4217.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlgHDGumlcikjzaJx2mLfIqfD/07bUk7NuV+HaDKQwlUStYBAVdMlxDy9kW0rwWC0HCT9GbvCkD48VhKDQQriZWHp5KyPiZAv8u/G1FGGfZJlmW2c9DCNn238mE9XZhxvKRcWrI5Hc/85/kTg4SLzZQtcn8kz0Or9csK9a/GgmPg2td9/EErqsJ2q9/UeXDXocF7AsekkHD6pZ80XrGaOuEtrhyYwpeX9EBFAx3Cwx+E4y6jK9LmlxYl3FdANeJ7g9Pj1guvLyQpFDkX+8rRrEGoDZzKb6ozMhWnP50xgODto0qyaROIDW2nNGkwyRKY64L+1iyG+yGIPDMvEO9d+2sA2QqM94cBbgpi7UskocserKoLqV1QevLliwZFRRwWJFScRj/q5by40HUkCZLG4zBSvSMUmnoPj4huSY9YvNrCNyetMihNVrfW4RlYQO98kDc9yb33kc6LTUefjgbEnjaV2rZsFg68mXoZXV65DMEG+LsvIdXpjjyPK6ZnY3NG4MaTU88iLgUYKrW5//BccgwAxk2saHnTNqvfX8Nc3J7gOtU7vDlb69tDSLAlf6NRsEcKVvoLMWj0sCGpVdWy3lh3T8zPLaV1LdcrQtpAGWspWWfV7bsUc7WVPIzjWrbl/wYxrRL1nHT/ujhN9SaRpsCYJ/H6CkPqiARDtMJA9rzbfi0CPh4eEVL5IuL4hy4D6fA9QISurIaIUsG8uhs8PHuVmZwJrNHqJiWDBwFgG7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(186003)(53546011)(83380400001)(508600001)(31686004)(2616005)(107886003)(316002)(36756003)(38100700002)(2906002)(6666004)(66946007)(26005)(66476007)(66556008)(6512007)(4326008)(8676002)(5660300002)(31696002)(86362001)(6486002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejdjV2dRa25sWFl2TktnZWV2UUI4VXFPNnNkTGxBMUlJNTBKRkRpT1VWM0d4?=
 =?utf-8?B?b0pad3FVbWc1OFlJdjI0NzJycXB1UWZCSm5wb1NMTFA4MW11NU9jWG5pbWRZ?=
 =?utf-8?B?Y0NiNzlKTWNHR3ZQeE91bEJaQS9UbDN1L2ZRVFZVb3ZCY2tDMGI0NzRETVBM?=
 =?utf-8?B?ZnNhTWlObXROcVBXY3lpYTJtUFZqRGhLZXd3cmlaVEl2cU5qUHh2dzJqOGlW?=
 =?utf-8?B?RVIrRnNpR2ovWFlSQUlEdjNuVGEveTc4YnJvUlp6RXgvNThGaXZnMHNXNnQw?=
 =?utf-8?B?Q1QwSTBxY1VCNEF5UVFXaGhTTnJCL1VUZHlaT3VEZmxwTVhTbzhpRUV2STdm?=
 =?utf-8?B?L0Nrc0xOaDNJZkQ3UlY2TEFuQk1MSWRWc1JYLzVNTndSOXdZakhnR2Rkd2pt?=
 =?utf-8?B?ekkyUGFrSUxMZ2NzVGd3ZDVkWmVTN21HT0Y0WjVNRnU0ZVJEZTNIRTA3bnRs?=
 =?utf-8?B?MjZRSmEzZUtTMVJBQWZYdmxQcVRXY01SQ0lUTEUrZzFTM2VVYzYrdFFPMnpw?=
 =?utf-8?B?a3d0UDB6MFYwclFDdXh1bnFRRHRYSjJJODlTNCtGc1huR2tHQU5vTHE0aFRW?=
 =?utf-8?B?c3Boa2VEZ01zT1FPTHlOZW9WWXk3N1Rqay9sTU1lQm00eGlFRklXcUZmV3FZ?=
 =?utf-8?B?eG9kZmQ4OE0xSkxrTUN4NnNadSt2V3lzZ1dWMkdSRHV5cFVvWTRTdUNEL1k4?=
 =?utf-8?B?TG5zREtDQktSMUFxTm5yNHpsK2FZRVhicjZjMjdUQkJNb3g2emRob2wzdHhD?=
 =?utf-8?B?ak01MmwzaDVybEtZMUFYVHVONVJsMUdSNTA2cFpoUDZIVjFsVkVqbXdzOEth?=
 =?utf-8?B?cDVvcGJIeGt4cHdUVHdIMGZKNGd2RHRjWTJlZWhvTjdwS0ROMUUvaE9aenBJ?=
 =?utf-8?B?Z1BsbXNnUWtLNFVnOVllSGlBTndQQk9sdkg1WW5sSDkyVXNaYjRlQzNyZFJ6?=
 =?utf-8?B?R0ZIK2V0ek96aWlCSjkyMmFBQUdObFZVQVoxVnJ0ZytkOCtTaEZoaEg2ek14?=
 =?utf-8?B?SmlEUnRXMnNuUEV2OFRPRkY3NkhQM1RwUDVLNThFWGlCaGFwT0tqMm1qNkNN?=
 =?utf-8?B?R2hSb1ZTTUQ0Q1JTVEpkM1I4L29sWER5dGNFU1lhWllad2FkNHJqZ0ZHOXRj?=
 =?utf-8?B?bmJjWFlqTC9kbnRiNEN3K3NhM2dRaWhlRDJUQ0Y5Mkw4VUJtNXhZMVNRM1I5?=
 =?utf-8?B?NjdNa0R6ZUtUVXJrcVR5YnVhQVI3S0JnTU16cG5wY3JWR2V4bnNTZGNObWhF?=
 =?utf-8?B?WGN3ZE9pczNtR2hObHlWL2h4OG5zNG10QVhjMmpTMnl1eUs1elFWVDJKdHpn?=
 =?utf-8?B?dlZWdlk2QlRPM0hrZGpGd0lyaGxZYVpCVXdEU1JsQlcxaXFmRVdJQTA3bG44?=
 =?utf-8?B?clZBUS9FZnoxWVF2SjYxSnJVbmpjTjkxak1LVUJTUGdKK002bUpLaFpxY3NY?=
 =?utf-8?B?MDF0emNSWGo3UGpwZ3hoRTB3TE16SFpxc1R0NFJYb1ZUb3loRTF1WlR3aGN5?=
 =?utf-8?B?K21TUnluaWkzMGl4MUhlTzMreXUvL0xKdnoyRlpPa0JXQWFLWEp1RjlXWm84?=
 =?utf-8?B?RXN2WmtZVWNsODFuYVhVQkVaaXRma1JSMjlIT2lDVWFaTXIvWXJxOS9aVm9U?=
 =?utf-8?B?bm9nZmR5MUJKVVl0WHdQcy85eUp2TnpBdFF3V0RoYlRuMDhmdVNHVDBXZGR5?=
 =?utf-8?B?YWlmSjYxQXdVZGgyK3VzaTJGamNaU051RnlPV1lVNENoK2dJNmZEZVhhRzc1?=
 =?utf-8?B?Z0lhSEdyV2hhK0RCUnVodnJhSFFzN0RTZVFNbmo5UEY2SkpwUzdsb0VnOHh0?=
 =?utf-8?B?a2FKWWRqV2xoMTROQlJsenhjQ2o5R05YRnRIWnFDdnNRTTJpaU13V3oyVC9O?=
 =?utf-8?B?bDZ3SHFqUnZ5eEgvaHY1bTFxTjhDZE9ST3g2VWZld2NsZXd2Rmd3MUs3b1lP?=
 =?utf-8?B?Ui9HcU1QS01NdGtaa1JrM1V4V08yRnVGK056U05HVHg2NnJzSllXTzE0cjJi?=
 =?utf-8?B?UEVxWjdtS2lMaHR3bWRVYVF2R0RzNXJMT2k3b3NGQmREeHdFUW5oQXJ0R2hr?=
 =?utf-8?B?TUZZTmRrdmV0cWsvai9sYlFheVVtellzQ0wwQ3MxZngrUEF0Z09wNUFHZE01?=
 =?utf-8?B?YUo1SWcrOWExNzlZN0RGdnRVd09vNkhIT00zV2wyT2IxS3lMSENCODFBQ2ty?=
 =?utf-8?B?ZVlURHpSUzFXb3hBa1BESTVOS29PTk9xUUd4YnN5TDVZNHY3N2VwUjdkeDRQ?=
 =?utf-8?B?YVNlM1lJR1czQWZCUEtUSGsySk95cG4yWUFJeDR2aHgyc0VaSElhN3Y2cFFs?=
 =?utf-8?B?RXQ5b090RUhCRzBsZm9UbUNPWjNGN1d5ak81UzhEQ0FuQTJFMWgzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19832a2b-9955-42e2-46af-08da44783c89
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 09:14:03.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9S7Pv4CYes7ifH1ACclx3bUp7FQR3p/q0ZD7iYrOECmY7//yayOEEcVzRJzVwKFoKX6uLendVK9BdL5ko607eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I would expect to get a comment on my patch, instead of submitting your 
own v2 and dropping my author and signed-off-by.

On 2022-06-02 02:42, Jakub Kicinski wrote:
> Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
> sockets") used "key: value" format for the sendfile read-only
> optimization. Move to a more appropriate "flag" display format.
> Rename the flag to something based on the assumption it allows
> the kernel to make.

The kernel feature is exposed to the userspace as "zerocopy sendfile", 
see the constants for setsockopt and sock_diag. ss should just print 
whatever is exposed via sock_diag as is. IMO, inventing new names for it 
would cause confusion. Calling the feature by the same name everywhere 
looks clearer to me.

> the term "zero-copy"
> is particularly confusing in TLS where we call decrypt/encrypt
> directly from user space a zero-copy as well.

I don't think "zerocopy_sendfile" is confusing. There is no second 
zerocopy sendfile, and the zero-copy you are talking about is neither 
related to sendfile nor exposed to the userspace, as far as I see.

What is confusing is calling a feature not by its name, but by one of 
its implications, and picking a name that doesn't have any references 
elsewhere.

I believe, we are going to have more and more zerocopy features in the 
kernel, and it's OK to distinguish them by "zerocopy TLS sendfile", 
"zerocopy AF_XDP", etc. This is why my feature isn't called just "zerocopy".

 > >> For device offload only. Allow sendfile() data to be transmitted 
directly
 > >> to the NIC without making an in-kernel copy. This allows true 
zero-copy
 > >> behavior when device offload is enabled.
 > >
 > > I suggest mentioning the purpose of this optimization: a huge
 > > performance boost of up to 2.4 times compared to non-zerocopy device
 > > offload. See the performance numbers from my commit message:

 > That reads like and ad to me.

My intention was to emphasize some positive points and give the readers 
understanding why they may want to enable this feature. "Zero-copy 
behavior" sounds neutral to me, and the following paragraphs describe 
the limitations only, so I wanted to add some positive phrasing like 
"improved performance" or "reduced CPU cycles spent on extra copies". 
"Transmitting data directly to the NIC without making an in-kernel copy" 
implies these points, but it's not explicit. If you think it's obvious 
enough for the target audience, I'm fine with the current version.

 > Avoid "salesman speak", the term "zero-copy"

In the documentation you wrote, "true zero-copy behavior" was an 
acceptable term, and the "ad" was the performance numbers. However, in 
the context of this patch, you call "zerocopy" a "salesman speak". What 
is different in this context that "zerocopy" became an unwanted term?

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   misc/ss.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/ss.c b/misc/ss.c
> index c4434a20bcfe..ac678c296006 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -2988,7 +2988,8 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
>   
>   static void tcp_tls_zc_sendfile(struct rtattr *attr)
>   {
> -	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
> +	if (attr)
> +		out(" sendfile_ro");
>   }
>   
>   static void mptcp_subflow_info(struct rtattr *tb[])

