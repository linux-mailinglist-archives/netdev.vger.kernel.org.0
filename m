Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F246C46BC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCVJnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCVJnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:43:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F2E1BD1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JclOWY9+XcXeepQdidxPEr7tmlHClcgTYPNwhpGY060wMUq9WtSp8twXb5Ewl2L+dYAg77SlAVIIQaSC45sBmkHEou25C2kR4cs11A1ufJHNBFc6uP8yXY0/nWiZDo/wW8qD7JN9ai/PsBbbYHra0ijdrV14wzkf0dKvbudq4G8iKMl8vOMpuHh6FTOjMUU4BREnmmTQyy+adIZbSMfiiP7mlVyQl4nKHbPP2RPu5/Euu+6CNKl9yHXbq35VTgy5O9P4OAeKFSENmnLjP/pUqeJjIh+QLXMZh8vZpRPjxHTtL/1KRqdqqsnuDve+AEEOa8fMtuAXwrD4uTAoutW7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6GhOarx4JZFnkI7Fbw7g7/4XW8KNBdFCniqTNqZh70=;
 b=WB4riQjBLpcHfHUKgmOYBmey16knWqqf9blYE0Jo7zMpcNQyQdbS5AEC/jW0hFXS1Dw8LGi74WltTHgisoK7ioxGv3vRcKZdlGAl+0adz1QNBu7CADsLgW1YlFygEH28g0/6OHKDNpeeVOMu9gIA4ovF2YkDziRLOi+Xn8D0mBa4P/O0HQRnYMpkID0VXusdXnFmrjBjyUN/12bAnzvasK05rQ7TQxiJ3bl7zqAdcgnthuo8yeRr7iEOYHV1+1hnfuGT3hG3lVpXGNKy07yReD74AWfBWbH+2rChWPCqSlYnGWqoquieJNJxdOGXnMcU8O5aaQvUrXKYJSva+neewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6GhOarx4JZFnkI7Fbw7g7/4XW8KNBdFCniqTNqZh70=;
 b=oppNuH8bIMgJpUyNaTlCSl27ixAsjQpGYvKZFeNQcTzH+dUQKxfK/pUba4OlgwTUbITIqSFnyPmB8r12EI6YpSgHMIbyIeRuWeih5Y+LOLM9rZVIRgPyQoV1MOLJ/r+x4z5ezChqHGHE6rvSEa6rT0czF5AJ/IuZC8zMmJ8Pw4nEkxHPUjRJu2g6QC2mRt+aH6sTlG8hX0imlEztBGwWKyTsTWOmzAqXY3vEKVFXvyGtl2z14OdeNzsbwBShRtSvyxV1yQtSufO1JIzeneO/M3BtIjN2UaI3a6JXle2CrkEHRLLVqEqO2QXTNi9I8gYLvW50wb/bizN2jnCbdZV8Yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 SJ2PR12MB8927.namprd12.prod.outlook.com (2603:10b6:a03:547::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 09:43:15 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 09:43:15 +0000
Message-ID: <a0775e23-56dc-fe0d-f9fb-91e421a596c1@nvidia.com>
Date:   Wed, 22 Mar 2023 11:43:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next 01/14] lib: cpu_rmap: Avoid use after free on rmap->obj
 array entries
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
 <20230320175144.153187-2-saeed@kernel.org>
 <20230321203836.5ab4951e@kernel.org>
