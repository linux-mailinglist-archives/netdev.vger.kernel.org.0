Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422256B237E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjCIL5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCIL5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:57:51 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B363DBB42;
        Thu,  9 Mar 2023 03:57:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JD+YnnSpUu8LA8cHQn4aiWdLNWILPhPt6lEge+0bqcXq55z0WgcHoQf7a5w+4KfyE3LxqWy4ZTR0WCd9QZqiNmxJwhpexQL6g20BE6fN+C0S18Qh0TvZ0P22RHP7FcpeC3LsQY7L6nfD7CJKFI4lgpm+pQjF7F4jvFxcqeDonExYTbv6iKTyZ+DlhFZLcGqRdsC22r+NcVdbuXrI86mRAH44x+6CoKP8udd/FxNhvHXVGdTwgvLe/SUYr8WszI8yp53znaRiULzTaJDJMGulO2E9QXts0FkuQ/tsblgj630BH3fjZYiJM1L+K1TYYgLgZWbY8Jmskcb3nXvyVCgCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04bPox/xIhxkB3vtOpq3EvyswZKqC13AL0IZnXqcRUc=;
 b=lKbl9oyenORS1waear6W/VuQxT9H0Wj+RTad0L+i47Bn6Yhmtnj23NDLRL9Q9wUxN2PXTsw8nuG4NyAWL9sBfruBxIGJ2u0EFD2Ju8qntcM/BwrkwQRlhVEdqwyqrpu1rnJ8oXJTe2uSK9huzy0539y36m5rw7bgr/F+xU2gAs4USi5yfiUNEG5yqmP5S1WTjpFO5V+wIpkZGRn37GVh/h7bDo6ZkaHg96Ir39p0jxtvSUyUbjlGo521QFEMiTn1MJyY5cucDn55xbCxbjacJ/YHdwIVkcyRHC9fX4hQ3JwCxUPAuv/JQEK9ZL5m7JADLLEYWr7QmvdONu0M8qoXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04bPox/xIhxkB3vtOpq3EvyswZKqC13AL0IZnXqcRUc=;
 b=e0IcHwwPV6OlrjFrK2mbc/dS9gcbMmpMEBqUQS95k0tl42TFvSbyKZv1bOJWelMeu6riVtgmfkoFEKHxvfrx8oEFAArAzvAJrdABDR+x+VCdjBBGT0R1LZFk96NzsdihlRTfhwzNcEkZm9NirlfXnEQR1VHu0tzEuj9omlBuVC+C5T5VWF5XOpDGt4gDLmii1feariy0sBx8lIrKS2/ZBlrKn1A+9zuXY+y2mgAjfOdp5oHitk29Wai13k2buQPGAoqkZQ00/ohdcUJHCOPr+p7ZmgFUbjHmh169j4RGgwy2JfWpcKpeIvJm5PQHafzK/B4Bo1CF9Fvm1rsF7rQN0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by DM4PR12MB6087.namprd12.prod.outlook.com (2603:10b6:8:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 11:57:47 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978%6]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 11:57:47 +0000
