Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A264952098F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiEIXro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiEIXrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:47:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C842CDEEE
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:38:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t6so21488315wra.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 16:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sEOoNgA37n+oAtmDFXjXYHfK9txRG9g+pJQQojjD46Y=;
        b=XXu0vAfOWN76zZocMQkxmDXWgIDzGo83KaDB7NAjCJ2ILPSOZDv0fZ9UdN0P6frAwD
         AwXmeS7Rjlnggyn135GHPcSKeRHe2VNehubW44MTeZXWk2lkSEXJj4O3w1Z7KdWO2z2i
         rb4jQWCREBTTEZ5zOr+dOOdPArOAEFO8+5k3q34jtMoCvjMwbxBSb+2koRsh4rQ6PdQ1
         ljjj6Vg9Fr5JqIVLgXyudWIV2JLHAqAjywTvH1eyhrm6EOVsWCzu9HRt07AwHjdRP4zh
         ax5hKw2OL6a3O4+GmVpAwvm1YAtsAFkgroO1E7PjyDlvSutFIBZ7AA0axajHwjcEJd3n
         SfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sEOoNgA37n+oAtmDFXjXYHfK9txRG9g+pJQQojjD46Y=;
        b=xpM3QJ85MhB1hHVnxbhikCYUXNfcY6ZqlJ55iJfr7cvJzWe6dFb2FsSFbWu7dVa8r2
         tbV3zMzaE42jO8mD6B1/wUERsZXctQezIgye4iT1fBpw6uKN3eiuqVdrd5iWSjh/7peU
         q8uOe/mVgt5UrIOIfVLMw+T792FTJrJkEZ7NEOn6sFfCH8ICd9oy5pPHP9HjI7OUHqmj
         l6Y8C+3WDNz+aRSR2DMC1dVjrBozyhURUHnHxS77wSQSktqFD5rnmyQM+oeURgX4knXZ
         5X4HN9vPmET/6gPydFRFdLlrOUqYqkOWx/WE1iDdRihLaykqv11fXEo6DysZZdtnaaXG
         P7Eg==
X-Gm-Message-State: AOAM532QkTB/xX7q1AiQzIH4N4oSjklYs+8QsEMplqqrNG/Qvjk+LQTH
        iDnA6wqYcHMHEmfW4L6ZxUzoIkqNxRLHEqnrCZBb+Q==
X-Google-Smtp-Source: ABdhPJzbOltZZaR3MgHCrXXhLNCDJBGfgjqHZbfMUBDfydO6J+pREiZbXz7ZkG+gqvomBwxUyol5h4urwh1GGFmxqEQ=
X-Received: by 2002:adf:dc91:0:b0:20c:cb51:4160 with SMTP id
 r17-20020adfdc91000000b0020ccb514160mr5366046wrj.568.1652139520845; Mon, 09
 May 2022 16:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-11-sdf@google.com>
 <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com>
In-Reply-To: <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 9 May 2022 16:38:29 -0700
Message-ID: <CAKH8qBtk6CpR-29R6sWicz_zW=RCYUrXZqBZbgF9eqt4XGgNqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 10/10] selftests/bpf: verify lsm_cgroup struct
 sock access
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 2:54 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Apr 29, 2022 at 2:16 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > sk_priority & sk_mark are writable, the rest is readonly.
> >
> > Add new ldx_offset fixups to lookup the offset of struct field.
> > Allow using test.kfunc regardless of prog_type.
> >
> > One interesting thing here is that the verifier doesn't
> > really force me to add NULL checks anywhere :-/
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
> >  .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
> >  2 files changed, 87 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> >
>
> [...]
>
> > diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > new file mode 100644
> > index 000000000000..af0efe783511
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > @@ -0,0 +1,34 @@
> > +#define SK_WRITABLE_FIELD(tp, field, size, res) \
> > +{ \
> > +       .descr = field, \
> > +       .insns = { \
> > +               /* r1 = *(u64 *)(r1 + 0) */ \
> > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
> > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
> > +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
> > +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
> > +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
> > +               BPF_MOV64_IMM(BPF_REG_0, 1), \
> > +               BPF_EXIT_INSN(), \
> > +       }, \
> > +       .result = res, \
> > +       .errstr = res ? "no write support to 'struct sock' at off" : "", \
> > +       .prog_type = BPF_PROG_TYPE_LSM, \
> > +       .expected_attach_type = BPF_LSM_CGROUP, \
> > +       .kfunc = "socket_post_create", \
> > +       .fixup_ldx = { \
> > +               { "socket", "sk", 1 }, \
> > +               { tp, field, 2 }, \
> > +               { tp, field, 3 }, \
> > +       }, \
> > +}
> > +
> > +SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
> > +SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
> > +SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
> > +SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
> > +SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
> > +
>
> have you tried writing it as C program and adding the test to
> test_progs? Does something not work there?

Seems like it should work, I don't see any issues with writing 5
programs to test each field.
But test_verified still feels like a better fit? Any reason in
particular you'd prefer test_progs over test_verifier?
