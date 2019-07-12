Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CCC667FF
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 09:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfGLHx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 03:53:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36025 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfGLHxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 03:53:25 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so8410808ljj.3
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 00:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N14VhMtw4nxYPnjI4trplrlqCxWIy2L/etQTQPyfrho=;
        b=FxhdyRHbpu8lEDRGri3kEp9qecmd7WXeACmTGRQMjU0g0DqvZPnxyZfXWRacYiex4Q
         zmxrgxHb3kXb6UBF/7oOMk438KVsnW/DeUTWBUilhWsuD8PEYpqXfKVo0nBFFOeYQNK8
         ZZm9CdMSRPomyrb+LFAGxthlf56iy8Rw5Wsp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N14VhMtw4nxYPnjI4trplrlqCxWIy2L/etQTQPyfrho=;
        b=B56NsLqAS5H4imvtr2KvGVyHFv9kQ95/IQ/nPPR2B4c+CEOgo0ZxNSCspR5AQZYfzK
         PqxDolrqkstFvcgj836IDi4hBr3p9f6GKSPmtFlDvZnHpCIsgeynC5EFhCHzzpsUw68m
         GhV29MHWvHcvox6qymgvQfXhDobFw66MlqX89PK4wpubxQRHUJvf2rY43MenQn6YHCAP
         qV+hI5cLQOKo7OyIC2jUGo4GRK0Ffno9ozaAsXi0Fl258jdFbUc9QibaHJHcD8Iq4KWB
         8Eg3cZHO5YrcxYQT8rgNNLCsJi9WihhOTx7eGEB3Dd1iEdNw8Ia1DyTE1E6dAjn3yehi
         oPjQ==
X-Gm-Message-State: APjAAAVvLreuIA+wEWCoPIqiiRiB1f7+JDY93K48D7Rtnhfz28zhO70E
        +UH1hW6GFIiuKYnQ+02U6q+cR4tYdOtZ2232TzGOpg==
X-Google-Smtp-Source: APXvYqyVArAnXPKGWQj2yioNmerFWk7zPojj8A/RcIlFiFYo6P6hMnP+MpksjmjX0hn0HTU8pt79mncpTJcBlrqp2U4=
X-Received: by 2002:a2e:89c8:: with SMTP id c8mr5174637ljk.70.1562918002887;
 Fri, 12 Jul 2019 00:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190711010844.1285018-1-andriin@fb.com> <CAGGp+cETuvWUwET=6Mq5sWTJhi5+Rs2bw8xNP2NYZXAAuc6-Og@mail.gmail.com>
 <CAEf4Bzb1kE_jCbyye07-pVMT=914_Nrdh+R=QXA2qMssYP5brA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb1kE_jCbyye07-pVMT=914_Nrdh+R=QXA2qMssYP5brA@mail.gmail.com>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Fri, 12 Jul 2019 09:53:12 +0200
