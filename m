Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F88D68638
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfGOJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:22:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54461 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfGOJWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:22:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so14355761wme.4
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 02:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=GoRhmkbjLzpojd246Bcqtxk5gu2MXuopT4PrS5lzH18=;
        b=dHg6JBhGxnOfeP59a/a727/UEuzHpEB4ytFKAlcxYt4o0oE7Dm9yk0yPbtQxuNDCJW
         4z+y6FLMnwhf7yjyluveCTlEQdj+B0mACk3BsyBO9v3HKUVFt7SVu5jp5hlmME2DpeY9
         ZXP518/dbGfCn1GRN0fcQpXgLHoX4lY3MJatH9t6rOnAcLM3h66Hy1tdMeIuGNfgHWyi
         lyulY6tZyHHSi/w/8s7WdVxiYLKth0H6r4Q+1ZE/+lrsAwilKqVEoqKC28QKmaJhbMb6
         RaVdLvRoOEtOPAkuxueKyRnfApfZ4/XYpX+khP97fJ2lX0vvYnWCvecYHnBBrnhaP7Ra
         IuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=GoRhmkbjLzpojd246Bcqtxk5gu2MXuopT4PrS5lzH18=;
        b=XxPLtmdNTi0yWSU8i6D8RW4alTPLiJo1CVchstBYfxHrlkJQapVwrrHAVQ8azp9+o3
         x0XQDAM68x8DKhSuhNU0lg0Eed4vW42n2nf0hCLEO7usmFf1o1A6MQb+4oxs8GI4bKeA
         uhP8WHSFnxIyyu7UpHiDch35v+oHNCcWepbHjqGjD/lLqTIPmzclv2k/svOVxdkIYKf3
         4nA2HxK77tCzBO89Usws0EEX2ywc0IMT3K7js7JkPTdnd6gwV6Jm/RD2CjvUBx5/1e/A
         0d9oA2KgV5MBoPM6R28j4jVT3mVahvMz6pVWiQrrW5a/woCpdF3+34+brsKSAvgIy0J/
         egnQ==
X-Gm-Message-State: APjAAAVi4+8lXJgfcf4bxdT2mdww3R1Fo6ivjEgpXKbLxB6EW/pRBvVs
        lXMw5DRr/JheF0M4SbS9G6jlkw==
X-Google-Smtp-Source: APXvYqzGx2O8qSmg7lZxrILeax7ltKkthyfvSWUzyCMKOjtSpC5T4KxuaGOWpNOm4o9R45z1unb3HQ==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr23166302wmg.65.1563182515563;
        Mon, 15 Jul 2019 02:21:55 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id d10sm19045873wro.18.2019.07.15.02.21.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 02:21:54 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com> <87r26w24v4.fsf@netronome.com> <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
In-reply-to: <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com>
Date:   Mon, 15 Jul 2019 10:21:50 +0100
Message-ID: <87k1cj3b69.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko writes:

