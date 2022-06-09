Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21AD5455A6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344749AbiFIUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344729AbiFIUaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:30:10 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C418295675;
        Thu,  9 Jun 2022 13:30:09 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id g25so27414083ljm.2;
        Thu, 09 Jun 2022 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Im/1dji55QotCSQ32JdC8nKliWN1E2VO9pn32O1vay4=;
        b=XBaW8tnJ3hxh7yGrgvzH5BLJhWkMX3X27iKWx+SyGXqPTZk64QZYsTE7qZYIb9XMmu
         SKIpUG157RO1sOYyx/1Iqi+r2rjlAllchlui3/Fg3iPfwAKQB13lQnT6bzF0L4bhjXI+
         gyJB5wjp5jvJMPHCWYT0I2R0yFdUE+pwkPneMl1wm55O/eDL7iEZ7DcCfHnBLaYSt3Lv
         xxymqosH2dFUPvd/zK/9F9rMg0qCTmq1RFAcocS1nF/Frh1tIvN3MzN2fupHPBFez41Z
         4mJzTcn98Bd9vIUCydJ/hUnILg1/01gpQcCAIe3f07vqnfcpdNsZET8tbnjmAMmJmMBE
         3wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Im/1dji55QotCSQ32JdC8nKliWN1E2VO9pn32O1vay4=;
        b=H/2n/dTurfsA27EW0VQf5SKjJO+qkBk3GDH4D2mq2EWG/p3SFAoN8xY+LMoThdNMiT
         Uya2mxSHBby+BqSr7LxSjbmMiVKsK4WqbJtzuz9QrAqQuJrpH1qxq9XDAsey4fPF6hwh
         WaIdngpteSxWxoVhMgtuXYM+5jm7dB0jZAdSBYThkbqN0D6XqjX2tHtpSTyJiNo1uNih
         81N1SJ891YhHOQcMjbDbMkIrJZS5ZUUgJ/2ipXvE6rWMZOPiKOC+FnAP2ZnRrYHwhzmx
         HPeOR/xEoerU4ENKB3LjuQof+cOJ42Mt2I615lCXwT3yNDSs6oV/Mc1Vv8YHEb2Lgcst
         iDvA==
X-Gm-Message-State: AOAM532raeF+Yh+gOO3jV25VmeXan9W5x45Zpj7aq49yMaqj4HnLMgRv
        Qx5voB/p/WqUrs7zr+5IU1OErrDjc458HDFljRs=
X-Google-Smtp-Source: ABdhPJy65AuRPY+RNbYh+M8zg6nJsGQ2kG2bHRZNWp3wmUepxtM9LV8iXjzr6gwHCup0zgjRxhkuyJJCytXfNde4w6E=
X-Received: by 2002:a2e:87c8:0:b0:255:6d59:ebce with SMTP id
 v8-20020a2e87c8000000b002556d59ebcemr22145411ljj.455.1654806607340; Thu, 09
 Jun 2022 13:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220607084003.898387-1-liuhangbin@gmail.com> <87tu8w6cqa.fsf@toke.dk>
 <YqAJeHAL57cB9qJk@Laptop-X1> <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
In-Reply-To: <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 13:29:55 -0700
Message-ID: <CAEf4BzZsAqq4rOpE2FWA-GHB4OSntv9rMUvt=6sOj6+1wKMMZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Wed, Jun 8, 2022 at 3:18 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Jun 8, 2022 at 9:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > On Tue, Jun 07, 2022 at 11:31:57AM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> > > Hangbin Liu <liuhangbin@gmail.com> writes:
> > >
> > > > libbpf APIs for AF_XDP are deprecated starting from v0.7.
> > > > Let's move to libxdp.
> > > >
> > > > The first patch removed the usage of bpf_prog_load_xattr(). As we
> > > > will remove the GCC diagnostic declaration in later patches.
> > >
> > > Kartikeya started working on moving some of the XDP-related samples i=
nto
> > > the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> > > programs into that instead of adding a build-dep on libxdp to the ker=
nel
> > > samples?
> >
> > OK, makes sense to me. Should we remove these samples after the xdp-too=
ls PR
> > merged? What about xdpxceiver.c in selftests/bpf? Should that also be m=
oved to
> > xdp-tools?
>
> Andrii has submitted a patch [1] for moving xsk.[ch] from libbpf to
> the xsk selftests so it can be used by xdpxceiver. This is a good idea
> since xdpxceiver tests the low level kernel interfaces and should not
> be in libxdp. I can also use those files as a start for implementing
> control interface tests which are in the planning stages. But the
> xdpsock sample shows how to use libxdp to write an AF_XDP program and
> belongs more naturally with libxdp. So good that Kartikeya is moving
> it over. Thanks!
>
> Another option would be to keep the xdpsock sample and require libxdp
> as in your patch set, but you would have to make sure that everything
> else in samples/bpf compiles neatly even if you do not have libxdp.
> Test for the presence of libxdp in the Makefile and degrade gracefully
> if you do not. But we would then have to freeze the xdpsock app as all
> new development of samples should be in libxdp. Or we just turn
> xdpsock into a README file and direct people to the samples in libxdp?
> What do you think?
>

I think adding libxdp dependency for samples/bpf is a bad idea. Moving
samples to near libxdp makes more sense to me.


> [1] https://lore.kernel.org/bpf/20220603190155.3924899-2-andrii@kernel.or=
g/
>
> > Thanks
> > Hangbin
