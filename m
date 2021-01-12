Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEE72F404E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbhALXcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:32:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbhALXcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:32:15 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CNUAkf013515;
        Tue, 12 Jan 2021 15:31:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3ThC1iwKbE8vfIHFJmq7CvSHRNpgy7HQWMldOkVpIkg=;
 b=pt0uWmDQyZyRqMaK1jhUWGuaQiVRv6/b9nO+WbWkAmJegu9MZ0zDVXZOBoFcSpOsyAP+
 h+g4CWtLbCk0GIqOE0gorZ++PI0PX1veXT5YBrpgGrd+2ySE8N0IfeNAMGTIIgULvUE1
 sWRtIxd0ghJwyzO8BfOII9dbREVdhVVFS2M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpft5js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 15:31:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 15:31:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQbNxZlnWnQxUHD8fV8rBzXwq6VcYsFiDdHRGY7k1AM6n2kGnAKbnvol+S5TSVlDDNZAc4J+yq+WwdvSjXAXdFypDr2EH+ANlPzrs/IlFC+kozn2JyNmjVyOS5sHco5uk3PE2vvPEcT2TVdN7CBGCnQ0fLuBPqM1Ca+jLHyg08XWRydu1wQWWq/Li/snqtRflIUQhErE5AwCcXkyoJFLpWGTGt/fDeKQ6NxkiLQYr/BPFpNtJEuB0LX36rRlUpUdvSAPzJDuOlQdv1zEmfYff8uBzX8f3h6Tgu5d3UKMSxEMdwQzBOanqjQ71MXuFN7puNYDm77OScbqAwSoKSITXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ThC1iwKbE8vfIHFJmq7CvSHRNpgy7HQWMldOkVpIkg=;
 b=SZuhXLEWdYXx5BHu6REQKz5tBXm/+8pzfh9WwKfNDFmi+H1n15vhHtMJgA9ftkh9qDI9k5O1hArJhAsW35YEh+4ekPb4iBJ+e4JtYNMirOYlWraiQJKDjLCbwFx2C+VvBe1tMI0e7Rdpfa4aVrUbsaNlGlYFinTUkrsocPzQFrhPpkWCOGfpe1py/mfleR3lcRtHdSCLERF8TKLfT3G+x+Ux9iBufgyrP6Cz3rZQjdbCMnEDoKg+Sdpkyg4kpbAlH5AezxeLqdCGL+TkAyjPkAuWsNWSODW19Mw8ldKt3nNF7DlAQOWY/5hM4bu/doUcQYK0bPr4FQJ4I9LgFT3j8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ThC1iwKbE8vfIHFJmq7CvSHRNpgy7HQWMldOkVpIkg=;
 b=RjSqToxwr+eO7dWW7Jtb8rHR+/ntzhFldPeaSs05LBd49ZoBE22mu/oJKBF0XDLBXY6xM4fNB1j2RsERGxslihxVXZ5NQMo29R8Qy75kRRef/4M5VBD9t9yak3qcUP+6lm8sGNiWRREDfuCsAhyZZ9f4lS3Y4QyTBIyvH8E50YI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2984.namprd15.prod.outlook.com (2603:10b6:a03:b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 23:31:13 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::780c:8570:cb1d:dd8c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::780c:8570:cb1d:dd8c%6]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 23:31:13 +0000
