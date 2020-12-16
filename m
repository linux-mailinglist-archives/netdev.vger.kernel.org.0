Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887F02DC8F3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLPW2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgLPW2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:28:15 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E670C06179C;
        Wed, 16 Dec 2020 14:27:35 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id j17so23957912ybt.9;
        Wed, 16 Dec 2020 14:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zn+y5rxLFp9fVLZF1TfCNe3/0vVW9B6mpSZszzK8qWs=;
        b=Tmyl0PJ1iWhlw09zIgknWiiYN6KOcV9n2IBwg7cCLyX71VwhCyvfPuyaQQKFd0lmMH
         L5r1Q/tL7k8Kg3vc8Z5peY5OOflnFpiDbUy0wfxg+ix9ajB16D/FssumfplXG2J7JP1t
         IyaDZFLIpHDoyjTqiQMs8+QuPGag8FIHIUxzu0I3zWM9aikefgyyeQAiI1EA6TrU5pxG
         Wqsxu/M0OKxjqvi9yhvx+LPHHrb15QnqZxKIZjNhr01hSRQLI2epo0FeBtcZpLeQDRkl
         K9/ajJLS39UwVlm8DcdCosC1Q80iXANPxzPXnyWsSQEE46FNbAbLZjF5JSEHXwLYmgWo
         cUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zn+y5rxLFp9fVLZF1TfCNe3/0vVW9B6mpSZszzK8qWs=;
        b=Lu3h43Bw7T53+JsvkdBWL04fyGNQWPOdLt5YgH/teDOXyDw+3wxBiSXyeyTsXztpnc
         nPWepUAMU4LN3nCwt1wy6vlLqFPZ0PAQeq19TuVi539PkJsH9b5nEkGnyRQ1pKLWiK8A
         9meIazW1qSFluJd7FDDmBEe+oPOMTnPsaC0RBiLjLuvTTMwNcw4Z6dHdp67+sItnmz02
         DTGvb+ZpbRvRHlnBJ944Vp6AU+6IbgcIX9WwjzLuIRp27dWFE+fFBdo2dW41LxLd0BR5
         SPPBzbc5k85vcbAWlmzI1QpVy3Cexwx0Cz5lMxRAlBld6kJHxajMCt/Kn9hlNqBB5a3z
         ftDg==
X-Gm-Message-State: AOAM532Z51BygeGAZdlnm8XQb76PAdID6AbSaDCgwzZb3qZ5mNnKOn3r
        UEBFJNuPWG/1YQqY7UiZqmf49zMh5xDr0h/1l5Q=
X-Google-Smtp-Source: ABdhPJzxwMvZ8FlYjgudBiLyboC+R/R4mRETDuDN2EWoss+YP3X6WfnFdkL9WGKdFjfAGFeOD6HjzeaQBZPapaZkw8s=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr50555701ybg.27.1608157654717;
 Wed, 16 Dec 2020 14:27:34 -0800 (PST)
MIME-Version: 1.0
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost>
 <20201208031206.26mpjdbrvqljj7vl@ast-mbp> <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
 <alpine.LRH.2.23.451.2012082202450.25628@localhost> <20201208233920.qgrluwoafckvq476@ast-mbp>
 <alpine.LRH.2.23.451.2012092308240.26400@localhost> <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
 <alpine.LRH.2.23.451.2012161457030.27611@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2012161457030.27611@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 14:27:23 -0800
Message-ID: <CAEf4BzZ0_iGqnzqz3qAEggdTRhXkddtdYRUgs0XxibUyA_KH3w@mail.gmail.com>
Subject: Re: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support
 module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 8:18 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Tue, 15 Dec 2020, Alexei Starovoitov wrote:
>
> > On Wed, Dec 09, 2020 at 11:21:43PM +0000, Alan Maguire wrote:
> > > Right, that's exactly it.  A pair of generic tracing BPF programs are
> > > used, and they attach to kprobe/kretprobes, and when they run they
> > > use the arguments plus the map details about BTF ids of those arguments to
> > > run bpf_snprintf_btf(), and send perf events to userspace containing the
> > > results.
> > ...
> > > That would be fantastic! We could do that from the context passed into a
> > > kprobe program as the IP in struct pt_regs points at the function.
> > > kretprobes seems a bit trickier as in that case the IP in struct pt_regs is
> > > actually set to kretprobe_trampoline rather than the function we're
> > > returning from due to how kretprobes work; maybe there's another way to get
> > > it in that case though..
> >
> > Yeah. kprobe's IP doesn't match kretprobe's IP which makes such tracing
> > use cases more complicated. Also kretprobe is quite slow. See
> > prog_tests/test_overhead and selftests/bpf/bench.
> > I think the key realization is that the user space knows all IPs
> > it will attach to. It has to know all IPs otherwise
> > hashmap{key=ip, value=btf_data} is not possible.
> > Obvious, right ? What it means that we can use this key observation
> > to build better interfaces at all layers. kprobes are slow to
> > setup one by one. It's also slow to execute. fentry/fexit is slow
> > to setup, but fast to execute. Jiri proposed a batching api for
> > fentry, but it doesn't quite make sense from api perspective
> > since user space has to give different bpf prog for every fentry.
> > bpf trampoline is unique for every target fentry kernel function.
> > The batched attach would make sense for kprobe because one prog
> > can be attached everywhere. But kprobe is slow.
> > This thought process justifies an addition of a new program
> > type where one program can attach to multiple fentry.
> > Since fentry ctx is no longer fixed the verifier won't be able to
> > track btf_id-s of arguments, but btf based pointer walking is fast
> > and powerful, so if btf is passed into the program there could
> > be a helper that does dynamic cast from long to PTR_TO_BTF_ID.
> > Since such new fentry prog will have btf in the context and
> > there will be no need for user space to populate hashmap and
> > mess with IPs. And the best part that batched attach will not
> > only be desired, but mandatory part of the api.
> > So I'm proposing to extend BPF_PROG_LOAD cmd with an array of
> > pairs (attach_obj_fd, attach_btf_id).

