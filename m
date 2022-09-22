Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E75E5BF4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiIVHLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiIVHLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:11:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C454FB7768;
        Thu, 22 Sep 2022 00:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOgxSHfdPwJTCVUd3Y2x0b0aUPTVLgrQFkNYB1OLJNtjmmWXrsAfPcEx3pIeZXsLA8GMU0QDkU2wcCsje091BnYWSrrFx2a8QgK8lKoHG11h1WivQ03LuGUZKIcBFGqRlDhC4mogJXfNTZCqaAweiCYfvjed2DbqqendPdWiolLTVVH79akkAKpl1ZlFxFscRM3pcPYqAKCtZWVEEY1+obI5FDrBg0C/sRBWJtSNGhVFTStrh1yTgSCHyX4pr47Zp4vWMe8lMJDCGlubqkozv5ZqZK8udCSuIrunHORfDiPcpHe0QSjIiooiQxvP8Pwn8LPzwdsUFOkEdpKMlI+VUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRT7WjmYurREJU7Dp5P+Ksp1qpA9oYbR9BO3SH8gD58=;
 b=Yt+AXil1xZaXtv/ATuAJcH2sE6o4GFLgt5zEQMF42QIrPOAnVTaIwHPwRryOpjuJgSYOfn153XzoG9/TNKlKxk/tLTkDZ7oRJcGfP0/QyMbAXgS1ZGYVqEEM/xd1B5IjBsSR/GicAU7nWQWrQHISCDSQcSJ45tLosBNKbGg6aiz3maJI8GwVH/KtlxP90o/red6rbh0gwMWVT09V5M/A2lJXrzH8JMXRqi7tsvP+FS1GGZhWi/Pylwg4qjAXSoEU1c0L1XruKANPlu6OpKaoD1Up0BFvCqKCd6VPmPpRdeIJoV5BfICOe3x4I/Slhgulw28bWrYEIRTcLbbW54ru8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRT7WjmYurREJU7Dp5P+Ksp1qpA9oYbR9BO3SH8gD58=;
 b=MZcgXrc59CSdt4pL5rr9nppCP345m0sxsjfu8U/x8fyEPl2xWjwE2DbkDywy0s/nLAWcCnhHCAYW1Mqbvf2Xw1oqJK73qavNVs0qIb2JamSpV2B4Eq5BUZo1kAMGhC/wmzwqrep8iJu5zgizz21tEu23Bc0D1mlwaX9NcheLmCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 07:11:15 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::653f:e59b:3f40:8fed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::653f:e59b:3f40:8fed%6]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 07:11:15 +0000