Message-ID: <6b7be975-c9e1-5833-9030-be87e713ecf5@nvidia.com>
Date:   Thu, 9 Mar 2023 19:57:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
To:     Simon Horman <simon.horman@corigine.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
 <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
 <7612377e-1dd0-1350-feb3-3a737710c261@intel.com>
 <3ed82f97-3f92-8f61-d297-8162aaf823c6@nvidia.com>
 <531bac44-23ba-d4f3-f350-8146b6fb063a@intel.com>
 <ZAjsa538mpnEQ/QI@corigine.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <ZAjsa538mpnEQ/QI@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|DM4PR12MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 301b35d8-31d3-4047-db72-08db20957fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3Kb3xhahX1deEqlD/CXeig7l9ACUZg5Rerz7te6Ws2EZJBjkJHHkPQXH6j0Dvt++nqzvhxIZEmz8n6TOxbSP1vd2FH27ynjp2n1oQcJzp7nO6QUz2ArDsqAoLjvoazGEW4kh1OFpma4m0IlLAu6tw0tCk/mbZR2rhlMKOCpMZUFIIuw4RwcV9F5zXWoT/LheG7Ym29C7vZegzc71JiYeeuZIZUkKBqitz6suAETIVa9hf5z3KkqvcoIGpchHBtpvQ5ZNsVTftOvFhPd0NcgMN4oi6+pLMbR5AuUDe3pY4O1e86l61fFmdDIaDELRJXlcX5TWVbkyW/6RvbgKskBaQxkcmxB8FxAAM49cRJ81Vq+JK86SuBu/MdbaFOg6LtyJBANeMv4MsPkeuA0DC54pGgkQzhsxvt+cPjF4YLqhPM/ndVWuJS5YiVRLMJjh49LG2ck460jfDpXC5sC5/pgBJbDUVOQNRixY9ahgdN7mTy2DZmS0sFluN3PAF15XuKKqSI5rI0NZZL4bmolDj3pdmKAPL7JTj1DYsyVlcJfweaF47OqD0JRdnkm2pKLfAJm4WO7vkI5TgOTjdbuPJ/Jh9cC/NssAfJ8BWXiAsFfeHPLiWeZdImpmyzcGQcLbMLwfBknUawW0rLclr3v26dY+lmt6lK8dsJNiIDhzFHn4gA1G9VPxOF6frlNp4KYJdXFDA110aJXglX7KNZe62P3bBb9prv32QAk3KMPbzJKhXkGqRgD87e2A8iJAtgHxDt3xUNSIVxYJK0Gp6owgeBFM6We3qL5wqiCjE8h75MNgfoN3CyWLFWWQMsc/QRJA38O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(966005)(186003)(6486002)(36756003)(31696002)(478600001)(110136005)(316002)(86362001)(38100700002)(31686004)(6506007)(26005)(6512007)(83380400001)(41300700001)(2616005)(53546011)(107886003)(6666004)(5660300002)(7416002)(66556008)(66946007)(66476007)(8936002)(4326008)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3VyZW9PTkN3aGxNWDA5U3lwaGRvVDBJUzFsOUp1NnlKK3MydHlBRCtXU0Ez?=
 =?utf-8?B?K3pQY3h6aE1pMVhheDJpU00xZUUxcEh6MHFKUVNVbkJJZU5yUmlCWDlRYmFt?=
 =?utf-8?B?YldsOFoxQXcvWjVNeUxuSndpL2xEdTZ6VlpLZElVY05pZlhhOW1hT1Q5UzQ4?=
 =?utf-8?B?alljdFFMWCtiM3pVa0NHUUtENDV6TXl1RGNodThNYWZGaFdQSGEyUkh3SEFN?=
 =?utf-8?B?YTNqcDYwNnRBVlp0WGdCVCsvbnU5S2lmbTVyeERaY1EvYk8wbWhiN05qTkov?=
 =?utf-8?B?Y2k3SlByazAyUEJhcTJjMTlOUWUrbU5VOGF4V1VjMWRST3poMUowYjZNZFhk?=
 =?utf-8?B?KzNZbmhNWHdzcjcxVUhHUGRkTWdDVGxTMmJ6OWcyOEs5VjhlYUI2NzVDckIy?=
 =?utf-8?B?UG9DZEJXOGk3ZWpxa0FNRVZFQzVhdWNhRW1WNDNNODVKMXovZ1A4SWZXOGxI?=
 =?utf-8?B?S1JSOFZVK3pEdXNiUGlkVWpRc05XcFBWVnNPMEU5S25VZm9mQ09aUEtkcFVm?=
 =?utf-8?B?UFJTK3o3UVJnNUkwS3k3bDJ6dWtUbVE5OHZTbFhxTEgzUUgzMC9XbUJvVjd5?=
 =?utf-8?B?cTR6Y1ZhYjUzTm05bzZQZi9lQzVTOWhDdldXazhzeFFpamFOVk9zU0xvb3Ri?=
 =?utf-8?B?OFpVeXd1L1Z2UkRmd0FhRUJTeDdqL0dZRGtYZ2xvVU4zYitJR0dMOUtGT2ww?=
 =?utf-8?B?eU1ueXErdGNqaGVqTW0zeHplQXU3WE9lZDNNd09XaCtJck8zMUIxZUI0UmJJ?=
 =?utf-8?B?aGpwMzVtT3Vka0YrZDlWc3ZtWit6bGRWOUVVaGdqNGZvdElzdnhWTDRnWjBn?=
 =?utf-8?B?ZzlZZ2ZQaERhL2VjRG1ac2hPaXFSRTd1QVdFZWEzWVp2V1JtQ09raVRzNjBh?=
 =?utf-8?B?VHRSWXNXUnEvOU5mbENia2hpY0tJR29obWJjRXpvR0dGTU90WlJZUHJlcHE2?=
 =?utf-8?B?eUdWTWk5MUMzRkl5c1J2dTRWZ05kcUwwbnByNVVzSUwrRjNyMHpYZlpKcTVG?=
 =?utf-8?B?QnhCQURNeTdFM1ZtY2NuNXM2VzZaeS83UnNYcDJYQWh2cmxIcGdxQkl0dXNJ?=
 =?utf-8?B?aVdwOGpqbTRYcVljanZqZkorSlR2Z3MveGszNGhxYmwrUE5SaHBXTEhBRFdB?=
 =?utf-8?B?MHJXeE1LYUx3MkQ4KzQ3VFNpdDhzSjlWck56TmlqUlpsNENxUDZwajRKUXNq?=
 =?utf-8?B?anU2VjlaeThHSVI2a1NpakhPK0g0cVQ3dUpFTUltZkxCdVBPRUsreUpPVndp?=
 =?utf-8?B?QVdHdjRVcHRhRTFqNHFkWGwwcTRQOHdIaktQVFFUdVFyK1AzTmc4UnNOQjd3?=
 =?utf-8?B?WWt2RzM0ZTFZcHJzZHlVNVhLbENiOGZOOVBqVisra2gzTDlnSTlpc0ppaDlq?=
 =?utf-8?B?MmRjVU14NlAydnoySUVyVkxWcEl5S1Z3cWZxMGIzUHJYNHVFTFJZYUZqUjVh?=
 =?utf-8?B?dlZoUmJIV2VGQVA2Q1QrYUFUbDg2UHR3ZS9lVjgzM2dPWml3WkNDZnFTU2Fs?=
 =?utf-8?B?cjBVQlZLZVRqODRyQVhRRjl4dDJHU3kxSTN6ZlpWbm1jR2UrSjhQM2lSODZr?=
 =?utf-8?B?MGQ2cUlva1QxdkROcE9ESWVidjBEcFdRNGlIUnpYd0FDUXlpVUh5dXZXditW?=
 =?utf-8?B?dTFnQ3loYU5LT21EYUZUMUovekZKV3dwVVFYYXU2WEJ4SzhIK0tHcjZITENr?=
 =?utf-8?B?UnZHVkxxQ0FYRjJCeGFuczV4UUhVTGt6QUh2WTlwNnJ6T0NES1NFMU5HSzJX?=
 =?utf-8?B?WjZSakpDTys1NGdLMklRRHhMazllN2pDakZzaTIrVk5UaXpNczRMemgxbld3?=
 =?utf-8?B?RjBWZU1jM3Jkdkw0VTgxTDBueXJncmxUN1lGYWJXVjdqU2lzOU15Q0ZBTVMy?=
 =?utf-8?B?VGhNQTZiNzN2NFNRWklxdHRtd1g5eGdzMVdGZjU2UzJ6aExKUzQ4MHFTa0Za?=
 =?utf-8?B?QURFVXRxM3VXNThWZ2NFclpLZkMycVFGS2NuQ0hDamlxZlc4VjFWM0o2Q2xP?=
 =?utf-8?B?dEN5WDZ5UjBWdHFrNThMRWdDRkhFQWEzVnlSVzJ2eFFKMDh0QW5FbVVwSWl2?=
 =?utf-8?B?ZVVkU0tjNUJuR24yeG5xTkhMT1lZYVRYeTJ2ZXRvNFkzTE9ZblluQmZtanht?=
 =?utf-8?Q?IladgqizwfDmbDpqDJIUSW85V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301b35d8-31d3-4047-db72-08db20957fac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 11:57:47.2151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9oISjMtPI8oo/NzGhD0+y1DuYNQkDZx3euRmls/qAZemfiQHZbBLVUPjKIaJj0IDCAoKO7KY3sagfDPvLqtXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6087
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/9/2023 4:13 AM, Simon Horman wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, Mar 08, 2023 at 02:34:28PM +0100, Alexander Lobakin wrote:
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Wed, 8 Mar 2023 10:22:36 +0800
>>
>>> On 3/8/2023 12:58 AM, Alexander Lobakin wrote:
>>>> External email: Use caution opening links or attachments
>>>>
>>>>
>>>> From: Gavin Li <gavinl@nvidia.com>
>>>> Date: Tue, 7 Mar 2023 17:19:35 +0800
>>>>
>>>>> On 3/6/2023 10:47 PM, Alexander Lobakin wrote:
>>>>>> External email: Use caution opening links or attachments
>>>>>>
>>>>>>
>>>>>> From: Gavin Li <gavinl@nvidia.com>
>>>>>> Date: Mon, 6 Mar 2023 05:02:58 +0200
>>>>>>
>>>>>>> Patch-1: Remove unused argument from functions.
>>>>>>> Patch-2: Expose helper function vxlan_build_gbp_hdr.
>>>>>>> Patch-3: Add helper function for encap_info_equal for tunnels with
>>>>>>> options.
>>>>>>> Patch-4: Add HW offloading support for TC flows with VxLAN GBP
>>>>>>> encap/decap
>>>>>>>            in mlx ethernet driver.
>>>>>>>
>>>>>>> Gavin Li (4):
>>>>>>>      vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
>>>>>>>        vxlan_build_gpe_hdr( )
>>>>>>> ---
>>>>>>> changelog:
>>>>>>> v2->v3
>>>>>>> - Addressed comments from Paolo Abeni
>>>>>>> - Add new patch
>>>>>>> ---
>>>>>>>      vxlan: Expose helper vxlan_build_gbp_hdr
>>>>>>> ---
>>>>>>> changelog:
>>>>>>> v1->v2
>>>>>>> - Addressed comments from Alexander Lobakin
>>>>>>> - Use const to annotate read-only the pointer parameter
>>>>>>> ---
>>>>>>>      net/mlx5e: Add helper for encap_info_equal for tunnels with
>>>>>>> options
>>>>>>> ---
>>>>>>> changelog:
>>>>>>> v3->v4
>>>>>>> - Addressed comments from Alexander Lobakin
>>>>>>> - Fix vertical alignment issue
>>>>>>> v1->v2
>>>>>>> - Addressed comments from Alexander Lobakin
>>>>>>> - Replace confusing pointer arithmetic with function call
>>>>>>> - Use boolean operator NOT to check if the function return value is
>>>>>>> not zero
>>>>>>> ---
>>>>>>>      net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
>>>>>>> ---
>>>>>>> changelog:
>>>>>>> v3->v4
>>>>>>> - Addressed comments from Simon Horman
>>>>>>> - Using cast in place instead of changing API
>>>>>> I don't remember me acking this. The last thing I said is that in order
>>>>>> to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
>>>>>> "Ack" and that was the last message in that thread.
>>>>>> Now this. Without me in CCs, so I noticed it accidentally.
>>>>>> ???
>>>>> Not asked by you but you said you were OK if I used cast-aways. So I did
>>>>> the
>>>>>
>>>>> change in V3 and reverted back to using cast-away in V4.
>>>> My last reply was[0]:
>>>>
>>>> "
>>>> You wouldn't need to W/A it each time in each driver, just do it once in
>>>> the inline itself.
>>>> I did it once in __skb_header_pointer()[0] to be able to pass data
>>>> pointer as const to optimize code a bit and point out explicitly that
>>>> the function doesn't modify the packet anyhow, don't see any reason to
>>>> not do the same here.
>>>> Or, as I said, you can use macros + __builtin_choose_expr() or _Generic.
>>>> container_of_const() uses the latter[1]. A __builtin_choose_expr()
>>>> variant could rely on the __same_type() macro to check whether the
>>>> pointer passed from the driver const or not.
>>>>
>>>> [...]
>>>>
>>>> [0]
>>>> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/skbuff.h#L3992
>>>> [1]
>>>> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/container_of.h#L33
>>>> "
>>>>
>>>> Where did I say here I'm fine with W/As in the drivers? I mentioned two
>>>> options: cast-away in THE GENERIC INLINE, not the driver, or, more
>>>> preferred, following the way of container_of_const().
>>>> Then your reply[1]:
>>>>
>>>> "ACK"
>>>>
>>>> What did you ack then if you picked neither of those 2 options?
>>> I had fixed it with "cast-away in THE GENERIC INLINE" in V3 and got
>>> comments and concern
>>>
>>> from Simon Horman. So, it was reverted.
>>>
>>> "But I really do wonder if this patch masks rather than fixes the
>>> problem."----From Simon.
>>>
>>> I thought you were OK to revert the changes based on the reply.
>> No I wasn't.
>> Yes, it masks, because you need to return either const or non-const
>> depending on the input pointer qualifier. container_of_const(), telling
>> this 4th time.
>>
>>>  From my understanding, the function always return a non-const pointer
>>> regardless the type of the
>>>
>>>   input one, which is slightly different from your examples.
>> See above.
>>
>>> Any comments, Simon?
>>>
>>> If both or you are OK with option #1, I'll follow.
> I'd like suggest moving on from the who said what aspect of this conversation.
> Clearly there has been some misunderstanding. Let's move on.
>
> Regarding the more technical topic of constness.
> Unless I am mistaken function in question looks like this:
>
> static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
> {
>       return info + 1;
> }
>
> My view is that if the input is const, the output should be const;
> conversely, if the output is non-const then the input should be non-const.
>
> It does seem to me that container_of_const has this property.
> And from that perspective may be the basis of a good solution.
>
> This is my opinion. I do understand that others may have different opinions.
ACK
