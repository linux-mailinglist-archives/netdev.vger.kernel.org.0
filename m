Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639C5509CC1
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387830AbiDUJuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387823AbiDUJuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:50:22 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAD725C7F
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 02:47:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGB0YudgZ/+UCZGf8hiefnMAfac1yipmYoZYA500oEH3ubwOizW4aiPoWfFA6Bivs2GNtK/093EZHewjwX25p0qfThS6CRysW+GbeKohB7ah3T28KsnlUZoyLS70aqEppCV/0fwf0tQoHyqnylyDv/OBgIRN8RVdeRnrB9uUEJTVH750S7dcRy4SSAnYKox2e/U5ZKrBMbni2Y43Pd3N6KGKzsjSd5EITAT5Zzwkgeykb2j6LkWVasFzULdtqTNR4oAxLu1E/BcZQold254sftUavB3Fu+5CJAyFWgWpP0Xhej6YKDZrrvDgqrdjqREX/rk6RSXYP5y2xh3YTlG8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgPIUjdAeHJq3IAkp1YmXuFdonL4vFCqBIPMCCgxQUY=;
 b=mXb6mChH6Zwg9svUtNmf8SUOMqtkH/3090YN7p755/hk25JogTEFqNk87G/WG+aXf3fJ4Uq/NZHz+lVH+X5llBjhx7MKBLfKJEPScZo1sgN4Q1YscwRnjM2cFKp9b20WSeKMW0q/+21dAzSdaFQ0JTtBoGMHV4E2D2yFMT4uo1rIjInrAVbxgOa0tkQisQVFruZTpwW0ObHZBTvGV0UssBYxnkuMYIw3KyaNNZe+8vqim5DgYRiQgdy3atFVNMfBQZlnV0oM3lPeKz4u75WEBmDCfTQBHjrBzM5l4fS3FyT3rJv9JlNU2omoxbV+eVxHqcVeN5Wcihq0r3miJXHArg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgPIUjdAeHJq3IAkp1YmXuFdonL4vFCqBIPMCCgxQUY=;
 b=f9avmw31ec1Pnq1rX7Ev2u/tsUBDDfyCirrN9lUoUoI6MOTm0awj3SCFQyD14FFNc9fY8rsmQCQYUWvpyfJlNGQCckwC3wCmfD+RuYyOUIsiQVN1lhmeS3svSIdP1EnmveYjvwu4dusrkLJqFmApRtD3PTXSlI6U3Wc4xTlZP3W3R4gfErdMcHqQ7e7WEOJvXKwVotkqDxxrw2zEigDcTIH1dMpiLOBLCRSQbkaiczlES9l0TL3iLFptn0dTCmMfV1sAUI1Gso25xDhYmUlRCoVcAfSINgxyIxxJT2XFGLOL0rEEQtxlnHzJr28ZaGLacFGHRYLBxK2g+wWXVfeOgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by CY4PR1201MB0086.namprd12.prod.outlook.com (2603:10b6:910:17::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Thu, 21 Apr
 2022 09:47:31 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%9]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 09:47:31 +0000
Message-ID: <da984a08-1730-1b0c-d845-cf7ec732ba4c@nvidia.com>
Date:   Thu, 21 Apr 2022 12:47:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] tls: Skip tls_append_frag on zero copy size
Content-Language: en-US
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>, netdev@vger.kernel.org
References: <20220413134956.3258530-1-maximmi@nvidia.com>
 <20220414122808.09f31bfe@kernel.org>
 <3c90d3cd-5224-4224-e9d9-e45546ce51c6@nvidia.com>
