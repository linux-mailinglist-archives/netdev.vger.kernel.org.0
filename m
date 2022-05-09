Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD4851FD7F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiEINFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiEINFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:05:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3FF23276C;
        Mon,  9 May 2022 06:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWNo9oOsJ5CV2QDVNF9fjENEgu4Kcf9hXEFdgmV4f6gkg/zRVjcK+YPyszb9F9v1HieQQPFh1Kpz99k7e1Vlv+Dty5WB/l7YdKAWjRofZvCTRd439VumI6AosBov9u92dS2Mhw9x0dex0AUI2zl6FLYmuOv8sjCFz6wZtupfqY3WBez2+/A7PHDWjvLTND1+tYAcXl7AQBsUIMK3rmaZSieKSfEfxUiLO2Bgi2SYLJQe9+ZOLXpd6IFyaXoTvxbIKMVbW6pU7OEdQPvxVK0AtZ06TLv5gCITfzfV4oZPzzUIV+KM78K/ajIlLIfTIjrp+Hg2yJkp6IjIX8lO/i8d1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXiD/B9UI+KsWOu9z6wxxq0F5n9+QZFqO9RpyRI0m8E=;
 b=JAHYlWYD8kujSU46obwtgJN4m0TIyubjnk+r4rUHD+za2fVW5B/RofBltDszChZwYnnBVmsmI4cj75rSIzk9doKTmBEsc2Ep+y/sJ168Cj82G5SscuaZZym+m0zESr8DThPB3+VvMS9+1CsUFUjzeppwFCxW8skoxkwiBe0pvD5LOj/Su0BsQEJYHb59dJlAis8ua0y4oHu5bpSxl4vgBCuPKYqtFAndHVf/m0VZIKRijAzFpgwN9k4SKP32l62OY6v2toH5OI6JFXQBrKukKdJZW0bDH0qDaPARFnVIDsnb7UiAweYoNIgWQsAAzja954P46HfVIQeUGWrZrVQ/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXiD/B9UI+KsWOu9z6wxxq0F5n9+QZFqO9RpyRI0m8E=;
 b=fP7QNMVyannJQINS13w7I3ALY6510twNo5CFLHy0uge+KRG0aR0XxqNNKd1EW7U/WSTgevxaOFDWmAFCzMef0T6ueTrdIdfXBjjbuDJMrKfrq+7KfyN/5wWwTLyQhxob1culpi1oamjvFSHSyNem/UuHO00+mssm5vWaT/AizheWccU57GGcpAbm0ex8YAgXwu7GpOPnFNhsyccIB7Y7mYXrYPYsl5G7f2IbhT1ST19cVuvsYJoCBtjwKQ4BFWSbYDlawA6cqCFeoSzvRddqgU/qQyLaKRXF1XWxu6ObIvDLyHPOeB4iJx5NwJTlwMhKSrFVNuyclVbeTiYnSyg0Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.18; Mon, 9 May 2022 13:01:45 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:01:45 +0000
Message-ID: <663024e0-ad0b-c940-903d-3f4a3a47ffd1@nvidia.com>
Date:   Mon, 9 May 2022 16:01:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Content-Language: en-US
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
References: <20220509072916.18558-1-ozsh@nvidia.com>
 <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
 <acba99bf-975d-54d8-01cf-938d2579f06e@nvidia.com>
 <20220509122749.yrxfzee4lzdpfkcc@SvensMacbookPro.hq.voleatech.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220509122749.yrxfzee4lzdpfkcc@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0451.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9538454e-3010-480e-4b06-08da31bc11b7
