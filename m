Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F0C42F3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfJAVt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:49:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727981AbfJAVt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569966565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTPKXYanENCf8S6Y/MdcG6LWf8Ty0manQNkYewZ+BGM=;
        b=cIzP+yjKPGy1t9Z0JYIkZzzo7jevU5voZVk+u8VA3mVgKSdpTuS9ka4Twj7izRd6t34WjB
        gt/MCC+Pjm0LzPGqMdDxstoBCP7BxVzgWdKbKXMnoL3RCXFt1dt2CcCRlxXBgex9YG5oM4
        p+4RpjWzHLVQfE7i06exAIxG5HAHuxM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-3t5NXPNGMvuOBlb8B0cf8w-1; Tue, 01 Oct 2019 17:49:22 -0400
Received: by mail-lf1-f71.google.com with SMTP id x20so3011594lfe.14
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 14:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CWvSuWO20TyB05rSQQNOr2Loal1JyROYxQL2nrEc6yk=;
        b=tTOMzECRF4zJGSQPQ431fhEEExKqXthsGIRdwxTPj8BkYIShY04zBwGaLBRIKmen1C
         ZpBac6pylSxdE9hMalyG/OhJhNBBsfl21LPSZx2037eYpuc7gL8ul7mA4L9ds4+VtUAT
         JG0dzOf5eoDynXOA56vzmzET7GcD+sLXYU5Xvw9/CkNVe7YFIAu6ENR98onyOgO2fv59
         EFiz+eu3kSYpWvEJxSMLD9BCZc4W5SVtyAs/jAw2iolCj0nScrusAbYU6oYj0OwDSQ3i
         as4NGrmmeT9AAAck1jHod7o2PVuy4VRZ5d5zuht/alx56tyvTzotST0x+bnzQ+Kt9qjf
         ahaA==
X-Gm-Message-State: APjAAAVx/UABMwO2fVYhPilMGLsnsBXVevFeyN+LaqElgVp/rs4ZaeRm
        Tc1B8TqWazZeNFcFsBwS8Ia5PF1xzfqJ+I4eIlSwdSLtzBgXoN3I0xgkLNT7QeQFkDpH0cCy3Bt
        1XEZyVrU33a1LZIUO
X-Received: by 2002:a2e:8857:: with SMTP id z23mr45938ljj.19.1569966560601;
        Tue, 01 Oct 2019 14:49:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzrNkirmUxLUhp3EyQUktDY7LhdA5FGyZ3+yZH2x7FEwi2PkHZAqN4kO+1NY51d/6WEM10SVQ==
X-Received: by 2002:a2e:8857:: with SMTP id z23mr45927ljj.19.1569966560379;
        Tue, 01 Oct 2019 14:49:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s7sm4280204ljs.16.2019.10.01.14.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:49:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6140718063D; Tue,  1 Oct 2019 23:49:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/ sized opts
In-Reply-To: <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com>
References: <20190930164239.3697916-1-andriin@fb.com> <871rvwx3fg.fsf@toke.dk> <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 23:49:18 +0200
Message-ID: <87lfu4t9up.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 3t5NXPNGMvuOBlb8B0cf8w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 1, 2019 at 1:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > Add new set of bpf_object__open APIs using new approach to optional
>> > parameters extensibility allowing simpler ABI compatibility approach.
>> >
>> > This patch demonstrates an approach to implementing libbpf APIs that
>> > makes it easy to extend existing APIs with extra optional parameters i=
n
>> > such a way, that ABI compatibility is preserved without having to do
>> > symbol versioning and generating lots of boilerplate code to handle it=
.
>> > To facilitate succinct code for working with options, add OPTS_VALID,
>> > OPTS_HAS, and OPTS_GET macros that hide all the NULL and size checks.
>> >
>> > Additionally, newly added libbpf APIs are encouraged to follow similar
>> > pattern of having all mandatory parameters as formal function paramete=
rs
>> > and always have optional (NULL-able) xxx_opts struct, which should
>> > always have real struct size as a first field and the rest would be
>> > optional parameters added over time, which tune the behavior of existi=
ng
>> > API, if specified by user.
>>
>> I think this is a reasonable idea. It does require some care when adding
>> new options, though. They have to be truly optional. I.e., I could
>> imagine that we will have cases where the behaviour might need to be
>> different if a program doesn't understand a particular option (I am
>> working on such a case in the kernel ATM). You could conceivably use the
>> OPTS_HAS() macro to test for this case in the code, but that breaks if a
>> program is recompiled with no functional change: then it would *appear*
>> to "understand" that option, but not react properly to it.
>
> So let me double-check I'm understanding this correctly.
>
> Let's say we have some initial options like:
>
> // VERSION 1
> struct bla_opts {
>     size_t sz;
> };
>
> // VERSION 2
> Then in newer version we add new field:
> struct bla_opts {
>     int awesomeness_trigger;
> };
>
> Are you saying that if program was built with VERSION 1 in mind (so sz
> =3D 8 for bla_opts, so awesomeness_trigger can't be even specified),
> then that should be different from the program built against VERSION 2
> and specifying .awesomeness_trigger =3D 0?
> Do I get this right? I'm not sure how to otherwise interpret what you
> are saying, so please elaborate if I didn't get the idea.
>
> If that's what you are saying, then I think we shouldn't (and we
> really can't, see Jesper's remark about padding) distinguish between
> whether field was not "physically" there or whether it was just set to
> default 0 value. Treating this uniformly as 0 makes libbpf logic
> simpler and consistent and behavior much less surprising.

Indeed. My point was that we should make sure we don't try to do this :)

>> In other words, this should only be used for truly optional bits (like
>> flags) where the default corresponds to unchanged behaviour relative to
>> when the option was added.
>
> This I agree 100%, furthermore, any added new option has to behave
> like this. If that's not the case, then it has to be a new API
> function or at least another symbol version.

Exactly!

>>
>> A few comments on the syntax below...
>>
>>
>> > +static struct bpf_object *
>> > +__bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
>> > +                    struct bpf_object_open_opts *opts, bool enforce_k=
ver)
>>
>> I realise this is an internal function, but why does it have a
>> non-optional parameter *after* the opts?
>
> Oh, no reason, added it later and I'm hoping to remove it completely.
> Current bpf_object__open_buffer always enforces kver presence in a
> program, which differs from bpf_object__open behavior (where it
> depends on provided .prog_type argument), so with this I tried to
> preserve existing behavior. But in the final version of this patch I
> think I'll just make this kver archaic business in libbpf not
> enforced. It's been deleted from kernel long time ago, there is no
> good reason to keep enforcing this in libbpf. If someone is running
> against old kernel and didn't specify kver, they'll get error anyway.
> Libbpf will just need to make sure to pass kver through, if it's
> specified. Thoughts?

