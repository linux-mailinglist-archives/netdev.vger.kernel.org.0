Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450B86A495C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjB0SNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjB0SNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:13:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06291B570;
        Mon, 27 Feb 2023 10:13:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xs4b+105t91lVejPx7L5d2WRLhvvr10tWquEIsJAeD9gDPmj+9JCBhzHvyc3lwow/eAa7NKL/S70JhbG+IaKER4UBhIaQ302FxcVDqlQ4ma1nKuH7EYxGVBUQXiDhIRL/B2Ti93Kf+8uwYyukboYRM2lfgeD9QhoFRuZUlKsB2lGxx2rvnUauukpIHf51xn/hUefgHm4hAYnp2BNNrsocVeSGOzCN+x1kcP84Hrc8QJwoZiQLmKnot9o1LclYYmZQyGDVYXt6FnJ8MDvMp+KXjlt4HHmQggGsdg3cao91S5UVeb0CM2M9YsRFib1uQ84LOhsU9sdbjKBL/ewFcHk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5SUfGF2fMwWHS5iiGjI42bTPu09/NKSl39Ozci3bqE=;
 b=jkGpnemx2dCVmUjAGJWuKequmUKdubhI2abWIJqsDxzVOh06/m0lLNOwKFVlhIw5zKaf6OeiTRCEa3YIvBGKF1s1rJcYMfVky2D0x8HONiI/x1UmNfmeuTQobMO5CzDpQLGvUp1sSDNlsqgjbHslAj2b0C0j93set2MhKG7fYWHtEQ1J0j1p2ZnPaM7urXvkEmJemYD6MWpvaJTa6QZwLUpGCqcsCwIxEG7j0yyfTE+hzEvHdabhMHdPd8HqKw4ZKD51dz+SKOCs9E3e6WapfvrGbt3pzb3mJq+IpkECrgjmhiXmpwLLTEwk8OaIVBWEdpPUWromu/bh/KtRKgfayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5SUfGF2fMwWHS5iiGjI42bTPu09/NKSl39Ozci3bqE=;
 b=PZoqaY+ZBEeFDyQwqhKZkgHVPDrWkYm8UP08QC1DBsAJMw9juN50juVP+uOHgt6EcIep5eFXR1hc6c3kcWReJ93BrUSTLul9qUyJ2+nrk8mw82Bw6sHST7OS6IP/MAJIzhc97wRGEmEiuSp6+1DjWoYxKBUOB41DDMJsDs+294kS0BmbhgamEr/oMXAcpl5hSK6xs9p7IrMBZMcdx7K3zF4bx6RkO2Ro7VP1nL/xd/G88n06X/2riaS4Gfn5mjtKmjZvWk4o500Ui2WUEuTRlWzyZl+kW7wUlfkCgBy216xfGuaaBE1UDjFLXMVDBCHHbyudrpDny0D42cGyW7+3TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 18:13:09 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec%3]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:13:09 +0000
Message-ID: <7e5aea12-7c56-bc11-69fd-a608cfa4eb93@nvidia.com>
Date:   Mon, 27 Feb 2023 20:13:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101
 Thunderbird/110.0
Subject: Re: [PATCH net] net/mlx5: E-Switch, Fix an Oops in error handling
 code
