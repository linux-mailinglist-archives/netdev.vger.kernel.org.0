Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B796F1DFC
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346453AbjD1S1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 14:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345481AbjD1S1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 14:27:04 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2725C4ECD;
        Fri, 28 Apr 2023 11:27:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6jqz/amWGIJyskCjFsaitlIeBxt3QCSJNeYbXimV3FejgOK/QMLiy84bejXQ9UZS9StfFf0qDNC1Z5d1FGzVmSZhERbf3BX0Ru6m0lk7Ls2YkmbzJnOJuHHbIrN1zwI0jp0LIgLogQ7bxjaiZBRVPeMqbzdWGCcyVRMeYHG59zHCqZ5hnoRzhdgmcpC1rOeq+RIUMJPakzRLOnISJs7VXXCG593ReiepMk7ovz0BiVxCE7XTtpxTvB+NQk6hLT4i0uaIpez6bE3PAoiaUr0HXZvU6tvWO1czDWHGcwbKCRW/Vc0uQ80ro4ViKiIE1tNDMnpwrkstpcb5MxYvbFpVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mV0Qj1OtdVkVJi2aGHfJeLhM0v+etMq+uvJ+XumaDg=;
 b=jkFi7d5v7saRwm8qr6AgMJvea7BqE8e9XMoFa1wdqeBY9gI7tHd5AzRLQJVovkD1VHMwjGKnwgVey2enh88UDPdNWj8PHmIjyOt2Fz/+R90Rsf/d6T/C6x9GH3a3kkY79vpJATaQ+5vwRfBVdtML8aV112a8Zf2mwHN20sh3QBzjHJfkxmyn3Vdi6qTsN+1IjcpkLXCZNIVfzMT6UozsdFPMJ0FVsaYyvesUlpZvp802uxTqIq80+ktfxTXjSdyM7C5Csxckcx5zVsCiVRsh6ekrR9/te1xz4Ji30hWaOIH6SEWXcBQ5X4D/oNRHvIuJarkhKUh6/OafjWM7dgs1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mV0Qj1OtdVkVJi2aGHfJeLhM0v+etMq+uvJ+XumaDg=;
 b=PXVSPW17y4UkrrX017cXl+uQcbbXlPh/XOhsJcy0QhPM7sYGAPK8WppeC7ayizYqTYGjg/pzfZ5F126KI30/tWbKAC7QCApLotgu3ow6nBuXosntUi64ubKKTXlNPbJVKhhdL4UH9W5/Z6ZUhTu9hFPEux4Ub0JCUt5UHKuOpZKDggsBtinXKX+Z4ZM9vEln4Sq8Ppim6aB5xgYckFxGB0vactaq/X1B4i/WJ7IZWoMDNUzDRxj6m091BvB94SuvnnbJi9iFL9Y/lcUznKo/9JClkIeI5/3XlhG+xcXpIVFigl0U2Lb2Nn08JZWLwt05iG9n+3AZo6OxNEeijb5VSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 18:27:01 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::4514:cdc2:537b:889f%3]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 18:27:01 +0000
