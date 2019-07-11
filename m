Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61B6593C
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfGKOnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:43:41 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39403 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbfGKOnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:43:41 -0400
Received: by mail-yw1-f68.google.com with SMTP id x74so3898434ywx.6;
        Thu, 11 Jul 2019 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vmOGsoHiM6XG/FkzWHR9Ptf7rpGEwowGLGGHPi+MFsE=;
        b=RvsrKGQe/7jfHw8K7xiEdsTUT8bBicNHtbkmlf24QpA/mMlhxLyhxQzmcXwOUdkaC5
         6MaTcaVvSzZuVeiSxQKlfZp7haBTum0QA2r7Lmry4iQzs3e7D1qEeMSx5P4M03ATijW4
         PkJhsxICIVvyxfqkj8FJOXJQ0RhRpPmHwAUrfOigfd0qcBu4eafWOmXeEj7dyGsmbaIJ
         9x595aooLQoSF0KpWc4nfbABIJhCkzsvDld2BrIZcINq3PkmYA7hTd9FlYsho49BO+4k
         so/vqc0BmjIwVWb6ZAJTNu1ZMHpXD3m2I2a09WvdQDgIQbP+szMKJ4xX062d8EEB+E2q
         JmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vmOGsoHiM6XG/FkzWHR9Ptf7rpGEwowGLGGHPi+MFsE=;
        b=mE8X9KwyLRDxL4YbzwA4UCUSuVx/UK+AZChmF3Y3tHh+NpYRJ0jK+XD5rpuwPkMXyd
         r+o6/+kDwp4g/ycMrS/Heg1B51vPqwG6ncY/8wH35SkxcLZfgP5dUvPmZrsaWlCUkUMx
         mkpLTX8uaZXzlRFApJfq2Uj9p2Arx6ay3hUnGHmY5SZviTa/YChtKQ+PJATM6gcSP8vN
         /lKMr87yIlx9iISFtdXVFP/cXq5XL72o432kpMP/UFfp50g/m5V9vDdj5P3SxyQPGcgJ
         DAggjBtnaZTpulqSAX/8fso9WR54b89DaO3QhxjNc4KVPSGNh/RCEBUIPc03+uhWyFh4
         O4Lg==
X-Gm-Message-State: APjAAAVbDVb243wGhYpHRXIxHOfe5EoMCARxLYEOnGF8puFkueSwnuJm
        cMrFvImEyvA50Bb7wTxKgHJvRei26PbOoO++yGA=
X-Google-Smtp-Source: APXvYqxYeX4hW5tYT/9KOKvI3xx9itOx+7MawBSLTgvaZ6T8c+c/LfMSHizMD8KUu6fS3zd1zVuVcLLamIkyb5uRe5Q=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr2321074qkj.39.1562856219891;
 Thu, 11 Jul 2019 07:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190711010844.1285018-1-andriin@fb.com> <CAGGp+cETuvWUwET=6Mq5sWTJhi5+Rs2bw8xNP2NYZXAAuc6-Og@mail.gmail.com>
In-Reply-To: <CAGGp+cETuvWUwET=6Mq5sWTJhi5+Rs2bw8xNP2NYZXAAuc6-Og@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 07:43:28 -0700
Message-ID: <CAEf4Bzb1kE_jCbyye07-pVMT=914_Nrdh+R=QXA2qMssYP5brA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: remove logic duplication in test_verifier.c
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
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

On Thu, Jul 11, 2019 at 5:13 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrot=
e:
>
> On Thu, Jul 11, 2019 at 3:08 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > test_verifier tests can specify single- and multi-runs tests. Internall=
y
> > logic of handling them is duplicated. Get rid of it by making single ru=
n
> > retval specification to be a first retvals spec.
> >
> > Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Looks good, one nit below.
>
> Acked-by: Krzesimir Nowak <krzesimir@kinvolk.io>
>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c | 37 ++++++++++-----------
> >  1 file changed, 18 insertions(+), 19 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testin=
g/selftests/bpf/test_verifier.c
> > index b0773291012a..120ecdf4a7db 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -86,7 +86,7 @@ struct bpf_test {
> >         int fixup_sk_storage_map[MAX_FIXUPS];
> >         const char *errstr;
> >         const char *errstr_unpriv;
> > -       uint32_t retval, retval_unpriv, insn_processed;
> > +       uint32_t insn_processed;
> >         int prog_len;
> >         enum {
> >                 UNDEF,
> > @@ -95,16 +95,24 @@ struct bpf_test {
> >         } result, result_unpriv;
> >         enum bpf_prog_type prog_type;
> >         uint8_t flags;
> > -       __u8 data[TEST_DATA_LEN];
> >         void (*fill_helper)(struct bpf_test *self);
> >         uint8_t runs;
> > -       struct {
> > -               uint32_t retval, retval_unpriv;
> > -               union {
> > -                       __u8 data[TEST_DATA_LEN];
> > -                       __u64 data64[TEST_DATA_LEN / 8];
> > +       union {
> > +               struct {
>
> Maybe consider moving the struct definition outside to further the
> removal of the duplication?

Can't do that because then retval/retval_unpriv/data won't be
accessible as a normal field of struct bpf_test. It has to be in
anonymous structs/unions, unfortunately.

I tried the following, but that also didn't work:

union {
    struct bpf_test_retval {
        uint32_t retval, retval_unpriv;
        union {
            __u8 data[TEST_DATA_LEN];
            __u64 data64[TEST_DATA_LEN / 8];
        };
    };
    struct bpf_test_retval retvals[MAX_TEST_RUNS];
};

This also made retval/retval_unpriv to not behave as normal fields of
struct bpf_test.


>
> > +                       uint32_t retval, retval_unpriv;
> > +                       union {
> > +                               __u8 data[TEST_DATA_LEN];
> > +                               __u64 data64[TEST_DATA_LEN / 8];
> > +                       };
> >                 };
> > -       } retvals[MAX_TEST_RUNS];
> > +               struct {
> > +                       uint32_t retval, retval_unpriv;
> > +                       union {
> > +                               __u8 data[TEST_DATA_LEN];
> > +                               __u64 data64[TEST_DATA_LEN / 8];
> > +                       };
> > +               } retvals[MAX_TEST_RUNS];
> > +       };
> >         enum bpf_attach_type expected_attach_type;
> >  };
> >
> > @@ -949,17 +957,8 @@ static void do_test_single(struct bpf_test *test, =
bool unpriv,
> >                 uint32_t expected_val;
> >                 int i;
> >
> > -               if (!test->runs) {
> > -                       expected_val =3D unpriv && test->retval_unpriv =
?
> > -                               test->retval_unpriv : test->retval;
> > -
> > -                       err =3D do_prog_test_run(fd_prog, unpriv, expec=
ted_val,
> > -                                              test->data, sizeof(test-=
>data));
> > -                       if (err)
> > -                               run_errs++;
> > -                       else
> > -                               run_successes++;
> > -               }
> > +               if (!test->runs)
> > +                       test->runs =3D 1;
> >
> >                 for (i =3D 0; i < test->runs; i++) {
> >                         if (unpriv && test->retvals[i].retval_unpriv)
> > --
> > 2.17.1
> >
>
>
> --
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago =
L=C3=B3pez Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
