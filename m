Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71C2F52AD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbhAMSsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:48:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728108AbhAMSsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:48:54 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DIicOo032117;
        Wed, 13 Jan 2021 10:48:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gulwjmtfgPvzvG+CYkimturzVYttqGxf4st4wHxiViM=;
 b=lVwQD0RL31fEbDkOy97ruT8/aGOFrRldSJwHVWMEj+fx8e+QK5wnD7rQQ3HNtEDRqlr9
 R3Hel8e+VOSKvb0dQ46vbEpX1S4j3apQ4Y8a3M2qQ2rFVwSeSNAtGet4Fekn7hCvFNnZ
 fEf31OZpIbZvzi84haR8hankF0biK1LR8eg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpueqes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 10:48:04 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 10:48:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tcfqoc2qqPAOW6UTNWSOkJJ52scsX30hpkfL5tly72mA6zKwj6YE1CDZLDnLxz46ePm1FpvlhKKm1BaMfIlc6Cii9is+sPm3FFKAfvXuY5ZObL6Kc2UTpSpbVt8H5giux2KXB3M5Da+zXOKtF3lmtgAhYl9ecTRpXju/eEgNy1P7VMt3Cadw5TqdZSOd6p1dNk8xnupVs+aOtnvyJYlYRnjoGWNiyeujEe9Ci9CWp4Hcrvw8ExI8wp+abNJCUcGih8Ae/tMmyFY8srD51LAdfycFl+cPk5h8snVzyaiQwuTrr4UP7RTfkshvu2z87+HuaaLxZC2UuMJA7JCDHJ/0Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gulwjmtfgPvzvG+CYkimturzVYttqGxf4st4wHxiViM=;
 b=LbEg8IMveSUJkZK9wpnINqt6cDLOz5yaLb4XSrPGuPW6B6VcCEdOLiNTtRuQMo2dd3A+JwStrm9yeKfAOguYCB9ZD90vUFU6bxPG09ZRG5nqi4bkM2ZNRx9y6X4eiI6tYt39ZejuLPQfAC5ciLPMCrOrc3zlnvYWE8bnoKnR04wAIy7Vv4SgxfI1QVIncVJCtHCy3QclnzkNkpA7OFKnYG+hSQe+YDHakeQQm7KRdISMPBbtH9g4G24IZymcvV1icUW7Sl3zU9mhi+ypkQHdk2W+xdcgadChcvL5ZcXmcBlfEQ2l9AfvWkPLw60/BIggLKRpS5uPuOTZQrxlRimNZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gulwjmtfgPvzvG+CYkimturzVYttqGxf4st4wHxiViM=;
 b=kneNKI5UHYK6MC+P1n7MTeqJI3R1schBSOgWtO6Xf6XtsjBp3OIpNz9Va6hKzOHB0mP0+pdqii8YAQXskzhFm9XCusYkRdDxy2FK/NuwQEy79vhsk0LPdepUI4IJ6IUl7Dl9ds+pmngv4voRcYS9dYoXQLhBeI/B/iC8M2yR21E=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR1501MB4144.namprd15.prod.outlook.com
 (2603:10b6:805:e8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 18:47:58 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::65cb:e5a9:2b4c:ceba]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::65cb:e5a9:2b4c:ceba%6]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 18:47:58 +0000
Date:   Wed, 13 Jan 2021 10:47:53 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Arjun Roy <arjunroy@google.com>
CC:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
 <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
 <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:31a8]
