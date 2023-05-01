Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F56F3B12
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 01:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjEAXnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 19:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjEAXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 19:42:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD143588;
        Mon,  1 May 2023 16:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRf7/+rgZTWXcwOU97tdsrfqRzYzeO/cofpS4Q2NbHux+9WQHztXzlrosldRspdrpGO/k6qPtI0ydFsnVIhftcL3lT4BCcx5IXN1Anna1A8hQF7MxDMMTWK7FTu63hquo69AWUM0cmkcr2sViix5Spf4jjry+DwE+5C5jiffyGTmv839e5tv8GeNLJ9zM3gsVuJAb66mVJfMLGkPWJ7ufJ72xhRpew9Cr1gakSe+/vN83ZnlfLURWnMe0g+mmn19ePD0x5UVrEQylyz276WrKio5MtAHPA2uaBom9A1rEpqweL0sHyLgEhqDaKxIY62huuu9S2IYoPG8ySYXxWgw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kN4VH6XCp6p8zubRs36D4kgn5RUUBwe+kT5byDFcnTQ=;
 b=AAn8AIVzg/Hh+g7YIKq7ikXaGzdytQu8NUnpOSV+bG6AP79uEwpNRG3qJT6/YMeF/8Zwj8f+nDEsBi3G2/J8swtD97rtGCPEch1Is+IHlXbWTYVAA/myWPCdH9x3LO6k0Ww9ZV2Ym9gzCFJMmH2mc7dM7Mrd9RXMjSOHyd46LnbOOk+vtRdYxZHkg1Clxu3RODWs0zjdPiDaZ5ih+/c5d+nRgJtXru4zkl7lj5ep6e5b8iP/jt6I4sRRyMNQleh1hucxUSJTA2YNfqDU6EIBTZfGYxoe734y8EK0A/nTXyc5PAUJUXlocrtbBLX/rSUpL+SkrHYI/o2HTmyszCopGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kN4VH6XCp6p8zubRs36D4kgn5RUUBwe+kT5byDFcnTQ=;
 b=Q7eGDicvwXMPFrtz2vkEqpGRg5BQIh/JAhiZreLJLBRss3CJmM46BKBrT0/L9wPZ5pvLej9OTGsJ/20XIryJRfzvadmS6uX0PhfhxtM9rnme6oyarab1hvkMbpoBnJ00S5InZ+izSQyF4pBxKDeiMkBxN/+4Z73ShdehLbNsnOoq3tMLWGZcOXmoM1pWGPM1nmk7ZPu8QQuVPXtCYkaraPSDR0q0XoUKFBwPI/uOEQHhMqyJUklH2kDr24jIccCVAFUR51pYo0bNrzs7FeDNWKcylVER/RllJpkrd/71vkivH/RgWjstK3YFmrND6yTGTjW9KxHNvCM0RSUQijdYJw==
