Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E1680755
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfHCQ4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 12:56:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33185 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHCQ4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 12:56:13 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so57260927qkc.0;
        Sat, 03 Aug 2019 09:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfJt7GEgUb39+lIgspXUSrY/aD5PDHWSaKqwIjdHMYo=;
        b=fTRaGy7oQqL7F1GzSbI4yxiY5WoBpL+6k/LFGR8h4YTjNg3SKx03vw3apunJkWFGxh
         o82b11i4d7o/CUSutxL8CpVkxnWXmEjW0NKyT/CtIQkDYObXBrBAqZ6KsAnBV2cWy4CL
         K01rpzS6KREdWTjKfF+O/e0z1KhVvjoe7WPcy3gme1TVxJ3Wf04Tu/36p8YeupTK5vxU
         10nNbxrz3b7fjPx1Er6PnT1IG0IFxX9/2FCR9raKkzCT8/YpCkDmUNxoPkGeDSpTKff4
         7EYuSxALhJQASbo+gkh26kvZwHVOkCfnFAdAWIwhGRYyM8g9U2LbCK2pGQShV7TItqJI
         RUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfJt7GEgUb39+lIgspXUSrY/aD5PDHWSaKqwIjdHMYo=;
        b=H3vjFEWraQhIMhGG9X4nI3vNIbJZqoqgAFWBa9DA4cFRYbTU4ZXcm/j3gWlB3JwLlZ
         WFZ3ta/qJEbdOkFqhkBDHYehC8bEn0qghMKb35sM8qEBloa6nwWCtCWgTulkJ3blOVpY
         ZUXmSSpL2UZWCQbGnB6CBZcKvdPwyDx3M5vBMjgv3XO98jjx41HPh0RwWsExi3dsPjjk
         ZnSmzOC1hkcRowqoRUN18d0BVmg3hR3rF9+5GMbLsIX8Tqiq0Wv+GGLBdzRl2CTOgkaP
         nENWd4EnVO3rGUsTkY9wZ3oXZkU3EWYuPwomC3a/ADlK0xpl/k4yYaE+s6cth4h5XXs1
         mv6w==
X-Gm-Message-State: APjAAAWCbxs5xe0YLsJZ/Kc+fy0oHCf9yXAdGTTNZ8UuaY9oKz2tQ7nl
        B2FTR9lgbx3IghsIedUH/h4ZGGznX7hFk62BO4k=
X-Google-Smtp-Source: APXvYqw4lDcaZ3yx2+UPXieA5nEvtHg29grEKxJlCITemX53gVEerhWptwEyyZvTfM5VcGt3+WSynxTS5c+aIIrJGDM=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr100225480qke.449.1564851371681;
 Sat, 03 Aug 2019 09:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190801064803.2519675-1-andriin@fb.com> <20190801064803.2519675-3-andriin@fb.com>
 <20190801235030.bzssmwzuvzdy7h7t@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzarjODxo5c-UKtCL_dGGNb1m-3QPAGGR0eq_0tcZVMt8g@mail.gmail.com>
 <20190802215604.onihsysinwiu3shl@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzY46=Vosd+kha+_Yh_iXNXhgfSW3ihePApb4GfuzoUU6w@mail.gmail.com> <20190803162556.pdbckv7yta4wigjk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190803162556.pdbckv7yta4wigjk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 3 Aug 2019 09:56:00 -0700
Message-ID: <CAEf4Bza+5puzEwyqym0eVZ=nGucSOWLwozBVMqpSwysob_8DvQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 3, 2019 at 9:26 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Aug 02, 2019 at 11:30:21PM -0700, Andrii Nakryiko wrote:
> >
> > No, not anonymous.
> >
> > struct my_struct___local {
> >     int a;
> > };
> >
> > struct my_struct___target {
> >     long long a;
> > };
> >
> > my_struct___local->a will not match my_struct___target->a, but it's
> > not a reason to stop relocation process due to error.
>
> why? It feels that this is exactly the reason to fail relocation.
> struct names matched. field names matched.
> but the types are different. Why proceed further?

Because it can be accidental name collision. Think about two different
ring_buffer structs, let's say they have some field with the same
generic name, but different types, e.g., id (I'm making everything up,
except the fact that there are two different ring_buffers in kernel):

struct ring_buffer {
    int id;
    int extra_field_a;
    /* tons of other fields */
};

struct ring_buffer {
    char id[16];
    int extra_field_b;
    /* other stuff */
};

If BPF app expects to read first ring_buffer's id (of int type), that
relocation will still be tried against both, because there is no way
to know which one was originally intended. But because type matched
for only one of them, then that one is the chosen candidate.

Now, if both ids were int, then we would have two matching candidates,
and then two situations are possible:

1. Offsets of that field match. Then it doesn't matter, we still
successfully relocate.
2. Offsets don't match - that's an error, because we can't figure out
correct relocation. Program loading will fail in that case.

But in situation 2, if there was another relocation for ring_buffer
(for another field), and that field was matched against only one of
the structs, then that one struct would be chosen only.

So in general, I try to postpone failure as much as possible, because
there could be "accidental" name matches. This is not a failure, until
we have ambiguity or failed to find any matching candidate, that
satisfies **all** field relocations.


>
> Also what about str->a followed by str->b.
> Is it possible that str->a will pick up one flavor when str->b different one?

