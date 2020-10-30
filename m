Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773C82A0DB3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgJ3SpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3SpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:45:11 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E11EC0613CF;
        Fri, 30 Oct 2020 11:45:11 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s89so5914051ybi.12;
        Fri, 30 Oct 2020 11:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=px7rt6ijxGxZewVuPhhCu4O2Znk18+YN05hNd4GISOc=;
        b=F61meXiccORHVK6D0lJmOhHIHrwksEueF9s0fHbIB6jUKFfQF7jXBd2xPD/rn8AlQY
         G70yCMvGjOKRYk19+vU9r2W6gwu9fzGJkPqD6vARDsnhLV4o+yGxskj6UlLJ86ou50tY
         iYPV7ZQyMOQBAho+C2eYsCl6MUV3S0UoNE9rnulmNarOMscvBXpNAxNs3zen8KBOxuq+
         FIMICPqLb91TFn8uAzLf4wSMM19izlQxXbkU80Mi+I50hO2NjIoSFhRPTyrvfBK+hU1g
         WhC3yRkqci75D2Qo+IbQG01uMKhBs2NfVXvxdnwVKonlGNLfvcQRQVm9BtYgh88RFco5
         +Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=px7rt6ijxGxZewVuPhhCu4O2Znk18+YN05hNd4GISOc=;
        b=uKgYF3qzblgrFlT6j3WEp0IKrloJK+PhSduq33xgPhhcqpTfvSK4QhyQ5Y/JjKa1d5
         Yf/adY4Z7axu/lbr7SqYV2KseT2o4/AHC4iY94N1D2KnOFK/a4vQD9xivPl+HHck/Sbv
         YgaMWJWmKNOUvvS229bZTaVaqR87uFzZTKyzsJdn57593LdKPm2FSu5/ani8+SGwvHG6
         TGB9hjqKNnLV6pMyKADUwnERxdu0Cm08iRDe6hvm4QNnMbheU8o2b6RpDShD7dP1a/Dm
         b93hKiJ56JunenR24kHgz+XfUvtkesEf8evXwtt28lRBdt2uiG5dFg51mUbOakBYUBn7
         nBNA==
X-Gm-Message-State: AOAM533ekRzqWwIyQ0aRMZUMDSlu71Y4C2T1gVfrExi2O0ukBDYS6Oe3
        iLzD5Sdnl2szoI17xG5XRUXBAkEazz2tJa5wb6c=
X-Google-Smtp-Source: ABdhPJznuci0A5uzK2h1NPbjFkX6C21r1cnLhWmWI00PBsP9m4bZy854eN7DcE2jpydOe0o/j0I+/bCYARzpOMcPNLo=
X-Received: by 2002:a25:25c2:: with SMTP id l185mr5090304ybl.230.1604083510800;
 Fri, 30 Oct 2020 11:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-3-andrii@kernel.org>
 <CAPhsuW6DxoRjBPJEgwzEtmVt-Uunw-MAmAF2tgh-ksjcKuJ4Bw@mail.gmail.com>
In-Reply-To: <CAPhsuW6DxoRjBPJEgwzEtmVt-Uunw-MAmAF2tgh-ksjcKuJ4Bw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Oct 2020 11:44:59 -0700
Message-ID: <CAEf4Bzaj6mfLPtMbXBNJ9Z2E4AKS8W4vcYG6OGuO_XftAqKBeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/11] selftest/bpf: relax btf_dedup test checks
To:     Song Liu <song@kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 9:43 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 29, 2020 at 1:40 AM Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Remove the requirement of a strictly exact string section contents. This used
> > to be true when string deduplication was done through sorting, but with string
> > dedup done through hash table, it's no longer true. So relax test harness to
> > relax strings checks and, consequently, type checks, which now don't have to
> > have exactly the same string offsets.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/btf.c | 34 +++++++++++---------
> >  1 file changed, 19 insertions(+), 15 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> > index 93162484c2ca..2ccc23b2a36f 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> > @@ -6652,7 +6652,7 @@ static void do_test_dedup(unsigned int test_num)
> >         const void *test_btf_data, *expect_btf_data;
> >         const char *ret_test_next_str, *ret_expect_next_str;
> >         const char *test_strs, *expect_strs;
> > -       const char *test_str_cur, *test_str_end;
> > +       const char *test_str_cur;
> >         const char *expect_str_cur, *expect_str_end;
> >         unsigned int raw_btf_size;
> >         void *raw_btf;
> > @@ -6719,12 +6719,18 @@ static void do_test_dedup(unsigned int test_num)
> >                 goto done;
> >         }
> >
> > -       test_str_cur = test_strs;
> > -       test_str_end = test_strs + test_hdr->str_len;
> >         expect_str_cur = expect_strs;
> >         expect_str_end = expect_strs + expect_hdr->str_len;
> > -       while (test_str_cur < test_str_end && expect_str_cur < expect_str_end) {
> > +       while (expect_str_cur < expect_str_end) {
> >                 size_t test_len, expect_len;
> > +               int off;
> > +
> > +               off = btf__find_str(test_btf, expect_str_cur);
> > +               if (CHECK(off < 0, "exp str '%s' not found: %d\n", expect_str_cur, off)) {
> > +                       err = -1;
> > +                       goto done;
> > +               }
> > +               test_str_cur = btf__str_by_offset(test_btf, off);
> >
> >                 test_len = strlen(test_str_cur);
> >                 expect_len = strlen(expect_str_cur);
> > @@ -6741,15 +6747,8 @@ static void do_test_dedup(unsigned int test_num)
> >                         err = -1;
> >                         goto done;
> >                 }
> > -               test_str_cur += test_len + 1;
> >                 expect_str_cur += expect_len + 1;
> >         }
> > -       if (CHECK(test_str_cur != test_str_end,
> > -                 "test_str_cur:%p != test_str_end:%p",
> > -                 test_str_cur, test_str_end)) {
> > -               err = -1;
> > -               goto done;
> > -       }
> >
> >         test_nr_types = btf__get_nr_types(test_btf);
> >         expect_nr_types = btf__get_nr_types(expect_btf);
> > @@ -6775,10 +6774,15 @@ static void do_test_dedup(unsigned int test_num)
> >                         err = -1;
> >                         goto done;
> >                 }
> > -               if (CHECK(memcmp((void *)test_type,
> > -                                (void *)expect_type,
> > -                                test_size),
> > -                         "type #%d: contents differ", i)) {
>
> I guess test_size and expect_size are not needed anymore?

hm.. they are used just one check above, still needed

>
> > +               if (CHECK(btf_kind(test_type) != btf_kind(expect_type),
> > +                         "type %d kind: exp %d != got %u\n",
> > +                         i, btf_kind(expect_type), btf_kind(test_type))) {
> > +                       err = -1;
> > +                       goto done;
> > +               }
> > +               if (CHECK(test_type->info != expect_type->info,
> > +                         "type %d info: exp %d != got %u\n",
> > +                         i, expect_type->info, test_type->info)) {
>
> btf_kind() returns part of ->info, so we only need the second check, no?

technically yes, but when kind mismatches, figuring that out from raw
info field is quite painful, so having a better, more targeted check
is still good.

>
> IIUC, test_type and expect_type may have different name_off now. Shall
> we check ->size matches?

yep, sure, I'll add

>
>
> >                         err = -1;
> >                         goto done;
> >                 }
> > --
> > 2.24.1
> >
