Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CC3153E95
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 07:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgBFGOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 01:14:09 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35158 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgBFGOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 01:14:09 -0500
Received: by mail-vs1-f68.google.com with SMTP id x123so3066910vsc.2;
        Wed, 05 Feb 2020 22:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJ1xRK2EH6FSgpWP61VDZM0GCos85Ow1M35Bi0pcNFg=;
        b=jcs9oM6XUgg0R7x5FLhQA7ctWnAo5jvFRXUU4JZALp8TC6wHzSns2s1OWqe8STMDkU
         DyT22eWXaEShI6Gsg1fmwJemzCfaSDxUooLfwTLAxCGMDyAQOo0WkZjyZtH7PB05WKhv
         FLFJtFLWM6Uasp9kguxq5jSZGMM+baMWifnP6355hGkHTxJALhArrg9U5NMX7c+VIyxw
         ZyfS15dhXBl8zD9UisEbA1wKYWYU2chEeLlQSp229r8JN3VO8oA1LVAxsyk8XffiBYaT
         L57wnPo7WTCiLjY71EOSjKWynfM8lvcJQEBGGScrzBa4RN8m8MoKkwHNv7wNY6/ywHKx
         8jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJ1xRK2EH6FSgpWP61VDZM0GCos85Ow1M35Bi0pcNFg=;
        b=euMcuM29HcU3Pr+dDOaDQfeo1io4mOF9hnwn8pAdw05qGBGk68bIQfrh4g2PXIo4Cn
         12NhIY400JKnS/U3cvjFMOrmk65Hlp7hHm4SAiVl4zOcdqMIR8KROpB6jZpZjBoHHJXY
         TERH1cHENa9wRzBg/NdNbz7HaKz/e/35osBXXaPFnbaW51b1oweS87VSq5dU0EC7v48I
         ET9oBt9x5qJOrQF3DQrjuK+k5ouMSUxSgwz0BXh/Jq9OWs3VcQfQtfPxPbUUSXdBKOXN
         Df0V8Fnqytk7x7Eqco+rfzL9zWIfO4tgMA/mJa6e1yox9uueikoaMuJFTTBRCxIB7fwr
         wI8A==
X-Gm-Message-State: APjAAAWTtj/bAxsAOy22SR7DTLoW+MuuQqiPC+kZ4fb73Dax54+aiCxl
        efKybKgEY8ct4+0K0T/0aNRpDADYraf01FFUEEc=
X-Google-Smtp-Source: APXvYqyzRowKUoD6j8wEitKkMQcXefSTB4qS4b4c1ZtNed4ugOU1zp7jCAydLDEBQ2Iks7iYYnFPWzpK0e+ZL1HHdN8=
X-Received: by 2002:a67:15c7:: with SMTP id 190mr857016vsv.178.1580969646274;
 Wed, 05 Feb 2020 22:14:06 -0800 (PST)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com> <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com> <20200130215330.f3unziderf5rlipf@ast-mbp>
