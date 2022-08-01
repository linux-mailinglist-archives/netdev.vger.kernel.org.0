Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A84586CBF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiHAOYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiHAOYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:24:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ACB2495A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlMKPYCirh/MGNlPubiI0dUBHW5UduV1Krq/AXe2AiNTKz8RYjLhdBwcqiV2uJ9f1MazUVyiP7DUKkcXrPNz9bi4Omob0HZpQqAScMfu463o8k+VEbe0FqUjhdmo9o6urPBcEB9llgrUnDPDlnYZNXpFhSwWbSCF2fLDOE5GeVRN1u1FNSdvByLtmMGL6CDVSbos44EsVzD677QnpjH7AN7wW1IhLkQaGar5JhMgnTrGK9Nriysn42N3YY1IHKi44DG/KN3nldIB5gTINWsNNYiuZPLR5/lWQKVLBBvzURRI/TwXoYZDEm22ix3V1SyhIV9VaUfNV1/7wmEpJZ0dRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpOE//Po4IYd9zbqI1SCvRNdf6o0ayV1AI6qiTiZYpw=;
 b=fNq4XGSVAQnVh7ED5apUK58Gh84b0bUHuhIsnrXqKzhzxxIiWNx08CTHtZaerX5OcTNAmStvoEoYBajZGbFjhhUH9gT/H3r/E4iWzFC5N3sE1OY9wOTTAc1DpqH7g3DMRkG+qW7R9lulVoKDvitY+hRm32iU+1xtCEwOW3SSbYtKqb6DUyATO1nrWbKn+mUPt6YSUoZMK1/pimpXXVgtIqjIRc7tVqBOCiWAMnezEdazGrf1EAYRCpFF5x6+hdDyo11Nu/WwMeQ0ijiTlR8nsOgF1YuewmwZPv8nokCEzK0PxTqcDDiH8WK2PfzAPImIWpSSva0bLE70Ia+t4lCIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpOE//Po4IYd9zbqI1SCvRNdf6o0ayV1AI6qiTiZYpw=;
 b=Ixt2Fj1pVizLDagjw0zjF6b296g4mibGReRQsLvJjf4joC6Wkh51mTJ2sfDDQ7C2wY/JLWj42S60jDZWdrc5T6aS+4E3kUfmcP9vyvDR5VkiC2TrV1ny8WHg0XHiZqUo0h8PhLkWelmzJkQPfaQ2TXhABt5H2r8plulCCCxO40VmyoLqLpY1TEUbJUbdlfKO9WUkEOXFBhUkoA+FgHcTdm7mQ+eb3hM5566k2u0A1nbpmE6Ej5sFNP8hMtk2LkFwJWdld3bAlws7xlOIvIcOWLaZpZkLSA01ewDyLlLt1OGVxVlgbuBOUbBLPhNmViWHq/FVNUA3DrhNAwREZQ+Kvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM6PR12MB4201.namprd12.prod.outlook.com (2603:10b6:5:216::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 14:24:28 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::4188:7cf7:c52:de5d]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::4188:7cf7:c52:de5d%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:24:28 +0000