> On Thu, Jul 11, 2019 at 4:22 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>>
>> Andrii Nakryiko writes:
>>
>> > On Thu, Jul 4, 2019 at 2:31 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>> >>
>> >> This is an RFC based on latest bpf-next about acclerating insn patching
>> >> speed, it is now near the shape of final PATCH set, and we could see the
>> >> changes migrating to list patching would brings, so send out for
>> >> comments. Most of the info are in cover letter. I splitted the code in a
>> >> way to show API migration more easily.
>> >
>> >
>> > Hey Jiong,
>> >
>> >
>> > Sorry, took me a while to get to this and learn more about instruction
>> > patching. Overall this looks good and I think is a good direction.
>> > I'll post high-level feedback here, and some more
>> > implementation-specific ones in corresponding patches.
>>
>> Great, thanks very much for the feedbacks. Most of your feedbacks are
>> hitting those pain points I exactly had ran into. For some of them, I
>> thought similar solutions like yours, but failed due to various
>> reasons. Let's go through them again, I could have missed some important
>> things.
>>
>> Please see my replies below.
>
> Thanks for thoughtful reply :)
>
>>
>> >>
>> >> Test Results
>> >> ===
>> >>   - Full pass on test_verifier/test_prog/test_prog_32 under all three
>> >>     modes (interpreter, JIT, JIT with blinding).
>> >>
>> >>   - Benchmarking shows 10 ~ 15x faster on medium sized prog, and reduce
>> >>     patching time from 5100s (nearly one and a half hour) to less than
>> >>     0.5s for 1M insn patching.
>> >>
>> >> Known Issues
>> >> ===
>> >>   - The following warning is triggered when running scale test which
>> >>     contains 1M insns and patching:
>> >>       warning of mm/page_alloc.c:4639 __alloc_pages_nodemask+0x29e/0x330
>> >>
>> >>     This is caused by existing code, it can be reproduced on bpf-next
>> >>     master with jit blinding enabled, then run scale unit test, it will
>> >>     shown up after half an hour. After this set, patching is very fast, so
>> >>     it shows up quickly.
>> >>
>> >>   - No line info adjustment support when doing insn delete, subprog adj
>> >>     is with bug when doing insn delete as well. Generally, removal of insns
>> >>     could possibly cause remove of entire line or subprog, therefore
>> >>     entries of prog->aux->linfo or env->subprog needs to be deleted. I
>> >>     don't have good idea and clean code for integrating this into the
>> >>     linearization code at the moment, will do more experimenting,
>> >>     appreciate ideas and suggestions on this.
>> >
>> > Is there any specific problem to detect which line info to delete? Or
>> > what am I missing besides careful implementation?
>>
>> Mostly line info and subprog info are range info which covers a range of
>> insns. Deleting insns could causing you adjusting the range or removing one
>> range entirely. subprog info could be fully recalcuated during
>> linearization while line info I need some careful implementation and I
>> failed to have clean code for this during linearization also as said no
>> unit tests to help me understand whether the code is correct or not.
>>
>
> Ok, that's good that it's just about clean implementation. Try to
> implement it as clearly as possible. Then post it here, and if it can
> be improved someone (me?) will try to help to clean it up further.
>
> Not a big expert on line info, so can't comment on that,
> unfortunately. Maybe Yonghong can chime in (cc'ed)
>
>
>> I will described this latter, spent too much time writing the following
>> reply. Might worth an separate discussion thread.
>>
>> >>
>> >>     Insn delete doesn't happen on normal programs, for example Cilium
>> >>     benchmarks, and happens rarely on test_progs, so the test coverage is
>> >>     not good. That's also why this RFC have a full pass on selftest with
>> >>     this known issue.
>> >
>> > I hope you'll add test for deletion (and w/ corresponding line info)
>> > in final patch set :)
>>
>> Will try. Need to spend some time on BTF format.
>> >
>> >>
>> >>   - Could further use mem pool to accelerate the speed, changes are trivial
>> >>     on top of this RFC, and could be 2x extra faster. Not included in this
>> >>     RFC as reducing the algo complexity from quadratic to linear of insn
>> >>     number is the first step.
>> >
>> > Honestly, I think that would add more complexity than necessary, and I
>> > think we can further speed up performance without that, see below.
>> >
>> >>
>> >> Background
>> >> ===
>> >> This RFC aims to accelerate BPF insn patching speed, patching means expand
>> >> one bpf insn at any offset inside bpf prog into a set of new insns, or
>> >> remove insns.
>> >>
>> >> At the moment, insn patching is quadratic of insn number, this is due to
>> >> branch targets of jump insns needs to be adjusted, and the algo used is:
>> >>
>> >>   for insn inside prog
>> >>     patch insn + regeneate bpf prog
>> >>     for insn inside new prog
>> >>       adjust jump target
>> >>
>> >> This is causing significant time spending when a bpf prog requires large
>> >> amount of patching on different insns. Benchmarking shows it could take
>> >> more than half minutes to finish patching when patching number is more
>> >> than 50K, and the time spent could be more than one hour when patching
>> >> number is around 1M.
>> >>
>> >>   15000   :    3s
>> >>   45000   :   29s
>> >>   95000   :  125s
>> >>   195000  :  712s
>> >>   1000000 : 5100s
>> >>
>> >> This RFC introduces new patching infrastructure. Before doing insn
>> >> patching, insns in bpf prog are turned into a singly linked list, insert
>> >> new insns just insert new list node, delete insns just set delete flag.
>> >> And finally, the list is linearized back into array, and branch target
>> >> adjustment is done for all jump insns during linearization. This algo
>> >> brings the time complexity from quadratic to linear of insn number.
>> >>
>> >> Benchmarking shows the new patching infrastructure could be 10 ~ 15x faster
>> >> on medium sized prog, and for a 1M patching it reduce the time from 5100s
>> >> to less than 0.5s.
>> >>
>> >> Patching API
>> >> ===
>> >> Insn patching could happen on two layers inside BPF. One is "core layer"
>> >> where only BPF insns are patched. The other is "verification layer" where
>> >> insns have corresponding aux info as well high level subprog info, so
>> >> insn patching means aux info needs to be patched as well, and subprog info
>> >> needs to be adjusted. BPF prog also has debug info associated, so line info
>> >> should always be updated after insn patching.
>> >>
>> >> So, list creation, destroy, insert, delete is the same for both layer,
>> >> but lineration is different. "verification layer" patching require extra
>> >> work. Therefore the patch APIs are:
>> >>
>> >>    list creation:                bpf_create_list_insn
>> >>    list patch:                   bpf_patch_list_insn
>> >>    list pre-patch:               bpf_prepatch_list_insn
>> >
>> > I think pre-patch name is very confusing, until I read full
>> > description I couldn't understand what it's supposed to be used for.
>> > Speaking of bpf_patch_list_insn, patch is also generic enough to leave
>> > me wondering whether instruction buffer is inserted after instruction,
>> > or instruction is replaced with a bunch of instructions.
>> >
>> > So how about two more specific names:
>> > bpf_patch_list_insn -> bpf_list_insn_replace (meaning replace given
>> > instruction with a list of patch instructions)
>> > bpf_prepatch_list_insn -> bpf_list_insn_prepend (well, I think this
>> > one is pretty clear).
>>
>> My sense on English word is not great, will switch to above which indeed
>> reads more clear.
>>
>> >>    list lineration (core layer): prog = bpf_linearize_list_insn(prog, list)
>> >>    list lineration (veri layer): env = verifier_linearize_list_insn(env, list)
>> >
>> > These two functions are both quite involved, as well as share a lot of
>> > common code. I'd rather have one linearize instruction, that takes env
>> > as an optional parameter. If env is specified (which is the case for
>> > all cases except for constant blinding pass), then adjust aux_data and
>> > subprogs along the way.
>>
>> Two version of lineration and how to unify them was a painpoint to me. I
>> thought to factor out some of the common code out, but it actually doesn't
>> count much, the final size counting + insnsi resize parts are the same,
>> then things start to diverge since the "Copy over insn" loop.
>>
>> verifier layer needs to copy and initialize aux data etc. And jump
>> relocation is different. At core layer, the use case is JIT blinding which
>> could expand an jump_imm insn into a and/or/jump_reg sequence, and the
>
> Sorry, I didn't get what "could expand an jump_imm insn into a
> and/or/jump_reg sequence", maybe you can clarify if I'm missing
> something.
>
> But from your cover letter description, core layer has no jumps at
> all, while verifier has jumps inside patch buffer. So, if you support
> jumps inside of patch buffer, it will automatically work for core
> layer. Or what am I missing?