In-Reply-To: <3c90d3cd-5224-4224-e9d9-e45546ce51c6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0445.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::18) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67cf8e02-5ca3-4ec6-c01d-08da237bf3ea
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0086:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0086EAF9546D99D6218F4768DCF49@CY4PR1201MB0086.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fWcEiuYetRF01wWPmTGjeWJBfQj1MeB8nKHaZvk9eLeABLorO5l3n+Jil6zlLhXQVbrhTOVYUzOZ7PWp6Sl9OxFvp6q+Ew9puIcuwwb9aN7T6Ijcq3L77+dKzliB51jzGVuvyC0QaaQwGPYttN6x8KOlCZZ/Zm8//ZceeSZWLiE3RrQM7QA8QrTJSLBC9ywruI+XHIgCEMbXVd1lXwtKeW5imUR91Qe3SeaEaKDGL1ww5K/E1mWCaNcgFwNSrYnDnTIgtk3YH+B/DtvDjp+GCU+ESJcUA/fFDp1Js22MI3r5nLGrqDQ/dgwbSPQ67nyXqNyMjEBv24X8YXR0wLn/0D+IadjFNYBlrq5ioVmOTtyD1zpFeXXkYrWtnnWt6wC0vlqBNTW73pIQK/Zsdvb4BR936b1rJegBX1NN7UHZJvHC4jU95IVdSVfJExa0hRN3B/sqpaz7oexr8t6y1Wt8FrrGyyoIXVf6rJEOgt5Zj2OMlL0fYvyllLgiaOSytBT8iyxvCIAoOun7FR/3/qvg7bgRbB98tAzFvqQ1U3zHuM7F+zj1cthMzBcdrT9FnxJt/pD7+CpCf9ySTOMeQVFE79IqK+h+dg5Cz9AmRRvRfpZHNaP51BgjJJaXhYyLm2JIPoBcavweGn0G/8b47ipQ80e6Jb0iBJ1XkTyxvwpTt6We8canxHD8UN8kNHHrRHwcprOXo5SbkuK4fpzgfuPX0M66TSBPiUEn5ymVUV9Ab8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(36756003)(6506007)(83380400001)(53546011)(31686004)(6512007)(6916009)(186003)(6666004)(26005)(54906003)(2906002)(66556008)(66476007)(508600001)(2616005)(8676002)(4326008)(66946007)(6486002)(316002)(31696002)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjhGNjIzbHRjcmVUMXNuM3JSMHpoV1RxMFpKd3FKOXIwbzQ2Z3NXSWNXK2Q0?=
 =?utf-8?B?bHkxV08rN2FWNnlOWVZxdzQ0SlljRy9CMWcxck5qQmQ3WGREN2p4VmdwUWNm?=
 =?utf-8?B?ZlBwTGRQTmFFRldac2syUTIza25wK1J4Q3cvQit6Rml0NTdOMjZVQmI4Q05W?=
 =?utf-8?B?emttTE9RaStIbEJPZGViZ05HbFFSSUlBT0JIODE1SCt4TUM0Y2pyTVJSaEl1?=
 =?utf-8?B?Y1dCeUNTZ1lIeU4wek9FTHVGZHZ0b1NLQ0dwSTY4ZzRLWXFBSTVjajRub2Z3?=
 =?utf-8?B?bkhkMUNwdWJ2dWN6dERLY3dCOXEvMTgyL25sZFpnVG1wblkrNWhxeHFIN2xt?=
 =?utf-8?B?ZDJyL1JmWHVicE5HK1VlRy9oTTJiSUl1d0dTRlByWTRqZzZ4MS9YTHdRc25m?=
 =?utf-8?B?NWdlcmxVR2N0R21NYWdVTlpKSnpvUVkwWitjU1hGQ3l6NnJ3SzRvMEN2QUI3?=
 =?utf-8?B?MDQ5YU5VMEFWTGVQazIya1l1eUtZTjk3YUc5ejVzRXVYa0s2bHFNYW9TMzJQ?=
 =?utf-8?B?ODNQNnU0dFJNYzJqSEFYOXVIUEh4N202dHZrNG15TW5PbUdRNWtibEFMcXBZ?=
 =?utf-8?B?Y2dpZDVRc2c5RUFFWTk2OThEelRyWmU4dmd0V1RVK29aVU9VYTI4VHgyQ0dS?=
 =?utf-8?B?OXhtSDNNRVVBNTFkWDh0MDc2Y1BxOTNSY2pNOXdrV3hkbUF5QlJWakFTQ2Iy?=
 =?utf-8?B?bXVaZUMxRkMvWW1IMzRpWEVJZjZ0L0J4ei9Ja3FIa0pUVCtCYlFrK1ZoczNk?=
 =?utf-8?B?NFpjNHFkZi9ySDlEQkp2aE4wVVZJSmdJciszQ2M2cWRuSEx3clZNVCt5cTE1?=
 =?utf-8?B?djJoSGxPY0FwZFNuK1d3c3NLQnpORFlPL0x0SHFINkxOMjRXaGFldzJYQ0tC?=
 =?utf-8?B?VnZIVFRRTXBhSmtpTjh3cEd4UXYyZHJyVDVINzFDTmVzMXNnOHFKaXkwRnp4?=
 =?utf-8?B?Rk9jZWZ0VFJvRm5YRHYwbnNJUHBLNDVodE0yaGwrcTJwK1dyM0Y4ZG5YT1RY?=
 =?utf-8?B?Ynp4SC9mZ1ZuQzM1dUdOWFlwL1pzWU8wZnNYbVNrSjQ0M3VCWEpSMFdUeVZq?=
 =?utf-8?B?R0FhUzhkMXdLMXYrNXIwNTdIV1pId0hwaVFMNVFqTUt3SDE3Ykp1M2xHQWMz?=
 =?utf-8?B?d2R0NFJsWEZubUk2Zm1IVVpSTmFPaTA3NmVReDl4Ky84K0NZMkRSNFg0a1Zz?=
 =?utf-8?B?eUFScHF1QXF2VC9QUEpXbnloWS9NWExlbHpKb3dNUHk0SS9jdTFWMnVlbk81?=
 =?utf-8?B?eGM4cCsrNUlmdGtUYkw4a2dwUVJPMDRMdmI0RFdmQmpTcEErQ3hKV3JWbzYx?=
 =?utf-8?B?YUtpV0F2d09sK2I5dkRCWW5CeTdxZGEyeWp3dUlCb2I1Ty9HU3NYMGhUL0Ur?=
 =?utf-8?B?VE9IN24xQUI4c3djVlJYRnFNN2dMSVVXa0lrcmtPL3dTZUtnMWJrLzVKYk5S?=
 =?utf-8?B?dEFWNVBFbndYSy9wZXRleWRhT0dVYkNSS1lqbGUyMVMzUTg5K2l0OVV4QjF4?=
 =?utf-8?B?N0Q5bjJoamJoZkpLU3dOS2RJaXNiTUJKUVo0ZlhrN09OR2J6dTRQWU95R1hq?=
 =?utf-8?B?UVNTbldDNWNLNGR2SDl4WE4yWXVFeGgvS29RSE8rODhQRFpDc2VJdHhKUGcy?=
 =?utf-8?B?cVRNbzVFSEg2RGtGWUJ1b1RoYnlUaHdBcmxiSlBRUzBiYUJkSklobkZGR0NW?=
 =?utf-8?B?TDE3d0hNaWFMMW1BUXhrMmZSWHhOTnJTb2FldFlnTFVQTUJxWmJHb2xzWkNy?=
 =?utf-8?B?aCsrUXVLZmtRVE9ERzhZRDROWm5Jc3ZiQ1E0OVVMaVhqWGw3N2FTK2I3d0Ez?=
 =?utf-8?B?aGFObm5XOFdqRFU0SSt0VjhvU1dzUWR2aE4xTkt2M1liS0JSZXNDOGpZcHN2?=
 =?utf-8?B?dGsxV3RtcVQ5RDZJWk5ZVWxSbmluSmhGcTZGTEM4Q1FWdzZLK1BER3N5OFJQ?=
 =?utf-8?B?QkVWNzFhVlY0SGNqTkdLQjc0YWU0bkpZM0xYMEFPMTJ0a1kyWkQ2U3pzcGdH?=
 =?utf-8?B?aU96TFE5aDdVMU5JS2ZPSTF5c2QyWlNnV0hwa002dkpwWTFBdU16anA3aSs4?=
 =?utf-8?B?QkpUWUdjdjFrUDdWZEFYcFl6S2pFeEdEZFVxT0V4TkIzaEx6VDdlWDFBMHJP?=
 =?utf-8?B?SUZiNVlTZ1BBZEpqQ3o4WEREMkphd21GalBXb3JLRWgzL0V0Z09ESkhBNUpm?=
 =?utf-8?B?SGNaRmNsQitaaldxOHJPZ2FOUVpVTmJiZ1A5dDA3YWQzWThjVlRTcmpNNXFn?=
 =?utf-8?B?VlJqdkd0dU5XWlNGQXhGZ2MrZDlqdE1SZWZCZjI5NUJ1UFhZMWhaM0xhVWI4?=
 =?utf-8?B?Z2FyWlRaY092d000VWZXa2FFSml2WENsN3BnakkwOThQaDFVbE0vZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cf8e02-5ca3-4ec6-c01d-08da237bf3ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 09:47:31.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5B/prXOBm2BJaYzSP93DnZa6VG+6HUtJU5mbZWAFDTD2R7t/F2uQxVeTOcqgMLmm4cHXHqDZQ0Dh7pwWrKLxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0086
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-18 17:56, Maxim Mikityanskiy wrote:
> On 2022-04-14 13:28, Jakub Kicinski wrote:
>> On Wed, 13 Apr 2022 16:49:56 +0300 Maxim Mikityanskiy wrote:
>>> Calling tls_append_frag when max_open_record_len == record->len might
>>> add an empty fragment to the TLS record if the call happens to be on the
>>> page boundary. Normally tls_append_frag coalesces the zero-sized
>>> fragment to the previous one, but not if it's on page boundary.
>>>
>>> If a resync happens then, the mlx5 driver posts dump WQEs in
>>> tx_post_resync_dump, and the empty fragment may become a data segment
>>> with byte_count == 0, which will confuse the NIC and lead to a CQE
>>> error.
>>>
>>> This commit fixes the described issue by skipping tls_append_frag on
>>> zero size to avoid adding empty fragments. The fix is not in the driver,
>>> because an empty fragment is hardly the desired behavior.
>>>
>>> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>> ---
>>>   net/tls/tls_device.c | 12 +++++++-----
>>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>>> index 12f7b56771d9..af875ad4a822 100644
>>> --- a/net/tls/tls_device.c
>>> +++ b/net/tls/tls_device.c
>>> @@ -483,11 +483,13 @@ static int tls_push_data(struct sock *sk,
>>>           copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
>>>           copy = min_t(size_t, copy, (max_open_record_len - 
>>> record->len));
>>> -        rc = tls_device_copy_data(page_address(pfrag->page) +
>>> -                      pfrag->offset, copy, msg_iter);
>>> -        if (rc)
>>> -            goto handle_error;
>>> -        tls_append_frag(record, pfrag, copy);
>>> +        if (copy) {
>>> +            rc = tls_device_copy_data(page_address(pfrag->page) +
>>> +                          pfrag->offset, copy, msg_iter);
>>> +            if (rc)
>>> +                goto handle_error;
>>> +            tls_append_frag(record, pfrag, copy);
>>> +        }
>>
>> I appreciate you're likely trying to keep the fix minimal but Greg
>> always says "fix it right, worry about backports later".
>>
>> I think we should skip more, we can reorder the mins and if
>> min(size, rec space) == 0 then we can skip the allocation as well.
> 
> Sorry, I didn't get the idea. Could you elaborate?
> 
> Reordering the mins:
> 
> copy = min_t(size_t, size, max_open_record_len - record->len);
> copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
> 
> I assume by skipping the allocation you mean skipping 
> tls_do_allocation(), right? Do you suggest to skip it if the result of 
> the first min_t() is 0?
> 
> record->len used in the first min_t() comes from ctx->open_record, which 
> either exists or is allocated by tls_do_allocation(). If we move the 
> copy == 0 check above the tls_do_allocation() call, first we'll have to 
> check whether ctx->open_record is NULL, which is currently checked by 
> tls_do_allocation() itself.
> 
> If open_record is not NULL, there isn't much to skip in 
> tls_do_allocation on copy == 0, the main part is already skipped, 
> regardless of the value of copy. If open_record is NULL, we can't skip 
> tls_do_allocation, and copy won't be 0 afterwards.
> 
> To compare, before (pseudocode):
> 
> tls_do_allocation {
>      if (!ctx->open_record)
>          ALLOCATE RECORD
>          Now ctx->open_record is not NULL
>      if (!sk_page_frag_refill(sk, pfrag))
>          return -ENOMEM
> }
> handle errors from tls_do_allocation
> copy = min(size, pfrag->size - pfrag->offset)
> copy = min(copy, max_open_record_len - ctx->open_record->len)
> if (copy)
>      copy data and append frag
> 
> After:
> 
> if (ctx->open_record) {
>      copy = min(size, max_open_record_len - ctx->open_record->len)
>      if (copy) {
>          // You want to put this part of tls_do_allocation under if (copy)?
>          if (!sk_page_frag_refill(sk, pfrag))
>              handle errors
>          copy = min(copy, pfrag->size - pfrag->offset)
>          if (copy)
>              copy data and append frag
>      }
> } else {
>      ALLOCATE RECORD
>      if (!sk_page_frag_refill(sk, pfrag))
>          handle errors
>      // Have to do this after the allocation anyway.
>      copy = min(size, max_open_record_len - ctx->open_record->len)
>      copy = min(copy, pfrag->size - pfrag->offset)
>      if (copy)
>          copy data and append frag
> }
> 
> Either I totally don't get what you suggested, or it doesn't make sense 
> to me, because we have +1 branch in the common path when a record is 
> open and copy is not 0, no changes when there is no record, and more 
> repeating code hard to compress.
> 
> If I missed your idea, please explain in more details.

Jakub, is your comment still relevant after my response? If not, can the 
patch be merged?

>> Maybe some application wants to do zero-length sends to flush the
>> MSG_MORE and would benefit that way?
> 
> If it's a zero-length send, it means that size is 0 initially, and 
> max_open_record_len - ctx->open_record->len isn't 0 (otherwise the 
> record would have been closed at a previous iteration). That doesn't 
> sound related to swapping the mins and skipping tls_do_allocation on 
> copy == 0.
> 
> Thanks,
> Max
> 
>>>           size -= copy;
>>>           if (!size) {
>>
> 

