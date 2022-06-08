Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE72542DBC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiFHKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiFHK3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:29:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C292914D5;
        Wed,  8 Jun 2022 03:18:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t2so17244795pld.4;
        Wed, 08 Jun 2022 03:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yCIN8zmtYKmUc6gE3sX4s+xs23+eE1y5zPsSpSsh+RY=;
        b=od2rKOLZW31v2f410YVvaGRCaMegoqlha4pAuZ+6iTjy4jC/3t0xNUlrJ0aeyj0zYQ
         5YlpioYTK96fYXl1YODDxOgJmxKAcoPOJ1h81KbvEOhS9l0E9Zn5Oz/MAibExPoHqCY1
         pMTWMUImVFNnPSBsZYVBo9p5by2qhxkit9E/OB4MihN+0jZM6G+NlguIQ7rI3ExS/SPs
         9TZVKEo8ZSmDIhX5ARzAPZPid66dCd6LIE+Rt4cwznggJa5lPjRc8b8qonNSsk5ULP2l
         ek+7k+CkrG9w/rJ7Wm4LCfSHITZoVdQ+6xokAa2PZTI6tktFKNqRiAncgRDBIlUYMCMT
         hMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yCIN8zmtYKmUc6gE3sX4s+xs23+eE1y5zPsSpSsh+RY=;
        b=fFhvutMXOo4JHxFMiMefKL46nENsTnGAVFGvwpw61iItfdtsqC1EeGDqVX94v4priH
         da6cZKPbKOypVyNHVGokTwsnoMT5cHHllpbY0BKuaH0T/+3OLpzZl0/iGJ4Mytso/28k
         EuLrGccjPSZYz+7vGfys29T54QDhwGF7yHIaFOdUmsqDplj4uKQXwYnWdCQ2XUIu8Yes
         0+yfEjiSLt9dq80nT/kwSa5ZOkVVxHSPFbPEImcgPxfDhqMOouOh+2Jh43426lY4AJfS
         /nPfkZpIC/Y/phDZQPpt8HtR2/0EPeYSYKGHC93DrYM+sjIMnywHs0gLQ+Qs870UI6eN
         AOrA==
X-Gm-Message-State: AOAM530thFyD7w1hLi/ibo+KXOiZXCaYFoFexYJrm9v8RkIyhcVzOegS
        1EgVm1q+rBg/+3clZuaq9TM3BiW/xpIsbNfoFWM=
X-Google-Smtp-Source: ABdhPJw6x5ViqrQr+9JfJUDr4HSVTFqTOUXtqq822wxaCeilpF/AjG+z1rzZDKrA4DWvqsPBRE+E2dPqspNPvcT0VSU=
X-Received: by 2002:a17:90b:1e42:b0:1e8:7669:8a1c with SMTP id
 pi2-20020a17090b1e4200b001e876698a1cmr18635833pjb.206.1654683505679; Wed, 08
 Jun 2022 03:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220607084003.898387-1-liuhangbin@gmail.com> <87tu8w6cqa.fsf@toke.dk>
 <YqAJeHAL57cB9qJk@Laptop-X1>
In-Reply-To: <YqAJeHAL57cB9qJk@Laptop-X1>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 8 Jun 2022 12:18:14 +0200
Message-ID: <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
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

On Wed, Jun 8, 2022 at 9:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Jun 07, 2022 at 11:31:57AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Hangbin Liu <liuhangbin@gmail.com> writes:
> >
> > > libbpf APIs for AF_XDP are deprecated starting from v0.7.
> > > Let's move to libxdp.
> > >
> > > The first patch removed the usage of bpf_prog_load_xattr(). As we
> > > will remove the GCC diagnostic declaration in later patches.
> >
> > Kartikeya started working on moving some of the XDP-related samples int=
o
> > the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> > programs into that instead of adding a build-dep on libxdp to the kerne=
l
> > samples?
>
> OK, makes sense to me. Should we remove these samples after the xdp-tools=
 PR
> merged? What about xdpxceiver.c in selftests/bpf? Should that also be mov=
ed to
> xdp-tools?

Andrii has submitted a patch [1] for moving xsk.[ch] from libbpf to
the xsk selftests so it can be used by xdpxceiver. This is a good idea
since xdpxceiver tests the low level kernel interfaces and should not
be in libxdp. I can also use those files as a start for implementing
control interface tests which are in the planning stages. But the
xdpsock sample shows how to use libxdp to write an AF_XDP program and
belongs more naturally with libxdp. So good that Kartikeya is moving
it over. Thanks!

Another option would be to keep the xdpsock sample and require libxdp
as in your patch set, but you would have to make sure that everything
else in samples/bpf compiles neatly even if you do not have libxdp.
Test for the presence of libxdp in the Makefile and degrade gracefully
if you do not. But we would then have to freeze the xdpsock app as all
new development of samples should be in libxdp. Or we just turn
xdpsock into a README file and direct people to the samples in libxdp?
What do you think?

[1] https://lore.kernel.org/bpf/20220603190155.3924899-2-andrii@kernel.org/

> Thanks
> Hangbin
