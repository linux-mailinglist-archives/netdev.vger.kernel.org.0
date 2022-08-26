Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C95A2FC2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiHZTQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiHZTQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:16:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C7FDFB0;
        Fri, 26 Aug 2022 12:16:09 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QIP3Ye024804;
        Fri, 26 Aug 2022 12:15:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gWZg1hCWT3uAfoYctojniQsZFBS106+Fh563dLLI9r4=;
 b=Jh/Z5tBIAmNuGWFYJYjJQeBvB51m1NOQ4QEqeLpTNAgyB1ynngOlBCEVUeGYaUu+Y9tM
 /2vQ/q1pAQFtV/w2ukBLq6d9i3RPYPRF91n57n6wUrSpdB8HF/0/ORSbqtCVIUFk93oJ
 qlWw7OIdGSTkOY57nSk3gj7wuviGaEe+bj8= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j6ne2d99y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 12:15:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifea6/YjMMy7mhPPvpzMn/XSaJX3U4bA0PVJ/JIGYb7/eMxUwV7qpIIECGBtx7/OgmKJuFjJSSvbgRhSi2rntbOVndtWzIBJq2UZ0uAh2xKMVrdryChs7pKwv41S2yLNV6+IVb1beug39/PkkX5rrbH8Kn7FV450Nfuxn6blNj8RJRruriw8sWi4SfDXebeH+yAG26ZKd4N+cDe6R+sTtEKAm5qaj4aKeVkGQ9XZCQlth6z8i1ATZY2FHSRnxpA4Sy+FfDEVOvKnH7VircCjqNkGd1Nj2zEUiuooGjj3tCTxHfeWyHjqPLCQlfH0Fd1Vl/57iU9mulfAuKj1bLEhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWZg1hCWT3uAfoYctojniQsZFBS106+Fh563dLLI9r4=;
 b=UJk9eQa3Zh7crYOsqkfi+5qKny9xcT5sqN1yhknYrYH5B/7RWp4qAPIJEd2CJlHeJFFLtJs+Ppv3t+fpkqT6mP7G9sEs434u3a5eIOcgWDXaOdkyFoyZPvUepfeisDb6faWlUHk1UfvWGE0iOdfDlktNage5NW8Kb8o/2GNNy7Go14U6/m3U75Bcv5AEClrp3ot5bZMWaG3L7tHZElsG434t0pqNJC2RtXGC6Hj+RneEMWcFIeta7+XoOME03OsXMKDgoLnGU9dD3YKFaknf12OIi2cN/mnYkhMp4tcOUoqQzgf3sILZ/Er5jsBdyltrSqwWyUZiZ+BQw/HQpfXUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3976.namprd15.prod.outlook.com (2603:10b6:5:2b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 19:15:45 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:15:45 +0000
Date:   Fri, 26 Aug 2022 12:15:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: net: Change sk_getsockopt() to take
 the sockptr_t argument
Message-ID: <20220826191543.dtrrhcga5ynuyrw2@kafai-mbp.dhcp.thefacebook.com>
References: <20220824222601.1916776-1-kafai@fb.com>
 <20220824222614.1918332-1-kafai@fb.com>
 <CAKH8qBtT332XrJ3aEw=o_9K+g6LYHbdhPG7s8R1uuNbKBso0+Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtT332XrJ3aEw=o_9K+g6LYHbdhPG7s8R1uuNbKBso0+Q@mail.gmail.com>
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e43bb8f-8d23-40eb-370c-08da87976062
X-MS-TrafficTypeDiagnostic: DM6PR15MB3976:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5+FiP9xJRFJLHWHdgZEk08XOoxsafwz3zbRBpVA8KVSxYWSNMnPfL5yt/LtNMpOTDf6cG/1fMqNnFEZDoSKAiZWfMbVGHUXXsGw6OFm41je8YEz6nQOyrksjFAq4iNa8JpSIDjkygO6I1OU+yuPbZlYfL5uRTdCGewUcDCbKeP3cu6ocLric66TCKuHZI82hHtPJGnzQi3VDft5/hczR+iB3neMc5UKaJLfokzyZTT4bNxTmTW4NoAV+O72LMd5f64bhJ2SBfNTkY7k6if9CofPK3imy7D41UAEkoXcXL5QZuXEQ5piBHBlKS+eiq8F5xYgCo4U2iSII4Yvz8QsXOo5NrWVEAKtFlzNAgdsE5LTpQ2OnoE8CrSAObmEHuJiKgH/NpxTSmXO1oRXUtL21cxJDYSNTpfeqfaFBcCmtcVBEWL/CU0uEemrMuABO4tFccG8NIFEw0T0Bi2qHRZJpGWs0brYGT9au52w+OJ0jvL1U/cZLwx+8fAnYXeKg8b/tAA7yhlIWwCKdppKctrz6Pl9W0CN3ydket+L4InPWTawcPj+gYi9QYLbRItuLLfmgW+f7zB3i3Ax32gGDalvGOn8nYs7JtyJXKukeENCfzWsrQyNaC02eUBo6uzYybVg/M5EPjLpcYw8CnesfKtGRnHz5UXNp7CV6dOLtrH3vuqjsisR469nloWPrEKhqorrnei1tR81PHQ6xdJymRk7UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(8676002)(4326008)(66476007)(66556008)(2906002)(38100700002)(478600001)(66946007)(7416002)(8936002)(5660300002)(316002)(6916009)(86362001)(54906003)(83380400001)(1076003)(186003)(6486002)(52116002)(41300700001)(53546011)(6512007)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIDBpFFT4r/CAo/mdL7fZg3jk/k+jFqiKdNyRe5L86/J0EDRZnmbl8hFB42J?=
 =?us-ascii?Q?gO/CCeZCPvr2vY83doG5CEzVmrAvL30eo2iwzdUaL0RR7Dvaxy3vipAEgbpw?=
 =?us-ascii?Q?UxE7PSZmlbmG6/dCg9yS4y1ZxpNu0EKOxcwYsK3zLu3wF6ciHIFCynUP18a0?=
 =?us-ascii?Q?5Rg4AP2Tk6p5O2tExck2/Xqk7eACUeVbQO71g/FN3hIHpFNZlKwDRWYnlqkm?=
 =?us-ascii?Q?4n6A3qgLKk42lVS4JKhrWvAeR2vuEesEXPaMs3t6NmIX8bbn1Z4c1aYJBxwd?=
 =?us-ascii?Q?sv0Sas8Usscij1YGs601Z7bxqQaufllmzvz9ej9HjeLT+QH6Um5ZLQBk7R9Q?=
 =?us-ascii?Q?az9AifGbExYEH2elNECFA0MW4WPTmB6LJ3/WB7PhFN2i5d25rfXeT8RBSWAv?=
 =?us-ascii?Q?BBKtMN02lmC9OptxyhY1GDSiThmjeyopJzBkDiB7Z1dek8WDH9SO0k+zRK0H?=
 =?us-ascii?Q?IJ28yBFh6vUCZSMrwD4tolu2WXa/6eYkEsh+xCGO6AB4ev5aPvgD8+cTuYU6?=
 =?us-ascii?Q?YKMZ+YzrrCYeXvXfzmsHM83E2QuXlMHrbSe+bwHEgE9NjFKfRgZViijk1uh2?=
 =?us-ascii?Q?+zZsagISX+4aaCuvBiSBvxSBDv6cscSqJBkiiqlSntN76En2kQUXs5FNnRBG?=
 =?us-ascii?Q?QN+mAlSQOSZx9DvtUOKFPZ0g+gBdAnSn+wGIVKYRKqIQpihbTA74QiGRRPn9?=
 =?us-ascii?Q?ig9PDUh/Oox+6eeu7mER4h4wfqJBnU8gckWeC9x+tzWzc76mnzCFhV0+Gs55?=
 =?us-ascii?Q?XlWHBoQ1RNSMnuyjJ6vb2GycOauJmuLfFsmh4xu3uy0bxjCFUWGncJS7j5Uw?=
 =?us-ascii?Q?IGa/Iwoj+owcZSPlTQpZKQqr3Sem7Vbxhjbw1XSpgMu9uNCOqxm3PDVxdq33?=
 =?us-ascii?Q?1iX95kGs72FBergXsXewWS4CTjC5WRYhWFUi508fH4BzL89sFrN9I6QJJMnv?=
 =?us-ascii?Q?g6XIS/f7hMmLmyYmn/XJwY+xe/Ononvp4aWb6oz1ODB+yJX1SCBxzXsijcUY?=
 =?us-ascii?Q?BAEutiJH00U3iXuOC02OruyYfICrq5i/hoSRxOHiTT5MtC1WOWfRaXWnGXJr?=
 =?us-ascii?Q?HxbV5obqbW0PkNLg0aFU7lpZrW192njZ2AWe0s31i3ZuNh/7VageWnuB2N0/?=
 =?us-ascii?Q?qrXSjV/tRucwHomnbUqcCoOR42tWr7LvvabAlDLn/YXzTQUe+ZjTsUEq/ora?=
 =?us-ascii?Q?Lj6S3jj4c36ZrgtfpWgXMaFqvZT5x5Hc+gPgOTPfnhB9hDeEMdHMNnyuaOaH?=
 =?us-ascii?Q?d1l4LKRbF4cnM6bGcW3xHeJ48m6tXtQX34IsoiA2R1B1yEUQClqIJNaz2QVO?=
 =?us-ascii?Q?e9nLbVf5ZqwhqrFz633ILt5Qja4Y9x3T9113tJOzUxZ+NMRph4MsM8W5HiI5?=
 =?us-ascii?Q?P3b/0YNcrMLcqm2R8AthXATWB6cexVkFxbiHI35vmZTsb87/YtQHbjqmeEan?=
 =?us-ascii?Q?QdOtM1Vo5dLUY5uF2+lG6tgzz5GrWVETEpM7kCIYqdf7NtjcgrRWgF598Sbh?=
 =?us-ascii?Q?gj+oa/1cBpgHPz1qUspkUkj8gDPUgwj/8SHgykdABma1Ejz2LuG7oDkvY0pL?=
 =?us-ascii?Q?VOiwjpMJZ1aEuSGUSFYJKFvYhWaOohuj3BnamMI7ElAGfAL3WU/SHRQpiIbb?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e43bb8f-8d23-40eb-370c-08da87976062
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:15:45.5707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFPP9uAuggHRqVqYXSQO9KRcfUiRv4uuR/W5cL/jJFhZOaaKzkb/xKtC68xFzKhH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3976
X-Proofpoint-ORIG-GUID: t2ztklZ_ztYZtFjzZFKsvb5X7dz52WmV
X-Proofpoint-GUID: t2ztklZ_ztYZtFjzZFKsvb5X7dz52WmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_10,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:07:36AM -0700, Stanislav Fomichev wrote:
> On Wed, Aug 24, 2022 at 3:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch changes sk_getsockopt() to take the sockptr_t argument
> > such that it can be used by bpf_getsockopt(SOL_SOCKET) in a
> > latter patch.
> >
> > security_socket_getpeersec_stream() is not changed.  It stays
> > with the __user ptr (optval.user and optlen.user) to avoid changes
> > to other security hooks.  bpf_getsockopt(SOL_SOCKET) also does not
> > support SO_PEERSEC.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/filter.h  |  3 +--
> >  include/linux/sockptr.h |  5 +++++
> >  net/core/filter.c       |  5 ++---
> >  net/core/sock.c         | 43 +++++++++++++++++++++++------------------
> >  4 files changed, 32 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index a5f21dc3c432..527ae1d64e27 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -900,8 +900,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk);
> >  int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk);
> >  void sk_reuseport_prog_free(struct bpf_prog *prog);
> >  int sk_detach_filter(struct sock *sk);
> > -int sk_get_filter(struct sock *sk, struct sock_filter __user *filter,
> > -                 unsigned int len);
> > +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
> >
> >  bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
> >  void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
> > diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> > index d45902fb4cad..bae5e2369b4f 100644
> > --- a/include/linux/sockptr.h
> > +++ b/include/linux/sockptr.h
> > @@ -64,6 +64,11 @@ static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
> >         return 0;
> >  }
> >
> > +static inline int copy_to_sockptr(sockptr_t dst, const void *src, size_t size)
> > +{
> > +       return copy_to_sockptr_offset(dst, 0, src, size);
> > +}
> > +
> >  static inline void *memdup_sockptr(sockptr_t src, size_t len)
> >  {
> >         void *p = kmalloc_track_caller(len, GFP_USER | __GFP_NOWARN);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 63e25d8ce501..0f6f86b9e487 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -10712,8 +10712,7 @@ int sk_detach_filter(struct sock *sk)
> >  }
> >  EXPORT_SYMBOL_GPL(sk_detach_filter);
> >
> > -int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
> > -                 unsigned int len)
> > +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len)
> >  {
> >         struct sock_fprog_kern *fprog;
> >         struct sk_filter *filter;
> > @@ -10744,7 +10743,7 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
> >                 goto out;
> >
> >         ret = -EFAULT;
> > -       if (copy_to_user(ubuf, fprog->filter, bpf_classic_proglen(fprog)))
> > +       if (copy_to_sockptr(optval, fprog->filter, bpf_classic_proglen(fprog)))
> >                 goto out;
> >
> >         /* Instead of bytes, the API requests to return the number
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 21bc4bf6b485..7fa30fd4b37f 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -712,8 +712,8 @@ static int sock_setbindtodevice(struct sock *sk, sockptr_t optval, int optlen)
> >         return ret;
> >  }
> >
> > -static int sock_getbindtodevice(struct sock *sk, char __user *optval,
> > -                               int __user *optlen, int len)
> > +static int sock_getbindtodevice(struct sock *sk, sockptr_t optval,
> > +                               sockptr_t optlen, int len)
> >  {
> >         int ret = -ENOPROTOOPT;
> >  #ifdef CONFIG_NETDEVICES
> > @@ -737,12 +737,12 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
> >         len = strlen(devname) + 1;
> >
> >         ret = -EFAULT;
> > -       if (copy_to_user(optval, devname, len))
> > +       if (copy_to_sockptr(optval, devname, len))
> >                 goto out;
> >
> >  zero:
> >         ret = -EFAULT;
> > -       if (put_user(len, optlen))
> > +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
> >                 goto out;
> >
> >         ret = 0;
> > @@ -1568,20 +1568,23 @@ static void cred_to_ucred(struct pid *pid, const struct cred *cred,
> >         }
> >  }
> >
> > -static int groups_to_user(gid_t __user *dst, const struct group_info *src)
> > +static int groups_to_user(sockptr_t dst, const struct group_info *src)
> >  {
> >         struct user_namespace *user_ns = current_user_ns();
> >         int i;
> >
> > -       for (i = 0; i < src->ngroups; i++)
> > -               if (put_user(from_kgid_munged(user_ns, src->gid[i]), dst + i))
> > +       for (i = 0; i < src->ngroups; i++) {
> > +               gid_t gid = from_kgid_munged(user_ns, src->gid[i]);
> > +
> > +               if (copy_to_sockptr_offset(dst, i * sizeof(gid), &gid, sizeof(gid)))
> >                         return -EFAULT;
> > +       }
> >
> >         return 0;
> >  }
> >
> >  static int sk_getsockopt(struct sock *sk, int level, int optname,
> > -                        char __user *optval, int __user *optlen)
> > +                        sockptr_t optval, sockptr_t optlen)
> >  {
> >         struct socket *sock = sk->sk_socket;
> >
> > @@ -1600,7 +1603,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >         int lv = sizeof(int);
> >         int len;
> >
> > -       if (get_user(len, optlen))
> > +       if (copy_from_sockptr(&len, optlen, sizeof(int)))
> 
> Do we want to be consistent wrt to sizeof?
> 
> copy_from_sockptr(&len, optlen, sizeof(int))
> vs
> copy_from_sockptr(&len, optlen, sizeof(optlen))
optlen type is sockptr_t now. sizeof(optlen) won't work.

so either

copy_from_sockptr(&len, optlen, sizeof(len))
or
copy_from_sockptr(&len, optlen, sizeof(int))

I went with the latter 'sizeof(int)' for consistency because the
name is not always 'len' but optlen is always in 'int'.

> 
> Alternatively, should we have put_sockptr/get_sockopt with a semantics
> similar to put_user/get_user to remove all this ambiguity?
The type is lost in sockptr.{kernel,user} which is 'void *'.  {get,put}_user()
depends on it.  The very early sockptr_t introduction also changes
get_user() to copy_from_sockptr() for integer value.

One option could be to make {get,put}_sockopt(x, sockptr) to use x to decide the
type.  Not sure how that may look like.  I can give it a try.

> 
> >                 return -EFAULT;
> >         if (len < 0)
> >                 return -EINVAL;
> > @@ -1735,7 +1738,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                 cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
> >                 spin_unlock(&sk->sk_peer_lock);
> >
> > -               if (copy_to_user(optval, &peercred, len))
> > +               if (copy_to_sockptr(optval, &peercred, len))
> >                         return -EFAULT;
> >                 goto lenout;
> >         }
> > @@ -1753,11 +1756,11 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                 if (len < n * sizeof(gid_t)) {
> >                         len = n * sizeof(gid_t);
> >                         put_cred(cred);
> > -                       return put_user(len, optlen) ? -EFAULT : -ERANGE;
> > +                       return copy_to_sockptr(optlen, &len, sizeof(int)) ? -EFAULT : -ERANGE;
> >                 }
> >                 len = n * sizeof(gid_t);
> >
> > -               ret = groups_to_user((gid_t __user *)optval, cred->group_info);
> > +               ret = groups_to_user(optval, cred->group_info);
> >                 put_cred(cred);
> >                 if (ret)
> >                         return ret;
> > @@ -1773,7 +1776,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                         return -ENOTCONN;
> >                 if (lv < len)
> >                         return -EINVAL;
> > -               if (copy_to_user(optval, address, len))
> > +               if (copy_to_sockptr(optval, address, len))
> >                         return -EFAULT;
> >                 goto lenout;
> >         }
> > @@ -1790,7 +1793,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                 break;
> >
> >         case SO_PEERSEC:
> > -               return security_socket_getpeersec_stream(sock, optval, optlen, len);
> > +               return security_socket_getpeersec_stream(sock, optval.user, optlen.user, len);
> 
> I'm assuming there should be something to prevent this being called
> from BPF? (haven't read all the patches yet)
Not sure if any of the hooks may block.

> Do we want to be a bit more defensive with 'if (!optval.user) return
> -EFAULT' or something similar?
Checking 'optval.is_kernel || optlen.is_kernel'?
Yep.  Make sense.  It may be better to do the check inside
security_socket_getpeersec_stream(sock, optval, optlen, ...).

> 
> 
> >         case SO_MARK:
> >                 v.val = sk->sk_mark;
> > @@ -1822,7 +1825,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                 return sock_getbindtodevice(sk, optval, optlen, len);
> >
> >         case SO_GET_FILTER:
> > -               len = sk_get_filter(sk, (struct sock_filter __user *)optval, len);
> > +               len = sk_get_filter(sk, optval, len);
> >                 if (len < 0)
> >                         return len;
> >
> > @@ -1870,7 +1873,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >                 sk_get_meminfo(sk, meminfo);
> >
> >                 len = min_t(unsigned int, len, sizeof(meminfo));
> > -               if (copy_to_user(optval, &meminfo, len))
> > +               if (copy_to_sockptr(optval, &meminfo, len))
> >                         return -EFAULT;
> >
> >                 goto lenout;
> > @@ -1939,10 +1942,10 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >
> >         if (len > lv)
> >                 len = lv;
> > -       if (copy_to_user(optval, &v, len))
> > +       if (copy_to_sockptr(optval, &v, len))
> >                 return -EFAULT;
> >  lenout:
> > -       if (put_user(len, optlen))
> > +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
> >                 return -EFAULT;
> >         return 0;
> >  }
> > @@ -1950,7 +1953,9 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> >  int sock_getsockopt(struct socket *sock, int level, int optname,
> >                     char __user *optval, int __user *optlen)
> >  {
> > -       return sk_getsockopt(sock->sk, level, optname, optval, optlen);
> > +       return sk_getsockopt(sock->sk, level, optname,
> > +                            USER_SOCKPTR(optval),
> > +                            USER_SOCKPTR(optlen));
> >  }
> >
> >  /*
> > --
> > 2.30.2
> >
