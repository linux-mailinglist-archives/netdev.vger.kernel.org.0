Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5B36B641
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhDZP4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhDZP4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:56:03 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A552C061760;
        Mon, 26 Apr 2021 08:55:22 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 130so21654821ybd.10;
        Mon, 26 Apr 2021 08:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ow0PSN0k/SFvrfh8J27y/ntNo0YklO8A0rTJslW4a0=;
        b=BOEdQYTdn1NsxZR6yKejEHjubc1VX4PeoiZpqqyhaLg/R4PNJTd8+ik5527hW9luLJ
         Bux0pNX1EwqEbx/4mRC2Ia4SNU6ChdVwWNV3NKBg7PGvAI+fBuRI0ENWtviAPPOcXBu4
         RKiJohhdNjlKkJtAbxZ/hbFsTS8lO0dbQzIASt7KD7maWpCI4WdYmx3jhJbqbRlYvU0I
         NvBlpWdgWuf2MebQLxxXhBGlsCFmWuIGrQPrAzgwrgxYBMvKAkFgWd7eRU8VyoGffyid
         l8jFVhcnzSTlr4Uykd0qaUzraQiYlgJsYJQpgNWykJ+nOSt2rG1g4Q69Jb3ATNFSjY0v
         WBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ow0PSN0k/SFvrfh8J27y/ntNo0YklO8A0rTJslW4a0=;
        b=PowNFiQ9562PGnLKkTKBq7KaWEgHbt4dMBocs9t3SUB8VlS3XWAXFf91H5jYpV711l
         CdWDgNsJAg0/sNX2vy4Y2srfwWmoXhm/Hkl2+QCBWn8aDxnRUoLLDYUQAp5EceWPUA4q
         3zJPuFJGZh3yFlQP1AaWjUA8/TxiprhA3ntdeCGOV9mDSpRQipdJF9SZNSY6TenkMCYV
         EA68pSVRdT7swM1RF/5EAmZBC2Khyx/d4LHJlIC4813eIa6NVpHWtImPJu3Y29v+9ldl
         Po0RS7CQqxT5t6xJ9oLWkoC0jNiAPXc/PVIqvJ3/9+kifWFJB1kqm/IyAcNNg9UStaEA
         KwuA==
X-Gm-Message-State: AOAM532G0iasMVjSH1f1zxtP7PIQK3+2CC30+nVDJ1h4bDSnFTJBQ8PO
        u0BOCmFhQqDT4lTWJvbCPbmEFB5pBskHTu33kxA=
X-Google-Smtp-Source: ABdhPJzHS5X/sdWIx2qTfYWM2EGb90/L6N0yrhqZtf2qR/7YLBMCnVg0FdS6AXN4u6VIep7U6kNKaJDfRs5Vd9xSu/Y=
X-Received: by 2002:a25:7507:: with SMTP id q7mr5657912ybc.27.1619452521557;
 Mon, 26 Apr 2021 08:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-6-andrii@kernel.org>
 <CACAyw98cvRe6rE8XOBZfd7v=_5X45U=Qb0AtWJi5Kw2hWccpFQ@mail.gmail.com>
In-Reply-To: <CACAyw98cvRe6rE8XOBZfd7v=_5X45U=Qb0AtWJi5Kw2hWccpFQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 08:55:10 -0700
Message-ID: <CAEf4BzYTg+eawA9gbBM30QZpwS=wTNCpG4SsFNiLctKjChyFNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: fix core_reloc test runner
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 1:17 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Fix failed tests checks in core_reloc test runner, which allowed failing tests
> > to pass quietly. Also add extra check to make sure that expected to fail test cases with
> > invalid names are caught as test failure anyway, as this is not an expected
> > failure mode. Also fix mislabeled probed vs direct bitfield test cases.
> >
> > Fixes: 124a892d1c41 ("selftests/bpf: Test TYPE_EXISTS and TYPE_SIZE CO-RE relocations")
> > Reported-by: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++++++++++--------
> >  1 file changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > index 385fd7696a2e..607710826dca 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > @@ -217,7 +217,7 @@ static int duration = 0;
> >
> >  #define BITFIELDS_CASE(name, ...) {                                    \
> >         BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",     \
> > -                             "direct:", name),                         \
> > +                             "probed:", name),                         \
> >         .input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,     \
> >         .input_len = sizeof(struct core_reloc_##name),                  \
> >         .output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)       \
> > @@ -225,7 +225,7 @@ static int duration = 0;
> >         .output_len = sizeof(struct core_reloc_bitfields_output),       \
> >  }, {                                                                   \
> >         BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",     \
> > -                             "probed:", name),                         \
> > +                             "direct:", name),                         \
> >         .input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,     \
> >         .input_len = sizeof(struct core_reloc_##name),                  \
> >         .output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)       \
> > @@ -546,8 +546,7 @@ static struct core_reloc_test_case test_cases[] = {
> >         ARRAYS_ERR_CASE(arrays___err_too_small),
> >         ARRAYS_ERR_CASE(arrays___err_too_shallow),
> >         ARRAYS_ERR_CASE(arrays___err_non_array),
> > -       ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
> > -       ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
> > +       ARRAYS_ERR_CASE(arrays___err_wrong_val_type),
> >         ARRAYS_ERR_CASE(arrays___err_bad_zero_sz_arr),
> >
> >         /* enum/ptr/int handling scenarios */
> > @@ -865,13 +864,20 @@ void test_core_reloc(void)
> >                           "prog '%s' not found\n", probe_name))
> >                         goto cleanup;
> >
> > +
> > +               if (test_case->btf_src_file) {
> > +                       err = access(test_case->btf_src_file, R_OK);
> > +                       if (!ASSERT_OK(err, "btf_src_file"))
> > +                               goto cleanup;
> > +               }
> > +
> >                 load_attr.obj = obj;
> >                 load_attr.log_level = 0;
> >                 load_attr.target_btf_path = test_case->btf_src_file;
> >                 err = bpf_object__load_xattr(&load_attr);
> >                 if (err) {
> >                         if (!test_case->fails)
> > -                               CHECK(false, "obj_load", "failed to load prog '%s': %d\n", probe_name, err);
> > +                               ASSERT_OK(err, "obj_load");
> >                         goto cleanup;
> >                 }
> >
> > @@ -910,10 +916,8 @@ void test_core_reloc(void)
> >                         goto cleanup;
> >                 }
> >
> > -               if (test_case->fails) {
> > -                       CHECK(false, "obj_load_fail", "should fail to load prog '%s'\n", probe_name);
> > +               if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
>
> Similar to my other comment, I find it difficult to tell when this
> triggers. Maybe it makes sense to return the status of the
> assertion (not the original value)? So if (assertion()) will be
> executed when the assertion fails? Not sure.
>

ASSERT_XXX() does return the status of assertion -- true if it holds,
false if it's violated. So false from ASSERT_xxx() means the test
already is marked failed.

Mechanically, in this case, it reads as "if we couldn't assert that
test_case->fails == false, do something about it". It's the part why
test_case->fails should be false is a bit obscure (because we
successfully loaded, but test_case is marked as should-be-failed, so
test_case->fails has to be false).

I hope it helps at least a bit.

> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
