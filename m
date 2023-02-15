Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A127697491
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 03:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjBOCyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 21:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOCyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 21:54:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18F2B639;
        Tue, 14 Feb 2023 18:54:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYnx8GUILYv8NXxD6+T8BSFt8B3fSCAfnLtGs9VI7ywEwISlZj/5lnRijElaNytzkcHfH6XTDS7jCnJfYzcRROUQBXU7PKWQvi8n9q56Q813eGTwNPBuVyNVgVPQJ7JkwWTTQ23j/HfcQSEzwv+gnD6nX80RYHC8mZEFgnj2fADTb7ReOCfRdX2/selNO+eDq6gWaTZnnL3l2g4fO/e9PfNcAkbtucsZFoPjIN6QCiEySoTOWw7DAYbcungnqDE0NoYTbGgF6vzIkcvy9xt2fBpN6mzznUS85bdVwVyT6xVH6z6XWZb5j72Txl/pOuXKShmNXTtcKYH5LsMAEWI32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFmlyooioUDv+qr+R5v2aoOvw3x4FV2mFfpCUXdDXbM=;
 b=iUqn+SfcLhaT06Pi3hXdIYj/wwUQzpwtcvEcQybzyN1/8Ae24uAALmG/D7/GP7O4BiVHPtDyqA4FHzJ8CP2T4YY1YwFBLehRW4M7hhG0q399lrewaKRyg+I3i4yIn3WI3QBfQjNEv2362wUO7SS1ks9xlcN5EbhTusE+JLcASqRgcf5klwIKyHbTFSeoCoNC2lKXO7Jm1TqIwJ4/SMTzW3wo/IBWwDrkOd8TGpqIYZVDkTVxFJGjUS5+JiY1XNDip+nWsWgmebMNrurzBWO6X1OFQ9zA4A//UoLi/awQFXp5xXwCjZyfXxqOSX7G1xLsWnb2aLQfASC4xhFrvTSEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFmlyooioUDv+qr+R5v2aoOvw3x4FV2mFfpCUXdDXbM=;
 b=ESDZGBq1cm5l9DspbJnnM+pwuStn+Izck03eOIicZqOBUk6AMv+GmNyh94/WwtpmBOHAXWX9SHaEvaqhBBmacBG/DGDmfv8CztLod6L90uvgDC4P/mgFFxAMaOdL+qU4qmx39s97wLJOKNCCFAP2lWTjTfn0Ha1KoQRs1J9+d+tqQ3+r5/3oNQNWxZUSx3XbZ6MRgjewl7prUYTKliZzlJiTTDSgbILhyPsKj26CSvuuqrChGcualR85XhJSt8VloSB/MIjOo3cFHXlxgPyWIU2Io+KYGkGl0UJdySkjsfbHg5kQGzjY/cQrGPkzvWDvALzr4siI3WSTg/mxLIDZSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3840.namprd12.prod.outlook.com (2603:10b6:208:16f::23)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 02:54:30 +0000
