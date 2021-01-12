Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5022F4087
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393487AbhAMAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391838AbhALXtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:49:17 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CNgtpk019891;
        Tue, 12 Jan 2021 15:48:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ogWyaYtFKuR0WRrAsB0kMicWt+hZhB+tqSswxvksTGg=;
 b=EJnRAapb1jHK/E3SE42OtvSSlGtOQLQOcqPQEn7FtyKuv3V+V+1P86SvW6yRV5B2lTFN
 HVcTY8cVPIVXobT4YMz7cufEChezxMlxTSXszKSddHCw1VzRDp66luusjblrM3GDsFjx
 +D3BScYgXoZmSfKIAJSm7eewmjLazC+VUDw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fp2t916-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 15:48:29 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 15:48:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naxQ5vJ9obtX8iss9wifMdruFUY91jfYUgRFWwXaXhXawrIEIGTlrl5oFhlcgePx1rC4oBSa6tBb+pAL8FRtc2Cm9PzNUWzSblPo1G1Al4SKplf2D16kzPSytMi7dn3EWe131/gLqPFj9guqVz5LJJoXCzJ6pzR3ZTPJGC3ENXzmAnID2upifeXL3A4f6UP+mOK6nWi7i8SIQyiuwMZASCvttsMfUjd4tTgMDD9iE58x8L1EYxbf35oPlUVLsskWCO/cRjVtNxwcn7C1yObBXFrLL5VlkJy0HvIcIR1OT7+wJiUTemr4VkItneEdKEqLma3hEueDL1kr0MUpza0krg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogWyaYtFKuR0WRrAsB0kMicWt+hZhB+tqSswxvksTGg=;
 b=OClkickOutwItQO1eVX1r4bZXFBIdhWbPxd56Mox+zNACWwwhetuIGpcagfJqxKzuZM7sF89DmFc8cmv2eu2g+6MAJnA6scooWg1dVEVPnf/eaWMG++LdfiszCwzh4Uyv4iGoYhSjEfojuX6wEe2BPjOKP07J5gyAEnhBtbc5AblDOcjkDpm/hquZeQrvwVd3le1tmY2RnE9rOrMco2okFROlFLxt0subFpWbT8kdUHiyffDbiS+EaX6aW8nbMFraWSbZdvxq6sM7S2g7AAL3XIuLG7RvS9Xju3APQAx6Fv5C1SLGRhE/L853BvQQlCg2Cckde7gOyFyC00dn1eBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogWyaYtFKuR0WRrAsB0kMicWt+hZhB+tqSswxvksTGg=;
 b=QmJItymG7kNBYKrrosPb3r4n9xKyU5VNxJ8/WjPFlp+KMkLO/kon9L0X2KBHy9o1cZkYTIrP/ssq48XdhPbscr01DG7UIApAUjL/UpnWpmUiJZAR0hmQnPCnEqKiU2fd0oV59QDxR6nXJVpmqyJDm6iq7UAzuruuV8QclNWn520=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2757.namprd15.prod.outlook.com (2603:10b6:a03:156::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 23:48:26 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::780c:8570:cb1d:dd8c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::780c:8570:cb1d:dd8c%6]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 23:48:26 +0000
Date:   Tue, 12 Jan 2021 15:48:22 -0800
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
Message-ID: <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
 <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2826]
