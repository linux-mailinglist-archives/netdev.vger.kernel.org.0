Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD05971D4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiHQOrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiHQOrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:47:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075619C512
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKz6/cIAKVuWdxIgegC+lnGIcE34jlQ0qe+nFTUrOKRn5mWCZYcKuwLo5Fn1OkuLnQKZ9qnIQvH65X7zNMhawGORN4Io3gAGJPm5p/vc9Q+u4F/2BOaVOC+rdi0F19AoWDbjOEspPC1OdOq/mG+z5Kc+DopgQxGK04QHkdWVbYCCuhUftJYhTn7PXMKZwZB+CQJIGRuUlBgpdscyjIU5dsjxkekt2JETmoke2Bnix35lj4OcyFkqFujVg1MFMrj2JwKH9xbQHTuoJD1H9yl4cudxh3Xm8ywhqLgl6DY65p5ufM1Hi9cMV6tFFfGSuspdVXZ/6XqpBiIXUQRO3J4RyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrdTwM9w8tGlpvz7MRFJZ7Dzvv+ripcxykf0QdYfGCg=;
 b=XutzprQZNBynpw5kYkvGOlko7Lt1vRrmBblJt/+xpQ/C9BDbfkaK2m6kAvdTwNmq50ZMCA6dqeOSd4+uj0WJxrHJyFWgCbgPRUMJxUruOYo4Xew9vHEVFHAKWMCT8ij1qtJEL6Obv8Qyu4TSQ5LxBNWEk8jEmLsnhk4pola8oMcwvqMzK3iaC8ZzKI1BYU72pZPjd8gXhYnuZ7mH5waXuRxPFBB+0MkdiXI/lIhNYhdUDR72mMvyiROlY35r1OEe9v3WUN7kITuFL4JAMqqMLKteI7pqkYC+AkIgoxqmVmAQUBdESpuMDWOi3Bhcf7NtORkG+zo09toXCAQQ6VPwqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrdTwM9w8tGlpvz7MRFJZ7Dzvv+ripcxykf0QdYfGCg=;
 b=kX8m89PcPXPA1YMKdbgTMm8t+KjvK48S9rXA9Clhdk89DG/DP3dHaPXKa1R9Yj8Cgyywapw/LdyBq1+eRvg6QkaCnMXJ6CgTlxCRNyOARpsIQrN+iBvDw6DnONFzu3qke1bb4hQO+UU1OhNOW2VnQZufXBpO4kpGC6xP6ZmLb3T5up+sLZAYapm46oM4B+pAWt/wpbGwQ7xTYZRKkxgEAnXY/m7y0x+WyjYc2kWxAEUTJUqwuKiaqlU8lnmsVQHw+hnTZs7ccjVxmZ0PqwACbaWLPcfbRHZK31kJH+wfEDjA2eXv7C76Ywsz/7OyPzhPtzfSqFtYqHmP4OSBIaHErQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 CY4PR12MB1141.namprd12.prod.outlook.com (2603:10b6:903:44::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.19; Wed, 17 Aug 2022 14:47:02 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::a46b:2fd0:ed07:ed7e]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::a46b:2fd0:ed07:ed7e%3]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 14:47:02 +0000