Beyond knowing its attach btf_id, such BPF programs probably need to
store some additional application-specific data per each attached
function, so if we can extend this to also accept an arbitrary long,
in addition to fd+id, that would be great. It can be used as an array
index for some extra configuration, or to correlate fentry with fexit,
etc, etc. No need for an arbitrary amount of data, one long is enough
to then use other means to get to arbitrary program data.

> > The fentry prog in .c file might even have a regex in attach pattern:
> > SEC("fentry/sys_*")
> > int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1,
> >              __u64 arg2, ...__u64 arg6)

So I like the overall idea, but I'm going to nitpick on some details :)

This still looks, feels and behaves like fentry/fexit program, so
hopefully it won't be really an entirely new type of BPF program (at
least from user-space point of view).

Also, not a big fan of having struct btf * and separate btf_id. Maybe
we can just abstract it into an opaque (or not opaque) struct
representing fully-qualified BTF type. Further, if instead of passing
it as an input argument, we can just have an BPF helper to return
this, it would be even better and could be actually generalized to
other BTF-powered BPF programs. So something like:

struct btf_type_id *id = bpf_get_btf_type_id(ctx);

...

.type_id = id->type_id;
.btf_obj = id->btf;

As Alan proposed below, this btf and type id could be stored at the
attachment point and just fetched through program context.

> > {
> >   struct btf_ptr ptr1 = {
> >     .ptr = arg1,
> >     .type_id = bpf_core_type_id_kernel(struct foo),
> >     .btf_obj = btf_obj,
> >   },
> >   ptr2 = {
> >     .ptr = arg2,
> >     .type_id = bpf_core_type_id_kernel(struct bar),
> >     .btf_obj = btf_obj,
> >   };
> >   bpf_snprintf_btf(,, &ptr1, sizeof(ptr1), );
> >   bpf_snprintf_btf(,, &ptr1, sizeof(ptr2), );
> > }
> >
> > libbpf will process the attach regex and find all matching functions in
> > the kernel and in the kernel modules. Then it will pass this list of
> > (fd,btf_id) pairs to the kernel. The kernel will find IP addresses and
> > BTFs of all functions. It will generate single bpf trampoline to handle
> > all the functions. Either one trampoline or multiple trampolines is an
> > implementation detail. It could be one trampoline that does lookup based
> > on IP to find btf_obj, btf_id to pass into the program or multiple
> > trampolines that share most of the code with N unique trampoline
> > prefixes with hardcoded btf_obj, btf_id. The argument save/restore code
> > can be the same for all fentries. The same way we can support single
> > fexit prog attaching to multiple kernel functions. And even single
> > fmod_ret prog attaching to multiple. The batching part will make
> > attaching to thousands of functions efficient. We can use batched
> > text_poke_bp, etc.

Yep, agree. And extra information that we'll have to store per each
attachment more than offsets the extra overhead that we'd pay for
thousands of BPF program copies we'd need otherwise to achieve the
same functionality, if attached through existing fentry/fexit APIs.

> >
> > As far as dynamic btf casting helper we could do something like this:
> > SEC("fentry/sys_*")
> > int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1, __u64
> > arg2, ...__u64 arg6)
> > {
> >   struct sk_buff *skb;
> >   struct task_struct *task;
> >
> >   skb = bpf_dynamic_cast(btf_obj, btf_id, 1, arg1,
> >                          bpf_core_type_id_kernel(skb));
> >   task = bpf_dynamic_cast(btf_obj, btf_id, 2, arg2,
> >                           bpf_core_type_id_kernel(task));
> >   skb->len + task->status;
> > }
> > The dynamic part of the helper will walk btf of func_proto that was
> > pointed to by 'btf_id' argument. It will find Nth argument and
> > if argument's btf_id matches the last u32 passed into bpf_dynamic_cast()
> > it will return ptr_to_btf_id. The verifier needs 5th u32 arg to know
> > const value of btf_id during verification.
> > The execution time of this casting helper will be pretty fast.
> > Thoughts?

