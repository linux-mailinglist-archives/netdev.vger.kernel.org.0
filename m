Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE0F6EFB84
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbjDZUE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbjDZUEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:04:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD70F196;
        Wed, 26 Apr 2023 13:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3Mn/uljQJNeBYSU92MKTWRg2b9Gtp6moj/2AXMYhYgJHy9P7/el3X2bgT2ZcD29ilGngHyZ5OxfvzQuzw0lBY4bBSpk/oY5r4IxurZHGDo6lrvJoBpkgR/RUb9ig2BR4i0JwtPGANWxGITgxN2kda6WvdLDJ+lNFRCaRCh37rzbdJ5HvHhjQur+axnGtUs8kvRYLNPA0T6XEbMf4ilN7gKhf47SRQhaJc8AFAU0SVOqrq/26g/O0zZqrPwZd5NNd7REG2q0S/O7/h4wqfLl6jquQ9km739yleUOSiJowXWU68De79P43DUXGnY5a6KY6SWqKTV4JptWefqrrdcFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/M9k1oEu8RZijzBzRgDb+YouImd34d0b7LWCUJfT0U=;
 b=E9G29pI2N65rDvaXzJg2xCHGD/1B3sb4+PC8mj+y7z/M0KPTR/Ywz/cPp6xhBaTEIMs9wnPw16OHxQKB4Hw1krppi9Kxjj+IDpEgPwuBhXd8gKWFeMgqR0MkOFZ+nBYJuC9tarYGZcW3S2hiW8gXzFdXkrybo0NmpBhgmD8nxBtb5kWHn+Tki/svW0r984H1Aa0iCwX2PpSNxlGwXGW7QqFmIraguFUBfwRGtLZlNnKZzdhRPfUgdg1v107NTc2wD239wu0I8XRwz3oCFrQoc31SoLC96l5zMeXEtefVdvkXL9+TWmdfEuu0PW42gn2QuFkVBgtkH1kt2COVi9aEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/M9k1oEu8RZijzBzRgDb+YouImd34d0b7LWCUJfT0U=;
 b=FPQnIPyNOuxL9VkMW2hWBUbUKRkHYolyeKtQYvkS570xrLMolhSQDNg2NiaUXPIx6tzLY5h2L0ZHuHvbRNyUxFqspgxJxmg5Glc3V7JE4Qt+2kWDB2rofxI82NaVMKsGjwS84cZxybG3HgbMHwpM+QceBsGH0i4uzWGG8zI99AsNEMFXkWVWr2kqaxLkW8R5pFfBHmoCiyjHzV2S/XXSBddUnFS+NRprliuoBQ1b0A6UoSCb/dTAHw728nctP79Y4/tytrtfGw9AH0ZJshDE3ff04NjrgKOg8WDtAn2zi9q6o8X27t7DCcTHC4oL/novRFVcNFNgrgo+Gj2bRdXX5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by SA1PR12MB8988.namprd12.prod.outlook.com (2603:10b6:806:38e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 20:04:50 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f%3]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 20:04:50 +0000
