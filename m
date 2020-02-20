Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD61165660
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 05:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBTEpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 23:45:12 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39976 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgBTEpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 23:45:11 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so339513pjb.5;
        Wed, 19 Feb 2020 20:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UxzuHE6U0zeAN5jhvJL+6BCcu+Q8EGxV5wbTxPW8nBM=;
        b=lWwwUrNucuEtJ12Rt9kdnMZ+EbE/eftEWMGVBrAj5GMi8UU/ZZWuzlFb6XVAzWiyo8
         GLXHRmWNx/g+gYlqUN/HMrfI/OfNGqXJIJZNviPbh95xYZgFZB3SQuZkFfRdKzDP7NRP
         3xQJeRWphHlpgdVnT0DssR6aNgbnNhkie7l8fDfAMflaoC9ZVO/X2EURMu/slsqcAOW7
         25z4F+twI8DRqYUZUhkFg+2c128B5EVH05ULgEoFdB3Clk7ojIc9Bt9ZcUPVn2TmeLI/
         9WeL8N9ahxbCamoygutoS3JDaT51rhccP1C9QY4/elz3635OFlus0easzmsfgyfCdn1b
         sVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UxzuHE6U0zeAN5jhvJL+6BCcu+Q8EGxV5wbTxPW8nBM=;
        b=eKSf6/LvGxFLrIgfdfktNIU43KOUdtOu+nj9N3pzF7BFOOv3LcWwL/anYFftZeEZbz
         qR0TsY8X5f/6QLI7mfixVrto/J/qrX0a2IuWyOvJOCF5JTBfi1OHILeiPbnRQVqgzGtX
         LSlsWnwIrN7lZfy5+u1URGlEWp2QerDAh5BEuFyPkB3Wk4LRUuMOAC4pSGo2bEgnx4rZ
         yOPBpTuv9cvPDhYr0gMl9tbavPN/DSCHL5LP7UhRBAG1LmWpVZ36LMC+3aCG+WmzI49M
         Vuf3rESq3tJumnFM3vh8HNiJswvYm6di3pGkWndkZAvrBTe/lQ386WV4xbms2XEemNde
         Vfew==
X-Gm-Message-State: APjAAAWvryrdNdvaujhDKx2wWQKYd8DSSdFqEZOD9/mg6WxP/7ubujNC
        DNMavFIGRCdlc1JpYvGoE2g=
X-Google-Smtp-Source: APXvYqzhzPXY1Cat3F4T4h6WJHftr7qf3nzRGYz9msqvckpXynCya2MAYwNtQXA/xYj0N4P/oBlOHw==
X-Received: by 2002:a17:90a:f014:: with SMTP id bt20mr1365185pjb.31.1582173910551;
        Wed, 19 Feb 2020 20:45:10 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:3283])
        by smtp.gmail.com with ESMTPSA id x4sm1280837pff.143.2020.02.19.20.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Feb 2020 20:45:09 -0800 (PST)
Date:   Wed, 19 Feb 2020 20:45:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
Message-ID: <20200220044505.bpfvdrcmc27ik2jp@ast-mbp>
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com>
 <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
 <20200130215330.f3unziderf5rlipf@ast-mbp>
 <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 11:13:55PM -0700, Matt Cover wrote:
