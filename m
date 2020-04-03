Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59C19E1A8
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDCX4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:56:15 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:40424 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgDCX4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:56:15 -0400
Received: by mail-ua1-f68.google.com with SMTP id a10so3414572uad.7;
        Fri, 03 Apr 2020 16:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6SCgIOYpnudRhZtd6qEg7IVEHLuQtvGrqyErgBDY60=;
        b=IFE034VSz/3ycyva/l2iazosnDVUf7SSgHN6Z8JXjDifboK15i9qi313yrusM9LmBO
         XByGyf2jk18ykin/a0/4YNrL/wXW1o8rY1y64LnBmO+ryyl/sXXRCHWTprYEEk1r9YmR
         A46B2Alf69FmPdZAqJK0Q3F3hfRj9IVVTjfosRCcUdRlQiBmu/H+qW+vYKVlRS/tWtpP
         FHIfVX1/2bTnJTCbmELiirLG2BQRxBL33UPYhrtg9I2NjQ9VIfa50wVcERAPCvrlLuIx
         ruNJ8Ims2ZshG9em8msfZ/+2QBaI4+QQRIGiAL7xV39oIWawuX2Dkdjo3xmP1/5HmEOh
         bc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6SCgIOYpnudRhZtd6qEg7IVEHLuQtvGrqyErgBDY60=;
        b=mkfogAc3U4q9bcDsqvEsRKrSwEJ3uicm8w1q6T6LkrJnkMQNxr8miJ1wtvF65AHBqD
         FC7QkPDL6KTyy9Ie7W2TxNi1eIbya8gZ/HtUSKhyshTWMLKyg2O1QXaSNxKeIs+QvEX+
         iW7ttGLBDyyJPMFGy625Zh5WE8Qd9FTywVYIiOdEFZ/orN+8SwG5x+Hn1JkVz54axaIV
         nknXLhCbPAqhdk4s930ZfZWL8N0khvdAxlFNQTnHZyQwppnbfZGnlzBNQW8ybnlUcqjD
         2H1gi69hBHQ8R81MWhRVguag6uu4iHetpOsVmyqjz1xVeIyX+v6n5b0CUB19VF6uDsCN
         lznA==
X-Gm-Message-State: AGi0Pub7eJ87031m0aKdZ+Xic3l4hlwR3kfhytG07WQg+RcS5h2hTn4W
        +o3i/QnJczEZLvwpM27ypmHE9vFNE+j3FtxIxZs=
X-Google-Smtp-Source: APiQypLerMY2M7ZVjxbZ6oFIxId2KFXxVGXKFo5iP40tSyuamxV26SjR+nm0+hCu29lgocj/waDFEfrnN5wjtqINvS8=
X-Received: by 2002:ab0:2651:: with SMTP id q17mr8981737uao.18.1585958172966;
 Fri, 03 Apr 2020 16:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com> <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
 <20200130215330.f3unziderf5rlipf@ast-mbp> <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
 <20200220044505.bpfvdrcmc27ik2jp@ast-mbp>
