Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22BA58D47
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0VnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:43:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35567 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0VnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:43:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id l128so3119342qke.2;
        Thu, 27 Jun 2019 14:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FbbgDdciMs2qLXCRIYA8aHeSqhp7HfRtrkHCd2kDFM=;
        b=BS6rDTTueJ4vMlho1zeKhgmC8HGLCxA2XOaLnkl2mgiKMxVfwj/6gktiS3uu2J6yIx
         DjHAwj2sY4VgvU6Bs6Ptj46r2loMGr9v7d6HBDS1EoC6SIsW7+VIFahrn3znw33VL4h9
         eo8V3qo2lSNDeCc23E6AgYIO1zSuOab7uMzhSovGMOQ+3G/KWqOsmaPlPv73H33U70pV
         vZ9tudrifSj2WEnoVpXFIW+p/KuQuBiOtkVmGsLgBPzj2ZTnequr73LxepDgiPvNCxS/
         5xRrjSP4F3sGDSQSQ9EZXxexDoaRGCExc8DVDZBL/uvplRXjmwAtFFcqQmESK4WaM8As
         CHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FbbgDdciMs2qLXCRIYA8aHeSqhp7HfRtrkHCd2kDFM=;
        b=AH23e0x/ZtqNTl8ASljWErToUmTsM3fFJVGUp1NEqF4lkPAUBUtvU/Q2N/Fr3VcKq+
         uP3K3LSFgPxZFZUQj7yXaLIekvnsHlNegPqBX6msC81XqQwQCRSAhqms4LnAR/iG4vJk
         mpCEo9Hvs3Tgo4KHuRLHFrA/hCz4A5nLB69rny2pKqBiOR9NXkarHo4gVKfL6hXacYUF
         Qttd0pJeUmfL9NBXpHJxLt76xzvYYbcGMNYzgZhS3tXMKumFyLMrWsY41e3JvqBjoIjr
         YAKpMGOJvu3FJoJYkHOdgtjLnihXhdeWwL4jg+VrrYNS/98tcjX5I8/hIX8ZB5naVKuw
         umHQ==
X-Gm-Message-State: APjAAAUQ2GWCI23DeE+681lQLTgxNqhvMARyqkvQn6GawEP5HpDk6XYx
        99ZEPXXb5aL+nJ/OJgpgpq0jMQiO3epcO5s1AkA=
X-Google-Smtp-Source: APXvYqwy2WisxVhPeoGbZiE08IgZDVI6VSziI1Tc3zn+swvNRjVP3mXa6k1BII+zqX059CmP/aur+v07aVm6+2js5wQ=
X-Received: by 2002:a37:a643:: with SMTP id p64mr5695179qke.36.1561671784829;
 Thu, 27 Jun 2019 14:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190621045555.4152743-1-andriin@fb.com> <20190621045555.4152743-4-andriin@fb.com>
 <a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net> <CAEf4BzYy4Eorj0VxzArZg+V4muJCvDTX_VVfoouzZUcrBwTa1w@mail.gmail.com>
 <44d3b02d-b0fb-b0cb-a0d3-e7dd4bde0b92@iogearbox.net>
