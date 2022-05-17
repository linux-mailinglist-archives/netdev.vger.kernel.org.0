Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A35529912
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiEQF3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbiEQF3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:29:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72AC2ED59;
        Mon, 16 May 2022 22:29:33 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w200so45703pfc.10;
        Mon, 16 May 2022 22:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2r2YJ9z8/DlhBwQrlo+ggv+RrmXk5WJX+ZtmBwlTjKY=;
        b=RNoBKzsGttlzdKQnPiEJnG221x14PCjwsW3kj6CyvCAyVnlJy//Q/L5IiS6i3I/4Or
         6kVpWRUjXT8ZLhTQlb73/K9rc6Wsd71AvMwt3KmCdc8ZQHKrdiJvnSRa7k4h7RYMPixC
         GbQCwL61QiDJ5e0Jgy8vxk+TBeKWzBu++gYkHKoe+LQxtkwm136+wFKtUtrmN0x9mduD
         3NDu4dfExBqDNNVl8L6d+WQn3lEjgnxd14ZLKZhIMMDvKjVsBYwGAvOM2CAJlda9be9m
         fxDuex7zrjhiz0ozCU+LWmu3xZ6ErKg9ZDk9unkYhw/J3YFphzllF/0hdOjuvGeM4Bpn
         Y8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2r2YJ9z8/DlhBwQrlo+ggv+RrmXk5WJX+ZtmBwlTjKY=;
        b=mC3kLwemdULweIoHiHvXA8/OiV+ZcpWvAgmg5fdkU3SDppJxbLMDOFLe58ljne1vgh
         V5kpES6nNF8P2Ck7g3/T5Sv8O6exzM6a6sdcN3hsvBXtw0J4NQhjmw9C8GV7wDOXIcyl
         o0Mvts/ZK21EbmHzW6IKp5q16MNv575Pfs4Gp8KPXXXTzHhnECPj5Zv269a4E5GZMlgj
         1c4+xhtYl/Rp1WTkRvXLYVqFR71TB2e2JHzBL3I3biSYSWtDUplSmnOLEooF/50r3FPB
         V8x26sslFJKG/ULCScctH0Ut8ZmH7jzH1I4e7AJgW1jZZt0uojjun4oLM/a7xSZhli+7
         b6eg==
X-Gm-Message-State: AOAM533oLsxs3tIdOCK04MMGIdTkgg9G+91Ydzyx2QbG9kllwrMef+gL
        YgGdB0IhZNdB722JhGxLfBNmyxYdzGaxoMpg8fA=
X-Google-Smtp-Source: ABdhPJyuzkoGE0IPDE8V1GtC5Nvtgct3xyNNq9kPHWgNhHMepyfq8l+meuY3A7PoqdT0NztEm1jSmu0ONXVb4Mu+oY8=
X-Received: by 2002:a05:6a00:1a47:b0:510:a41b:362d with SMTP id
 h7-20020a056a001a4700b00510a41b362dmr21017741pfv.30.1652765373434; Mon, 16
 May 2022 22:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-5-mathew.j.martineau@linux.intel.com> <20220517012055.loesbaunau2bxbt5@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220517012055.loesbaunau2bxbt5@kafai-mbp.dhcp.thefacebook.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Tue, 17 May 2022 13:29:35 +0800
Message-ID: <CA+WQbwtWUqK_dR5Chpfg3S9nbTNEi20YqSJkh10MVcaVSQeeJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=8C 09:21=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 13, 2022 at 03:48:24PM -0700, Mat Martineau wrote:
> [ ... ]
> > diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/tes=
ting/selftests/bpf/progs/mptcp_sock.c
> > index bc09dba0b078..3feb7ff578e2 100644
> > --- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
> > +++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> > @@ -7,6 +7,7 @@
> >  #include "bpf_tcp_helpers.h"
> >
> >  char _license[] SEC("license") =3D "GPL";
> > +extern bool CONFIG_MPTCP __kconfig;
> >
> >  struct mptcp_storage {
> >       __u32 invoked;
> > @@ -24,6 +25,7 @@ SEC("sockops")
> >  int _sockops(struct bpf_sock_ops *ctx)
> >  {
> >       struct mptcp_storage *storage;
> > +     struct mptcp_sock *msk;
> >       int op =3D (int)ctx->op;
> >       struct tcp_sock *tsk;
> >       struct bpf_sock *sk;
> > @@ -41,11 +43,24 @@ int _sockops(struct bpf_sock_ops *ctx)
> >               return 1;
> >
> >       is_mptcp =3D bpf_core_field_exists(tsk->is_mptcp) ? tsk->is_mptcp=
 : 0;
> > -     storage =3D bpf_sk_storage_get(&socket_storage_map, sk, 0,
> > -                                  BPF_SK_STORAGE_GET_F_CREATE);
> > -     if (!storage)
> > -             return 1;
> > +     if (!is_mptcp) {
> > +             storage =3D bpf_sk_storage_get(&socket_storage_map, sk, 0=
,
> > +                                          BPF_SK_STORAGE_GET_F_CREATE)=
;
> > +             if (!storage)
> > +                     return 1;
> > +     } else {
> > +             if (!CONFIG_MPTCP)
> hmm... how is it possible ?  The above just tested "!is_mptcp".

Will drop this in v5, thanks.

>
> > +                     return 1;
> > +
> > +             msk =3D bpf_skc_to_mptcp_sock(sk);
> > +             if (!msk)
> > +                     return 1;
> >
> > +             storage =3D bpf_sk_storage_get(&socket_storage_map, msk, =
0,
> > +                                          BPF_SK_STORAGE_GET_F_CREATE)=
;
> > +             if (!storage)
> > +                     return 1;
> > +     }
> >       storage->invoked++;
> >       storage->is_mptcp =3D is_mptcp;
> >
> > --
> > 2.36.1
> >
>
