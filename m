Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0C5A7679
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiHaGUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiHaGUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:20:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FFB6DFA9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOIMvMTcsVGCmJjgV/lJI7yFzn7mV99tI810zZP9uZjfYdME485BWZK8H2Pcl4iF3nNf+R5b/ORPsESv52q/Q+CFdvS1s4Izc9VuraWDrpMKwUn5W0JCSNBzGw8D3FQN+dPxDEwjlhyB/pU7p/AP2Hk9o9pLuFQOrvZ5gHBERZfHWUzW1vyRGiCsMhqnJLxxY5Ylx80VIrWc1VemmLuDeCwk40vOY5ukbhor7jlga647QgfM3wzseXqizVsIIzP8VNUaTDDdy7wk4b2Plsg6jLYP833avB4/PLGgy/z5GdRTdAwRGRdswwlbN9w08fCdIjEkxcb8KKmD+qgR7T9vnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ul2wMyGI++HfCDtaUogx8vZ6oAWRKhpHPn3U1MviGzA=;
 b=YuFdV5m7l+LfalLoQKccOLIklEZFUDC30Vd2Ltp1hC8+o6chKbwPkscHWzSlBN0/RpeRSbsv+AfuhtUK/9hbSUOQsK8zOZJcgLBwOZFZZ6JKK/xiu56obaXsFxHlk9IXSrj/vnsr1IG+E/O0tPWdMk3h+fDs6HjE5aDgrUc3K00uoJE2+gI53XrQHsRRgwtPuTQgfxqeUdJBY6qazz1YsC44HGQz0Gd5LO7tmjGJ1JQnOWyNO7Ld/fzU2i1DYL8YsD8EuilgVmKkhMKrV2MgXkDCuP7AG81kijaj55Hx1QkIH0JmUY2JqodXUqcW9t2aVvjrnOk/LOBrVdmcMXbENA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ul2wMyGI++HfCDtaUogx8vZ6oAWRKhpHPn3U1MviGzA=;
 b=AnpHf8AM8Ko+uOLs6KyhxYgE945R/G5vGQMygRsCbezkP63IkuNBriAKGsRnLUv2IwIQnapaw4fOJwGtb2Cr6DpC1XreggD+QnYoaa5CoW48P6en/9/MugPfJhQn1fehxFGZNGAY6FveVNPMb8hQEk+Cn7oKNFFk97p5q4ug6e+NnNWbbZCFT2W60QENl+oA/Z9i3hrz6KD3XlR/WAD0OVjkrZGuhiRD3aT2BwbUSm8qPNyl3Q1K91KUB5PCNDP4aMdzpNVsfhDZ4cNHh+3fydEoGD1dGjyFZHa2vociLS8euRmdfwPv/OGbEEBAlpUIOr/OeWqGEA+bNPprlX6bHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17)
 by BL0PR12MB4883.namprd12.prod.outlook.com (2603:10b6:208:1c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 06:20:46 +0000
Received: from SJ1PR12MB6289.namprd12.prod.outlook.com
 ([fe80::f843:16b3:2d23:8cf]) by SJ1PR12MB6289.namprd12.prod.outlook.com
 ([fe80::f843:16b3:2d23:8cf%5]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 06:20:46 +0000
Message-ID: <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
Date:   Wed, 31 Aug 2022 09:20:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220830231330.1c618258@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::8) To SJ1PR12MB6289.namprd12.prod.outlook.com
 (2603:10b6:a03:458::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60aa71e9-f8b9-4fe5-1845-08da8b18f094
X-MS-TrafficTypeDiagnostic: BL0PR12MB4883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNfQLttU3/EyBgHhFF5rz+ulFQ8qdXERqGPjdIe9eE0MFmwlGfNNLFLHsOh/X8AzmIh/pUb+aTBDFnHOXngDKLKznaCpPKRCMRbtCjQ5e89daqApfmVISaRWYi5NQUXHQFBap4Gb3dUZmtXngr4niYVecjM4DD9ENv28Kyjx/XsFVZDqvh9t23os8Eqa0SgM8cqMxyI7OrAgpQN75qLQWbneAWftDnQ+yV6dfQVKbTqqAXCGLqwvEp0DGE1CYbfkABdW1+Zys9y1pWilcy+JL6LAI/m8t5Vo9h+ewjf7ttpxprnTu2Np/ucdpwuMlD90U8mFqpKIqpCDh084V4dVlbRp3Ham4u/6WFti3fKDA042v8VwUSWRseWukuqB7GGeZ+MW4HMy0ge6Pr3R66iodbp3nfqrRazVqxBz38N5WIxnnN//N8hko6KDCpnI1UFYDuM6SOy4OSuq+q/RKRdrjdSmKu/IgtRKjVQTtHxJViBEmKXa89RpqQnnO9b1g/2aMF1RlfPWuZbXaGko7OuDI7/N0POeC9Tx0R8D9T6KGq96obwqqY/MldzXqyGuxE8IV+x6pSy2L/CRAoSluIio2219gCMrsYbSJImlEeHCvV/ZtpAYqm/3kjoGXHo3bhbJA01046R/acueUBDwGifO/ofJ1Ox95cNSdZe+FC6Yp6QjO8o3UZ7UxF4yTmMnz8F9KHcLlVHEewtQkTpAKqYp8sQY58fFerYqXrL48iVsEWdAF0DHin7jFUKwOfFx+kEK3jI7mFPFNPcYJxYrAxgc6RwYKh6ptrdADdzYN+7oapQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6289.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(6666004)(8936002)(6506007)(107886003)(26005)(31696002)(478600001)(36756003)(53546011)(186003)(86362001)(31686004)(2616005)(6486002)(41300700001)(83380400001)(6512007)(66946007)(6916009)(54906003)(316002)(66476007)(38100700002)(4326008)(66556008)(2906002)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1NubzN0OTNhUlVuc2VRK2hVRG4yWmpnL0J6RTh5UUxiYjMzTE1JaFFiNG1B?=
 =?utf-8?B?TDYxK2lhQmtZSHhOWWcyK0ZodkY4cGdBU05nKzJNU2g4ZFNPRmEvdjlHUUtn?=
 =?utf-8?B?UklYeWhPbU9QUDF1MjJ3UGxiMjBjYnRlRCt5ZG94M2hxTnZsVWN2enFOVkEw?=
 =?utf-8?B?cEI4QUxDMEVnSGhkelFOaXpIbk0zQ3Z1WHZlbmdlMUZ5TlFlVnJuRlZERmpO?=
 =?utf-8?B?YTMvWHZocDFPNjdZN1hDUmdsRXdlVnFjYTVWTzBrS0owRW1Ha2hOam05cCtG?=
 =?utf-8?B?REtyMEhEMThjSW15MDREZG1YV2xYdkNpSEhQTTZ0TUlpQ240WXkrdENYcWRw?=
 =?utf-8?B?Qy9CSUl0N3NwajVsWWxVc0g5SVlabHVsWURjV1E4NEY0K0JlUzdBSHJSYTNj?=
 =?utf-8?B?RDBuMU9jVmp4dGh5ajBpbnU2cUhqdXA3ck5YSUZINzE2dzFsWnp0UEJLcmxQ?=
 =?utf-8?B?Y010YnBzOWZmeW5kUFBtazJzK1lKOHBhUlVBc29CL0ZVcFdSclRFSTcvNDRK?=
 =?utf-8?B?QTNZMVpWQkN3VHErK0hIMnowRTlNUVVTMlpySVhIK1QxMmhuNk9uYnNzMVlJ?=
 =?utf-8?B?bmxjTllRaldIdmxWYmhVVEREbnFHZkt0REt0enZ5Vjl4ZXJMd3lPVzZUVWd3?=
 =?utf-8?B?UUNVK3pGMjQydHlWaTc2b1ZaemJQYTNSN2ltdmtuR2F2cmNDYlRVYkIzNktZ?=
 =?utf-8?B?VWxydnM4VFBoTzJ6aTgyQzBFRUJWbzlUVWpBeHZRam51a2xQK21rcWZoeEkw?=
 =?utf-8?B?anZnUlBmSmMvNTlBUGc2ZTBXUDNaQ0h4bnkrUjIwU3dSRitJOE11Y2t0dG02?=
 =?utf-8?B?UmJEdzF3ckhBNzFwdWRnR2k4dDZVNG5uNHo5TjF6cU1FQ05LaGN5VEFCM1Mz?=
 =?utf-8?B?b1pEY2lOL2pZNW5aM3JyVTNidGFJUndVZUNVUy9yQTZBUmw3ekJld05wRDM2?=
 =?utf-8?B?dk1qM2h5b0NiTlpWTzE1WHNZY3kyM29wcktFeWp2L0xqaExFbVgzRlc2aXJw?=
 =?utf-8?B?MTZuUXlHRjc3MHorWkYrbVVmc2EwVEpLb3RHd21EdVVIWDQwekZyVjdoTU10?=
 =?utf-8?B?TDJLOUc1SUNQVTFSby8ycTgyTUV2cURSSUhCaGgyOXdoSU0xVTlEaXdZRHNB?=
 =?utf-8?B?R3ZOSWdKK3daVjJlOEI3YlhpNXJaOUFCejJRdEhoYnFkRUpKcC95ODhRdXVx?=
 =?utf-8?B?ZS9UNWx2YjdOQTVmNEgxVFl6K0FnWUpiMXczTjN3aWZoTUYwMTgwdFd5ZExJ?=
 =?utf-8?B?L3VESlJNOUVGdXFqazR5MEJxUkc4NDhDRzA1KzFPUGFzVmx0dlZ5Sld4Mld0?=
 =?utf-8?B?ZjVmTDFnTk1IQ0p2VGFRTUNmNVdWalJrNUpFYUY5clRnYmFHSk1LeHBtMkFN?=
 =?utf-8?B?UUpJSlo1Uy84UDlhR0pGc0xuZGVoUnU5WE4xa2pyV2pOQlZUZEdkL3ZGQ1FZ?=
 =?utf-8?B?MnpxOGxwNXloTzVWbXp4cGsxd2U5SFd4djV0Kzl0T3IzMWZvWVYxL0dUTE9s?=
 =?utf-8?B?dHpNUkhoMTRTSHNZenZzbklFWTBwVnZpTkNvNWE0YmVaMTBaUm1tbmFlOWxW?=
 =?utf-8?B?TDllYmVXNHhMY1FUM3IrZEVYdG51MDVaQSs3aE52czRRdzQ1cDVUT0lNMkVk?=
 =?utf-8?B?eDdRbWVRV3BQZUp1KzRBbjlNempEMWErSHZUMGJJaHR2NXA5c09DbFExUnQr?=
 =?utf-8?B?T3NFemtLZ0U3cjRzNEJyMWFCRllBdnIxRGxqTjdBa0ZNMEZTa2M4SWYzOW1P?=
 =?utf-8?B?K0ZPWWg1TUlOc1VPZFVnVitFc2h2ZHlnbzdEWFc5NTN6MXExbGp6b3pCK0J2?=
 =?utf-8?B?L2pHR1F5T2MyNSs3cFhCRXRna0k0L3RQM1hIU0dYM3JLWWxHMFIyUWR3NTNY?=
 =?utf-8?B?Q2VsMWJkaDNuVGk5ak1pNkl5c0xpRS9NSnN5dHNFa3VPcnhVWUlscWFDOWZU?=
 =?utf-8?B?MDY1RFA3TDAxY2VlNTluVUtNbUI2VHRxcS9BVjZiUU9XanNqNEJGM2VrWWlh?=
 =?utf-8?B?blJFaHo4Y05ZTE5aZEIyZFdSa1hzcStZN0lRWVc5U0tuZnlRVEczNXYyU0JQ?=
 =?utf-8?B?ZWd5OXRhZWNHcWNWODNreGFwWGE2WmMvbEhieEZ0c3E2Ry8zQXN6SXp5WFJG?=
 =?utf-8?Q?xvt+8aNxZVI8wzEbsAYNG2fcS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60aa71e9-f8b9-4fe5-1845-08da8b18f094
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6289.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 06:20:46.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZUOvjyXHhdnqIibPxAD4nDSPR9BkfX3jJLaDFzVVgkBQaWm8JyqvNlBIesClMl7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4883
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 09:13, Jakub Kicinski wrote:
> On Tue, 30 Aug 2022 13:12:37 +0300 Gal Pressman wrote:
>> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
>> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
>> error:
>> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>>  2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>>       |                   NL802154_CMD_SET_CCA_ED_LEVEL
>>
>> Use __NL802154_CMD_AFTER_LAST instead of
>> 'NL802154_CMD_DEL_SEC_LEVEL + 1' to indicate the last command.
>>
>> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>> Signed-off-by: Gal Pressman <gal@nvidia.com>
>> ---
>>  net/ieee802154/nl802154.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
>> index 38c4f3cb010e..dbfd24c70bd0 100644
>> --- a/net/ieee802154/nl802154.c
>> +++ b/net/ieee802154/nl802154.c
>> @@ -2500,7 +2500,7 @@ static struct genl_family nl802154_fam __ro_after_init = {
>>  	.module = THIS_MODULE,
>>  	.ops = nl802154_ops,
>>  	.n_ops = ARRAY_SIZE(nl802154_ops),
>> -	.resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>> +	.resv_start_op = __NL802154_CMD_AFTER_LAST,
>>  	.mcgrps = nl802154_mcgrps,
>>  	.n_mcgrps = ARRAY_SIZE(nl802154_mcgrps),
>>  };
> Thanks for the fix! I think we should switch to 
> NL802154_CMD_SET_WPAN_PHY_NETNS + 1, tho.
>
> The point is to set the value to the cmd number after _currently_ 
> last defined command. The meta-value like LAST will move next time
> someone adds a command, meaning the validation for new commands will
> never actually come.

I see, missed that part.

So, shouldn't it be:
#ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
        .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
#else
        .resv_start_op = NL802154_CMD_SET_WPAN_PHY_NETNS + 1,
#endif

?
