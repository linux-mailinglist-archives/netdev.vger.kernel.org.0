Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848164889E8
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 15:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiAIOnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 09:43:16 -0500
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:27841
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230170AbiAIOnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jan 2022 09:43:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZoJkikZ1SuKeOV5JdTTmQsctMDVJX1fM93Ob9zyIDQjJW++ZhAd8x/9c/0jVujm/pJA1rcLHb0Zs1I1gdhrBZkMUqKii/juzQxPVKW6bem69Dguc0scEF4L1WxSGTv0+4syUFT3nem43Yn+TWD6ylT4KjrxBrcjqEgJk5PEmSBnDjflsHHFGqeLHgV6FQiB+kQHfl+o5970jiS8NV0z4X5L8gmJ+eQrY9Dy2VtZ8LP3RHqPPa75PpREg/i5ojssV+z+UD88s8NxWj5WQlFkNeVf6n8ek7lBh/jn/W4qysa3L5G63wjleL4ZrLqbLxF9LB5Zx/EiWvkFlN9DWgam3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSjM107P+hfE2a+8fU4+GGHgiXUY1nx5n2X0IbLRp40=;
 b=O6A2mZL2Wk7LqaBu3YOm3uBEcjnyQfPeByb2WNhIR1LsF/jV0UtAcpeScF5+OevhpCg4XCHnTZaq5IDjD1SgAeiUUwpQGYGqBoxPb1Tk9bDV7Y4jUDHMViqQwOp6nDV8UphGlGVxoffekBkTi1UWwJDrlHBQZ002Zd8EE049+dloM+SmnjjU7gq4WILx1I8vAWEuQgZYDONBSXVXIS+GUebNf8lOX0Dzwfv8z7L/do1f3Q7Z8W8yn8kXhelZxRaVJZ6nKGNgB3J2KIkHUtNVkZvUBEwp2sHHbKkW0bATWdV2MZE6ql3aPzDP9T4rqv2aTf1/zeOQX4pnwLHrIWk4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSjM107P+hfE2a+8fU4+GGHgiXUY1nx5n2X0IbLRp40=;
 b=Pg5xsCzG0eCOCGZptoimkfp8BKRiGxADoaO9mK8HuDYGm74vfPq/zJDsOsopBO9PzAhGkTOgkABLXmxOJoCm0TfL/uAsgPz5nUgxlWjjxC+2H0g4CMsWkcjRpv3mpnu0lWtkHVyXqPvNWb1iExC82kw0RIntCkQ0ZvZEZ2GyskCwSkHR/9BZF3ea77AjkylYbIPrOd7eQdtHlcX+EqplhDI01f36CFSLH5B1hyzMhjk4adgyXa/wTVAx6ybGztQonSPugwqimtfUt/d0/75KM/kJLNaKkRUPZCbUa4TnwOJFBltQcCXLN/xGsBSyeSOQjRoTrjnBSOKdnR4e9OUwfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Sun, 9 Jan
 2022 14:43:13 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::8161:d1b3:cc90:1123]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::8161:d1b3:cc90:1123%3]) with mapi id 15.20.4867.011; Sun, 9 Jan 2022
 14:43:13 +0000
