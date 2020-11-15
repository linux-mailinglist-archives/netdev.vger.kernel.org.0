Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8252B347F
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgKOKy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:54:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKOKy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:54:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFArVhe149463;
        Sun, 15 Nov 2020 10:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=0XMZD16bdaTBBS1c0EriN29o6a/bDa7mcaxrZicQ764=;
 b=rDK+7NcdTjXfBIsPVN14lB0wYJiwWvdHacUFHFmz1nXYGNQkvlda75Pxnl1YgvgNSBbv
 p0nh39FGMcuuTo3r944Fl4i+rHlygV25nuKOYLYvFADGVwokVHce1S7AjG1bMqUVCX3L
 CglZzMtfQV+bI2BQq0KuqZKuEbWZ3zJKSdRlSHsAXkm/PIsvGkVsGmCXn9hfbz+LtrCq
 khMEnH4Y8RH34AksLmr4xsx92UPRes0BkFmmCgsH64Eo2lPHDr8ceOpKV4bUIstRfiPM
 e0KJJIu/WmhAX8ufu1RJ2g3LldZrQQNkRHldpeLeBR3onJXyuuxeW2Q57OHzeRDdL1WQ yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vmt5ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 10:53:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFApJ3b062611;
        Sun, 15 Nov 2020 10:53:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0nc519-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 10:53:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AFArQQd022860;
        Sun, 15 Nov 2020 10:53:26 GMT
Received: from dhcp-10-175-173-115.vpn.oracle.com (/10.175.173.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Nov 2020 02:53:26 -0800
Date:   Sun, 15 Nov 2020 10:53:19 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 1/3] bpf: add module support to btf display
 helpers
In-Reply-To: <778cc9b5-2358-e491-1085-2a5c11dbbf57@fb.com>
Message-ID: <alpine.LRH.2.21.2011151047410.2244@localhost>
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com> <1605291013-22575-2-git-send-email-alan.maguire@oracle.com> <CAEf4BzaaUdMnfADQdT=myDJtQtHoQ_aW7T8XidrCkYZ=pGXuaQ@mail.gmail.com> <CAADnVQK6PFAHQMBgQ=Xp7tUFkUBg5yUgBM+r5mi-Kd5UWNWHzw@mail.gmail.com>
 <778cc9b5-2358-e491-1085-2a5c11dbbf57@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011150066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150066
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020, Yonghong Song wrote:

