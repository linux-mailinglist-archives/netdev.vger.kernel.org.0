Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABC6F4433
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjEBMtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjEBMta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:49:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB181AE;
        Tue,  2 May 2023 05:49:27 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342ChaNi011400;
        Tue, 2 May 2023 12:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FN9vBZ8d7br8HP0KhHzVVSNO3Yq7pGTSNXKbLmga7xI=;
 b=V2CPNyCZx6qTQPTh7W73X3Uv9f0ldrm423iwf9YtSO8pA3ev4ulBXhXGqv10Whxyn/jA
 TNiXX5sQDq00h1w9mnj/b0w8NnxV9NpQnxWEniEPaZwEHo9Uv2NDjfJns+KCrNqrOfWY
 iA6hsEtYnwde5ShItZMV2Gw827lQlcmGJzHhqfO+e0ua6vm6BQakHZbJzBU9OJpnWmYq
 XsnThQZpSl3wLeuF6Cne+cQLHOBNk1YQAALMq0zLo4u6mMzZHXQmHXBtxW9pBgBY5KmA
 w2B24pE/zJAhHCcnv8R/Bx+ZCSJAjAu9J6qSG4pJzYw6K52ww3/4OffDiObNVgvcB4GG Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1wh9ute-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:46:36 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342CkBc7023597;
        Tue, 2 May 2023 12:46:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1wh9urn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:46:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3424Pupe010273;
        Tue, 2 May 2023 12:46:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6sk96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:46:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342CkT51262880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:46:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7B8220043;
        Tue,  2 May 2023 12:46:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD7D32005A;
        Tue,  2 May 2023 12:46:28 +0000 (GMT)
Received: from [9.152.224.114] (unknown [9.152.224.114])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:46:28 +0000 (GMT)
Message-ID: <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
Date:   Tue, 2 May 2023 14:46:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0nEiGzh6Zlpvn55uhGAwq8jgdRV-4CdJ
X-Proofpoint-GUID: bqU3cKQwFu1adb2MpL3Bqes67JUjKJIy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=523 adultscore=0 clxscore=1011 phishscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305020108
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> as we cannot rule out folios being cleaned and then a GUP user writing to
> them again and possibly marking them dirty unexpectedly.
> 
> This is especially egregious for long-term mappings (as indicated by the
> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> we have already done in the slow path.

Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
It would no longer work with file backed memory, correct?

See
arch/s390/kvm/pci.c

kvm_s390_pci_aif_enable
which does have
FOLL_WRITE | FOLL_LONGTERM
to

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
