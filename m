Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CD4C6E25
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiB1N2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiB1N2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:28:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C162CC9A
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:27:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLdH5CUr1C8+s1MisUnOgNzPRHtjN1eZPot4la29vr9Rh2FoWB0Mjn0srvSVG9rnEVjY5b3JJ9aedCScuuHgfbbok3BVuB7gOFQIn4uXU2So947CXrSALg/iXVGoglYfawaLvSG9JgBUsKzJtuwbB559tnGmA4DGEHAFVD7eBuV+xGK5NBi3vxElE6Hzc7tmg3pLTf/uOq3hq421hr7uNZiNihBB6HiZuHHWy+X/UBHjmLnTA4yiCSvSipIq08Js1E9QwZMMm3QWtWS9rNccrdjHrcyIj5hMAAQB59B6rjNlyJucsF+BMLQQVg8v/Q66viPJ2rUiz/92cn+rsLO2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9jyj+pCInzi5mJWNr/oN7vVUOVVIaMprjRrC5sF9I8=;
 b=nD24ZG2/npb62nX8ka8OgII1k+vLynWJOHyuOv78/Uh83zaTdGi8bbD5QLDEFoHWyPS5MQ4kptmYd/7Fd2dtknKsPEPQefzy3Ft8GPwEXnoBtOVEW03+bHf3pWVKXA63y4+SezYMgKGy8jySw8xR+FfQB0KNWREAcp1Yl8OEhtk++ZskKgPXPR2NgfKNrc8tNvSiW7VrhpnlrsZMJm6lL2iZ3Te8OURSdPPNYonjJpHFWfPdgoilxcKBzf5JhZGhxJqNBVxDwc+qNBUbKaBPRedMWemAuORyoW2yfn8BK8z0W5pLmUNnBQYPnwNJ1Eh9qbp64/84dWY2TkW6OiwC8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9jyj+pCInzi5mJWNr/oN7vVUOVVIaMprjRrC5sF9I8=;
 b=E2ebucmAXpgOObkUZggKBZTA6CMAs1SpibRYzdHYgj3U15DlNwUfbJbQgL0hmRgqx3f++lkwlicVHeP50JZUyZK7RMEz0QK/UvAvyJHOZHil3FoGKGtqTUOz1Svxg/Fr1FaM13E1mfLiVrya4PcFLLCDVzPqmWO+BjcLEuhQZRkN3JWaFg5gSd2aivNQpbeKzjB1CzetpUNyiGTRj3CfFn5bNkFm7dqXZVMcP5q/23CehamgMBx+e5S9zKh7MRNBkFd6g8/UJ8FGGQMis3SasagzYGcEcrrxt8K9Zma21847F7q3G1mQ34Z2IOvhTj7weVufIO/IBjOo4wKue6tT5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by CH0PR12MB5316.namprd12.prod.outlook.com (2603:10b6:610:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 13:27:51 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 13:27:51 +0000
Message-ID: <58d9789a-11db-8896-db10-f20f94753474@nvidia.com>
Date:   Mon, 28 Feb 2022 15:27:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH net-next v1] flow_offload: improve extack msg for user
 when adding invalid filter
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, simon.horman@corigine.com
References: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR03CA0048.eurprd03.prod.outlook.com
 (2603:10a6:803:50::19) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d14efc1-4243-40e6-8ec8-08d9fabe1e1d
