Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1368F5320D1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiEXCPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiEXCPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:15:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E9C9CCBE
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:15:30 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v191-20020a1cacc8000000b00397001398c0so582779wme.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=muL8b64Pp6kaxWu77c45PCZ8HuHx5jG9bLj/hnhVeK0=;
        b=o+QbVLXkFDFeU2SlI1fmlEFB+6cGdQUULFVbbrD/mMrYTOOhHoeTi1iSjXz55xgkLx
         DZMAUuijVuwzj7VKG0kCsL8jVq6qwZvDPGavYs/KN/CGHKJfnO0REG3hhbhGqerW4b2K
         KgwUAlCBj1hgCQOGeqeqa9jLznFMVVDYtLJO8dNIRcZNNbtssoOydjEZSg2GXDwOb9Sx
         vGnEEZfYGqWdbdEsanRUGeFFhcnBa55JQ+St4HiIRzZcExsSoeRy1CtVcTgspVJFkY2W
         SPUR2LrCFss/I9MRcdyIIC0e+SoC2gt2S1vyuhKKdt+ULty/e4HfNqWzpfCJPWriCftk
         Fwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=muL8b64Pp6kaxWu77c45PCZ8HuHx5jG9bLj/hnhVeK0=;
        b=WrUOEo43E8CtCD1Vg6DSdZvSK3wW/C/TVQcH3/M49KrFxvZdvlTbW0BKCcVsP21oHI
         yALqqfP4ZFQ5aFjhz+k2YdcVOnbUlV56gml+e0tQ0fhF7gHZSMarihvTnXqW1DNE2P46
         kUM0aks8dlZB7u3p0VdvicXCkDrWvJE9rsEWI9450v68oIXmLP5mXTBb2m4pzsblPiUx
         N5gl7CPNuqImDWCLkHOMTEZlBdbtQBqul/Zaa6izOUitMYEqqQuzQqeLCw4CBsySYVCf
         y0e2lCHjP//daaiRTjg8RCcMm5mckRPIMC9XMt4R7ezSPuz60MvjjHyX+q38gRh99mmL
         ditg==
X-Gm-Message-State: AOAM531nC/BFghogneEb4X/SeQpOzSX4nFgHeFx9Eu34XiMMjNfqFsbX
        pXEehqS6THfUvnEsfZW+ACpdAshiRmjxkOrMYGHYacZkZBI=
X-Google-Smtp-Source: ABdhPJwSDlj1ctjYz34tqFMzLjXYLaqIQTUEFNrObdQSTLyM1Qo9v3U3926jMfw/A7QHheI1badsVgTmT1dSHvyXPVI=
X-Received: by 2002:a05:600c:a03:b0:395:bc75:61eb with SMTP id
 z3-20020a05600c0a0300b00395bc7561ebmr1607860wmp.46.1653358529160; Mon, 23 May
 2022 19:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-6-sdf@google.com>
 <CAEf4BzYxHsB3D-HT7H1zZsSDEjz_cU7FpfgFnVVzbe5qA4=dYg@mail.gmail.com>
In-Reply-To: <CAEf4BzYxHsB3D-HT7H1zZsSDEjz_cU7FpfgFnVVzbe5qA4=dYg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 23 May 2022 19:15:17 -0700
Message-ID: <CAKH8qBu9fMvhi7pOOKc35m8s5ckWT7M5SW5mupFTv-AzixwpFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
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

On Mon, May 23, 2022 at 4:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > We have two options:
> > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> >
> > I was doing (2) in the original patch, but switching to (1) here:
> >
> > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > regardless of attach_btf_id
> > * attach_btf_id is exported via bpf_prog_info
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/uapi/linux/bpf.h |   5 ++
> >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> >  kernel/bpf/syscall.c     |   4 +-
> >  3 files changed, 81 insertions(+), 31 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b9d2d6de63a7..432fc5f49567 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1432,6 +1432,7 @@ union bpf_attr {
> >                 __u32           attach_flags;
> >                 __aligned_u64   prog_ids;
> >                 __u32           prog_cnt;
> > +               __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> >         } query;
> >
> >         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> >         __u64 run_cnt;
> >         __u64 recursion_misses;
> >         __u32 verified_insns;
> > +       /* BTF ID of the function to attach to within BTF object identified
> > +        * by btf_id.
> > +        */
> > +       __u32 attach_btf_func_id;
>
> it's called attach_btf_id for PROG_LOAD command, keep it consistently
> named (and a bit more generic)?
>
> >  } __attribute__((aligned(8)));
> >
> >  struct bpf_map_info {
>
> [...]

SG. Making it generic makes sense.
