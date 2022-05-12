Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782A452534C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbiELRLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245709AbiELRLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:11:41 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3941B522DB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:11:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h16so7473992wrb.2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbaBo0tTt+Cva9G8P4T0fup/a/USRSsQXGBn/3A6eC0=;
        b=HQIXePWzK3skOxKo/WNkTK2qMSDJPBP7ZTiW6GpWMo5ot3PH9jcBtSbQakdOq1+8PK
         Nv/W1gTFzrm+wqtvXoxXUfmvI6i+D5hiraP8BmfgXOg0fV2sgS8iEBDHqvWCXNAicsd6
         lv3DK0fSyQ/eYq4uJrljbZQPK1hbIlgz5Gi8Qwj6ng9yj9cRScA6HQExLepn3+HKBNVR
         SHmN5sYsOWBPqcd/VRkW97yDJgX6MmHZQg3gWTpr6mTsZMQS8VJ3fAdvGeMkHldFK1/Q
         f8AFs5ceXMcnSJ/b0p9U94xzgDNIxSkx/xjko260QBfwiFWL3GW1bkTYO1vzi5bD2gGV
         XteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbaBo0tTt+Cva9G8P4T0fup/a/USRSsQXGBn/3A6eC0=;
        b=GtS93+H9lUyxtoJ0zW5kvdTpJT/7QQMaw62UQCYmpxDLCsbQaTFh4N8l7RyuDvimQc
         h9wUxaUoqpOiI72+lV5K/N9/cCXt8hEoBBqs8sBYbiRyaBnSNm2O+gkeQJSBODn/By0H
         cre/zCwoHZ8g8753Og96ewuQoGr9YZTW8MX3eU1KRpGmFPKX4uVOsso0WxCE+3KhTl0x
         /SXHAXLxkMo9JvZTpvVVK4SeHKc4CYEkoPN+8CSRt1hzdx2ZmmQQUfoE/wxZMOHQFhLv
         IxXpOS1j7qXUqBMFcjRIzWKJ/XKLidlSD/uwUVOQgXcBJwFuThe+oVbdZKE5Z51K0/eR
         kSUQ==
X-Gm-Message-State: AOAM531uUaYVA1qyjd+l8QWv1opukHMaz+aVHmdeNkHBAeTfS4YgSxvr
        KsEtz/oBlYuiEnFfM8PhGnm8cqkJwdbLg/1oSavcDA==
X-Google-Smtp-Source: ABdhPJzS+KHIFt2i4JcT0YHnxCuNXi9kSQ8vsl2ND840iQcH8/sNqHLdoyfBphDmnoVI5uzOcn1EX6cFthwylISyqxE=
X-Received: by 2002:a05:6000:1682:b0:20c:588c:7dfa with SMTP id
 y2-20020a056000168200b0020c588c7dfamr582305wrd.15.1652375498513; Thu, 12 May
 2022 10:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-11-sdf@google.com>
 <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com>
 <CAKH8qBtk6CpR-29R6sWicz_zW=RCYUrXZqBZbgF9eqt4XGgNqQ@mail.gmail.com>
 <CAEf4BzZvVzHd9Sb=uH+614fq0wrht1wBAyG1zh6ZJg-_Qz0-rA@mail.gmail.com>
 <CAKH8qBv401RBdiouFD71JGZScG_oFD+3fUNav68JpzA=VWLkiA@mail.gmail.com> <CAEf4Bzb0Dnh49rwy8eFwoZK1ThOn-YQjcwXJiKbT-p7aATqEQw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb0Dnh49rwy8eFwoZK1ThOn-YQjcwXJiKbT-p7aATqEQw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 12 May 2022 10:11:27 -0700
