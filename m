Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74435C448C
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfJAXnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:43:43 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39738 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJAXnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:43:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so13086114qki.6;
        Tue, 01 Oct 2019 16:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NZiKesRrNai6DjNeKspOD00dUBIkQxlrk0O9UGGwq2U=;
        b=RTI6RifuPlhhP7fvLsEc2Nwqyprm+973m8I3d1vEyd8BFtRmAaGiO8hxzmiT9cmSQH
         xAScozlr1mdNqv5sra297Fjugq1+tb9A6n8T86wVobtHCF6Oj7W3zUGikhFDvsqlUjXA
         9//yDMZNdpx/D4BnrB7SzhpI2XSgqiMY7U4YxzQR5UdNb4FCdwpK8rzAnkbqKxU7IipA
         6LTmAZbKWKqCQmaB++ee2MjAFg0aXG+g8UQLIq0yYuiCj14oH2ymwWzVbt53oac9fmWp
         k9PsDyb0/L/CsuJTZKToFkdyo7KANPwyL/aAiy4fNEDdzedu7GA//KCTR3RtGMz/lUb3
         CL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NZiKesRrNai6DjNeKspOD00dUBIkQxlrk0O9UGGwq2U=;
        b=C4LuWXgxrxHaDKeBwtGoGElKW6v9iDRDvyJz+SSGBvnqhmOMPCRWAesoXqrAmklqfE
         IXIkHyyC9+IrFRTAWFdB98tN96c4SrbUXyNgqGeMXkVvdfeHAMikXTPodDcRopLbN/0N
         7UI6SfCBHg6QwdjgEaX2hqXMMO78elb3Nq8dqvDwH00MUtWMK7+0S8Y0oBHWUqXQQruo
         LDZdpW3qNTICx/DQYEOMpb14JCzmh1KcZJ+o+WEECCE9EL8STsXUy5+udlay7kKmJ/4/
         SkC0VQOmY7yMkGMxdCMey+zsLZyhWwoW9c7J2MmXZ92ryRLKN/Zmqa4TfIBLf1+yf4Q3
         s6dg==
X-Gm-Message-State: APjAAAVtdaVPgKw5cPyVCNweZTKVwSvZ7CnSArrgNNrUsnxAiiEcaFD8
        u4bZZ8ghqrq4sArG5A6J/c4VMwcIKk+DWaZCvUo=
X-Google-Smtp-Source: APXvYqwcGE1oMfH3nJPxSj5x72qOQSKPm0dNq5/oFt1xM0UqU+6oySos34lnOeIWHQ67Sy4VMtHW50gUTQhTt4GxIck=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr831825qkb.437.1569973422279;
 Tue, 01 Oct 2019 16:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190930164239.3697916-1-andriin@fb.com> <871rvwx3fg.fsf@toke.dk>
 <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com> <87lfu4t9up.fsf@toke.dk>
In-Reply-To: <87lfu4t9up.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 16:43:30 -0700
Message-ID: <CAEf4BzZJFBdjCSAzJ3-rOrCkkaTJmPSDhx_0xKJt4+Vg2TEFwg@mail.gmail.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/
 sized opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 2:49 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 1, 2019 at 1:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > Add new set of bpf_object__open APIs using new approach to optional
> >> > parameters extensibility allowing simpler ABI compatibility approach=
.
> >> >
> >> > This patch demonstrates an approach to implementing libbpf APIs that
> >> > makes it easy to extend existing APIs with extra optional parameters=
 in
> >> > such a way, that ABI compatibility is preserved without having to do
> >> > symbol versioning and generating lots of boilerplate code to handle =
it.
> >> > To facilitate succinct code for working with options, add OPTS_VALID=
,
> >> > OPTS_HAS, and OPTS_GET macros that hide all the NULL and size checks=
.
> >> >
> >> > Additionally, newly added libbpf APIs are encouraged to follow simil=
ar
> >> > pattern of having all mandatory parameters as formal function parame=
ters
> >> > and always have optional (NULL-able) xxx_opts struct, which should
> >> > always have real struct size as a first field and the rest would be
> >> > optional parameters added over time, which tune the behavior of exis=
ting
> >> > API, if specified by user.
> >>
> >> I think this is a reasonable idea. It does require some care when addi=
ng
> >> new options, though. They have to be truly optional. I.e., I could
> >> imagine that we will have cases where the behaviour might need to be
> >> different if a program doesn't understand a particular option (I am
> >> working on such a case in the kernel ATM). You could conceivably use t=
he
> >> OPTS_HAS() macro to test for this case in the code, but that breaks if=
 a
> >> program is recompiled with no functional change: then it would *appear=
*
> >> to "understand" that option, but not react properly to it.
> >
> > So let me double-check I'm understanding this correctly.
> >
> > Let's say we have some initial options like:
> >
> > // VERSION 1
> > struct bla_opts {
> >     size_t sz;
> > };
> >
> > // VERSION 2
> > Then in newer version we add new field:
> > struct bla_opts {
> >     int awesomeness_trigger;
> > };
> >
> > Are you saying that if program was built with VERSION 1 in mind (so sz
> > =3D 8 for bla_opts, so awesomeness_trigger can't be even specified),
> > then that should be different from the program built against VERSION 2
> > and specifying .awesomeness_trigger =3D 0?
> > Do I get this right? I'm not sure how to otherwise interpret what you
> > are saying, so please elaborate if I didn't get the idea.
> >
> > If that's what you are saying, then I think we shouldn't (and we
> > really can't, see Jesper's remark about padding) distinguish between
> > whether field was not "physically" there or whether it was just set to
> > default 0 value. Treating this uniformly as 0 makes libbpf logic
> > simpler and consistent and behavior much less surprising.
>
> Indeed. My point was that we should make sure we don't try to do this :)

Ah, cool, glad we are in agreement then :)

