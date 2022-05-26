Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDF353490C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 04:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiEZCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 22:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238848AbiEZCuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 22:50:55 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDE4BDA00
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:50:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j25so462354wrb.6
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GJfXzK7ODt1YwIKAywTBcsIg9rr1FO/xy5c9dfiLP6g=;
        b=j2eSIcf16y1t/MT/Zrq3CZb0dOkyIhwpvo6vEKFYcw90KuOiUyjoWnEGZsw/KSPvYz
         tqiesURBf8eXe40N/2jYgb40fPmdVO3d9LsIQdrlgLR3htepbAz24d7Ji9STO5i45+dq
         hJgeey5pJUOk46Ol7xzXG6I/RL0Ha4JDWWe8JtOuqNl44zSVSsdcCBxByw6sGl83BhMS
         MR/DA5yL7mne8iUiQW90VwZYufAqXIO9ZkQOSgHEWTpzNGfY6ycuBplMzD90iqurjszT
         vjXvy6c6bFc0k6c2f0iLwp93Syl5iWAQ9kx2Eu03vgX33QHFywYerNMmrveAf9Crclys
         /sdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GJfXzK7ODt1YwIKAywTBcsIg9rr1FO/xy5c9dfiLP6g=;
        b=ohMNwiR39e6iZC9Id67NSV6DorYMRoV5KXQ1exCqnk1l1qCbXHan/fWtGcbWMv0k6P
         wxYTmEQOliUQjeOfDDuPTGKyxnlia9ZV0p27JqjWVGRTg8a19igWf7I+NGY0YK7FX7m0
         xv8wh+XiwrvMu1H6mvBti4gjQC1dwu1EkiFg1ZTlHPBpUBYJG8AtC5xD0mvsC8dps4Si
         XLJf3C/FdLyPoCW8lmhd0FNCjyMFjCaoNGQcrtZGzu7IogkAlo1FCWR8jqIb2dK2Hy86
         E9QH5ItBIH9hbgXzQ8V4j3AWFa7JHA7AU9SrCD648SgOiKw0TVetTBQ2s7oxKeInC6Bi
         IvXA==
X-Gm-Message-State: AOAM5325z/2SVkeeJ8JGGjFSpPxSUwiitiXe4RENNXrx6SLmKCM5EYKQ
        iHGj1jwAt5gqxTPe+65mKs1UQFDEJmqqNs/p5IUhPjUQ/hJCpw==
X-Google-Smtp-Source: ABdhPJyVRSBH5zHIxkUQCT6Z9RzLs1dEfPTwt+/vwVUca4mxIaYcgXFY5JYGzg/r4Q5RiB4EPqUx6PbxvMr0XyZOMn0=
X-Received: by 2002:adf:f603:0:b0:210:ddf:e04d with SMTP id
 t3-20020adff603000000b002100ddfe04dmr15289wrp.463.1653533452779; Wed, 25 May
 2022 19:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp> <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
 <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp> <Yo6e4sNHnnazM+Cx@google.com>
 <20220526000332.soaacn3n7bic3fq5@kafai-mbp> <20220526012330.dnicj2mrdlr4o6oo@kafai-mbp>
In-Reply-To: <20220526012330.dnicj2mrdlr4o6oo@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 25 May 2022 19:50:41 -0700
Message-ID: <CAKH8qBskY75CtDuNcNrgV_5gm87qZO3zEZcLZO0zof2ty8zvdA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Wed, May 25, 2022 at 6:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, May 25, 2022 at 05:03:40PM -0700, Martin KaFai Lau wrote:
> > > But the problem with going link-only is that I'd have to teach bpftool
> > > to use links for BPF_LSM_CGROUP and it brings a bunch of problems:
> > > * I'd have to pin those links somewhere to make them stick around
> > > * Those pin paths essentially become an API now because "detach" now
> > >   depends on them?
> > > * (right now it automatically works with the legacy apis without any
> > > changes)
> > It is already the current API for all links (tracing, cgroup...).  It goes
> > away (detach) with the process unless it is pinned.  but yeah, it will
> > be a new exception in the "bpftool cgroup" subcommand only for
> > BPF_LSM_CGROUP.
> >
> > If it is an issue with your use case, may be going back to v6 that extends
> > the query bpf_attr with attach_btf_id and support both attach API ?
> [ hit sent too early... ]
> or extending the bpf_prog_info as you also mentioned in the earlier reply.
> It seems all have their ups and downs.

I'm thinking on putting everything I need into bpf_prog_info and
exporting a list of attach_flags in prog_query (as it's done here in
v7 + add attach_btf_obj_id).
I'm a bit concerned with special casing bpf_lsm_cgroup even more if we
go with a link-only api :-(
I can definitely also put this info into bpf_link_info, but I'm not
sure what's Andrii's preference? I'm assuming he was suggesting to do
either bpf_prog_info or bpf_link_info, but not both?