X-ClientProxiedBy: MWHPR01CA0028.prod.exchangelabs.com (2603:10b6:300:101::14)
 To SN6PR1501MB4141.namprd15.prod.outlook.com (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:31a8) by MWHPR01CA0028.prod.exchangelabs.com (2603:10b6:300:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 18:47:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6942526-faf6-4211-2941-08d8b7f3bf3d
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4144:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB414416206099C27E84B66A51BEA90@SN6PR1501MB4144.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNQkfAk6LM9S+PnLVBkNvTz0pp1QW1nRGKNSUZ6aZQLGyOUhdJC7v7uidjO9C8dFtaFHXHrnF5AzUKjEPWbwtNfTiK0hesvmYwYw7as7r0UCgEs7vabVAorp6VpJMtINL3UZjlUVYIq6OOFZlFrJuORWQ9XE146pETT4Adu+WlW6TXgQkwaLcdwZIfgnFYvEXs5i2xzJ5Y1okZPqDFEKrGAurtkd71Zw7qO3m49Svvf/zl+Qv/lcQqJoL6o2kxhtfGRJDL0NLfqllxsaL97SXWUoK+4BqgwttJlRZSveJYrmSn7QOqEBchJrwIjzYgaY5LB0BEuc1UMWnH9MDgZauu8+0ui8uEn7HMtEbtDIdUGNckLjPnwJyKtCtU2KzVEFXjvanMeLft0haaGMykuY1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(478600001)(6666004)(54906003)(66556008)(16526019)(6506007)(33656002)(66476007)(9686003)(7696005)(1076003)(5660300002)(186003)(86362001)(4326008)(8676002)(7416002)(83380400001)(316002)(8936002)(53546011)(55016002)(15650500001)(52116002)(2906002)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?16EuJNtGyL0Tv5OdFu6AAAyYS0eOPWjtTDANsk/b7Ro6K7V4+lmL5N7C9/fC?=
 =?us-ascii?Q?uFrEd+vN9pr8cYTiK00FD2V6LPU24dXz1ITuLr40E6sNTc9//5nQd8q072jd?=
 =?us-ascii?Q?P8as0Kq3UGK+S+ea1bUOW4L+T9sQcuZV/A+rhSC1QcPfZe9wjgif2FyfmGwe?=
 =?us-ascii?Q?/hEO6rTdVZCLcINbD3LcmJPf4MQf3B4CvKJ+AJ8iYw16nbngEx7SPPrLwTX4?=
 =?us-ascii?Q?ukOmcLZkxAJqftvCKH3sKBDFS8/jGXQu8nWDwBf1XB5IlTfstJ/mrk7aa1A3?=
 =?us-ascii?Q?kgKs7y46uzpKZ+7A/XLUj96vewS5nrqZwFuM5ru5G8t3RCNXzTmVzhP7hIb2?=
 =?us-ascii?Q?kOWYaBgwv+yCTkCMCQ0Ey7Iz8Lp6ZRwkGkN0DOg4EiSVMFw6MV/FFTzpzJTz?=
 =?us-ascii?Q?XAPb2mFMEucp4n+t8NtsFYSNdXhjiwCLLFwziMMBrdMr42+M1y+ObCieKedB?=
 =?us-ascii?Q?aHLjU/7mUrHzKszyKXYQz11k5ygaYntHlUNA37Mio4EMzPKdbEUzFvrATcYy?=
 =?us-ascii?Q?xKwM4zSTj0X9luTkNPv7OMGpcP/3ZcHCrziIMGimrS3jDRVoVFvJPrawFLPA?=
 =?us-ascii?Q?6E2fVcscKQhO34l5pKEF3NdES6XuBBJqvb05n4qUyWY7iR2XdnBA03bw3b1P?=
 =?us-ascii?Q?mp9JGmRyty4mXsrdHaQGSTT5VfVOirTsTltbTcGF03/MSd1/xFGSQ/QUUt+e?=
 =?us-ascii?Q?USxjw6XZyfRpQY6gRwJclNGXoL/3ftwbAVIYXj4fWr4cX6Cs1oFV+W32FGDn?=
 =?us-ascii?Q?CfTh98n6+nF0uo8gJ/2/wzF6ngfnfOvcjqIAXKPuBcTHKlDDwmkwSkVAgOLx?=
 =?us-ascii?Q?ya81oE/YcSiAMheimUjRnyzsQ5wl5ONaE5jACC12dpeufjn9BhliC8pXV0bZ?=
 =?us-ascii?Q?4TZbfW3CfzBENld+torD1fC1RVQZO/QvwzORfi5Jaz3ugpQuxistY29ZZRFO?=
 =?us-ascii?Q?QsG3bbqMtOyqf6RbOFDNvm333L9VcKbBAZIQgC+Y6U/NXHpFzfAkwZFOySgA?=
 =?us-ascii?Q?SDF2Z6Q6yCMY1xelxgjVnuJaRg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 18:47:58.4918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: d6942526-faf6-4211-2941-08d8b7f3bf3d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fvw1D4q6GZp2IkmJ8Oj9ctMhXOpHJVhvRyPdqr+5O2B6ZZIMPes0Nx202wwFEnpt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4144
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 04:12:08PM -0800, Arjun Roy wrote:
> On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 03:36:18PM -0800, Arjun Roy wrote:
> > > On Tue, Jan 12, 2021 at 3:31 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> > > > > From: Arjun Roy <arjunroy@google.com>
> > > > >
> > > > > TCP zerocopy receive is used by high performance network applications to
> > > > > further scale. For RX zerocopy, the memory containing the network data
> > > > > filled by network driver is directly mapped into the address space of
> > > > > high performance applications. To keep the TLB cost low, these
> > > > > applications unmaps the network memory in big batches. So, this memory
> > > > > can remain mapped for long time. This can cause memory isolation issue
> > > > > as this memory becomes unaccounted after getting mapped into the
> > > > > application address space. This patch adds the memcg accounting for such
> > > > > memory.
> > > > >
> > > > > Accounting the network memory comes with its own unique challenge. The
> > > > > high performance NIC drivers use page pooling to reuse the pages to
> > > > > eliminate/reduce the expensive setup steps like IOMMU. These drivers
> > > > > keep an extra reference on the pages and thus we can not depends on the
> > > > > page reference for the uncharging. The page in the pool may keep a memcg
> > > > > pinned for arbitrary long time or may get used by other memcg.
> > > > >
> > > > > This patch decouples the uncharging of the page from the refcnt and
> > > > > associate it with the map count i.e. the page gets uncharged when the
> > > > > last address space unmaps it. Now the question what if the driver drops
> > > > > its reference while the page is still mapped. That is fine as the
> > > > > address space also holds a reference to the page i.e. the reference
> > > > > count can not drop to zero before the map count.
> > > > >
> > > > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > > > Co-developed-by: Shakeel Butt <shakeelb@google.com>
> > > > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > > > ---
> > > > >  include/linux/memcontrol.h | 34 +++++++++++++++++++--
> > > > >  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
> > > > >  mm/rmap.c                  |  3 ++
> > > > >  net/ipv4/tcp.c             | 27 +++++++++++++----
> > > > >  4 files changed, 116 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > index 7a38a1517a05..0b0e3b4615cf 100644
> > > > > --- a/include/linux/memcontrol.h
> > > > > +++ b/include/linux/memcontrol.h
> > > > > @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
> > > > >
> > > > >  enum page_memcg_data_flags {
> > > > >       /* page->memcg_data is a pointer to an objcgs vector */
> > > > > -     MEMCG_DATA_OBJCGS = (1UL << 0),
> > > > > +     MEMCG_DATA_OBJCGS       = (1UL << 0),
> > > > >       /* page has been accounted as a non-slab kernel page */
> > > > > -     MEMCG_DATA_KMEM = (1UL << 1),
> > > > > +     MEMCG_DATA_KMEM         = (1UL << 1),
> > > > > +     /* page has been accounted as network memory */
> > > > > +     MEMCG_DATA_SOCK         = (1UL << 2),
> > > > >       /* the next bit after the last actual flag */
> > > > > -     __NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> > > > > +     __NR_MEMCG_DATA_FLAGS   = (1UL << 3),
> > > > >  };
> > > > >
> > > > >  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> > > > > @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > >       return page->memcg_data & MEMCG_DATA_KMEM;
> > > > >  }
> > > > >
> > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > +{
> > > > > +     return page->memcg_data & MEMCG_DATA_SOCK;
> > > > > +}
> > > > > +
> > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > >  /*
> > > > >   * page_objcgs - get the object cgroups vector associated with a page
> > > > > @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > >       return false;
> > > > >  }
> > > > >
> > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > +{
> > > > > +     return false;
> > > > > +}
> > > > > +
> > > > >  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > > > >  {
> > > > >       return true;
> > > > > @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
> > > > >  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
> > > > >  void mem_cgroup_sk_alloc(struct sock *sk);
> > > > >  void mem_cgroup_sk_free(struct sock *sk);
> > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > +                              unsigned int nr_pages);
> > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> > > > > +
> > > > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > > > >  {
> > > > >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > > > @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> > > > >                                         int nid, int shrinker_id)
> > > > >  {
> > > > >  }
> > > > > +
> > > > > +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> > > > > +                                            struct page **pages,
> > > > > +                                            unsigned int nr_pages)
> > > > > +{
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > > +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> > > > > +                                               unsigned int nr_pages)
> > > > > +{
> > > > > +}
> > > > >  #endif
> > > > >
> > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index db9836f4b64b..38e94538e081 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > > >       refill_stock(memcg, nr_pages);
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * mem_cgroup_charge_sock_pages - charge socket memory
> > > > > + * @memcg: memcg to charge
> > > > > + * @pages: array of pages to charge
> > > > > + * @nr_pages: number of pages
> > > > > + *
> > > > > + * Charges all @pages to current's memcg. The caller should have a reference on
> > > > > + * the given memcg.
> > > > > + *
> > > > > + * Returns 0 on success.
> > > > > + */
> > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > +                              unsigned int nr_pages)
> > > > > +{
> > > > > +     int ret = 0;
> > > > > +
> > > > > +     if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> > > > > +             goto out;
> > > > > +
> > > > > +     ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> > > > > +
> > > > > +     if (!ret) {
> > > > > +             int i;
> > > > > +
> > > > > +             for (i = 0; i < nr_pages; i++)
> > > > > +                     pages[i]->memcg_data = (unsigned long)memcg |
> > > > > +                             MEMCG_DATA_SOCK;
> > > > > +             css_get_many(&memcg->css, nr_pages);
> > > > > +     }
> > > > > +out:
> > > > > +     return ret;
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> > > > > + * @pages: array of pages to uncharge
> > > > > + * @nr_pages: number of pages
> > > > > + *
> > > > > + * This assumes all pages are charged to the same memcg.
> > > > > + */
> > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> > > > > +{
> > > > > +     int i;
> > > > > +     struct mem_cgroup *memcg;
> > > > > +
> > > > > +     if (mem_cgroup_disabled())
> > > > > +             return;
> > > > > +
> > > > > +     memcg = page_memcg(pages[0]);
> > > > > +
> > > > > +     if (unlikely(!memcg))
> > > > > +             return;
> > > > > +
> > > > > +     refill_stock(memcg, nr_pages);
> > > > > +
> > > > > +     for (i = 0; i < nr_pages; i++)
> > > > > +             pages[i]->memcg_data = 0;
> > > > > +     css_put_many(&memcg->css, nr_pages);
> > > > > +}
> > > >
> > > > What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
> > > > a separate counter? Do we plan to eventually have shrinkers for this type of memory?
> > > >
> > >
> > > While the pages in question are part of an sk_buff, they may be
> > > accounted towards sockmem. However, that charge is unaccounted when
> > > the skb is freed after the receive operation. When they are in use by
> > > the user application I do not think sockmem is the right place to have
> > > a break-out counter.
> >
> > Does it mean that a page can be accounted twice (even temporarily)?
> >
> 
> This was an actual consideration for this patchset that we went back
> and forth on a little bit.
> Short answer, for this patch in its current form: yes. We're calling
> mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
> and the skb isn't cleaned up until afterwards. Thus we have a period
> of double charging.
> 
> The pseudocode for the approach in this patch is:
> 
> while skb = next skb in queue is not null:
>     charge_skb_pages(skb.pages) // sets page.memcg for each page
>     // at this point pages are double counted
>     vm_insert_pages(skb.pages)
>     free(skb) // unrefs the pages, no longer double counted
> 
> An alternative version of this patch went the other way: have a short
> period of undercharging.
> 
> while skb = next skb in queue is not null:
>     for page in skb.pages set page.memcg
>     vm_insert_pages(skb.pages)
>     free(skb) // unrefs the pages. pages are now undercounted
> charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
> ret

I have to think more, but at the first look the second approach is better.
IMO forcing the charge is less of a problem than double accounting
(we're forcing sock memory charging anyway). I'm afraid that even if the
double counting is temporarily for each individual page, with a constant
traffic it will create a permanent difference.

Btw, what is a typical size of the TCP zerocopy data per-memcg? MBs? GBs?

Thanks!