I meant in core layer (JIT blinding), there is the following patching:

input:
  insn 0             insn 0
  insn 1             insn 1
  jmp_imm   >>       mov_imm  \
  insn 2             xor_imm    insn seq expanded from jmp_imm
  insn 3             jmp_reg  /
                     insn 2
                     insn 3


jmp_imm is the insn that will be patched, and the actually transformation
is to expand it into mov_imm/xor_imm/jmp_reg sequence. "jmp_reg", sitting
at the end of the patch buffer, must jump to the same destination as the
original jmp_imm, so "jmp_reg" is an insn inside patch buffer but should
be relocated, and the jump destination is outside of patch buffer.

This means for core layer (jit blinding), it needs to take care of insn
inside patch buffer.
  
> Just compared two version of linearize side by side. From what I can
> see, unified version could look like this, high-level:
>
> 1. Count final insn count (but see my other suggestions how to avoid
> that altogether). If not changed - exit.
> 2. Realloc insn buffer, copy just instructions (not aux_data yet).
> Build idx_map, if necessary.
> 3. (if env) then bpf_patchable_insn has aux_data, so now do another
> pass and copy it into resulting array.
> 4. (if env) Copy sub info. Though I'd see if we can just reuse old
> ones and just adjust offsets. I'm not sure why we need to allocate new
> array, subprogram count shouldn't change, right?