In-Reply-To: <20200220044505.bpfvdrcmc27ik2jp@ast-mbp>
From:   Matt Cover <werekraken@gmail.com>
Date:   Fri, 3 Apr 2020 16:56:01 -0700
Message-ID: <CAGyo_hrcibFyz=b=+y=yO_yapw=TbtbO8d1vGPSLpTU0Y2gzBw@mail.gmail.com>
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 9:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Feb 05, 2020 at 11:13:55PM -0700, Matt Cover wrote:
> > On Thu, Jan 30, 2020 at 2:53 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Jan 24, 2020 at 02:46:30PM -0700, Matt Cover wrote:
> > > >
> > > > In addition to the nf_conntrack helpers, I'm hoping to add helpers for
> > > > lookups to the ipvs connection table via ip_vs_conn_in_get(). From my
> > > > perspective, this is again similar.
> > >
> > > ...
> > >
> > > > Writing to an existing nf_conn could be added to this helper in the
> > > > future. Then, as an example, an XDP program could populate ct->mark
> > > > and a restore mark rule could be used to apply the mark to the skb.
> > > > This is conceptually similar to the XDP/tc interaction example.
> > >
> > > ...
> > >
> > > > I'm planning to add a bpf_tcp_nf_conn() helper which gives access to
> > > > members of ip_ct_tcp. This is similar to bpf_tcp_sock() in my mind.
> > >
> > > ...
> > >
> > > > I touched on create and update above. Delete, like create, would
> > > > almost certainly be a separate helper. This submission is not
> > > > intended to put us on that track. I do not believe it hinders an
> > > > effort such as that either. Are you worried that adding nf_conn to
> > > > bpf is a slippery slope?
> > >
> > > Looks like there is a need to access quite a bit of ct, ipvs internal states.
> > > I bet neigh, route and other kernel internal tables will be next. The
> > > lookup/update/delete to these tables is necessary. If somebody wants to do a
> > > fast bridge in XDP they may want to reuse icmp_send(). I've seen folks
> > > reimplementing it purely on BPF side, but kernel's icmp_send() is clearly
> > > superior, so exposing it as a helper will be useful too. And so on and so
> > > forth. There are lots of kernel bits that BPF progs want to interact with.
> > >
> > > If we expose all of that via existing bpf helper mechanism we will freeze a
> > > large chunk of networking stack. I agree that accessing these data structures
> > > from BPF side is useful, but I don't think we can risk hardening the kernel so
> > > much. We need new helper mechanism that will be unstable api. It needs to be
> > > obviously unstable to both kernel developers and bpf users. Yet such mechanim
> > > should allow bpf progs accessing all these things without sacrificing safety.
> > >
> > > I think such new mechanism can be modeled similar to kernel modules and
> > > EXPORT_SYMBOL[_GPL] convention. The kernel has established policy that
> > > these function do change and in-tree kernel modules get updated along the way
> > > while out-of-tree gets broken periodically. I propose to do the same for BPF.
> > > Certain kernel functions can be marked as EXPORT_SYMBOL_BPF and they will be
> > > eligible to be called from BPF program. The verifier will do safety checks and
> > > type matching based on BTF. The same way it already does for tracing progs.
> > > For example the ct lookup can be:
> > > struct nf_conn *
> > > bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
> > >               u8 proto, u64 netns_id, u64 flags)
> > > {
> > > }
> > > EXPORT_SYMBOL_BPF(bpf_ct_lookup);
> > > The first argument 'skb' has stable api and type. It's __sk_buff and it's
> > > context for all skb-based progs, so any program that got __sk_buff from
> > > somewhere can pass it into this helper.
> > > The second argument is 'struct nf_conntrack_tuple *'. It's unstable and
> > > kernel internal. Currently the verifier recognizes it as PTR_TO_BTF_ID
> > > for tracing progs and can do the same for networking. It cannot recognize
> > > it on stack though. Like:
> > > int bpf_prog(struct __sk_buff *skb)
> > > {
> > >   struct nf_conntrack_tuple my_tupple = { ...};
> > >   bpf_ct_lookup(skb, &my_tupple, ...);
> > > }
> > > won't work yet. The verifier needs to be taught to deal with PTR_TO_BTF_ID
> > > where it points to the stack.
> > > The last three arguments are scalars and already recognized as SCALAR_VALUE by
> > > the verifier. So with minor extensions the verifier will be able to prove the
> > > safety of argument passing.
> > >
> > > The return value is trickier. It can be solved with appropriate type
> > > annotations like:
> > > struct nf_conn *
> > > bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
> > >              u8 proto, u64 netns_id, u64 flags)
> > > { ...
> > > }
> > > EXPORT_SYMBOL_BPF__acquires(bpf_ct_lookup);
> > > int bpf_ct_release(struct nf_conn * ct)
> > > { ...
> > > }
> > > EXPORT_SYMBOL_BPF__releases(bpf_ct_release);
> > > By convention the return value is acquired and the first argument is released.
> > > Then the verifier will be able to pair them the same way it does
> > > bpf_sk_lookup()/bpf_sk_release(), but in declarative way. So the verifier code
> > > doesn't need to be touched for every such function pair in the future.
> > >
> > > Note struct nf_conn and struct nf_conntrack_tuple stay kernel internal.
> > > BPF program can define fields it wants to access as:
> > > struct nf_conn {
> > >   u32 timeout;
> > >   u64 status;
> > >   u32 mark;
> > > } __attribute__((preserve_access_index));
> > > int bpf_prog()
> > > {
> > >   struct nf_conn *ct = bpf_ct_lookup(...);
> > >   if (ct) {
> > >        ct->timeout;
> > >   }
> > > }
> > > and CO-RE logic will deal with kernel specific relocations.
> > > The same way it does for tracing progs that access all kernel data.
> > >
> > > I think it's plenty obvious that such bpf helpers are unstable api. The
> > > networking programs will have access to all kernel data structures, receive
> > > them from white listed set of EXPORT_SYMBOL_BPF() functions and pass them into
> > > those functions back. Just like tracing progs that have access to everything.
> > > They can read all fields of kernel internal struct sk_buff and pass it into
> > > bpf_skb_output().
> > > The same way kernel modules can access all kernel data structures and call
> > > white listed set of EXPORT_SYMBOL() helpers.
> >
> > I think this sounds great. Looking forward to hearing what others
> > think of this proposal.
>
> No further comments typically means either no objections or lack of
> understanding :) In both cases the patches have to do the talking.

