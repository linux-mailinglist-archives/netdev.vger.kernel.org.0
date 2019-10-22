Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F622DFE14
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 09:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfJVHQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 03:16:26 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34504 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfJVHQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 03:16:25 -0400
Received: by mail-qk1-f194.google.com with SMTP id f18so14719250qkm.1;
        Tue, 22 Oct 2019 00:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DKOZJivBfgaVZm/MQeBuy3v8RHDAFWBq9N66kk5jmfc=;
        b=c9xJ373S437DGaiEap0GE9l3QUNCAJ5Nsw3l930PxNs/HJfHVhsaOUpow2coauZSRL
         M3qtNheqBa6seYCRtzJUmLwufVbE6HzM+0tq1G4lhSGz8cKoZiKQa1knZTxHyU8ekEJU
         MV5MV20mzj9dJ6HakfxoTLCCaJJ4lkqLXiB8dS5OaeatuP+Hxj6QHZgJfT1yRgE0ifdi
         EcKM8xfUzTkN4Jw6rY6yYkGIuCVtl03wA0mxD6cvh03WovhXY7Y9I/OMXbbV48G6Y5g+
         rLDR1l75zMikxMJwLj3sJR7Kr90ngRRpWDjcyI5eqO0NUH7aPhHMO8rayFRCWyUN2GUe
         2HZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DKOZJivBfgaVZm/MQeBuy3v8RHDAFWBq9N66kk5jmfc=;
        b=mrjucnVrFOfCMmfBipveBjB8hl8QnL5vfq6nVJcIm3D57gL1CBozdZFdOjhOT0UXLC
         WVnqUkJg2NRbwRqkPmV/Lznk/rbLxM+x02Gg9irGoDcMFF2WA2RXHkdCD9lGrlNjrqA9
         oN5Y1yCUfTd+f/B5UNiEPNf8licM28YPaYau9U9WsxUCGsQdJcKvUO2wa5DEq1BuQDCm
         n4gtxDiiEayxqq2K426HSnGmvvgDf+DMPC6QUNo7v697fRMDrvlNHo5XC2ieqEMkcNhH
         2slrTfYrnh83jkrmQxIM/n13DpcOse6Vr+LK+i3WTEIT3B3DsOx8eN1Pa5mPEEClxbcX
         72ow==
X-Gm-Message-State: APjAAAXk8xGhSr79Ik+QLyTMaTPkdKlcprDjS+hDNwRih3K8b6qCJRqE
        tsGZcP+D6zVCEkHxWnF2bbScclhXCueBsF4WLHQ=
X-Google-Smtp-Source: APXvYqySyzVUtkSWsKxipWWsIg3m/CmZj0W+2GPAOg2ttPAfDnZKpnmIVzVe7+VOBz+oMC82UhGCBFydhfwCBOrMLuc=
X-Received: by 2002:a05:620a:132b:: with SMTP id p11mr1688653qkj.232.1571728582996;
 Tue, 22 Oct 2019 00:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk>
 <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com>
 <87bluaqoim.fsf@toke.dk> <CAJ+HfNgWeY7oLwun2Lt4nbT-Mh2yETZfHOGcYhvD=A+-UxWVOw@mail.gmail.com>
 <CAJ+HfNjd+eMAmeBnZ8iANjcea9ZT2cnvm3axuRwvUEMDpa5zHw@mail.gmail.com> <87v9sip0i8.fsf@toke.dk>
In-Reply-To: <87v9sip0i8.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 22 Oct 2019 09:16:11 +0200
Message-ID: <CAJ+HfNgGTL-P-Qe5zOh=s0RBRMJGx0NXDLTj7DAunwk-HoVdxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 at 17:43, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > On Mon, 21 Oct 2019 at 15:37, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >>
> >> On Mon, 21 Oct 2019 at 14:19, Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >> >
> >> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >> >
> >> [...]
> >> > >
> >> > > bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bi=
t
> >> > > will need to be cleared. Having an explicit AND is one instruction
> >> > > less than two shifts. So, it's an optimization (every instruction =
is
> >> > > sacred).
> >> >
> >> > OIC. Well, a comment explaining that might be nice (since you're doi=
ng
> >> > per-instruction comments anyway)? :)
> >> >
> >>
> >> Sure, I can do a v3 with a comment, unless someone has a better idea
> >> avoiding both shifts and AND.
> >>
> >> Thanks for taking a look!
> >>
> >
> > Now wait, there are the JMP32 instructions that Jiong added. So,
> > shifts/AND can be avoided. Now, regarding backward compat... JMP32 is
> > pretty new. I need to think a bit how to approach this. I mean, I'd
> > like to be able to use new BPF instructions.
>
> Well, they went into kernel 5.1 AFAICT; does AF_XDP even work properly
> in kernels older than that? For the xdp-tutorial we've just been telling
> people to upgrade their kernels to use it (see, e.g.,
> https://github.com/xdp-project/xdp-tutorial/issues/76).
>

Yeah, let's take that route, i.e. using JMP32 and one program. One
could argue that libbpf could do runtime checks and load the simpler
program w/o the fallback for post-5.3 only, and avoiding the branching
all together.


Bj=C3=B6rn


> -Toke
>
