Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB70B4BC24B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiBRVqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:46:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiBRVqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:46:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04BE1A387
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:46:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/SoxZddqVd6EGpwI9sUE5PLQljgclFn/wk3oWJXsUPemsRk7ikJcoWpOshVhBkOZaf6J9z4t/N73Pyyg7DwW2TU58l4io9DH1IBeQmCiQK4xH25PNYb4NU9SdoxQ72h9dPHiUxMOJ4ULsz5ZEzpdKtNjVG/cFSi4th3bMjgAH9+UZ6iZT1V1FWOIaq6hPV3aSVGs0O8ACXKz4hdo50DoK5qNoFhoVk+G98UKZuduHe6WYVkPHmn2Zk45o0BvbBtjYjbpw7Y1lG8lCvPeodRK4jRhseYfb+1BYko6shy5Cow/PPWQw4IlOHhbMr8srYyhSouz/lLRawEiZr+ELyRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NscoPkHeoa2hjeQ3czJiWFtd6UeePP1UyH52KQCvH1U=;
 b=F0qRYvoDItO3F0faRyRTqZ/Wk7E037FK4CO7DPZNWsf6CUtEHmkQ1cBN6WcMniPDgCSsq1+A89PYw7Fv5YVB1/kAycFTYKxoq1AuEnL9FVox5o6qieqIAXI7n6e2Aw3g3s3Q8Zq+bmMGpZMmN6r9uyqEkKDc5DqQZInmHDlzuynBP7lbRESSNIiDMt0fb4EAFcG2sIVTAwT2nh6Y8Wp2p+O+TFpfiZJwKEehKkmahANkebJE2f+Ea3A9PaefY05wB5R1p1Uhp3VPB3S0P2oNWpZDKNx86F+BR44bdhSfH9/Kdz93DKhhJ2Q9Y4kxWneyUftyLE4IvN6HYmY24TfBXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NscoPkHeoa2hjeQ3czJiWFtd6UeePP1UyH52KQCvH1U=;
 b=zQAyPTmepk4KNDxRrAnH1Z46r1uJTlUqrYNsfh4Nd6kY/FRKcVTUPROBZ09bV+dD4bHPJC5ijrfb2z75ZHFu+VuIh5PE5ldS/ONm6UTOCerNsq8mtfUGQVKEMYFWgylvAq+ujvkTzze/d0sKdj1cm7oblhCOp8SaHkntJdHXh2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MWHPR12MB1743.namprd12.prod.outlook.com (2603:10b6:300:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Fri, 18 Feb
 2022 21:46:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6146:8d09:4503:cb49]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6146:8d09:4503:cb49%3]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 21:46:31 +0000
Message-ID: <fe2afad2-e167-57a0-91ed-86da256c7f8f@amd.com>
Date:   Fri, 18 Feb 2022 15:46:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>,
        Anthony Pighin <anthony.pighin@nokia.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <b21d35da33357b20ece39c7892f57084b94c017a.1645214686.git.thomas.lendacky@amd.com>
 <5cf6cfc8f5bc4808b37e21fcfa7cafc7@AcuMS.aculab.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net] net: amd-xgbe: Replace kasprintf() with snprintf()
 for debugfs name
