Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3194D4EFA11
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349544AbiDASo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344949AbiDASo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:44:27 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4669215934;
        Fri,  1 Apr 2022 11:42:37 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r11so2598284ila.1;
        Fri, 01 Apr 2022 11:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WwpAK3+BlmoGoKiUbBAI9EOaiCPyjOkskkGU3mSNOAA=;
        b=gp7VObEnEF9sTPUemKvfL/S219VI3l/lMTxp36UMxKcPhbvGQKKWFUJqZ/2qud069v
         3rKd0H0agbytfoUk9bFAIbUUO+OOWRm3gu8WllMUIbmYLHSscZKrh5enQPb8iNGNOnA/
         MErWUKASXY71EE6SKEUqCF5ipDOzEkdeZ+20ElQ8MlMuyP5kpIwL0aqk0+bEeTj8/OO1
         3ZmSbtOZvEXqcxFOassSjktFokJs2lpZNmbV7V6J0iwLblr2aN8wwcKxq9Vz+l4+/yR9
         UFMca8EzZq/6LGCmxpllMnso+KEe4oPnp1GDpIG3wELPViqUWqzj4RfFRO64WBXE08eN
         dYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WwpAK3+BlmoGoKiUbBAI9EOaiCPyjOkskkGU3mSNOAA=;
        b=I3S5PZVzG+RJajpi/EIggWaeiTZQacwga8QxXZTn2O99HZbx5t4idoCWbgio1TdzkF
         RONj9nSFP2zf0C2r33IYIzcNT5kH9oR22of5rOer/YVWHg98dIDflkAnnE9BsEMOZI7R
         4kRS9oKWrvDkDLdU5JJigfNnCJafpZxWyrEWlTBETbyYOXDTPnGUaCHGDlKSrqSImRyn
         y61CaP8Z0hbQG63lwgR9h0TOrs0YzQQ9NnnLv/kerVSN3N+HlmBTzB1ffpTOPsR2VgsT
         s92i7PTSCejCIcO+AOmgg3SGElktZjA9pa7uGYZRVdxv6/Pu0iQvezWb9jFcW44t82ju
         pRBg==
X-Gm-Message-State: AOAM533nkTUucAh5O87mK7+RPLnthlXWHqVgE0O5kcPGcsuEir6CFh7Y
        GEozIjIEa480u/V7Sawq8YCSF/3jFgfBJZXA8bFUtaAl
X-Google-Smtp-Source: ABdhPJx2AYXghttKZ0/hmuzpmYNV3HGuZmiizL0qWKvJWioaKcZAtNAnJj4AK6FuiaHJprszUdBDuvmo6xTEMFEqmUU=
X-Received: by 2002:a92:cd89:0:b0:2c9:bdf3:c5dd with SMTP id
 r9-20020a92cd89000000b002c9bdf3c5ddmr511748ilb.252.1648838557218; Fri, 01 Apr
 2022 11:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220331154555.422506-1-milan@mdaverde.com> <20220331154555.422506-4-milan@mdaverde.com>
 <8457bd5f-0541-e128-b033-05131381c590@isovalent.com>
In-Reply-To: <8457bd5f-0541-e128-b033-05131381c590@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Apr 2022 11:42:26 -0700
Message-ID: <CAEf4BzaqqZ+bFamrTXSzjgXgAEkBpCTmCffNR-xb8SwN6TNaOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf/bpftool: handle libbpf_probe_prog_type errors
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Milan Landaverde <milan@mdaverde.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Fri, Apr 1, 2022 at 9:05 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> > Previously [1], we were using bpf_probe_prog_type which returned a
> > bool, but the new libbpf_probe_bpf_prog_type can return a negative
> > error code on failure. This change decides for bpftool to declare
> > a program type is not available on probe failure.
> >
> > [1] https://lore.kernel.org/bpf/20220202225916.3313522-3-andrii@kernel.org/
> >
> > Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> > ---
> >  tools/bpf/bpftool/feature.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> > index c2f43a5d38e0..b2fbaa7a6b15 100644
> > --- a/tools/bpf/bpftool/feature.c
> > +++ b/tools/bpf/bpftool/feature.c
> > @@ -564,7 +564,7 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
> >
> >               res = probe_prog_type_ifindex(prog_type, ifindex);
> >       } else {
> > -             res = libbpf_probe_bpf_prog_type(prog_type, NULL);
> > +             res = libbpf_probe_bpf_prog_type(prog_type, NULL) > 0;
> >       }
> >
> >  #ifdef USE_LIBCAP
>

A completely unrelated question to you, Quentin. How hard is bpftool's
dependency on libcap? We've recently removed libcap from selftests, I
wonder if it would be possible to do that for bpftool as well to
reduce amount of shared libraries bpftool depends on.

> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
>
> Thanks!