> On Thu, Jan 30, 2020 at 2:53 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jan 24, 2020 at 02:46:30PM -0700, Matt Cover wrote:
> > >
> > > In addition to the nf_conntrack helpers, I'm hoping to add helpers for
> > > lookups to the ipvs connection table via ip_vs_conn_in_get(). From my
> > > perspective, this is again similar.
> >
> > ...
> >
> > > Writing to an existing nf_conn could be added to this helper in the
> > > future. Then, as an example, an XDP program could populate ct->mark
> > > and a restore mark rule could be used to apply the mark to the skb.
> > > This is conceptually similar to the XDP/tc interaction example.
> >
> > ...
> >
> > > I'm planning to add a bpf_tcp_nf_conn() helper which gives access to
> > > members of ip_ct_tcp. This is similar to bpf_tcp_sock() in my mind.
> >
> > ...
> >
> > > I touched on create and update above. Delete, like create, would
> > > almost certainly be a separate helper. This submission is not
> > > intended to put us on that track. I do not believe it hinders an
> > > effort such as that either. Are you worried that adding nf_conn to
> > > bpf is a slippery slope?
> >
> > Looks like there is a need to access quite a bit of ct, ipvs internal states.
> > I bet neigh, route and other kernel internal tables will be next. The
> > lookup/update/delete to these tables is necessary. If somebody wants to do a
> > fast bridge in XDP they may want to reuse icmp_send(). I've seen folks
> > reimplementing it purely on BPF side, but kernel's icmp_send() is clearly
> > superior, so exposing it as a helper will be useful too. And so on and so
> > forth. There are lots of kernel bits that BPF progs want to interact with.
> >
> > If we expose all of that via existing bpf helper mechanism we will freeze a
> > large chunk of networking stack. I agree that accessing these data structures
> > from BPF side is useful, but I don't think we can risk hardening the kernel so
> > much. We need new helper mechanism that will be unstable api. It needs to be
> > obviously unstable to both kernel developers and bpf users. Yet such mechanim
> > should allow bpf progs accessing all these things without sacrificing safety.
> >
> > I think such new mechanism can be modeled similar to kernel modules and
> > EXPORT_SYMBOL[_GPL] convention. The kernel has established policy that
> > these function do change and in-tree kernel modules get updated along the way
> > while out-of-tree gets broken periodically. I propose to do the same for BPF.
> > Certain kernel functions can be marked as EXPORT_SYMBOL_BPF and they will be
> > eligible to be called from BPF program. The verifier will do safety checks and
> > type matching based on BTF. The same way it already does for tracing progs.
> > For example the ct lookup can be:
> > struct nf_conn *
> > bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
> >               u8 proto, u64 netns_id, u64 flags)
> > {
> > }
> > EXPORT_SYMBOL_BPF(bpf_ct_lookup);
> > The first argument 'skb' has stable api and type. It's __sk_buff and it's
> > context for all skb-based progs, so any program that got __sk_buff from
> > somewhere can pass it into this helper.
> > The second argument is 'struct nf_conntrack_tuple *'. It's unstable and
> > kernel internal. Currently the verifier recognizes it as PTR_TO_BTF_ID
> > for tracing progs and can do the same for networking. It cannot recognize
> > it on stack though. Like:
> > int bpf_prog(struct __sk_buff *skb)
> > {
> >   struct nf_conntrack_tuple my_tupple = { ...};
> >   bpf_ct_lookup(skb, &my_tupple, ...);
> > }
> > won't work yet. The verifier needs to be taught to deal with PTR_TO_BTF_ID
> > where it points to the stack.
> > The last three arguments are scalars and already recognized as SCALAR_VALUE by
> > the verifier. So with minor extensions the verifier will be able to prove the
> > safety of argument passing.
> >
> > The return value is trickier. It can be solved with appropriate type
> > annotations like:
> > struct nf_conn *
> > bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
> >              u8 proto, u64 netns_id, u64 flags)
> > { ...
> > }
> > EXPORT_SYMBOL_BPF__acquires(bpf_ct_lookup);
> > int bpf_ct_release(struct nf_conn * ct)
> > { ...
> > }
> > EXPORT_SYMBOL_BPF__releases(bpf_ct_release);
> > By convention the return value is acquired and the first argument is released.
> > Then the verifier will be able to pair them the same way it does
> > bpf_sk_lookup()/bpf_sk_release(), but in declarative way. So the verifier code
> > doesn't need to be touched for every such function pair in the future.
> >
> > Note struct nf_conn and struct nf_conntrack_tuple stay kernel internal.
> > BPF program can define fields it wants to access as:
> > struct nf_conn {
> >   u32 timeout;
> >   u64 status;
> >   u32 mark;
> > } __attribute__((preserve_access_index));
> > int bpf_prog()
> > {
> >   struct nf_conn *ct = bpf_ct_lookup(...);
> >   if (ct) {
> >        ct->timeout;
> >   }
> > }
> > and CO-RE logic will deal with kernel specific relocations.
> > The same way it does for tracing progs that access all kernel data.
> >
> > I think it's plenty obvious that such bpf helpers are unstable api. The
> > networking programs will have access to all kernel data structures, receive
> > them from white listed set of EXPORT_SYMBOL_BPF() functions and pass them into
> > those functions back. Just like tracing progs that have access to everything.
> > They can read all fields of kernel internal struct sk_buff and pass it into
> > bpf_skb_output().
> > The same way kernel modules can access all kernel data structures and call
> > white listed set of EXPORT_SYMBOL() helpers.
> 
> I think this sounds great. Looking forward to hearing what others
> think of this proposal.

