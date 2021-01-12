Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEDB2F3447
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391763AbhALPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391149AbhALPgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:36:47 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDE8C061786;
        Tue, 12 Jan 2021 07:36:07 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id g20so4154788ejb.1;
        Tue, 12 Jan 2021 07:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3H58F2EgPUmA9bBKPktDhyUlZCxmuNrKvZMlcefSEDw=;
        b=ukQC+u6UU6t7vIYYTsdaKblvTwE2VZ68ooJSzYA3HhooqQ2y9Wug/aYJRae3XvdFWQ
         MdUl9O3DpIUtquLNVEURj8/Uin0KvUjSfBaKa9/c8MNAuoPUudPwapeVfERWj50je7IT
         ztD+8fOsVUuQ3BSMSInF+/Q3IWWQa1g4OnHRLqE1/LiojhuYXIrpWic02h6zPf8HKfDZ
         EOA9SYtNayXd+hc7QnG09kvp4PACyHsXXSEz/1MCDUFhrpL+ieza5dvav1r8dCkuN+e+
         Abdn//3VwCsspRWEXnZTTuxLPzGzk85bB2EPvJUBD7tydn+MsFiNRXt1RnRVqkYpFRqg
         E6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3H58F2EgPUmA9bBKPktDhyUlZCxmuNrKvZMlcefSEDw=;
        b=PsAym8jOAy2cZC5uprS9mpAv+8NYX4gRMLhJ7AcfjIrJfWrP/DwUPb4dwj1ET3OrLz
         4M86FhOmtYq+g2kD4l+xwuovQZOw0novsO4Q3UDjT5K8AlRRUGTAItrtrE0Q1CLuYDt7
         yjbvxif/y49sPT+2WrW7JgWU4taYf/np3mCM70DC1akul95FARwxjBafjI8j/oy2OI42
         cqM+I19rj4Dx0p+H7DYoxV/qN33iB2HhM+DpXgh5s1d+RNavPLYeqYDWqSP4MC6QS1KR
         VdfsyyT90RTWKomPtkZu3y8afsRfpo0Gi9VXOjpYLn75biNXDIh9P1JCCMOaWNJo2GlU
         IbQQ==
X-Gm-Message-State: AOAM531opSG0EJyiVOA9hbCRgK5BQgw/IWsVxq2dEsy9J+3dHy77lUMR
        N7RUDl9QHNztjjZSgSm5ncDpSW3l7Ji+LGCsBuU=
X-Google-Smtp-Source: ABdhPJyBthTeKmOHV1bPwZzzrSsODrn8asKpgzmW7chz9v9JOHxcYnX2KugHRntNpQOYwB2em9V1TVZ00aOdGtDGhZA=
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr3715902ejr.39.1610465765748;
 Tue, 12 Jan 2021 07:36:05 -0800 (PST)
MIME-Version: 1.0
References: <20210112091545.10535-1-gilad.reti@gmail.com> <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
In-Reply-To: <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
From:   Gilad Reti <gilad.reti@gmail.com>
Date:   Tue, 12 Jan 2021 17:35:29 +0200
Message-ID: <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     KP Singh <kpsingh@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 4:56 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> wrote:
> >
> > Add test to check that the verifier is able to recognize spilling of
> > PTR_TO_MEM registers.
> >
>
> It would be nice to have some explanation of what the test does to
> recognize the spilling of the PTR_TO_MEM registers in the commit
> log as well.
>
> Would it be possible to augment an existing test_progs
> program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
> this functionality?
>

It may be possible, but from what I understood from Daniel's comment here

https://lore.kernel.org/bpf/17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net/

the test should be a part of the verifier tests (which is reasonable
to me since it is
a verifier bugfix)

>
>
> > The patch was partially contibuted by CyberArk Software, Inc.
> >
> > Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c   | 12 +++++++-
> >  .../selftests/bpf/verifier/spill_fill.c       | 30 +++++++++++++++++++
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 777a81404fdb..f8569f04064b 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -50,7 +50,7 @@
> >  #define MAX_INSNS      BPF_MAXINSNS
> >  #define MAX_TEST_INSNS 1000000
> >  #define MAX_FIXUPS     8
> > -#define MAX_NR_MAPS    20
> > +#define MAX_NR_MAPS    21
> >  #define MAX_TEST_RUNS  8
> >  #define POINTER_VALUE  0xcafe4all
> >  #define TEST_DATA_LEN  64
> > @@ -87,6 +87,7 @@ struct bpf_test {
> >         int fixup_sk_storage_map[MAX_FIXUPS];
> >         int fixup_map_event_output[MAX_FIXUPS];
> >         int fixup_map_reuseport_array[MAX_FIXUPS];
> > +       int fixup_map_ringbuf[MAX_FIXUPS];
> >         const char *errstr;
> >         const char *errstr_unpriv;
> >         uint32_t insn_processed;
> > @@ -640,6 +641,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> >         int *fixup_sk_storage_map = test->fixup_sk_storage_map;
> >         int *fixup_map_event_output = test->fixup_map_event_output;
> >         int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
> > +       int *fixup_map_ringbuf = test->fixup_map_ringbuf;
> >
> >         if (test->fill_helper) {
> >                 test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
> > @@ -817,6 +819,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> >                         fixup_map_reuseport_array++;
> >                 } while (*fixup_map_reuseport_array);
> >         }
> > +       if (*fixup_map_ringbuf) {
> > +               map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
> > +                                          0, 4096);
> > +               do {
> > +                       prog[*fixup_map_ringbuf].imm = map_fds[20];
> > +                       fixup_map_ringbuf++;
> > +               } while (*fixup_map_ringbuf);
> > +       }
> >  }
> >
> >  struct libcap {
> > diff --git a/tools/testing/selftests/bpf/verifier/spill_fill.c b/tools/testing/selftests/bpf/verifier/spill_fill.c
> > index 45d43bf82f26..1833b6c730dd 100644
> > --- a/tools/testing/selftests/bpf/verifier/spill_fill.c
> > +++ b/tools/testing/selftests/bpf/verifier/spill_fill.c
> > @@ -28,6 +28,36 @@
> >         .result = ACCEPT,
> >         .result_unpriv = ACCEPT,
> >  },
> > +{
> > +       "check valid spill/fill, ptr to mem",
> > +       .insns = {
> > +       /* reserve 8 byte ringbuf memory */
> > +       BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> > +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> > +       BPF_MOV64_IMM(BPF_REG_2, 8),
> > +       BPF_MOV64_IMM(BPF_REG_3, 0),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_reserve),
> > +       /* store a pointer to the reserved memory in R6 */
> > +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> > +       /* check whether the reservation was successful */
> > +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
> > +       /* spill R6(mem) into the stack */
> > +       BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_6, -8),
> > +       /* fill it back in R7 */
> > +       BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_10, -8),
> > +       /* should be able to access *(R7) = 0 */
> > +       BPF_ST_MEM(BPF_DW, BPF_REG_7, 0, 0),
> > +       /* submit the reserved rungbuf memory */
> > +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
> > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_submit),
> > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .fixup_map_ringbuf = { 1 },
> > +       .result = ACCEPT,
> > +       .result_unpriv = ACCEPT,
> > +},
> >  {
> >         "check corrupted spill/fill",
> >         .insns = {
> > --
> > 2.27.0
> >
