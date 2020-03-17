Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB9188DCC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgCQTOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:14:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35664 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQTOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:14:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id d8so34526850qka.2;
        Tue, 17 Mar 2020 12:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XV4ApXaEYXYRiwR3HMlKSbs60CuugfX5sLZu0E5ypyc=;
        b=eNAbwJ/wQQ5jkXW1B4/03eNtA1Veh7qduBfIdB5kug2ey7Wl2PfLsq7BdP/0SiM/9I
         jBlwxduW8lO8cvli+W3SKSS70FkfUt4JPUSWWStuj7NTnlWCHCYpnYJhUMp/5mM9nM5P
         A6InzYJvsQbw7OEtUR9iHB6C5PDzsKNWwFLTmoYMx1SPcISuJQrMvKve1Qoq9WmoinRy
         ZjAj5qP6untfWaT6b4ByUIiz/OrMIZVP3rTeY/0adyQ4qG/k3UPQb4D4I6sJ/PGIhHS5
         EwkK6SGB4PIV2eDJWpmCURAD3X95zLEE1KVpuu0SSj4KtjzJQMvkYT3ptOUbTkHggIlP
         vlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XV4ApXaEYXYRiwR3HMlKSbs60CuugfX5sLZu0E5ypyc=;
        b=i4T33Akqq4HhvqDMU6KiW2PhPFlmeCxKDp5pyTt3ft50lbiq1Dbksi11+vuWj/reO1
         Jc09lvYkPJTqSC5RuX/xLCnFH2OUj3C9pFErwr/y/LtYyPbSs/LXy2WwcS10xDV4ECrw
         xADk8+YyZQMU+CFPOwB18KrwQID5bMS2o1hEPtz/15iaO8fRECr0lpEZAIfPors4bP4t
         sXVH9ufmO60t1ad1O3yqaWKeTOkR3+Z+mn5QIQOIiU82qI/OnjmdqP3wlobBOXbAqfyp
         frP09pWavN18InMNW4/B5GppgM8txUcbWltnPbJGw+u6873W1+FPAYccMJ2tsBwAy8iQ
         5ZUw==
X-Gm-Message-State: ANhLgQ3+BoOANHzJWeAHh0aTJrf4IE6e7tJU6fPagA5c7G+b07wGH7RN
        dw7TWb+bXlTB8iATzStoOxiEV1L8qPCE/wpKdw0=
X-Google-Smtp-Source: ADFU+vsd8mwB+Yh1N4a9/NDu5lu8T2Blj+rDCmLzBPiHsNFcZKHqVbNLiA2N1vF3F5ps8w3eHR2jnAdn1ttALd2Sh4o=
X-Received: by 2002:a37:8046:: with SMTP id b67mr434146qkd.218.1584472460809;
 Tue, 17 Mar 2020 12:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200120092149.13775-1-bjorn.topel@gmail.com> <28b2b6ba-7f43-6cab-9b3a-174fc71d5a62@iogearbox.net>
 <CAJ+HfNj6dWLgODuHN82H5pXZgzYjx3cLi5WvGSoMg57TgYuRbg@mail.gmail.com> <20200316184423.GA14143@willie-the-truck>
In-Reply-To: <20200316184423.GA14143@willie-the-truck>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 17 Mar 2020 20:14:09 +0100
Message-ID: <CAJ+HfNh=XuCU3QBSbJZ-qEj-fx+JrB_iiJGpqKQmOwEjvAROpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: update rings for load-acquire/store-release semantics
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 at 19:44, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jan 21, 2020 at 12:50:23PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Tue, 21 Jan 2020 at 00:51, Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
> > >
> > > On 1/20/20 10:21 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > >
> > > > Currently, the AF_XDP rings uses fences for the kernel-side
> > > > produce/consume functions. By updating rings for
> > > > load-acquire/store-release semantics, the full barrier (smp_mb()) o=
n
> > > > the consumer side can be replaced.
> > > >
> > > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > If I'm not missing something from the ring update scheme, don't you a=
lso need
> > > to adapt to STORE.rel ->producer with matching barrier in tools/lib/b=
pf/xsk.h ?
> > >
> >
> > Daniel/John,
> >
> > Hmm, I was under the impression that *wasn't* the case. Quoting
> > memory-barriers.txt:
> >
> > --8<--
> > When dealing with CPU-CPU interactions, certain types of memory
> > barrier should always be paired.  A lack of appropriate pairing is
> > almost certainly an error.
> >
> > General barriers pair with each other, though they also pair with most
> > other types of barriers, albeit without multicopy atomicity.  An
> > acquire barrier pairs with a release barrier, but both may also pair
> > with other barriers, including of course general barriers.  A write
> > barrier pairs with a data dependency barrier, a control dependency, an
> > acquire barrier, a release barrier, a read barrier, or a general
> > barrier.  Similarly a read barrier, control dependency, or a data
> > dependency barrier pairs with a write barrier, an acquire barrier, a
> > release barrier, or a general barrier:
> > -->8--
>
> The key part here is "albeit without multicopy atomicity". I don't think
> you care about that at all for these rings as you're very clearly passing=
 a
> message from the producer side to the consumer side in a point-to-point l=
ike
> manner, so I think you're ok to change the kernel independently from
> userspace (but I would still recommend updating both eventually).
>
> The only thing you might run into is if anybody is relying on the smp_mb(=
)
> in the consumer to order other unrelated stuff either side of the consume
> operation (or even another consume operation to a different ring!), but i=
t
> looks like you can't rely on that in the xsk queue implementation anyway
> because you cache the global state and so the barriers are conditional.
>

Thanks for getting back, and for the clarification! I'll do a respin
(as part of a another series) that include the userland changes.

Cheers,
Bj=C3=B6rn

> Will