X-MS-TrafficTypeDiagnostic: DS0PR12MB6390:EE_
X-Microsoft-Antispam-PRVS: <DS0PR12MB6390A8480B9B00EACE09D076A6C69@DS0PR12MB6390.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4whTGkeNe2DwlXT6lMJkTirO3UQgVRNxq6MGCgMHic9KutA/lLg06ZzqOIGEeFj0oTUciMzq88totbOCqlNwQoxJQ2D9L3MgHU0wxby0jkRUCHVtTgysVqTyZgj0kCd60TDIgvmQc6Lw1v1/oEt0npBpbvzI5YgZtD54+JrwkM2+aBJqwi0dOfnxMRcJRfZOL7GcWzu3pOUVf/gFC2VRN60jVQS7fBZL/MTP354nfmIv2i5QtAFrHrhpNyFpnby3wv/IMZNEfa2Qzi+1Dx8F2N3Mop9NpYRNzZvcZtPcJ99Fgn4Mrg1ckq+us9X/KC5LFqLaAxiEejrpa0UB4HnBhoO6H0EporYoTM5VkEifiFUbgOULsAi5x2S8s5Kh9PGMtvxzqB27TNEYBsiZXcSzCKrkXO8+lwzQLexrDBFXN97ysTDRaCmPn6p+fdBCbVJki+DbmyySbFYYPjZCFXSZkzMHDyhuOr4MgQiZ5nNffGPV4L6kkL406wJf+J6MocEEfTNxRrZtgzlR45B+ekhwrIDKN+05NCdct+N4A9tSmXYGYGjnc/8xbPrLo982MWU6Wkh8ritbsVLerq6M/u2JB4BdYkC3oQa/xSet4H1nuarJrK5sek8dUQNlhurJPczaqq6fRamqXz5kSjxmGV/+rY1NEF6+jX18tc5KejdeF9Ti7yPzUPqRP6TtGQ/btF1CfLWaNJXBIY7YOfZIeurIamxVsI8nDgdvD0eEYGPOc1CPZP/xwt3bvET61Z6gve1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(186003)(6916009)(2616005)(31686004)(26005)(53546011)(4326008)(31696002)(66476007)(8676002)(66946007)(107886003)(66556008)(6506007)(316002)(86362001)(5660300002)(2906002)(36756003)(508600001)(6512007)(6486002)(8936002)(83380400001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmpzSFVmZjdla0E0bHFVdHR1QjZpaGF4dll2NWhNaHRGYklFbTIrVC9EYUdM?=
 =?utf-8?B?M2J1V3NrK2xON1Q0UEFHdElTa2pmdkRmeEtwdGtObXI4RkZjZUE2K2gyQzRG?=
 =?utf-8?B?ZVUwcmRsQ1o2d21EY1NDSit4TTBkN1pMcWtPMTc1Nm9CWHl0bURGb1hQVlIr?=
 =?utf-8?B?Qi9yOVhqUkdjMkFMRC9tRDhqNW1rU24wMEpGQjZXYVIvWHRYS3NJMkJvN250?=
 =?utf-8?B?ODFUdDF4MllENExGT2N2VlVjTWpzZmJ6NzFPdlBOZS9xaldaYzRPUEVlbEx3?=
 =?utf-8?B?ZW5RRG5KUUl0WStCQ1g1OExPU25WV0NnMVJ5SmJwYUluNEtaK0poSDNoOWVZ?=
 =?utf-8?B?QXZSWHIxdTBhbXZvMVpoaUovQUZrK0ZsM3pvZ0R5cmM2UmZtU3c1UUVwVE5P?=
 =?utf-8?B?UkMzTEl4TWxxTGtxaGtWSUpIamk3LzdQTjRIM1ErVTBjenMxR3p5U2NVbHNE?=
 =?utf-8?B?OWF6eHJjM0s3ZVgxOW5RWlpKSzBZTE5KL0ZRWlNkQ2ljc0EvUjBEeG9mOVJx?=
 =?utf-8?B?Vy9la29xZnFQdGJpOVNuSHA5ZkdEZVNKaWdzYlZybTFIcS9scEhScUF4WTBJ?=
 =?utf-8?B?b2EvOUpBWDB4RHdCL0VIK0cvdmRHa3FXZDVZRk9hNG9IYkJCaFYwRUwxZmpa?=
 =?utf-8?B?YmZMQ2ZGQ3V1cDJ4djNpck9ycjM5TFN1Vm5qcWYyb3hCUThFOUFiZG5IaWgw?=
 =?utf-8?B?VGh0RGxyL3VMZzNrWFp5QVNncXlXWUVWUG85a0Y1NEgvNGlMNkRkWEU1dm9q?=
 =?utf-8?B?aGhvNjNaUU5xK0RKMldyYUswbDRCOERXSWVCeU40YUduY3NWU1EyMEk1QmZV?=
 =?utf-8?B?WExyaFQ2NHBhWFZ0cE9wREFSdkZFb3NWVlF5anV3M0tuK0xDSUhhS2dWam84?=
 =?utf-8?B?V0ViZDVMQ3B5SHQxSnVyZHFWQVZDdFVKRkw2N1pjQVcyOVE3a3ZHeENKWElG?=
 =?utf-8?B?VnFPa1RCSitGZ25XeG5qalJEN1hiVU5VeG5iTytqVnRteVU2VHVOTTZPb0U2?=
 =?utf-8?B?U2ppb3VxTnJ5THFBbWZJcnNwazk0NDhKalJMQ3VRTzJNd3F5SHgwdGl3N2N1?=
 =?utf-8?B?ZzZWeTNCbXpRT0lTZ2gvcENzVDZnc3NkVkZtSnBxcVNyVkZBc2tya3N6aW1C?=
 =?utf-8?B?TWhTQWt4cnJHTnVnUXdnK0JuUGlZMWRIWkJDV2tTK0dRRmRHUWQ4a2xnaEFB?=
 =?utf-8?B?YW9JcUpQVlNDeGV5L1Vzb0FkNmtZLzFKM1hPTWNpclhDS05oMW5kbEgzNFZJ?=
 =?utf-8?B?TnhWZ3JudzZRWEs2ak1QdGNlNHdYK0NZSUpwSUprMnZFaDhuUlMvMEFTWUs2?=
 =?utf-8?B?T0dGaUJvVFZzLzJXYm8ybE1jUzIrYlpZQlduWGZabjZyMG1aSkRBZW9JSTVn?=
 =?utf-8?B?d1Z3TUd4UjVmY3ZrZjRQYjdiL3ZIMzNFT2lNTDJDUStjUHdYa0szZUZxVDRw?=
 =?utf-8?B?YkRvZ3UySDgrdFhzWWVuaHQ5VmVlbGxTRG95NzRRQi9XOG5Lak1hbERVN04w?=
 =?utf-8?B?NElKSnBRUkprc0puR1R4SlR5YzRFYTEraUw4eWROQnZ1UEVMbmlSRTNqN2dk?=
 =?utf-8?B?ZDJnTE9JVTlDejFvczlqaG9xOGp1RUNFTExJWEt4Njg4N3hQSXFKcTl5N0Vh?=
 =?utf-8?B?b2RUeHVkRUlRa2lKdmhuSSswYWFBek9LU3NEMXRjRVZoZE9randrbnd2cmln?=
 =?utf-8?B?U01QczlFMzR5TG5XRjBKRFBRcEpUTVpjS0NlYXZ5RitnN0F5SHRYcEREV3Jq?=
 =?utf-8?B?cXc1dlR2ZW5WL2NweWgwMzBMMEpQMXc2T2xwZ2ZYVHg4Y29UMWwwcnRabEFL?=
 =?utf-8?B?STg1USs0OWtPT05lMmJVeFM3QWUwVnI2ZVpXazUxNUhKeEtHUE1UUkk4Ny8w?=
 =?utf-8?B?SzNPYnBqa2w4Uk5sK1hZZ21MenhuT2ZiRjZrSUlDQnZURGJ4UHpoSTBMK2E0?=
 =?utf-8?B?ek9VeFVOcFNXYXlpWFRDUTRLY3pJNXJIYTl6bDVpZGF3N2dlMXZlc0hGS3Jl?=
 =?utf-8?B?MHIyRmlidVF1MlRhVmxucE90dERsRXl4SW1MaXBBMUtSQUtON0FtV2RXS0s1?=
 =?utf-8?B?S21xZTdHTngyS2krZERxZmU0K25VVWdiY2lPTFV2UVlieUE4Q09yVjRMSVBV?=
 =?utf-8?B?elhId0hrVnNxajQ0eXlWdEZqYnE2cEsveXZ3dzQ5WElDaGlpMTRmeDA2TXpZ?=
 =?utf-8?B?VlJOOGY3QVVmb3FrVzZyVzFid3RncmkzM2JRRHkzcHYvY1NFVEdBV2duVDdo?=
 =?utf-8?B?M1NlZEQ1NzlqNE9ZMzg5MnRLUXRHZ2U0Q2RpdkdSeXc5SitOTXpxMUt0NjUr?=
 =?utf-8?B?OStiaWRzNFFORHNCOFZ5QzV6WStCMEF3cUFRN1hyMVpQQWxva0ZrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9538454e-3010-480e-4b06-08da31bc11b7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:01:44.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zefu+J6K5JZsB2cWvlw4A+rFbW29TCuCEG7m+9kw/WZFxjcLL7iy9gPFY9cKzFe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven,

On 5/9/2022 3:27 PM, Sven Auhagen wrote:
> On Mon, May 09, 2022 at 03:18:42PM +0300, Oz Shlomo wrote:
> Hi Oz,
> 
>> Hi Sven,
>>
>> On 5/9/2022 11:51 AM, Sven Auhagen wrote:
>>> Hi Oz,
>>>
>>> thank you, this patch fixes the race between ct gc and flowtable teardown.
>>> There is another big problem though in the code currently and I will send a patch
>>> in a minute.
>>>
>>> The flowtable teardown code always forces the ct state back to established
>>> and adds the established timeout to it even if it is in CLOSE or FIN WAIT
>>> which ultimately leads to a huge number of dead states in established state.
>>
>> The system's design assumes that connections are added to nf flowtable when
>> they are in established state and are removed when they are about to leave
>> the established state.
>> It is the front-end's responsibility to enforce this behavior.
>> Currently nf flowtable is used by nft and tc act_ct.
>>
>> act_ct removes the connection from nf flowtable when a fin/rst packet is
>> received. So the connection is still in established state when it is removed
>> from nf flow table (see tcf_ct_flow_table_lookup).
>> act_ct then calls nf_conntrack_in (for the same packet) which will
>> transition the connection to close/fin_wait state .
>>
>> I am less familiar with nft internals.
>>
> 
> It is added when the ct state is established but not the TCP state.
> Sorry, I was probably a little unclear about what is ct and what is TCP.
> 
> The TCP 3 way handshake is basically stopped after the second packet
> because this will create the flow table entry.
> The 3rd packet ACK is not seen by nftables anymore but passes through
> the flowtable already which leaves the TCP state in SYN_RECV.
> 
> The flowtable is passing TCP FIN/RST up to nftables/slowpath for
> processing while the flowtable entry is still active.
> The TCP FIN will move the TCP state from SYN_RECV to FIN_WAIT and
> also at some point the gc triggers the flowtable teardown.

So perhaps TCP FIN packets processing should first call 
flow_offload_teardown and then process the packet through the slow path.
This will ensure that the flowtable entry is invalidated when the 
connection is still in established state (similar to what act_ct is doing).

> The flowtable teardown then sets the TCP state back to ESTABLISHED
> and puts the long ESTABLISHED timeout into the TCP state even though
> the TCP connection is closed.
> 
> My patch basically also incorporates your change by adding the clearing
> of the offload bit to the end of the teardown processing.
> The problem in general though is that the teardown has no check or
> assumption about what the current status of the TCP connection is.
> It just sets it to established.
> 

AFAIU your patch clears the bit at flow_offload_del.
If so, then it can still race as flow_offload_del is called by the 
flowtable gc thread while the flow is deleted by flow_offload_teardown 
on the dp thread.

> I hope that it explains it in a better way.
> 
> Best
> Sven
> 
>>>
>>> I will CC you on the patch, where I also stumbled upon your issue.
>>
>> I reviewed the patch but I did not understand how it addresses the issue
>> that is fixed here.
>>
>> The issue here is that IPS_OFFLOAD_BIT remains set when teardown is called
>> and the connection transitions to close/fin_wait state.
>> That can potentially race with the nf gc which assumes that the connection
>> is owned by nf flowtable and sets a one day timeout.
>>
>>>
>>> Best
>>> Sven
>>>
>>> On Mon, May 09, 2022 at 10:29:16AM +0300, Oz Shlomo wrote:
>>>> Connections leaving the established state (due to RST / FIN TCP packets)
>>>> set the flow table teardown flag. The packet path continues to set lower
>>>> timeout value as per the new TCP state but the offload flag remains set.
>>>> Hence, the conntrack garbage collector may race to undo the timeout
>>>> adjustment of the packet path, leaving the conntrack entry in place with
>>>> the internal offload timeout (one day).
>>>>
>>>> Return the connection's ownership to conntrack upon teardown by clearing
>>>> the offload flag and fixing the established timeout value. The flow table
>>>> GC thread will asynchonrnously free the flow table and hardware offload
>>>> entries.
>>>>
>>>> Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
>>>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>>>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>>>> ---
>>>>    net/netfilter/nf_flow_table_core.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>>>> index 3db256da919b..ef080dbd4fd0 100644
>>>> --- a/net/netfilter/nf_flow_table_core.c
>>>> +++ b/net/netfilter/nf_flow_table_core.c
>>>> @@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
>>>>    	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
>>>>    	flow_offload_fixup_ct_state(flow->ct);
>>>> +	flow_offload_fixup_ct_timeout(flow->ct);
>>>> +
>>>> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(flow_offload_teardown);
>>>> -- 
>>>> 1.8.3.1
>>>>
