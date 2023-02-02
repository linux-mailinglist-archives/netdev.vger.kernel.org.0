Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675B76887FC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjBBUHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjBBUG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:06:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84787CC80
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:06:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfsC9+cSTvFo2iF+g4bl5w5lMgEE0vVjV/i3/p2Q+Li1SG7ymgGrfGdbNSPcJzCapXN7wBng6tHvAqF82zoPuXO+gZ68JGAginL8PTNUcwv+R3WQAWB3NqHKFfdbElkeylKZff+BUYSV/9whePCm7V6pvEvNQT0cbQSI6GjP41dM5oPOY7jFt2gCBSDjr+AReFJlTjM1TNTSnTd9JipzLo5vSSnFL5ui2uMCwIwgurJl8huVpXvfbUOJs9Jb12h8YVwJaLWYl2A6PKZK2tG2zZKb6rLyI8CjGPkAZ/R5uYVlpmxiXXcG/SRDQE5PDr8Cz9AnPAeB0xpezIMxL5kNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiLdfw8pKe7yoGK8fwdPe+UZ1C98f3grHQAiRK5Kbrw=;
 b=i6uhZtmdOEe7EUelkbWleJ9VSKKLQ3rm1XfpzD9OwBd76PnvutVUVJgetLvjdIu64mS0n31+jgyNeqzYSb1X6mqJ0xi5d7iXzP8alTW95WKBHatPZ1PA2JiXSDcYQkv6mqaPe8xGW64UWb1QsJkII8xW8ryutQh9g6SqIWjHUNZbJ7gvJppNGlMuBQFmdjX2am2O88wz0nuUnQONE/MZDveTmXrCD/4uJv+zsQSq89y7ygigaNbbKRIzhuycZl5IuDIsDVKpuGule8HXGkK6iWDS+dWOpELdVCbaIibxu/1lWtlwI1FePO5y5hafGKPs+bZm51js5DqCdZdJKRhVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiLdfw8pKe7yoGK8fwdPe+UZ1C98f3grHQAiRK5Kbrw=;
 b=x6/61K+BW0RgD3nSS4I0GyEz5cDtclCCj1F9BEUNpBCwKsZGvCtHTGvNLxSG8XOZq82ZKlhuqlax8pkGliUaAboAciVC2g4XxWeJQmoTwkugh8GjOXua95eJBYO6Wq3+S632/2UC9fvfzt6YyjkMG9NDaJ2ifa/232svGM+9ZuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 20:06:55 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.6043.036; Thu, 2 Feb 2023
 20:06:54 +0000