Message-ID: <1b9e3406-c08e-b97c-d46f-22f36535d9e5@nvidia.com>
Date:   Wed, 26 Apr 2023 13:04:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Hildenbrand <david@redhat.com>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <a68fa8f2-8619-63ff-3525-ede7ed1f0a9f@redhat.com>
 <5ffd7f32-d236-4da4-93f7-c2fe39a6e035@lucifer.local>
 <aa0d9a98-7dd1-0188-d382-5835cf1ddf3a@redhat.com>
 <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::6) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|SA1PR12MB8988:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f0b9aa1-948d-434e-f16c-08db46917e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8dHrzPi1H1BWuqVmePzUyKuky8mPhCX2NhlpXfhueU6OIsqq6iK1FMEDfJIE1kiXSzYR+4fm7VjJkaj/8/1NigM6gqYnPC4QSkCyk623jbpDtLPIADWqVUT+xcNGf0QD0Y6zF4l2cFzNw8PgOuo4tVHXtf7jC/D99U68fwgX9nL1s0jw2o+bszzu7vndjt9cFmzMBuFZGCxK/NKqvQPwqpdApEONTwkemYLOBUesoX2ZVNjZJL4JkGOof/19+F6gbtBUGQ1bZ72j/OyzXgdRRt860P4rgWx9H9cqiPdZKUog6i06nuz/zSURj6wxc5TuGaVf0Z82x9E5IgPySMFgD/ULinMn7xxAID0MQIYpR6EKanNf56VGMiLUwxZdC0m7p54VqxppAkBPne+xb7awyrp2Gyp8ts+vPz5YsUW/c2KZ0Q5wqX2xw4pRjXaixkFATZopRiLifc20dQV+ZsjjFrDoSfm0nggw/NRHkLAhT0/pHylq6DRCn5qz2PB4jl+Ar6newmUsq76RdtoQCHLSaDfUz4b17VdMRNTbimQhoEYtwOfqRNTh2YCPSOArAnCTDs4fhVnmotyTH34Cd3DWV9LqcD+hOdGqhO+xsXFJpls1WxyHEMOcxnQawPRVU97b9GRDqBtMUHyoMPaRpOwFiXLk2IYQ1MOj6zs0nsBMtKh4P0A0NOTW+AHHWhrk2xQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(41300700001)(2616005)(26005)(6512007)(53546011)(6506007)(5660300002)(8936002)(8676002)(31686004)(83380400001)(7416002)(7406005)(2906002)(38100700002)(4326008)(316002)(66476007)(66946007)(66556008)(36756003)(31696002)(478600001)(86362001)(186003)(110136005)(54906003)(6486002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUw4d3hDMDU5RzJtUzZvZVEzU1FXWkdmWTZ1a2J3bEdvWGw5Qk5qNXMyYXQ4?=
 =?utf-8?B?T1N0Qnk5VWppS0IxZ0xORWJXbCtvME1vRGNLYWZNMEdCWkMvZisrQmNYRy9W?=
 =?utf-8?B?QVpHUGh2Rjg2aytHVFZSK1MzWGxUS2ZkamxLZkJhc2RxY1AyMW0zR2NDK2dS?=
 =?utf-8?B?RkFLTUZjcHd3K1Q5dEc0NlZqUjlkc3VjWGo5VUZ0Z2YwREJqdWdsdlYrOENp?=
 =?utf-8?B?N3JMNjdwQW5hQnlkQVV5UUhJcFNlajgrSWcxSEdBanN2U1FNL09PRzRaMWMw?=
 =?utf-8?B?VWlCWUh6QVpIZURTam1vRUdXell2aGFsenJvU0N1b0xDUHBlK1FsNzlObGFi?=
 =?utf-8?B?KzZYTVZsWEw1WVIyK2sxWnBmRXF4WWQ2Ky9JdG5qaEVOTDcwbElDU0JXWURq?=
 =?utf-8?B?azdTbDV4cHJ5dDZpRHdwRE1jK0pXN1RPbGZsNVh5OWdKd0syeHNkUnQ3VEh1?=
 =?utf-8?B?aFdXUWJ4L1JiSVBpQ2hrTDU2WXZkKzZKYW1jL0tidVZvcVVyeWdsZzk1Z0NE?=
 =?utf-8?B?TE4zdDN4eEdnbEpzVUpFbW4yNUZqZE9iekZubWVZRW8xQmhMa1M0bDRtamRG?=
 =?utf-8?B?cGdwaU8rUmpRRnQ4UWVWYTVLcWZDYUloNjZOVjlTbVVlOFJyMjlXeDRpWEZq?=
 =?utf-8?B?QWEvOGhNcUVRclJ2TzJYQWFCYm5Jd1JSYkh1cEpUQWM4TnVkMWVoQTEvbFVR?=
 =?utf-8?B?SUZ4NDNVak8xUjhqRk1CcEVOM0pDcVoyTGw4QTREdDMzY3hna2JUd29NN0No?=
 =?utf-8?B?YnFqQW95YmV5UDZMckJxWVovbzBvV2IrVVNTOFR0citMTThRTHR6aVU0eFZE?=
 =?utf-8?B?SnN3SStIMmNETldrRlptNGJaWUdjOUNDNFBvam41Z3NiTS9sUEM2Z3kwZFA1?=
 =?utf-8?B?OExLZWFPTFQ1MTN0dnd6TTJYVXdiMCtWdko1VGNvTzAxc2MxMDJWWElLREhw?=
 =?utf-8?B?a0VoWmxOemMzblNneCthK0NCTWtRRVVnUnZDZ1pLMDJtZ2gvRDhHNndSZ1p5?=
 =?utf-8?B?TWM3TVNWREZWeUR6VlJsRE5lZm9WNGk4R2REM2pSZUEyUml0TkNpc0lLU09J?=
 =?utf-8?B?dWZLQW4rbzA5ak11R3gzeUR6bUNqSXNrTnNrSmpGbkd4UUJqY29DV3N3NzlO?=
 =?utf-8?B?S0pZWVlMUHZCczB5cWd5dDhXLzZKWGRySXM0bTdDWFdVcG8yQVZoSjZDTXlj?=
 =?utf-8?B?U2hXcXUvVThrVVZ4N2xTNS8rN2dtejk1THRIRWI5UVR6Z3NoTzIyNGZmSXVi?=
 =?utf-8?B?UGl2UjNDeFB3L1JKc3Ixb2pUYXpCMzNoWDJITUVRZTFFYThLZHgrUlJYbHRU?=
 =?utf-8?B?dkREN3BQVEFZWC81STNnRnRyOE1STmZSK1FGY1BCelBsS0x2SDZGVnppeEdM?=
 =?utf-8?B?WCsvTTY1eS90U2p3a2FJMzV0b2QvdTdBc2ZaTEdCYXR1WkozRWgxR0Nna3V2?=
 =?utf-8?B?RDdEenRFWXVCTEVWbnJkNGhOR3pRUnR3b3V3N05mdVBGTVV4dWNXd3VwalVE?=
 =?utf-8?B?NkpXT1pXSm12QzkyTksrYTlHc1E4WlYrQ25qRmwzVStYRG82WGJ0K0lkNWQ3?=
 =?utf-8?B?ZWhvSmJLNEY5UnRXQmNXMWlnQzdycGZWOU5OVk9aaTFsYjhQMnJrQTA5MU1B?=
 =?utf-8?B?bWdIaVN4ZHdnRUUrK01NSVFXUHpHSG9PM1hLR0JBd1ptQVY0TCtyRGZWaXdE?=
 =?utf-8?B?RWw4K0VhODVuT1Ayd2x3NGFUcnNUMk5BWjBiZCtrOWxHVzhzZmpVVEJiNjRV?=
 =?utf-8?B?d3JHdlN3bEdGVTFqcEdMb1VNNHU1d0IzajJrTFBEcHFIYVFONlkyMHJhN0hN?=
 =?utf-8?B?VzBaZlJ3V3pQOHFmblBKMmZRVkVIK21hczNDN3Q1QWJYQTNSODhSZ2tDejha?=
 =?utf-8?B?QUI1R0RxcEtlY3lsNk9vS3BHZDdPRmpiamdoVjNBbm5STjdvSkwwY3BOVWZz?=
 =?utf-8?B?UWFZNFQwR0l0bktRZGtWa2JaN0RKSUJlc2pGc1UvVm02V20wZzlHTGs5UWFZ?=
 =?utf-8?B?ZHZlRFcxQVhOSzkxU0VBY1RCeUFBNSt2aU96VWlGeUl5bkNuaUVIdVJTaWRU?=
 =?utf-8?B?aWIwbm9KSFppdWQ1aG5Pc3pmbUdibWFaZmlHT0dka3BEVWg2RjNTakNqNWU3?=
 =?utf-8?Q?jRk9zBWthNkTYbdFGfsmAAgQt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0b9aa1-948d-434e-f16c-08db46917e09
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 20:04:50.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1S9Cduyco8m7p5yOoyxVgYyFQAW8WJTimyw3EF4jBqmFbW7HYsU6NPmRXCtgUE/Q95wX4GaDmZXas2+L438abw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8988
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/23 00:20, Lorenzo Stoakes wrote:
...
>> Could you elaborate? GUP calls handle_mm_fault() that invokes the write
>> notify the pte is made first writable. Of course, virt(pinned_page)[0] = 'x'
>> is not supposed to fault while using the kernel mapping.
>>
> 
> The issue is how dirtying works. Typically for a dirty-tracking mapping the
> kernel makes the mapping read-only, then when a write fault occurs,
> writenotify is called and the folio is marked dirty. This way the file
> system knows which files to writeback, then after writeback it 'cleans'
> them, restoring the read-only mapping and relying on the NEXT write marking
> write notifying and marking the folio dirty again.
> 
> If we GUP, _especially_ if it's long term, we run the risk of a write to
> the folio _after_ it has been cleaned and if the caller tries to do the
> 'right thing' and mark the folio dirty, it being marked dirty at an
> unexpected time which might race with other things and thus oops.
> 
> The issue is that this dirtying mechanism implicitly relies on the memory
> _only_ being accessed via user mappings, but we're providing another way to
> access that memory bypassing all that.
> 
> It's been a fundamental flaw in GUP for some time. This change tries to
> make things a little better by precluding the riskiest version of this
> which is the caller indicating that the pin is longterm (via
> FOLL_LONGTERM).
> 
> For an example of a user trying to sensibly avoid this, see io_pin_pages()
> in io_uring/rsrc.c. This is where io_uring tries to explicitly avoid this
> themselves, something that GUP should clearly be doing.
> 
> After this change, that code can be removed and we will live in a world
> where linux has a saner GUP :)

Hi Lorenzo,

This is the "missing writeup" that really helps people visualize the
problem, very nice. I think if you include the above, plus maybe a link
to Jan Kara's original report [1], in the commit description, that will
help a lot.


> 
> Of course we need to make more fundamental changes moving forward, the idea
> is this improves the situation and eliminates the need for the open-coded
> solution for io_uring which unblocks my other patch series which is also
> trying to make GUP more sane.

It is true that solving the problem has taken "a few"...years, and is still
not done, yes. :)

I'll respond to the patch with a review, as well.


[1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
 thanks,
-- 
John Hubbard
NVIDIA