Message-ID: <CAKH8qBuHU7OAjTMk-6GU08Nmwnn6J7Cw1TzP6GwCEq0x1Wwd9w@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 8:38 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 10, 2022 at 10:31 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Mon, May 9, 2022 at 4:44 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, May 9, 2022 at 4:38 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > On Mon, May 9, 2022 at 2:54 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Fri, Apr 29, 2022 at 2:16 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > >
> > > > > > sk_priority & sk_mark are writable, the rest is readonly.
> > > > > >
> > > > > > Add new ldx_offset fixups to lookup the offset of struct field.
> > > > > > Allow using test.kfunc regardless of prog_type.
> > > > > >
> > > > > > One interesting thing here is that the verifier doesn't
> > > > > > really force me to add NULL checks anywhere :-/
> > > > > >
> > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > ---
> > > > > >  tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
> > > > > >  .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
> > > > > >  2 files changed, 87 insertions(+), 1 deletion(-)
> > > > > >  create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > > > new file mode 100644
> > > > > > index 000000000000..af0efe783511
> > > > > > --- /dev/null
> > > > > > +++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > > > @@ -0,0 +1,34 @@
> > > > > > +#define SK_WRITABLE_FIELD(tp, field, size, res) \
> > > > > > +{ \
> > > > > > +       .descr = field, \
> > > > > > +       .insns = { \
> > > > > > +               /* r1 = *(u64 *)(r1 + 0) */ \
> > > > > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > > > > +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
> > > > > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > > > > +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
> > > > > > +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
> > > > > > +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
> > > > > > +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
> > > > > > +               BPF_MOV64_IMM(BPF_REG_0, 1), \
> > > > > > +               BPF_EXIT_INSN(), \
> > > > > > +       }, \
> > > > > > +       .result = res, \
> > > > > > +       .errstr = res ? "no write support to 'struct sock' at off" : "", \
> > > > > > +       .prog_type = BPF_PROG_TYPE_LSM, \
> > > > > > +       .expected_attach_type = BPF_LSM_CGROUP, \
> > > > > > +       .kfunc = "socket_post_create", \
> > > > > > +       .fixup_ldx = { \
> > > > > > +               { "socket", "sk", 1 }, \
> > > > > > +               { tp, field, 2 }, \
> > > > > > +               { tp, field, 3 }, \
> > > > > > +       }, \
> > > > > > +}
> > > > > > +
> > > > > > +SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
> > > > > > +SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
> > > > > > +SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
> > > > > > +SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
> > > > > > +SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
> > > > > > +
> > > > >
> > > > > have you tried writing it as C program and adding the test to
> > > > > test_progs? Does something not work there?
> > > >
> > > > Seems like it should work, I don't see any issues with writing 5
> > > > programs to test each field.
> > > > But test_verified still feels like a better fit? Any reason in
> > > > particular you'd prefer test_progs over test_verifier?
> > >
> > > Adding that fixup_ldx->strct special handling didn't feel like the
> > > best fit, tbh. test_progs is generally much nicer to deal with in
> > > terms of CI and in terms of comprehending what's going on and
> > > supporting the code longer term.
> >
> > This is not new, right? We already have a bunch of fixup_xxx things.
>
> I'm not saying it's wrong, but we don't have to keep adding extra
> custom fixup_xxx things and having hand crafted assembly test cases if
> we can do C tests, right? BPF assembly tests are sometimes necessary
> if we need to craft some special conditions which are hard to
> guarantee from Clang side during C to BPF assembly translation. But
> this one doesn't seem to be the case.
>
> > I can try to move this into test_progs in largely the same manner if
> > you prefer, having a C file per field seems like an overkill.
>
> You don't need a separate C file for each case. See what Joanne does
> with SEC("?...") for dynptr tests, or what Kumar did for his kptr
> tests. You can put multiple negative tests as separate BPF programs in
> one file with auto-load disabled through SEC("?...") and then
> open/load skeleton each time for each program, one at a time.

I'm gonna start with keeping the assembly, but moving it into
test_progs. I think it looks a bit nicer than the fixup stuff I'm
currently doing and I like how everything is in the same place. So
please yell at me if you still don't like it next time I send it out
and I'll try to explore SEC("?...").
