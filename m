Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EBD4D0E73
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 04:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbiCHDrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 22:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiCHDra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 22:47:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CD633E1D;
        Mon,  7 Mar 2022 19:46:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gncBX+iT7nf/BmkswvTG1IlnZhvSff2LE/HGm/J4NouUv6p3hOodxyyQwFI5uGzVCCPBpIxyQ63nEnIgwDQ1i0s9QxS5AfzDLdgktf4WNZ9JKtQzeW4AkDq8bA6k9feFcMmIS3zJWUYw2NzixWd2972GR2ZareWRB8aVQR7mt/uOj7DrSLEyuLUBdyRaR9kCYAUqj/rUma5MOVLXVn+MDdl5AmTHRR2+DiwNo6tfpJWArkTQf30rfMVBrw39FBSL4LZEilvkSRNtogsJN5616WJQd0SZeNBFSsZnLnufSpgwJbiGKFgo4OXCZb1rNTRba2S7JjyutWeIBrEV3eoy2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTFNOODiS8sILIwRmJqlaFHd4EKL0OppdjEv7nmi4rM=;
 b=b5d8ZWt7l8PguP/ssdCDDazAUjHWuTr/Fann8oFwx5ErHcfd9PS8rfejYyo/xyyssgJkZQq+CuzDZgwuxJJzArW6TlhHl/h+25FG+sR/Eg9ar7158vnJNN0B3ZAWc/pnniqfurZ/WyzrSX6andXzDZP4HHz7AAMTcEPQ0eYKvM4F0lH4GpyZxh2awXU9ijP5Zce2hoJvK3AZRHDUad1ABsYWVBNbAXXYJ9EH0qMAesdLlz4xteRSlPUaKYgBaHscJp1mTBS0JPq6CxxxBp+ZGyqLt1jPKkAXk0vlXe0ZLKw8LFSIp0wt3G7I+aI02ZkeZ+U3drG/kEaPCEWJpzLq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTFNOODiS8sILIwRmJqlaFHd4EKL0OppdjEv7nmi4rM=;
 b=hLj2pwTNIA+7n+pmPrRKll/FY21qMXOAFvcyHdM3ChnKPaKnM+aqzoNEr0EIs3o1fbIOxS3txF4uFtht1p9HMddiL+5KVWmV3+EGzZHlqgiXkSI9d4k82tj7T029E5+icBON8cZZrzyv7CoKIJc5Kaf3pr5COsZzRuS4nLUqjvdJf4zAXbRxfyQPM7tuX465W5jIqapYoxw2avaNbFQIMNAW1/Lr9DL3ed2KZM4L9Mkn63hLjpN75Uyc8fnnBbeiMeHAiituECH/vXmCB3/p5eS1GQ/5hhw/EYG0PiAXPUtoUoucW6FF5CGLcmsFLJRRbozaXrap0yYuwGq8dDPYPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 03:46:32 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 03:46:32 +0000
Message-ID: <5657e464-0f06-5bdf-106f-1bc7687e5e42@nvidia.com>
Date:   Mon, 7 Mar 2022 19:46:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] vxlan_core: delete unnecessary condition
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20220307125735.GC16710@kili>
 <c568979a-d3da-c577-840f-ca6689f7400f@blackwall.org>
 <2756c7b6-6402-3bef-a3ca-273459b9bda5@blackwall.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <2756c7b6-6402-3bef-a3ca-273459b9bda5@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0004.prod.exchangelabs.com (2603:10b6:a02:80::17)
 To SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a3e993c-d191-481f-5d18-08da00b63c20
