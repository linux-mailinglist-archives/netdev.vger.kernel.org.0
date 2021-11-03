Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6A6444769
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhKCRsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKCRsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:48:00 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F42C061714;
        Wed,  3 Nov 2021 10:45:23 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id w4so582456qtn.2;
        Wed, 03 Nov 2021 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3ViBa9naZf28Cww7gL/QOOgFg/wRrzoE4zzgQtbuVU=;
        b=YGuJw0t48hrKKUImWSsY6FBU2oQSbdUEdF/cBSLHgt0U0zBAbQe0Zvir3gPO4iTn2z
         jmSO9eqtBRzOdcE5hSssD/esUFojs56DB8gvj05AblhDt/HpkyJCJmSDNU054q3rluVW
         19lUfE1axAsvR0w2eejCZ6xodPUJJWM9djyMbJzJWUnCg1yTdFZa6NIgAYg+34LHdlRI
         inP1vOYEpR0p7pdTNK6Rlw1Vis8YRH/+lJ2sEzFxTFNAbOdmHH2g52cm+izGQBChMZYv
         5xxwqV3piiLdnrCIyS3M7jlLPFBLGiaUuJp8rtkupP5ZvSNSrfaxyJ2JuX7BbYegdOQx
         W/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3ViBa9naZf28Cww7gL/QOOgFg/wRrzoE4zzgQtbuVU=;
        b=tOYh45N6/U47mOPeeaN8D+VtLv9nNi7FsWZdkfcWBFzvMvu34GpeIwyzd+5NNtBU8x
         1sRMze/qJT1CxqnX9eWU3poPWLfd3rYOC50ssToLh4iqayipFwAhfylQnRO+ohCYaVMH
         SjFUeimvziaKl3pmkGFL5XyXtG2nCWsU8IWm3M1LF7OZsV/UJ1oiGbEygNNCJpj0tlJJ
         EwYRIGUrcR/HzZXtI6EI5hq2HXpjxFLif1CEb9JI78ec+2GM2BmTBMc6cj2xJl3LPw1a
         ioFZjQeuJZbQ1/1w29WmzYEuVjVEKQr6PmAuvJ29lHZVEq0wcrka7VTXeuaVKJx1o0Fa
         1U0Q==
X-Gm-Message-State: AOAM532uyA8sfaQ3P/4V4V2nhjAX/IWeQOEJN2mjA8lwnoaa1p9NZFca
        fB3ClkFAkxOXmIpjpZaxdecS/ZQ8edzIro80kw==
X-Google-Smtp-Source: ABdhPJy8UHA7OwX6MWrwRNFuzQ6lAdjC6nGOP4r/A46tkaWhaeKZYjkJyCePGiuE9kXWb+O6FoTemzfU1PfQKcQ2tvw=
X-Received: by 2002:ac8:5bd6:: with SMTP id b22mr26103259qtb.157.1635961522829;
 Wed, 03 Nov 2021 10:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com> <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com>