In-Reply-To: <5cf6cfc8f5bc4808b37e21fcfa7cafc7@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:806:6f::8) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e568362-d9e7-43a9-05e1-08d9f3281fd5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1743:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1743A406BDF695D683C481E2EC379@MWHPR12MB1743.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SVXjkTilaMieK3kzRjvLC7hkmZs5Rnx6WLOWSF9r/8YXd87YiTjDdNuPhjGQBwwZLqrSzI7v/HPglDf8e9yXip9iGhPdm3M+ZB2ZKHWFgSCRFdtDxtMQqnbLD3+oZFRYiwjEb36Kke80Etyap1YtUGp6Sk0FdvLveo7lhmag6lK6O2kA/E7FGoxwr3IrWzIzX7R5p0N1z95WBltSzJ4KUuMDhK8tlBNJT4rw2YJSa3GZsiCU46NQtB+nvb0uWEXUR3VBKC35t9nV8RYpyH9kmdGpEwAWa3ZX+aTu6/s6sn3UmgKdK1Sp95xGyQVEukx0k82X9ANVcb+ZJnxN/zh4nasjcWAcx9igLOfb7kUEKOMCscnx4aweAybQ2ZKw0BJ+jryKKdxOlTqv+pa53xAMfRynTIxbn5yZJWaz3e1p0818AhauwVYP/aT8Bu3035D/TAIF7Key34cwnd5xWvMWF06lOhC0dWdxPA3ESQJL8rCPoDw+mtHB5VyolZeNqEELipmeuEvu//rEPyznvFQ2PxDL7uqJtbZV9RseV2m50CHSh65UfjqxIm93KqE8/1zjRxWLbUMOzC1Kfff2e93Q8Gc/US9DOZfuu3DCP9SBAlARBqHJvXnSi2gs6gUGHzU3JxmOxxPPcQOsohlGsG7FzTgaSoFif0tlQjaAG3gSE1tDAyWG+a56QOYXFMXIy9VgBOnohXgP5pHP/LhR23fZixJuUJyLLoS5mHNpH3s7I4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(508600001)(53546011)(110136005)(54906003)(6666004)(316002)(5660300002)(38100700002)(6506007)(6486002)(36756003)(6512007)(2906002)(66476007)(86362001)(8936002)(2616005)(26005)(31696002)(186003)(66946007)(83380400001)(4326008)(8676002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTYvc3ZWUFN5WjR1aGExK3VwZkhtQlJZTk1PN05rNWJPQzVRMzI1Z0tONVdH?=
 =?utf-8?B?Rk5UZENkRjd1MUhMYklHeUZEVHF2Q0RDdi9RQXJXekdMb0Z1L2QxNXQ5dldo?=
 =?utf-8?B?NUNYeGR4T1IxamJkQVNmV1NHMFFMclBtUS90dmVSaFBPdTlJOVk2QWFBTnBw?=
 =?utf-8?B?cnBuRW40VDlpNzdRbEYzZUJxSFpyZjVQNlNWTmZJa1VKakxGMjV3d09HMWZX?=
 =?utf-8?B?dUhhdGV3bDE0cmQrMUVRUTFWNjJtbkU5cjBDK0U1SE5mdkFDRkh0M2x5dmo0?=
 =?utf-8?B?RC95ZG9tckVLK0xnTDN0U1lGbGo0RWJ6Ni9aQ1VqRDFCM0xVSUVLL2Rnc0E5?=
 =?utf-8?B?U0JXa1hmNW5MclZBTkplUlFVcnZZOGdXK0ZXOXlYNFVWR293NHBHRGU5QkY4?=
 =?utf-8?B?S053azZDWVJ5bXdxT0MybUJaZ3grcjRvZkluUnVON3FRZlhhM1I0aTIyOE5q?=
 =?utf-8?B?STRlZE53ZytsTW9xTm1Hd0hBZjJjbWQ3SHRoMTZFOHc0em50cWV2NTJNSFlK?=
 =?utf-8?B?Vm5OcDdweDJ5ODFBRTNFSCtRTUsxMWwzZGNrVjdtZUV6VmpESHI3YnhIdFBp?=
 =?utf-8?B?Y3FuRXZINnl4YUZXazFobDVKRUNURGowNmtEcC8yM1lHbWU0TlZTRThtV0Jn?=
 =?utf-8?B?elErS0tvQ2ZwYkZ5TUJRUkFvcHEwTnF0ZFg0MzRpN2lVb0ZIRC95U1ZKYTJq?=
 =?utf-8?B?L0tJbURXTk10dzNyWEI0UWpEZVArR29HWU5JZHRrbWdCRXZWbEFsSDUxM2NV?=
 =?utf-8?B?eHVyTUUrRE5adEE2a3lJWU1tSmNZMitaY1g0eU5rblVTTWpRSHQwN1UrN1J6?=
 =?utf-8?B?Q3o3UzJaNTd6d1JYV3FvTTZDRjRXVlVkNGd6YnRLWEM3bEthaytOMFYrbnFs?=
 =?utf-8?B?elZYQmpEY0hOU1ZzOXdBUkRZQ016aTNNdmJQUXRjdE8reEZyV2h4dG0rMWth?=
 =?utf-8?B?MWlXZHNabXdXVmcxczFyaHJ3QUdGZWNuSjZpdHQzZGhGOUhyaHo3b2YwdWhH?=
 =?utf-8?B?UU5RUjBQN2xpRS9qeHdyeUlsUHljVUpMRzd2MUFJMmExaU5ySCs2N2w3OHFi?=
 =?utf-8?B?Q1RPLzRuYVpUM0V3MXhZUHZPY0FyTlJ3NVB5M3lUV1pmeHEyQWlTQnd5bWFB?=
 =?utf-8?B?d0hnSi84cWFGT0RlVWVpUFlZakJxWmoxdnRURmwrZ1RmNHd4Z05YMjBtcWxQ?=
 =?utf-8?B?a3EyeGFnN2NxTEkwRmg5dDBxZjNmK2VCRVhIcDh4emtwUlp3VHJtR2o5S2Rp?=
 =?utf-8?B?VXh5S2tuMzZxQXFFN05xZDl4R2o1d2pMR084Y2d0c1JOeDlWeldTSFJrTnhm?=
 =?utf-8?B?SGRQUVJOdk5iRjlDSkxXV1lWZ1hpZG5lNE5tbXVLN1JrNUpxN0JQR0UxZGY3?=
 =?utf-8?B?ZndxNlhzZkh5YndlVGpac29JazkvMmZIdk9oaHVvZVltdjBjUmFYcm04c0dE?=
 =?utf-8?B?QW9IaEFBWHoxZVd4MzMyem5kZHVCNFlPcVpaWjdTbFVGUkJxMVh6aUNqbmdo?=
 =?utf-8?B?YldTZ3Z4anE2cW5xK0IzWGt6aDhMQnlsWDhHeDNmUzhjdzFlRVFBY1luYjhP?=
 =?utf-8?B?WUh4c3BLSTFNaTVLc3pkM3E1TDA0cTFMUFIvMGlvY3V5djNqd1puRGIzbDNB?=
 =?utf-8?B?OWtMVW5ZSm8rNmFzVnMzNUd3UzBOdFVFcUY2aGdUT2hrRVAvR3orVEdvNmZ3?=
 =?utf-8?B?cU1vc1ppOGtGaVpKYi9wWUJhU0xBK2IxLzM4NnlKMXVWVThNd3ZGbzNHTHcv?=
 =?utf-8?B?Y0dCZ3VnZ2pTcnJOeUQ2a1d4dXdHMkxyRzlEeFhHTk9qRHQydVVTaFNLS2V5?=
 =?utf-8?B?ZVB2ZUJIYU5qeHc0dG1tejUrQ2UvTVhENFNob0JVSkZaK0FDeWFhcm1iQ25r?=
 =?utf-8?B?SjhkcUxKL2Y0bHdWd052bWpEeGwyUFdJM01aNVhEWkxFNDFva21PVG56Y3JP?=
 =?utf-8?B?RDVJSE1XMUNkRzlZOXFldThwNFF2NHpVeHBYZHZPeEZaUnIvSWFSUi9HbXl2?=
 =?utf-8?B?MnVqa0ZzTytTOGFqTEZaUlFHOU93ZG1jN3hmd2dpOVM1ZXU5MUJTRWs0OTBN?=
 =?utf-8?B?SjVhSzBjaSt0T3pHUWRnOS8yS2MvRUU1TDhwR2dseE1keHpKZlNUbDFvUHky?=
 =?utf-8?B?ZXlsaklWdzZwdlh5cituRmgvMGQxRnM1NW1JME04YnlZWXo4RTRNWldJaWxr?=
 =?utf-8?Q?QbwXHL+64kc9fXAtfY7/9tk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e568362-d9e7-43a9-05e1-08d9f3281fd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 21:46:30.9962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/iLEREBy5wLaMWRdkCz58p9wspPQe2LqzHj9gOt78/dH9k27vaOecPF68wyWH19G8iyiMFzo5zLWlAx246nmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/22 15:01, David Laight wrote:
