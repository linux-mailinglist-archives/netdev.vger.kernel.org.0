Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1621D389D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgENRqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:46:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgENRqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:46:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EHbHq7062504;
        Thu, 14 May 2020 17:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=iiox1OoyLYPj1YqXqsqY5GvvS9T+WKHEsu/rhPn1oFk=;
 b=FzHGF011Y9lEeL/hjDvwDjL3GU5Ex3J7A42lisgz/H/JM9HZkYDyq9BBINKV2yWcJ3qu
 LGOUG4kAYAm1+hOdKfb8iJdAD6luAXO52kWSV5QmAMDj3FE8CG/O2PSLwlorR4b/+0Eu
 oIiucR4AI0IEtrks8Njx+klHtCccaej2ryM78LcXFErVOd5HoP5AStSl4qFsdMh8qZWm
 7bUHkJGVuvGWzS33wkEp+FQgR3IOn23Q+mM1amJnXB3EmIh8vKiy8gWrUy2rvyhaN/Sg
 Elhgu17hqQShCT9T32d9Ax2ZNKJF3h55RY1MbmiI+VOhwQVJpsW+Z177ZLG0tros4qmB lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3100xwv1w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 17:46:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EHggO7153853;
        Thu, 14 May 2020 17:46:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100ypsbf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 17:46:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EHkOiO000719;
        Thu, 14 May 2020 17:46:25 GMT
Received: from dhcp-10-175-210-26.vpn.oracle.com (/10.175.210.26)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 10:46:24 -0700
Date:   Thu, 14 May 2020 18:46:17 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, joe@perches.com,
        linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com, yhs@fb.com,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type
 printing
In-Reply-To: <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2005141738050.23867@localhost>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com> <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 13 May 2020, Alexei Starovoitov wrote:

> On Tue, May 12, 2020 at 06:56:38AM +0100, Alan Maguire wrote:
> > The printk family of functions support printing specific pointer types
> > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > full details see Documentation/core-api/printk-formats.rst.
> > 
> > This patchset proposes introducing a "print typed pointer" format
> > specifier "%pT"; the argument associated with the specifier is of
> > form "struct btf_ptr *" which consists of a .ptr value and a .type
> > value specifying a stringified type (e.g. "struct sk_buff") or
> > an .id value specifying a BPF Type Format (BTF) id identifying
> > the appropriate type it points to.
> > 
> > There is already support in kernel/bpf/btf.c for "show" functionality;
> > the changes here generalize that support from seq-file specific
> > verifier display to the more generic case and add another specific
> > use case; snprintf()-style rendering of type information to a
> > provided buffer.  This support is then used to support printk
> > rendering of types, but the intent is to provide a function
> > that might be useful in other in-kernel scenarios; for example:
> > 
> > - ftrace could possibly utilize the function to support typed
> >   display of function arguments by cross-referencing BTF function
> >   information to derive the types of arguments
> > - oops/panic messaging could extend the information displayed to
> >   dig into data structures associated with failing functions
> > 
> > The above potential use cases hint at a potential reply to
> > a reasonable objection that such typed display should be
> > solved by tracing programs, where the in kernel tracing records
> > data and the userspace program prints it out.  While this
> > is certainly the recommended approach for most cases, I
> > believe having an in-kernel mechanism would be valuable
> > also.
> > 
> > The function the printk() family of functions rely on
> > could potentially be used directly for other use cases
> > like ftrace where we might have the BTF ids of the
> > pointers we wish to display; its signature is as follows:
> > 
> > int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
> >                            char *buf, int len, u64 flags);
> > 
> > So if ftrace say had the BTF ids of the types of arguments,
> > we see that the above would allow us to convert the
> > pointer data into displayable form.
> > 
> > To give a flavour for what the printed-out data looks like,
> > here we use pr_info() to display a struct sk_buff *.
> > 
> >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > 
> >   pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
> > 
> > ...gives us:
> > 
> > (struct sk_buff){
> >  .transport_header = (__u16)65535,
> >  .mac_header = (__u16)65535,
> >  .end = (sk_buff_data_t)192,
> >  .head = (unsigned char *)000000007524fd8b,
> >  .data = (unsigned char *)000000007524fd8b,
> 
> could you add "0x" prefix here to make it even more C like
> and unambiguous ?
>

Sure.
 
> >  .truesize = (unsigned int)768,
> >  .users = (refcount_t){
> >   .refs = (atomic_t){
> >    .counter = (int)1,
> >   },
> >  },
> > }
> > 
> > For bpf_trace_printk() a "struct __btf_ptr *" is used as
> > argument; see tools/testing/selftests/bpf/progs/netif_receive_skb.c
> > for example usage.
> > 
> > The hope is that this functionality will be useful for debugging,
> > and possibly help facilitate the cases mentioned above in the future.
> > 
> > Changes since v1:
> > 
> > - changed format to be more drgn-like, rendering indented type info
> >   along with type names by default (Alexei)
> > - zeroed values are omitted (Arnaldo) by default unless the '0'
> >   modifier is specified (Alexei)
> > - added an option to print pointer values without obfuscation.
> >   The reason to do this is the sysctls controlling pointer display
> >   are likely to be irrelevant in many if not most tracing contexts.
> >   Some questions on this in the outstanding questions section below...
> > - reworked printk format specifer so that we no longer rely on format
> >   %pT<type> but instead use a struct * which contains type information
> >   (Rasmus). This simplifies the printk parsing, makes use more dynamic
> >   and also allows specification by BTF id as well as name.
> > - ensured that BTF-specific printk code is bracketed by
> >   #if ENABLED(CONFIG_BTF_PRINTF)
> 
> I don't like this particular bit:
> +config BTF_PRINTF
> +       bool "print type information using BPF type format"
> +       depends on DEBUG_INFO_BTF
> +       default n
> 
> Looks like it's only purpose is to gate printk test.
> In such case please convert it into hidden config that is
> automatically selected when DEBUG_INFO_BTF is set.
> Or just make printk tests to #if IS_ENABLED(DEBUG_INFO_BTF)
> 