Message-ID: <CAGGp+cHaV1EMXqeQvKN-p5gEZWcSgGfcbKimcS+C8u=dfeU=1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: remove logic duplication in test_verifier.c
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 4:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jul 11, 2019 at 5:13 AM Krzesimir Nowak <krzesimir@kinvolk.io> wr=
ote:
> >
> > On Thu, Jul 11, 2019 at 3:08 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > test_verifier tests can specify single- and multi-runs tests. Interna=
lly
> > > logic of handling them is duplicated. Get rid of it by making single =
run
> > > retval specification to be a first retvals spec.
> > >
> > > Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > Looks good, one nit below.
> >
> > Acked-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> >
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c | 37 ++++++++++---------=
--
> > >  1 file changed, 18 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/test=
ing/selftests/bpf/test_verifier.c
> > > index b0773291012a..120ecdf4a7db 100644
> > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > @@ -86,7 +86,7 @@ struct bpf_test {
> > >         int fixup_sk_storage_map[MAX_FIXUPS];
> > >         const char *errstr;
> > >         const char *errstr_unpriv;
> > > -       uint32_t retval, retval_unpriv, insn_processed;
> > > +       uint32_t insn_processed;
> > >         int prog_len;
> > >         enum {
> > >                 UNDEF,
> > > @@ -95,16 +95,24 @@ struct bpf_test {
> > >         } result, result_unpriv;
> > >         enum bpf_prog_type prog_type;
> > >         uint8_t flags;
> > > -       __u8 data[TEST_DATA_LEN];
> > >         void (*fill_helper)(struct bpf_test *self);
> > >         uint8_t runs;
> > > -       struct {
> > > -               uint32_t retval, retval_unpriv;
> > > -               union {
> > > -                       __u8 data[TEST_DATA_LEN];
> > > -                       __u64 data64[TEST_DATA_LEN / 8];
> > > +       union {
> > > +               struct {
> >
> > Maybe consider moving the struct definition outside to further the
> > removal of the duplication?
>
> Can't do that because then retval/retval_unpriv/data won't be
> accessible as a normal field of struct bpf_test. It has to be in
> anonymous structs/unions, unfortunately.
>

Ah, right.

Meh.

I tried something like this:

#define BPF_DATA_STRUCT \
    struct { \
        uint32_t retval, retval_unpriv; \
        union { \
            __u8 data[TEST_DATA_LEN]; \
            __u64 data64[TEST_DATA_LEN / 8]; \
        }; \
    }

and then:

    union {
        BPF_DATA_STRUCT;
        BPF_DATA_STRUCT retvals[MAX_TEST_RUNS];
    };

And that seems to compile at least. But question is: is this
acceptably ugly or unacceptably ugly? :)

> I tried the following, but that also didn't work:
>
> union {
>     struct bpf_test_retval {
>         uint32_t retval, retval_unpriv;
>         union {
>             __u8 data[TEST_DATA_LEN];
>             __u64 data64[TEST_DATA_LEN / 8];
>         };
>     };
>     struct bpf_test_retval retvals[MAX_TEST_RUNS];
> };
>
> This also made retval/retval_unpriv to not behave as normal fields of
> struct bpf_test.
>
>
> >
> > > +                       uint32_t retval, retval_unpriv;
> > > +                       union {
> > > +                               __u8 data[TEST_DATA_LEN];
> > > +                               __u64 data64[TEST_DATA_LEN / 8];
> > > +                       };
> > >                 };
> > > -       } retvals[MAX_TEST_RUNS];
> > > +               struct {
> > > +                       uint32_t retval, retval_unpriv;
> > > +                       union {
> > > +                               __u8 data[TEST_DATA_LEN];
> > > +                               __u64 data64[TEST_DATA_LEN / 8];
> > > +                       };
> > > +               } retvals[MAX_TEST_RUNS];
> > > +       };
> > >         enum bpf_attach_type expected_attach_type;
> > >  };
> > >
> > > @@ -949,17 +957,8 @@ static void do_test_single(struct bpf_test *test=
, bool unpriv,
> > >                 uint32_t expected_val;
> > >                 int i;
> > >
> > > -               if (!test->runs) {
> > > -                       expected_val =3D unpriv && test->retval_unpri=
v ?
> > > -                               test->retval_unpriv : test->retval;
> > > -
> > > -                       err =3D do_prog_test_run(fd_prog, unpriv, exp=
ected_val,
> > > -                                              test->data, sizeof(tes=
t->data));
> > > -                       if (err)
> > > -                               run_errs++;
> > > -                       else
> > > -                               run_successes++;
> > > -               }
> > > +               if (!test->runs)
> > > +                       test->runs =3D 1;
> > >
> > >                 for (i =3D 0; i < test->runs; i++) {
> > >                         if (unpriv && test->retvals[i].retval_unpriv)
> > > --
> > > 2.17.1
> > >
> >
> >
> > --
> > Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> > Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iag=
o L=C3=B3pez Galeiras
> > Registergericht/Court of registration: Amtsgericht Charlottenburg
> > Registernummer/Registration number: HRB 171414 B
> > Ust-ID-Nummer/VAT ID number: DE302207000



--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