Content-Language: en-US
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <20230321203836.5ab4951e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::18) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|SJ2PR12MB8927:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae11fdf-38c0-4014-14bd-08db2ab9dbc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSkXcV3U3PGiyhNtbon3Npvn0LJXK6KMhUnXVzXSm+BCcyDQ3MqyEWZimq5eKUmSySLRrECIhDkYWlVB1xQdKUSe++Y9Dqi4yPe+vOICLDuG/QlTPsg+4MPQARyp7bhVw7eTbB/OTKgr0rrIZaeSX/DuZqbw4y1yB8E3t9ke/6WPTwGt1yEKWjMzcl8LBFAw6jNELAm3q4FHNP4wENTz6/rZU/3GXNEHeHbuF7bb2nJLJpQCB3/EsnddQTwSFRfopDH2G/8KtVIA60+8wS9UL+loSbV5Kgo/0Fyr+vM25ihmY8zgwNDdASBn03JcySptqkF0CivZ9exmtmfY1SGblrvKo2iITuHBKvuoqO+VexVEWir63atpZuRx83RZyc1eW9DG4e2doGakNIwEhQgO4oFQVtZrAQDDozWH0ZBcEVaCg/7jUC8nolHjV5L5mZCDwOg+1nqQWzmyzgiwcoyRo2QWaEaYlmvgwTtx08mxBecJFOTJAH4ePG89QkpuztPJmGwvYYs0Dos4kS7i2vFwOe02dTO4njEI5GntJ3CUIMlpBPYIAfZuq2WIMqp47LFmAJseUWAZsqCsSjAbVV7sQsLCkAZqGwRWlNyQew7wHaHIJ1fnPVj/dNjCEOySqrx810N2p/6IhAngmTcfhxnatZ6z2kh6bpNyizGebpLYZrwbAKIFMVOJMamp+E9Y/So6QAu6lxNQ1IODKYFx622PlBusYyzkL9RTdQogXujTXq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199018)(31696002)(86362001)(2906002)(38100700002)(41300700001)(8676002)(4326008)(5660300002)(8936002)(66556008)(110136005)(6666004)(66476007)(6512007)(26005)(53546011)(186003)(6506007)(2616005)(66946007)(107886003)(6486002)(316002)(478600001)(83380400001)(54906003)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czBCWm94WFQ1aURBWDhma1l1dWFualhFR3h5SEtjU2pxSEVpUytJT1pBSkFX?=
 =?utf-8?B?TUlDL3MycjErV2JCeG5WRFpWdTBab0NxQWYxS1AxbzAyMTMvUUhlQVl3T1pW?=
 =?utf-8?B?ckdZaDZNMkswL2FXLzZrYnZEMHdpNU9DUW5PYXhZRGNYVjJVVXVaM0p5MTJI?=
 =?utf-8?B?THJYT3Nvd09lcG9pNWlTZ2phRWV3NHFkc1N4NFBUdk5GZTBKVDZTT3UydTZM?=
 =?utf-8?B?RGtTMHlvTUxUMVkzQkxVanVzZ1BzVElsYTh3QWVmamxXS3lHMlZqWUUzMjdy?=
 =?utf-8?B?S1dkQ2VUUVVmTk1XUjdnUW1TOHgzdXI2VkJwYWNjT3A1ajNGUGVxdmVKWVhl?=
 =?utf-8?B?Y3AyRFA5Z2FCcUlnY0tGSmNKVFJGZE1jR215M2pPZWI0Y3JyczJLUndZWElM?=
 =?utf-8?B?WVZJemN6dlhQMlJmQU1nWlJSQVVUWlZjcXRiRjdyeGxaa1puYWYvWSthUlNa?=
 =?utf-8?B?bDh6OHZqTFhFb3NYYktFNTlLVG8xcHFSM2tCdVZwSFZlTkgwY1BYcWNhY3R0?=
 =?utf-8?B?bEsxT1dWZVpwOW41MEd0VVpnL1NqN2dpaTdFSUQrVzZkQkpNa3dMbzFBMjQ0?=
 =?utf-8?B?R0MyYlNZVERBeUxQcTVHMTZsSmN1QUltSElNTDlVbWhxRFozdWovOFdYc3Q0?=
 =?utf-8?B?TnZ6akVFVE9oNGNuYlkrL2NjUTY1TDR1L2hVZmNSQmx4ckUyNjhLU3ZTT2dw?=
 =?utf-8?B?bkhzSUw5RlFBUTBZM05WbldpRTdadzAxT0p0ZHZtQ244VjlmS20wODJLdnow?=
 =?utf-8?B?TXkyYk9sSFZvVGRsSWFFWXJYc1ROMXc4ODQwVmR0WmRYQkVUdzg1TnkwQTdo?=
 =?utf-8?B?UWxndC9KZVhwbkNTYWxkeHc3bHgzdTA5dDc5RE8vTWlMS2JBWmo1VXJpVVhO?=
 =?utf-8?B?cVFYK09kUWdVK2lhWkdJL09xQmFDMWFPVWw1Uk5QenlLMlZqSkpaSUMxMjFh?=
 =?utf-8?B?QkZPRHdVVlcxK0FOU3VaYjlOQkpCeWtzaERSVFM1VWxhZmJUK3JyUENOK0s1?=
 =?utf-8?B?ZC94Zy9zclhucUxFNkdzQklNT0NtRnRWRW1ZdHJHb1pxam91UTNGTUlvMEVl?=
 =?utf-8?B?YWZlNmNtZkQ1eTgxeTJLMEhWZjVpY3Bya1FRS1hyazJHTENzYndWMjZUWVRi?=
 =?utf-8?B?bm8rVVBpQnpVKzJMbWNpdHFXVG9sSmpuVy90ZnJ4bHhpNDJGM3VwdUNRSnZw?=
 =?utf-8?B?cXV4ajhtZVZ1MU5OODkwVzY3ZWIzSzBsSlAvTWtpaXFxV05aNWIyU3NLdVJ6?=
 =?utf-8?B?dU1KdkI1L1BQUkVzbFJEMEs3TEpOVUgzU1Z2RkRwZ3RvaktBcUZkeUNqVThw?=
 =?utf-8?B?SG42TFgwbzRuaHJ5UTVmeVYzYk16bFRURHVYRmlCRmkvTW9XRzBhalhBaU1R?=
 =?utf-8?B?S2h5S0UrY01obnJQcTI3SFFyeUMrT0pITlF2UEo4WW0zOE51bVFISHhuVGZF?=
 =?utf-8?B?c3FYdFRaK3VUM2ZUbE0rZTJzY1lYdFZwSTQxU3h1dGVZeXMxUnh0bXY4bHgw?=
 =?utf-8?B?RU9hbC8xaVJIU01FNlFMejNyemVGZjVaVDlJbzB1TUhqbTlmRlh3NVJObmZi?=
 =?utf-8?B?UnE5NXVvNXlLaFhTTXFzNUtWUXFNbWtKeVg4ZHdJdUZqenlJeHdYcU4vRWNl?=
 =?utf-8?B?RU8wejUyMm0yNHhRb0piSkFLN0ZaaU9HRmFEYWtiS1EzRTFwWlBMdUZZdm8y?=
 =?utf-8?B?Q0lMQWxGYkhNRFpZeHFXMmFnakwwbnhQZGdGeFB2WExTZ2NWUUpiYWdNSHVj?=
 =?utf-8?B?dHUzeTB0eEJUNXJqdVY3Y0QwUng1a1RJbmxXcDFtM2hzVE5vcm15TGVqYmdn?=
 =?utf-8?B?Zzk3eTNjVTcxTC8xcWxFdVVLcW42cVVhRkowa0RlSHFVK01TQzdud1puQ0VY?=
 =?utf-8?B?UDJJcmVZOVlESDl3Ly83UDh5djdVV2R2UEZ2a2Fwc2RHZW5iSWdVNTloMXZZ?=
 =?utf-8?B?R3ZUVWNHQ0crN0p5M0grRy9aNE9oL3FhY2lWYUpYa2pod3cxdW5McjlIS3FD?=
 =?utf-8?B?Q1lKT3p0bjhmcit5VVg0QnpQSnkxdDE2Nk1ZQytTVWE3YmNXTFo3NGFQVHJJ?=
 =?utf-8?B?TmJqSmRaSThUdzVOV1kzakF4R1hESytzVDY1dTI5Y3RRWkRmVU5vdThxN3E1?=
 =?utf-8?Q?6MZmmoH44uBdcIPDsGjIjG8h/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae11fdf-38c0-4014-14bd-08db2ab9dbc2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 09:43:14.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rY2AsNpX3yOjs0E2m/lC5NfMbtA1fOFTjEpxFyZtKbgLjP9BTixGnzxNj2T1GJCW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8927
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/03/2023 5:38, Jakub Kicinski wrote:
> On Mon, 20 Mar 2023 10:51:31 -0700 Saeed Mahameed wrote:
>> From: Eli Cohen <elic@nvidia.com>
>>
>> When calling irq_set_affinity_notifier() with NULL at the notify
>> argument, it will cause freeing of the glue pointer in the
>> corresponding array entry but will leave the pointer in the array. A
>> subsequent call to free_irq_cpu_rmap() will try to free this entry again
>> leading to possible use after free.
>>
>> Fix that by setting NULL to the array entry and checking that we have
>> non-zero at the array entry when iterating over the array in
>> free_irq_cpu_rmap().
> Commit message needs some work. Are you trying to make double
> free_irq_cpu_rmap() work fine because of callers?