Cool. No patches yet, but a little code to show.

>
> > Presumably we want all of
> > EXPORT_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() as part of the
> > initial effort.
>
> I was thinking that _GPL suffix will be implicit. All such unstable helpers
> would require GPL license because they can appear in modules and I want to make
> sure people don't use this method as a way to extend BPF without sharing the
> code.

Implicitly requiring all bpf exported symbols to be gpl sounds
reasonable. However, _GPL suffix is to denote a GPL license
requirement on the caller (i.e. bpf prog), not the exporter. It's the
same as bpf_func_proto's gpl_only member. Stable helpers code are
all GPL, but calling some stable helpers is permitted from non-GPL
bpf prog. bpf_icmp_send is a good example of an unstable helper which
really doesn't need the calling bpf prog to be GPL license (the same
way __icmp_send permits calls from non-GPL modules).

>
> > EXPORT_SYMBOL_BPF(bpf_icmp_send);
> > EXPORT_SYMBOL_BPF__acquires(bpf_ipvs_conn_in_lookup);
> > EXPORT_SYMBOL_BPF__releases(bpf_ipvs_conn_release);
> >
> > EXPORT_SYMBOL_BPF_GPL(bpf_ct_delete);
> > EXPORT_SYMBOL_BPF_GPL__acquires(bpf_ct_lookup);
> > EXPORT_SYMBOL_BPF_GPL__releases(bpf_ct_release);
> >
> > Do we also need a __must_hold type annotation (e.g.
> > EXPORT_SYMBOL_BPF_GPL__must_hold(bpf_ct_delete))?
>
> I don't see how 'must_hold' helps safety.
> It's purely sparse annotation. What does the verifier suppose to do?

Probably a hasty question on my part. I was thinking must_hold would
mark an unstable helper as requiring the first argument be previously
acquired and not yet released.

>
> > Would we expect all
> > unstable helpers to handle being passed NULL? Or will the existing
> > verifier rule that returned values must be checked non-NULL before
> > use extend to calls of these functions even without the annotation?
>
> I think both ways will be possible.
>
> > We can optionally include
> > EXPORT_UNUSED_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() and
> > EXPORT_SYMBOL_BPF_GPL_FUTURE{,__acquires,__releases}() in the initial
> > effort, but they aren't needed for the helpers proposed so far. Given
> > that they won't be used right away, I'd just as soon leave them for a
> > follow up, when the need arises.
>
> Not sure what you mean by UNUSED and FUTURE.
> All such helpers will likely by 'unused' by the core kernel.
> Just like all existing stable bpf helpers are rarely called directly
> by the kernel code.

Good point, UNUSED makes no sense here. FUTURE denotes an exported
symbol as soon-to-be GPL only. I plan to omit them both.

>
> > In addition to reusing the EXPORT_SYMBOLS convention, I think reusing
> > the existing symvers implementation might be a reasonable choice.
>
> I don't think symvers will work, since they're lacking type info.
> I was thinking that simple BTF annotation will do the trick.
>
> > Some additional thoughts:
> > * Do we want to be able to export the exact same function to modules
> >     and bpf (i.e. without error: redefinition of '__kstrtab_xxx')?
>
> Same function to modules is already done via EXPORT_SYMBOL.
> Let's not mess with that.
>
> > * Do we want asm versions of EXPORT_SYMBOL_BPF*() (e.g. in
> >     include/asm-generic/export.h)?
>
> No. kernel's asm is typeless. bpf verifier cannot call arbitrary functions.
> It has to do type match. Otherwise we'll let bpf crash left and right.
>
> > * If a function with more than 5 parameters is exported via
> >     EXPORT_SYMBOL_BPF*(), should we have the build fail?
>
> Some kind of error is necessary. build time would be preferred, but I wouldn't
> worry about it at this point.
>
> I think doing BTF annotation for EXPORT_SYMBOL_BPF(bpf_icmp_send); is trivial.

I've been looking into this more; here is what I'm thinking.