No, if str->a picked one flavor and discarded another one, then we are
left with that chosen flavor as single possible candidate for all
subsequent relocations against structs with the same name. That's main
reason or this cache of candidates that I maintain (not just a
performance improvement).

> That will likely lead to wrong behavior?
>
> >
> > All the tests I added use non-numeric flavors. While technically I can
> > use just ___1, ___2 and so on, it will greatly reduce readability,
> > while not really solving any problem (nothing prevents someone to add
> > something like lmc___1 eventually).
> >
> > I think it's not worth it to complicate this logic just for
> > lmc___{softc,media,ctl}, but we can do 2) - try to match any struct as
> > is. If that fails, see if it's a "flavor" and match flavors.
>
> Could you please share benchmarking results of largish bpf prog
> with couple thousands relocations against typical vmlinux.h ?

I can once I have such a program converted.

> I'm concerned that this double check will be noticeable.

Well yes, it's an extra pass, essentially, which is why I wouldn't
like to do it.

> May be llvm should recognize "flavor" in the type name and
> encode them differently in BTF ?
> Or add a pre-pass to libbpf to sort out all types into flavored and not.

This seems like extreme overcomplication for extreme corner case. And
there is very simple work-around from user space.

E.g., let's take that lmc___media struct. If for user really needs to
relocate such struct, we can just define (locally) typedef:

typedef struct lmc___media lmc___media___for_real;

And now "non-flavored" name that we will try to match will be desired
"lmc___media". Given there are whole 3 structs like that right now,
I'm fine with this work around in exchange of not overcomplicating
libbpf's algorithm. WDYT?

> If flavored search is expensive may be all flavors could be a linked list
> from the base type. The typical case is one or two flavors, right?

Flavors search is no more expensive than non-flavored one. And we have
a list of candidates.

>
> > > > > > +     for (i = 0, j = 0; i < cand_ids->len; i++) {
> > > > > > +             cand_id = cand_ids->data[i];
> > > > > > +             cand_type = btf__type_by_id(targ_btf, cand_id);
> > > > > > +             cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> > > > > > +
> > > > > > +             err = bpf_core_spec_match(&local_spec, targ_btf,
> > > > > > +                                       cand_id, &cand_spec);
> > > > > > +             if (err < 0) {
> > > > > > +                     pr_warning("prog '%s': relo #%d: failed to match spec ",
> > > > > > +                                prog_name, relo_idx);
> > > > > > +                     bpf_core_dump_spec(LIBBPF_WARN, &local_spec);
> > > > > > +                     libbpf_print(LIBBPF_WARN,
> > > > > > +                                  " to candidate #%d [%d] (%s): %d\n",
> > > > > > +                                  i, cand_id, cand_name, err);
> > > > > > +                     return err;
> > > > > > +             }
> > > > > > +             if (err == 0) {
> > > > > > +                     pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec ",
> > > > > > +                              prog_name, relo_idx, i, cand_id, cand_name);
> > > > > > +                     bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> > > > > > +                     libbpf_print(LIBBPF_DEBUG, "\n");
> > > > > > +                     continue;
> > > > > > +             }
> > > > > > +
> > > > > > +             pr_debug("prog '%s': relo #%d: candidate #%d matched as spec ",
> > > > > > +                      prog_name, relo_idx, i);
> > > > >
> > > > > did you mention that you're going to make a helper for this debug dumps?
> > > >
> > > > yeah, I added bpf_core_dump_spec(), but I don't know how to shorten
> > > > this further... This output is extremely useful to understand what's
> > > > happening and will be invaluable when users will inevitably report
> > > > confusing behavior in some cases, so I still want to keep it.
> > >
> > > not sure yet. Just pointing out that this function has more debug printfs
> > > than actual code which doesn't look right.
> > > We have complex algorithms in the kernel (like verifier).
> > > Yet we don't sprinkle printfs in there to this degree.
> > >
> >
> > We do have a verbose verifier logging, though, exactly to help users
> > to debug issues, which is extremely helpful and is greatly appreciated
> > by users.
> > There is nothing worse for developer experience than getting -EINVAL
> > without any useful log message. Been there, banged my head against the
> > wall wishing for a bit more verbose log. What are we trying to
> > optimize for here?
>
> All I'm saying that three printfs in a row that essentially convey the same info
> look like clowntown. Some level of verbosity is certainly useful.

But they don't convey the same information! One is error clearly
stating "failed to match with error". Another one is informational
debug-only "we tried this candidate, it didn't match, but it's not an
error". The other one "yay, we successfully found this candidate".
Three extremely different outcomes.

Given I find it hard to understand what's the exact reason you don't
like this, it's hard to guess the approach that you'll find
acceptable, but I'll try one more time. How about this:

- emit "We are trying this spec/this candidate" before we try (at
DEBUG log level, though);
- then depending on the outcome, emit corresponding "cand #%d:
failed", "cand #%d: not a match", or "cand #%d: a match".

This is very subpar, especially given that on error we might not have
spec/candidate details, because they are DEBUG-only, but still better
than nothing.

But, honestly, at this point I'm ready to give up and remove all that,
I'll just keep adding it back locally when reproducing or debugging
some issue in the future, which is PITA, but nothing I can't live
with.
>
