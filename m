Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38831427D2D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhJITvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:51:33 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:48161
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229806AbhJITva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 15:51:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hw0l5bb5Z0Vc0BMncPXYwn5fCViHzPw3B9UYBgxR8mXa37sk6Vh0Cprzy6d7KqgPjxHm4jPKnNEeYm/DHgCg0eJYHZACb+qAU8Yk5UylU1vVU7FxZT+GY0PNhwlXgEbBYNs4RZV2x4sHCdxahIKSwcWFrzJRMb0jaQbIEPZC7lWcNB4IUSXGvN9+PYO7Fa2Mvu7EjifDhlfq5WdKMcKzh2hokcp5a/y/HhGHahM5cJpdw6pR5nMxBTFCGVjeZkaToNmMJOUyDXrbZgvKdfXaOWyjrqjg9woyCKpTgfYG+6/P64dCR3nUZnP6MBu+lHbN6VzKhTsNJtdeA7LNYdRw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQ3D3dvyc/zshdKuWiKWgzYm7G7t1+LWUr4xPMXl9ak=;
 b=EcdH/YuVOyyPNFS0E297ouFKhnI2ZrekMWbsR6oRG8hbVi4kxO0yhytIWxlj8jGM+JaSN3bszOdx9Egzb/Uk3oKsjtr9G1BMdET6NxF/52RRD3h3fjMo0pNbSMh0X5ZUcdA2zRE8ABfPatS/sDCsrWE1YQtreIwPipucuN4hp5pJRuNFub4ByfTxFQOZx+mZpRjpGzz1kKDxN6ie9Zah2YThl0hmJxdVrsjzm6u+IsXhGUSHpRujCd+5zmrJ51Z+F5QuXGUn9DEDEYDlCQDW8gNh7bSb5a9oo2SUytuqW8CyXeN6oxJz2lf9rNjx6ju/LStAYbSS6/qJjtNEUdDNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ3D3dvyc/zshdKuWiKWgzYm7G7t1+LWUr4xPMXl9ak=;
 b=bChun6HpP+bM/3vaN3BPCUdxlw7WIUzfwkxPk0yTKG0Lrh9STkAoHKUqTW5nHoWbaSx/b2De1Vn3L0vYZ3JttgSaJyT85D94zsuylpyckd8GtqbY2ngZm4dvkyNP4BkPzEvZeoqWqbtbQ6+g+T+/muzYoN7XeOi6vgZrsqD6hAYAVHcHcBqcJuczv4j6mpDJp9eDaWKCQkOuODTE8icnmhI8P9xtRcn97UU7WzWHFrtA/a5EHcy3bWPwtTGHBHMR1L/IMlqmg/hdpbka182Mg8BnFc1PwfjgBCtQgj6XwO7VshyMkEvjtbZskRQIzbUBIoSDE9v2VVSVD84wHza7RQ==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (52.135.54.208) by
 BY5PR12MB4049.namprd12.prod.outlook.com (52.135.52.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Sat, 9 Oct 2021 19:49:31 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a0ac:922f:1e42:f310]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a0ac:922f:1e42:f310%3]) with mapi id 15.20.4587.025; Sat, 9 Oct 2021
 19:49:31 +0000