Message-ID: <d563ce0f-4bfb-3f8f-4ddf-f23ff2403895@nvidia.com>
Date:   Mon, 1 Aug 2022 17:24:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <horms@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
References: <20220728205728.143074-1-saeed@kernel.org>
 <20220728205728.143074-7-saeed@kernel.org>
 <20220728221852.432ff5a7@kernel.org> <YuN6v+L7LQNQdbQf@corigine.com>
 <YuQP+cBUkyR1V1GT@vergenet.net> <20220729195844.23285f4d@kernel.org>
 <DM5PR1301MB21728958DED2FF52C2FF9496E7989@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <DM5PR1301MB21728958DED2FF52C2FF9496E7989@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::29) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12caa362-21f2-4ad4-21f9-08da73c98a9d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4201:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Na8IdY34FWNxRM/dC65rB4QFsLc2ubcYWM1SdrdvLVb9aIPGeleUa/oRewRMqdk144MzmRnn5cucd9M5WK4cq7Vj21u7V6oj4XZUZV3oQQr3ljy9gBPwiyrbOayBRYDiMWzH8lXCXH38eXr9DbP18Swrn/3KpeKpvQJtk626xPAqyHZ3bSBwt0xa+EVNY4t0gVuWWlDblH0W/ESFA8cvQYEP345jPDtGg7l/mgJ9HPtzh4i4Ry8mJQyo2rqz6DrqBrzIluXyW7lyfOs6PR9yZ8/pXnwwM2D/q1Afc0h1k6KuH/8K0MBhGNe+0SuOSUVhXHizj1zNZQb73smBhoeYKedS/6SJ3XImg6rlXIR/UpA/JHe0/vTQ+FRmpF+b/d11DiHU2iLPNwA3HshOlA6mBCPawIhaY/u3ivOu4ekyFVmoqkADS3kc6sP6B3onThYjj6pFw5s62MrPfp/TX2S8th7hZHZaC1vgWoiPPJeYJY9iOFTC1ubv7zGg806ImERbC4BcoXBR0j0ZaTpGGjsYVFkIF7ASZsRb0s3Exz6B59uvdsZegoOW1C5q9z4ifpuICT/9lrIcMnh9Ongx8Dnul3zyAcvojg1DdLlUSG76stN0Ldv9RFlRDs3Nss0KaHBntS/UVTl7Y8QOcA4KqgLG5wHYIwdloDUHAWKLvbPl+IMrC6rtNF8miUKss390bD3Z6OjhLAPnQJUjaAKt+rXAuuh5BUWc1REL1zXj5RTR59fejk7jPvP3g4Xw3QZPzWdCdw2UYqFCARrKSyUsdNcfy613MgvJ2UDK9xDCYLTMG2W2xhqTtOJZ4dUj+rVbXEGHrIvT+HMZqWG7yt1dYUi6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(6666004)(107886003)(41300700001)(2616005)(8936002)(5660300002)(186003)(26005)(6486002)(6512007)(478600001)(4326008)(8676002)(2906002)(66946007)(66556008)(31696002)(6506007)(86362001)(53546011)(66476007)(110136005)(54906003)(31686004)(38100700002)(316002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE95T2RYMFZUeUlJT2txODkrUldKS3pLMjg2alJYV04zbnNVV21RbUM1ZjRU?=
 =?utf-8?B?anl0Tzl2N3QyY2tCL2NQVWtKT3ppQzFuZEwrRGtsTHFMNGlLdlkxSTRuNGZl?=
 =?utf-8?B?QXE0alRVYUJiekcwelpGNndVaDd6cTVwTUk3VE1JZmwxMnErTTI5UTRuZnpL?=
 =?utf-8?B?RVlXaCtHdXZ1Ym9Ca3dUTDhsTXlGYVFkVTJxWFR0dHlNWk9hWlUvK0NmY0VZ?=
 =?utf-8?B?MnV3dkdPT3RsVVJxWkk1b0VHTjY5NjE1dUlDK2lHdDRMUC9UNmg0YU1rL0hC?=
 =?utf-8?B?bkVpWHRrcFcyUy9GbVorRXc5ZGRoaUs1YnFOM1ppTkZISDJQU3ArbTFaejdq?=
 =?utf-8?B?RTlVd1UzaU9PR0xPNngzdXhzcUxaOE44emtjaVZrMFFocWladCtUOXQ4bXg5?=
 =?utf-8?B?UXc3b0EzZnFEUUJDM0VOWkpzQVN0SnRIYmFOQjBMZGJ0d0x3N3VTdzR6elho?=
 =?utf-8?B?NnF0WnhPekNoNzNmWmcwcWhWdm51YlppeXYxNmdTdkFTdW80WUhQTWJndHBU?=
 =?utf-8?B?K1pJZTYvQlBNbTJ4OG1ibjhUTkpZak1hMEgxM0YvbjA1UjBKWDdnWTV5bVVG?=
 =?utf-8?B?M0xtbk0yaTRZdGVBVzJzb0RMb1B6UXFQelFSd0lwTDdlSERTdzg0Ulh1ZkEy?=
 =?utf-8?B?M2pwMGNsbkt4TlFSNENkZXFDRTJnQ0VodTZjd0ZaaUlVQW1Qb3FGZHp0N21P?=
 =?utf-8?B?VGJuWkllL2lWTUFDOEZCeExtM3B3bTg4VitXa3daendHTXlLTnNXUi9jaWFP?=
 =?utf-8?B?MExUS1IxbFVaTHI3QnJ2UmRlNXl1SnV6V1NPdDYvRGZ3VUxvQ3QvcVcyT2VD?=
 =?utf-8?B?T3hVODBhaFpNNEw1bWVrUkhYSTNTZEpKOUpMTEhuYUVES1VYNTFlWnFyTk9k?=
 =?utf-8?B?eEF2cVowK2dDQ0g2QXhGdWUzY2RtQlQ5eUNYUEM0T2xXZElCSkpTNDY4ay8x?=
 =?utf-8?B?UjE2UVVsUW9tajQ4b3NQSEJXLzd3Q09oUTFBb2h1anlpYjdUUXBJR0tERWNV?=
 =?utf-8?B?czFMT3BQSU0wYXkvM2RmQk00TmZHcmVZVFliNnlLeGdFeDJNNEs3blhsZnhB?=
 =?utf-8?B?WXhEejVITE56Z3hndVd6YVZNNFFONnZPeVVxK3lWRnBGYmxJVTI4dTk1SElm?=
 =?utf-8?B?QVgrbS8rZW1HMmJDalZyMUlXRHZVK1RvMFdQUXg3VFNPdlg4VkpJdGtlVVZ6?=
 =?utf-8?B?OFJITnRoS0JpMEJYTkR1a1E3b0F2TWVJUEIxODBNYzhsM3JPYlVlV2MrZitn?=
 =?utf-8?B?UmRVdXB2RlY3dnBwaVI4NjVVZXNYQlBkZ21TY29wUWVsWWkzd1BMUkhzMXk3?=
 =?utf-8?B?aERvZTFUWGd6cmgrSlp0U1VaMzFLQkF2b1AwdjlNeExtd0FFWEh4M0F5azNT?=
 =?utf-8?B?MHVPSndqbkZRanBCL1ViWHB5VHdTa2J5a01PeXJRN3FOMHozVUlRWVNDVU4w?=
 =?utf-8?B?amVSQkwxaTdSSUorVWFoTzBiT3JhRzdpWWx4RjdKRitsT21MVUZLQ1lMY09w?=
 =?utf-8?B?YkU5Yi9UMFBla3IwVFlKbzBoTENDZjA4NVNmVDlmcmxtLy84YmVYbmxQYkFn?=
 =?utf-8?B?MUtYNG9ZaEZPSHRGYzZBVWlGb2Y3QXJHN0EraXJsUGdBZjNOZE84YlZxODhP?=
 =?utf-8?B?TDRIcE1hdGVyOE9RSmtDSXN6ZVZ3MTJlQVVFRWgzaWJnU0xDTk1qU1dNcXVM?=
 =?utf-8?B?blJVait2RWxURnpGUUdWRzIzcTdZZk5oajZ1YjVCdFVGMmRVK1R2RHJPZXRW?=
 =?utf-8?B?eWFwbWFqZC9XVE5kMXNUYnpNd0huK2ZVVEZVMkd2YzVKSlBqS3FvaTBxSmVi?=
 =?utf-8?B?dDZBS3NwZzFEY3ZnV0dXVGdDNHpYSWN2bkp0Vnc0MXdVWWpSTUpRZzBRemNi?=
 =?utf-8?B?dTlrVjRWdDEvbzVUbTFQZ2M4STBtc1VKOE1pTzJ6dGNIQUliei8zdlRWVGE0?=
 =?utf-8?B?d1h3enA0TUovdE81RS82RUtTUGRHL2VOMWVHYk1aZzBuOFJIbW1OVTd0OWpL?=
 =?utf-8?B?am05U055SzkxZVp5MFpsSmRPa05tZ1MwQnZGdGNQTFY1V1h3WERoNXlaV0pE?=
 =?utf-8?B?VzhGMVI4Z1d3dE9QWkhNMjNpMU1HY3p3THZrczhUVFNidDY5MXdYRU5GRFFl?=
 =?utf-8?Q?+Yl157fjHr/Xd4MBLprt4VcGg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12caa362-21f2-4ad4-21f9-08da73c98a9d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:24:28.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWkE/qbQ1jOXuTEosFGfP7ZFggXPCEevwee59HXTn8QPXc18wwRyYBPa9WPB2Er1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4201
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-07-30 7:58 AM, Baowen Zheng wrote:
>> Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
>>
>> On Fri, 29 Jul 2022 17:51:05 +0100 Simon Horman wrote:
>>> my reading of things is that the handling of offload of police (meter)
>>> actions in flower rules by the mlx5 driver is such that it can handle
>>> offloading actions by index - actions that it would now be possible to
>>> add to hardware with this patch in place.
>>>
>>> My reasoning assumes that mlx5e_tc_add_flow_meter() is called to
>>> offload police (meter) actions in flower rules. And that it calls
>>> mlx5e_tc_meter_get(), which can find actions based on an index.
>>>
>>> I could, however, be mistaken as I have so much knowledge of the mlx5
>>> driver. And rather than dive deeper I wanted to respond as above - I
>>> am mindful of the point we are in the development cycle.
>>>
>>> I would be happy to dive deeper into this as a mater of priority if
>>> desired.
>>
>> Thank you! No very deep dives necessary from my perspective, just wanted for
>> the authors of the action offload API to look over.
> Hi Jakub, thanks for noticing us about this change, for this patch, it seems good to me.
> I just have a tiny doubt, since Nvida just add a validation for a police offload, why it is not applied to this meter offload patch?
> Since I do not know much details about Nvdia meter implement, I guess not all the police action result is supported, so maybe validation is necessary.
> 
> Thanks

hi,

as Simon already mentioned. offloading action meter is done in
mlx5e_tc_add_flow_meter() and adding a tc rule with meter will use
mlx5e_tc_meter_get() to find the existing meter by index if exists.

as for Baowen Zhang comment. you are right. it seems I missed a
validation part. since its merged I will send a fix commit.

thanks
