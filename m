Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBB1E75C8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgE2GO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgE2GO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 02:14:56 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37FFC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 23:14:55 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id g7so564106qvx.11
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 23:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AwBW66X55w/qk5Bod1p+IjxbNLvIEv8oVPPxgCizjFc=;
        b=TmJYcMYEH5Al37LUtHy1DKcyoPP5cyqJa9PTsg4ExlHxPjOKi9IdyYX6bEe1wMAIyg
         RIBh/tTefc4dvmBNu+uREOFLYNiOcHv/7djr1R2RNgYEmUrw47ZPysc2Kg0aIdsufWb5
         oVAX9EMECw3VxzbInn0XXRSmWB1M/qOTQeBTPvII0o/Af3VOwxI++UQO3kStTrDwefoh
         clDSTehSIlLkxwytEE5ZSEbKuVII5sUJUj+tOB4TUj/wjb6N9fPER9yfKJJjCatyOfqL
         SiSa+bjfE7PkAyxFhan4rHyT0OUv4eYGgtFCtbvVxhEz8whwbZgyvAWYoexPkIucEs34
         fuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AwBW66X55w/qk5Bod1p+IjxbNLvIEv8oVPPxgCizjFc=;
        b=l5SlWPcgJGCZyOmCO95w4Q/ARDThr31kJPh+EWPlqV/hicoHSJ3e+FAJNtVHq1xjGh
         TM8m2NNPzlsuUkryaKmSchxo1Ieypq2VE6J2KotlQa0oH3N8XXgZcEZ5JTz3PO2VHtZh
         noYFA+j/tsZ+cdnFnCDl6VUSmdpzdb5PJ0ft+gDl8LfLYGwOtbzDEEl2QDu1+91Bu5vL
         w3i1E9/aXcV4W3DYAT8bJnZMehwZxv5UvUUF79tUmFWYZrJ0OWabH0AbzaNXAhh3yojb
         88HyDWNm92dkHtz24HtMHZbakeGoc1RImiI93DFJ6kU5OxvaQJhd1uyJ8jZKK4EEXzES
         zPEg==
X-Gm-Message-State: AOAM530OJ5HE5nFlpd7mLRJihRVqmA8pYH1bLIXSfY/vkz4UQKR+blSd
        9MEiiEl90AClA1HGMZkNPiWcQltwfxbifkugzOu/tw==
X-Google-Smtp-Source: ABdhPJwci1oTG/zX0IkYCuZ3IMawLEUffqu15Kl80rLoilasFB3wzn4QWzR6cDSgIs6jtY2/pbeLYBSMiJLpc86/fkE=
X-Received: by 2002:a05:6214:15ce:: with SMTP id p14mr6873918qvz.159.1590732894455;
 Thu, 28 May 2020 23:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com> <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
In-Reply-To: <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 29 May 2020 08:14:42 +0200
Message-ID: <CACT4Y+bZjRL7LoDhXUrcGWNBYzEWQEq0Mbpzqj6+cP_0nDGWGg@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 2:17 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 28/05/2020 17:00, Alexei Starovoitov wrote:
> > xoring of two identical values is undefined in standard?
> I believe it is in this case, yes; even without the complication
>  of array references that happen to alias, Alexander's foo1() is
>  undefined behaviour under C89 (and also C99 which handles the
>  case differently).
>
> From the definitions section (1.6) of the C89 draft [1]:
> > * Undefined behavior --- behavior, upon use of a nonportable or
> > erroneous program construct, of erroneous data, or of
> > indeterminately-valued objects, for which the Standard imposes
> > no requirements.
> And from 3.5.7 'Initialization':
> > If an object that has automatic storage duration is not
> > initialized explicitly, its value is indeterminate.
> Since the standard doesn't say anything about self-XORing that
>  could make it 'special' in this regard, the compiler isn't
>  required to notice that it's a self-XOR, and (in the tradition
>  of compiler-writers the world over) is entitled to optimise the
>  program based on the assumption that the programmer has not
>  committed UB, so in the foo1() example would be strictly within
>  its rights to generate a binary that contained no XOR
>  instruction at all.  UB, as you surely know, isn't guaranteed to
>  do something 'sensible'.
> And in the BPF example, if the compiler at some point manages to
>  statically figure out that regs[insn->dst_reg] is uninitialised,
>  it might say "hey, I can just grab any old free register and
>  declare that that's now regs[insn->dst_reg] without filling it.
>  And then it can do the same for regs[insn->src_reg], or heck,
>  even choose to fill that one (this is now legal even though the
>  pointers alias, because you already committed UB), and do a xor
>  with different regs and produce garbage results.
>
> (In C99 it gets subtler because an 'indeterminate value' is
>  defined to be 'either a valid value or a trap representation',
>  so arguably the compiler can only do this stuff if it _has_
>  trap representations for the type in question.)

Interesting. Are you sure that's the meaning of 'indeterminate value'?
My latest copy of the standard says:

3.19.2
1 indeterminate value
either an unspecified value or a trap representation

My reading of this would be that this only prevents things from
exploding in all possible random ways (like formatting drive). The
effects are only reduced to either getting a random value, or a trap
on access to the value. Both of these do not seem to be acceptable for
a bpf program.


> > If that's really true such standard worth nothing.
> You may be right, but plenty of compiler writers will take that
>  as a reason to ignore you, and if (say) a gcc upgrade breaks
>  filter.c, they will merrily close any bugs you file as NOTABUG
>  or INVALID or GOAWAYWEDONTCARE.
> Is this annoying?  Extremely; the XOR-clearing _would_ be fine
>  if the standard had chosen to define things differently (e.g.
>  it's fine under a hypothetical 'C99 but uninitialised auto
>  variables have unspecified rather than indeterminate values').
> I can't see a way to work around it that doesn't have a possible
>  performance cost (alternatives to Alexander's MOV_IMM 0 include
>  initialising regs[BPF_REG_A] and regs[BPF_REG_X] in PROG_NAME
>  and PROG_NAME_ARGS), although there is the question of whether
>  anyone who cares about performance (or security) will be using
>  BPF without the JIT anyway.
> But I don't think "Alexandar has to do the data-flow analysis in
>  KMSAN" is the right answer; KMSAN's diagnostic here is _correct_
>  in that ___bpf_prog_run() invokes UB on this XOR.
> Now, since it would be rather difficult and pointless for the
>  compiler to statically prove that the reg is uninitialised (it
>  would need to generate a special code-path just for this one
>  case), maybe the best thing to do is to get GCC folks to bless
>  this usage (perhaps defining uninitialised variables to have
>  what C99 would call an unspecified value), at which point it
>  becomes defined under the "gnu89" pseudo-standard which is what
>  we compile the kernel with.  At which point KMSAN can be taught
>  that this is OK, and can figure out "hey, you're self-XORing an
>  unspecified value, the result is determinate" and clear the
>  shadow bits appropriately.
>
> -ed
>
> [1]: https://port70.net/~nsz/c/c89/c89-draft.html