Message-ID: <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
Date:   Sat, 9 Oct 2021 12:49:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, akpm@linux-foundation.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, peterz@infradead.org,
        yuzhao@google.com, will@kernel.org, willy@infradead.org,
        jgg@ziepe.ca, mcroce@microsoft.com, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        vvs@virtuozzo.com, linux-mm@kvack.org, edumazet@google.com,
        alexander.duyck@gmail.com, dsahern@gmail.com
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20211009093724.10539-4-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::21) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
Received: from [10.2.48.185] (216.228.112.22) by BYAPR06CA0008.namprd06.prod.outlook.com (2603:10b6:a03:d4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Sat, 9 Oct 2021 19:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b85771be-14b0-4c6d-b555-08d98b5de8fa
X-MS-TrafficTypeDiagnostic: BY5PR12MB4049:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4049B732C2C398780FCB2CECA8B39@BY5PR12MB4049.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NuTw/hT9ebSThEGltu25moleEzsqYGN9FJRmvdH1aVr6StaBYrZsCeiR/YavMZ0ZLluxwTf9D6EDVqvl8KDIKFybWGKIT9ZZ0U0TEJmUzAnqHAgsy4dSE+lD+t1Om4h0YyHyA0gRH9pO48+bbnyRI3bzGz/IlBAxOzj8YvIPYYSoemdSvNSFiAlk8Rg5V8zdX2zLNmNFUHczIfBQ7d/t2Z3W+jpQuBkW+JuG04bilrj71S1un7cSJay0Tl4O8nmG3Gtyv2zKadWa8XbyPqoQHp7b7Kqwa/RNDyi/nNMXtWIeH8czD0MahVT2IIe8Wkd9IqvUDENV9p4wo2S1ofMAWp7jm159YLa0IdlhV4onWI2klhAJf/NjCyM6aXcMia1s1q0tac+yKP4oVLO5i+IgfKCXmDUlaiaxRc43Sp1YIqHSTsyYmLnuHNIsJbaPvOhXgyUBApMiWZ1ybfK3Pu10f5Nou+EiFjJRu6t0TS69hZ/1CGf5hO3ymgAFJPKO80ECAZb1rfWHGDS7w2gsVFZ7lyikSPbACnbcrftujf/Rl+cncTot5FAVdHCUEOuQOLwJqzi3sAGYxVdTLr5vPR/jihszLuDsZ9VL7o63DjvA4m6/z1NZkz9wb+5CkZaG34c9JUBqTZyDnXtacKvforS9FihM/O4BiV2puEEywkSROxRfJPKLpNHhz9LKZAKB+uyh2Oq0TrHmYuI3KOXVWU9dcXVcdutBtzyvtISkFDZQUaI7m3qggSYS9IAD8ioH5tewTDHewwC5Q/A3/13IQREroxu/9FJ+mIEVHZ8MOP4LS29CNHQjH5xZbGFcVGCstoz3qlfJ4fo4pXEUiHdbP98pfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(2906002)(6486002)(4326008)(31686004)(966005)(508600001)(316002)(86362001)(2616005)(38100700002)(5660300002)(83380400001)(31696002)(8936002)(8676002)(16576012)(956004)(186003)(36756003)(26005)(53546011)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXhFQU9vd1BzZnR0aWxlb214ZjdOM3hmMGRuc2hqWTVpYlBsc2sxdURlZzdo?=
 =?utf-8?B?c21kWnRKQnRSYTY3b0Q3WnlGRyswMkVrWW5BTExUQnI4aTRKbWFtSi93bWNo?=
 =?utf-8?B?STR5NWI3NjhBb2w4ZE9JZGtqWWJkeCtOYXRMMHhSTjUvdDdtS0p2Tko5QWh0?=
 =?utf-8?B?Tzc5YzdvZzZwNXB6T1dqUXJvS2Zmd2dnNnRWVU1YVXgzMDRnL2EwL2R3S1do?=
 =?utf-8?B?c3lNaG1BNWpqUklFY2p5NG1nbTFUa2NVM1hPNEF2dGs1WU9xNFZ1bFMyU08v?=
 =?utf-8?B?UGNXUldPVDNSbGtBOWlpMHR4VTA5NEdUVy9iaXgzMWZ6SzkrTmlIN0d0VXpS?=
 =?utf-8?B?RXZRbHlMYzAwVjlsSGovV2NJNEMrUnQyU2ZvQ3pRNVZyWTRSb0wzYy9pREJZ?=
 =?utf-8?B?dlFXVDA5VDBmSGdRYXJQd2FmSUFHS2xWNWYyWk1OelJ1ODg5eXE0Rlhjc0NT?=
 =?utf-8?B?S01rUXEyWGR6bXQ0NTlweUh4eXEzcmVVTHRuZUMxVXBSTUx4WGRKemdKbnpo?=
 =?utf-8?B?bmViK0x0U1FYN3hEWkdDVENZN1VMdkh0VEo1c3FZaFRZZkw4ZGJ0WHJPRHJS?=
 =?utf-8?B?K1p1bkVOaFlYYTVZbmlPcGJLSHVVakJrTVZZN1lzaWVaNFZHMmZjeEJSMmZT?=
 =?utf-8?B?UVVJNjBVb1JEem9kUG9mcnpPbnUrdzE2dFM2U3hnaDZVWUsrTTM3NC9XTElT?=
 =?utf-8?B?OEhsS09vU1ZIQ1pCcytYTWVMeU1VczVEVmlpbTZTN1ZML0l5cWloTklqUkx4?=
 =?utf-8?B?Ti9PTjBjMDJPcTV1bGhyc1owZVVtWjJBbnhEeEtGU3V6cXlFS3V4eXR4SHV1?=
 =?utf-8?B?WXdYU2lTQ3ZBaUhoTWk1UkVwOFl0NmFLeUpqeXBJVThFNHE2UUQzSE1mOHRk?=
 =?utf-8?B?K2NUZGZFNXl0NFhkWFR3NHhiQzdkaEd4cXpSVTVzOXBkTk9wM2hrQURwQlJO?=
 =?utf-8?B?bjF0RzFlQjhhSVhPcFMzb3lOWDFjWEUyUEpyMUo2RTlIZWZKQkZpeTY0RUwv?=
 =?utf-8?B?SUFUZE1lYmczV1VMZklZOExncmU0RVByMDdCYjVVQW5vMVRtb3UzckkvUkMz?=
 =?utf-8?B?bW5LZTRONXlrYU9HSEtJTWFBaXBkV0pianFiRjJ5OU96dzY0ZzF0WHBGN0Z2?=
 =?utf-8?B?cmhDU0Vkd1kzenFTaUJMMjF4b1pONnhabTU1V3RYM0gvNU1Rb3R3ODY2R0px?=
 =?utf-8?B?ZFZUZUV1SjVxeHczVks2SzdIYzZBRnE0VW44MkN5cUFSaWtZMUFkTFp0bHdh?=
 =?utf-8?B?UUR4ZmhTaTVMM3praTBOeUgwQ1Q4bm8xL3VNNDJjaUMxejQvRFhSM3ZhWmZk?=
 =?utf-8?B?aFRzUWlLZk43S2M2YkplcldQdW9hMFNhQ3BRS2JFa3k2Tk1xRnFIajF0aExh?=
 =?utf-8?B?NlMrR0F0b05KYTJNbVNVZHFsZDA1dU5oRXlRWHozQVlEZ04vUm82TkNRa3hx?=
 =?utf-8?B?MklERmdlU3I3Slg4ZEovQzhmYmoyYjZiQk5yMVFDNXprc2dLZ1QveU42TXdl?=
 =?utf-8?B?OWZmSTFOa2VGdW03Sk8rL25TV0pOaXM1ZVVla3h0SjFBUU1ac3dLUXZNazB3?=
 =?utf-8?B?aFJFWEY1a1AwdGU4QUtUejBxNzRZdUV3d1RBYzFPVzJoTlh1dGNGUS90TjBT?=
 =?utf-8?B?L3dFeUR1UUZGYWZDbTBOeUNmcGdHTW9PUjlidldWUGFhSm1tN3d3c0lrWk1W?=
 =?utf-8?B?djNPRkl1Y0xZN2tjaU5RdWxTQ0loS09UQUZ1MnlwSTQvS2szNVZRREdLYVBy?=
 =?utf-8?Q?DnqMgX06+90PcP/22/IaxWAoNCFJO+Cb5/WYdN9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85771be-14b0-4c6d-b555-08d98b5de8fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 19:49:31.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJmN6gGb7dyUiiH+MJgBOlxYY0rjMbaJJ02rV+EMs71gwEBOea+4UlclaVybA8+too52gxbhg5KnTpsxk69LzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/21 02:37, Yunsheng Lin wrote:
> Introduce __get_page() and __put_page() to operate on the
> base page or head of a compound page for the cases when a
> page is known to be a base page or head of a compound page.

Hi,

I wonder if you are aware of a much larger, 137-patch seriesto do that:
folio/pageset [1]?

The naming you are proposing here does not really improve clarity. There
is nothing about __get_page() that makes it clear that it's meant only
for head/base pages, while get_page() tail pages as well. And the
well-known and widely used get_page() and put_page() get their meaning
shifted.

This area is hard to get right, and that's why there have been 15
versions, and a lot of contention associated with [1]. If you have an
alternate approach, I think it would be better in its own separate
series, with a cover letter that, at a minimum, explains how it compares
to folios/pagesets.

So in case it's not clear, I'd like to request that you drop this one
patch from your series.


[1] https://lore.kernel.org/r/YSPwmNNuuQhXNToQ@casper.infradead.org

thanks,
-- 
John Hubbard
NVIDIA

> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   include/linux/mm.h | 21 ++++++++++++++-------
>   mm/swap.c          |  6 +++---
>   2 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 73a52aba448f..5683313c3e9d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -902,7 +902,7 @@ static inline struct page *virt_to_head_page(const void *x)
>   	return compound_head(page);
>   }
>   
> -void __put_page(struct page *page);
> +void __put_single_or_compound_page(struct page *page);
>   
>   void put_pages_list(struct list_head *pages);
>   
> @@ -1203,9 +1203,8 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
>   #define page_ref_zero_or_close_to_overflow(page) \
>   	((unsigned int) page_ref_count(page) + 127u <= 127u)
>   
> -static inline void get_page(struct page *page)
> +static inline void __get_page(struct page *page)
>   {
> -	page = compound_head(page);
>   	/*
>   	 * Getting a normal page or the head of a compound page
>   	 * requires to already have an elevated page->_refcount.
> @@ -1214,6 +1213,11 @@ static inline void get_page(struct page *page)
>   	page_ref_inc(page);
>   }
>   
> +static inline void get_page(struct page *page)
> +{
> +	__get_page(compound_head(page));
> +}
> +
>   bool __must_check try_grab_page(struct page *page, unsigned int flags);
>   struct page *try_grab_compound_head(struct page *page, int refs,
>   				    unsigned int flags);
> @@ -1228,10 +1232,8 @@ static inline __must_check bool try_get_page(struct page *page)
>   	return true;
>   }
>   
> -static inline void put_page(struct page *page)
> +static inline void __put_page(struct page *page)
>   {
> -	page = compound_head(page);
> -
>   	/*
>   	 * For devmap managed pages we need to catch refcount transition from
>   	 * 2 to 1, when refcount reach one it means the page is free and we
> @@ -1244,7 +1246,12 @@ static inline void put_page(struct page *page)
>   	}
>   
>   	if (put_page_testzero(page))
> -		__put_page(page);
> +		__put_single_or_compound_page(page);
> +}
> +
> +static inline void put_page(struct page *page)
> +{
> +	__put_page(compound_head(page));
>   }
>   
>   /*
> diff --git a/mm/swap.c b/mm/swap.c
> index af3cad4e5378..565cbde1caea 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -111,7 +111,7 @@ static void __put_compound_page(struct page *page)
>   	destroy_compound_page(page);
>   }
>   
> -void __put_page(struct page *page)
> +void __put_single_or_compound_page(struct page *page)
>   {
>   	if (is_zone_device_page(page)) {
>   		put_dev_pagemap(page->pgmap);
> @@ -128,7 +128,7 @@ void __put_page(struct page *page)
>   	else
>   		__put_single_page(page);
>   }
> -EXPORT_SYMBOL(__put_page);
> +EXPORT_SYMBOL(__put_single_or_compound_page);
>   
>   /**
>    * put_pages_list() - release a list of pages
> @@ -1153,7 +1153,7 @@ void put_devmap_managed_page(struct page *page)
>   	if (count == 1)
>   		free_devmap_managed_page(page);
>   	else if (!count)
> -		__put_page(page);
> +		__put_single_or_compound_page(page);
>   }
>   EXPORT_SYMBOL(put_devmap_managed_page);
>   #endif
> 