X-ClientProxiedBy: CO1PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:101:1f::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:2826) by CO1PR15CA0052.namprd15.prod.outlook.com (2603:10b6:101:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 23:48:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b5f1282-e78d-48e5-af31-08d8b7548e7d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2757:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2757FB83E414A03D489DDDF6BEAA0@BYAPR15MB2757.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xABcpl9ZcR15Az2h7NHiEBYmKgGZg3bvd4EJARUn2jUFNV/75QVwf1BzwmV9IlGoltkA1GeonOp+toLg0tsWHkjr4e0XXclXcPuDcCZQ0BopXxikcJMl8Gd/vDCU+wZT06cv3koVrT0rOCS9soTXnHyY4LZfu4KbTFkCnhzHpQA56cFMEj0xZQ/4TTM0BVTBcoXiqmOQexYeUBWrdKQD4OCkjSr88Ppu2KNQrBbe+3VX4zRcfwaA9w1z0zDt8cRwmsKWeWbM5J5AxHaCfO05HRQ+96/1FSvApa8afNNlRWqKp6GqHJkFi6jsC8MUkGlvSwIf7cd2tx2EYzJZtFI0ZUp6WiHmmq6xxHZ8xiUsbzufNJZTcervyFoLeVgDsHrWM5BtRtVilcABk41xc6AFKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(39860400002)(376002)(33656002)(52116002)(6666004)(9686003)(86362001)(6506007)(16526019)(66946007)(6916009)(83380400001)(5660300002)(66556008)(186003)(1076003)(15650500001)(7416002)(478600001)(55016002)(54906003)(7696005)(8936002)(8676002)(4326008)(66476007)(2906002)(53546011)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?baIu0OaYGX5gccGxVm5si3fGjjGhP3w93QvGqjyZ/iCLHnE0HUeKMIN/egGu?=
 =?us-ascii?Q?lr1TBDl03PpVm0nUglODKgLJNhpG7Q5Fyn2NMx/F44nmDa0Siru3nTAztiLP?=
 =?us-ascii?Q?aGA8AuFQSEFXCHrDx6nFuaKYDeZuGB7EYvwERb1z06J+O+ZcbLB+0SpuLpms?=
 =?us-ascii?Q?DfmnPHAgNFSWT44p9WZrUU1kXYMFtV5j7hbXI+ofBDfriSB3lrnIpa69pZkU?=
 =?us-ascii?Q?MEehVwyJNZH6boi/PlaILzZ5jjkJl5nCdN0N4IsgKvYcKJWwxFxOwaNXwlTu?=
 =?us-ascii?Q?O2fYM/Is8Ezh3tTSbTIo0oXNE5S9iyRB1XULkQbrXX+A+gnAYh7oavZgJo07?=
 =?us-ascii?Q?XnpzDd1F+/Q+Z4Rke+8JDkN1wU1qYSnbwTaBAbn7YY4Il0H0x+Dl/V0ukxu4?=
 =?us-ascii?Q?ZcY8bCPpg0E3V/25h+3v4z+I0LsnT/CQEOi+63oVM99yH02UU/CmUYIBpry+?=
 =?us-ascii?Q?MPck3RP38xHSKtA7qqBPgSM8N+Cy7GMl0CAbLncoIgx5lzfcumz/ngNyCMay?=
 =?us-ascii?Q?JjzpSBPylP8USr5jcPgP9OTbW9iDHVrXFAppB3+WI58ygjwR8jAYMizwpG0A?=
 =?us-ascii?Q?BA0WAaIK5hmJ2xRc5D5WK4b/NakMIiMVYJP3B8MSnXaiwUycK40sVODr/hhQ?=
 =?us-ascii?Q?XyQXc6+6B1DVZPPQjRANnLWCaidYASDRhJeQmXowYbSvWF0vxYoO1Bf/lHo5?=
 =?us-ascii?Q?QZ42RH04p4bs2b2LiJ16eI1NefsJrYZ135rf/Ndaalvci9Cpcu7lVr5po6Dv?=
 =?us-ascii?Q?UgOdKGzAjeHeZSQa1p2fHxY4HaCcW4qgQt0WCIKTksLOuaxdWDLt8/ZIJEiG?=
 =?us-ascii?Q?XcIAy/SIPwewJmmwt/HjB6O3cJx0/8i3u47JY9UAi5pCaHM9l/8tyr8eB3Rq?=
 =?us-ascii?Q?Ifu1NqdxDvrOlB2RdsBEVXa4P3TGOWt53t21UzZy8qwHNt22f96lzBRa9UVq?=
 =?us-ascii?Q?dtCUYt3AzWsxM76x/3qI8BYGJ+OcqB4Ty6zbVoRsil8RyfOTVyIpPOF9mfU2?=
 =?us-ascii?Q?i8yD6bbIm2hXw7v2mx1WjWpIoA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 23:48:26.8092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5f1282-e78d-48e5-af31-08d8b7548e7d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpdYNEHA18i/EE8mpi/D/7WDU9/+ZWkInfg8NOPV1CvlKfj3vv9KoU6W6KJq7tE3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2757
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_21:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 03:36:18PM -0800, Arjun Roy wrote:
> On Tue, Jan 12, 2021 at 3:31 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> > > From: Arjun Roy <arjunroy@google.com>
> > >
> > > TCP zerocopy receive is used by high performance network applications to
> > > further scale. For RX zerocopy, the memory containing the network data
> > > filled by network driver is directly mapped into the address space of
> > > high performance applications. To keep the TLB cost low, these
> > > applications unmaps the network memory in big batches. So, this memory
> > > can remain mapped for long time. This can cause memory isolation issue
> > > as this memory becomes unaccounted after getting mapped into the
> > > application address space. This patch adds the memcg accounting for such
> > > memory.
> > >
> > > Accounting the network memory comes with its own unique challenge. The
> > > high performance NIC drivers use page pooling to reuse the pages to
> > > eliminate/reduce the expensive setup steps like IOMMU. These drivers
> > > keep an extra reference on the pages and thus we can not depends on the
> > > page reference for the uncharging. The page in the pool may keep a memcg
> > > pinned for arbitrary long time or may get used by other memcg.
> > >
> > > This patch decouples the uncharging of the page from the refcnt and
> > > associate it with the map count i.e. the page gets uncharged when the
> > > last address space unmaps it. Now the question what if the driver drops
> > > its reference while the page is still mapped. That is fine as the
> > > address space also holds a reference to the page i.e. the reference
> > > count can not drop to zero before the map count.
> > >
> > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > Co-developed-by: Shakeel Butt <shakeelb@google.com>
> > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > ---
> > >  include/linux/memcontrol.h | 34 +++++++++++++++++++--
> > >  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
> > >  mm/rmap.c                  |  3 ++
> > >  net/ipv4/tcp.c             | 27 +++++++++++++----
> > >  4 files changed, 116 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 7a38a1517a05..0b0e3b4615cf 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
> > >
> > >  enum page_memcg_data_flags {
> > >       /* page->memcg_data is a pointer to an objcgs vector */
> > > -     MEMCG_DATA_OBJCGS = (1UL << 0),
> > > +     MEMCG_DATA_OBJCGS       = (1UL << 0),
> > >       /* page has been accounted as a non-slab kernel page */
> > > -     MEMCG_DATA_KMEM = (1UL << 1),
> > > +     MEMCG_DATA_KMEM         = (1UL << 1),
> > > +     /* page has been accounted as network memory */
> > > +     MEMCG_DATA_SOCK         = (1UL << 2),
> > >       /* the next bit after the last actual flag */
> > > -     __NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> > > +     __NR_MEMCG_DATA_FLAGS   = (1UL << 3),
> > >  };
> > >
> > >  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> > > @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > >       return page->memcg_data & MEMCG_DATA_KMEM;
> > >  }
> > >
> > > +static inline bool PageMemcgSock(struct page *page)
> > > +{
> > > +     return page->memcg_data & MEMCG_DATA_SOCK;
> > > +}
> > > +
> > >  #ifdef CONFIG_MEMCG_KMEM
> > >  /*
> > >   * page_objcgs - get the object cgroups vector associated with a page
> > > @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > >       return false;
> > >  }
> > >
> > > +static inline bool PageMemcgSock(struct page *page)
> > > +{
> > > +     return false;
> > > +}
> > > +
> > >  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > >  {
> > >       return true;
> > > @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
> > >  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
> > >  void mem_cgroup_sk_alloc(struct sock *sk);
> > >  void mem_cgroup_sk_free(struct sock *sk);
> > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > +                              unsigned int nr_pages);
> > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> > > +
> > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > >  {
> > >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> > >                                         int nid, int shrinker_id)
> > >  {
> > >  }
> > > +
> > > +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> > > +                                            struct page **pages,
> > > +                                            unsigned int nr_pages)
> > > +{
> > > +     return 0;
> > > +}
> > > +
> > > +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> > > +                                               unsigned int nr_pages)
> > > +{
> > > +}
> > >  #endif
> > >
> > >  #ifdef CONFIG_MEMCG_KMEM
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index db9836f4b64b..38e94538e081 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >       refill_stock(memcg, nr_pages);
> > >  }
> > >
> > > +/**
> > > + * mem_cgroup_charge_sock_pages - charge socket memory
> > > + * @memcg: memcg to charge
> > > + * @pages: array of pages to charge
> > > + * @nr_pages: number of pages
> > > + *
> > > + * Charges all @pages to current's memcg. The caller should have a reference on
> > > + * the given memcg.
> > > + *
> > > + * Returns 0 on success.
> > > + */
> > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > +                              unsigned int nr_pages)
> > > +{
> > > +     int ret = 0;
> > > +
> > > +     if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> > > +             goto out;
> > > +
> > > +     ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> > > +
> > > +     if (!ret) {
> > > +             int i;
> > > +
> > > +             for (i = 0; i < nr_pages; i++)
> > > +                     pages[i]->memcg_data = (unsigned long)memcg |
> > > +                             MEMCG_DATA_SOCK;
> > > +             css_get_many(&memcg->css, nr_pages);
> > > +     }
> > > +out:
> > > +     return ret;
> > > +}
> > > +
> > > +/**
> > > + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> > > + * @pages: array of pages to uncharge
> > > + * @nr_pages: number of pages
> > > + *
> > > + * This assumes all pages are charged to the same memcg.
> > > + */
> > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> > > +{
> > > +     int i;
> > > +     struct mem_cgroup *memcg;
> > > +
> > > +     if (mem_cgroup_disabled())
> > > +             return;
> > > +
> > > +     memcg = page_memcg(pages[0]);
> > > +
> > > +     if (unlikely(!memcg))
> > > +             return;
> > > +
> > > +     refill_stock(memcg, nr_pages);
> > > +
> > > +     for (i = 0; i < nr_pages; i++)
> > > +             pages[i]->memcg_data = 0;
> > > +     css_put_many(&memcg->css, nr_pages);
> > > +}
> >
> > What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
> > a separate counter? Do we plan to eventually have shrinkers for this type of memory?
> >
> 
> While the pages in question are part of an sk_buff, they may be
> accounted towards sockmem. However, that charge is unaccounted when
> the skb is freed after the receive operation. When they are in use by
> the user application I do not think sockmem is the right place to have
> a break-out counter.

Does it mean that a page can be accounted twice (even temporarily)?

Historically we have a corresponding vmstat counter to each charged page.
It helps with finding accounting/stastistics issues: we can check that
memory.current ~= anon + file + sock + slab + percpu + stack.
It would be nice to preserve such ability.

> 
> To double check, what do you mean by shrinker?

I mean do we plan to implement a mechanism to reclaim memory from these drivers
on-demand, if a cgroup is experiencing high memory pressure.
