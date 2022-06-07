Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8215D542051
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385456AbiFHAVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835889AbiFGX5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:57:08 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E324E152D91;
        Tue,  7 Jun 2022 16:28:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id u23so30644137lfc.1;
        Tue, 07 Jun 2022 16:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dSdUSI+pkr071eJjV0UfGMvEDu/B3M5prSn6At+TTD4=;
        b=fayj0xnS/zMNX3SBFODhszyNfpChk9nJHPBQLFcmcNrn4g0Yaa3i6lDyJDgksIdOEN
         esM2prMgb1YWnMYb3YnF3zX1rCCH4J+NsTLOU8LCSNVDJm/pTyQBhQiMXvr+an3ETenH
         TGYIiKCceA3A09ELQpmWI4sRQkxQRJ/lym8AG4ICAsxa5y9yRuVpcKVd7t7QXK5Cl0pN
         iXmpqiFz25FK6ZpvJuChY9fteQ6q6XpBzX1RPObLC8je1hMvBiTmaFTrA+jL2BIJWNRG
         +hoLKEtk4bxR8vy15x01divw8vGMYcHucOAcjrsIWSKskRMLdm40CS72JyyRg+hrHfwQ
         iS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dSdUSI+pkr071eJjV0UfGMvEDu/B3M5prSn6At+TTD4=;
        b=fiS+d1WbBupUSLDTlxqnxdgIvSRfEsJQ3VROb7ByjG3I7iZ/jtDbE6VuHl84WBiFpp
         WE2wmmqXvozYxjuEB75ZuQ39S0Tm5GWqwUBDVBzBZkVlPR6WP3TrM2LBllaeVObqRmqk
         DaSzJ6VDm/NT2fQuvJMmDitJgFR8lpthVQlt776lwJO3tyo4s0umn8wlSuUlBp+TAOpr
         0U5FABqGYsMzugVUBvq/u6zx2OrGwjcGHsJDIIHWH+94rDjR93mH3dLRpoKgwKn4Irfk
         nx2lv7l6xna4oxT4Dw+4MGjrnIeZYRf4KmPNDVOUA72WgAtbXFg9CBWfrcODgAEJc7bS
         maRw==
X-Gm-Message-State: AOAM531HjZNXkmeyZ2IKnL0Bn7eiJ8mVBdCnGT5gqHTB07JtTu6vi5f3
        jGH/RHD8NkBHiGcPUFgRHEFwtui1P//4rNb6Wfo=
X-Google-Smtp-Source: ABdhPJwAIaVgb5p2NITx+Iv1UYfESkOLkKrb62lFlihYfZRxFfUJLu1Ft1rNlvyQ0BqbAcPHKIwJ1s79HN0vxmJnXsc=
X-Received: by 2002:a05:6512:685:b0:479:176c:5a5e with SMTP id
 t5-20020a056512068500b00479176c5a5emr15617763lfe.408.1654644528071; Tue, 07
 Jun 2022 16:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220607084003.898387-1-liuhangbin@gmail.com> <87tu8w6cqa.fsf@toke.dk>
In-Reply-To: <87tu8w6cqa.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jun 2022 16:28:36 -0700
Message-ID: <CAEf4BzYegArxq+apR+GZ+cYNQtAnnxaZWKOAKd+3tnqpKdq3ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Tue, Jun 7, 2022 at 2:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Hangbin Liu <liuhangbin@gmail.com> writes:
>
> > libbpf APIs for AF_XDP are deprecated starting from v0.7.
> > Let's move to libxdp.
> >
> > The first patch removed the usage of bpf_prog_load_xattr(). As we
> > will remove the GCC diagnostic declaration in later patches.
>
> Kartikeya started working on moving some of the XDP-related samples into
> the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> programs into that instead of adding a build-dep on libxdp to the kernel
> samples?
>

Agree. Meanwhile it's probably better to make samples/bpf just compile
and use xsk.{c,h} from selftests/bpf.

> -Toke
>
> [0] https://github.com/xdp-project/xdp-tools/pull/158
>
