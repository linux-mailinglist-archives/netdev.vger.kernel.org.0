Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD4656AB
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfGKMR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 08:17:57 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34250 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfGKMR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 08:17:57 -0400
Received: by mail-lf1-f66.google.com with SMTP id b29so3924176lfq.1
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 05:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RrsD3KUbljKvcn/hTr1tzlZHGQrSAvr0S9K4UihQZu8=;
        b=gPFFOd4m36WM6dZd5CejiVx7RdfnZc4j/86D1XlTScWoQsHCx2yBODthaivogk8816
         bB2hGxI+PMmzsRKI2aOTxeNpcNXyzHXuM9GL7E+KILvF98Zcs1qaOKfKqWbj9ME7mYPQ
         YowjcBp2AzvI8k5puyqJMwVxLeeaU+mTDht+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RrsD3KUbljKvcn/hTr1tzlZHGQrSAvr0S9K4UihQZu8=;
        b=o4WBwBVngzRN1KcDFpNswhZ4L0TdD3hVRo9sN6jEFTxvCF5c2NJ7O6+XZP2MDpBUl7
         HHm78vJa18A3CLSt2NTyZ43Rz0UmCM0YFKFZU8j/C5L6pkUvqb3xDIpEVqkpLAh8vhOn
         ioXp4wdnO4FKpaFJpOBGuXE+AXfHEdugKGU7oA3fbADPrTIzjteTpib+y3xe3hhxV/zL
         Rh8cBwPMsu8nl2i0J1LZImKS8Wjql6gMD/z93PykG5G//GR4Qmu+RtYC4ov9zOTjJybr
         0Rv1jjGSmYZuqWL35Pn0phJx4GnIKYJPX/o78RpEQbdzPHRr8TBXCY59krxDiBSVcr09
         oBKQ==
X-Gm-Message-State: APjAAAVcElW5RxywIhvHW2+MefcnRAik1Zd2P5ETYzFh26XJ5RkI3//U
        iVOinX04wCCRw9CCL7ixPQ7xMBvKavud8Cj2oKGTMw==
X-Google-Smtp-Source: APXvYqw/AFHC6mXj2InF033lRSoV20fz1hXzm0KNG263CeACzfnfgIlYQMKtoMaN8NEU5ji7jend5en4rm8fFfDzCP4=
X-Received: by 2002:a19:8c08:: with SMTP id o8mr1709672lfd.57.1562847474848;
 Thu, 11 Jul 2019 05:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-6-krzesimir@kinvolk.io>
 <CAEf4BzYYdrcwJKg271ZL7kPJNYyZEGdxQeuUNbfPk=EjewuHeQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYYdrcwJKg271ZL7kPJNYyZEGdxQeuUNbfPk=EjewuHeQ@mail.gmail.com>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Thu, 11 Jul 2019 14:17:44 +0200
