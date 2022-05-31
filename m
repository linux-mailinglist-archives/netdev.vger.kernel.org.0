Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728A35399EE
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348618AbiEaXIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiEaXIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:08:51 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1805005A;
        Tue, 31 May 2022 16:08:50 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id e7so100450vkh.2;
        Tue, 31 May 2022 16:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rng1DtEmjOfsc28R1+vQxmPpAFzote6MnieP84LTVVQ=;
        b=gFAoyg4B6makpShZ73D7TERoEA1EYdTmgfo7LpPLkgpagLr1QLMwerizw8LCbOVzSz
         0z2JXJt7DYJnuaTelxmOk+nQoSvcYdfrmLTd7BqYaZJpKf2cXSo+SnuzL5kVlXrYkeNr
         6CWGVphPxaELhXQT4FC2fEd9hW6WUMOTd2ta7fZja7BmT17vPj6EdEkhZ6xASzXYyNzS
         yGGUm4Nndqdpmcd4X3OLogC5ZluscHuSWaVFsTFEtUOpI8/KnMYhtJJr8cCIV9xFoOof
         iPx9KcqGqISnqxE/lzGpY3Zd/8jqM7WaAYZ8i6V/N7oGtVxFCCJfugtgNTZN/X8rEhUq
         sKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rng1DtEmjOfsc28R1+vQxmPpAFzote6MnieP84LTVVQ=;
        b=ILirwEa5E7VCG2n5N5vBfxRwzJZ9S/ZwTC1xFbWmWi5f3kSTcH4dwaPBQOjcfNO+4p
         s9o56Gpcdx1fMqrQQrRONxKTexkFC++gFgqEQmza14RlHZ9anqtDocAyA+pzvD5Q5ivh
         o92yEf4yAHKmYrANUo6YTK/hzunWQz/LfJ2DRusKvKNvXwFAow99CZs4X6kCTtq4vZ7l
         SSNZoaj3pLbs7xrh2bkuOxk7GDZWUWU2fMx33IK84F3NhfbU//o+f1UTry6v60nwlLGX
         tSZ5o4c0p3D2WHQ1V9UjgSR1htaKqk34Ngodmpl4Rb7uwBufGQbgtUMi2TfDcnmmf0H3
         KdnA==
X-Gm-Message-State: AOAM531PT6QVNudU/fxY0jdUWv0GydgvgI3kSDmn6ictMp/fvg7SV7xt
        l1ZGwXRX2KRzxOVGnTVAQmVXQMnx4mon+PbRTp0=
X-Google-Smtp-Source: ABdhPJyvnnIcS6OzwHtYKKLDib5TGZkpZxD9p4cY9NeY3TXW6B2yOO3cF4H4Lmbu8yr+F7boe1k0rmjK2IdiCmsRnhE=
X-Received: by 2002:a1f:5907:0:b0:352:6327:926f with SMTP id
 n7-20020a1f5907000000b003526327926fmr23352593vkb.1.1654038529488; Tue, 31 May
 2022 16:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp> <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
 <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp> <Yo6e4sNHnnazM+Cx@google.com>
 <20220526000332.soaacn3n7bic3fq5@kafai-mbp> <20220526012330.dnicj2mrdlr4o6oo@kafai-mbp>
 <CAKH8qBskY75CtDuNcNrgV_5gm87qZO3zEZcLZO0zof2ty8zvdA@mail.gmail.com>
In-Reply-To: <CAKH8qBskY75CtDuNcNrgV_5gm87qZO3zEZcLZO0zof2ty8zvdA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 May 2022 16:08:38 -0700
Message-ID: <CAEf4BzbbvFnnZES0fivCAHbijKAium5C7uLmBp7zsYKn_ZM15g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 7:50 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Wed, May 25, 2022 at 6:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, May 25, 2022 at 05:03:40PM -0700, Martin KaFai Lau wrote:
> > > > But the problem with going link-only is that I'd have to teach bpftool
> > > > to use links for BPF_LSM_CGROUP and it brings a bunch of problems:
> > > > * I'd have to pin those links somewhere to make them stick around
> > > > * Those pin paths essentially become an API now because "detach" now
> > > >   depends on them?
> > > > * (right now it automatically works with the legacy apis without any
> > > > changes)
> > > It is already the current API for all links (tracing, cgroup...).  It goes
> > > away (detach) with the process unless it is pinned.  but yeah, it will
> > > be a new exception in the "bpftool cgroup" subcommand only for
> > > BPF_LSM_CGROUP.
> > >
> > > If it is an issue with your use case, may be going back to v6 that extends
> > > the query bpf_attr with attach_btf_id and support both attach API ?
> > [ hit sent too early... ]
> > or extending the bpf_prog_info as you also mentioned in the earlier reply.
> > It seems all have their ups and downs.
>
> I'm thinking on putting everything I need into bpf_prog_info and
> exporting a list of attach_flags in prog_query (as it's done here in
> v7 + add attach_btf_obj_id).
> I'm a bit concerned with special casing bpf_lsm_cgroup even more if we
> go with a link-only api :-(
> I can definitely also put this info into bpf_link_info, but I'm not
> sure what's Andrii's preference? I'm assuming he was suggesting to do
> either bpf_prog_info or bpf_link_info, but not both?

I don't care much, tbh. Whichever makes most sense to you.