X-MS-TrafficTypeDiagnostic: CH0PR12MB5316:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53160AA588D652DED92DF673B8019@CH0PR12MB5316.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mnHw0Gsrn+eORCXuXZcZy6CeH641W5jVtun7oSk3hVyS3wjBkfUtihs4feEJPKbxirbXARHxPisfL0tjZFpLLiZl60Rm1ETMwYHWdDl5i+XbDw3F8uVpr5hIgPMQLkrFQyOPkCMPcNQL8brl24Qq/XE3+GpYoCnwt9xw/t4lZto+wmpW9BkTD1fG6cBPit+KE3ng3Yd/SdpxLemhTYbnh0gEVAOwPMgNdw3lDXc7pJZt72yYn36gKIfwemjPfm7SwATmvispmOVBGBvJpdU/M3e776qFu43ir5VaxEPWgd9taZjHU+kKFJ/DSxwf2BEhNG8uxX7YgWIymCwe3vAey+Ap6UssYsGUZUP3c7ktU1oPSwbr0fDNKAKRW1LDfQN5c5Nc176D0uksUKqMqH/k2aMvqFHNPH0QKPu5ntpe4WrsZd5BoNGODhn8PjUr3bUVVBKBl8HSAkptlWBRAurhmKh14WTZvBHJwfLacxrG+tIIkVxKaYH3IWzFrKZ4NGdzTqEzM6uH3A4r5klQxIv+XbfsjpMKkCp4jz0IMswAcaU6C2DPEfkxfcZoTa0Rt91qDsOBMTLefhcHfnzM5PzZ9XsUA7XXtAQ+7afrzxus8VuYlPPC0QS7TgzFYbwvv+FyxHKdk58Nx62XF8rYX+zCxTh71cDrSLv3027FuVPe2O7baXTq786SOMucj7SzKn1HDDu5DHxrcu98Yb/uP2Z5tmHKeeNrm4btdMHs4E/iwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4744005)(66946007)(4326008)(53546011)(31696002)(36756003)(26005)(186003)(2616005)(8676002)(5660300002)(66556008)(31686004)(66476007)(8936002)(38100700002)(316002)(83380400001)(508600001)(2906002)(6506007)(6512007)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFVQc1FwZ3pRZXdpRjNsNWhicUxPTlM1aUN3V3pEVmVXM2FISmN3U3hxZEVF?=
 =?utf-8?B?Uzh1M3hLVzF2MnlMY1RNdVh5RzZydDZXd0hvRm5rZ2pxOFNCdnplSExpVGZu?=
 =?utf-8?B?ZGlJdHQ3V1JSWTQvZE5EYlV4THZ2NGJaVFZvSWZPSG1GSDFBY3BWM0hIQ2ZO?=
 =?utf-8?B?M3lDSWxTemhaOXQwb3RkR3JkRFBIUzFZR2F4ZGIydnBrZWlVajJ4aVNkV3Zu?=
 =?utf-8?B?T0k1WGZUeWpyaGJNVDIyNjY0QVd0YzlaUHJxR3pQd1RrRlE2ZllRRzZuS2pY?=
 =?utf-8?B?ZldueUF2ajNxdHdUNEEzeVNMNi8xbldrTFVNNVFhR3d0dDFXUTM1d2F0a3lP?=
 =?utf-8?B?cnNVMGdXL0daenhPcWcyZUxLMzJ1eGpQOUNFT05uTFNtd1hpeWRzZU9zaEto?=
 =?utf-8?B?ZXIwa2pucVdzY3VvYTFIbFJnN3cvL3lWNU5KakdkakNuVjN1d0w5VmFjekxI?=
 =?utf-8?B?cWRkM3BKOHdLeDFvYktLTlJVNmxkN3FFZlBRM09zWGIxdzF5UmNkYW4xc0VN?=
 =?utf-8?B?bjQwcnlCc0tkRElhYk1PcG90STExaXNxYm1pejRPOElCQmd0R3BOSG1LOXRw?=
 =?utf-8?B?blh5ME00UDF3RUgyNXBFOEFJMTkyZHg2Rk5CaTJEdmQzT0VWMHhPbWR1L0w4?=
 =?utf-8?B?bWJIQ3c4OTFYc1RIVGozVFBiTHR0WkhFYytIeFJSZ3FZNThYeG9ua1ZLWXpl?=
 =?utf-8?B?ZEVrc2ZPc09kdGVCOGo4WVpDTnMzZUxIUmw1elpxV1RtNnIxRjdySUhvay9x?=
 =?utf-8?B?STNVWE5vOUhnZVdCM0psN0R2SkhudlVDRGRHSzdBek5COTBON29BaGgxNE1D?=
 =?utf-8?B?b1VmWFQvbXE2T0h5NFErYk9XZkJLUlBBVi93cjBOM0hWTm45bnhmWXFZRmZI?=
 =?utf-8?B?bTZpVFE1c0Q4bmNrOVA5VHJ6L0R1RzNhUXZ2SVgyTVlteVJKdWxEWlFmVURJ?=
 =?utf-8?B?TUgwK2ZkeVVDNnluWlNKUlhnRjNCM28xd1Z5ZDJURGZaTnIzSzVlUkFoYmFs?=
 =?utf-8?B?RE15dEpQOWlsUnpPaFNjcFpkNHpCaTkzQU5IbU5YcG9GcUN0c2ZjQ1o4YzBB?=
 =?utf-8?B?T2U4SHVmNnVBMXU4TTVWSTlZNUZPYVFWZStVTFFrMjdPNUFpUFZJdkFZUWd1?=
 =?utf-8?B?UDkwbkttekpUWUZ3UTRadEZtZHV6Y3hMSDllYzNIcHpsV3BCRjVSQnVzRm9F?=
 =?utf-8?B?VkE2TXlzZ0ErenFBR1UzLzVaOHZCTU5nU2NCRXpkTE5BVFFRdW9SRmtqZ0ky?=
 =?utf-8?B?YjdnVm9uWmRWTjNLeWxzQWsrZkZjdis1ZTFaY3FFNyt5RFVERThYTjhXNGVi?=
 =?utf-8?B?WXd1b3hWU1IzOVgvbTRyQWRXYTJBend0bmNqVTc5QkRNS2MwNkJLT1ZST05l?=
 =?utf-8?B?Ymlpa1AxTFNJMmlyRFBobFZuSitLM1Ruclo2Mmw4VWhVbjNQNGdhdGU4bnpX?=
 =?utf-8?B?eXFkWm5DVXZXRDJxdGt1K3ZCNlNKU2VBNCtSdTBSVVpmWGlWTnZGUndhc1Rl?=
 =?utf-8?B?SkE5eHRRRExxa1VQUUpwM1E0U2dKc1hxUFdhNm56UFJWN3ppL2wxSDEzamJ4?=
 =?utf-8?B?RlptWHNyaUNRUFpwY1dlZzEzR3puRHBkVndCNG5ZSWs0UitwZy9nWk0vM1Z0?=
 =?utf-8?B?Z3VrbWJrdGFVcWVET0tyS1pwdS9paXY0VkdSYkRFYVluOHV6djk1ZG5SR2Uz?=
 =?utf-8?B?Z1JrRUZzQTRWMVBIRDlLWi8zRFZaY0R0K0N5RlBGcHZOemVZZS9ROERmSmNk?=
 =?utf-8?B?OXhIT1lRdWNjd1lsTFN0dUtBNXB0c3ZjV0o0a09ES0FEUnBsS2U4VW9WZFJD?=
 =?utf-8?B?NkgyK3NLNHhZd0FBQTF3bTM0ak9ZKzhaeU5nRHlWTytQVmJqNnJXa3ZWRUVH?=
 =?utf-8?B?eGtiQ1N6UWpVWnUyZXhRWEJmOWN0OWwwaEpEeWNxSFJoMng1akpFbWQ2N3JF?=
 =?utf-8?B?NnkwVEdjOGZTRUFKdTM4SE1tTHc3aTlmVTRmQmRXTjcvU0Z6V1Nheit1RmFw?=
 =?utf-8?B?T2ZIVmlhQzNsNWZPZk1MdGZDaGJ6eHZ0RW5yZmMvU2doempJS0VvWVM1ZXBy?=
 =?utf-8?B?TVVzK0xhZHVhWTJkZDhHKzVGMk84cnJQYnIwT2NGVWxHYVJJakhlY3VVaGdV?=
 =?utf-8?Q?VnnM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d14efc1-4243-40e6-8ec8-08d9fabe1e1d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 13:27:51.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snoByUEqLf6F6BzZIlPUcHphRmbuAhlbMlvGu/MVga1gQUtYXWArQyfls72URnz6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5316
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-28 12:44 PM, Baowen Zheng wrote:
> Add extack message to return exact message to user when adding invalid
> filter with conflict flags for TC action.
> 
> In previous implement we just return EINVAL which is confusing for user.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> ---
>   net/sched/act_api.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index ca03e72..eb0d7bd 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1446,6 +1446,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>   				continue;
>   			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
>   			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Conflict occurs for TC action and filter flags");
>   				err = -EINVAL;
>   				goto err;
>   			}

Reviewed-by: Roi Dayan <roid@nvidia.com>