Message-ID: <a2b5d395-01c7-4ca4-a844-2ba6952ac66b@nvidia.com>
Date:   Wed, 17 Aug 2022 17:46:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [ RFC net-next 0/3] net: flow_offload: add support for per action
 hw stats
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
 <20220816111941.04242d4f@kernel.org>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220816111941.04242d4f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR07CA0146.eurprd07.prod.outlook.com
 (2603:10a6:802:16::33) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67350874-0403-4c4a-2298-08da805f585e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1141:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDGUkXsiILzzZNkTEtSuE50WGXEmw85rSWozrzfAlEncuKWnTJX07l3xWN+IpQ6wYubnstjLqbcZMl+NzKimCDu/iSVc4iwjMztFbgrhrAB44QoTIGX9T3KsC2qQCqc+lVbKOQonRplJoTwtr4hg8mRlvGoFQRjcXVxSOjO8z5+lx95saTWJY3N1LVPUkQXEzQZpySvo0DN9jSmMQ65dSAQRd8/GTPx8JK4RdnZyiyYaQZi+mY8zYtSJ2arqg0Jy4KVUOLIGZaB3w24s/2GEvbuQ8tO7Jlej/zPUgg8d2OVzquw3siGKaEoyDZVxR5JB38wbmCYRsd1QAJ6MVPxtAXSFNxXa1X7MMnbPTCwvsVtVo2QJHbiJGHMgZ5/1t/3/9Oq+44ad91iO/jj3yLfFLE954B97gKC2Yah8NHYRBSx2zqeMLTPAMWj7a/QUKKnNVe4TJUFauJqZh8ux1IybrphUQRGXKqLtfpKaLUV4wl5cQs1Y/hk9GSlijYmXAkXLYJuqMOVtnWLhKEzWyxDmvjIn8t6pP/PsBOi9RT3BMatj/5IpyzNA73AW4sI/brzvJim3k4RYTZmmUn/QDzbDppWfUrSJWrxhOzCvXymOuUWhVNL6KGi13xLQvw4nM+b+epECWtH481So9FVK2WQQLqY2A8/CKyIX3DXNZoMzLoOJ4bDnSdTTuhNAg6zxAHZgYurS+yuA7swEYSrtCAduwsKSjxoRVXVQ/eUxVOpJsrKx+odaTItekDgNmxrS/0B7be1pTauaMFOYHcAgiW7SlfK+kp52IUtvkqC0Bd2a/tIaMz8ecH87Eb6aLiNdNwf2egMgIfBgIUPPJRds7C0HjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(2616005)(186003)(107886003)(83380400001)(38100700002)(5660300002)(8936002)(4326008)(66946007)(66556008)(36756003)(8676002)(66476007)(4744005)(2906002)(478600001)(6486002)(6666004)(6512007)(6506007)(53546011)(41300700001)(26005)(316002)(6916009)(54906003)(31686004)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDM4UzIzL2k3MmtPMnIxcFNpN3BGSlpuN0dKaGhNcE5lOCt6dlJEVXQ2cC9Y?=
 =?utf-8?B?d1FJU2FlUWp6ZzgyeTEvQUFHZlFDRkVrRGVBZUUxcXdZODZ3S1BVak1uUm1q?=
 =?utf-8?B?MWhYbzhEdHdnR3FBdzZsZkwxOXhEM3oyTnBTQWZQalRMSFB5bmlSS2d3UE9R?=
 =?utf-8?B?UE1iZ2hoZTc0UDNMU0hNcHJOaXJsaitjWWxQZHRIT3pweEZRM08wRmpsZWZM?=
 =?utf-8?B?allrTU0wbE53RHRxZ3RqTVpvT3dXeFJpRExXZ3pzVm9CNVh5SFNBOFpmRnhx?=
 =?utf-8?B?L2FhRDJ1aHJldEpEV3lRcVlrVHM1R0VwVndiTVQ4TXlJL2k5eWJlRHFoaEhO?=
 =?utf-8?B?OVdLU3VJcVhPU1h3SkNxTmtVK0RSdTVCN1JEMVJwd1hoZWJ4VWtYTmtMNkhR?=
 =?utf-8?B?anJROEJybWt4bGpBeUZxaTNJdVU4TVRiZ2pnMDFyVDFkaUxYSHgxK0x6TjNB?=
 =?utf-8?B?VGVKd1VTNmFsOVVUUjB5aC82OTRBOG1pajBLQkFYNVF3WmIxaVkwcFVpOFR1?=
 =?utf-8?B?cDBFemZsdlZudWpvL2xwRUg3ckgzTkxBbVRFdnFVOXUvZVpEb1ZzQU9JQmNG?=
 =?utf-8?B?ZUVsODhTRmlvSWI0YjNKbkFPcXpIMlgzRWNrWUVpdWhVSXh1UVRoL2dCd2lF?=
 =?utf-8?B?UER4MDZQRDhvR2NEMksvT2UranptY0VaaWlkTm9wQVdmZkpwQ0dWemhFNHlV?=
 =?utf-8?B?K1dORDBLdkpRU2l5Qk9GK0RXeDQrOUt5Z3JEc1lvMU1xaUtlNllBQ3l0R3RR?=
 =?utf-8?B?M25iQ0NQMkxpMzlYUHI4a1FvVUVnU1ZLeUZmUVFwbWh1Z0dIcUhOK1Mya00z?=
 =?utf-8?B?L2FiaGN4NmpJeHNaZlNWOTNDN0VoZzZodEp1dXdlek5QNjJLOWVLQlM3aGlY?=
 =?utf-8?B?RlYvOTA4N1lPbjZLc2ZFMThlVXVuSUNOOWw1VER5MjhxMmYwU1J4ckpQUlZ5?=
 =?utf-8?B?azAzcmZBSFFLNjh6NExhTUVwMnRkN05wcjFmVUUwdjhlR2tWRmtRZEtrc2Z2?=
 =?utf-8?B?bVRnZ0tnUzZaU013TzMvL1NHZUVxMmdTR1V2ZldWS083Mm0xNVE5V0FlelFl?=
 =?utf-8?B?ekp1ZWJVU1o4R245TGdoQzJvY0theW5TNXYrd0E0UUZJSG5lNEEzNk4wd2tB?=
 =?utf-8?B?MEZDTXh0MFRsaUhQY3YyRS9JUkd3S05WVTc0cjA0eWtlUnFwWDRMRFhraXp0?=
 =?utf-8?B?ZTgzRlN4Ynd0SjJzL0k1YmkySDlBVEV6bEE0Tk1BdkRpNG1mdUhGMjJ0NDlt?=
 =?utf-8?B?VlFtK1hsdll1aVdFWnErK2NEbCttaHVReEpLd2IrNFN5bDEyTjhyOURhMGd4?=
 =?utf-8?B?dEdnMVczcDJWbU9VbWFzejJLVWcyUk9oR3czdUFRcFVwU1k0UlNCRXpCeUd0?=
 =?utf-8?B?aVh0VW5wcCtqcFBlYWVxV21TSHV6TUE4bzRyWWtQMHdtTXJScUdLRTU1ZGpu?=
 =?utf-8?B?dlpid1lzQVRmVTBqN0JDbTRQTzhSVzFPa3JtQzFrVFRXU0dqY2lYaVdYL0dn?=
 =?utf-8?B?MnRnL05heGswams4L0xIZUxSVmViT3ZDdFR3MnlrdWlhMlRUVW83ODFQaTI4?=
 =?utf-8?B?VlBicVA3QkMzN1pjbEJSc2xBT1dHOWF1dklVYWYrWU5aK2xyQks0YVd1UXJP?=
 =?utf-8?B?ekVTK2xpSFkveTNncFlCMHN3VjcrZWZTQkUxU2hMZXdpU3JuZ3hHZE1FbDY4?=
 =?utf-8?B?L1JFY0pKQUlwOHVEZGZvUVVrZzlkcW5KRjIwUDlvRi85bVFwSWVQR01wZHdE?=
 =?utf-8?B?VmoyN0MvUVJBaURxRnB5Rm55MVlmTU5yYTVESnVmWVNDZVRoMmhGdkQycWxm?=
 =?utf-8?B?RHkxNVlKVVZiUlFVbGtEa1BZaGNDTHFKNC9YcktsOWFacDYrN0p2NHlwZXlS?=
 =?utf-8?B?bVpJclVIanhGSzF6VTZnQjNQODJ0ZGZ5bE1sWG9WQTR5c1A4cWJGZll2Mzhk?=
 =?utf-8?B?R2gwS3YydStJNit1SU5Wb0pCYkwyc3dtM3MzcDc5MDU2eFdpQm16bVJHOFY3?=
 =?utf-8?B?UEE3K2ZYclZqd0RBdVFFT3orT2llMStkSTR3aW5LbDV5ZUxETzFwSEVUQWpm?=
 =?utf-8?B?emlOOVY5MmtJbmtQYUowOFFzTk5xdWhjcU5ZVHFudXl1dU1hT2ZCOVNRNU9W?=
 =?utf-8?Q?U+YxofaxaMCXPDPFSc1iYvbHK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67350874-0403-4c4a-2298-08da805f585e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 14:47:02.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2htyj0DzejZq+q8g0HLMGrEOaP52TR5KLLJWaEVZ0GEnIAQi/yLLaZA6HrywYWp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1141
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 9:19 PM, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 12:23:35 +0300 Oz Shlomo wrote:
>> This series provides the platform to query per action stats for in_hw flows.
> 
> I'd like to make sure we document the driver-facing APIs going forward,
> please consider adding a doc.

Is there an existing document that we can update?