In-Reply-To: <44d3b02d-b0fb-b0cb-a0d3-e7dd4bde0b92@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Jun 2019 14:42:53 -0700
Message-ID: <CAEf4BzZ7EM5eP2eaZn7T2Yb5QgVRiwAs+epeLR1g01TTx-6m6Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] libbpf: add kprobe/uprobe attach API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 2:16 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/27/2019 12:15 AM, Andrii Nakryiko wrote:
> > On Wed, Jun 26, 2019 at 7:25 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> [...]
> >> What this boils down to is that this should get a proper abstraction, e.g. as
> >> in struct libbpf_event which holds the event object. There should be helper
> >> functions like libbpf_event_create_{kprobe,uprobe,tracepoint,raw_tracepoint} returning
> >> such an struct libbpf_event object on success, and a single libbpf_event_destroy()
> >> that does the event specific teardown. bpf_program__attach_event() can then take
> >> care of only attaching the program to it. Having an object for this is also more
> >> extensible than just a fd number. Nice thing is that this can also be completely
> >> internal to libbpf.c as with struct bpf_program and other abstractions where we
> >> don't expose the internals in the public header.
> >
> > Yeah, I totally agree, I think this is a great idea! I don't
> > particularly like "event" name, that seems very overloaded term. Do
> > you mind if I call this "bpf_hook" instead of "libbpf_event"? I've
> > always thought about these different points in the system to which one
> > can attach BPF program as hooks exposed from kernel :)
> >
> > Would it also make sense to do attaching to non-tracing hooks using
> > the same mechanism (e.g., all the per-cgroup stuff, sysctl, etc)? Not
> > sure how people do that today, will check to see how it's done, but I
> > think nothing should conceptually prevent doing that using the same
> > abstract bpf_hook way, right?
>
> I think if we abstract it this way, then absolutely. If I grok the naming conventions
> from the README right, then this would be under 'bpf_hook__' prefix. :)

Yeah, so this is what I had, API-wise:

struct bpf_hook;

LIBBPF_API struct bpf_hook *bpf_hook__new_perf_event(int pfd);
LIBBPF_API struct bpf_hook *bpf_hook__new_kprobe(bool retprobe,
                                                 const char *func_name);
LIBBPF_API struct bpf_hook *bpf_hook__new_uprobe(bool retprobe, pid_t pid,
                                                 const char *binary_path,
                                                 size_t func_offset);
LIBBPF_API struct bpf_hook *bpf_hook__new_tracepoint(const char *tp_category,
                                                     const char *tp_name);
LIBBPF_API struct bpf_hook *bpf_hook__new_raw_tracepoint(const char *tp_name);

LIBBPF_API int bpf_hook__attach_program(struct bpf_hook *hook,
                                        struct bpf_program *prog);
LIBBPF_API int bpf_hook__free(struct bpf_hook *hook);


You'd use bpf_hook_new_xxx to create struct bpf_hook, which then get's
attached using generic bpf_hook__attach_program and detached/freed
with generic bpf_hook__free.

But once I converted selftests, I realized that this generic
bpf_hook__attach_program is kind of unnecessary and is just a
boiler-plate extra function that everyone has to call. So now I'm
leaning towards a hybrid approach:

- bpf_program__attach_xxx will create some specific struct bpf_hook
*and* attach bpf_program to it;
- bpf_hook__free(struct bpf_hook *) would still be used to detach/free
resources, abstracting away specifics of detaching.

There are few benefits to this, I think:
1. Less error checking and clean up from caller: attach either
succeeds (and you'll have to eventually do bpf_hook__free) or not, and
then nothing needs to be cleaned up. With separate create/attach, if
create succeeds, but attach fails, you'll have to do extra
bpf_hook__free call. This bundling of create/attach does prevent
theoretical use case of having hook creation in one place and then
pass this generically into another place for attachment, but it seems
like a bit far-fetched corner use case, which can be implemented at
application level, if necessary.
2. bpf_program__attach has more context for helpful log messages, if
something goes wrong. E.g.,
bpf_program__attach_tracepoint(tp_category, tp_name), once it created
perf event FD for tracepoint, can discard tp_category and tp_name and
use only FD for attachment. But if attachment fails, we don't really
know which tracepoint failed to attach. To facilitate that, you'd need
to allocate/copy tp_category/tp_name (just in case for logging), which
is PITA. With bundled attach, you can log nice error with context
right there with no overhead.

This still allows to do cgroup/flow/sysctl/etc attachment in similar
uniform way (but that's for another set of patches).

Also, I renamed bpf_hook to bpf_link as it seems to convey connection
between connection point (hook) and bpf_program better. Alternative
might be bpf_assoc, I'll mention that as well in cover letter.

Anyways, I think it's better usability without losing anything
(realistically) in terms of flexibility for users. I'll post v2 later
today.


>
> Thanks,
> Daniel