Not many. Enforcing anything on kernel version seems brittle anyway, so
off the top of my head, yeah, let's nuke it (in a backwards-compatible
way, of course :)).

>>
>> >       char tmp_name[64];
>> > +     const char *name;
>> >
>> > -     /* param validation */
>> > -     if (!obj_buf || obj_buf_sz <=3D 0)
>> > -             return NULL;
>> > +     if (!OPTS_VALID(opts) || !obj_buf || obj_buf_sz =3D=3D 0)
>> > +             return ERR_PTR(-EINVAL);
>> >
>> > +     name =3D OPTS_GET(opts, object_name, NULL);
>> >       if (!name) {
>> >               snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
>> >                        (unsigned long)obj_buf,
>> >                        (unsigned long)obj_buf_sz);
>> >               name =3D tmp_name;
>> >       }
>> > +
>> >       pr_debug("loading object '%s' from buffer\n", name);
>> >
>> > -     return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true)=
;
>> > +     return __bpf_object__open(name, obj_buf, obj_buf_sz, enforce_kve=
r, 0);
>> > +}
>> > +
>> > +struct bpf_object *
>> > +bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
>> > +                  struct bpf_object_open_opts *opts)
>> > +{
>> > +     return __bpf_object__open_mem(obj_buf, obj_buf_sz, opts, false);
>> > +}
>> > +
>> > +struct bpf_object *
>> > +bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz, const=
 char *name)
>> > +{
>> > +     struct bpf_object_open_opts opts =3D {
>> > +             .sz =3D sizeof(struct bpf_object_open_opts),
>> > +             .object_name =3D name,
>> > +     };
>>
>> I think this usage with the "size in struct" model is really awkward.
>> Could we define a macro to help hide it? E.g.,
>>
>> #define BPF_OPTS_TYPE(type) struct bpf_ ## type ## _opts
>> #define DECLARE_BPF_OPTS(var, type) BPF_OPTS_TYPE(type) var =3D { .sz =
=3D sizeof(BPF_OPTS_TYPE(type)); }
>
> We certainly could (though I'd maintain that type specified full
> struct name, makes it easier to navigate/grep code), but then we'll be
> preventing this nice syntax of initializing structs, which makes me
> very said because I love that syntax.
>>
>> Then the usage code could be:
>>
>> DECLARE_BPF_OPTS(opts, object_open);
>> opts.object_name =3D name;
>>
>> Still not ideal, but at least it's less boiler plate for the caller, and
>> people will be less likely to mess up by forgetting to add the size.
>
> What do you think about this?
>
> #define BPF_OPTS(type, name, ...) \
>         struct type name =3D { \
>                 .sz =3D sizeof(struct type), \
>                 __VA_ARGS__ \
>         }
>
> struct bla_opts {
>         size_t sz;
>         int opt1;
>         void *opt2;
>         const char *opt3;
> };
>
> int main() {
>         BPF_OPTS(bla_opts, opts,
>                 .opt1 =3D 123,
>                 .opt2 =3D NULL,
>                 .opt3 =3D "fancy",
>         );
>
>         /* then also */
>         BPF_OPTS(bla_opts, old_school);
>         old_school.opt1 =3D 256;
>
>         return opts.opt1;
> }

Sure, LGTM! Should we still keep the bit where it expands _opts in the
struct name as part of the macro, or does that become too obtuse?

> Thanks a lot for a thoughtful feedback, Toke!

You're very welcome! And thanks for working on these API issues!

-Toke

