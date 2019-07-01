Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03B15C083
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfGAPpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:45:00 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33738 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfGAPpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:45:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id h24so12104992qto.0;
        Mon, 01 Jul 2019 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FOE44j1xWpRZ28qyZ1p6w3LG2DITsR83YnSX3ZLYcF8=;
        b=icjmOShcMwYRtNRtI8WpIgD+VQDOR+trS7r8z9FsG8UaC2RkU8iqXrzo0g4XuFasdV
         FsrlRwQ7fyWtDWyg9SyXjoXv+9dSELU29eqVf++n5DgkT2ZPuwYlx5OlIJy0yesoX8i1
         p8rHCHgd9jI2rrgOuocl9W4ehVozSn8heJEeHVzTf3t9suC4syd1GiLY4csQRMVpzJnk
         cFykaausbhFqnJ9/6Dgz+GWLvb8aSYHnN6daK/rm7+RPy8uVxOwdUVudh7nDmrbtT0q/
         ahaMpzkebQ/ASD+jbqxt9jGJsTh/NbS/N1xNGaq/qNvPS2XmnDffdZcJ2YUVus7SgKF0
         gYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOE44j1xWpRZ28qyZ1p6w3LG2DITsR83YnSX3ZLYcF8=;
        b=qpxyUisvmZbPadui7Y6VhWYI/WKJFnBk6A9spsBg3XktUT2UvCCVaNRGzoDzgI02xs
         RgAHIILEgDlL64elxgY3ECE2EMz66wMAYn+BYltvvr+EYJqYv/pWlp/QnFmxbEARvAwh
         fMZB3SDEq2wgP4CDktc6JJnxDApn0ZoG9At3wq0PZf91jIdYMgE5JcR1YyO037QPsIeM
         nVW+sbPdw8TU5bEsSwuwpUogYFjMvb51xUG7PiVowNUojfvPBQBT8+YrzbBzdELMsG7B
         XvBktQiPmzKJlHrbjLD6Y75nOeH7UTsoP4VExEhvX225qKxa2X00CPmBmQUIFVCNZcai
         bUFw==
X-Gm-Message-State: APjAAAWTqAD/WBMLaUqTetodPypRFfGiDTPaW9/Z+6wIR+gbcT0LkUka
        Cfg0GAHUx/buktIUWmjLTczULCJaJWk/rHHTLRw=
X-Google-Smtp-Source: APXvYqzNe5IEnVInZYd15vZ3Af3znDb/qIQKL21Y0sax7w8t5o12AQTTFATVb2nhbKIkmKqLf/rBgnobR3oiMZBLlRk=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr20573471qty.141.1561995899130;
 Mon, 01 Jul 2019 08:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190628231049.22149-1-sdf@google.com> <20190628231049.22149-2-sdf@google.com>
 <8e469767-a108-ba42-f8c8-6fd505393699@fb.com>