>
> >> In other words, this should only be used for truly optional bits (like
> >> flags) where the default corresponds to unchanged behaviour relative t=
o
> >> when the option was added.
> >
> > This I agree 100%, furthermore, any added new option has to behave
> > like this. If that's not the case, then it has to be a new API
> > function or at least another symbol version.
>
> Exactly!
>
> >>
> >> A few comments on the syntax below...
> >>
> >>
> >> > +static struct bpf_object *
> >> > +__bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> >> > +                    struct bpf_object_open_opts *opts, bool enforce=
_kver)
> >>
> >> I realise this is an internal function, but why does it have a
> >> non-optional parameter *after* the opts?
> >
> > Oh, no reason, added it later and I'm hoping to remove it completely.
> > Current bpf_object__open_buffer always enforces kver presence in a
> > program, which differs from bpf_object__open behavior (where it
> > depends on provided .prog_type argument), so with this I tried to
> > preserve existing behavior. But in the final version of this patch I
> > think I'll just make this kver archaic business in libbpf not
> > enforced. It's been deleted from kernel long time ago, there is no
> > good reason to keep enforcing this in libbpf. If someone is running
> > against old kernel and didn't specify kver, they'll get error anyway.
> > Libbpf will just need to make sure to pass kver through, if it's
> > specified. Thoughts?
>
> Not many. Enforcing anything on kernel version seems brittle anyway, so
> off the top of my head, yeah, let's nuke it (in a backwards-compatible
> way, of course :)).

Yep, that's what I'm intending to do.

>
> >>
> >> >       char tmp_name[64];
> >> > +     const char *name;
> >> >
> >> > -     /* param validation */
> >> > -     if (!obj_buf || obj_buf_sz <=3D 0)
> >> > -             return NULL;
> >> > +     if (!OPTS_VALID(opts) || !obj_buf || obj_buf_sz =3D=3D 0)
> >> > +             return ERR_PTR(-EINVAL);
> >> >
> >> > +     name =3D OPTS_GET(opts, object_name, NULL);
> >> >       if (!name) {
> >> >               snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
> >> >                        (unsigned long)obj_buf,
> >> >                        (unsigned long)obj_buf_sz);
> >> >               name =3D tmp_name;
> >> >       }
> >> > +
> >> >       pr_debug("loading object '%s' from buffer\n", name);
> >> >
> >> > -     return __bpf_object__open(name, obj_buf, obj_buf_sz, true, tru=
e);
> >> > +     return __bpf_object__open(name, obj_buf, obj_buf_sz, enforce_k=
ver, 0);
> >> > +}
> >> > +
> >> > +struct bpf_object *
> >> > +bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> >> > +                  struct bpf_object_open_opts *opts)
> >> > +{
> >> > +     return __bpf_object__open_mem(obj_buf, obj_buf_sz, opts, false=
);
> >> > +}
> >> > +
> >> > +struct bpf_object *
> >> > +bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz, con=
st char *name)
> >> > +{
> >> > +     struct bpf_object_open_opts opts =3D {
> >> > +             .sz =3D sizeof(struct bpf_object_open_opts),
> >> > +             .object_name =3D name,
> >> > +     };
> >>
> >> I think this usage with the "size in struct" model is really awkward.
> >> Could we define a macro to help hide it? E.g.,
> >>
> >> #define BPF_OPTS_TYPE(type) struct bpf_ ## type ## _opts
> >> #define DECLARE_BPF_OPTS(var, type) BPF_OPTS_TYPE(type) var =3D { .sz =
=3D sizeof(BPF_OPTS_TYPE(type)); }
> >
> > We certainly could (though I'd maintain that type specified full
> > struct name, makes it easier to navigate/grep code), but then we'll be
> > preventing this nice syntax of initializing structs, which makes me
> > very said because I love that syntax.
> >>
> >> Then the usage code could be:
> >>
> >> DECLARE_BPF_OPTS(opts, object_open);
> >> opts.object_name =3D name;
> >>
> >> Still not ideal, but at least it's less boiler plate for the caller, a=
nd
> >> people will be less likely to mess up by forgetting to add the size.
> >
> > What do you think about this?
> >
> > #define BPF_OPTS(type, name, ...) \
> >         struct type name =3D { \
> >                 .sz =3D sizeof(struct type), \
> >                 __VA_ARGS__ \
> >         }
> >
> > struct bla_opts {
> >         size_t sz;
> >         int opt1;
> >         void *opt2;
> >         const char *opt3;
> > };
> >
> > int main() {
> >         BPF_OPTS(bla_opts, opts,
> >                 .opt1 =3D 123,
> >                 .opt2 =3D NULL,
> >                 .opt3 =3D "fancy",
> >         );
> >
> >         /* then also */
> >         BPF_OPTS(bla_opts, old_school);
> >         old_school.opt1 =3D 256;
> >
> >         return opts.opt1;
> > }
>
> Sure, LGTM! Should we still keep the bit where it expands _opts in the
> struct name as part of the macro, or does that become too obtuse?

For me it's a question of code navigation. When I'll have a code

LIBBPF_OPTS(bpf_object_open, <whatever>);

I'll want to jump to the definition of "bpf_object_open" (e.g., w/
cscope)... and will find nothing, because it's actually
bpf_object_open_opts. So I prefer user to spell it out exactly and in
full, this is more maintainable in the long run, IMO.

I'll work on all of that in non-RFC v1 then.

>
> > Thanks a lot for a thoughtful feedback, Toke!
>
> You're very welcome! And thanks for working on these API issues!
>
> -Toke
>
