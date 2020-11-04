Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717292A7040
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgKDWKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:10:39 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8FC0613D3;
        Wed,  4 Nov 2020 14:10:39 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id e27so6409676lfn.7;
        Wed, 04 Nov 2020 14:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yk2mj75i8xa8ayUVBQ83JlZDKWwjs6t8SW4iIqQ0FL8=;
        b=KANFOam0HlCtXCJKxEuU+poGR57CGLU6/zmeHIPrjcjIfkW00DexlF9LqBPk1p5pXq
         vxp8ESNn3E0OZNZeYDdCUJSLW/qJZx22Cf416XUH8J3ANooFmsCb8UIwmcc5XL22E5kO
         937DmY/OO5bps0pihshlNQy8MSGL+w5FjluXGJBdE9IkQZsYz85TASPkatJwHsR1x3in
         GZna+Lwq6va5sQtb6limwg+TU3Olwwbr5g1aaJKKfjcTOqYDdkXo6Hud1Jv0hxQJWGqg
         QA7HxRzsUkeCYRL5Acfx/1VySgVdi5cVudimmEe5fbvpuJpMu+QHbeNf0jKJT4xNcxk1
         Up+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yk2mj75i8xa8ayUVBQ83JlZDKWwjs6t8SW4iIqQ0FL8=;
        b=RKRRQGQ1mdFEiiLnOPCxy7sTYICFvpNtius7i4LYUaCEgiRkR2YKLOQ4k7lR8eRT3t
         GoMrOpFGrnevqrP2LqRmDvbiJdHrByjwrxwYEC3jjh1Hk4HLq6z9LWdt2yRImia8+038
         MU09nqvTfT9G3uTDaId8hc36eJUnHtyICopwxOKMQ3DKDYC2SCxqRLoH0HqlRX5vhj0F
         jaIYQ5uE7qTnTfNN159h3N8+W+I1lrmtripd3JGa4OFB+w3gb9N9V95twEt5YNFD6moo
         d3k01mdtrxv0k+IXYMKLQQknvT+ycpVPyihHdGkE1HvoxZ8/39aIfhpNWO7ji++qMVoZ
         Ahbw==
X-Gm-Message-State: AOAM531FWnPzNNsuuCg3DXku6FASwtlBXijA5zNzXQOZR3GXkWNCjBsq
        +tQ5+EmRZXpyZnmDFPsdzdex93TeLkyEsc2XUEM=
X-Google-Smtp-Source: ABdhPJz5XSkiQ1cv/9X7KUiC72fGiP+TjMWeNoh7HI4hGLD2ZP40tU35M5i5UPWTJDnGhRPZVmqhsgMlFOMeEjT3+pc=
X-Received: by 2002:ac2:5e83:: with SMTP id b3mr9823957lfq.119.1604527837537;
 Wed, 04 Nov 2020 14:10:37 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
In-Reply-To: <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Nov 2020 14:10:25 -0800
Message-ID: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Edward Cree <ecree@solarflare.com>
Cc:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 1:16 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 04/11/2020 03:11, Alexei Starovoitov wrote:
> > The user will do 'tc -V'. Does version mean anything from bpf loading pov?
> > It's not. The user will do "ldd `which tc`" and then what?
> Is it beyond the wit of man for 'tc -V' to output somethingabout
>  libbpf version?
> Other libraries seem to solve these problems all the time, I
>  haven't seen anyone explain what makes libbpf so special that it
>  has to be different.

slow vger? Please see Daniel and Andrii detailed explanations.

libbpf is not your traditional library.
Looking through the installed libraries on my devserver in /lib64/ directory
I think the closest is libbfd.so
Then think why gdb always statically links it.