1. Export symbols for bpf the same as modules, but into one or more
   special namespaces.

   Exported symbols recently gained namespaces.
     https://lore.kernel.org/linux-usb/20190906103235.197072-1-maennich@google.com/
     Documentation/kbuild/namespaces.rst

   This makes the in-kernel changes needed for export super simple.

     #define EXPORT_SYMBOL_BPF(sym)     EXPORT_SYMBOL_NS(sym, BPF_PROG)
     #define EXPORT_SYMBOL_BPF_GPL(sym) EXPORT_SYMBOL_NS_GPL(sym, BPF_PROG)

   BPF_PROG is our special namespace above. We can easily add
   BPF_PROG_ACQUIRES and BPF_PROG_RELEASES for those types of
   unstable helpers.

   Exports for bpf progs are then as simple as for modules.

     EXPORT_SYMBOL_BPF(bpf_icmp_send);

   Documenting these namespaces as not for use by modules should be
   enough; an explicit import statement to use namespaced symbols is
   already required. Explicitly preventing module use in
   MODULE_IMPORT_NS or modpost are also options if we feel more is
   needed.

2. Teach pahole's (dwarves') dwarf loader to parse __ksymtab*.

   I've got a functional wip which retrieves the namespace from the
   __kstrtab ELF section. Working to differentiate between __ksymtab
   and __ksymtab_gpl symbols next. Good news is this info is readily
   available in vmlinux and module .o files. The interface here will
   probably end up similar to dwarves' elf_symtab__*, but with an
   struct elf_ksymtab per __ksymtab* section (all pointing to the
   same __kstrtab section though).

3. Teach pahole's btf encoder to encode the following bools: export,
   gpl_only, acquires, releases.

   I'm envisioning this info will end up in a new struct
   btf_func_proto in btf.h. Perhaps like this.

     struct btf_func_proto {
         /* "info" bits arrangement
          * bit     0: exported (callable by bpf prog)
          * bit     1: gpl_only (only callable from GPL licensed bpf prog)
          * bit     2: acquires (acquires and returns a refcounted pointer)
          * bit     3: releases (first argument, a refcounted pointer,
is released)
          * bits 4-31: unused
          */
         __u32    info;
     };

   Currently, a "struct btf_type" of type BTF_KIND_FUNC_PROTO is
   directly followed by vlen struct btf_param/s. I'm hoping we can
   insert btf_func_proto before the first btf_param or after the
   last. If that's not workable, adding a new type,
   BTF_KIND_FUNC_EXPORT, is another idea.

4. Teach btf consumers to work with the new info.

   Haven't started looking at this yet, but I'd imagine it'll be
   straightforward once the new info has been encoded in btf.

With those items in place, we gain some cool properties for exports
to bpg programs.

  - The exporting new symbols to bpf programs will be trivial.
  - Our exports will be obvious to the kernel community at large.
  - We'll be leveraging namespaces as intended to categorize our
      exports.
  - genksyms will generate a crc to identify our exports.

The crcs could be used to improve the developer experience when
using unstable helpers.

This concept is pulled from the trace/CO-RE work; it's just like in
"Dealing with compile-time #if's in BCC".
  https://facebookmicrosites.github.io/bpf/blog/2020/02/20/bcc-to-libbpf-howto-guide.html#dealing-with-compile-time-ifs-in-bcc

I believe we can make something like this possible.

  extern uint32_t crc_of_bpf_icmp_send __kcrctab;

  switch(crc_of_bpf_icmp_send) {
      case 0x12345678:
          /* use struct/call flavors associated with 0x12345678 */
          break;
      case 0x87654321:
          /* use struct/call flavors associated with 0x87654321 */
          break;
  }

Thoughts on this export mechanism?

> The interesting implementation detail is how to do BPF_CALL_x() in a generic
> way. The BPF trampoline solved the problem of calling BPF programs from the
> kernel. It translates kernel calling convention into BPF. To do unstable
> helpers the reverse BPF trampoline is needed. It would need to translate BPF
> calling convention into kernel. The nice part that on x86-64 there is no
> reverse trampoline necessary. JITed BPF code can call arbitrary (with <=5 args)
> functions without any tricks, but other architectures are not that lucky. Hence
> infrastructure has to be done to support all archs. It's ok to have it as a nop
> for x86-64, but infra should be there from the start. Take a look at
> btf_func_model. Kernel function needs to be distilled into it and reverse BPF
> trampoline generated.

I'll keep working on this as time permits. If anyone has time to
collaborate on unstable helpers (or even answer questions as I get
familiarized with some of the deeper topics), please let me know.