In-Reply-To: <8e469767-a108-ba42-f8c8-6fd505393699@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 08:44:48 -0700
Message-ID: <CAEf4BzYUv3v2qV7p6ibEfnR2rs0Hy3D_K_uxCMGbVu-pqkaWmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add verifier tests for wide stores
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 11:02 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 4:10 PM, Stanislav Fomichev wrote:
> > Make sure that wide stores are allowed at proper (aligned) addresses.
> > Note that user_ip6 is naturally aligned on 8-byte boundary, so
> > correct addresses are user_ip6[0] and user_ip6[2]. msg_src_ip6 is,
> > however, aligned on a 4-byte bondary, so only msg_src_ip6[1]
> > can be wide-stored.
> >
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/testing/selftests/bpf/test_verifier.c   | 17 ++++++--
> >   .../selftests/bpf/verifier/wide_store.c       | 40 +++++++++++++++++++
> >   2 files changed, 54 insertions(+), 3 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index c5514daf8865..b0773291012a 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -105,6 +105,7 @@ struct bpf_test {
> >                       __u64 data64[TEST_DATA_LEN / 8];
> >               };
> >       } retvals[MAX_TEST_RUNS];
> > +     enum bpf_attach_type expected_attach_type;
> >   };
> >
> >   /* Note we want this to be 64 bit aligned so that the end of our array is
> > @@ -850,6 +851,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >       int fd_prog, expected_ret, alignment_prevented_execution;
> >       int prog_len, prog_type = test->prog_type;
> >       struct bpf_insn *prog = test->insns;
> > +     struct bpf_load_program_attr attr;
> >       int run_errs, run_successes;
> >       int map_fds[MAX_NR_MAPS];
> >       const char *expected_err;
> > @@ -881,8 +883,17 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >               pflags |= BPF_F_STRICT_ALIGNMENT;
> >       if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
> >               pflags |= BPF_F_ANY_ALIGNMENT;
> > -     fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
> > -                                  "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> > +
> > +     memset(&attr, 0, sizeof(attr));
> > +     attr.prog_type = prog_type;
> > +     attr.expected_attach_type = test->expected_attach_type;
> > +     attr.insns = prog;
> > +     attr.insns_cnt = prog_len;
> > +     attr.license = "GPL";
> > +     attr.log_level = 4;
> > +     attr.prog_flags = pflags;
> > +
> > +     fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> >       if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> >               printf("SKIP (unsupported program type %d)\n", prog_type);
> >               skips++;
> > @@ -912,7 +923,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >                       printf("FAIL\nUnexpected success to load!\n");
> >                       goto fail_log;
> >               }
> > -             if (!strstr(bpf_vlog, expected_err)) {
> > +             if (!expected_err || !strstr(bpf_vlog, expected_err)) {
> >                       printf("FAIL\nUnexpected error message!\n\tEXP: %s\n\tRES: %s\n",
> >                             expected_err, bpf_vlog);
> >                       goto fail_log;
> > diff --git a/tools/testing/selftests/bpf/verifier/wide_store.c b/tools/testing/selftests/bpf/verifier/wide_store.c
> > new file mode 100644
> > index 000000000000..c6385f45b114
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/wide_store.c
> > @@ -0,0 +1,40 @@
> > +#define BPF_SOCK_ADDR(field, off, res, err) \
> > +{ \
> > +     "wide store to bpf_sock_addr." #field "[" #off "]", \
> > +     .insns = { \
> > +     BPF_MOV64_IMM(BPF_REG_0, 1), \
> > +     BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, \
> > +                 offsetof(struct bpf_sock_addr, field[off])), \
> > +     BPF_EXIT_INSN(), \
> > +     }, \
> > +     .result = res, \
> > +     .prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
> > +     .expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
> > +     .errstr = err, \
> > +}
> > +
> > +/* user_ip6[0] is u64 aligned */
> > +BPF_SOCK_ADDR(user_ip6, 0, ACCEPT,
> > +           NULL),
> > +BPF_SOCK_ADDR(user_ip6, 1, REJECT,
> > +           "invalid bpf_context access off=12 size=8"),
> > +BPF_SOCK_ADDR(user_ip6, 2, ACCEPT,
> > +           NULL),
> > +BPF_SOCK_ADDR(user_ip6, 3, REJECT,
> > +           "invalid bpf_context access off=20 size=8"),
> > +BPF_SOCK_ADDR(user_ip6, 4, REJECT,
> > +           "invalid bpf_context access off=24 size=8"),
>
> With offset 4, we have
> #968/p wide store to bpf_sock_addr.user_ip6[4] OK
>
> This test case can be removed. user code typically
> won't write bpf_sock_addr.user_ip6[4], and compiler
> typically will give a warning since it is out of
> array bound. Any particular reason you want to
> include this one?

I agree, user_ip6[4] is essentially 8-byte write to user_port field.

>
>
> > +
> > +/* msg_src_ip6[0] is _not_ u64 aligned */
> > +BPF_SOCK_ADDR(msg_src_ip6, 0, REJECT,
> > +           "invalid bpf_context access off=44 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 1, ACCEPT,
> > +           NULL),
> > +BPF_SOCK_ADDR(msg_src_ip6, 2, REJECT,
> > +           "invalid bpf_context access off=52 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 3, REJECT,
> > +           "invalid bpf_context access off=56 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 4, REJECT,
> > +           "invalid bpf_context access off=60 size=8"),
>
> The same as above, offset=4 case can be removed?

And this one is a write into a struct hole, which should be rejected
even without wide-store check, right?

>
> > +
> > +#undef BPF_SOCK_ADDR
> >
