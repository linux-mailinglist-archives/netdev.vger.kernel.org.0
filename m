Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942CA672B2
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGLPp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:45:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37314 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfGLPpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:45:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so8543182qto.4;
        Fri, 12 Jul 2019 08:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=253jIi4xOnzjlXg+NSu0GwC/ONvEx2hif4TU2AxVCkk=;
        b=AUkPAPFalZ+5FD7voy4yN/Pw1QeUPyRAq1oKkMLcY6b69p7dcoiI5V1w560l7wXOzW
         j6zf72ggQPvFJdYwGtp7G/gLOcCuMKcraLa2ibKfGWm+NMgIgVlawFqkpglf3/vh56hc
         OkwLiSeaB7eYh80gDAOQSieGTCJozLcCyMtS7nihOk7SBrVnB9D7S1n+PAX2ZlXFu8gC
         +k+Ogl/r7wXbR3mQEokwVpXC8Ejhyo/honZ2oQkdNnPfoy7YjhqdHJLV4ec4+vhyIgYZ
         f/ykzmuYjjQ+1BtYSgcbDUF7+75ixYOHzgYXS9ML+KjAKNivLU0GTrHDV0czk2los1ne
         cueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=253jIi4xOnzjlXg+NSu0GwC/ONvEx2hif4TU2AxVCkk=;
        b=aBc8LctFoGxQiSXkzeLjHE/Zb4Ua/AjygDgzA34NPZv9zgCm+ApB4a/XjottOWYEhP
         Iqq5DQiuQaEcb4Fj5vHrRHtNqSdG8c352uGf4UgSsrk/+nbCuMwODdB0cs6T0EDWvaUp
         zEybP6au1lVcHY/nHj8ZRwhPQJsLKS/aK4umknPz/uUXC8zmb02cu7rI7l3BAMVZJ0py
         By/PEPLIyWnpLEXdT3DIIyE3UKRm3mY6KExDIJ631CQfaDvFCrNH/szNDvFH9wFOTcQJ
         tzQ4ELzsti6nw5KnotlBwr6L7Q/yT7wys4WRHC7T1JctIia4aFepvh2Oe+/qRk93HvyR
         NUbQ==
X-Gm-Message-State: APjAAAXswXtWn/JIYakcyCcnDbmiTE/advUy9p91HVB/X8qSfn+4cF+p
        3IG5ESrJB+0ke0udQ6SHIOzlD2eAymt2bJDSA6I=
X-Google-Smtp-Source: APXvYqxwcqr95f+DpEerccyPYK416a7NLAn9w42IJLY6k6Gs26oxjN42o5ha9HN+aCi1d2+xL4EvfEkLSQNnrc2qshk=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr6719872qty.141.1562946354278;
 Fri, 12 Jul 2019 08:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190711010844.1285018-1-andriin@fb.com> <CAGGp+cETuvWUwET=6Mq5sWTJhi5+Rs2bw8xNP2NYZXAAuc6-Og@mail.gmail.com>
 <CAEf4Bzb1kE_jCbyye07-pVMT=914_Nrdh+R=QXA2qMssYP5brA@mail.gmail.com>
 <CAGGp+cHaV1EMXqeQvKN-p5gEZWcSgGfcbKimcS+C8u=dfeU=1Q@mail.gmail.com> <d6ff6022-56f7-de63-d3e1-8949360296ca@iogearbox.net>
In-Reply-To: <d6ff6022-56f7-de63-d3e1-8949360296ca@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 08:45:43 -0700
Message-ID: <CAEf4BzacDoKwSbBQxMK9eP8ETyD-RWnYYZtucozoVQsJ75Ymjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: remove logic duplication in test_verifier.c
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Krzesimir Nowak <krzesimir@kinvolk.io>,
        Andrii Nakryiko <andriin@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 6:57 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/12/2019 09:53 AM, Krzesimir Nowak wrote:
> > On Thu, Jul 11, 2019 at 4:43 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Thu, Jul 11, 2019 at 5:13 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
> >>>
> >>> On Thu, Jul 11, 2019 at 3:08 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >>>>
> >>>> test_verifier tests can specify single- and multi-runs tests. Internally
> >>>> logic of handling them is duplicated. Get rid of it by making single run
> >>>> retval specification to be a first retvals spec.
> >>>>
> >>>> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> >>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>>
> >>> Looks good, one nit below.
> >>>
> >>> Acked-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> >>>
> >>>> ---
> >>>>  tools/testing/selftests/bpf/test_verifier.c | 37 ++++++++++-----------
> >>>>  1 file changed, 18 insertions(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> >>>> index b0773291012a..120ecdf4a7db 100644
> >>>> --- a/tools/testing/selftests/bpf/test_verifier.c
> >>>> +++ b/tools/testing/selftests/bpf/test_verifier.c
> >>>> @@ -86,7 +86,7 @@ struct bpf_test {
> >>>>         int fixup_sk_storage_map[MAX_FIXUPS];
> >>>>         const char *errstr;
> >>>>         const char *errstr_unpriv;
> >>>> -       uint32_t retval, retval_unpriv, insn_processed;
> >>>> +       uint32_t insn_processed;
> >>>>         int prog_len;
> >>>>         enum {
> >>>>                 UNDEF,
> >>>> @@ -95,16 +95,24 @@ struct bpf_test {
> >>>>         } result, result_unpriv;
> >>>>         enum bpf_prog_type prog_type;
> >>>>         uint8_t flags;
> >>>> -       __u8 data[TEST_DATA_LEN];
> >>>>         void (*fill_helper)(struct bpf_test *self);
> >>>>         uint8_t runs;
> >>>> -       struct {
> >>>> -               uint32_t retval, retval_unpriv;
> >>>> -               union {
> >>>> -                       __u8 data[TEST_DATA_LEN];
> >>>> -                       __u64 data64[TEST_DATA_LEN / 8];
> >>>> +       union {
> >>>> +               struct {
> >>>
> >>> Maybe consider moving the struct definition outside to further the
> >>> removal of the duplication?
> >>
> >> Can't do that because then retval/retval_unpriv/data won't be
> >> accessible as a normal field of struct bpf_test. It has to be in
> >> anonymous structs/unions, unfortunately.
> >>
> >
> > Ah, right.
> >
> > Meh.
> >
> > I tried something like this:
> >
> > #define BPF_DATA_STRUCT \
> >     struct { \
> >         uint32_t retval, retval_unpriv; \
> >         union { \
> >             __u8 data[TEST_DATA_LEN]; \
> >             __u64 data64[TEST_DATA_LEN / 8]; \
> >         }; \
> >     }
> >
> > and then:
> >
> >     union {
> >         BPF_DATA_STRUCT;
> >         BPF_DATA_STRUCT retvals[MAX_TEST_RUNS];
> >     };
> >
> > And that seems to compile at least. But question is: is this
> > acceptably ugly or unacceptably ugly? :)
>
> Both a bit ugly, but I'd have a slight preference towards the above,
> perhaps a bit more readable like:

Heh, I had slight preference the other way :) I'll update diff with
macro, though.

>
> #define bpf_testdata_struct_t                                   \
>         struct {                                                \
>                 uint32_t retval, retval_unpriv;                 \
>                 union {                                         \
>                         __u8 data[TEST_DATA_LEN];               \
>                         __u64 data64[TEST_DATA_LEN / 8];        \
>                 };                                              \
>         }
>         union {
>                 bpf_testdata_struct_t;
>                 bpf_testdata_struct_t retvals[MAX_TEST_RUNS];
>         };
>
> Thanks,
> Daniel
