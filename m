Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A043B6ADE5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfGPRtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:49:43 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42981 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfGPRtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:49:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so15273208qkm.9;
        Tue, 16 Jul 2019 10:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pKgwSM3EeL3Bo+GwW3Pc2zKaKsXXRql2OFrxROP7fwY=;
        b=D1Xu+IunnwX+JxrNu5APuOhIAA2O9Fea1O80yx7T61l/GZ2Hs+n0oddYJuOyxBwUT0
         9aRKg9Qe9F0irk4nZV8DzD/sjZbFi638ct5DNkmP5kD2I9DSxJgDVLVRuEOww2zZYgVn
         07DV1qKKASIcj0QzqdVT0bZTpOV15yBnnXJGCJ+T6mCVlJmxdUvTU6aBvtWdWZdXVhe8
         m7dQh1MTsO1IrPnPXTzHrvYSXii7xjF04uxwjqbJdw9gE98dNVr1HMjrAZX6SMcEzD+W
         NMWQbA6ZJl0ZKsxpy7K0KGcepaCkCKwSExBrxgyfA2KcYrEOBjHAomy/4e/Z2Yr6wN+m
         0IBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pKgwSM3EeL3Bo+GwW3Pc2zKaKsXXRql2OFrxROP7fwY=;
        b=OI0zVJ4AQLhxJIFq2d7wKQJLBl3bUzu/Rv8vA4neE+cOTVkUoYKfklPlFtAvBtyCV/
         vhMQDjGFW5YdX5YGbWHF8f7bXdMOOm8yxnwRwl8deeRxBw3DWzn9LbGQk3QOHeCCOuzU
         OAZ+RvxvSWkec7aUpmrd+AgDaAtyI26iIv4zGXafk+hatA218mnsVSjvyNIG9UXVZnji
         D4LiXE712E44064TO6wIo/2zpnOB0lccv5PH2jVBsBcvV1L6c/Pj1xMd9dcKTKroVkci
         Ms/RdUUqefSsGJwfUgspqr8NvIi6TOcf22iE8v4FygZvTsKf7hK8ZKMTxzwkEBvUXjv5
         /ThA==
X-Gm-Message-State: APjAAAXT2OFCcRDbsq5TYYo+1SL6DYLiwayPX+/n+SSaRIVeUAH/0Dp9
        i4VfISTNNtr2GGBEZL8FNBX3T40NzqpVqOMcSTY=
X-Google-Smtp-Source: APXvYqy7Jd2sE3lV36z6Mi+CCMdt2V0zJe9kNUPVnXbDxB5NGq+rMyeJDfC7TZr9UueUtHYevuawzcEHP87XC7UP0cQ=
X-Received: by 2002:a37:660d:: with SMTP id a13mr23233038qkc.36.1563299382008;
 Tue, 16 Jul 2019 10:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
 <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com>
 <87r26w24v4.fsf@netronome.com> <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com>
 <87k1cj3b69.fsf@netronome.com> <CAEf4BzYDAVUgajz4=dRTu5xQDddp5pi2s=T1BdFmRLZjOwGypQ@mail.gmail.com>
 <87wogitlbi.fsf@netronome.com>