Received: from MW4PR03CA0270.namprd03.prod.outlook.com (2603:10b6:303:b4::35)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 23:42:26 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::1d) by MW4PR03CA0270.outlook.office365.com
 (2603:10b6:303:b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30 via Frontend
 Transport; Mon, 1 May 2023 23:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.20 via Frontend Transport; Mon, 1 May 2023 23:42:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 1 May 2023
 16:42:18 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 1 May 2023
 16:42:17 -0700
Message-ID: <d4dc3bf4-5a9c-93d7-8472-a0cf6ea9992d@nvidia.com>
Date:   Mon, 1 May 2023 16:42:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox" <willy@infradead.org>,
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
        "Namhyung Kim" <namhyung@kernel.org>,
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
        "Christian Brauner" <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <linux-fsdevel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Mika Penttila" <mpenttil@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        "Dave Chinner" <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 736ebcc6-22bb-4731-33b8-08db4a9db842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbWHv9DQq+dJw4zK8fpKA2Lu7HmWKNP9D80fWCGjU1xKkIPwv3OQtEe3k1VnGn/g8vodYYURE1WMTGmIq64+FzwZJo/ovsGsFWoT4RgfUVdaULGCng2eoS796MuTYRnrE5PSEn35Yfk37CIi/GdeYU9XVTZnZLPOl+0guqjxvU2QTtlrupBpMbt/w7KmIQ+odi7VfA+QMGhTPAunAaBGDVbgEgIF0JHpx555DbYCkI6PgPPP7iSeVVxkuymF+s4ENuRSKAZ8EO88aLHkmEvzRxNDcumYvlHEpcvT8yR442f1YibljI3zuIeKRncIThEsMyS35I9rne9PJ+fPQzFdWjYs/oUc+nzD9ACmitewcTPf3cLIGG2kSh/UknglqEp26RnnBgj64mwEHqfR+Xf5TCkMHCulToN8Kk9G0r660vpw2VwKCg7jEQqPkAPzwDuPuEAnsmxQ4eU1CMDi4MFGN7Pz9wBZRlnSxsBBpUcYaMNYVQvo3FXK9tNJl3D/gv20tRUDKNrHAFeu1Q//AGzDT3C6Jp+oh5Tk0AlWAo8+/taVpVBaURl1qOHtbVwtB28Uhai+n7nY7JDHsK8TIUsBRBlxoJkpcwttKaxGNlZ6jBHCUgEn1+Gv4U73u7z1Shc+gjlSIkRtWUIjOJTyUkugWUMlz3ZNCmHInnEH9RzaBPxvpd7UYlWNjDVUmwM1XqvP00ijfJU/YCdTTKQKkN4N9wYQ7MSN3aL7FWWarfMd7RRtFhb+x+u0QIinje+yzbuK
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(31686004)(316002)(53546011)(26005)(82310400005)(40460700003)(40480700001)(8936002)(5660300002)(7416002)(7406005)(8676002)(31696002)(86362001)(186003)(16526019)(478600001)(110136005)(16576012)(70206006)(70586007)(336012)(2616005)(426003)(36860700001)(47076005)(83380400001)(41300700001)(54906003)(356005)(36756003)(7636003)(2906002)(82740400003)(4326008)(43740500002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 23:42:26.3318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 736ebcc6-22bb-4731-33b8-08db4a9db842
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/23 16:11, Lorenzo Stoakes wrote:
> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> as we cannot rule out folios being cleaned and then a GUP user writing to
> them again and possibly marking them dirty unexpectedly.
> 
> This is especially egregious for long-term mappings (as indicated by the
> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> we have already done in the slow path.
> 
> We have access to less information in the fast path as we cannot examine
> the VMA containing the mapping, however we can determine whether the folio
> is anonymous and then whitelist known-good mappings - specifically hugetlb
> and shmem mappings.
> 
> While we obtain a stable folio for this check, the mapping might not be, as
> a truncate could nullify it at any time. Since doing so requires mappings
> to be zapped, we can synchronise against a TLB shootdown operation.
> 
> For some architectures TLB shootdown is synchronised by IPI, against which
> we are protected as the GUP-fast operation is performed with interrupts
> disabled. However, other architectures which specify
> CONFIG_MMU_GATHER_RCU_TABLE_FREE use an RCU lock for this operation.
> 
> In these instances, we acquire an RCU lock while performing our checks. If
> we cannot get a stable mapping, we fall back to the slow path, as otherwise
> we'd have to walk the page tables again and it's simpler and more effective
> to just fall back.
> 
> It's important to note that there are no APIs allowing users to specify
> FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
> always rely on the fact that if we fail to pin on the fast path, the code
> will fall back to the slow path which can perform the more thorough check.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>   mm/gup.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 85 insertions(+), 2 deletions(-)
> 

Hi Lorenzo,

I am unable to find anything wrong with this patch, despite poring
over it and fretting over IPI vs. RCU cases. :)

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard
NVIDIA


> diff --git a/mm/gup.c b/mm/gup.c
> index 0f09dec0906c..431618048a03 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -18,6 +18,7 @@
>   #include <linux/migrate.h>
>   #include <linux/mm_inline.h>
>   #include <linux/sched/mm.h>
> +#include <linux/shmem_fs.h>
>   
>   #include <asm/mmu_context.h>
>   #include <asm/tlbflush.h>
> @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>   	return folio;
>   }
>   
> +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> +static bool stabilise_mapping_rcu(struct folio *folio)
> +{
> +	struct address_space *mapping = READ_ONCE(folio->mapping);
> +
> +	rcu_read_lock();
> +
> +	return mapping == READ_ONCE(folio->mapping);
> +}
> +
> +static void unlock_rcu(void)
> +{
> +	rcu_read_unlock();
> +}
> +#else
> +static bool stabilise_mapping_rcu(struct folio *)
> +{
> +	return true;
> +}
> +
> +static void unlock_rcu(void)
> +{
> +}
> +#endif
> +
> +/*
> + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> + * FOLL_WRITE pin is permitted for a specific folio.
> + *
> + * This assumes the folio is stable and pinned.
> + *
> + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> + * (see comment describing the writeable_file_mapping_allowed() function). We
> + * therefore try to avoid the most egregious case of a long-term mapping doing
> + * so.
> + *
> + * This function cannot be as thorough as that one as the VMA is not available
> + * in the fast path, so instead we whitelist known good cases.
> + *
> + * The folio is stable, but the mapping might not be. When truncating for
> + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> + * so we are safe from an IPI, but some architectures use an RCU lock for this
> + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> + */
> +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> +{
> +	bool ret;
> +
> +	/* hugetlb mappings do not require dirty tracking. */
> +	if (folio_test_hugetlb(folio))
> +		return true;
> +
> +	if (stabilise_mapping_rcu(folio)) {
> +		struct address_space *mapping = folio_mapping(folio);
> +
> +		/*
> +		 * Neither anonymous nor shmem-backed folios require
> +		 * dirty tracking.
> +		 */
> +		ret = folio_test_anon(folio) ||
> +			(mapping && shmem_mapping(mapping));
> +	} else {
> +		/* If the mapping is unstable, fallback to the slow path. */
> +		ret = false;
> +	}
> +
> +	unlock_rcu();
> +
> +	return ret;
> +}
> +
>   /**
>    * try_grab_folio() - Attempt to get or pin a folio.
>    * @page:  pointer to page to be grabbed
> @@ -123,6 +195,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>    */
>   struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>   {
> +	bool is_longterm = flags & FOLL_LONGTERM;
> +
>   	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
>   		return NULL;
>   
> @@ -136,8 +210,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>   		 * right zone, so fail and let the caller fall back to the slow
>   		 * path.
>   		 */
> -		if (unlikely((flags & FOLL_LONGTERM) &&
> -			     !is_longterm_pinnable_page(page)))
> +		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
>   			return NULL;
>   
>   		/*
> @@ -148,6 +221,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>   		if (!folio)
>   			return NULL;
>   
> +		/*
> +		 * Can this folio be safely pinned? We need to perform this
> +		 * check after the folio is stabilised.
> +		 */
> +		if ((flags & FOLL_WRITE) && is_longterm &&
> +		    !folio_longterm_write_pin_allowed(folio)) {
> +			folio_put_refs(folio, refs);
> +			return NULL;
> +		}
> +
>   		/*
>   		 * When pinning a large folio, use an exact count to track it.
>   		 *