Message-ID: <917e57c0-fd37-18a8-a418-c439badb7d41@amd.com>
Date:   Thu, 2 Feb 2023 12:06:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-4-shannon.nelson@amd.com>
 <20230202100538.6f9a4ea3@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230202100538.6f9a4ea3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: f8fb3d36-2ccf-4bcc-a36a-08db055907eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4ZgENFUHLA2JaDAD8Jlt5cw1CdXy2YSxSC4cAdq1r/lTpsK9l4sEVlGGb6/0FNhRWcUJ1W1HXwRn8bANEVZqqJKYOzKwlxkcTu9dC4Fy/gH7qYkgbDJxNkSUa6N7dxOmZzNZY4vaKimA/PJ23+RQDny6Ybx/5LBCW/PGXRomzApMe+b8y4ubQ9PpErKP7ThUvQEQAHblQR+qbhRDF1iATyb3BWF6+sjS+YcyQQddTGWN/K806+SD/wn3lITjheebPCtWIJZInntMoFPW6PtzOgdKR2WGUZeKccvK1OyOqk4Au53qNozy39trgmqctNROGMlugZ1nHV0CaZA78Who3Ydd1A6K6hiDiwT4F0ajgLOmXWI4caBwM1JfTfZtRmqc583N99Qkw6ZuPgS9rTHIYIPtY/gLlMccGnoiYSeuOSmxXeox9yzQzSch/8Ph6w+749ke+PJpJg5M5rI6OxyiNJ61I8V07bjBBiYb5VA0YQVFKEP/XgZEOjovpxer/GQD3g7k35Kl3TrObEG0zt2fpercC/ICD7MWT9xeVrAmBgd5t3lwqqrtj9bd2po8NkU9Jw2vAafKriqb4krAriklvmt00oxHYtuhYOmfIJkNE+x30BmThpFkobQsC0s0Qjbj5k2QHxoHyyfTDeuk7lW+8Qooj+Xwd8quchPdYKuBciiE2dib3XPVbFKh89JjpGYOVebfKf/MzltmFKp6ROlPROPXEu26fqF9DC7Dw+yNQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(8936002)(316002)(26005)(6506007)(31696002)(478600001)(2616005)(86362001)(53546011)(6486002)(186003)(44832011)(6512007)(2906002)(4744005)(36756003)(38100700002)(5660300002)(4326008)(8676002)(66556008)(66476007)(6916009)(66946007)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Fsb2FRQXpsVW1LV0xJUjg2bDJNN3RpOGdhYTBTVEtMU2dGZHFKeXYvSFZ5?=
 =?utf-8?B?R0JWRE14ZFRNZ1pmeldvUUQrdWlVL21DZHMwS0tZcGZRanNMcVFSUVNEaFRv?=
 =?utf-8?B?T0pFTU5HTTM5NDd5bVpuK1lWaFl0cnVSMDVPQnloNzBXMUhGOUE2eVpFbDZp?=
 =?utf-8?B?Wjh1K2lVZENsUlVnM1ZsMWswTm9zck1zdEo4TUVTNVhJREcrOFhZOFFHZ2lD?=
 =?utf-8?B?c3duUTFKNnZLMVBuWEFsd3ExeEc4RHhGaVRxaDBRSUtxU2dPSnRsZlFKT1Uw?=
 =?utf-8?B?anY3MjJtQ3lYbDNrTkQxWkVzV29OWi93eEx1WFQ1Y042b1M5WjlqRFJ0a0Uz?=
 =?utf-8?B?U1VYRnc2ek5lUG42cjdBck1HVzE1dWdEL0JabjYrUkQ5ODJpR011c0lRb3I1?=
 =?utf-8?B?K1hPWFM3UkNOc3hKRVBRaHZEdisvSytyUWgxdERPNmZYZWtqUmdQMUovSzQw?=
 =?utf-8?B?TVlveWF3Y1RwR3IzdnpWVTF5NjFEcC9YeHNvNnp1SUpKL3oyYnpzKzVhSXF3?=
 =?utf-8?B?VTJnTDFjdHhEVlBjUDRzcXRqRUpTUHd3UHVmblBxdkR4NUU1UytwNDlqWDdK?=
 =?utf-8?B?MXpRMXVKWnlhRVVRbHVWMlhNRHQyVEpma2s5V09kNC9mQnlGK3VpdEs1OGJH?=
 =?utf-8?B?ZllrWk9DV2RxNVZBVmQ4UzR2UHM0YytKVy9scC9mbWxISE5ZZDAwQVAzUmVp?=
 =?utf-8?B?ZjducUZVWlpqck1JQjF6N3VFT0MvYlZ1dTFmMFZaVkVRbHRwK3NEWEkyblQ4?=
 =?utf-8?B?YzZEVStyUm9PMHp5SGFNazdTVlIxZTNVekk5Wk1pbmk5U3lVTk1uZmZVeDhW?=
 =?utf-8?B?T0JjdHZ5eUJuRFJsdWN2WjdQS2hSb3FMcDFPUGw0YVYvNlNYMHpSMlVHZzVM?=
 =?utf-8?B?OTQ1c3BjZzZLQjdha0xHVGFJZGQzUUtUczUzUW5NbkQwWE5MWkhMN1M1MFRZ?=
 =?utf-8?B?NzgvTnNQdytlZFprdjNGUXh1VDdvbWFCMlJGTFJJYU12WFdxdzluM2dFYTlJ?=
 =?utf-8?B?NFpDdG9XcVc1aGZrY2lnNVNTK2VrOFU1aEdXWFcvRFkwc3pBWjIxT0g2NFIr?=
 =?utf-8?B?ZFRkYktpQUY3eGtOeGNURUxmZnF2YW4vZnV2djhQellLQ0FidllTa3I5T2hX?=
 =?utf-8?B?WkQ2K1VHOW5VU1U1dVpJRXdOTnEyRFV6S0VpcTBxc1d1cExOdGs5MGZSdUpj?=
 =?utf-8?B?L2NXeHNvK2syRGhJK2hsK2NuWmVEdmRpOXB6cWpQcHdRdDFRcWQwMWdCNkJn?=
 =?utf-8?B?djFCVmI4L0VmVGxCeXQ2NVFlNSsyUXR5WkxoRXBwYkhjUkREL3RPRkRMWHI0?=
 =?utf-8?B?Z2l2WG1Ka0FjR0VOWkpTSlNOK0I5bzhTL2xHeVlwRXdZQlJ5MEhqdklTQ0I1?=
 =?utf-8?B?b0h3WmU2RWJXUUNXNUlXNzh2NnN5RENxZ0pKbUFNR3k2U1NZampxKzl5dXAx?=
 =?utf-8?B?clNPbm9BVXNLcGFKYy9oV3Byenc1dmJ3WC9MQysvbXZIUUw2VGZSdjhhc0N4?=
 =?utf-8?B?QVArVFNQZEgwOEFoRkpralBjM1FjZGh1b3hmQnZjY05kalREbkFSbU9OdmhJ?=
 =?utf-8?B?TnBhQmY4OWdrWEhiRGRwcExFKzB4blI4dkcvbEREYlZNZE5JeEJXdDVpSWdl?=
 =?utf-8?B?RTlMMEkwbU1KMXZKS1pETlpmTXZyTkdNOG5MVVBpc3R5YXVUYWpkanRLWUVs?=
 =?utf-8?B?UWxrcnNFeEdHUE9STkVPcFcxTE84MjFKa2oyS3JtaW1IWHc4cVFnd0psc3lO?=
 =?utf-8?B?eXZlUFE4emRiWTRFTVpYVWhhS05BbWR4TzRwMGg5ME8xN3pETUE3YysxbTVF?=
 =?utf-8?B?T3Q4N1RzWTJMc0RyZTg2M29UQklGeWtzRStjZ1hhSWQzRHZSOGtPMm00dlh2?=
 =?utf-8?B?T3JvYTY2T2hxTHExZTUrTVhRY1VraHNucWZRTnVPaXFLMHY1dUpDZUJFRzAr?=
 =?utf-8?B?WGhnM2F3WUVRMHlSSk1SVjJUS3JTYzBNdjI2OEsrakdtckkrRFh3VzhMOXdq?=
 =?utf-8?B?c3F6QU9JZzFqYncvRVF6NFpkQ1J6S3kzNTVSKzZCdjFpK1BRTXhSaWxwa1ZM?=
 =?utf-8?B?ajFsVDIzOXl4M1hFN1hrdzZscG1kSUdoeHRDTklLN2dnYWFFVWwxYWdHaE54?=
 =?utf-8?Q?ZNNjKL8GPqVoUaXa9l58VJunv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fb3d36-2ccf-4bcc-a36a-08db055907eb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 20:06:54.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LVcuBpK1q4HtlOY0h75XoyeBmMwhMuvdIuQGLdNHsR4I1QutAYeBwR0DCSUyY7kTVj4Uv4ywE38GtglELQNPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 10:05 AM, Jakub Kicinski wrote:
> On Wed, 1 Feb 2023 17:29:59 -0800 Shannon Nelson wrote:
>> Make sure there are qcqs to clean before trying to swap resources
>> or clean their interrupt assignments.
> 
> ... Otherwise $what-may-happen
> 
> Bug fixes should come with an explanation of what the user-visible
> misbehavior is

I can add some text here and post a v2.

Would you prefer I repost some of these as net-next rather than net as 
Leon was suggesting, or keep this patchset together for v2?  I have a 
couple other larger net-next patches getting ready as well...

sln
