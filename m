Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9B19A1BF
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 00:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbgCaWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 18:16:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44640 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgCaWQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 18:16:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id b72so11034131pfb.11;
        Tue, 31 Mar 2020 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OBuQzCEQi0PqZRU3WMKWxzfOWVwx3+pYDNPDQ0ltveI=;
        b=ZFFjB0U8bT6q630ouARTHMTTH75fudntvIGn00zgf6RCw6P9HPNjI46LL6aUI2LqWe
         D7I9nqcd6hO04Mks4kXqGAxOsVmo8yEDpiZ/KlOICxQaygdD9CNUFVveBjoLC3HzwITo
         AcqCO40pJCX6JSyQmA1V7ReU+iTzBZ8lrAj52EuvYWCsS8KFVP0SbJfKJAZnkowl8YnX
         6rR8WiWUCW4kJ4JhgPB42Q4VKFjZeQJUkB+ff0BY9McK2wB/mZBZddpgQZ/4NkxXfjcR
         R+mbGKQ9jzNNew0OfbV/qJD6+TnZ3PCEaqxEnLXm/UeGRXZuaptLVtBxAfXfzAAWr17z
         Gi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OBuQzCEQi0PqZRU3WMKWxzfOWVwx3+pYDNPDQ0ltveI=;
        b=TaQe8P2CwBxGlSRc9c4RbEnvm/vfta2uRgzzs66S85YndLKrCguowHhGAu/uiRwNso
         dxXzR//I4PS7+FXTk4QNjWwvSu8JmD0ph59FGnbNC8ZHmDaqm96BMO/bVvvpijba1isj
         yT0Ugc5LM6Hrhtteqf88A2HocWeJazXsp/Wn3VRZijZdvw8d0P4/S9wlcGrmO9vp9mfh
         f7KQSMfSxnP2GNSYpso/Knr0b0QPNCZemKS2TUSjUbib3RWEOWTmzx3VEW5ctm4cii1G
         +liErHf0vxHQrKmn/7FdKMJrt8oKchQz2JS9xpYvPrexpvin/gWTataN0Lx1xSyjpVpM
         LJeQ==
X-Gm-Message-State: ANhLgQ1r0R9uBvIVcg1FeWkfHAA5PPwTOv08iotKNcidnrS6mOQUnxi2
        aQlJgRDTtxy7MAxNh/nMUJ0=
X-Google-Smtp-Source: ADFU+vt3xRj1b+xkbqDVvnv5034gAGCn85C0Nqn59rDRIn6rGM4SYqyty879rk9o7y3gz+WiRmNX3w==
X-Received: by 2002:a63:6f45:: with SMTP id k66mr20352554pgc.246.1585692979758;
        Tue, 31 Mar 2020 15:16:19 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8a85])
        by smtp.gmail.com with ESMTPSA id f22sm28811pgl.20.2020.03.31.15.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 15:16:18 -0700 (PDT)
Date:   Tue, 31 Mar 2020 15:16:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Ahern <dsahern@gmail.com>, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200331221613.uwk6vmlrwggbj4s7@ast-mbp>
References: <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
 <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
 <20200327230253.txq54keztlwsok2s@ast-mbp>
 <eba2b6df-e2e8-e756-dead-3f1044a061cd@solarflare.com>
 <20200331034319.lg2tgxxs5eyiqebi@ast-mbp>
 <8c55c053-ab95-3657-e271-dd47c1daaf5e@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c55c053-ab95-3657-e271-dd47c1daaf5e@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 11:05:50PM +0100, Edward Cree wrote:
> On 31/03/2020 04:43, Alexei Starovoitov wrote:
> > On Mon, Mar 30, 2020 at 04:25:07PM +0100, Edward Cree wrote:
> >> Everything that a human operator can do, so can any program with the
> >>  same capabilities/wheel bits.  Especially as the API that the
> >>  operator-tool uses *will* be open and documented.  The Unix Way does
> >>  not allow unscriptable interfaces, and heavily frowns at any kind of
> >>  distinction between 'humans' and 'programs'.
> > can you share a link on such philosophy?
> It's not quite as explicit about it as I'd like, but
>  http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2877684
>  is the closest I can find right now.

I knew the bit you linked and I've read several "Rule of" up and down
in that doc and still don't see any mention of 'humans' vs 'programs'.
Unix philosophy can be rephrased as divide-and-conquer which is #1
principle in bpf architecture. In other words: build the smallest
possible mechanisms that are composable.