> 
> 
> On 11/14/20 8:04 AM, Alexei Starovoitov wrote:
> > On Fri, Nov 13, 2020 at 10:59 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com>
> >> wrote:
> >>>
> >>> bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
> >>> argument that specifies type information about the type to
> >>> be displayed.  Augment this information to include a module
> >>> name, allowing such display to support module types.
> >>>
> >>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> >>> ---
> >>>   include/linux/btf.h            |  8 ++++++++
> >>>   include/uapi/linux/bpf.h       |  5 ++++-
> >>>   kernel/bpf/btf.c               | 18 ++++++++++++++++++
> >>>   kernel/trace/bpf_trace.c       | 42
> >>>   ++++++++++++++++++++++++++++++++----------
> >>>   tools/include/uapi/linux/bpf.h |  5 ++++-
> >>>   5 files changed, 66 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/include/linux/btf.h b/include/linux/btf.h
> >>> index 2bf6418..d55ca00 100644
> >>> --- a/include/linux/btf.h
> >>> +++ b/include/linux/btf.h
> >>> @@ -209,6 +209,14 @@ static inline const struct btf_var_secinfo
> >>> *btf_type_var_secinfo(
> >>>   const struct btf_type *btf_type_by_id(const struct btf *btf, u32
> >>>   type_id);
> >>>   const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> >>>   struct btf *btf_parse_vmlinux(void);
> >>> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> >>> +struct btf *bpf_get_btf_module(const char *name);
> >>> +#else
> >>> +static inline struct btf *bpf_get_btf_module(const char *name)
> >>> +{
> >>> +       return ERR_PTR(-ENOTSUPP);
> >>> +}
> >>> +#endif
> >>>   struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
> >>>   #else
> >>>   static inline const struct btf_type *btf_type_by_id(const struct btf
> >>>   *btf,
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index 162999b..26978be 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
> >>>    *             the pointer data is carried out to avoid kernel crashes
> >>>    during
> >>>    *             operation.  Smaller types can use string space on the
> >>>    stack;
> >>>    *             larger programs can use map data to store the string
> >>> - *             representation.
> >>> + *             representation.  Module-specific data structures can be
> >>> + *             displayed if the module name is supplied.
> >>>    *
> >>>    *             The string can be subsequently shared with userspace via
> >>>    *             bpf_perf_event_output() or ring buffer interfaces.
> >>> @@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
> >>>    * potentially to specify additional details about the BTF pointer
> >>>    * (rather than its mode of display) - is included for future use.
> >>>    * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
> >>> + * A module name can be specified for module-specific data.
> >>>   */
> >>>   struct btf_ptr {
> >>>          void *ptr;
> >>>          __u32 type_id;
> >>>          __u32 flags;            /* BTF ptr flags; unused at present. */
> >>> +       const char *module;     /* optional module name. */
> >>
> >> I think module name is a wrong API here, similarly how type name was
> >> wrong API for specifying the type (and thus we use type_id here).
> >> Using the module's BTF ID seems like a more suitable interface. That's
> >> what I'm going to use for all kinds of existing BPF APIs that expect
> >> BTF type to attach BPF programs.
> >>
> >> Right now, we use only type_id and implicitly know that it's in
> >> vmlinux BTF. With module BTFs, we now need a pair of BTF object ID +
> >> BTF type ID to uniquely identify the type. vmlinux BTF now can be
> >> specified in two different ways: either leaving BTF object ID as zero
> >> (for simplicity and backwards compatibility) or specifying it's actual
> >> BTF obj ID (which pretty much always should be 1, btw). This feels
> >> like a natural extension, WDYT?
> >>
> >> And similar to type_id, no one should expect users to specify these
> >> IDs by hand, Clang built-in and libbpf should work together to figure
> >> this out for the kernel to use.
> >>
> >> BTW, with module names there is an extra problem for end users. Some
> >> types could be either built-in or built as a module (e.g., XFS data
> >> structures). Why would we require BPF users to care which is the case
> >> on any given host?
> > 
> > +1.
> > As much as possible libbpf should try to hide the difference between
> > type in a module vs type in the vmlinux, since that difference most of the
> > time is irrelevant from bpf prog pov.
>

All sounds good to me - I've split out the libbpf fix and 
put together an updated patchset for the helpers/test which
converts the currently unused __u32 "flags" field in
struct btf_ptr to an "obj_id" field.  If obj_id is > 1 it
is presumed to be a module ID.  I'd suggest we could move
ahead with those changes, using the more clunky methods
to retrieve the module-specific BTF id, and later fix up
the test to use Yonghong's __builtin_btf_type_id()
modification.  Does that sound reasonable?

In connection to this, I wonder if libbpf could
benefit from a simple helper btf__id() (similar
to btf__fd()), allowing easy retrieval of the
object ID associated with module BTF?  I suspect
we will always have cases in general-purpose
tracers where we need to look up BTF ids of
objects dynamically, so such a function would
help in that case.

> I just crafted a llvm patch where for __builtin_btf_type_id(), a 64bit value
> is returned instead of a 32bit value. libbpf can use the lower
> 32bit as the btf_type_id and upper 32bit as the kernel module btf id.
> 
>    https://reviews.llvm.org/D91489
> 
> feel free to experiment with it to see whether it helps.
> 
> 

Great! I'll give it a try, thanks!

Alan
