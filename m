Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF3D6EFEAD
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbjD0Aw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjD0Aw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:52:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10hn2230.outbound.protection.outlook.com [52.100.156.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B34C3586;
        Wed, 26 Apr 2023 17:52:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+BaAp+2Ogpt9Fnp5tw/DVFrmk3peOIA3dqrFrcUiGxaiU/c2zB5FmhczvBcaAXpDmaQr7orPFHNFakxoSPlKcMJGn88B+jSNOyt/O6vSPcX3c/zxRjQXXFnEk31k7Eq+24BiJKMX6+Ee2nFCFyH+BifRrH7QDqgO4OT4mPRTvGEiTR/c3991bB/dg27QoJj7lmN6ZGZnJBEix0ONt79hWwF9ck/gf1we3NsIyhyuQSJi+gc6+4R7vdOibQKtz00B5PEXOSrXNy8O1d45HVyb63Ex+9uXdpztxiP7oVXfkKS6XRZGwP2aZVwt9mMoG1cy1UH4utXL2eBy4fCdibn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5x+4oQat2Vr/yleJ0s6BYivX97KVHihy98lhz54kId8=;
 b=PucXDqT49E+mjeiBOO9zkpfR6weUk/Fh6PR1YrrYI5fHCjDR9ePXFT7yySP9jwXYqAay//k6a8CL/ynbbSbxbSzxlhfQuSFTqSNJv3cbcuKeXAlLTDdp0lMl8OsDfoG3j2FrR8moLxlXS+43NwO/DclJ/Rjs926bSvBSgqvrAEz6kvMp+6snsvO8FxlhAkEQSBu4NfjlENXOX5lcI74UJpALhabxZw192YpOXzSULwhh/f2tmArtWEZWbuB2FDTiXtX8i1yk7AIWzE875fUdq3JZk4BrAs5PYIVS2XK+TZaQ7LsjU7NG/VRBVYs62osu70kWXYzMQlddd1lZu99jzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x+4oQat2Vr/yleJ0s6BYivX97KVHihy98lhz54kId8=;
 b=I2uiDoPX+aw/mNyubavFX1udZDnh8w++PEZrSHoHx/3E++XzxKEFDT/ww66LqLisMRk8OOv6V5vfmPg3ulQzI8y3UrUPSwhzWAb8mk5GCpA1x0L7W+yelyPH0zWFuhK7xCH4tbFOuNPqMw2//cttpxhveMJD26yKBGO0w+yspMPTcYsh9OltwyzgGCqMqUihZwHYEFXJmjEfRTkDxK9j2HmkA9H1O16SuAdv77CFiM4P0Dtg4J3dUIAdBYvmYAIb/+oq0D2oEyT2JVV32tzDowE+tw1JhO5azZHVAUCRvTn33/YdzfzNMzItSmmNI/Kg0ddgxwzBz0iRlBrHQg4CUw==
Received: from DS7PR07CA0003.namprd07.prod.outlook.com (2603:10b6:5:3af::11)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 00:52:21 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::c9) by DS7PR07CA0003.outlook.office365.com
 (2603:10b6:5:3af::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Thu, 27 Apr 2023 00:52:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.22 via Frontend Transport; Thu, 27 Apr 2023 00:52:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 17:52:11 -0700
Received: from [10.110.48.28] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 17:52:09 -0700
Message-ID: <7a3ff186-09c4-1059-9cdf-9e793f985251@nvidia.com>
Date:   Wed, 26 Apr 2023 17:52:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
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
        Pavel Begunkov <asml.silence@gmail.com>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|BL1PR12MB5319:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b74ad8-eba5-4de9-0b15-08db46b9a8ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS7Oo1edcy0UiinXZql8rpv7LZMPi+XSExH28uDbIkiZHriBJQrxF8FRuhLPqTmcDV3yYQdzYhjS07NtKO5eIu4rVHJIZf+T8f3m4ivrDZcVk/ySwd2XiUV5NlFPAnbYe1DFxisH/4eMwOANAq3M2Q5ktO7mhG6I2SZBLh7n/zIbDUsLna8wCvNdWX3QyjTupDuKlIEGwTPu8vg29kMzMVHVSo5ENwl6QJQFKcPmWykLl7Nd9ABXhKQoTgwUWq1ccs/Zbb5+pkhuskRzyMKukAPxf4wlJLHHoXuNabzvpm4Si2YhsFbynfpHIMjnMqnH+iLc7gwzRrQXT4LYJ/VdZlv8+JcflCyovYLHZFq5u1+03bml8ol8H9rZRMThaGZPYhT3ZQexfa1LQH61j48yzcpSnch10sb+rifK0imM4/y7SRAOE3WzekTNOaN13fYFJauRqAeUNB6jZq9mD04LKi+ripZiQbt9kI4xIlRs4TcQiJ9HPY3GURv8Kn5dZrcrYI+DT+o9sy6E1nuYsP1cpjzcr7psoZ5EBI9yI2PxvYfRVUSsO2p5iiRpk+BwpINhsKmOFGyBV4ons/pY3h15HKTIxPim9RgX327fOUYDeBY1I6jn/87nJTRKkd4XUX2Gs8eRB1WPKd9iCy5SqAgxWB7G/PNgAa3rSJHl+nppiwy+/mfOA7Qq6vk2v7LEjokQoZq9W4Z6VYuvqyWAkBZI+HipyJhqwUzQ04iSc4+ay0RNYIYzs4JZ0jxih31tfhNydBZBs/z47+8+w9176IUttnNywji9uqXo2XoexGgnV3vMeOE3yXfYMKVYz4ddeq0O5GtS1HRqOerOHo0+KaI7UcKEjwI+7OW8JH6tCKb2pzz6vpm4759FYSj4IHXzzNldw2JHAcW9xPzg0mDp/U1FtA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199021)(5400799015)(36840700001)(40470700004)(46966006)(7636003)(356005)(82740400003)(36756003)(40480700001)(86362001)(82310400005)(31696002)(40460700003)(966005)(7416002)(5660300002)(7406005)(26005)(2906002)(16526019)(31686004)(186003)(4326008)(2616005)(70206006)(110136005)(54906003)(16576012)(70586007)(478600001)(316002)(53546011)(41300700001)(8676002)(8936002)(47076005)(36860700001)(426003)(34020700004)(83380400001)(336012)(2101003)(43740500002)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 00:52:21.5153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b74ad8-eba5-4de9-0b15-08db46b9a8ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
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