Received: from MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a]) by MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 02:54:30 +0000
Message-ID: <40a616a5-f350-2ac1-eda1-7e4c777ed487@nvidia.com>
Date:   Wed, 15 Feb 2023 10:54:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 2/3] net/mlx5e: Add helper for
 encap_info_equal for tunnels with options
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-3-gavinl@nvidia.com>
 <611a9a70-0f6e-cba5-dcb3-3412e6e9956f@intel.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <611a9a70-0f6e-cba5-dcb3-3412e6e9956f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0017.apcprd03.prod.outlook.com
 (2603:1096:802:18::29) To MN2PR12MB3840.namprd12.prod.outlook.com
 (2603:10b6:208:16f::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3840:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: b8807680-717a-408b-f8e4-08db0efff566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJQG18e9sLIM5phiRpkyY9OYtVNAwAxhh5DNstTpu+SmBU15swtcwL5Ad4+rbrsFGeZtyqpU3vK4f9u9qrjxGgv2xaViVbdrZVzK42EoM/UD188QqB2ZndhmdtPt4E7ydIRxpAOpZH1p/B9LFnrk2zPomggod3IZUlfyRmeQSfplF204PLGykGztfdRcShMRJebAOZwNJUNmpQeoUfsNrBqNcOX8DP8qGszEGmtkQsWT4adaZsBg7T+JbGzZ75Ly1+pFTdsLbXBH96qxTkzkgWrtt5MDUsHu6qvHJcZvEPmphANSuNQZztFkxYkzQWLI7LQNpi0AETPvmweKTd06aDUtBWLsIUUkXnjrHmOzAWHd/4iA5Ailk4oR+vjIqgyubf/6hlOZpeXKsgH3akRumBb/PbKADaYSK3VYksjuRSz5LGNT1GSuaT0G2xTVUnQwPkhq3SVYUoFqa1oW6kQu+0aRjLfDZtLWXp8IPHEDH5AG+VYte7Zfi4hsjvbMbKrpOIyAOgXJL7qAH48TNnvbZ+gmRlgleo0zCk+ih2Sf0VJVwhrNEAdwD4aEtqwCmorJ56DiZBrW3ayagn40RAfptrLlzSpdlcxlLIYd9RdosncwxaITCkPfBD6ivlvcQindMSesS2mN1QmbzMygJ58AWqefd6hDk8a5ASRAV48pn7HTbmrimwB2my6qrYW98WWRxrimS9k4LF7KhM9fCxs8lfoEHzNau5TDE/K1HZcsfmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3840.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199018)(26005)(186003)(6506007)(6512007)(53546011)(2616005)(66946007)(4326008)(41300700001)(66476007)(8676002)(86362001)(66556008)(6916009)(31696002)(5660300002)(8936002)(2906002)(38100700002)(478600001)(6486002)(107886003)(6666004)(36756003)(316002)(54906003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3JtSWRnVGs3MWhaaW5WUVNyQ2FEa09TRWVETkROempsTE5HcW13VjY2R1c5?=
 =?utf-8?B?VS8xRTArRFZ3OWI5UFlUdWxOaGt6UlJLMjN2ekhZbzd0QjJUUjVqbWc2czdZ?=
 =?utf-8?B?Q293RXlKNUZLMldSTjhJaml0UGNxMmdYSGpwUXVibjQ4QStMT2JUVlF2UmN4?=
 =?utf-8?B?SlRBbmFsekl4SHNOQjZWWXN3YWVnQU1MQlhDZlFRZ3d0VnBxRkxNS3ZkZW90?=
 =?utf-8?B?R1dvVk9hcTN6anprVWNRTmdTcFJBUDB6WXd3WEtHNFRPL3lCTlQ4aUhvM2Y1?=
 =?utf-8?B?bXAzVHZOWDFFN3dJZTJESDFNb2N2TDNVajNXUTBxbk5QNDVUTlh6NmVEM0du?=
 =?utf-8?B?QURCcTVsc2MzdlRzajd1cHVSemQ3WlpVM0dZMGVUME5Bdy8xeS9LOHQzTVQ3?=
 =?utf-8?B?TDVLV3RObGxwZytUTHlnRTlrWDYyRStIc2NyV1cvSS9ZM0x0U2RQYWozamVx?=
 =?utf-8?B?Y3MvcTkyOE5HbEd0ZUxRU2MvaDZZMXhGMTlEem5KQllsNnU0R216MWJBeWh0?=
 =?utf-8?B?OThQZnpQOXNKN3NXT2VEcFhuTXdxY2d4cDFJc0s2UG8rdmJ4NEN2ZUlMS0lW?=
 =?utf-8?B?RENuSUFDbVBVckU0Y1ZUYkFIZHZxd3YxYVl1NU5oQ1pBZjExWXM5RmFpM21r?=
 =?utf-8?B?UUs5dUtxcEFrRjJXb1Uwbit3eGNOK3NsakVEb2RoUHA2cW44VnFGRVlwWFNt?=
 =?utf-8?B?L1lFM0xYb0UvSFNWd1FHdklJRVhSa0xDejZsL2hoUUxxYkVYVjdWQ0U5YmxG?=
 =?utf-8?B?dS96WjVOTXoraVBBWTNBRVlUcFh3MHMxQi80Ty9xaktSditWQzczaGhjWTFp?=
 =?utf-8?B?M3ZiSVREZ3pWRkF6clZuSWNCL0VZaWkxQytJVHRRWnFkOFBsOFh4Q2wxMUh0?=
 =?utf-8?B?bk5kelFyay9ueEY3RGpJbE9FM28xNHBmZ0YzOGVVSmYyRlZET0s1REc1bHBM?=
 =?utf-8?B?QWVrcGFRemx1Ui90QU9MdlhPS0l0cDUyUkFBRkVlRVRMRDBsZDBEbDJmMTFj?=
 =?utf-8?B?eUROeW10MEt4WGV5NytVaCtXREpZMk1yRjRFS21tY1R5TzNRNTBPc0prY2ZN?=
 =?utf-8?B?Y1hMRzM3dE9QZXRZdENhamg4dmhGTTlicHZMOUUrSFBWcmJKOCsyOWtJY3dw?=
 =?utf-8?B?NGdTL0JDVjRpcjR1eFFpc2FRVHlsN0dOM1NOTlNGVDBMZGhzVTBta244azFq?=
 =?utf-8?B?TVlBdFFrOHhtSkNzN2UxRzlsc2x4eFpTTzVjU243TTJJOUlzdUl2eEV2OXdJ?=
 =?utf-8?B?QkY1WHU2RXpmOXI1ZmRiQU9kdk9vK25qU0tRNVZGemVrR3lWT0JNYlhEZGFL?=
 =?utf-8?B?MmxJSk1PQ09Nd2JTeHFqaWd6eTMvR0dGMjRFVk5idnh2cHVSTEJUeEk3aW1n?=
 =?utf-8?B?ZGg3ekV5NHlzWUtWNEJGTnRaRDdwQTZiN2FLVXE4MENYVHVzUHFwM1lHVUlx?=
 =?utf-8?B?ek5DUUlObnVLMGJBZUlsdCs5NzFiYUtNVUFOTXBIeG9jcDA1Ui9mQ1NhR092?=
 =?utf-8?B?UEpMM0Vha0lwU3owQjNVcG1EUTJBeGxNbjg0UWs0TDFIODczR2RMUmozYjNN?=
 =?utf-8?B?RHBheVZNUnFSeWVnTjhYR2FlSEhad0hRZjFoalRBQUxQTUljb0ViMDZiSG9D?=
 =?utf-8?B?anQyQ3RwR2x0NmNzd0h5clpMbWpjWHBhOUtwWWkyaHJFRDZHeVM0SWNkS1dW?=
 =?utf-8?B?SzNNZUdPRVI0UHN1RXdFL1NpTktCUEtpQmY4SThDSFREUDczNUNKOVBXeXRC?=
 =?utf-8?B?R0M5dWZDMWxaYXE5UHFUa2xFZVdqVFV2Zlh4Z2V6NmZEQlRWRVB5OG9mT1dV?=
 =?utf-8?B?NDQxc2syeXQ2NmFGVktxcHg5dy9YdjVQcys4TFdHOEdDaWdhL2pXRW1Qb1dp?=
 =?utf-8?B?UnZNZXIzbExqRUR3eGk2QXc1QVdiSEpIQ2RBTE1pbHpHMHNWc2E1OXFjYkE5?=
 =?utf-8?B?MlNzZnhJaER0eHdsNkdHQjlic1lLZnUwUDZlMGFSVGhHN21Ub2tVYTZYSGwz?=
 =?utf-8?B?bDVMZWovN0YxSUZSMW1ld09WUHJzT0RySlZPRWNWamtuZXlpTldZN1pIRGNU?=
 =?utf-8?B?N2g2Rko3NSs3aVhkeWJEakFsU3dMalZXNk9SQ3lNbkE0dzB1bHF4ZnkrbmEr?=
 =?utf-8?Q?SSbb1Tk0HnPv4RxnHsMerBMQu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8807680-717a-408b-f8e4-08db0efff566
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3840.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 02:54:30.3266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzm5KZV6JnSVpN6fcHEjA9WNOTTB5DyghmC5/ipAqFERuh7PqcAO+OtMf0SG85RLCbfT0KR1l88Wz6GKI3rosQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/14/2023 11:01 PM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Tue, 14 Feb 2023 15:41:36 +0200
>
> (dropping non-existent nikolay@nvidia.com)
>
>> For tunnels with options, eg, geneve and vxlan with gbp, they share the
>> same way to compare the headers and options. Extract the code as a common
>> function for them
>>
>> Change-Id: I3ea697293c8d5d66c0c20080dbde88f60bcbd62f
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> [...]
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
>> index 780224fd67a1..4df9d27a63ad 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
>> @@ -571,6 +571,35 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
>>                a->tc_tunnel->tunnel_type == b->tc_tunnel->tunnel_type;
>>   }
>>
>> +bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
>> +                                        struct mlx5e_encap_key *b,
>> +                                        __be16 tun_flags)
>> +{
>> +     struct ip_tunnel_info *a_info;
>> +     struct ip_tunnel_info *b_info;
>> +     bool a_has_opts, b_has_opts;
>> +
>> +     if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
>> +             return false;
>> +
>> +     a_has_opts = !!(a->ip_tun_key->tun_flags & tun_flags);
>> +     b_has_opts = !!(b->ip_tun_key->tun_flags & tun_flags);
>> +
>> +     /* keys are equal when both don't have any options attached */
>> +     if (!a_has_opts && !b_has_opts)
>> +             return true;
>> +
>> +     if (a_has_opts != b_has_opts)
>> +             return false;
>> +
>> +     /* options stored in memory next to ip_tunnel_info struct */
>> +     a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
>> +     b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
>> +
>> +     return a_info->options_len == b_info->options_len &&
>> +             memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
> 1. memcmp() is not aligned to the first expr (off-by-one to the right).
Options start from "info + 1", see ip_tunnel_info_opts and will use it 
here to replace the "info+1".
> 2. `!expr` is preferred over `expr == 0`.
ACK
>
>> +}
>> +
>>   static int cmp_decap_info(struct mlx5e_decap_key *a,
>>                          struct mlx5e_decap_key *b)
>>   {
> [...]
>
> Thanks,
> Olek
