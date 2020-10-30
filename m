Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC73B2A04FB
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgJ3MHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:07:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3MHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:07:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UC5Mea187402;
        Fri, 30 Oct 2020 12:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=PA5vm8YYxJcMJz7FkXJPGgwFOrfVUarZqcqKwGiR5pw=;
 b=vEWlzI++kJ99DZQRzwgFRaholuNA8Vo/M9bKIgdech0cXpLpnjcvmA8anPdbvzA158Cl
 4Y2JzbFSWfMk1uOoFmdyaAYdz9x36iQdGakCHuPaiZ1JiplwdHkll5xtTpHMBeDX7INh
 IPgrca+O3sbFI+29PbYOi+A5kDLDtRVLWn6koUeLufrxK9FZEqfSX+xLobAmgpY2zpGB
 pz7gFP8WRMKzzc0LMPKFsyw9uNLyYCjQ1Rkpxkjdz9Y3oLXSxgACWY4gsZGvFSp2+Elf
 F8u+mUs4zpTbpogYa3M4blYW+s+ShOTfFW5FB0YaLQDMau7HEe9izo75u3P7zsI7cb0D gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb9h3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:06:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UC0TeT106000;
        Fri, 30 Oct 2020 12:04:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1ud1gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 12:04:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09UC4aHZ030085;
        Fri, 30 Oct 2020 12:04:36 GMT
Received: from dhcp-10-175-216-65.vpn.oracle.com (/10.175.216.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 05:04:35 -0700
Date:   Fri, 30 Oct 2020 12:04:27 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/11] libbpf: split BTF support
In-Reply-To: <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2010301144050.25037@localhost>
References: <20201029005902.1706310-1-andrii@kernel.org> <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com> <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=3 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020, Andrii Nakryiko wrote:

> On Thu, Oct 29, 2020 at 5:33 PM Song Liu <songliubraving@fb.com> wrote:
> >
> >
> >
> > > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> > >
> > > This patch set adds support for generating and deduplicating split BTF. This
> > > is an enhancement to the BTF, which allows to designate one BTF as the "base
> > > BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> > > kernel module BTF), which are building upon and extending base BTF with extra
> > > types and strings.
> > >
> > > Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> > > with continuous and transparent numbering scheme. This allows all the existing
> > > users of BTF to work correctly and stay agnostic to the base/split BTFs
> > > composition.  The only difference is in how to instantiate split BTF: it
> > > requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> > > or btf__parse_xxx_split() "constructors" explicitly.
> > >
> > > This split approach is necessary if we are to have a reasonably-sized kernel
> > > module BTFs. By deduping each kernel module's BTF individually, resulting
> > > module BTFs contain copies of a lot of kernel types that are already present
> > > in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
> > > kernel configuration with 700 modules built, non-split BTF approach results in
> > > 115MBs of BTFs across all modules. With split BTF deduplication approach,
> > > total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> > > around 4MBs). This seems reasonable and practical. As to why we'd need kernel
> > > module BTFs, that should be pretty obvious to anyone using BPF at this point,
> > > as it allows all the BTF-powered features to be used with kernel modules:
> > > tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
> >
> > Some high level questions. Do we plan to use split BTF for in-tree modules
> > (those built together with the kernel) or out-of-tree modules (those built
> > separately)? If it is for in-tree modules, is it possible to build split BTF
> > into vmlinux BTF?
> 
> It will be possible to use for both in-tree and out-of-tree. For
> in-tree, this will be integrated into the kernel build process. For
> out-of-tree, whoever builds their kernel module will need to invoke
> pahole -J with an extra flag pointing to the right vmlinux image (I
> haven't looked into the exact details of this integration, maybe there
> are already scripts in Linux repo that out-of-tree modules have to
> use, in such case we can add this integration there).
> 
> Merging all in-tree modules' BTFs into vmlinux's BTF defeats the
> purpose of the split BTF and will just increase the size of vmlinux
> BTF unnecessarily.
>

Again more of a question about how module BTF will be exposed, but
I'm wondering if there will be a way for a consumer to ask for
type info across kernel and module BTF, i.e. something like
libbpf_find_kernel_btf_id() ? Similarly will __builtin_btf_type_id()
work across both vmlinux and modules? I'm thinking of the case where we 
potentially don't know which module a type is defined in.

I realize in some cases type names may refer to different types in 
different modules (not sure how frequent this is in practice?) but
I'm curious how the split model for modules will interact with existing 
APIs and helpers.

In some cases it's likely that modules may share types with
each other that they do not share with vmlinux; in such cases 
will those types get deduplicated also, or is deduplication just
between kernel/module, and not module/module? 

Sorry I know these questions aren't about this patchset in
particular, but I'm just trying to get a sense of the bigger
picture. Thanks!

Alan