On 4/25/23 16:15, Lorenzo Stoakes wrote:
> GUP does not correctly implement write-notify semantics, nor does it
> guarantee that the underlying pages are correctly dirtied, which could lead
> to a kernel oops or data corruption when writing to file-backed mappings.
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
> In the meantime, we add a check for the most broken GUP case -
> FOLL_LONGTERM - which really under no circumstances can safely access
> dirty-tracked file mappings.
> 

Hi Lorenzo,

As I mentioned in a sub-thread [1], it would be a nice touch to include
your more detailed write-up, and a link to Jan Kara's original report,
here.


> As part of this change we separate out vma_needs_dirty_tracking() as a
> helper function to determine this, which is distinct from
> vma_wants_writenotify() which is specific to determining which PTE flags to
> set.

This, I think should go in a separate cleanup patch, because it is
(nearly) the same behavior. More notes below on this.

More notes below:

> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
> v4:
> - Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to reduce
>    duplication and update to use this in the GUP check. Note that both separately
>    check vm_ops_needs_writenotify() as the latter needs to test this before the
>    vm_pgprot_modify() test, resulting in vma_wants_writenotify() checking this
>    twice, however it is such a small check this should not be egregious.
> 
> v3:
> - Rebased on latest mm-unstable as of 24th April 2023.
> - Explicitly check whether file system requires folio dirtying. Note that
>    vma_wants_writenotify() could not be used directly as it is very much focused
>    on determining if the PTE r/w should be set (e.g. assuming private mapping
>    does not require it as already set, soft dirty considerations).
> - Tested code against shmem and hugetlb mappings - confirmed that these are not
>    disallowed by the check.
> - Eliminate FOLL_ALLOW_BROKEN_FILE_MAPPING flag and instead perform check only
>    for FOLL_LONGTERM pins.
> - As a result, limit check to internal GUP code.
>   https://lore.kernel.org/all/23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com/
> 
> v2:
> - Add accidentally excluded ptrace_access_vm() use of
>    FOLL_ALLOW_BROKEN_FILE_MAPPING.
> - Tweak commit message.
> https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/
> 
> v1:
> https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/
> 
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 26 +++++++++++++++++++++++++-
>   mm/mmap.c          | 37 ++++++++++++++++++++++++++++---------
>   3 files changed, 54 insertions(+), 10 deletions(-)
> 
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
> index 1f72a717232b..53652453037c 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,37 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
>   
> +/*
> + * Writing to file-backed mappings which require folio dirty tracking using GUP
> + * is a fundamentally broken operation as kernel write access to GUP mappings
> + * may not adhere to the semantics expected by a file system.
> + */
> +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> +					  unsigned long gup_flags)

Perhaps name this:
  
         writeable_file_mapping_allowed()

? "can" is more about "is this possible", whereas the goal here is
to express, "should this be allowed".

Also a silly tiny nit: let's omit the "inline" keyword, down here in this
.c file, and let the compiler work that out instead. "static" should suffice.

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

This name:

        bool file_backed = !vma_is_anonymous(vma);

would lead to a slightly better reading experience below.

Sorry for the small naming and documentation comments here,
it's just what I do. :)


>   
>   	if (vm_flags & (VM_IO | VM_PFNMAP))
>   		return -EFAULT;
>   
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>   		return -EFAULT;
>   
>   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +999,9 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   		return -EFAULT;
>   
>   	if (write) {
> +		if (!vma_anon && !can_write_file_mapping(vma, gup_flags))
> +			return -EFAULT;
> +
>   		if (!(vm_flags & VM_WRITE)) {
>   			if (!(gup_flags & FOLL_FORCE))
>   				return -EFAULT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 536bbb8fa0ae..aac638dd22cf 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,32 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   }
>   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
>   
> +/* Do VMA operations imply write notify is required? */
> +static inline bool vm_ops_needs_writenotify(

This "inline" should also be omitted, imho.

> +	const struct vm_operations_struct *vm_ops)
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
> @@ -1484,14 +1510,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
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

OK, so here we are calling vm_ops_needs_writenotify(), that's the
first call. And then...

>   		return 1;
>   
>   	/* The open routine did something to the protections that pgprot_modify
> @@ -1511,13 +1536,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
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

...and now we call it again. I think once should be enough, though.

Also, with the exception of that double call to
vm_ops_needs_writenotify(), these changes to mmap.c are code cleanup
that has the same behavior as before. As such, it's better to separate
them out from this patch whose goal is very much to change behavior.


[1] https://lore.kernel.org/all/1b9e3406-c08e-b97c-d46f-22f36535d9e5@nvidia.com/

thanks,
-- 
John Hubbard
NVIDIA

