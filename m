Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4494BEF0D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiBVBtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 20:49:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiBVBtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 20:49:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC63425C4E;
        Mon, 21 Feb 2022 17:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482B261487;
        Tue, 22 Feb 2022 01:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8E9C340E9;
        Tue, 22 Feb 2022 01:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645494528;
        bh=S9TxefCeXQCOUZ6D19FyayuauuaqtfzAGYJ7COJEcVk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nExl3/nb+NKaXoksFTavxexjIeQcMxPRmP2dfLSwzL58GIJiCiH6oWuvqJ5SGQ6A+
         Alw6CrA1lFDjTY56sMrO+gHgU5a/Kc4Wq7waJRvAVfh/D8uDZ1vIh++gvf74IxS8dG
         mviqsnsexKxGZjsDy4UB7W0nf0rpkXGmPlSPe3p4MWo1dU/LsQ7fCvUdsNd5BDbl37
         SVhMn+q+l/qlGC22QKBdJRbdwAQzVCMSez7RHDUYLrf3JCSEY0gdogL3d/pt+fzm/3
         Yc8kNRUN6WjMGD2ooAIV6pa3ja58uYAI9rMG6BxTEt101JeTrMCcO+fXACa5mu4F0j
         VtSjGynGQFIfA==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2d79394434dso14602327b3.5;
        Mon, 21 Feb 2022 17:48:48 -0800 (PST)
X-Gm-Message-State: AOAM5312Lw7/ZYoSCTYf9/Tjv4maNjGvqIpr+KWo34epUb954CYTyLNS
        qWPlO5GlC+uyLZ+goVBJJYGGuzPtxouVhau8riw=
X-Google-Smtp-Source: ABdhPJxn6W5ZJlfQB0WZuhICe+tXsoTPFFFrHg7xRSqBNkby9ZvDtTQR0NUbs0JXGTnD8SgPsduOUQHVLxpt78jVZZ4=
X-Received: by 2002:a0d:ea0a:0:b0:2d6:93b9:cda1 with SMTP id
 t10-20020a0dea0a000000b002d693b9cda1mr22092300ywe.460.1645494527807; Mon, 21
 Feb 2022 17:48:47 -0800 (PST)
MIME-Version: 1.0
References: <20220221125617.39610-1-mauricio@kinvolk.io> <f2c11f1a-ab7d-2d7b-7583-d1edb94cace9@isovalent.com>
In-Reply-To: <f2c11f1a-ab7d-2d7b-7583-d1edb94cace9@isovalent.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Feb 2022 17:48:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6fRNOOckuULrbkjPdZdZTCeWTu3zv5HJsm=0+=qD0eww@mail.gmail.com>
Message-ID: <CAPhsuW6fRNOOckuULrbkjPdZdZTCeWTu3zv5HJsm=0+=qD0eww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: Remove usage of reallocarray()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 7:48 AM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> 2022-02-21 07:56 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > This commit fixes a compilation error on systems with glibc < 2.26 [0]:
> >
> > ```
> > In file included from main.h:14:0,
> >                  from gen.c:24:
> > linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use po=
isoned "reallocarray"
> >  static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
> > ```
> >
> > This happens because gen.c pulls <bpf/libbpf_internal.h>, and then
> > <tools/libc_compat.h> (through main.h). When
> > COMPAT_NEED_REALLOCARRAY is set, libc_compat.h defines reallocarray()
> > which libbpf_internal.h poisons with a GCC pragma.
> >
> > This commit reuses libbpf_reallocarray() implemented in commit
> > 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf").
> >
> > v1 -> v2:
> > - reuse libbpf_reallocarray() instead of reimplementing it
> >
> > Reported-by: Quentin Monnet <quentin@isovalent.com>
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> >
> > [0]: https://lore.kernel.org/bpf/3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@i=
sovalent.com/
>
> Fixes: a9caaba399f9 ("bpftool: Implement "gen min_core_btf" logic")
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Song Liu <songliubraving@fb.com>