Message-ID: <673e425d-1692-ef47-052b-0ff2de0d9c1d@amd.com>
Date:   Thu, 22 Sep 2022 09:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/12] slab: Introduce kmalloc_size_roundup()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Vlastimil Babka <vbabka@suse.cz>
Cc:     Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
References: <20220922031013.2150682-1-keescook@chromium.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::12) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9216c7-500f-49bd-c604-08da9c69a36d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSPWu19WqtbGOL+TAFpX9azBYsWMTzLFXVzaM4r/AL98cZ7Yn2JRIYQ0a+TSX4Cl8jqW181nagWy9e+s0mg7YeN/BjukFfnh/h0mZHzSCJULOzCn8XSPrLcRGq/EZ9zB7R0SSxNwjq4iz4RQrUSbl7R8E3FsY8HZtTgzPg8dOHjlyo8+hWsJKb0cHuNB+DwlFP6XxzV9asE40kzkmPzq5sN+tJurpB7xSAh9evwjXcUgPnUM8XHnXWTTB3wsXWoIFdUtyWDQv8ZhL6CGY0c5Z5vJ5KHIs1lQjPmqukQT9Uv+VvWe9hMdDsIBRwNvf0wiMBUoyORP1aPChs9ObBeRhmnQVHvxMdiqF5oD+6Q2JOZFURWe5vXJcvVa2n9A/WnZ0c+/mcxuVSJutfvcAZWU0lh8R6Nx6aoJeFIEFjSOfC3BqdjW51rJiOhWNYE5sV0rvDXsKPFdCRWElMfiI9HKYRz4Kyr324MgDpW70Vdp3gCQE/4adtgoef7rnJtb7/wdl8Vdb5gUWcBWXorwe2ZIXluRajO0DrhybGoOA32tnkWWEOxfN9rJnhDMyhjNJ1BtJupETxafkNzIts57Vyh6RXiKnERIn17lLyhkfyWtulAjCmnk3pDbn8jGbKrD8UYzjfMp9wPWd1Qw/JZtUZvP/OWD0C/TwT0Z1Hjl7gYs9FZgGRM8Hprr7t8SQxe9+jPSomULVztn0EeqyMtC/3vnyOwGwNw1JQ0zWWMPRQfRqs0lmYZozfEgCm+3D9pGnU/vePhJv1sLqgUTc9rVzeljfBc9ofYR8yeisuktOUtlmMYCA+fxGOaixOD45l1sdiGiD1RVxC4JQsaJ9eejrxGA3Hn+wQcc5V93R3XmswQAN+JXWYNs4Hrm2Tuwj+YISwpv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(8676002)(31686004)(6666004)(36756003)(966005)(7416002)(7406005)(478600001)(41300700001)(66946007)(66476007)(66556008)(8936002)(5660300002)(4326008)(110136005)(316002)(45080400002)(2906002)(54906003)(31696002)(38100700002)(86362001)(2616005)(186003)(6486002)(26005)(83380400001)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WThBU0ZDRSs2OEw2NGdCSTlQZVdYVDJOYTNqSFZrLzc5YXBVTGIrQXRLM1l1?=
 =?utf-8?B?RVd4NWRUZjZqN2ljKzAzem9vQWU3TDhTVi9QNEdSUzNqemNIcWRDZDAzOURL?=
 =?utf-8?B?N2lnQzdZVWJZN2R5ckV3eEZ0Sk9BYUxnVFRFUnh3NFJEZEFJc3VJa0V0Ukxn?=
 =?utf-8?B?RUtrdCtVemxIekN0UzBSeWh3b29vYVE5L3BaSzlzRUNXRi9mMy9VeFBDbkwv?=
 =?utf-8?B?Y0lKdU1MY1ZmUE1IUmpCeWZPZDdhU1d4bCtMYlNOamdFSVRLSW9MdlN4Z0Ev?=
 =?utf-8?B?aVd4UHpUOXM4UXhDQi9IZHRPOHdJTEhxUk1vSWNGS0NGdzJrcWxqTUxTZkJw?=
 =?utf-8?B?RWc4MzF2Rzh3NWpGUW0xSk9paExVK1BnRVJIQmJRS3pNblhoSHRmWXZvd1RW?=
 =?utf-8?B?ZDhlQUFDTUJkNmI4ZUIrS1crQ2NNYStCWnVBbWpqa1VvYVhFNkVnYU5qeGZE?=
 =?utf-8?B?WmJSMk5oMm5rMWNPZzlyam9nVWtKZUpCamZLR1o5d21abjQveVBLMUVpRFE5?=
 =?utf-8?B?RmdQQmxmaFpocE42MG0rTjRmWnZDK0F6SW13dGVvM2pGaVd1SXo4RUNRK2JH?=
 =?utf-8?B?YTRYVGpiU0ZQYzhJOExaTVNUYTNmZkpwYURZQTJGdmNYaHg1c1JSZW5mRjIw?=
 =?utf-8?B?WTNGZVNPbkhVcXhMcklYeXZJR3FhTFJkQW95L21pek40WHNBR2cwaDlNWUd1?=
 =?utf-8?B?STFqc09LYWNRNTd4OXNhNWw0bElNYjdpejgzQmQrTHpzeGZualBjNHNEWkRE?=
 =?utf-8?B?QW1ha2RKNVVGcHVMZGQ3aERXcXFGN1VnWWR4K0JrdEFTcVFoanpvSGNjMExh?=
 =?utf-8?B?aFVEWlNkazV6Tmt3U0NlU3lHN2wyU3p6L2FueGoyVUphblk1a3BmS2lMRXIy?=
 =?utf-8?B?YkdUMGtXK25ubFh6dEtqbm1vUEN3NUxoS0JQcjN4dVg2WlpXRjF1aHJ5UFA1?=
 =?utf-8?B?Z21sRUtrMDFKRS9neXBEaytNMnFKRjVDdUphR1Baa1daaGJNd3pVYUJVSEtO?=
 =?utf-8?B?RytDSzd2T3E4NVpSUnUrWWpOVG41elFWSDEybk9OMkJqSGhkREZ4OXhqREU0?=
 =?utf-8?B?NnNQbnNPRzIzbUFVRnVjVmlCTDIyRU0zczNnemJFc1VTZlhkeVd1WVl5YUk1?=
 =?utf-8?B?R2w5emU0MHE5V0RnWlhmVS9IZ1BTbXQ4VmlwNU5kUHdhOUU4UzBFOEVRdGY4?=
 =?utf-8?B?WS9mRE5XTGdCak1mVUY4V0FsSjNMWjUxRWFmVE1yUzllSXdBNWwwcno3cUxI?=
 =?utf-8?B?VGluUEZvMkxlRTRkZzNRMkdBRkh4dXNCbjh0ZzJXRHRITHUvSHExaEU1L2hh?=
 =?utf-8?B?TUNFSVVHeFlCV2NGWXNjLzhnMDZudEFwUTVVdXRWSEo2bWQrZDlNYVo0WVhW?=
 =?utf-8?B?cCtFeFBDUGhvK0dDYnNXeEMzdllyVTR6U1lxYjFocjRRMDhxUXh1Y001dXBp?=
 =?utf-8?B?NTR3bjN3b1N2MXhnVjhNSjNSclRmZnBFU09KY3FKQVg4MDRLUjZZdzRWVVFo?=
 =?utf-8?B?QmJ1U2Z1K25ZMDRud1hYdFNXSjVmbTZNVk9JdXhKVEZZTjVSU3NDVlZkKzhY?=
 =?utf-8?B?RTdHZWpzbVcrTURRckdFMk5uTkFURW45Y0tPNWJRcm5Tc05jQWpjbkVaVUUx?=
 =?utf-8?B?NGUrbHJYMHRYcFYrbGY0dzhNSkJwMlpXSVQ1Zy95a1NRS0hDdHYwOXRFeE1y?=
 =?utf-8?B?eEJBN3YvVld4OFZvVEdtYmgzcE5pTWxkL0V6ZWFERlNnbHc2Vk9YMGNPOFFq?=
 =?utf-8?B?SytqamVaS2ZxMlpEb3hVL0lueEJ0bittZW01cXVKNVN6V1hMN25wMC84SDFW?=
 =?utf-8?B?cVJvaE5PTExoLzJsR2JETW9ibExWeVhpUlBnRmdPa2E0NjZTeU5MTy9CMFJt?=
 =?utf-8?B?cUZlcmxNbWFHbjlGb2xQNlZBWlRRelIwbnM4dkN4aExhZHRYbW5oQXdpVFRZ?=
 =?utf-8?B?TWRxVHVkbE1jVVpKWnhsanc4S3dSTFNyNVltaEdNQjlPUURXUTNPaHdsVG9S?=
 =?utf-8?B?eG96ZVZFSVQ2TGdiSFBqQWFvalZGcnlXWWVHR1BTdUxzWktTbHFHMFhXRUhh?=
 =?utf-8?B?b09Mbit3dFk3Yzg2LzAwNXF2M3R0bThDVkcvSzZqZDZYeVYvaDI0cjVXMzg2?=
 =?utf-8?Q?38WmNmx6VbQEPYBPQbj48OvRh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9216c7-500f-49bd-c604-08da9c69a36d
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 07:11:15.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3DuJH1j2Vv5LVJdXfe2ol4tKB5UPthfhlY8EhhHjRI64BAzT90Cn7u6CgdGs6TX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 22.09.22 um 05:10 schrieb Kees Cook:
> Hi,
>
> This series fixes up the cases where callers of ksize() use it to
> opportunistically grow their buffer sizes, which can run afoul of the
> __alloc_size hinting that CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE
> use to perform dynamic buffer bounds checking.