Date:   Tue, 12 Jan 2021 15:31:08 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arjun Roy <arjunroy@google.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112214105.1440932-1-shakeelb@google.com>
X-Originating-IP: [2620:10d:c090:400::5:2826]
X-ClientProxiedBy: MWHPR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:301:1::18) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:2826) by MWHPR11CA0008.namprd11.prod.outlook.com (2603:10b6:301:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 23:31:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbc9028e-cc85-455c-deaa-08d8b75226af
X-MS-TrafficTypeDiagnostic: BYAPR15MB2984:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2984470929429451067A12F6BEAA0@BYAPR15MB2984.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpdyeaRY/giokdhi4YrGYO5jPo1fXxh6VvAqVhcURBotkweAzA7nGfahfn7aqjYUs6WXuPLdkZbi5z+KloV1oQEH/6NIPom+etAJjkjES9gDKSOKgtwVY3rooGWGHH/uZCtdA/LD5yTtU4jwa8OX9a+QjQZVjmAuOylxDFvlcgXliMkQDhgcAFDgH/hogLSFN6Dgk5LrUSpv9ln+SzxI7tCfE1yraUlQlZvtKTPMpL9BpdUy0Emuf7YFOlJWuFlCmHl03kq+Ol3v4rDqBMJA+Y9VhT1I4u4b6891+zGezcGve19u3YfGTLMDNDifhH/vZBlmPwJJ44wPZkeB6ANw9cc9NzK6JlCdM+JV0biM4r18JsbZkApIstosiuUmWF4gZXiTnSZfm+hDLUugydoXZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(83380400001)(4326008)(33656002)(8936002)(9686003)(7416002)(2906002)(15650500001)(8676002)(478600001)(1076003)(316002)(66556008)(66476007)(6916009)(52116002)(6666004)(7696005)(54906003)(16526019)(5660300002)(55016002)(66946007)(186003)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9+dRBEo3XmXW6pZkB8TFR3vGjAsU10juCnnixURf1R9taWUaELmrwqZQG86M?=
 =?us-ascii?Q?UubtorxpMaHGCMl/s0yFuh/6/rnTfjiwyXhNOL/iVSAsGR5iDRG69T/mHGrE?=
 =?us-ascii?Q?EAdJCKXNVZvTuikBJr7rGCXGrZGvaWzTPb2ahORLTLxeL6Wai1C8sXe2sXPd?=
 =?us-ascii?Q?B87tH3ds9LqcDR+VlCJfEj1qIO/es7M6bzHxT0X/lNbH0RH/cyUnSG54/5Vu?=
 =?us-ascii?Q?C9QN5LUBHyskJJWVsvEIQ/sYvH7LuuLOQaubYR9Tp4hhfKBFgUjHsbjrUkmU?=
 =?us-ascii?Q?36FGRQlzoC3w8S9ib1ggmef0DrPwH+xcoE6VML4wPKNBNa9Mo+m7r+Hfh6K6?=
 =?us-ascii?Q?iKQ9w5T53gKq5qCCWpp6jaLG1+MFe5IOQUoTpUaonNBbDr+Du1mkRmeIrjKh?=
 =?us-ascii?Q?er4QWloxE02CYcD1RB/lHc/Yst4x/Sye8vQVQU6RzdWhH9f1BZPVjwdfYxUL?=
 =?us-ascii?Q?W29CpeOrQzZUKdSltfDBHj0gIiwtAfgqMj2oiKsUJ/q99G3E1s7gz7wmFMGG?=
 =?us-ascii?Q?g9rMzBj+8APhpQS8xULdu+o7u7U9x5jmUMuDv/L99TAw+JZiJjnMMKfR0r/n?=
 =?us-ascii?Q?VSxEZ31k3qz9r2VdJqlEFFQkaxqapz5FaM0avnpbieY/pfzFANdYXmPY/yjn?=
 =?us-ascii?Q?yHeTmqvmFgQQRrkbfk2HpX2W43VDIx1oMnPWr96FldWi2KTLaRm1MKhwMDDv?=
 =?us-ascii?Q?cDz6mBdk4Uz2PltWIKvSW1XX3HuFwvalaNbR+dsNTJ5Sb3mNleygWZXRNAL6?=
 =?us-ascii?Q?eKb9fznp047NADAq+F1i2Zs1gUFSjSEdTzEkj/czLeRIua39RgmmBt9oe7h0?=
 =?us-ascii?Q?eFlDx62g2wPgc1BnuGHMuHCKd/BzigHK9XjyfidzC3kJtboNMtwi0b2P7wAz?=
 =?us-ascii?Q?HMks2c9s0lDH+erOIstNOK1OwkEPNXiP/nzvLnDoJbesC3z8xPKIVYggQSf8?=
 =?us-ascii?Q?e1lkt5ubPpyiSa8YuVJszVdLAciUqf1ufRWBTsobboSVfybmRORz3UY8V/Fq?=
 =?us-ascii?Q?41iXPcPBaIHTXPG4OGFcCbRY3A=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 23:31:13.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc9028e-cc85-455c-deaa-08d8b75226af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7EiyFRhxA081GxsYvR1QLrJCEto2y/zLxl/SMlwvsVfEjMTATWuORHcuqD4jBA3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2984
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_21:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> TCP zerocopy receive is used by high performance network applications to
> further scale. For RX zerocopy, the memory containing the network data
> filled by network driver is directly mapped into the address space of
> high performance applications. To keep the TLB cost low, these
> applications unmaps the network memory in big batches. So, this memory
> can remain mapped for long time. This can cause memory isolation issue
> as this memory becomes unaccounted after getting mapped into the
> application address space. This patch adds the memcg accounting for such
> memory.
> 
> Accounting the network memory comes with its own unique challenge. The
> high performance NIC drivers use page pooling to reuse the pages to
> eliminate/reduce the expensive setup steps like IOMMU. These drivers
> keep an extra reference on the pages and thus we can not depends on the
> page reference for the uncharging. The page in the pool may keep a memcg
> pinned for arbitrary long time or may get used by other memcg.
> 
> This patch decouples the uncharging of the page from the refcnt and
> associate it with the map count i.e. the page gets uncharged when the
> last address space unmaps it. Now the question what if the driver drops
> its reference while the page is still mapped. That is fine as the
> address space also holds a reference to the page i.e. the reference
> count can not drop to zero before the map count.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Co-developed-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  include/linux/memcontrol.h | 34 +++++++++++++++++++--
>  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
>  mm/rmap.c                  |  3 ++
>  net/ipv4/tcp.c             | 27 +++++++++++++----
>  4 files changed, 116 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7a38a1517a05..0b0e3b4615cf 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
>  
>  enum page_memcg_data_flags {
>  	/* page->memcg_data is a pointer to an objcgs vector */
> -	MEMCG_DATA_OBJCGS = (1UL << 0),
> +	MEMCG_DATA_OBJCGS	= (1UL << 0),
>  	/* page has been accounted as a non-slab kernel page */
> -	MEMCG_DATA_KMEM = (1UL << 1),
> +	MEMCG_DATA_KMEM		= (1UL << 1),
> +	/* page has been accounted as network memory */
> +	MEMCG_DATA_SOCK		= (1UL << 2),
>  	/* the next bit after the last actual flag */
> -	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> +	__NR_MEMCG_DATA_FLAGS	= (1UL << 3),
>  };
>  
>  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
>  	return page->memcg_data & MEMCG_DATA_KMEM;
>  }
>  
> +static inline bool PageMemcgSock(struct page *page)
> +{
> +	return page->memcg_data & MEMCG_DATA_SOCK;
> +}
> +
>  #ifdef CONFIG_MEMCG_KMEM
>  /*
>   * page_objcgs - get the object cgroups vector associated with a page
> @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
>  	return false;
>  }
>  
> +static inline bool PageMemcgSock(struct page *page)
> +{
> +	return false;
> +}
> +
>  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  {
>  	return true;
> @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
>  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
>  void mem_cgroup_sk_alloc(struct sock *sk);
>  void mem_cgroup_sk_free(struct sock *sk);
> +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> +				 unsigned int nr_pages);
> +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> +
>  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  {
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
>  					  int nid, int shrinker_id)
>  {
>  }
> +
> +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> +					       struct page **pages,
> +					       unsigned int nr_pages)
> +{
> +	return 0;
> +}
> +
> +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> +						  unsigned int nr_pages)
> +{
> +}
>  #endif
>  
>  #ifdef CONFIG_MEMCG_KMEM
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index db9836f4b64b..38e94538e081 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
>  	refill_stock(memcg, nr_pages);
>  }
>  
> +/**
> + * mem_cgroup_charge_sock_pages - charge socket memory
> + * @memcg: memcg to charge
> + * @pages: array of pages to charge
> + * @nr_pages: number of pages
> + *
> + * Charges all @pages to current's memcg. The caller should have a reference on
> + * the given memcg.
> + *
> + * Returns 0 on success.
> + */
> +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> +				 unsigned int nr_pages)
> +{
> +	int ret = 0;
> +
> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> +		goto out;
> +
> +	ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> +
> +	if (!ret) {
> +		int i;
> +
> +		for (i = 0; i < nr_pages; i++)
> +			pages[i]->memcg_data = (unsigned long)memcg |
> +				MEMCG_DATA_SOCK;
> +		css_get_many(&memcg->css, nr_pages);
> +	}
> +out:
> +	return ret;
> +}
> +
> +/**
> + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> + * @pages: array of pages to uncharge
> + * @nr_pages: number of pages
> + *
> + * This assumes all pages are charged to the same memcg.
> + */
> +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> +{
> +	int i;
> +	struct mem_cgroup *memcg;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	memcg = page_memcg(pages[0]);
> +
> +	if (unlikely(!memcg))
> +		return;
> +
> +	refill_stock(memcg, nr_pages);
> +
> +	for (i = 0; i < nr_pages; i++)
> +		pages[i]->memcg_data = 0;
> +	css_put_many(&memcg->css, nr_pages);
> +}

What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
a separate counter? Do we plan to eventually have shrinkers for this type of memory?

Two functions above do not contain anything network-related,
except the MEMCG_DATA_SOCK flag. Can it be merged with the kmem charging path?

Code-wise the patch looks good to me.

Thanks!
