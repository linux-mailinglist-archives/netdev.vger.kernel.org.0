Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE46F1DF6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346415AbjD1S0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 14:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344368AbjD1S0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 14:26:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A749449D;
        Fri, 28 Apr 2023 11:26:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4e9rLSRJxTxDy0w8wFnuPxyzP5lrUJo2AWJ3So9ySlKYuwBvVSAHyXw0cpKrTdvcvYRPf+MhzPb0n5OgJbokSCSY7ZOaWtFYaxKgqFFAShLayMu3GwzG/n8h4xrmHWpwb3EU8pWUfpEGmPAK9cJeCB2qJnOYwZNzzC4m27QA3zxkl65ngN/DIKoaGlzkhUa98m/OvRVDLgxnPksrEnA1L8cbD1SCuEQtIxHxqKq9uSZeO7TWPDPupBRHOv1mwPaCaULReNoqPoaKf1ssGe7B0hQqaCcbejt2X/Hqqd62Tqnmmg0Pn1fmfAyGoVdoZu8d8qi9Qc44W6z5gOH90YGsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAGOiOI6S+8IMzxvKLWR7KxzL12dBCIy56YRpCpIG7Y=;
 b=CkW/2rABZuJjyXr+EtQZu39JrLGV2V2ERKwrZPd7bTUikbs/aDgb5YQXOFkQy/LlqidFktE4kxmZBZvPM11+s/ymxgmf6sDB/kCAS++TYMBlLCSk31xhPiqI8VDUzwhPavbOIPM058au1ZuJXTrJ2ou7QNd/Qh0Sjfl9C/PzCFsvyNvyu9JwiGi+fmGNbwSvABh1SN3EQXJHhtg+S1XD1YUizMXTvypfwDAo3Fp+jXpRquGdSUHHfJbex26GvXDUTITTDwFWqEobJ1cMf91Ll573fMqooWa4UmX8PqI7F7yN8Ais/e9oroB/I313XBnqHTReiF8MurR5ME2r1PNZcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAGOiOI6S+8IMzxvKLWR7KxzL12dBCIy56YRpCpIG7Y=;
 b=ifX2LLmXFwB1sf/e7YOQWcsoVISz73Ta8k5l/3vlo//jfS70Nn41GYy9GwtIKgPnxP/0RzPJ1PTCSsPWg6FX3PVZCv6q4JxaGAzSwn9Opn7OoilWklNr5lUmo/Kz2gB3zD5FsvtfEVreitBKI+y18FyPW9oRjUQ5ojPK6AyaXTQSF8rAH5ImQUhQobopuluCyfmBL8a2WkYqMAzKU4K1eb+GAYXkrB16QwN/vUq/RwzdVesUOvg2AyxBULcEKKdHaFu0JPSHs9zCMDv59B8qQOmGQhLHuC/RJvjDqwtKGZqMycrqYIEzxmLqK2wBqbJKQdbP6aN/BX/NdGUm1VNXyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 18:26:04 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f%3]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 18:26:04 +0000