Good cleanup, but one question: What other use cases we have for ksize() 
except the opportunistically growth of buffers?

Of hand I can't see any.

So when this patch set is about to clean up this use case it should 
probably also take care to remove ksize() or at least limit it so that 
it won't be used for this use case in the future.

Regards,
Christian.


>   Quoting the first patch:
>
>
> In the effort to help the compiler reason about buffer sizes, the
> __alloc_size attribute was added to allocators. This improves the scope
> of the compiler's ability to apply CONFIG_UBSAN_BOUNDS and (in the near
> future) CONFIG_FORTIFY_SOURCE. For most allocations, this works well,
> as the vast majority of callers are not expecting to use more memory
> than what they asked for.
>
> There is, however, one common exception to this: anticipatory resizing
> of kmalloc allocations. These cases all use ksize() to determine the
> actual bucket size of a given allocation (e.g. 128 when 126 was asked
> for). This comes in two styles in the kernel:
>
> 1) An allocation has been determined to be too small, and needs to be
>     resized. Instead of the caller choosing its own next best size, it
>     wants to minimize the number of calls to krealloc(), so it just uses
>     ksize() plus some additional bytes, forcing the realloc into the next
>     bucket size, from which it can learn how large it is now. For example:
>
> 	data = krealloc(data, ksize(data) + 1, gfp);
> 	data_len = ksize(data);
>
> 2) The minimum size of an allocation is calculated, but since it may
>     grow in the future, just use all the space available in the chosen
>     bucket immediately, to avoid needing to reallocate later. A good
>     example of this is skbuff's allocators:
>
> 	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> 	...
> 	/* kmalloc(size) might give us more room than requested.
> 	 * Put skb_shared_info exactly at the end of allocated zone,
> 	 * to allow max possible filling before reallocation.
> 	 */
> 	osize = ksize(data);
>          size = SKB_WITH_OVERHEAD(osize);
>
> In both cases, the "how large is the allocation?" question is answered
> _after_ the allocation, where the compiler hinting is not in an easy place
> to make the association any more. This mismatch between the compiler's
> view of the buffer length and the code's intention about how much it is
> going to actually use has already caused problems[1]. It is possible to
> fix this by reordering the use of the "actual size" information.
>
> We can serve the needs of users of ksize() and still have accurate buffer
> length hinting for the compiler by doing the bucket size calculation
> _before_ the allocation. Code can instead ask "how large an allocation
> would I get for a given size?".
>
> Introduce kmalloc_size_roundup(), to serve this function so we can start
> replacing the "anticipatory resizing" uses of ksize().
>
> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FClangBuiltLinux%2Flinux%2Fissues%2F1599&amp;data=05%7C01%7Cchristian.koenig%40amd.com%7C491e7c24ddc64e9e505b08da9c47fe36%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637994130356907320%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=te%2BJ46%2B8L8oBTyGS3C7ueORFYI%2BhMRbfEoflVErr4k0%3D&amp;reserved=0
>      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FKSPP%2Flinux%2Fissues%2F183&amp;data=05%7C01%7Cchristian.koenig%40amd.com%7C491e7c24ddc64e9e505b08da9c47fe36%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637994130356907320%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=lrOCZN6EE%2BnDBA5DfOqteQt0nKCbJJ9bxlh2F13%2B3Es%3D&amp;reserved=0
> -------
>
> And after adding kmalloc_size_roundup(), put it to use with the various
> ksize() callers, restore the previously removed __alloc_size hint,
> and fix the use of __malloc annotations.
>
> I tried to trim the CC list on this series since it got rather long. I
> kept all the suggested mailing lists, though. :)
>
> Thanks!
>
> -Kees
>
> Kees Cook (12):
>    slab: Introduce kmalloc_size_roundup()
>    skbuff: Proactively round up to kmalloc bucket size
>    net: ipa: Proactively round up to kmalloc bucket size
>    btrfs: send: Proactively round up to kmalloc bucket size
>    dma-buf: Proactively round up to kmalloc bucket size
>    coredump: Proactively round up to kmalloc bucket size
>    igb: Proactively round up to kmalloc bucket size
>    openvswitch: Proactively round up to kmalloc bucket size
>    x86/microcode/AMD: Track patch allocation size explicitly
>    iwlwifi: Track scan_cmd allocation size explicitly
>    slab: Remove __malloc attribute from realloc functions
>    slab: Restore __alloc_size attribute to __kmalloc_track_caller
>
>   arch/x86/include/asm/microcode.h              |  1 +
>   arch/x86/kernel/cpu/microcode/amd.c           |  3 +-
>   drivers/dma-buf/dma-resv.c                    |  9 +++-
>   drivers/net/ethernet/intel/igb/igb_main.c     |  1 +
>   drivers/net/ipa/gsi_trans.c                   |  7 ++-
>   drivers/net/wireless/intel/iwlwifi/dvm/dev.h  |  1 +
>   drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 10 +++-
>   drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  6 +--
>   fs/btrfs/send.c                               | 11 +++--
>   fs/coredump.c                                 |  7 ++-
>   include/linux/compiler_types.h                | 13 ++----
>   include/linux/slab.h                          | 46 ++++++++++++++++---
>   mm/slab_common.c                              | 17 +++++++
>   net/core/skbuff.c                             | 34 +++++++-------
>   net/openvswitch/flow_netlink.c                |  4 +-
>   17 files changed, 125 insertions(+), 51 deletions(-)
>