I think the latter makes sense; if BTF isn't there retrieving
vmlinux BTF fails and we simply fall back to standard pointer
printing.  The only part of the code that won't work is the
printk tests that assume BTF display works, and as you suggest
they can just be gated via #if IS_ENABLED(DEBUG_INFO_BTF)

> > - removed incorrect patch which tried to fix dereferencing of resolved
> >   BTF info for vmlinux; instead we skip modifiers for the relevant
> >   case (array element type/size determination) (Alexei).
> > - fixed issues with negative snprintf format length (Rasmus)
> > - added test cases for various data structure formats; base types,
> >   typedefs, structs, etc.
> > - tests now iterate through all typedef, enum, struct and unions
> >   defined for vmlinux BTF and render a version of the target dummy
> >   value which is either all zeros or all 0xff values; the idea is this
> >   exercises the "skip if zero" and "print everything" cases.
> > - added support in BPF for using the %pT format specifier in
> >   bpf_trace_printk()
> > - added BPF tests which ensure %pT format specifier use works (Alexei).
> > 
> > Outstanding issues
> > 
> > - currently %pT is not allowed in BPF programs when lockdown is active
> >   prohibiting BPF_READ; is that sufficient?
> 
> yes. that's enough.
> 
> > - do we want to further restrict the non-obfuscated pointer format
> >   specifier %pTx; for example blocking unprivileged BPF programs from
> >   using it?
> 
> unpriv cannot use bpf_trace_printk() anyway. I'm not sure what is the concern.
> 

I forgot about bpf_trace_printk() not being available.

> > - likely still need a better answer for vmlinux BTF initialization
> >   than the current approach taken; early boot initialization is one
> >   way to go here.
> 
> btf_parse_vmlinux() can certainly be moved to late_initcall().
>

I'll try something in that direction for v3.
 
> > - may be useful to have a "print integers as hex" format modifier (Joe)
> 
> I'd rather stick to the convention that the type drives the way the value is printed.
> For example:
>   u8 ch = 65;
>   pr_info("%pT", BTF_PTR_TYPE(&ch, "char"));
>   prints 'A'
> while
>   u8 ch = 65;
>   pr_info("%pT", BTF_PTR_TYPE(&ch, "u8"));
>   prints 65
> 
> > 
> > Important note: if running test_printf.ko - the version in the bpf-next
> > tree will induce a panic when running the fwnode_pointer() tests due
> > to a kobject issue; applying the patch in
> > 
> > https://lkml.org/lkml/2020/4/17/389
> 
> Thanks for the headsup!
> 
> BTF_PTR_ID() is a great idea as well.
> In the llvm 11 we will introduce __builtin__btf_type_id().
> The bpf program will be able to say:
> bpf_printk("%pT", BTF_PTR_ID(skb, __builtin_btf_type_id(skb, 1)));
> That will help avoid run-time search through btf types by string name.
> The compiler will supply btf_id at build time and libbpf will do
> a relocation into vmlinux btf_id prior to loading.
>

Neat!
 
> Also I think there should be another flag BTF_SHOW_PROBE_DATA.
> It should probe_kernel_read() all data instead of direct dereferences.
> It could be implemented via single probe_kernel_read of the whole BTF data
> structure before pringing the fields one by one. So it should be simple
> addition to patch 2.

Totally agreed we need to prioritize safety for the BPF case.
There's no way to avoid a memory allocation to store the 
probe_kernel_read() data for the BTF_SHOW_PROBE_DATA case is there?
One possible approach would be to DEFINE_PER_CPU() dedicated
buffers; we can observe that because bpf_trace_printk() is
limited in how much data can be displayed, we wouldn't
necessarily need to make such a buffer too big, and could
do multiple probe_kernel_read()s in such cases.

> This flag should be default for printk() from bpf program,
> since the verifier won't be checking that pointer passed into bpf_trace_printk
> is of correct btf type and it's a real pointer.
> Whether this flag should be default for normal printk() is arguable.
> I would make it so. The performance cost of extra copy is small comparing
> with no-crash guarantee it provides. I think it would be a good trade off.
> 

Right, performance isn't the goal here. I think if we could avoid
an allocation, always probe_kernel_read()ing would be best.

> In the future we can extend the verifier so that:
> bpf_safe_printk("%pT", skb);
> will be recognized that 'skb' is PTR_TO_BTF_ID and corresponding and correct
> btf_id is passed into printk. Mistakes will be caught at program
> verification time.
> 

That would be great!

Alan