To:     Dan Carpenter <error27@gmail.com>, Vu Pham <vuhuong@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maor Dickman <maord@nvidia.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Y/yQ+kk/cQdXKBLw@kili>
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <Y/yQ+kk/cQdXKBLw@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab30e50-8235-45b8-1ca2-08db18ee478f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4gXfB+mcwNQ5hFu7k2VDy/XKeZFL9FoAQqYHqijwbvczXadsn1QWHFM6K697Te3DSyQ2c0fKRMFlBTcHsV+7LcEEIWmn1Cn65iHA+0MrvVXLDTdszdpN+jKwnn5rVx4GSMh/Hsr4JPzgr3mClydFk99ZyFdMaZQhVfh6fN+4uTzuS7V7/48tJ6cEWy3F0/P5hbYjNF8pIuVGn5hedDfxjS5UFn8066/eGIuKxl8o1zzl7Ec4Ea01vskqPLBp3nQdjHaQkWF4+zuwqq3X74gMEA4pXwYzj9vqLqchKqLx2C7CkI3YTCiZvJpflshYd9FF7VfUgCmdAKErvLjkyE5rE/XGI4DmNSiWsF08mY1vl7T5GrFVWBkMohvv5CWBGA4966wvkKauCmi8olX9Wyi5XxwzLZetgzS9YOIcxWjGFsYZZJRJgCt6V2U+81Iny5nbgkmtgjWL5FO66JhYbS+tEnYQKVrckrET0qgD39ttCMWzi5Z3PNZ8hidQEQNIA9WOcxTfvbE/gbq4DjoE8QwUcZYG7+tKHMXfv+gmCmSoGk4HVpcPYp2x6ugFMjWdN2652AKGDApzR45m5hLN3Ea3lJTVqRKj+HS8AoA901QlqDyVYLDL1sH/hU0yL1pq91fhjD6XC3ZgGRnjGh9VnKV1u/OQAq/V9RAYeUMfashJXWuoAwTMyE2oGed8rUbI6aO6WudObvMiB+MWMHbtL/DQbGYf9dvH0TXgFUao9bZmBjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199018)(36756003)(54906003)(110136005)(316002)(83380400001)(6666004)(6486002)(8936002)(2616005)(53546011)(6512007)(478600001)(6506007)(26005)(186003)(41300700001)(86362001)(66946007)(66476007)(31696002)(5660300002)(2906002)(66556008)(8676002)(38100700002)(4326008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXFOQWdMOXM1eHltU3NJR0J2L1NvVHFmZjBPMDd5ZjUxSDdlVi9mSWNDWFh1?=
 =?utf-8?B?SmlwTnZIQXkveHUrWDRPMEpyNTF5eEdzRWYrek1MS1U4dzBoSDZrZEUzSjZw?=
 =?utf-8?B?RkJUdFkvbGsrYXlNNXZBbWRaSS9Wcm5QMTRBL1VBWWNmeERVQXc2Qnk5VjF4?=
 =?utf-8?B?M1RiOEdtWlYxeWVCWVVtN1JwWWJTenRrUDZlcXBGOEZ5Z3hqakFCNVZVVTE3?=
 =?utf-8?B?TGpVWnJocTVaOC9pMllUaSs5ZzE3Y1dQY1YrVkVCRnFMOXREaTJpTFJ2MFpL?=
 =?utf-8?B?dndkenRlMU1OeEVJOWpSWGlPS3lLczlXN2k1Mk9oM1libC9pOHBSVHFBQjlF?=
 =?utf-8?B?VFhoL2U3TVZ6bWVGSFgzWWlMeXc3Y0F6SVpWV1NDNDFXVHdEL1dkYVdrN25k?=
 =?utf-8?B?TlpqL3h6Y1hQam1NWHYvRmZaNW9PRW1nZlBVRDc3Ri9sTldNVE9mRUpWVW9k?=
 =?utf-8?B?Q1o1NjU1a0pqV1Y3UkNrZlg5RFpzWkh1MmVqUm8xbENMVjVIS0tWbHV1OTY5?=
 =?utf-8?B?QzlVV0VLM1Bxc0Z1OW50TnRtWnBMUWxFYXZZSVF3ZU1sWHE3YkxMTkIrVDFB?=
 =?utf-8?B?UUJpM0pNQUc3UnA2SEprby9VbDNPRmlIQ0tKWXNnZklsVlhLa0dKUFlnRm9n?=
 =?utf-8?B?MlM3UEoxa2VBdkJVRUJyc0ZKTXNKNFhaSEhpWWhFMGtXTW1SNmlsb3JiajFG?=
 =?utf-8?B?eWYzL04rR3BFajR3eWIySHNjZklGeHhBVG9RQmY3aU1yUy9oUWRBMGcwOUZB?=
 =?utf-8?B?UGdXWHBucVhiSGJQaWN3TldBL3liUlRKSENCMHNETEFhSnoxLzAyQ2dWMmV1?=
 =?utf-8?B?dlB4NnN2azk1dGdGUS9EcVNaVkM4dFd6eHk5TDJqaW1wT3ZvTmMxVEJhUWYx?=
 =?utf-8?B?YXBua2Z1ZFpWMmVVdlhkamJJeERjeW5LYWUvb2lnaFRUa21WL21WYnNlSW5a?=
 =?utf-8?B?bnNmU00wZURXTys0Zno3cFhUckVuVUI2SDNXT0R0UVBURHM5T0c4bkhFcjBa?=
 =?utf-8?B?dXFBWDRmNGhVRHloTzZKZmZkN1R1UFpnbVdtTEY0VEJkN3pNZlloaitDbStu?=
 =?utf-8?B?UUdJYytSVi9xbGQ3dnIrQzI2NXdaNWtBVmVUNWFrRHl3S0tDOHBuMEo3ZGU0?=
 =?utf-8?B?OVVkQUQ2ditONXNETmxBV2Zpakd5eEVYM05XUkUrL0ROZGxVYUFOMTRyME9x?=
 =?utf-8?B?QTFLeFk3MUZOQjZzbnorR3czODNjVEw2b2FMZmtORC91a3RMUy9qelRPaDZN?=
 =?utf-8?B?MHZNMjBEQ0dWLzhGM21ia3dFdzhGdTd4cGIxMUk0bno5N1llU2xLaDFIdjZr?=
 =?utf-8?B?ZzZaczg5RWYreWJ0Q21sVVhXNXFzMUVGYTBpMXVkMkpHZGMxRVVnZVdJZy80?=
 =?utf-8?B?K0ZhVWh3WlVKemx6SFJOTnh6dXpzdzViMDZGMzB3ajhmbXVDeGtqaFQ1Zith?=
 =?utf-8?B?OERCRzlhNTNJcVBMMnh2QW5UYWZnYmMxdWFyaXZ5Ym9lWkFHeGFMSVB5azE2?=
 =?utf-8?B?VFF0UnhpbXpjeE5jWFlVakEvcXpqS1FTeDRHMi9STTNWZGRGV0UzU0hqS2xV?=
 =?utf-8?B?czlLY1ZIS240WlN6VUt2WGVsMTM0SXF4a0VTOHRHM0lFazg1V0FPdEkxYmNh?=
 =?utf-8?B?RERnNHZvbGoyNGE4V3BLK1RIZ3ZtR1RZRUhHcDFxa3AzQW93RGdjVlh1enNu?=
 =?utf-8?B?ODJJbFNWTG0yY3RHYmRUNm91S1I1UjQ5dHRydTZMS1RZdmRGZlQza0laTWRS?=
 =?utf-8?B?V3AwNmhTa1VxVy9Kc0wwS2t3UUNRVW1UclVrVjlvTUsybnVta1FSNDBpbTFS?=
 =?utf-8?B?WTNSRGs1MTlNVVhQSkpRVjByS2crc1c4KzRpckFIWWd6RUR5NG42OUNFN0lK?=
 =?utf-8?B?dy9LNXpYcWFCZHlSUmRaNnA4NmlrWXFEdFZDd3lZZ2JsTm1GSHhlazd2M1hX?=
 =?utf-8?B?a3MrRkpxd0JxYmVNamNYMlJ6bmg3emZZbDJ3eHJCbjRuK3ZybHRlY20vZ3Ex?=
 =?utf-8?B?VldSbFV4cnJjdkhYckxET1pXNmt6a1hMbTFQTTczTjFNOGpOYVdoZmhtTmdM?=
 =?utf-8?B?dlQzcnRtWmZQRFNQdzZiY011MmtSbDZVOUlkTm5rU2lhc29iRzJsYnFsYXRJ?=
 =?utf-8?Q?U809whZGeaPrBsAKV3bJIkw3K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab30e50-8235-45b8-1ca2-08db18ee478f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:13:09.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KA/kyaQ0K1Qa+vukw8i1NEVDiyauQ3BR3NJaRUKvz65iiytGvej+oBnwKRu/4ih
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/02/2023 13:16, Dan Carpenter wrote:
> The error handling dereferences "vport".  There is nothing we can do if
> it is an error pointer except returning the error code.
> 
> Fixes: 133dcfc577ea ("net/mlx5: E-Switch, Alloc and free unique metadata for match")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
> index d55775627a47..50d2ea323979 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
> @@ -364,8 +364,7 @@ int mlx5_esw_acl_ingress_vport_metadata_update(struct mlx5_eswitch *esw, u16 vpo
>  
>  	if (WARN_ON_ONCE(IS_ERR(vport))) {
>  		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
> -		err = PTR_ERR(vport);
> -		goto out;
> +		return PTR_ERR(vport);
>  	}
>  
>  	esw_acl_ingress_ofld_rules_destroy(esw, vport);

thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