In-Reply-To: <20200130215330.f3unziderf5rlipf@ast-mbp>
From:   Matt Cover <werekraken@gmail.com>
Date:   Wed, 5 Feb 2020 23:13:55 -0700
Message-ID: <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 2:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 24, 2020 at 02:46:30PM -0700, Matt Cover wrote:
> >
> > In addition to the nf_conntrack helpers, I'm hoping to add helpers for
> > lookups to the ipvs connection table via ip_vs_conn_in_get(). From my
> > perspective, this is again similar.
>
> ...
>
> > Writing to an existing nf_conn could be added to this helper in the
> > future. Then, as an example, an XDP program could populate ct->mark
> > and a restore mark rule could be used to apply the mark to the skb.
> > This is conceptually similar to the XDP/tc interaction example.
>
> ...
>
> > I'm planning to add a bpf_tcp_nf_conn() helper which gives access to
> > members of ip_ct_tcp. This is similar to bpf_tcp_sock() in my mind.
>
> ...
>
> > I touched on create and update above. Delete, like create, would
> > almost certainly be a separate helper. This submission is not
> > intended to put us on that track. I do not believe it hinders an
> > effort such as that either. Are you worried that adding nf_conn to
> > bpf is a slippery slope?
>
> Looks like there is a need to access quite a bit of ct, ipvs internal states.
> I bet neigh, route and other kernel internal tables will be next. The
> lookup/update/delete to these tables is necessary. If somebody wants to do a
> fast bridge in XDP they may want to reuse icmp_send(). I've seen folks
> reimplementing it purely on BPF side, but kernel's icmp_send() is clearly
> superior, so exposing it as a helper will be useful too. And so on and so
> forth. There are lots of kernel bits that BPF progs want to interact with.
>
> If we expose all of that via existing bpf helper mechanism we will freeze a
> large chunk of networking stack. I agree that accessing these data structures
> from BPF side is useful, but I don't think we can risk hardening the kernel so
> much. We need new helper mechanism that will be unstable api. It needs to be
> obviously unstable to both kernel developers and bpf users. Yet such mechanim
> should allow bpf progs accessing all these things without sacrificing safety.
>
> I think such new mechanism can be modeled similar to kernel modules and
> EXPORT_SYMBOL[_GPL] convention. The kernel has established policy that
> these function do change and in-tree kernel modules get updated along the way
> while out-of-tree gets broken periodically. I propose to do the same for BPF.
> Certain kernel functions can be marked as EXPORT_SYMBOL_BPF and they will be
> eligible to be called from BPF program. The verifier will do safety checks and
> type matching based on BTF. The same way it already does for tracing progs.
> For example the ct lookup can be:
> struct nf_conn *
> bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
>               u8 proto, u64 netns_id, u64 flags)
> {
> }
> EXPORT_SYMBOL_BPF(bpf_ct_lookup);
> The first argument 'skb' has stable api and type. It's __sk_buff and it's
> context for all skb-based progs, so any program that got __sk_buff from
> somewhere can pass it into this helper.
> The second argument is 'struct nf_conntrack_tuple *'. It's unstable and
> kernel internal. Currently the verifier recognizes it as PTR_TO_BTF_ID
> for tracing progs and can do the same for networking. It cannot recognize
> it on stack though. Like:
> int bpf_prog(struct __sk_buff *skb)
> {
>   struct nf_conntrack_tuple my_tupple = { ...};
>   bpf_ct_lookup(skb, &my_tupple, ...);
> }
> won't work yet. The verifier needs to be taught to deal with PTR_TO_BTF_ID
> where it points to the stack.
> The last three arguments are scalars and already recognized as SCALAR_VALUE by
> the verifier. So with minor extensions the verifier will be able to prove the
> safety of argument passing.
>
> The return value is trickier. It can be solved with appropriate type
> annotations like:
> struct nf_conn *
> bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
>              u8 proto, u64 netns_id, u64 flags)
> { ...
> }
> EXPORT_SYMBOL_BPF__acquires(bpf_ct_lookup);
> int bpf_ct_release(struct nf_conn * ct)
> { ...
> }
> EXPORT_SYMBOL_BPF__releases(bpf_ct_release);
> By convention the return value is acquired and the first argument is released.
> Then the verifier will be able to pair them the same way it does
> bpf_sk_lookup()/bpf_sk_release(), but in declarative way. So the verifier code
> doesn't need to be touched for every such function pair in the future.
>
> Note struct nf_conn and struct nf_conntrack_tuple stay kernel internal.
> BPF program can define fields it wants to access as:
> struct nf_conn {
>   u32 timeout;
>   u64 status;
>   u32 mark;
> } __attribute__((preserve_access_index));
> int bpf_prog()
> {
>   struct nf_conn *ct = bpf_ct_lookup(...);
>   if (ct) {
>        ct->timeout;
>   }
> }
> and CO-RE logic will deal with kernel specific relocations.
> The same way it does for tracing progs that access all kernel data.
>
> I think it's plenty obvious that such bpf helpers are unstable api. The
> networking programs will have access to all kernel data structures, receive
> them from white listed set of EXPORT_SYMBOL_BPF() functions and pass them into
> those functions back. Just like tracing progs that have access to everything.
> They can read all fields of kernel internal struct sk_buff and pass it into
> bpf_skb_output().
> The same way kernel modules can access all kernel data structures and call
> white listed set of EXPORT_SYMBOL() helpers.