> From: Tom Lendacky
>> Sent: 18 February 2022 20:05
>>
>> It was reported that using kasprintf() produced a kernel warning as the
>> network interface name was being changed by udev rules at the same time
>> that the debugfs entry for the device was being created.
> 
> What was the error?
> I'm guessing the length changed and that made kvasprintf() unhappy??
> 
> ...
>> -	buf = kasprintf(GFP_KERNEL, "amd-xgbe-%s", pdata->netdev->name);
>> -	if (!buf)
>> +	ret = snprintf(buf, sizeof(buf), "%s%s", XGBE_DIR_PREFIX,
>> +		       pdata->netdev->name);
> 
> You can do:
> 	snprintf(buf, sizeof buf, XGBE_DIR_PREFIX "%s", pdata->netdev->name)
> 

Thought about that, just decided on the double %s, though.

>> +	if (ret >= sizeof(buf))
>>   		return;
> 
> Unlike kasnprintf() where kmalloc() can fail, the simple snprintf()
> can't really overrun unless pdata->netdev->name isn't '\0' terminated.
> Even if it being changed while you look at it that shouldn't happen.

It's a safety check, it doesn't hurt anything.

> 
> 
> Don't you need to synchronise this anyway?
> 
> If the debugfs create and rename can happen at the same time then
> the rename can be requested before the create and you get the wrong
> name.

I thought about introducing a mutex or semaphore, but thought it was 
overkill just for debugfs support and this small window. But if folks 
think it's really needed, it can be added.

Thanks,
Tom

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