So I haven't dug through the code to see if it's doable, but this API
seems unnecessarily complicated and error-prone. Plus it's not clear
how verifier can validate that btf_obj and btf_id correctly describe
arg1 and it does match "1" argument position. I.e., if I mess up and
for skb specify bpf_dynamic_cast(btf_obj, 123123, 2, arg3,
bpf_core_type_id_kernel(skb)), will verifier stop me? Note that I
specified an arbitrary integer for the second argument. Or at least,
would we get a NULL in runtime? Or we'll just re-interpret arg3
(incorrectly) as a sk_buff? I might be missing something here, of
course.

But this seems more "verifiable" and nicer to use, even though it
won't substituting an arbitrary btf_id and btf_obj (but that's sort of
a goal, I think):

skb = bpf_get_btf_arg(ctx, 1, bpf_core_type_id_kernel(skb));

So btf_obj and btf_id of attach point will be taken from the program's
context, as well as btf info of an argument #1 (and additionally
verified that argument number makes sense at all). Note also that
bpf_core_type_id_kernel(skb) ideally would encode type ID and BTF
object FD of a module, if the destination type is defined in a module.

If we do want explicitly providing btf_obj+btf_id, then I think having
it in a separate struct that verifier can track as a PTR_TO_BTF_ID and
verify it's valid would make this API better (see above).

> >
> >
>
> From a bpf programmer's perspective, the above sounds fantastic and opens
> up a bunch of new possibilities.  For example, a program that attaches to
> a bunch of networking functions at once and uses dynamic casts to find the
> skb argument could help trace packet flow through the stack without having
> to match exact function signatures.  From a mechanics perspective I
> wonder if we could take a similar approach to the cgroup storage, and use
> the bpf prog array structure to store a struct btf * and any other
> site-specific metadata at attach time? Then when the array runs we could
> set a per-cpu variable such that helpers could pick up that info if
> needed.

I don't think per-cpu variable will work for sleepable BPF programs. I
think storing it in whatever BPF context struct is a more reliable
way. But I agree that  remembering struct btf * and attach btf ID at
the attachment point makes a lot of stuff simpler.

>
> Having the function argument BTF ids gets us nearly the whole way there
> from a generic tracer perspective - I can now attach my generic tracing
> program to an arbitrary function via fentry/fexit and get the BTF ids
> of the arguments or return value, and even better can do it with wildcarding.

Yeah, it's a nice interface and libbpf can support that. I think in
more advanced cases (e.g., matching fentry with fexit), libbpf should
still provide APIs to specify extra user-provided long for each
attachment point, so that it's possible to correlate "related" BPF
programs.

> There is an additional use case though - at least for the ksnoop program
> I'm working on at least - and it's where we access members and need their
> type ids too.  The ksnoop program (which I wanted to send out last week but due
> to a system move I'm temporarily not able to access the code, sorry about that,
> hoping it'll be back online early next week) operates in two modes;
>
> - default mode where we trace function arguments for kprobe and return value
>   for kretprobe; that's covered by the above; and
> - a mode where the user specifies what they want. For example running
>
> $ ksnoop "ip_send_skb"
>
> ...is an example of default mode, this will trace entry/return and print
> arguments and return values, while
>
> $ ksnoop "ip_send_skb(skb)"
>
> ...will trace the skb argument only, and
>
> $ ksnoop "ip_send_skb(skb->sk)"
>
> ...will trace the skb->sk value.  The user-space side of the program
> matches the function/arg name and looks up the referenced type, setting it
> in the function's map.  For field references such as skb->sk, it also
> records offset and whether that offset is a pointer (as is the case for
> skb->sk) - in such cases we need to read the offset value via bpf_probe_read()
> and use it in bpf_snprintf_btf() along with the referenced type.  Only a
> single simple reference like the above is supported currently, but
> multiple levels of reference could be made to work too.

I think this is normally done with Clang compiling the code at runtime
(like trace.py), right? I assume you are trying to find a way to do
that without code generation at runtime, am I right? I honestly don't
yet see how this can be done easily...

>
> This latter case would be awkward to support programmatically in BPF
> program context I think, though I'm sure it could be done.  To turn back
> to our earlier conversation, your concern as I understand it was that
> pre-specifying module BTF type ids in a map is racy, and I'd like to dig
> into that a bit more if you don't mind because I think some form of
> user-space-specified BTF ids may be the easiest approach for more flexible
> generic tracing that covers more than function arguments.
>
> I assume the race you're concerned about is caused by the module unloading
> after the BTF ids have been set in the map? And then the module reappears
> with different BTF/type id mappings? Perhaps a helper for retrieving
> the struct btf * which was set at attach time would be enough?
>
> So for example something like
>
>
>         struct btf_ptr ptr;
>
>         ptr.type_id = /* retrieve from map */
>         ptr.obj_id = bpf_get_btf(THIS_MODULE);

On re-reading this this seems like something I was proposing above
with bpf_get_btf_type_id(), right? THIS_MODULE part is confusing,
though.

>
> ...where we don't actually specify a type but a libbpf-specified fd
> is used to stash the associated "struct btf *" for the module in the
> prog array at attach.  Are there still race conditions we need to worry
> about in a scenario like this? Thanks!
>
> Alan