Message-ID: <CAGGp+cHoujaAF_DSFitwgV3sshjj6_q6CL_hKPZUDhZC825PUQ@mail.gmail.com>
Subject: Re: [bpf-next v3 05/12] selftests/bpf: Allow passing more information
 to BPF prog test run
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 3:17 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wro=
te:
> >
> > The test case can now specify a custom length of the data member,
> > context data and its length, which will be passed to
> > bpf_prog_test_run_xattr. For backward compatilibity, if the data
> > length is 0 (which is what will happen when the field is left
> > unspecified in the designated initializer of a struct), then the
> > length passed to the bpf_prog_test_run_xattr is TEST_DATA_LEN.
> >
> > Also for backward compatilibity, if context data length is 0, NULL is
> > passed as a context to bpf_prog_test_run_xattr. This is to avoid
> > breaking other tests, where context data being NULL and context data
> > length being 0 is handled differently from the case where context data
> > is not NULL and context data length is 0.
> >
> > Custom lengths still can't be greater than hardcoded 64 bytes for data
> > and 192 for context data.
> >
> > 192 for context data was picked to allow passing struct
> > bpf_perf_event_data as a context for perf event programs. The struct
> > is quite large, because it contains struct pt_regs.
> >
> > Test runs for perf event programs will not allow the copying the data
> > back to data_out buffer, so they require data_out_size to be zero and
> > data_out to be NULL. Since test_verifier hardcodes it, make it
> > possible to override the size. Overriding the size to zero will cause
> > the buffer to be NULL.
> >
> > Changes since v2:
> > - Allow overriding the data out size and buffer.
> >
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c | 105 +++++++++++++++++---
> >  1 file changed, 93 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testin=
g/selftests/bpf/test_verifier.c
> > index 1640ba9f12c1..6f124cc4ee34 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -54,6 +54,7 @@
> >  #define MAX_TEST_RUNS  8
> >  #define POINTER_VALUE  0xcafe4all
> >  #define TEST_DATA_LEN  64
> > +#define TEST_CTX_LEN   192
> >
> >  #define F_NEEDS_EFFICIENT_UNALIGNED_ACCESS     (1 << 0)
> >  #define F_LOAD_WITH_STRICT_ALIGNMENT           (1 << 1)
> > @@ -96,7 +97,12 @@ struct bpf_test {
> >         enum bpf_prog_type prog_type;
> >         uint8_t flags;
> >         __u8 data[TEST_DATA_LEN];
> > +       __u32 data_len;
> > +       __u8 ctx[TEST_CTX_LEN];
> > +       __u32 ctx_len;
> >         void (*fill_helper)(struct bpf_test *self);
> > +       bool override_data_out_len;
> > +       __u32 overridden_data_out_len;
> >         uint8_t runs;
> >         struct {
> >                 uint32_t retval, retval_unpriv;
> > @@ -104,6 +110,9 @@ struct bpf_test {
> >                         __u8 data[TEST_DATA_LEN];
> >                         __u64 data64[TEST_DATA_LEN / 8];
> >                 };
> > +               __u32 data_len;
> > +               __u8 ctx[TEST_CTX_LEN];
> > +               __u32 ctx_len;
> >         } retvals[MAX_TEST_RUNS];
> >  };
> >
> > @@ -818,21 +827,35 @@ static int set_admin(bool admin)
> >  }
> >
> >  static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expecte=
d_val,
> > -                           void *data, size_t size_data)
> > +                           void *data, size_t size_data, void *ctx,
> > +                           size_t size_ctx, u32 *overridden_data_out_s=
ize)
> >  {
> > -       __u8 tmp[TEST_DATA_LEN << 2];
> > -       __u32 size_tmp =3D sizeof(tmp);
> > -       int saved_errno;
> > -       int err;
> >         struct bpf_prog_test_run_attr attr =3D {
> >                 .prog_fd =3D fd_prog,
> >                 .repeat =3D 1,
> >                 .data_in =3D data,
> >                 .data_size_in =3D size_data,
> > -               .data_out =3D tmp,
> > -               .data_size_out =3D size_tmp,
> > +               .ctx_in =3D ctx,
> > +               .ctx_size_in =3D size_ctx,
> >         };
> > +       __u8 tmp[TEST_DATA_LEN << 2];
> > +       __u32 size_tmp =3D sizeof(tmp);
> > +       __u32 size_buf =3D size_tmp;
> > +       __u8 *buf =3D tmp;
> > +       int saved_errno;
> > +       int err;
> >
> > +       if (overridden_data_out_size)
> > +               size_buf =3D *overridden_data_out_size;
> > +       if (size_buf > size_tmp) {
> > +               printf("FAIL: out data size (%d) greater than a buffer =
size (%d) ",
> > +                      size_buf, size_tmp);
> > +               return -EINVAL;
> > +       }
> > +       if (!size_buf)
> > +               buf =3D NULL;
> > +       attr.data_size_out =3D size_buf;
> > +       attr.data_out =3D buf;
> >         if (unpriv)
> >                 set_admin(true);
> >         err =3D bpf_prog_test_run_xattr(&attr);
> > @@ -956,13 +979,45 @@ static void do_test_single(struct bpf_test *test,=
 bool unpriv,
> >         if (!alignment_prevented_execution && fd_prog >=3D 0) {
> >                 uint32_t expected_val;
> >                 int i;
> > +               __u32 size_data;
> > +               __u32 size_ctx;
> > +               bool bad_size;
> > +               void *ctx;
> > +               __u32 *overridden_data_out_size;
> >
> >                 if (!test->runs) {
> > +                       if (test->data_len > 0)
> > +                               size_data =3D test->data_len;
> > +                       else
> > +                               size_data =3D sizeof(test->data);
> > +                       if (test->override_data_out_len)
> > +                               overridden_data_out_size =3D &test->ove=
rridden_data_out_len;
> > +                       else
> > +                               overridden_data_out_size =3D NULL;
> > +                       size_ctx =3D test->ctx_len;
> > +                       bad_size =3D false;
>
> I hated all this duplication of logic, which with this patch becomes
> even more expansive, so I removed it. Please see [0]. Can you please
> apply that patch and add all this new logic only once?
>
>   [0] https://patchwork.ozlabs.org/patch/1130601/

Will do.

>
> >                         expected_val =3D unpriv && test->retval_unpriv =
?
> >                                 test->retval_unpriv : test->retval;
> >
> > -                       err =3D do_prog_test_run(fd_prog, unpriv, expec=
ted_val,
> > -                                              test->data, sizeof(test-=
>data));
> > +                       if (size_data > sizeof(test->data)) {
> > +                               printf("FAIL: data size (%u) greater th=
an TEST_DATA_LEN (%lu) ", size_data, sizeof(test->data));
> > +                               bad_size =3D true;
> > +                       }
> > +                       if (size_ctx > sizeof(test->ctx)) {
> > +                               printf("FAIL: ctx size (%u) greater tha=
n TEST_CTX_LEN (%lu) ", size_ctx, sizeof(test->ctx));
>
> These look like way too long lines, wrap them?

Ah, yeah, these can be wrapped easily. Will do.

>
> > +                               bad_size =3D true;
> > +                       }
> > +                       if (size_ctx)
> > +                               ctx =3D test->ctx;
> > +                       else
> > +                               ctx =3D NULL;
>
> nit: single line:
>
> ctx =3D size_ctx ? test->ctx : NULL;
>
> > +                       if (bad_size)
> > +                               err =3D 1;
> > +                       else
> > +                               err =3D do_prog_test_run(fd_prog, unpri=
v, expected_val,
> > +                                                      test->data, size=
_data,
> > +                                                      ctx, size_ctx,
> > +                                                      overridden_data_=
out_size);
> >                         if (err)
> >                                 run_errs++;
> >                         else
> > @@ -970,14 +1025,40 @@ static void do_test_single(struct bpf_test *test=
, bool unpriv,
> >                 }
> >
> >                 for (i =3D 0; i < test->runs; i++) {
> > +                       if (test->retvals[i].data_len > 0)
> > +                               size_data =3D test->retvals[i].data_len=
;
> > +                       else
> > +                               size_data =3D sizeof(test->retvals[i].d=
ata);
> > +                       if (test->override_data_out_len)
> > +                               overridden_data_out_size =3D &test->ove=
rridden_data_out_len;
> > +                       else
> > +                               overridden_data_out_size =3D NULL;
> > +                       size_ctx =3D test->retvals[i].ctx_len;
> > +                       bad_size =3D false;
> >                         if (unpriv && test->retvals[i].retval_unpriv)
> >                                 expected_val =3D test->retvals[i].retva=
l_unpriv;
> >                         else
> >                                 expected_val =3D test->retvals[i].retva=
l;
> >
> > -                       err =3D do_prog_test_run(fd_prog, unpriv, expec=
ted_val,
> > -                                              test->retvals[i].data,
> > -                                              sizeof(test->retvals[i].=
data));
> > +                       if (size_data > sizeof(test->retvals[i].data)) =
{
> > +                               printf("FAIL: data size (%u) at run %i =
greater than TEST_DATA_LEN (%lu) ", size_data, i + 1, sizeof(test->retvals[=
i].data));
> > +                               bad_size =3D true;
> > +                       }
> > +                       if (size_ctx > sizeof(test->retvals[i].ctx)) {
> > +                               printf("FAIL: ctx size (%u) at run %i g=
reater than TEST_CTX_LEN (%lu) ", size_ctx, i + 1, sizeof(test->retvals[i].=
ctx));
> > +                               bad_size =3D true;
> > +                       }
> > +                       if (size_ctx)
> > +                               ctx =3D test->retvals[i].ctx;
> > +                       else
> > +                               ctx =3D NULL;
> > +                       if (bad_size)
> > +                               err =3D 1;
> > +                       else
> > +                               err =3D do_prog_test_run(fd_prog, unpri=
v, expected_val,
> > +                                                      test->retvals[i]=
.data, size_data,
> > +                                                      ctx, size_ctx,
> > +                                                      overridden_data_=
out_size);
> >                         if (err) {
> >                                 printf("(run %d/%d) ", i + 1, test->run=
s);
> >                                 run_errs++;
> > --
> > 2.20.1
> >



--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