Message-ID: <56b6d708-b05f-6871-1779-45798a2eccdb@nvidia.com>
Date:   Sun, 9 Jan 2022 16:43:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] gro: add ability to control gro max packet size
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220105104838.2246803-1-eric.dumazet@gmail.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220105104838.2246803-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:203:90::32) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4bbcdb9-86f8-48b7-2745-08d9d37e5cdf
X-MS-TrafficTypeDiagnostic: BY5PR12MB3843:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3843BF5C5662679FEDB00ED6C24F9@BY5PR12MB3843.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2L9CPoCIHmqJa0Vvnb/nrm/2q6TWjwN13tpQuFImwqdJpTGx9/NadzkzefwZtZAGw63AOsZVRzM50S5U4LcloDSlN24fo5jIJ3qB/NdVl0qKEH7Uw55+IWBjJ+gGHxQvUx1GXbHubVE/ZWPRmj5QTF4nIUzmnqIyL/fz/DfAB7N80sTYY01fFQRaXl098oD3dTsYM7aK+eqpN1nVSzvWXPMP4tKEJYozSi9Qqs46PwWuf7SfLlS5rm2mCF+OzWNU0gQTA6wtVlbqysLFw9ON51b59+3wLKolzZ28OahQrbrvYO6LpgmCPWxHHPU4dDh72U+xIy5Jpxe63CobozV+zQ+Nu+fnDwKciOQEOKY5WpWDmVw2imoIY/OFWi24qS2z7HIPljMo8U6tCV0B9JjQRUgrLujV7lo9En6B/oZAouYhMvkhB4Cc3O7Gr2wOAR3P/rSB4336tphoG8jagdo7Ne/WLSFBN2OYlfC5eRdZBpR5/DTgWJtKSofvMi/dOLFun0XylDs2fNNiOcXm0YQSs95A/4xacLJVBWUBn/2vv7gREErVeEI8fJt8vRG59ZG0dftvizaMJYeUUTESGm1QST/tU/G7RwxN8PQ5gqk1+NXveaKjLaMkEAPr9bJGsO+5zxkmw1VXv7oXniAnkV60T5c9rBWfX4P3+l0F2PzmgTryVobW6A5EzzrY0RgBH1PGZDwdprti0KK4nG1AnLL9XExSy3eWCwatpWCgiHpcrkxFW+Q1L/OZgIbl/QjBc9YX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(8936002)(38100700002)(66946007)(36756003)(31696002)(316002)(86362001)(8676002)(508600001)(6512007)(54906003)(110136005)(4326008)(6486002)(2906002)(31686004)(5660300002)(66476007)(66556008)(2616005)(6506007)(53546011)(26005)(4744005)(107886003)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blpmRzlTM3JkRTZ4TlFVUng3L2JCR3FOc1l0TmlLMGVHQ2xHaVdVd2UxSUNM?=
 =?utf-8?B?eW9IUEVsSEU0dVZYc01XK3FFTHNyeW1pbm5NOGFCcWFHd250aTErdEFqU2hC?=
 =?utf-8?B?Y3JjYWEzQ05EZXJyRlBjWDA0VnR0Kzl2UVpmOVl4b3BwZEpRb2NaQmMvbk9P?=
 =?utf-8?B?cS9uNjBMUnZSZXIwbXRPQkpuS2trRG8wOUQ1ekZzaDIzMWttNzEvQ01nUmVs?=
 =?utf-8?B?Nmo4a2pCblFvUkdyTjJTbURXTHd0WENwN3ovK3crUWJTQnBWMkRSRndsbWUy?=
 =?utf-8?B?YXQ2SHVQT28xbHdLYXBvLzJSOVVMcDcyeXRTQWdqV3JiWGdGM01TSGt6M2x0?=
 =?utf-8?B?Qk4wMmtXSnNwRVpyTzdUYUF6UHZjSHZEKzI4WUxyTUlncm1HWkUwUk5weXI4?=
 =?utf-8?B?MFVPZWpGS1IyZDJTaHRDQTZaQWcvaVU5S2xJeXFGSWZuNVhNOWZBWExEMUFv?=
 =?utf-8?B?dEZRK3V3TlBHYXk2RUF2ZEtPa0Q2V3Q0SFA4VlhQRC9ld3JsSFJyTmZ2UUlx?=
 =?utf-8?B?Y3htRjhYOGIyOGdzcnA3dXhEWDVJUWpYWEVzM005TDFSVVZFTnRXV0hGcUxx?=
 =?utf-8?B?SXAxREJHNDlDUExwbzBHNzVadGw4MHNZbi9yK0lpc2pmVzY0VW01dTZyYWJV?=
 =?utf-8?B?QzJ3M2FEOHhaT0FiWXh4NzFKNHlCeUZnWUVLMEFURlBDbS9uWHFCUmNocEFr?=
 =?utf-8?B?L3U1V3E5MVhXSjJkME5yT3JTZGwvYlVMcHBsWm1lNFhqZEU3eFlGZTNJV0Zn?=
 =?utf-8?B?UVdZdjFiaDN1eVAvWTBmOFQ3Yy9NUWJ3ZlgwdWpXTXR1ckN3azlQMXpWSVZ3?=
 =?utf-8?B?UHVZVCtqNDV4aU9JUkwvcDNBYURINFNUSXdGdkJ3empzRkZreG1ieVhsYjRW?=
 =?utf-8?B?ckxOU0FiYkxVcXBGQytUbjdhYjVNRDFpaTcxYWFINEp3bVNNOG9LZSt0VXE3?=
 =?utf-8?B?ckd2SUk3NDB4NzQ0Wkp3ZU55aC8wSkxyMFNPOU03RksrKzJpK1h0YjRaeWRK?=
 =?utf-8?B?dHkvSnY1M1lLclR6RytyOW5ubzIvN2xVVzZWcGlFREdlaStnVEZNT3RTaWkx?=
 =?utf-8?B?R1RQMUN5L0srWUFuUGdqZkRGV3ZrMHhrTTVOUDE5ZE5hQVdqOUd4RUZXa29N?=
 =?utf-8?B?dlNBUWI1WGZCMUs1TWwxcUhaUkpVWmJyN3M1Q1JuZDl6ZjV0cGFkUWdqVVhB?=
 =?utf-8?B?YlZYMzR0elBKZVZkQndLQmZCY2lTWjhHS09zMC9Xa3cxdDlxWWNuN2JlN3pk?=
 =?utf-8?B?SitiRzNRTm1ieTZyOG15N2JOTitxaXJ4V3cvZ3N1R1N5d01VVWtvc0o4Njdl?=
 =?utf-8?B?QXYyVmVIMU95dXNMcEc0Z1pjZWR5V0I4a0FpdjBYZWpOOVpvUHI2NklkSWQz?=
 =?utf-8?B?U2tHdnE5RTBUbzNKWjFVamk2b0FFSGJLdFJkM0ZDeW0vbmJxVVZBNkxQL0tF?=
 =?utf-8?B?MW1xZVArQWlOSHNmTEZuMmtQU1FIM3BOU3psVFMwMWdsMXVEQUxTNWh6dGda?=
 =?utf-8?B?M3hqS2pISC85bFlDN1h1djJkbTlZeFcrZVI4TVdnWDQxcEdha09iNGkxa2xJ?=
 =?utf-8?B?TmxhU2dOLzJzajh1bVZxSVRWQVJiaVBiMW4rbVpjTTNGVlVzSFhOK0c5ZWp4?=
 =?utf-8?B?KytabDNvU2hKM3l6eDFXd0phb1JISDRNWm1hNWMwOVpTRkwxZlRLMGI1c1BG?=
 =?utf-8?B?Um1GM2tzTHQ3cW5ySU84YVBzQkFRN3JQNE9tdVdiZzNkMXdFU09ITkIzM09Y?=
 =?utf-8?B?Y3FnK0hrdXczMEl5SkE2OThnR2l1S1cvSTZwNnhnV0xzLzFadEE4TDcwSld2?=
 =?utf-8?B?UHpJYlBIbkVEMkQ4M3BFQTROYlZDdzArTUFsRzNFNnJvWkF6U2VRT01nbDhS?=
 =?utf-8?B?emczOFlFVi9LSDU0bnB1OWtYNjdzZGJvdHppNTFMR0I3UmdyL2JwOU5oMnFw?=
 =?utf-8?B?Sk9IaGkydFl0Q3JldHVsOG9wSzVwYTF6aUcxbHNLK1VhVTVOOWlmOERZVWJX?=
 =?utf-8?B?ZndmWHFpUk9LNVprQ05GOFU3OHA5NWtoYTNTV250OWFYNG5xNnl4akM0Qkt0?=
 =?utf-8?B?SHRzVVJXWmhpVTNiclV3eGh2NGVCWnRvS2J4QUNJa3QzUGlaTUNnNS9nWi9M?=
 =?utf-8?Q?BQ94=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bbcdb9-86f8-48b7-2745-08d9d37e5cdf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2022 14:43:13.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCabXv/x56o3au+V8PU3YHVCjr6JqdksFy17Tf0KfleYRJ57uJB5LU5w5MrVQIZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3843
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 12:48, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
>
> Eric Dumazet suggested to allow users to modify max GRO packet size.
>
> We have seen GRO being disabled by users of appliances (such as
> wifi access points) because of claimed bufferbloat issues,
> or some work arounds in sch_cake, to split GRO/GSO packets.
>
> Instead of disabling GRO completely, one can chose to limit
> the maximum packet size of GRO packets, depending on their
> latency constraints.
>
> This patch adds a per device gro_max_size attribute
> that can be changed with ip link command.
>
> ip link set dev eth0 gro_max_size 16000
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I wonder if this parameter should apply to HW-GRO as well, I assume it could benefit from that as well?