X-MS-TrafficTypeDiagnostic: DM4PR12MB5769:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB57692723DF32821D069E24D1CB099@DM4PR12MB5769.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFe1nSXdI6oQVhS8aRxeHZKHbX6UIk2sIhFWMAxJ3BgY9b2MrPC9QBxezP3g6TwaStn0aJhqXFFu86odkGtyjhzOHculrE9Y2WqQihCZ1VsgeQFCB9IgpVxW0XvEGTcNWgJ1ug3Rt9nW7+jH8s/LtZP4e+CMKapBcYts20C93u6f20j+nOGQkfQSak56Beq/wX2Qd87nTSzjFaaxQYA7S67hRxqSpEmlXhTyIWRU7+kUaREn9w7f8KBBW7d0H6HdSCjMM2EYBb7G8EGvkdf1SWLQdkumZN8KWHQpX+6wQpTlqKWpriDrTNQNEGvABGFWU62JkvuUzi7u8hUwRo1QGQ3Fjalqx4jAR3Jk0fewbRcBdc6xU4HO9E7F4cSxNJoptdDnCs1x3hA9/d6XvtVd1b9t3F9wRA+XmbyRzVr+7N102tCj76Fkh1ORDw/Xkn41udwrT21zB/JyAnGHp/nV6STVnm/JhgktD8YGj8hhIve/F/2lHkKJdArw2qRDJTMjk7cNfwSI7f7h6JWKci5v482wcBVSbm7NoLZVN/pf4GZTNzbly208rb4Q1fXLOEkWJAMUP4+t6eW5vbX9J7igVfu39nSajCGZVZ+JJSyBvi8+8D4pfTRItIlghoHuHM+uKQFq556kYKF6zvuQyZ6hDm68bXDubJcXUJtK5OGLK6XKRfAnaHt+MWUvOv5XZW91ZBg7fN0oQhh3o5arY+BiXu6UGq+2wMmcf7COvdtF42s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(26005)(86362001)(6512007)(2616005)(186003)(8936002)(6506007)(6666004)(38100700002)(83380400001)(31686004)(53546011)(6636002)(8676002)(66556008)(66476007)(2906002)(31696002)(508600001)(6486002)(36756003)(316002)(4744005)(110136005)(54906003)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0xqUjkyaldURXEwUzhNcjlpbnBTVWFrbitPemtpSW5yK201b2Z5ZkJwb1dX?=
 =?utf-8?B?TXJRNkNrWmNEWXdxOVlycFp3RWlSYW0vM1lzT3ZmbGQ3QTEwZFJnT1NvclJL?=
 =?utf-8?B?SzR2RVR0ZmYxUG9xL0l2THBFSWdNbEI3RFd0dnB0TElaQ01OaUJxNm9zMHJq?=
 =?utf-8?B?aU5tcDY5a1BzYnZDMFR6VlFyT2E3MGxXdkpXbHZvSmw0RmJmRUM1dGo2NFNE?=
 =?utf-8?B?MHMyQ25HZ210b0RwSXdyd3FIdW5XYWYwNEdaQkpsam9IemVpKzFIL3F0cEI0?=
 =?utf-8?B?TUtxdG5wVkgzeUJXd2M0TEx1dXkyRUFQVEFWeTNnMTJZby9RT3haSEZ1cWVB?=
 =?utf-8?B?NjdZTGV5Z1hEek4rZ0hXNklsMXByWkEwdlhpNnJMUGljdFRTQm1YKzVVSmRO?=
 =?utf-8?B?ZGY0c0RPdjl3QVBaa0FVY1h6WFZ1QmQyaFg4T3VDZlo0REhQa09hTFRaREM0?=
 =?utf-8?B?RGpOb0kyNk5KR0JsVFd1MDc3NXBJNFZ6M3FEUmtUdEVjVCtQRUdBRndEOVJY?=
 =?utf-8?B?aFJqSVR0Mm1adXI1UURmY0JiSGlodm5zTzNZLzdFMEk3TUh1R05xMWVIenVo?=
 =?utf-8?B?bXRrbTBNMHU0Y0VpRytKNHhnUEtYdjR1a0R6L3JhdFBES0Npc0R2QlFoSVBq?=
 =?utf-8?B?dFhaeVVtWURtdkdROGZsZUxHOXM1QnBhSGRuWUhIT2JHZ3VmSlQyYnVaa2NT?=
 =?utf-8?B?c1JVNHhFallxRmRwSVJtR3c5NkhReGY5WE5aRktmeXNaMkZZZDg4SVZ4SCs5?=
 =?utf-8?B?MEppZmVZdUp5d2VDdjhwV2JzVHpSbVN0VHpTa2NPQUJ1VjdWZm9pQ2xFaTMx?=
 =?utf-8?B?Mm4rMkJveUo3YnEycHlVdHZCVGthZjZQU2hCS2dCL1NwbHVkMFJoTkhzM25u?=
 =?utf-8?B?UFFhMkZKdHVSU1E1bG5SRDNqS2E3MGptVmpGV1hjUktNRVd1RWdLbUhWTW52?=
 =?utf-8?B?QWJkWVBDTWFucEtmR2VIbnFERHFlRWlQZ2oyVUxNYlR6KzBjZzl0c0lhdlNI?=
 =?utf-8?B?UkZWRlFqcnFmYmxkQ09CK0xPS1dVVDRZcXFESFp1SU9COWFWeWUxNDlYQ2tP?=
 =?utf-8?B?UUdpUG5IeXVtREdzYzVCSzFXS0YxOGNJeFVITkV0R2lvbnhFcTA1MURFVEpp?=
 =?utf-8?B?V0hIdXBGLytDbkFDUmMxUGIwd2hoaVlXVFA2UFR3QWdzU05nL2RrdFViMTEw?=
 =?utf-8?B?TjNjSUdRUmlUMVpLTVRIU05mdUx1Z0ZSeTdzSjdPQkxsTlRVbWdnei9Cei9M?=
 =?utf-8?B?Sys2OEIrVTNDT1czaGpwKzNpNmNyZXg2VXRWbjByWjlabGVibGZ2cFZlb0pN?=
 =?utf-8?B?UkhGRHVnZ0dCSThSc0Y4YXlIbjlnMGpBeWtTK2J2SisyNVR5am9LYk9MMytY?=
 =?utf-8?B?K1QwUWVaZnBKSzNTZW94MjdkSzVNSEMrYU45RmdNMFdTaUpWclpPZUNMTDNF?=
 =?utf-8?B?SCtPRktSQkNXQzJCZC9NRDBNRzhNam1EbEY4RkNTcFJyY0E3dkNkVkNzNjhP?=
 =?utf-8?B?cThEMmV0QTZ5Ylh0NkdIUll6U3NwU1pDSVl5a05BU0VaWmNGOTg1b1RjZCtl?=
 =?utf-8?B?bkFGWTBOclEzUFNMYmdJckdhdU1XZXZvekYxYlFxbHMyclBRamhWcERjMWFI?=
 =?utf-8?B?K2tIbGNqRUkwQ0kwTDRuOW5WQ1lmUEd2aDVPeDhPd2pjQTVrMThHRFI4SXUv?=
 =?utf-8?B?YnY4aGZZL3R6eFVlU0RKNnEwZ29QUkVEandCOUZaTytzMnZxVkxGazR5cGVG?=
 =?utf-8?B?TThPaU1NdmtscHNQQjM3T05jcHhMTTZNY1g4VmtkQm9zdkhCelVVMHEvNmNZ?=
 =?utf-8?B?VnlPYWJ5RUtyS055dnlXNnlvendUeUdjNDFJUVFJWEdSVHl5WVZIWHJjVk9i?=
 =?utf-8?B?QWpuYWRiTTgrYjFPWlZGdEkzWjFvWGtkaXVTeGZuSkNvV2J1OHo3WklUbHA5?=
 =?utf-8?B?UlcvY3VPMFFhZlBvWTRqaU9sTHZHM2d2eC9OOVRabVVnRjk2Qk5zZVlRK3hi?=
 =?utf-8?B?bUo0VmNtSG5SaVkwamx6MEV6d0xVVU1QS3dUMVZXeWc4UjFIcW1VOG5FVk12?=
 =?utf-8?B?ak93WGxQYXRBRTQ2WEgwNDZMdXpmN1Z2bmpobm91VGIyVm5Tc1VZSGZwcWlv?=
 =?utf-8?B?cHJTejkwZ1JreTZ6OXpCVzAzajBpOFVVdE1SbVFFVENONDMwaHJsV1FRNjhB?=
 =?utf-8?Q?ZpkLb0eYzGYloUNR7+sDElU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3e993c-d191-481f-5d18-08da00b63c20
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:46:32.0710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghlc3v6vu1y3VxtcCznzNsH3xz/q/xC8XmAgUzktSaz00k6eiAUqbEXX95PAmMZhU2roXnB6F2GrlUeTfSTwHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/7/22 05:07, Nikolay Aleksandrov wrote:
> On 07/03/2022 15:05, Nikolay Aleksandrov wrote:
>> On 07/03/2022 14:57, Dan Carpenter wrote:
>>> The previous check handled the "if (!nh)" condition so we know "nh"
>>> is non-NULL here.  Delete the check and pull the code in one tab.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> This not a bug so a Fixes tag is innappropriate, however for reviewers
>>> this was introduced in commit 4095e0e1328a ("drivers: vxlan: vnifilter:
>>> per vni stats")
>> No, it was not introduced by that commit.
>> It was introduced by commit:
>>   1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
>>
> Forgot to add: patch looks good to me. :)
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

+1


Reviewed-by: Roopa Prabhu <roopa@nvidia.com>

LGTM too, thanks Dan