No further comments typically means either no objections or lack of
understanding :) In both cases the patches have to do the talking.

> Presumably we want all of
> EXPORT_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() as part of the
> initial effort.

I was thinking that _GPL suffix will be implicit. All such unstable helpers
would require GPL license because they can appear in modules and I want to make
sure people don't use this method as a way to extend BPF without sharing the
code.

> EXPORT_SYMBOL_BPF(bpf_icmp_send);
> EXPORT_SYMBOL_BPF__acquires(bpf_ipvs_conn_in_lookup);
> EXPORT_SYMBOL_BPF__releases(bpf_ipvs_conn_release);
> 
> EXPORT_SYMBOL_BPF_GPL(bpf_ct_delete);
> EXPORT_SYMBOL_BPF_GPL__acquires(bpf_ct_lookup);
> EXPORT_SYMBOL_BPF_GPL__releases(bpf_ct_release);
> 
> Do we also need a __must_hold type annotation (e.g.
> EXPORT_SYMBOL_BPF_GPL__must_hold(bpf_ct_delete))? 

I don't see how 'must_hold' helps safety.
It's purely sparse annotation. What does the verifier suppose to do?

> Would we expect all
> unstable helpers to handle being passed NULL? Or will the existing
> verifier rule that returned values must be checked non-NULL before
> use extend to calls of these functions even without the annotation?

I think both ways will be possible.

> We can optionally include
> EXPORT_UNUSED_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() and
> EXPORT_SYMBOL_BPF_GPL_FUTURE{,__acquires,__releases}() in the initial
> effort, but they aren't needed for the helpers proposed so far. Given
> that they won't be used right away, I'd just as soon leave them for a
> follow up, when the need arises.

Not sure what you mean by UNUSED and FUTURE.
All such helpers will likely by 'unused' by the core kernel.
Just like all existing stable bpf helpers are rarely called directly
by the kernel code.

> In addition to reusing the EXPORT_SYMBOLS convention, I think reusing
> the existing symvers implementation might be a reasonable choice.

I don't think symvers will work, since they're lacking type info.
I was thinking that simple BTF annotation will do the trick.

> Some additional thoughts:
> * Do we want to be able to export the exact same function to modules
>     and bpf (i.e. without error: redefinition of '__kstrtab_xxx')?

Same function to modules is already done via EXPORT_SYMBOL.
Let's not mess with that.

> * Do we want asm versions of EXPORT_SYMBOL_BPF*() (e.g. in
>     include/asm-generic/export.h)?

No. kernel's asm is typeless. bpf verifier cannot call arbitrary functions.
It has to do type match. Otherwise we'll let bpf crash left and right.

> * If a function with more than 5 parameters is exported via
>     EXPORT_SYMBOL_BPF*(), should we have the build fail?

Some kind of error is necessary. build time would be preferred, but I wouldn't
worry about it at this point.

I think doing BTF annotation for EXPORT_SYMBOL_BPF(bpf_icmp_send); is trivial.
The interesting implementation detail is how to do BPF_CALL_x() in a generic
way. The BPF trampoline solved the problem of calling BPF programs from the
kernel. It translates kernel calling convention into BPF. To do unstable
helpers the reverse BPF trampoline is needed. It would need to translate BPF
calling convention into kernel. The nice part that on x86-64 there is no
reverse trampoline necessary. JITed BPF code can call arbitrary (with <=5 args)
functions without any tricks, but other architectures are not that lucky. Hence
infrastructure has to be done to support all archs. It's ok to have it as a nop
for x86-64, but infra should be there from the start. Take a look at
btf_func_model. Kernel function needs to be distilled into it and reverse BPF
trampoline generated.