I think this sounds great. Looking forward to hearing what others
think of this proposal.

I've started looking into how the exported symbols portion of this
might look. These are just some thoughts on how we could do things
if Alexei's proposal is accepted.

Presumably we want all of
EXPORT_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() as part of the
initial effort.

EXPORT_SYMBOL_BPF(bpf_icmp_send);
EXPORT_SYMBOL_BPF__acquires(bpf_ipvs_conn_in_lookup);
EXPORT_SYMBOL_BPF__releases(bpf_ipvs_conn_release);

EXPORT_SYMBOL_BPF_GPL(bpf_ct_delete);
EXPORT_SYMBOL_BPF_GPL__acquires(bpf_ct_lookup);
EXPORT_SYMBOL_BPF_GPL__releases(bpf_ct_release);

Do we also need a __must_hold type annotation (e.g.
EXPORT_SYMBOL_BPF_GPL__must_hold(bpf_ct_delete))? Would we expect all
unstable helpers to handle being passed NULL? Or will the existing
verifier rule that returned values must be checked non-NULL before
use extend to calls of these functions even without the annotation?

We can optionally include
EXPORT_UNUSED_SYMBOL_BPF{,_GPL}{,__acquires,__releases}() and
EXPORT_SYMBOL_BPF_GPL_FUTURE{,__acquires,__releases}() in the initial
effort, but they aren't needed for the helpers proposed so far. Given
that they won't be used right away, I'd just as soon leave them for a
follow up, when the need arises.

In addition to reusing the EXPORT_SYMBOLS convention, I think reusing
the existing symvers implementation might be a reasonable choice.

Module.symvers already contains an "Export Type" field which
categorizes exported symbols. Exported symbols of each type are
placed in a separate ELF section within a module (e.g.
EXPORT_SYMBOL_GPL maps to __ksymtab_gpl). Given that bpf progs can
and often do exist as ELF files, it seems like this could work for
them as well (at least on the surface).

scripts/mod/modpost.c contains check_for_gpl_usage() and
check_for_unused() which enforce policy on how modules use exported
symbols by type (via containing section). Adding new policy (e.g.
check_for_bpf_usage()) to prevent modules from using bpf exported
symbols is one way exported symbols for modules and bpf can coexist.

We'd also need policy checking on the bpf prog side; the same
categorization mechanisms should work, but we need a util which
actually does it.

Additionally, distros can leverage symvers in the same manner for bpf
progs as is already done for modules. For example, icmpv6_send() is
in the el7 kabi whitelists; perhaps bpf_icmpv6_send() would be a
candidate for kabi whitelisting as well. Greylists can be optionally
generated and shipped with bpf progs which use unstable helpers.
Scripts which provide similar functionality for bpf progs as
/sbin/weak-modules does for modules could be added. Even with
existing el7 kernel rpms (including variants like kernel-ml),
/etc/kernel/p{ostinst,rerm}.d can be used to run a "weak-bpf-progs"
on install/removal. Point is a lot of distro conventions could be
reused; el7 is just a concrete example.

Some additional thoughts:
* Do we want to be able to export the exact same function to modules
    and bpf (i.e. without error: redefinition of '__kstrtab_xxx')?
* Do we want asm versions of EXPORT_SYMBOL_BPF*() (e.g. in
    include/asm-generic/export.h)?
* If a function with more than 5 parameters is exported via
    EXPORT_SYMBOL_BPF*(), should we have the build fail?
