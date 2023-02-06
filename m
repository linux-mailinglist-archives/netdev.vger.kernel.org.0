Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CE468C469
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBFRRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBFRRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:17:10 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E124910A9A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:17:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNfjJIRiLP8BmM8PM2cy1aSxYwokx09stm4+FGxvKhpK1KQD+rqHLzRLrbw0vX7642qN7mJvvDcfpaJnELtb4ekgkc0mdccfEoGa8X/60XYvbKNGn/SsRPw1irX9E/PoWA0s3tN8bThWWENe7iLvMA105hxTaNJW7qSsaFxSlh3aIP4IopQL5JwsUMzpIdogrcdawKNECuJMnkvXChYWjKiwucKxPOMp09TsX6ae792anIfT0VSwhcl4aBKN0N70Ve5FQ127BKBXEpVAIRhOLAFfdDTBModWgwAVOzfcv0ej6bq+1fyMvxNv8d0djwvXlnweNZkrohIXJTqSKXoJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwTlz1KM2+8fF8r+zEr42JeyV5qllaKsJ0HFlm9U8yA=;
 b=CO6YyDIZT9PV6EsyRAYJRBQEX+dic6gnEDNLg85CSkChyobJ/7iW23juUpShWurSx1QLXCP6tp4yTcNMj0RbFF9nxP7cSLiZ9kwrMzI5wPL8g3VsuqJmBDTsfNiVvMQUbzQHGGUrblDYJgm/yAc0YakHtT/3QQEK8pz8q7GJB5EII+bCLoQdo59OxrYMj4S3AC48Sdt+coPM9kIvKPW2Ke5fugxuw1X7mu4JUOn7fK24D9O7KetFk3ONPd2wmE6cXn5XHePjsRbU1ur8p4tU4P4EJo7mnu7KLpBEh6zJbAOyDveDAC+O5IxE4CBwmHxoPTto+lGFIFbwr9ea/4XCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwTlz1KM2+8fF8r+zEr42JeyV5qllaKsJ0HFlm9U8yA=;
 b=kJ3vERsYk2938+ch6GJK7ajaIyArI0czLlyh9o+AxKNX5CKLaPqd+JOtGCFkE1/5b4WG89LnxIMfgjID4ZZJLakc/HSgsKwn9FSQ3JrW7RAB1Rjub1tOXR2Mj6G+owcf3aQCz0g1RWgsTojiDkxrcttTZKRJqI53fspqInxffpINMuhyY/KlRpZwXtsTUudOjnQ6r/QXEjqBbmjA6GZt6B0qfGPxTGgFAeTyvBdSIP9+MmcV7GVDOb3DwXhdNkYgo0eSdxO+4yTPoTm0rcvR55qWdVPlS8fs/ir8sKx0YVj14OXOqTWnJTr0CYkmS8Z+fjay+tAZ5XiAnyfAVQ6NmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SN7PR12MB6713.namprd12.prod.outlook.com (2603:10b6:806:273::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:17:05 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6064.027; Mon, 6 Feb 2023
 17:17:05 +0000
Message-ID: <51691c67-33e4-01f0-c968-00c57c4dd86f@nvidia.com>
Date:   Mon, 6 Feb 2023 19:16:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v8 4/7] net/mlx5: Kconfig: Make tc offload depend
 on tc skb extension
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
 <20230205154934.22040-5-paulb@nvidia.com>
 <86b7936aa6c306c61a782950c762fe3124229c51.camel@gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <86b7936aa6c306c61a782950c762fe3124229c51.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::28) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|SN7PR12MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fdd8a60-5f94-46fa-50c3-08db0865f7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fy0kUW2pkyBNJhvWQQI0mtBf8937Uj5NU2UbNsQsVO2BH0Dq/41VNfS2rDm4bPg0DhybW4lK8mHvYT9lcnVvAO6+YuPQh9EKsOCSRW73EQqbS0Z8dfhTlIpSPQ8xDuXXYacJhPI0b/cz0akf4Ec94YfMJfSfCeAxMDckuhkNyl7UYQCxwCz42XJIQEMrgMiuP308s4BxdBOvHc5amFEMR7Re++8yd1nXeI7sVwCP7Mi9QLJ4x3Ay/7ssamm50Vb3H6qSIlQkXZ4PA0a6BHvSY3RFTOQcv1UOJ7D02/6HY9A71XycBUXHM449xgaIBVmjV1IjqnMYiw9/Pg/g0GAE3JlrsVhBX5+ZdAlI/7SJiZ6PP4gHaSCHLTM5bVJc49Dva5R8dQSSu5lIKt5l2TNC1CCbi4dz239fmyipa2Y7HDfw2UgAZ5wD5JVMEdLYD5jN+rQafeCeKO1kVw9oXebfLTNggXCwx9VqgMNLuBDGEePF5tU9ZLVIaL7D/Fn43FkEkMMvrS4oCbq1wlIqFuFwckmcxx7HrUl1DeD457SuS0nnwpLwW9O2UOOE4SWzQOLp0IASbNyJrZQYPxDWBxGSAlJkLjyUCcv/IEyaA1bYcFOBB3H9+reg6/vGp9PsmUXtuTYkZxNSL39MDBFvdnnJSqUwJbGo3t667S6T33fLnfCVTT3j1q0GOLO2yETVs990KOomC7amyRy75Pl6BkKDHalcPbBgLYnbiHtMUqsCix4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(8936002)(4326008)(6512007)(8676002)(26005)(31686004)(41300700001)(4744005)(66946007)(66476007)(66556008)(186003)(5660300002)(6506007)(2906002)(53546011)(478600001)(6486002)(83380400001)(107886003)(54906003)(110136005)(36756003)(31696002)(86362001)(316002)(6666004)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmhTNi9kUk5NcHZud05KZ0d2bHBnditwT0VIVkFVcUlqM05DSm00a0VKUU9C?=
 =?utf-8?B?RGYrZzdrQzQ0eHlocWkzRGVLR2w4UEk1S0R2ZVNjeTVlQVhHcVdwMUpMWmlT?=
 =?utf-8?B?SnJsai9SblhtQWp5YzRDRDBhRkVSN20xQ2V2bm54aHE0Tk0yNUg2UkQvdHpt?=
 =?utf-8?B?bU9QL3VucXdKZWU3VWVXbHZwNWx3KzVJcHlYZm5DZFlnaXJxbFk5UjFrZTN0?=
 =?utf-8?B?akhYUFlrdGszSFRkMmJWWWlXRjJ5Q1VtYWJWWUxMNDBZNTNRTXQxOTlMZ1Zp?=
 =?utf-8?B?U0dudnJiYUZQcEQ2RHNFbWZyOUdtRkZhV1p6U2VvK1l4N3Q5R0hvb1BhU0NL?=
 =?utf-8?B?amNieUtyWlNVTUl3T0RqZnUrMEhueXZsbHg3MnRBUlIybWw1VWVGOVQyQlJJ?=
 =?utf-8?B?WEpuZk9DeHMrSzRScGZHNklyVWcyd0Y0b0x3cENFaDZrais4SmJ2bWJwbitO?=
 =?utf-8?B?Y2wzSDBBc0IwQ0VDRTdhVHEzQnU1VmlZVUF3T1FNWEQ5cG0zMm9SUjJkRUUz?=
 =?utf-8?B?UStpYTlqa0FPeDVFZDhxTEsrZ2hOYitTMlRtdXZzOXl5NlRQbXRhZW5BSjJo?=
 =?utf-8?B?L2VMbG9BeHcvT2RoSTdMVGppMGhJVXNBUERPaG8yWGc0L1Y5UFZWbTV6ZmJ5?=
 =?utf-8?B?SC9KNmVEdTk2L1ljbjlNUmpkK2hZUFlmbmF0aGs4VCt3MkM2UW5sWFlaQVdW?=
 =?utf-8?B?UFBWOHFVbndEcTRwZExxV1BpUm5QZjJTVHB1SGxiTzUvT084Sjh6UGQxNExl?=
 =?utf-8?B?TzQ4UUJrZ0RuZWw1UGVpL0VMczU1YzJsZzhCSzVRbGdFOTd1QXpRMk81ZEhT?=
 =?utf-8?B?UjNNaGlIQmVMdytzUkpTY1VoMmFla3czNS9yL0swRllJYzdtRzBsVFl5VXg1?=
 =?utf-8?B?RGtRZ0dQTENNSEVjb1lCdDlZM3dweGx2cVlHamltd01uVWlHcmVJUnlhNTdP?=
 =?utf-8?B?ektDd3NtcE8zb1g5QTBiM1gwSDYybHNUSEJra2dIZ0JDdE5odzNJVjlMbzRB?=
 =?utf-8?B?L1AzQkJEcEd5QkJWVnJXamNRUmMxZHhkWUEzcEZvWktCUVRLK1Flb2h4cnVI?=
 =?utf-8?B?VmFFTm9BZ25mV2pneEJ5QkpaWS9ocUYzUVN0UnZHYmRoaForYTJEd1AxS3gx?=
 =?utf-8?B?ZXdvOWRuVldBWm5UZHE1N3lRYjR6SVM1Sm9wOEx3SHhOakJKcjl6VU1GWTVC?=
 =?utf-8?B?NEVZR3BPYkNkOWM3M1NFMk5pK2VxbmNUaGl6NHVZYXBLL1FNVDhjbnJJSTVx?=
 =?utf-8?B?dmh0Y3ovOGh0VmlkSmUzTFZidFNLVWZNVzh4eElSc2MydjBucmp5Q29SdExN?=
 =?utf-8?B?Tmh4OG16bHdXQlU5WWdJT1ZKS29zaS9HekpjU0xoY3JNRDlzeHhwQXM2MHA2?=
 =?utf-8?B?alFyMXB3YkdJWW83aFpGbXU1czRVMG9yRGhlVFp1QlR0Mm4wVGJJL2tzVlhn?=
 =?utf-8?B?WU45SHBUaUkxeDRYR2F1U3VITkVYV2JQTzc0ajlwM2J4dWlGNnBCSUZMVUJN?=
 =?utf-8?B?TnJiaVlCVkpRZTVxZXZWU05EVmwzdDgvMU5EYjBZdEltZTBhUGlKN0c4RlI2?=
 =?utf-8?B?MmxtbzhNWmZEcWNGTXJYZmpiMXVuUktVd1FEcHJVSEJ1cDNLS2pmZ21Zak1i?=
 =?utf-8?B?RXVpNWJJcE1qSDZHLytkYW9PMlAwa01XL3NTanZacVM3OHdEeVJ2RGNSMDhT?=
 =?utf-8?B?SHV5dEVEV0FDZGVnZEtMSFU4ejEyaDBPRXVlNTRjYmxWMFBzSkNhRysySTRv?=
 =?utf-8?B?TENFZmlxbk9BOTYwYW4zM3d2YVd2TmlIRFNyKzJkbjFOWmdmQ2NGU25nOEJ2?=
 =?utf-8?B?R1JDcXI4OGNCK2c1SkpWc0V6OEM2SUlxaldGekIzWFloQlNPY0dRcjhSaTIz?=
 =?utf-8?B?bnU4K2ZSWnd4UVBVYzJSOENVZTZwcTExa3M0ZkorUUZCdTdRMTZzaDFWdHY5?=
 =?utf-8?B?eTN0UXJDS0xWY0dBbUdPSStzVmdLNk9jYTNvc3ZIQktrUWJwQXlFcFB4UGdJ?=
 =?utf-8?B?Qy8xTTF0NjJXOXh2dG52NGU1b1BKSVo4bnEwUzIyTXhZdjB6aS90blZ2ZlFw?=
 =?utf-8?B?bGxTRTVhTVhLdUtlS0tGOHAzcUI3LzRKQlpDNGhpL29PVkpOZG0vdFQzR25z?=
 =?utf-8?Q?iWL64DJmyQdPw2NLYaqugCCnX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdd8a60-5f94-46fa-50c3-08db0865f7f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:17:04.9438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1iSUfLfYXwWLc7EXY87XqjzBzhQD8rZHUEDeWuz2kIel2+iLuDpZmZY2e0oe4oDgfgICw+qj+ssTeUluth1kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6713
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/02/2023 17:40, Alexander H Duyck wrote:
> On Sun, 2023-02-05 at 17:49 +0200, Paul Blakey wrote:
>> Tc skb extension is a basic requirement for using tc
>> offload to support correct restoration on action miss.
>>
>> Depend on it.
>>
>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/Kconfig     | 2 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 --
>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 --
>>   3 files changed, 1 insertion(+), 5 deletions(-)
>>
> 
> So one question I had is what about the use of the SKB_EXT check in
> mlx5/core/en_tc.h? Seems like you could remove that one as well since
> it is wrapped in a check for MLX5_CLS_ACT before the check for
> NET_TC_SKB_EXT.


Good catch, ill remove it.

Thanks.
