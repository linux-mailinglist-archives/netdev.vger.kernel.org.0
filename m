Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04208103219
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKTDol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:44:41 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:37172 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfKTDol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:44:41 -0500
Received: by mail-qv1-f65.google.com with SMTP id s18so9177379qvr.4;
        Tue, 19 Nov 2019 19:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFYmk1c4LFW+dPg+5TCuCt2gylH4jJwQm4WOE1MX9E8=;
        b=YhBqxolSGUB8H5f5EdqOoTqDK7MDxsEHlBw+3+a7dHMS7cms9/bHhX1+FUnKSd6hJs
         5O7EzOhOLR+2Z+2Idkz8FpUgJrtCWGJUYLquD1CNWStUZRG+dlyRYuVwlF7iZM7Aobww
         czYt7Z0r/DC6DV4mCiF66dOUh5fHOod7cLaHRZ07Y8/xdfPfYwPJje1jwE+GJctVmEjs
         3+KxkeiMP0WLsDNAR3fP2j/uXVJdjRAAxH0xddYcWnePpbzzJcQvsv3ZjLYUdQZsnEEr
         tZ3lR0X3a672JMFl5KfW+W/+RIq+gqi4FwgBUE3VlRtIdLnR8fzjLzJJ3hCNNTJs956w
         aQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFYmk1c4LFW+dPg+5TCuCt2gylH4jJwQm4WOE1MX9E8=;
        b=QJBFMNzQIM97htUzglxyv518fi6tjC83ZaT46r/La5dtBdwxn3btXYrLcKCPBop6NI
         JFRHpAIWQ7cenM5M6zJIRMODWjIklL7sXDViSn1mI6iJc4HMokSbU9wQc0BfiL85HgBv
         /GwgEESGwPV6zOPL/9PLAKrnQUwOXTFdtayICAqvXSWZmZkT47Qvq1OzKlOxngdzsN1N
         V/o2q/p9lXWUKYzvpPXUq2lmFFGJHZoOLTy+acdon4NX3AzR9rxEkXOkssQ6tLwFQGW5
         d1o5wFdHWDZFyN5BzKPzZcEg3mR5tbntO4Ab6AbFzgIu8qL0Wk5ff51ADlnWwr2HqSdj
         PEfg==
X-Gm-Message-State: APjAAAU7JiRk3iitijhvlBlkAnz+kWNfvXzYjyAHsYPcQBz0ZuM1WlMr
        UexcR+7Z6jF5IYAEG1yMOp8jBusdLLnTg6OrfGc=
X-Google-Smtp-Source: APXvYqxnw/v+WcoNTVHMy/XAEQDtFkTGa55g6ky92RVrmy50ZpV5CkE3xG/Ke3iomA/je39+NNfkzOnWxb3nnl4FW40=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr695293qvb.224.1574221479531;
 Tue, 19 Nov 2019 19:44:39 -0800 (PST)