In-Reply-To: <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com>
From:   Joe Burton <jevburton.kernel@gmail.com>
Date:   Wed, 3 Nov 2021 10:45:12 -0700
Message-ID: <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort of - I hit issues when defining the function in the same
compilation unit as the call site. For example:

  static noinline int bpf_array_map_trace_update(struct bpf_map *map,
                void *key, void *value, u64 map_flags)
  {
        return 0;
  }
  ALLOW_ERROR_INJECTION(bpf_array_map_trace_update, ERRNO);

  /* Called from syscall or from eBPF program */
  static int array_map_update_elem(struct bpf_map *map, void *key,
                void *value, u64 map_flags)
  {
        ...
                /* This call is elided entirely! */
                if (unlikely(err = bpf_array_map_trace_update(map, key,
                                                value, map_flags)))
                        return err;

... I observed that the call was elided with both gcc and clang. In
either case, the function itself is left behind and can be attached to
with a trampoline prog, but the function is never invoked. Putting
the function body into its own compilation unit sidesteps the issue - I
suspect that LTO isn't clever enough to elide the call.

FWIW, I saw this in the objdump of `array_map_update_elem' when I compiled
this code:

  90:   e8 6b ff ff ff          call   0 \
      <bpf_array_map_trace_update.constprop.0>

So I suspect that constant propagation is responsible for getting rid of
the call site.

The gcc docs for __attribute__((noinline)) call out the asm("") trick to
avoid inlining:

        noinline
        This function attribute prevents a function from being
        considered for inlining. If the function does not have side-
        effects, there are optimizations other than inlining that
        causes function calls to be optimized away, although the
        function call is live. To keep such calls from being optimized
        away, put
                  asm ("");

Since putting the func in its own compilation unit sidesteps the issue,
I'm content to remove the asm("").

On Wed, Nov 3, 2021 at 10:29 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/2/21 5:12 PM, Alexei Starovoitov wrote:
> > On Tue, Nov 02, 2021 at 02:14:29AM +0000, Joe Burton wrote:
> >> From: Joe Burton <jevburton@google.com>
> >>
> >> This is the third version of a patch series implementing map tracing.
> >>
> >> Map tracing enables executing BPF programs upon BPF map updates. This
> >> might be useful to perform upgrades of stateful programs; e.g., tracing
> >> programs can propagate changes to maps that occur during an upgrade
> >> operation.
> >>
> >> This version uses trampoline hooks to provide the capability.
> >> fentry/fexit/fmod_ret programs can attach to two new functions:
> >>          int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
> >>                  void* val, u32 flags);
> >>          int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);
> >>
> >> These hooks work as intended for the following map types:
> >>          BPF_MAP_TYPE_ARRAY
> >>          BPF_MAP_TYPE_PERCPU_ARRAY
> >>          BPF_MAP_TYPE_HASH
> >>          BPF_MAP_TYPE_PERCPU_HASH
> >>          BPF_MAP_TYPE_LRU_HASH
> >>          BPF_MAP_TYPE_LRU_PERCPU_HASH
> >>
> >> The only guarantee about the semantics of these hooks is that they execute
> >> before the operation takes place. We cannot call them with locks held
> >> because the hooked program might try to acquire the same locks. Thus they
> >> may be invoked in situations where the traced map is not ultimately
> >> updated.
> >>
> >> The original proposal suggested exposing a function for each
> >> (map type) x (access type). The problem I encountered is that e.g.
> >> percpu hashtables use a custom function for some access types
> >> (htab_percpu_map_update_elem) but a common function for others
> >> (htab_map_delete_elem). Thus a userspace application would have to
> >> maintain a unique list of functions to attach to for each map type;
> >> moreover, this list could change across kernel versions. Map tracing is
> >> easier to use with fewer functions, at the cost of tracing programs
> >> being triggered more times.
> >
> > Good point about htab_percpu.
> > The patches look good to me.
> > Few minor bits:
> > - pls don't use #pragma once.
> >    There was a discussion not too long ago about it and the conclusion
> >    was that let's not use it.
> >    It slipped into few selftest/bpf, but let's not introduce more users.
> > - noinline is not needed in prototype.
> > - bpf_probe_read is deprecated. Pls use bpf_probe_read_kernel.
> >
> > and thanks for detailed patch 3.
> >
> >> To prevent the compiler from optimizing out the calls to my tracing
> >> functions, I use the asm("") trick described in gcc's
> >> __attribute__((noinline)) documentation. Experimentally, this trick
> >> works with clang as well.
> >
> > I think noinline is enough. I don't think you need that asm in there.
>
> I tried a simple program using clang lto and the optimization
> (optimizing away the call itself) doesn't happen.
>
> [$ ~/tmp2] cat t1.c
>
>
> __attribute__((noinline)) int foo() {
>
>
>    return 0;
>
>
> }
>
>
> [$ ~/tmp2] cat t2.c
>
>
> extern int foo();
>
>
> int main() {
>
>
>    return foo();
>
>
> }
>
>
> [$ ~/tmp2] cat run.sh
>
>
> clang -flto=full -O2 t1.c t2.c -c
>
>
> clang -flto=full -fuse-ld=lld -O2 t1.o t2.o -o a.out
>
>
> [$ ~/tmp2] ./run.sh
>
>
> [$ ~/tmp2] llvm-objdump -d a.out
> ...
> 0000000000201750 <foo>:
>    201750: 31 c0                         xorl    %eax, %eax
>    201752: c3                            retq
>    201753: cc                            int3
>    201754: cc                            int3
>    201755: cc                            int3
>    201756: cc                            int3
>    201757: cc                            int3
>    201758: cc                            int3
>    201759: cc                            int3
>    20175a: cc                            int3
>    20175b: cc                            int3
>    20175c: cc                            int3
>    20175d: cc                            int3
>    20175e: cc                            int3
>    20175f: cc                            int3
>
> 0000000000201760 <main>:
>    201760: e9 eb ff ff ff                jmp     0x201750 <foo>
>
> I remember that even if a call is marked as noinline, the compiler might
> still poke into the call to find some information for some optimization.
> But I guess probably the callsite will be kept. Otherwise, it will be
> considered as "inlining".
>
> Joe, did you hit any issues, esp. with gcc lto?
>
> >
> > In parallel let's figure out how to do:
> > SEC("fentry/bpf_map_trace_update_elem")
> > int BPF_PROG(copy_on_write__update,
> >               struct bpf_map *map,
> >               struct allow_reads_key__old *key,
> >               void *value, u64 map_flags)
> >
> > It kinda sucks that bpf_probe_read_kernel is necessary to read key/values.
> > It would be much nicer to be able to specify the exact struct for the key and
> > access it directly.
> > The verifier does this already for map iterator.
> > It's 'void *' on the kernel side while iterator prog can cast this pointer
> > to specific 'struct key *' and access it directly.
> > See bpf_iter_reg->ctx_arg_info and btf_ctx_access().
> >
> > For fentry into bpf_map_trace_update_elem it's a bit more challenging,
> > since it will be called for all maps and there is no way to statically
> > check that specific_map->key_size is within prog->aux->max_rdonly_access.
> >
> > May be we can do a dynamic cast helper (simlar to those that cast sockets)
> > that will check for key_size at run-time?
> > Another alternative is to allow 'void *' -> PTR_TO_BTF_ID conversion
> > and let inlined probe_read do the job.
> >