In-Reply-To: <87wogitlbi.fsf@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 10:49:30 -0700
Message-ID: <CAEf4BzbandXvWFAbrh-SXOgXa9=2+NkY6GG1nqX2kaSF6C4PhA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 1:50 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> Andrii Nakryiko writes:
>
> > On Mon, Jul 15, 2019 at 2:21 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> >>
> >>
> >> Andrii Nakryiko writes:
> >>
> >> > On Thu, Jul 11, 2019 at 4:22 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> >> >>
> >> >>
> >> >> Andrii Nakryiko writes:
> >> >>
> >> >> > On Thu, Jul 4, 2019 at 2:31 PM Jiong Wang <jiong.wang@netronome.com> wrote:
> >> >> >>
> >> >> >> This is an RFC based on latest bpf-next about acclerating insn patching
> >> >> >> speed, it is now near the shape of final PATCH set, and we could see the
> >> >> >> changes migrating to list patching would brings, so send out for
> >> >> >> comments. Most of the info are in cover letter. I splitted the code in a
> >> >> >> way to show API migration more easily.
> >> >> >
> >> >> >
> >> >> > Hey Jiong,
> >> >> >
> >> >> >
> >> >> > Sorry, took me a while to get to this and learn more about instruction
> >> >> > patching. Overall this looks good and I think is a good direction.
> >> >> > I'll post high-level feedback here, and some more
> >> >> > implementation-specific ones in corresponding patches.
> >> >>
> >> >> Great, thanks very much for the feedbacks. Most of your feedbacks are
> >> >> hitting those pain points I exactly had ran into. For some of them, I
> >> >> thought similar solutions like yours, but failed due to various
> >> >> reasons. Let's go through them again, I could have missed some important
> >> >> things.
> >> >>
> >> >> Please see my replies below.
> >> >
> >> > Thanks for thoughtful reply :)
> >> >
> >> >>
> >> >> >>
> >> >> >> Test Results
> >> >> >> ===
> >> >> >>   - Full pass on test_verifier/test_prog/test_prog_32 under all three
> >> >> >>     modes (interpreter, JIT, JIT with blinding).
> >> >> >>
> >> >> >>   - Benchmarking shows 10 ~ 15x faster on medium sized prog, and reduce
> >> >> >>     patching time from 5100s (nearly one and a half hour) to less than
> >> >> >>     0.5s for 1M insn patching.
> >> >> >>
> >> >> >> Known Issues
> >> >> >> ===
> >> >> >>   - The following warning is triggered when running scale test which
> >> >> >>     contains 1M insns and patching:
> >> >> >>       warning of mm/page_alloc.c:4639 __alloc_pages_nodemask+0x29e/0x330
> >> >> >>
> >> >> >>     This is caused by existing code, it can be reproduced on bpf-next
> >> >> >>     master with jit blinding enabled, then run scale unit test, it will
> >> >> >>     shown up after half an hour. After this set, patching is very fast, so
> >> >> >>     it shows up quickly.
> >> >> >>
> >> >> >>   - No line info adjustment support when doing insn delete, subprog adj
> >> >> >>     is with bug when doing insn delete as well. Generally, removal of insns
> >> >> >>     could possibly cause remove of entire line or subprog, therefore
> >> >> >>     entries of prog->aux->linfo or env->subprog needs to be deleted. I
> >> >> >>     don't have good idea and clean code for integrating this into the
> >> >> >>     linearization code at the moment, will do more experimenting,
> >> >> >>     appreciate ideas and suggestions on this.
> >> >> >
> >> >> > Is there any specific problem to detect which line info to delete? Or
> >> >> > what am I missing besides careful implementation?
> >> >>
> >> >> Mostly line info and subprog info are range info which covers a range of
> >> >> insns. Deleting insns could causing you adjusting the range or removing one
> >> >> range entirely. subprog info could be fully recalcuated during
> >> >> linearization while line info I need some careful implementation and I
> >> >> failed to have clean code for this during linearization also as said no
> >> >> unit tests to help me understand whether the code is correct or not.
> >> >>
> >> >
> >> > Ok, that's good that it's just about clean implementation. Try to
> >> > implement it as clearly as possible. Then post it here, and if it can
> >> > be improved someone (me?) will try to help to clean it up further.
> >> >
> >> > Not a big expert on line info, so can't comment on that,
> >> > unfortunately. Maybe Yonghong can chime in (cc'ed)
> >> >
> >> >
> >> >> I will described this latter, spent too much time writing the following
> >> >> reply. Might worth an separate discussion thread.
> >> >>
> >> >> >>
> >> >> >>     Insn delete doesn't happen on normal programs, for example Cilium
> >> >> >>     benchmarks, and happens rarely on test_progs, so the test coverage is
> >> >> >>     not good. That's also why this RFC have a full pass on selftest with
> >> >> >>     this known issue.
> >> >> >
> >> >> > I hope you'll add test for deletion (and w/ corresponding line info)
> >> >> > in final patch set :)
> >> >>
> >> >> Will try. Need to spend some time on BTF format.
> >> >> >
> >> >> >>
> >> >> >>   - Could further use mem pool to accelerate the speed, changes are trivial
> >> >> >>     on top of this RFC, and could be 2x extra faster. Not included in this
> >> >> >>     RFC as reducing the algo complexity from quadratic to linear of insn
> >> >> >>     number is the first step.
> >> >> >
> >> >> > Honestly, I think that would add more complexity than necessary, and I
> >> >> > think we can further speed up performance without that, see below.
> >> >> >
> >> >> >>
> >> >> >> Background
> >> >> >> ===
> >> >> >> This RFC aims to accelerate BPF insn patching speed, patching means expand
> >> >> >> one bpf insn at any offset inside bpf prog into a set of new insns, or
> >> >> >> remove insns.
> >> >> >>
> >> >> >> At the moment, insn patching is quadratic of insn number, this is due to
> >> >> >> branch targets of jump insns needs to be adjusted, and the algo used is:
> >> >> >>
> >> >> >>   for insn inside prog
> >> >> >>     patch insn + regeneate bpf prog
> >> >> >>     for insn inside new prog
> >> >> >>       adjust jump target
> >> >> >>
> >> >> >> This is causing significant time spending when a bpf prog requires large
> >> >> >> amount of patching on different insns. Benchmarking shows it could take
> >> >> >> more than half minutes to finish patching when patching number is more
> >> >> >> than 50K, and the time spent could be more than one hour when patching
> >> >> >> number is around 1M.
> >> >> >>
> >> >> >>   15000   :    3s
> >> >> >>   45000   :   29s
> >> >> >>   95000   :  125s
> >> >> >>   195000  :  712s
> >> >> >>   1000000 : 5100s
> >> >> >>
> >> >> >> This RFC introduces new patching infrastructure. Before doing insn
> >> >> >> patching, insns in bpf prog are turned into a singly linked list, insert
> >> >> >> new insns just insert new list node, delete insns just set delete flag.
> >> >> >> And finally, the list is linearized back into array, and branch target
> >> >> >> adjustment is done for all jump insns during linearization. This algo
> >> >> >> brings the time complexity from quadratic to linear of insn number.
> >> >> >>
> >> >> >> Benchmarking shows the new patching infrastructure could be 10 ~ 15x faster
> >> >> >> on medium sized prog, and for a 1M patching it reduce the time from 5100s
> >> >> >> to less than 0.5s.
> >> >> >>
> >> >> >> Patching API
> >> >> >> ===
> >> >> >> Insn patching could happen on two layers inside BPF. One is "core layer"
> >> >> >> where only BPF insns are patched. The other is "verification layer" where
> >> >> >> insns have corresponding aux info as well high level subprog info, so
> >> >> >> insn patching means aux info needs to be patched as well, and subprog info
> >> >> >> needs to be adjusted. BPF prog also has debug info associated, so line info
> >> >> >> should always be updated after insn patching.
> >> >> >>
> >> >> >> So, list creation, destroy, insert, delete is the same for both layer,
> >> >> >> but lineration is different. "verification layer" patching require extra
> >> >> >> work. Therefore the patch APIs are:
> >> >> >>
> >> >> >>    list creation:                bpf_create_list_insn
> >> >> >>    list patch:                   bpf_patch_list_insn
> >> >> >>    list pre-patch:               bpf_prepatch_list_insn
> >> >> >
> >> >> > I think pre-patch name is very confusing, until I read full
> >> >> > description I couldn't understand what it's supposed to be used for.
> >> >> > Speaking of bpf_patch_list_insn, patch is also generic enough to leave
> >> >> > me wondering whether instruction buffer is inserted after instruction,
> >> >> > or instruction is replaced with a bunch of instructions.
> >> >> >
> >> >> > So how about two more specific names:
> >> >> > bpf_patch_list_insn -> bpf_list_insn_replace (meaning replace given
> >> >> > instruction with a list of patch instructions)
> >> >> > bpf_prepatch_list_insn -> bpf_list_insn_prepend (well, I think this
> >> >> > one is pretty clear).
> >> >>
> >> >> My sense on English word is not great, will switch to above which indeed
> >> >> reads more clear.
> >> >>
> >> >> >>    list lineration (core layer): prog = bpf_linearize_list_insn(prog, list)
> >> >> >>    list lineration (veri layer): env = verifier_linearize_list_insn(env, list)
> >> >> >
> >> >> > These two functions are both quite involved, as well as share a lot of
> >> >> > common code. I'd rather have one linearize instruction, that takes env
> >> >> > as an optional parameter. If env is specified (which is the case for
> >> >> > all cases except for constant blinding pass), then adjust aux_data and
> >> >> > subprogs along the way.
> >> >>
> >> >> Two version of lineration and how to unify them was a painpoint to me. I
> >> >> thought to factor out some of the common code out, but it actually doesn't
> >> >> count much, the final size counting + insnsi resize parts are the same,
> >> >> then things start to diverge since the "Copy over insn" loop.
> >> >>
> >> >> verifier layer needs to copy and initialize aux data etc. And jump
> >> >> relocation is different. At core layer, the use case is JIT blinding which
> >> >> could expand an jump_imm insn into a and/or/jump_reg sequence, and the
> >> >
> >> > Sorry, I didn't get what "could expand an jump_imm insn into a
> >> > and/or/jump_reg sequence", maybe you can clarify if I'm missing
> >> > something.
> >> >
> >> > But from your cover letter description, core layer has no jumps at
> >> > all, while verifier has jumps inside patch buffer. So, if you support
> >> > jumps inside of patch buffer, it will automatically work for core
> >> > layer. Or what am I missing?
> >>
> >> I meant in core layer (JIT blinding), there is the following patching:
> >>
> >> input:
> >>   insn 0             insn 0
> >>   insn 1             insn 1
> >>   jmp_imm   >>       mov_imm  \
> >>   insn 2             xor_imm    insn seq expanded from jmp_imm
> >>   insn 3             jmp_reg  /
> >>                      insn 2
> >>                      insn 3
> >>
> >>
> >> jmp_imm is the insn that will be patched, and the actually transformation
> >> is to expand it into mov_imm/xor_imm/jmp_reg sequence. "jmp_reg", sitting
> >> at the end of the patch buffer, must jump to the same destination as the
> >> original jmp_imm, so "jmp_reg" is an insn inside patch buffer but should
> >> be relocated, and the jump destination is outside of patch buffer.
> >
> >
> > Ok, great, thanks for explaining, yeah it's definitely something that
> > we should be able to support. BUT. It got me thinking a bit more and I
> > think I have simpler and more elegant solution now, again, supporting
> > both core-layer and verifier-layer operations.
> >
> > struct bpf_patchable_insn {
> >    struct bpf_patchable_insn *next;
> >    struct bpf_insn insn;
> >    int orig_idx; /* original non-patched index */
> >    int new_idx;  /* new index, will be filled only during linearization */
> > };
> >
> > struct bpf_patcher {
> >     /* dummy head node of a chain of patchable instructions */
> >     struct bpf_patchable_insn insn_head;
> >     /* dynamic array of size(original instruction count)
> >      * this is a map from original instruction index to a first
> >      * patchable instruction that replaced that instruction (or
> >      * just original instruction as bpf_patchable_insn).
> >      */
> >     int *orig_idx_to_patchable_insn;
> >     int cnt;
> > };
> >
> > Few points, but it should be pretty clear just from comments and definitions:
> > 1. When you created bpf_patcher, you create patchabe_insn list, fill
> > orig_idx_to_patchable_insn map to store proper pointers. This array is
> > NEVER changed after that.
> > 2. When replacing instruction, you re-use struct bpf_patchable_insn
> > for first patched instruction, then append after that (not prepend to
> > next instruction to not disrupt orig_idx -> patchable_insn mapping).
> > 3. During linearizations, you first traverse the chain of instructions
> > and trivially assing new_idxs.
> > 4. No need for patchabe_insn->target anymore. All jumps use relative
> > instruction offsets, right?
>
> Yes, all jumps are pc-relative.
>
> > So when you need to determine new
> > instruction index during linearization, you just do (after you
> > calculated new instruction indicies):
> >
> > func adjust_jmp(struct bpf_patcher* patcher, struct bpf_patchable_insn *insn) {
> >    int old_jmp_idx = insn->orig_idx + jmp_offset_of(insn->insn);
> >    int new_jmp_idx = patcher->orig_idx_to_patchable_insn[old_jmp_idx]->new_idx;
> >    adjust_jmp_offset(insn->insn, new_jmp_idx) - insn->orig_idx;
> > }
>
> Hmm, this algo is kinds of the same this RFC, just we have organized "new_index"
> as "idx_map". And in this RFC, only new_idx of one original insn matters,
> no space is allocated for patched insns. (As mentioned, JIT blinding

It's not really about saving space. It's about having a mapping from
original index to a new one (in this case, through struct
bpf_patchable_insn *), which stays correct at all times, thus allowing
to not linearize between patching passes.


> requires the last insn inside patch buffer relocated to original jump
> offset, so there was a little special handling in the relocation loop in
> core layer linearization code)
>
> > The idea is that we want to support quick look-up by original
> > instruction index. That's what orig_idx_to_patchable_insn provides. On
> > the other hand, no existing instruction is ever referencing newly
> > patched instruction by its new offset, so with careful implementation,
> > you can transparently support all the cases, regardless if it's in
> > core layer or verifier layer (so, e.g., verifier layer patched
> > instructions now will be able to jump out of patched buffer, if
> > necessary, neat, right?).
> >
> > It is cleaner than everything we've discussed so far. Unless I missed
> > something critical (it's all quite convoluted, so I might have
> > forgotten some parts already). Let me know what you think.
>
> Let me digest a little bit and do some coding, then I will come back. Some

Sure, give it some thought and give it a go at coding, I bet overall
it will turn out more succinct and simpler. Please post an updated
version when you are done. Thanks!

> issues can only shown up during in-depth coding. I kind of feel handling
> aux reference in verifier layer is the part that will still introduce some
> un-clean code.
>
> <snip>
> >> If there is no dead insn elimination opt, then we could just adjust
> >> offsets. When there is insn deleting, I feel the logic becomes more
> >> complex. One subprog could be completely deleted or partially deleted, so
> >> I feel just recalculate the whole subprog info as a side-product is
> >> much simpler.
> >
> > What's the situation where entirety of subprog can be deleted?
>
> Suppose you have conditional jmp_imm, true path calls one subprog, false
> path calls the other. If insn walker later found it is also true, then the
> subprog at false path won't be marked as "seen", so it is entirely deleted.
>
> I actually thought it is in theory one subprog could be deleted entirely,
> so if we support insn deletion inside verifier, then range info like
> line_info/subprog_info needs to consider one range is deleted.

Seems like this is not a problem, according to Alexei. But in the
worst case, it's now simple to re-calculate all this, given that we
have this simple operation to get new insn idx by old insn idx.

>
> Thanks.
> Regards,
> Jiong