MIME-Version: 1.0
References: <20191117070807.251360-1-andriin@fb.com> <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com> <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
In-Reply-To: <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Nov 2019 19:44:28 -0800
Message-ID: <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern variables
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 7:58 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 11/19/19 7:42 AM, Andrii Nakryiko wrote:
> > On Mon, Nov 18, 2019 at 10:57 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Mon, Nov 18, 2019 at 7:21 PM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>>
> >>> On Sat, Nov 16, 2019 at 11:08:06PM -0800, Andrii Nakryiko wrote:
> >>>> Add support for extern variables, provided to BPF program by libbpf. Currently
> >>>> the following extern variables are supported:
> >>>>    - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
> >>>>      executing, follows KERNEL_VERSION() macro convention;
> >>>>    - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
> >>>>      boolean, and integer values are supported. Strings are not supported at
> >>>>      the moment.
> >>>>
> >>>> All values are represented as 64-bit integers, with the follow value encoding:
> >>>>    - for boolean values, y is 1, n or missing value is 0;
> >>>>    - for tristate values, y is 1, m is 2, n or missing value is 0;
> >>>>    - for integers, the values is 64-bit integer, sign-extended, if negative; if
> >>>>      config value is missing, it's represented as 0, which makes explicit 0 and
> >>>>      missing config value indistinguishable. If this will turn out to be
> >>>>      a problem in practice, we'll need to deal with it somehow.
> >>>
> >>> I read that statement as there is no extensibility for such api.
> >>
> >> What do you mean exactly?
> >>
> >> Are you worried about 0 vs undefined case? I don't think it's going to
> >> be a problem in practice. Looking at my .config, I see that integer
> >> config values set to their default values are still explicitly
> >> specified with those values. E.g.,
> >>
> >> CONFIG_HZ_1000=y
> >> CONFIG_HZ=1000
> >>
> >> CONFIG_HZ default is 1000, if CONFIG_HZ_1000==y, but still I see it
> >> set. So while I won't claim that it's the case for any possible
> >> integer config, it seems to be pretty consistent in practice.
> >>
> >> Also, I see a lot of values set to explicit 0, like:
> >>
> >> CONFIG_BASE_SMALL=0
> >>
> >> So it seems like integers are typically spelled out explicitly in real
> >> configs and I think this 0 default is pretty sane.
> >>
> >> Next, speaking about extensibility. Once we have BTF type info for
> >> externs, our possibilities are much better. It will be possible to
> >> support bool, int, in64 for the same bool value. Libbpf will be able
> >> to validate the range and fail program load if declared extern type
> >> doesn't match actual value type and value range. So I think
> >> extensibility is there, but right now we are enforcing (logically)
> >> everything to be uin64_t. Unfortunately, with the way externs are done
> >> in ELF, I don't know neither type nor size, so can't be more strict
> >> than that.
> >>
> >> If we really need to know whether some config value is defined or not,
> >> regardless of its value, we can have it by convention. E.g.,
> >> CONFIG_DEFINED_XXX will be either 0 or 1, depending if corresponding
> >> CONFIG_XXX is defined explicitly or not. But I don't want to add that
> >> until we really have a use case where it matters.
> >>
> >>>
> >>>> Generally speaking, libbpf is not aware of which CONFIG_XXX values is of which
> >>>> expected type (bool, tristate, int), so it doesn't enforce any specific set of
> >>>> values and just parses n/y/m as 0/1/2, respectively. CONFIG_XXX values not
> >>>> found in config file are set to 0.
> >>>
> >>> This is not pretty either.
> >>
> >> What exactly: defaulting to zero or not knowing config value's type?
> >> Given all the options, defaulting to zero seems like the best way to
> >> go.
> >>
> >>>
> >>>> +
> >>>> +             switch (*value) {
> >>>> +             case 'n':
> >>>> +                     *ext_val = 0;
> >>>> +                     break;
> >>>> +             case 'y':
> >>>> +                     *ext_val = 1;
> >>>> +                     break;
> >>>> +             case 'm':
> >>>> +                     *ext_val = 2;
> >>>> +                     break;
> >>
> >> reading some more code from scripts/kconfig/symbol.c, I'll need to
> >> handle N/Y/M and 0x hexadecimals, will add in v2 after collecting some
> >> more feedback on this version.
> >>
> >>>> +             case '"':
> >>>> +                     pr_warn("extern '%s': strings are not supported\n",
> >>>> +                             ext->name);
> >>>> +                     err = -EINVAL;
> >>>> +                     goto out;
> >>>> +             default:
> >>>> +                     errno = 0;
> >>>> +                     *ext_val = strtoull(value, &value_end, 10);
> >>>> +                     if (errno) {
> >>>> +                             err = -errno;
> >>>> +                             pr_warn("extern '%s': failed to parse value: %d\n",
> >>>> +                                     ext->name, err);
> >>>> +                             goto out;
> >>>> +                     }
> >>>
> >>> BPF has bpf_strtol() helper. I think it would be cleaner to pass whatever
> >>> .config has as bytes to the program and let program parse n/y/m, strings and
> >>> integers.
> >>
> >> Config value is not changing. This is an incredible waste of CPU
> >> resources to re-parse same value over and over again. And it's
> >> incredibly much worse usability as well. Again, once we have BTF for
> >> externs, we can just declare values as const char[] and then user will
> >> be able to do its own parsing. Until then, I think pre-parsing values
> >> into convenient u64 types are much better and handles all the typical
> >> cases.
> >
> >
> > One more thing I didn't realize I didn't state explicitly, because
> > I've been thinking and talking about that for so long now, that it
> > kind of internalized completely.
> >
> > These externs, including CONFIG_XXX ones, are meant to interoperate
> > nicely with field relocations within BPF CO-RE concept. They are,
> > among other things, are meant to disable parts of BPF program logic
> > through verifier's dead code elimination by doing something like:
> >
> >
> > if (CONFIG_SOME_FEATURES_ENABLED) {
> >      BPF_CORE_READ(t, some_extra_field);
> >      /* or */
> >      bpf_helper_that_only_present_when_feature_is_enabled();
> > } else {
> >      /* fallback logic */
> > }
> >
> > With CONFIG_SOME_FEATURES_ENABLED not being a read-only integer
> > constant when BPF program is loaded, this is impossible. So it
> > absolutely must be some sort of easy to use integer constant.
>
> Hmm. what difference do you see between u64 and char[] ?
> The const propagation logic in the verifier should work the same way.
> If it doesn't it's a bug in the verifier and it's not ok to hack
> extern api to workaround the bug.

For some specific subset of cases (mostly bool and tristate), yes,
verifier should be able to track raw byte value, because there is no
transformation applied to those values. With integers it's certainly
not the case.

Imagine something like:

if (CONFIG_HZ > 1000) {
  ... do something ...
else if (CONFIG_HZ > 100) {
  ... something else ...
} else {
  ... yet another fallback ...
}

With CONFIG_HZ being integer, entire if/else if/else will be
eliminated by verifier. If you do bpf_strtoul(), it's not possible,
unless we do those more further optimizations (implementing const
versions of helpers). The latter would be a good addition, if possible
to implement generically, of course, but I'm not sure we need to block
on that.

>
> What you're advocating with libbpf-side of conversion to integers
> reminds me of our earlier attempts with cgroup_sysctl hooks where
> we started with ints only to realize that in practice it's too
> limited. Then bpf_strtol was introduced and api got much cleaner.
> Same thing here. Converting char[] into ints or whatever else
> is the job of the program. Not of libbpf. The verifier can be taught
> to optimize bpf_strtol() into const when const char[] is passed in.

Given config values are constant and won't change throughout lifetime
of kernel, it's much more practical and easier to parse any
complicated value in userspace and pass necessary well-structured and
easy to use (and thus - performant) data to BPF side through global
data. But if BPF developer knows that CONFIG_HZ has to be integer
(because it's defined in Kconfig as having a type int), then it's
going to be integer, there is no doubt about that.

So while I can imagine some extreme cases where we might need parsing
string, I think most such cases can be painlessly solved in userspace.

Having said that, I don't oppose having an option to expose strings
and allow to work with them, either from userspace or BPF side. It is
extension of what I implemented and can be easily added.

>
> As far as is_enabled() check doing it as 0/1 the way you're proposing
> has in-band signaling issues that you admitted in the commit log.
> For is_enabled() may be new builtin() on llvm side would be better?
> Something like __builtin_preserve_field_info(field, BPF_FIELD_EXISTS)
> but can be used on _any_ extern function or variable.
> Like __builtin_is_extern_resolved(extern_name);
> Then on libbpf side CONFIG_* that are not in config.gz won't be seen
> by the program (instead of seen as 0 in your proposal) and the code
> will look like:
> if (__builtin_is_extern_resolved(CONFIG_NETNS)) {
>    ..do things;
> } else {
> }
> The verifier dead code elimination will take care of branches.
> The BPF program itself doesn't need to read the value of CONFIG_
> it only needs to know whether it was defined.
> Such builtin would match semantics better.

I agree such __builtin is useful and we should add it. But also I
believe that a lot of common cases would be much simpler and nicer if
we have this not defined = 0 logic. But I think we can satisfy both
sides without sacrificing anything. If you define extern as weak:

extern __attribute__((weak)) uint64_t CONFIG_MISSING;

Libbpf will set it to zero, if it's not recognized/found. So check
like below will nicely work:

if (CONFIG_MISSING) {
  .. do something ...
}

If the extern is strong, then the above check will fail, and will have
to be written with using __builtin:

if (__builtin_extern_resolved(CONFIG_MISSING)) {
  .. do something ..
}

This puts control over semantics into users hands. WDYT?


> If CONFIG_ is tri-state doing
> if (*(u8*)CONFIG_FOO == 'y' || *(u8*)CONFIG_FOO == 'm')
> is cleaner than *(u64*)CONFIG_FOO == 1 || 2.
> and constant propagation in the verifier should work the same way.

Once we get BTF info for externs, you'll be able to do just that very cleanly:

extern bool CONFIG_FOO; - true, if =y, false if =n, false, if extern
is weak and undefined in config
extern char CONFIG_FOO; will get 'y'/'n'/'m' values
extern enum tristate CONFIG_FOO - YES/NO/MODULE (or whatever we define
in enum tristate)
extern char CONFIG_FOO[]; - will get raw zero-terminated "y\0", "n\0", or "m\0"

Until we have BTF, though, we can dictate that all those should be
defined uniformly as uin64_t and be handled as in my current patch.
Then, with introduction of BTF, libbpf will do necessary extra
transformations and enforcement of type (e.g., if defined as `extern
bool CONFIG_FOO`, but actual value is m (module) - that will be an
error and enforced by libbpf).

Only if currently users will still use something like bool or int,
instead of uint64_t, that might break later because with BTF for
externs libbpf will suddenly start enforcing more restrictions. But I
think it's just going to be a misuse of current API and shouldn't be
considered a breaking change.

So, to summarize, we proceed with uint64_t for everything, with added
bits of weak vs strong handling. Then in parallel we'll work on adding
BTF for externs and __builtin_extern_resolved (and corresponding new
kind of BTF relocation) and will keep making this whole API even
better, while already having something useful and extensible.

As for strings, I'd prefer to add them in a follow up patch, but if
you guys insist, I can add them anyways. One reservation about strings
I do still have is how better to represent strings:

extern const char *CONFIG_SOME_STRING;   /* pointer to a string
literal, stored in soem other place */
/* or */
extern const char CONFIG_SOME_STRING[];  /* inlined string contents */

The latter can be implemented and used (to some degree) today. But the
former would more seamlessly blend with exposing string-based
variables from kernel. Also,

extern __attribute__((weak)) const char *CONFIG_SOME_STRING;

would more naturally resolve to NULL, if not explicitly defined in
kernel config.

But I'm feeling less strongly about strings overall.

Thoughts?