Message-ID: <ee1426d4-062d-74d5-8a9d-8bb06d554518@nvidia.com>
Date:   Fri, 28 Apr 2023 11:26:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
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
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name> <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <40fc128f-1978-42db-b9c1-77ac3c2cebfe@lucifer.local>
 <3d7fcfab-e445-1dc7-f000-9fbe7bea04c0@redhat.com>
 <bd470e63-e2e0-4532-8aab-cffe326688b6@lucifer.local>
 <7e096879-4578-36df-4809-3b04f4c20587@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <7e096879-4578-36df-4809-3b04f4c20587@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::27) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: 44cd249c-c632-4b3b-ec29-08db48162873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /O7XzFknRqq9YXZHhFu2n9+0mySwAidToZqsvW2fuh6d5N+4GLNwOpZ+xOnrzQeQUsCEMw2q/S2hb7HP4S7ekbtIroljMRT0MvPGefZnSyu8h55MFo57bZeWLKHWHID59WAbT5yUml7hJxnVqV0Wtoc14STP7LHUwjHwOHeMMXqmzlgiDXM6uOZSpiNdzE3OtYIaXhjUOGUIrr/yZWd8EY0NQ7YvBDASpWWaMQY2k4CUQK5J2n6wXZHPG6uU4xzfJ+/BoKDj/g2MZptvUb1LS2rMz80aQ+zXlYDkvgunOtmmUaD0Hmh7W6ICR05bylMtwFzjdtsQDWEWodm5zr1HkrFop2qs/TJhfPnxf7gSWyfrQIljP17bOo7YYkxQEajCvKLwm3OKHWrGALAUGV7xyh5XDz8uU8GVJbXo3ym/6LABcgRVvnqhpxVLw/QagZTtQDnuJo5V3wXfb3Dub00PNwtJFuuok1TDLj6CKJbCRRrQU5dZVBnUrq6Cohx6bK8/31WWaWKF7YU5wbPCvgMV9lIK+eLMllmaTZYjtxO7pGtLJE6OjM6pR+G+dTUVBDoqYXd7MrAEdYfxKjxSgXiXFncXDk2vJnO90AHIxoVLJrC1daEyhnzaC1UTzfTEiAhTkKtpIqcb+DRSZSRGCdwdHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199021)(66556008)(66946007)(66476007)(316002)(110136005)(4326008)(54906003)(7416002)(7406005)(5660300002)(4744005)(8936002)(41300700001)(8676002)(2906002)(186003)(38100700002)(53546011)(31696002)(86362001)(6512007)(26005)(6506007)(83380400001)(31686004)(2616005)(36756003)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGIzMnJZVXhxQWF0WDRpNUdROGU5ckEyRVIwOXJHN052RnpOWVlLSmdta1FG?=
 =?utf-8?B?SFlBS1BqUDNsM0gySFU2bmprY1NUaEtJaGhjM3F3NnJVdHdQWmF0MU5MT2h1?=
 =?utf-8?B?QkwwUzlINTJ2a1pzTTNnSlo4cDEwMng3STIxZE13LzdHTHhlaE5MZG5MQzQz?=
 =?utf-8?B?Z25DRXhQbTR1UDZGR0F6bzFRNll5bHJ2cEhnZ1d2ZHc1Umt1N0FsMEV0TGUy?=
 =?utf-8?B?M1ZjdkdGb2xiMXdFVEtOb0czNFZiSHkxMC9zeHgxOHliRXFjQzNWSVdjTUpr?=
 =?utf-8?B?Q2lBTWJ5TURqMjFoS1pZWkIvTnIzOENZMHYrSTVFMTdtUkZYLzcrSmRGaU5Z?=
 =?utf-8?B?Q1c2aEl6TGxyWm9RRVF2bExkMnYwSHRhb1ZaWXMwbUNJeGk1c09EMTIrM3hL?=
 =?utf-8?B?YU1ZVWtCY0sxWmQ0ZTlCTDVWZHpRVGgxTjdNZ2ZGZDh0RVZBM2FXZGlJejRa?=
 =?utf-8?B?c0tONk9RWUR0TUVJWFdtTXJWZHhacmsvUFFyZUMxQVdjWURycnFYbytRU0sw?=
 =?utf-8?B?OXpYVW1lR2toRURIZ21tR1I2VGoxNC91SEVOTjBBaU5iZ08zMzFoSnAxUEtY?=
 =?utf-8?B?Nm1NK1EvK20xZzZCN0QzRnpsc3ppVHZSZXBPb0pPQmNRL25xTDVnYTYyRGV0?=
 =?utf-8?B?eUZhMEIrV21CQk1ZazRvUzFOczVVdFBpK2lrbWlHdjJTWkN6dlFnWHQxSTNV?=
 =?utf-8?B?b3MwSnV6aUFjamFhMmRrbExvcGgwc0ZDNzBYSTJHMGpOTUZ1bHcrTUNJazRJ?=
 =?utf-8?B?ckVHY3orOGtBaUdiQ3l3ejJDbUd3bXhEcGViZ0xlMHc2azBQY3dBUDZ0TE5m?=
 =?utf-8?B?SStEYjZ1Q0w3cWpiQzJUaEV2YytlTWZvOXdIM0VaZUVhaGRGejI2bEhIVStz?=
 =?utf-8?B?V0lwZHVlaTNvY1ZERTNVdnFhYUN0NStQWWRBMmVJeThiZVBUYm9NeW5pWFJH?=
 =?utf-8?B?cWJ0SEdxc0lDRFpYODMwcUEza1JKQUZ2S0VBaC9udWVwQk1XeHRLYjlmUXpm?=
 =?utf-8?B?RWpCYlVCbndJQXNMcElmVG0wNHdDRTZhWlBxaHpRMkNkSG9WWFpvUDhGZW9r?=
 =?utf-8?B?RW1DeGVoMzIyRVVzNUpDeTh0UzJTNWNtYlFIdWNxUUtFSTVObUdlUU5sR29L?=
 =?utf-8?B?OXF0bzRGWldzaUxobUFLL2N3emQyNmlOTGZNNmhwb0lPNWhuMitMQk80aEdp?=
 =?utf-8?B?TTNhdFpPY3Y3SU90Nk0zekt0WW1mbjl0QWNibEg5Um1pODN4TzYwTkhGOXo5?=
 =?utf-8?B?QUlmdmxQNkt4K0UxdU9aQ2ZhbmpMSUdqb0tpS1l4MkplNTNJdE83LzVrQUFW?=
 =?utf-8?B?WERZcEdMZHhnejJZZm9ibWtscFZGZEpDSUZsVVpvUkNHeW91eVN6L0pIdmww?=
 =?utf-8?B?QzNiTEk0QlpLVEpGV21Nckp3N1hrckVoelBGRElNc0E5VWJYdnhNa21ReUdP?=
 =?utf-8?B?UU5Ed21oalRQTkVNb1hWMzc5MFd2RE5QRHkrWW0zYlF3Sjd2RFEwdXlnQmF4?=
 =?utf-8?B?Y2Ixb05sdkFvM1FKbmF2dysvaDdra3hCQVVLeGhiZEZnNWw2WnRqSHE1V3Jr?=
 =?utf-8?B?RUt6WDlGNUZ1TmdDSnBjcFZzR215cSs2aC8yY09PV3Ntd0J1WERxeXhmeEs5?=
 =?utf-8?B?enEzeUdsYmx0MHNPOFBpSnRGU2ZzOHd5MnRHeWtwalBLN2MzTjFUTFV5MkIx?=
 =?utf-8?B?dkNLbzFkdGpTUW9xcGh6Qm1aYnBEaU9GT3FOUmFxWnEzZDR6Q2JzaGs5Z3U1?=
 =?utf-8?B?N0pvWnlPZmt3NzFmWnd4eDlETXBBZkN2MEcyVEVtcHdPVlR4Tis4Y3NXbzJJ?=
 =?utf-8?B?Lzd0bFFNRUh1RURwR08xOUQ0dTdvN2gzV1ZrT21NeFN1U2ZGc3hTVjJoUHpC?=
 =?utf-8?B?elRWY0FIU1lsblI0NGpMTW5EeGtJZTVEcGFsMmpIL3FrdXFiUkk2QnRZTkE3?=
 =?utf-8?B?aUpwWG1kQldTTk14bmhuV0tuaVdpRWNpNk56SWlxd0MvWGlFVWdlTGptMFpx?=
 =?utf-8?B?N2tHd3pqakxJWk5nVVYrSkMyd0czdmJmZElWYjJqSFY3RUp3N3BQVUg3cEsy?=
 =?utf-8?B?WnY0Wlh5UXN2R0FhdDU1UkRZZmdkSm5vVTVpVXkwUlNIMkwrN0lZTWErOXF6?=
 =?utf-8?Q?2cusZ1btFVzFLoJEPB7ZGF/5Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cd249c-c632-4b3b-ec29-08db48162873
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:27:00.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRha7DYonPVQPRXemm2MJRmVGki0xLByPdtmWmsTGfws/Fot0PQEAS6eAsyVAtfnJP8PFFglfAYdP4TM/udbAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155
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

On 4/28/23 10:29, David Hildenbrand wrote:
...
>> Is that an issue with interrupts disabled though? Will block page tables being
>> removed and as Kirill says (sorry I maybe misinterpreted you) we should be ok.
> 
> Let's rule out page table freeing. If our VMA only spans a single page 
> and falls into the same PMD as another VMA, an munmap() would not even 
> free a single page table.
> 
> However, if unmapping a page (flushing the TLB) would imply an IPI as 
> Kirill said, we'd be fine. I recall that that's not the case for all 
> architectures, but I might be just wrong.
> 

Some architectures use IPIs, and others use an RCU-like approach instead.

thanks,
-- 
John Hubbard
NVIDIA

