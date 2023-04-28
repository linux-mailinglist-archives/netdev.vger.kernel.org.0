Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7EC6F1033
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbjD1CGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjD1CGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:06:41 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02hn2200.outbound.protection.outlook.com [52.100.159.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464253A86;
        Thu, 27 Apr 2023 19:06:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbjkH2vREhraryIFs37Ff5HiEpUIKxcpXc+XGRKYsapF9LhkLHGfjl5rhDYV5eAVk4hC9B4eZObj1wcxXZ4cbArMkbIFcPEY7TzDITq3Ure2jotiZAoDis1rMPzf5uCrKuwI1zTAexA5lGupS3FXxq4No0S9/0KczXNVbSqjYtIvXFiTr/AUJJfLgP2dJ9w1Oo/8kktUAbuA8nQXT1mFepSROP3Wg8fqNfxwYSNIrap7uQ+pdUXlBZAdnC5pduP8iCXqg37fivT1LkZLj92zWcbqpcqrEDpyMPI+DitnqsL/FNGrp8bsTzQe+ySqutqbWRt+SBKLCMbt2zwWfHUIKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjDqfl1rsKwvXN4xEu7JighzoW2/rXyrDsnlvlddb6E=;
 b=hEhUptH2l9C04g3HPngu7mrYKgEDSw5huFom6kzRHtkTuE3He+DkODe6ara+8uMix2YLeh6M4YtZiFc4d4m/EgSwPn7pNOuy9T9Sia44PQQX1daw7Hd3kHeiY/HQPzpaGPu2TU5rc1OgQwCEjFntic8EdB+HARYxkSqQfZWzuY9P6Gs81ydwQShOh+3wRWyWbO+MgTeYdtsIJCdArdfyiKCpbG7/PlGO1N0lkO1icma2gQ0yjZ8X5+9qxprS3CazN8W19rjYDUnajfDyAzqx7OKA9tpsoaCdIAoPYkY/SOkr7GNGU1Ey/Y9Y4JWWSOhuV6DA306mG7gAfdwbksncFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjDqfl1rsKwvXN4xEu7JighzoW2/rXyrDsnlvlddb6E=;
 b=LzG/caiFzsJ1tFmBWO5YLv8yWfB6ozPGuNjhqKqgMlkDWU3y2SJuNLDOMeTn5nsvPKujl5Rh3c8CEs4x0UdSQjlMvwaJCbc/c3SmtoQG24dMqDj3+lvIqLG80N83eyvRu379LpRQ2ZDiw/s66JKX36oJVcDchoaUDUrUin3846ibueGP0xTVeKsXVFKSTmnpttk1SA5/PrfKpkD2v1yWHzKSYyGyCfXnaTLVIZeM/Q0N3N1bHZe3ssYnYGMZmU1Fcuskx0IPhuPUPESeMhI2ra2BIJVqduqWZlWGiox2qqRBO3QzSu2quqSUnYApHHNnsm1oJefBUGha3QXO+vf8lw==
Received: from DS7PR03CA0187.namprd03.prod.outlook.com (2603:10b6:5:3b6::12)
 by CY8PR12MB8316.namprd12.prod.outlook.com (2603:10b6:930:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 02:06:36 +0000
Received: from DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::a5) by DS7PR03CA0187.outlook.office365.com
 (2603:10b6:5:3b6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24 via Frontend
 Transport; Fri, 28 Apr 2023 02:06:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT089.mail.protection.outlook.com (10.13.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.23 via Frontend Transport; Fri, 28 Apr 2023 02:06:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 27 Apr 2023
 19:06:32 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 27 Apr
 2023 19:06:31 -0700
Message-ID: <6d418a81-7c09-deb3-ef74-090a0749470a@nvidia.com>
Date:   Thu, 27 Apr 2023 19:06:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
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
        "Mika Penttila" <mpenttil@redhat.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT089:EE_|CY8PR12MB8316:EE_
X-MS-Office365-Filtering-Correlation-Id: fcba6790-006d-4f4d-8640-08db478d3290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAcU3SWWImE6OI46lXwPCGNLx4ow4zgYxJRN0xK4Fc0A2THYdVin7/0bV4ECwsjgz9Watou+opOZO7mK+YSKNmnp7fQnBjz5m6h1UL20X6BaHmOGQUpDOqzSVXk+YNlVjd7ydASZp9yb89I2ApgDq1tfEryqtghPifRvEujCdaUITVrn+QWbQS6A1VXTAOlyaxo/CNpdtyvlTaJces2cykHOqM5z69rPGmrPyb/D0VvUwZTDY83A0BD9P78ZDgUdKTYlOH7uc+C0FrWmOKmnGHtDCBJMskTuZRNRB87mlfuOl/L+c2VJQpGpHipjXjy+GxX1BdbX1UF23lzHFkpUKXVpQ9xg5YtQDdwufkc+RRDOiWxs5W0Q37/mm4qclL+R0bKCetxiWpCr6+0IVFe5JKTxYV9nsmKqLu40jFzqc/C37d8oTZKcar31yFgjhaN691X/oH30fV3qMH5kS3VukYWjZBxJVQcRlMWyddZ/ZbHT0ytQtgegihjyB4dK18z5T+MlOleEy4k1q9Ef8+NQeEG99jtR5DSOohkZ9IIvG4TN2ILTnFx73j5jSLkHwAtaiS59dyosvGscc0PcLcpllIpKvynfyGpQWTcAnKSn4EGBKbx1tq9Dz3ZrQTyiEQVyNSagzffUCRcJuH+5pAxz8+bLl6SPEMxdq2tI878ADetjf/0eBZSz/S/AOOf8JX/3SiDAYrfa7TyF43RRKLXe6F2AG0f/6VbFyFZN0FlPLJFjBaV38HFWBg82VUnu6rBqYioEk2vuAGC1niCLCJOGxyHywil65JpIckvRhMebn7GvRVHsBRxMmIiCqqKUcFHcUKeu57pgDa4uccY3DgHSapfxJp9d7+LW9ljfIgYiQ8Q=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(5400799015)(451199021)(36840700001)(46966006)(40470700004)(82740400003)(16576012)(31686004)(478600001)(83380400001)(356005)(7636003)(34020700004)(54906003)(110136005)(186003)(16526019)(316002)(2616005)(70586007)(70206006)(36860700001)(82310400005)(4326008)(41300700001)(26005)(53546011)(86362001)(36756003)(336012)(8936002)(40480700001)(8676002)(40460700003)(7406005)(7416002)(31696002)(426003)(2906002)(47076005)(5660300002)(43740500002)(2101003)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 02:06:36.5787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcba6790-006d-4f4d-8640-08db478d3290
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8316
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 16:42, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>     the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>     the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>     direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>     (though it does not have to).
> 
> This results in both data being written to a folio without writenotify, and
> the folio being dirtied unexpectedly (if the caller decides to do so).
> 
> This issue was first reported by Jan Kara [1] in 2018, where the problem
> resulted in file system crashes.
> 
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
> 
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
> 
> However, for the time being we introduce this check to prevent the most
> egregious case of this occurring, use of the FOLL_LONGTERM pin.
> 
> These mappings are considerably more likely to be written to after
> folios are cleaned and thus simply must not be permitted to do so.
> 
> As part of this change we separate out vma_needs_dirty_tracking() as a
> helper function to determine this which is distinct from
> vma_wants_writenotify() which is specific to determining which PTE flags to
> set.
> 
> [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>   3 files changed, 68 insertions(+), 10 deletions(-)
> 

Looks good.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 37554b08bb28..f7da02fc89c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
> 
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>   {
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..d36a5db9feb1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
> 
> +/*
> + * Writing to file-backed mappings which require folio dirty tracking using GUP
> + * is a fundamentally broken operation, as kernel write access to GUP mappings
> + * do not adhere to the semantics expected by a file system.
> + *
> + * Consider the following scenario:-
> + *
> + * 1. A folio is written to via GUP which write-faults the memory, notifying
> + *    the file system and dirtying the folio.
> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> + *    the PTE being marked read-only.
> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> + *    direct mapping.
> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> + *    (though it does not have to).
> + *
> + * This results in both data being written to a folio without writenotify, and
> + * the folio being dirtied unexpectedly (if the caller decides to do so).
> + */
> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> +					   unsigned long gup_flags)
> +{
> +	/* If we aren't pinning then no problematic write can occur. */
> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> +		return true;
> +
> +	/* We limit this check to the most egregious case - a long term pin. */
> +	if (!(gup_flags & FOLL_LONGTERM))
> +		return true;
> +
> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> +	return vma_needs_dirty_tracking(vma);
> +}
> +
>   static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   {
>   	vm_flags_t vm_flags = vma->vm_flags;
>   	int write = (gup_flags & FOLL_WRITE);
>   	int foreign = (gup_flags & FOLL_REMOTE);
> +	bool vma_anon = vma_is_anonymous(vma);
> 
>   	if (vm_flags & (VM_IO | VM_PFNMAP))
>   		return -EFAULT;
> 
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>   		return -EFAULT;
> 
>   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   		return -EFAULT;
> 
>   	if (write) {
> +		if (!vma_anon &&
> +		    !writeable_file_mapping_allowed(vma, gup_flags))
> +			return -EFAULT;
> +
>   		if (!(vm_flags & VM_WRITE)) {
>   			if (!(gup_flags & FOLL_FORCE))
>   				return -EFAULT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 536bbb8fa0ae..7b6344d1832a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   }
>   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
> 
> +/* Do VMA operations imply write notify is required? */
> +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> +{
> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> +}
> +
> +/*
> + * Does this VMA require the underlying folios to have their dirty state
> + * tracked?
> + */
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> +{
> +	/* Does the filesystem need to be notified? */
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
> +		return true;
> +
> +	/* Specialty mapping? */
> +	if (vma->vm_flags & VM_PFNMAP)
> +		return false;
> +
> +	/* Can the mapping track the dirty pages? */
> +	return vma->vm_file && vma->vm_file->f_mapping &&
> +		mapping_can_writeback(vma->vm_file->f_mapping);
> +}
> +
>   /*
>    * Some shared mappings will want the pages marked read-only
>    * to track write events. If so, we'll downgrade vm_page_prot
> @@ -1484,14 +1509,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   {
>   	vm_flags_t vm_flags = vma->vm_flags;
> -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> 
>   	/* If it was private or non-writable, the write bit is already clear */
>   	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>   		return 0;
> 
>   	/* The backer wishes to know when pages are first written to? */
> -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>   		return 1;
> 
>   	/* The open routine did something to the protections that pgprot_modify
> @@ -1511,13 +1535,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   	if (userfaultfd_wp(vma))
>   		return 1;
> 
> -	/* Specialty mapping? */
> -	if (vm_flags & VM_PFNMAP)
> -		return 0;
> -
> -	/* Can the mapping track the dirty pages? */
> -	return vma->vm_file && vma->vm_file->f_mapping &&
> -		mapping_can_writeback(vma->vm_file->f_mapping);
> +	return vma_needs_dirty_tracking(vma);
>   }
> 
>   /*
> --
> 2.40.0


