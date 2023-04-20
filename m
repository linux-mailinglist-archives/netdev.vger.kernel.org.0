Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C279E6E9FAA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjDTXH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDTXHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:07:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9164C1B;
        Thu, 20 Apr 2023 16:07:52 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so7040008a12.1;
        Thu, 20 Apr 2023 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682032071; x=1684624071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8wKZMZYXsnOjuLfzL5hDmHJwRUsAA27rAZvxX9HB4g=;
        b=iWoyx0gZpltiOKHboZzB7TKJkyi1IeTSsb7rWrg8slvtGN6289NnaSpW81eT63y7VC
         TUeOKuIjnsUOaI4OsbBfOzsgmsZrmM5KKvcvSA4MBjqNeO0BndV/ygmFB4/XoPO6Qydi
         Gfvvuji/nYWOx7ShaDEs2ZHmVzYCjjnwxKLQs8C7TjsZBXgzagkD8koCQEYydslQnDFm
         gJ6chqcMH91RijvO+tBzbdvrPuxLxMMCho4yjsMA/s5plodo2yPuVNs3zRbZTo5dolNZ
         dZH1IK+D/ispnH73x6oFJtdAekQwhuvKD1aFBHzNJd+xABULauP9xRXx2qsFxBowTcka
         eqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682032071; x=1684624071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8wKZMZYXsnOjuLfzL5hDmHJwRUsAA27rAZvxX9HB4g=;
        b=FVdZjvxszRYFKCjjrCyI61FU1Qt3wT4Rc7+YQOR5/9DHz7I65SE+dEf/8HsNK4L5bu
         f1CUxKbpgQh+7gKMyhncqZJdoI2DhmB6J4coGRLYXfO3xtagZz3QqicuWraBdWEGIhn5
         l4L8pL25hlqWisNROud6Wy31Y2dEFVXKHuCjv+0KKoMKexn3GJFVadFXV50G4wypr086
         gHq53H8zsmRxnDTe7IHaxWSN+mGCy/fuO5vzMsWdzLfxjd/IzbyG8f73p/l6vY/WVqEk
         qylkHqFHnMaZ69pBnNgZlSdpK1n+st8kenKiP4B2WnfGMe/qRvg1sBmRd+91dl0n9P5Q
         ujPg==
X-Gm-Message-State: AAQBX9c/hpcG5Y3WovXjCwwwlamFI6Fy5H6JUqHZpuude9k6EcXW5BkP
        Nfv1jMK2Zx0tWlQ8OxIhtl0Lp+RvPVJpEjGjMCU=
X-Google-Smtp-Source: AKy350Zaw1DbYbSOKVXb3Y32ptTldvDmu/rCMOrv9rJDvySvoKwX/B4TujNjIOhzCdsyGNBp/+4QQelBb+vXL/HORgE=
X-Received: by 2002:a05:6402:3592:b0:506:bd27:a2f0 with SMTP id
 y18-20020a056402359200b00506bd27a2f0mr7747135edc.15.1682032070510; Thu, 20
 Apr 2023 16:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220421003152.339542-1-alobakin@pm.me> <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz> <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
 <20230414162821.GK63923@kunlun.suse.cz>
In-Reply-To: <20230414162821.GK63923@kunlun.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Apr 2023 16:07:38 -0700
Message-ID: <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix
 accessing its fields
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Apr 14, 2023 at 9:28=E2=80=AFAM Michal Such=C3=A1nek <msuchanek@sus=
e.de> wrote:
>
> On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
> > From: Michal Such=C3=A1nek <msuchanek@suse.de>
> > Date: Fri, 14 Apr 2023 11:54:57 +0200
> >
> > > Hello,
> >
> > Hey-hey,
> >
> > >
> > > On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
> > >> When building bpftool with !CONFIG_PERF_EVENTS:
> > >>
> > >> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type =
'struct bpf_perf_link'
> > >>         perf_link =3D container_of(link, struct bpf_perf_link, link)=
;
> > >>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: =
note: expanded from macro 'container_of'
> > >>                 ((type *)(__mptr - offsetof(type, member)));    \
> > >>                                    ^~~~~~~~~~~~~~~~~~~~~~
> > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: =
note: expanded from macro 'offsetof'
> > >>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBE=
R)
> > >>                                                   ~~~~~~~~~~~^
> > >> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct b=
pf_perf_link'
> > >>         struct bpf_perf_link *perf_link;
> > >>                ^
> > >>
> > >> &bpf_perf_link is being defined and used only under the ifdef.
> > >> Define struct bpf_perf_link___local with the `preserve_access_index`
> > >> attribute inside the pid_iter BPF prog to allow compiling on any
> > >> configs. CO-RE will substitute it with the real struct bpf_perf_link
> > >> accesses later on.
> > >> container_of() is not CO-REd, but it is a noop for
> > >> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
> > >> the original structure.
> > >>
> > >> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > >
> > > This does not solve the problem completely. Kernels that don't have
> > > CONFIG_PERF_EVENTS in the first place are also missing the enum value
> > > BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling =
the
> > > cookie.
> >
> > Sorry, I haven't been working with my home/private stuff for more than =
a
> > year already. I may get back to it some day when I'm tired of Lua (curs=
e
> > words, sorry :D), but for now the series is "a bit" abandoned.
>
> This part still appllies and works for me with the caveat that
> BPF_LINK_TYPE_PERF_EVENT also needs to be defined.
>
> > I think there was alternative solution proposed there, which promised t=
o
> > be more flexible. But IIRC it also doesn't touch the enum (was it added
> > recently? Because it was building just fine a year ago on config withou=
t
> > perf events).
>
> It was added in 5.15. Not sure there is a kernel.org LTS kernel usable
> for CO-RE that does not have it, technically 5.4 would work if it was
> built monolithic, it does not have module BTF, only kernel IIRC.
>
> Nonetheless, the approach to handling features completely missing in the
> running kernel should be figured out one way or another. I would be
> surprised if this was the last feature to be added that bpftool needs to
> know about.

Are we talking about bpftool built from kernel sources or from Github?
Kernel source version should have access to latest UAPI headers and so
BPF_LINK_TYPE_PERF_EVENT should be available. Github version, if it
doesn't do that already, can use UAPI headers distributed (and used
for building) with libbpf through submodule.

>
> Thanks
>
> Michal