Some callers may want to call irq_set_affinity_notifier() for a specific 
vector and then call free_irq_cpu_rmap() to to free the struct cpu_rmap 
allocation.  This is a valid scenario as both 
irq_set_affinity_notifier() are exported. This sequence. This sequence 
of calls does not happen in the current kernel but my other patches in 
the series do.

I will try to improve the commit message.

>   Are there problems
> with error path of irq_cpu_rmap_add()? I can tell what you're trying
> to prevent but not why.
No, as explained above.
>
>> Fixes: c39649c331c7 ("lib: cpu_rmap: CPU affinity reverse-mapping")
> What is this Fixes tag doing in a net-next patch :S
> If it can be triggered it needs to go to net.
It can't be triggered but with my subsequent patches it could.
>
>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   lib/cpu_rmap.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
>> index f08d9c56f712..e77f12bb3c77 100644
>> --- a/lib/cpu_rmap.c
>> +++ b/lib/cpu_rmap.c
>> @@ -232,7 +232,8 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>>   
>>   	for (index = 0; index < rmap->used; index++) {
> After looking at this code for 10min - isn't the problem that used
> is never decremented on the error path?
>
> I don't see a way to remove from the map so it can't be sparse.
This call, irq_set_affinity_notifier(glue->notify.irq, NULL) can be made 
by drivers.
>
>>   		glue = rmap->obj[index];
>> -		irq_set_affinity_notifier(glue->notify.irq, NULL);
>> +		if (glue)
>> +			irq_set_affinity_notifier(glue->notify.irq, NULL);
>>   	}
>>   
>>   	cpu_rmap_put(rmap);
>> @@ -268,6 +269,7 @@ static void irq_cpu_rmap_release(struct kref *ref)
>>   		container_of(ref, struct irq_glue, notify.kref);
>>   
>>   	cpu_rmap_put(glue->rmap);
>> +	glue->rmap->obj[glue->index] = NULL;
>>   	kfree(glue);
>>   }
>>   
>> @@ -297,6 +299,7 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>>   	rc = irq_set_affinity_notifier(irq, &glue->notify);
>>   	if (rc) {
>>   		cpu_rmap_put(glue->rmap);
>> +		rmap->obj[glue->index] = NULL;
>>   		kfree(glue);
>>   	}
>>   	return rc;