If there is no dead insn elimination opt, then we could just adjust
offsets. When there is insn deleting, I feel the logic becomes more
complex. One subprog could be completely deleted or partially deleted, so
I feel just recalculate the whole subprog info as a side-product is
much simpler.

> 5. (common) Relocate jumps. Not clear why core layer doesn't care
> about PATCHED (or, alternatively, why verifier layer cares).

See above, in this RFC, core layer care PATCHED during relocating jumps,
and verifier layer doesn't.

> And again, with targets pointer it will look totally different (and
> simpler).

Yes, will see how the code looks.

> 6. (if env) adjust subprogs
> 7. (common) Adjust prog's line info.
>
> The devil is in the details, but I think this will still be better if
> contained in one function if a bunch of `if (env)` checks. Still
> pretty linear.
>
>> jump_reg is at the end of the patch buffer, it should be relocated. While
>> all use case in verifier layer, no jump in the prog will be patched and all
>> new jumps in patch buffer will jump inside the buffer locally so no need to
>> resolve.
>>
>> And yes we could unify them into one and control the diverge using
>> argument, but then where to place the function is an issue. My
>> understanding is verifier.c is designed to be on top of core.c and core.c
>> should not reference and no need to be aware of any verifier specific data
>> structures, for example env or bpf_aux_insn_data etc.
>
> Func prototype where it is. Maybe forward-declare verifier env struct.
> Implementation in verifier.c?
>
>>
>> So, in this RFC, I had choosed to write separate linerization function for
>> core and verifier layer. Does this make sense?
>
> See above. Let's still try to make it better.
>
>>
>> >
>> > This would keep logic less duplicated and shouldn't complexity beyond
>> > few null checks in few places.
>> >
>> >>    list destroy:                 bpf_destroy_list_insn
>> >>
>> >
>> > I'd also add a macro foreach_list_insn instead of explicit for loops
>> > in multiple places. That would also allow to skip deleted instructions
>> > transparently.
>> >
>> >> list patch could change the insn at patch point, it will invalid the aux
>> >
>> > typo: invalid -> invalidate
>>
>> Ack.
>>
>> >
>> >> info at patching point. list pre-patch insert new insns before patch point
>> >> where the insn and associated aux info are not touched, it is used for
>> >> example in convert_ctx_access when generating prologue.
>> >>
>> >> Typical API sequence for one patching pass:
>> >>
>> >>    struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
>> >>    for (elem = list; elem; elem = elem->next)
>> >>       patch_buf = gen_patch_buf_logic;
>> >>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>> >>    bpf_prog = bpf_linearize_list_insn(list)
>> >>    bpf_destroy_list_insn(list)
>> >>
>> >> Several patching passes could also share the same list:
>> >>
>> >>    struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
>> >>    for (elem = list; elem; elem = elem->next)
>> >>       patch_buf = gen_patch_buf_logic1;
>> >>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>> >>    for (elem = list; elem; elem = elem->next)
>> >>       patch_buf = gen_patch_buf_logic2;
>> >>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>> >>    bpf_prog = bpf_linearize_list_insn(list)
>> >>    bpf_destroy_list_insn(list)
>> >>
>> >> but note new inserted insns int early passes won't have aux info except
>> >> zext info. So, if one patch pass requires all aux info updated and
>> >> recalculated for all insns including those pathced, it should first
>> >> linearize the old list, then re-create the list. The RFC always create and
>> >> linearize the list for each migrated patching pass separately.
>> >
>> > I think we should do just one list creation, few passes of patching
>> > and then linearize once. That will save quite a lot of memory
>> > allocation and will speed up a lot of things. All the verifier
>> > patching happens one after the other without any other functionality
>> > in between, so there shouldn't be any problem.
>>
>> Yes, as mentioned above, it is possible and I had tried to do it in an very
>> initial impl. IIRC convert_ctx_access + fixup_bpf_calls could share the
>> same list, but then the 32-bit zero extension insertion pass requires
>> aux.zext_dst set properly for all instructions including those patched
>
> So zext_dst. Seems like it's easily calculatable, so doesn't seem like
> it even needs to be accessed from aux_data.
>
> But. I can see at least two ways to do this:
> 1. those patching passes that care about aux_data, should just do
> extra check for NULL. Because when we adjust insns now, we just leave
> zero-initialized aux_data, except for zext_dst and seen. So it's easy
> to default to them if aux_data is NULL for patchable_insn.
> 2. just allocate and fill them out them when applying patch insns
> buffer. It's not a duplication, we already fill them out during
> patching today. So just do the same, except through malloc()'ed
> pointer instead. At the end they will be copied into linear resulting
> array during linearization (uniformly with non-patched insns).
>
>> one which we need to linearize the list first (as we set zext_dst during
>> linerization), or the other choice is we do the zext_dst initialization
>> during bpf_patch_list_insn, but this then make bpf_patch_list_insn diverge
>> between core and verifier layer.
>
> List construction is much simpler, even if we have to have extra
> check, similar to `if (env) { do_extra(); }`, IMO, it's fine.
>
>>
>> > As for aux_data. We can solve that even more simply and reliably by
>> > storing a pointer along the struct bpf_list_insn
>>
>> This is exactly what I had implemented initially, but then the issue is how
>> to handle aux_data for patched insn? IIRC I was leave it as a NULL pointer,
>> but later found zext_dst info is required for all insns, so I end up
>> duplicating zext_dst in bpf_list_insn.
>
> See above. No duplication. You have a pointer. Whether aux_data is in
> original array or was malloc()'ed, doesn't matter. But no duplication
> of fields.
>
>>
>> This leads me worrying we need to keep duplicating fields there as soon as
>> there is new similar requirements in future patching pass and I thought it
>> might be better to just reference the aux_data inside env using orig_idx,
>> this avoids duplicating information, but we need to make sure used fields
>> inside aux_data for patched insn update-to-date during linearization or
>> patching list.
>>
>> > (btw, how about calling it bpf_patchable_insn?).
>>
>> No preference, will use this one.
>>
>> > Here's how I propose to represent this patchable instruction:
>> >
>> > struct bpf_list_insn {
>> >        struct bpf_insn insn;
>> >        struct bpf_list_insn *next;
>> >        struct bpf_list_insn *target;
>> >        struct bpf_insn_aux_data *aux_data;
>> >        s32 orig_idx; // can repurpose this to have three meanings:
>> >                      // -2 - deleted
>> >                      // -1 - patched/inserted insn
>> >                      // >=0 - original idx
>>
>> I actually had experimented the -2/-1/0 trick, exactly the same number
>> assignment :) IIRC the code was not clear compared with using flag, the
>> reason seems to be:
>>   1. we still need orig_idx of an patched insn somehow, meaning negate the
>>      index.
>
> Not following, original index with be >=0, no?
>
>>   2. somehow somecode need to know whether one insn is deleted or patched
>>      after the negation, so I end up with some ugly code.
>
> So that's why you'll have constants with descriptive name for -2 and -1.
>
>>
>> Anyway, I might had not thought hard enough on this, I will retry using the
>> special index instead of flag, hopefully I could have clean code this time.
>>
>
> Yeah, please try again. All those `orig_idx = insn->orig_idx - 1; if
> (orig_idx >= 0) { ... }` are very confusing.
>
>> > };
>> >
>> > The idea would be as follows:
>> > 1. when creating original list, target pointer will point directly to
>> > a patchable instruction wrapper for jumps/calls. This will allow to
>> > stop tracking and re-calculating jump offsets and instruction indicies
>> > until linearization.
>>
>> Not sure I have followed the idea of "target" pointer. At the moment we are
>> using index mapping array (generated as by-product during coping insn).
>>
>> While the "target" pointer means to during list initialization, each jump
>> insn will have target initialized to the list node of the converted jump
>> destination insn, and all those non-jump insns are with NULL? Then during
>> linearization you assign index to each list node (could be done as
>> by-product of other pass) before insn coping which could then relocate the
>> insn during the coping as the "target" would have final index calculated?
>> Am I following correctly?
>
> Yes, I think you are understanding correctly what I'm saying. For
> implementation, you can do it in few ways, through few passes or with
> some additional data, is less important. See what's cleanest.
>
>>
>> > 2. aux_data is also filled at that point. Later at linearization time
>> > you'd just iterate over all the instructions in final order and copy
>> > original aux_data, if it's present. And then just repace env's
>> > aux_data array at the end, should be very simple and fast.
>>
>> As explained, I am worried making aux_data a pointer will causing
>> duplicating some fields into list_insn if the fields are required for
>> patched insns.
>
> Addressed above, I don't think there will be any duplication, because
> we pass aux_data by pointer.
>
>>
>> > 3. during fix_bpf_calls, zext, ctx rewrite passes, we'll reuse the
>> > same list of instructions and those passes will just keep inserting
>> > instruction buffers. Given we have restriction that all the jumps are
>> > only within patch buffer, it will be trivial to construct proper
>> > patchable instruction wrappers for newly added instructions, with NULL
>> > for aux_data and possibly non-NULL target (if it's a JMP insn).
>> > 4. After those passes, linearize, adjust subprogs (for this you'll
>> > probably still need to create index mapping, right?), copy or create
>> > new aux_data.
>> > 5. Done.
>> >
>> > What do you think? I think this should be overall simpler and faster.
>> > But let me know if I'm missing something.
>>
>> Thanks for all these thoughts, they are very good suggestions and reminds
>> me to revisit some points I had forgotten. I will do the following things:
>>
>>   1. retry the negative index solution to eliminate flag if the result code
>>      could be clean.
>>   2. the "target" pointer seems make sense, it makes list_insn bigger but
>>      normally space trade with time, so I will try to implement it to see
>>      how the code looks like.
>>   3. I still have concerns on making aux_data as pointer. Mostly due to
>>      patched insn will have NULL pointer and in case aux info of patched
>>      insn is required, we need to duplicate info inside list_insn. For
>>      example 32-bit zext opt requires zext_dst.
>>
>
>
> So one more thing I wanted to suggest. I'll try to keep high-level
> suggestions here.
>
> What about having a wrapper for patchable_insn list, where you can
> store some additional data, like final count and whatever else. It
> will eliminate some passes (counting) and will make list handling
> easier (because you can have a dummy head pointer, so no special
> handling of first element

Will try it.

> you had this concern in patch #1, I
> believe). But it will be clear if it's beneficial once implemented.

>> Regards,
>> Jiong
>>
>> >>
>> >> Compared with old patching code, this new infrastructure has much less core
>> >> code, even though the final code has a couple of extra lines but that is
>> >> mostly due to for list based infrastructure, we need to do more error
>> >> checks, so the list and associated aux data structure could be freed when
>> >> errors happens.
>> >>
>> >> Patching Restrictions
>> >> ===
>> >>   - For core layer, the linearization assume no new jumps inside patch buf.
>> >>     Currently, the only user of this layer is jit blinding.
>> >>   - For verifier layer, there could be new jumps inside patch buf, but
>> >>     they should have branch target resolved themselves, meaning new jumps
>> >>     doesn't jump to insns out of the patch buf. This is the case for all
>> >>     existing verifier layer users.
>> >>   - bpf_insn_aux_data for all patched insns including the one at patch
>> >>     point are invalidated, only 32-bit zext info will be recalcuated.
>> >>     If the aux data of insn at patch point needs to be retained, it is
>> >>     purely insn insertion, so need to use the pre-patch API.
>> >>
>> >> I plan to send out a PATCH set once I finished insn deletion line info adj
>> >> support, please have a looks at this RFC, and appreciate feedbacks.
>> >>
>> >> Jiong Wang (8):
>> >>   bpf: introducing list based insn patching infra to core layer
>> >>   bpf: extend list based insn patching infra to verification layer
>> >>   bpf: migrate jit blinding to list patching infra
>> >>   bpf: migrate convert_ctx_accesses to list patching infra
>> >>   bpf: migrate fixup_bpf_calls to list patching infra
>> >>   bpf: migrate zero extension opt to list patching infra
>> >>   bpf: migrate insn remove to list patching infra
>> >>   bpf: delete all those code around old insn patching infrastructure
>> >>
>> >>  include/linux/bpf_verifier.h |   1 -
>> >>  include/linux/filter.h       |  27 +-
>> >>  kernel/bpf/core.c            | 431 +++++++++++++++++-----------
>> >>  kernel/bpf/verifier.c        | 649 +++++++++++++++++++------------------------
>> >>  4 files changed, 580 insertions(+), 528 deletions(-)
>> >>
>> >> --
>> >> 2.7.4
>> >>
>>