Message-ID: <afc2f63e-67a5-803b-883b-bc1f13ba452f@nvidia.com>
Date:   Fri, 28 Apr 2023 11:26:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com> <ZEvsx998gDFig/zq@x1n>
 <ZEwDelszXBRwUGS0@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ZEwDelszXBRwUGS0@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::27) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|CH3PR12MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: f2052b31-d3c7-473d-a530-08db48160698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFRh8FNGtG7a+tJuF71nje5iitSsmWHMBMYk7Zos7uGAKNzHi+7IPq5NChsn20K2+b8X7XEZSmJOgxlSaR/HYiU84DW9oARQKngPXD5MFKudMhobje8aVXyokiCWjX65FyUvYsPVqrmZMl9u0SSpRmaLQ3omBG3/TuWWL+vyZmB2/TCGDyWOPXnz0RG0QhyVwMz+ta6EN/DynWgLLYRFqh4W5twH/psiGHTIogDyV8x7rYGz0nw6/4rw6cvDBz5EmhjErDgNapL30ZF6SsjOp1gSwfHYGRhjlccNvkaNrQe8jNVYr60hoT31WPtvDu2clxrzRUx1HRw1olwaOWRDHRD9MQAdreuhhpYgYRJwMbAe7RUNXRVS87EC1pJn/mkuKtCPKaYIlBgCzj/Wf7qPMjSCr5G4HpUrwJcE9krjFBaHeqzsDd3sEGTTeubn9J2KRRozPIIxkhz2s5o2l7w9qnciJ5iHiENLY2e5BqIU9o0ovA7ZbaiK4u/BZsg5eTgnniLYzrGgQmIDxa9gyYBAfU8YLU54XQBqLIYN0GwnPHE8v9A2FrJlbkEGho/05QQ/P5LcQlPYiCFaCPOLlZJiBcH8IyzBRF23Cg4otCqpRBAln2tRTp8pdOOO5kLbxPuLoHZ1cp8RR5o3Y0VQ2u4bJUlBzDhIZZXD0aW3Yqbxh3pT4USRmcl2ycPuLM4PxI96bwbRnpDpPjysdIMGDXS+3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(66556008)(478600001)(110136005)(54906003)(186003)(26005)(6512007)(53546011)(6506007)(2616005)(83380400001)(6486002)(4744005)(36756003)(2906002)(5660300002)(4326008)(38100700002)(66946007)(8936002)(41300700001)(316002)(7416002)(31696002)(8676002)(86362001)(66476007)(7406005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGlJQk1XakJ6cWJLY0pmVm9SUXVtN3lnck93RVk5R2loSndLSmx6WUk2ckJY?=
 =?utf-8?B?N1JSZVdqVjZYQ29PVXcycEFpL0pvVkxmZkUyYnY4dytJNnlOTzkySlBPUVZK?=
 =?utf-8?B?OWJIcStudEZMR0xoc3l4YUVuKzZCZ21zUXBPdnlraktldlRON1ZjT2dIcVkv?=
 =?utf-8?B?dXlWYkI0UGsrWnhHYlowVCtLNmVTU3ZWcVpNeENyVVZLSG11MWtIWWxqMVVR?=
 =?utf-8?B?SmovUUh4UjIwaDFNeDI4Syt5bU1VL01NTWJ2MlRsLzRzaEpkV0RPUHhWQzBl?=
 =?utf-8?B?WU1lWThPaGNWRjVzT2Z5NWh0V1ZYRmVEWGI1L09Nc05XTmsweERmb3RPV1Y1?=
 =?utf-8?B?d3JtZVVIK2k3eWUrazhmcjA3bk9VRldsd2RmNGNaSm1NMitJdW0xZHFqRDRC?=
 =?utf-8?B?NXZXdEJOTUNUcjRFem9GU0tUVGxEVCszbUI5RUNRaUdhL256U08yQ21Sbllx?=
 =?utf-8?B?aWRLN093bWV3N055RVJaWWh3dEdTR0xKK3ZxOXhmSWxQNjgrTWJZZEdHZkdG?=
 =?utf-8?B?MmpZU1BTSGtYZmxkNGxDKzI5R3M2YU1jakttN210N2c5MGI1czhnTFQxNW1M?=
 =?utf-8?B?eE4yLzRxeExtYlEvWmw4NjhLNjJ0SFhmcWxTY3F5MEtZSUlsaXdTOGxYajVW?=
 =?utf-8?B?MHhQMGphRCtvQ0JzbHRQeHhjYUo5dkpOQzZRZm53Wll1KzErdjF4MHE0cS9F?=
 =?utf-8?B?SkN0RkNJamR0Q1J3Nk0wbW5WQ0M3Ym9VNFN6MUVoYWsrellQdzkzYy9WOG1j?=
 =?utf-8?B?eENRVmoxZEFiTjBhakQ0cFdTdytsc2daejFURFAzYkNvVzE3dnhxeFZHQU8z?=
 =?utf-8?B?RkhVY2JiYzQxaFgxcktQTlpkcHRvZUF5R1lXRExaOXJ5bUhPa1R4Qm5DTjVy?=
 =?utf-8?B?UzdVeHBSbk9DQitWUmc0ZFc2OUVhMGlnVUVDK0xLa2pUb1FLUGFFbU13OG0y?=
 =?utf-8?B?RlV5VWhvOFp6MTRVa3FlODl1SjJaSHFMQ083UGVoZFpQdElhNFd0OW9FTm0v?=
 =?utf-8?B?RXBCdHlhRlFvNjNyL1dHRURDUloyUDFJWHFRN2dtQVY4ajhuRGdPUERXaFZr?=
 =?utf-8?B?dGtSYVozNHhEL29tZUNRdzRLZGl4Z0t6MVF0U3R5T3RYellaOTUxMmUwVnZz?=
 =?utf-8?B?SlZtbGROWjY2ek9lQzQ5TkRFQVVhY2x5dHc1emhMeUd6WWUrRXdpcGRTbzRh?=
 =?utf-8?B?ZXJQQ2pJVEF4VUkxRzRjRHpuYWNLOVdSTXBMaGhhU0pRS3RSOFJUT244Q2F3?=
 =?utf-8?B?ZGo4TG9rM1IvaDRWYVVQNERINTJaMjhWMzMzWWFJZ01LSVRocm80VDI2SlJw?=
 =?utf-8?B?djkxVFdjeHovYmYrems3WFltamY4ZDIvR0ZMbiswWnlWQytGWGdHUDZ4Q0kw?=
 =?utf-8?B?a2ZVcFBJTWZnZVJnR0hGTlBMRUNHZDYxZ1JSdUlsell4eTN1MjJOSHRRTFR6?=
 =?utf-8?B?ZGwxWW1lbWo3R1FMYWNBemVibDVIb2xMdVR0Y1ViOVZkRk9SVXcwWkxuTjVO?=
 =?utf-8?B?MjJJdlNZZmdFVlI4WEFSRndvRStLbDI4VllmREFzUmwwOWp2amh1aU5JaDZj?=
 =?utf-8?B?U0MwTE9DTExCck1oT3NCR1FUK0lOTkJtdjUrYjliMmhUWjd2ZE5BSkE0YUx2?=
 =?utf-8?B?MlNmck9xQXF5VUhUK3ZoYzNVdmpxeFRIUzZEUnBpTUdxdnVpMDZNQmZ2VUZx?=
 =?utf-8?B?Tng5dTgwZlBxMGZYTGl3Y2ppMk5kbGpoL0VGeWZnR1pLUWxUQW1jTzUwazkr?=
 =?utf-8?B?TWNVWDdLNUN2WUxDY2JIVWx0dDhYV1NkWlNMdCtQWUVDdXRXK0ZjY095Risv?=
 =?utf-8?B?WkRSYzBPSkxhTnpFSVYwWkZ1SFA2clVlejYyTllyL2l0YmR6U2V6MWpsZklY?=
 =?utf-8?B?WldKREQvdUd3TDFHcTkzZ1VjZ0htU0V0OTcwNjNtbVZhNzF3N1ArNXpBNDJr?=
 =?utf-8?B?MDJISXIvWUQ2bjlWK3k3VmtnVVBZZ1VyRHdaMGZmbjBZMnplMWRHeFFBS2wz?=
 =?utf-8?B?VWdpa1ZaUmRwQXBxZkFyck1TZzhiL3NNa3QyTy94eGVQOHFsbTBpalM0cUVu?=
 =?utf-8?B?eENHQVVJbm9QdFpnZkdkOXBMY0tNM050T1dkTGJMemc1V0l6Tm91OVN1ejJ3?=
 =?utf-8?Q?3ZNKKBcFKNN+axPOqz0mtF9Th?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2052b31-d3c7-473d-a530-08db48160698
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:26:04.3327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AwhjDEk8Ok9VNeIJ4V3RPBPWa5NoEZjEdndzUNBVM/4mUN1wEc5XB3bxkNKTsD4eWcuehKvsiz8TWSX3cw4JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8660
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

On 4/28/23 10:33, Jason Gunthorpe wrote:
> On Fri, Apr 28, 2023 at 11:56:55AM -0400, Peter Xu wrote:
> 
>>> PageAnon(page) can be called from GUP-fast after grabbing a reference. See
>>> gup_must_unshare().
>>
>> Hmm.. Is it a good idea at all to sacrifise all "!anon" fast-gups for this?
>> People will silently got degrade even on legal pins on shmem/hugetlb, I
>> think, which seems to be still a very major use case.
> 
> Remember gup fast was like this until quite recently - DAX wrecked it.
> 
> I fixed it when I changed DAX to not post-scan the VMA list..
> 
> I'm not sure longterm and really fast need to go together.
> 

Exactly: gup_fast + FOLL_LONGTERM is asking too much of this system,
it's really excessive.

I like the idea of simply: "if (FOLL_LONGTERM) jump straight to slow gup". 

thanks,
-- 
John Hubbard
NVIDIA

