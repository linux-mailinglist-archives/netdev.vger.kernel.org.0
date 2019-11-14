Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AABFC831
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKNN4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:56:19 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36088 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfKNN4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:56:18 -0500
Received: by mail-qt1-f196.google.com with SMTP id y10so6864870qto.3;
        Thu, 14 Nov 2019 05:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GR2keDSS6Ecy97PPzanGU4w7wjE7bCwqVAMt5IDxed8=;
        b=aBYuSw6NDBRvMmetNJuJsMoqb39TvRRrZxA66BSGlkJvrfv0M6FHiOwqsWiPq4aTwZ
         qf0aYxEVOi3/E+qkjnG7toGpHvUCtIXhIqKF+llUfDHWT09uD+8ts80wtZamzNYEC4ZL
         qRnvz3ZH/J/el8m9kIas3GNtn030UtmpnpkQlrkooBfIm9la4Km1C8LXNe/tPNf0WjRs
         onv08UWQyheM48bPZjWtrUsN7ASDeveaowvSVVHl317pAsUizNzwLTh/Gpq1w0CHPR/o
         itfU1JxVWxfONUZeYItE3kF6oXyUTX9ELAdkVR9fPefVbHGnjCvb34H1W9dqrG1eB2In
         4mDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GR2keDSS6Ecy97PPzanGU4w7wjE7bCwqVAMt5IDxed8=;
        b=Kxcf/nKIbZDV5gk36rw7pkTLcEnXLSdD9yDhqw8RXlPpAINOuk/Vex/UxSL120Dv9H
         NUkB9NbpVr+9JQcqFWxj2Itj7iA2DBWE6kAIjUmQPUwSQCVt8e5H6/tYWkbxa8MfPS9F
         pThK2Du8IFWWU5WenrbCDFGF9K0MggKGSPRqFD046EE6qobmR15ZXQAUIIs9VFoxOk8F
         PU9vaXBCMC7Hh9As+xJUfS1zlvYTcCj/8H/ZyXI52dkMO84X9Kd3VwlidtrfkDfw+pez
         pb3UnGV4gujvS28b3D/pyAZnBzaaTkJ+m2sZl4fqpXG35GaRZRVvIfARXFNhxDvIAqg3
         Hmkg==
X-Gm-Message-State: APjAAAWlSkScpL8+rSknFuRJHrl+WeOdfIrT0bJbsYZux1hE0gvkOTnF
        GjmcoMGa5dZzEVYm4MQwd9PXRrrZ00PObIPWHmo=
X-Google-Smtp-Source: APXvYqzbH6dJGvoV3Qi73WsY9DguGWnnC8c5RWqxy9CbOAHjQp07jqJAi2lYOZjB+xiK6BqCT00nC3a0UTlNpSc2Ayo=
X-Received: by 2002:aed:3ef2:: with SMTP id o47mr8458261qtf.107.1573739777271;
 Thu, 14 Nov 2019 05:56:17 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <87o8xeod0s.fsf@toke.dk> <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net>
In-Reply-To: <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 14 Nov 2019 14:56:06 +0100
Message-ID: <CAJ+HfNhPhCi4=taK7NcYuCvdcRBXVDobn7fpD3mi1eppTL7zLA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 at 14:03, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/14/19 1:31 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> The BPF dispatcher builds on top of the BPF trampoline ideas;
> >> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> >> code. The dispatcher builds a dispatch table for XDP programs, for
> >> retpoline avoidance. The table is a simple binary search model, so
> >> lookup is O(log n). Here, the dispatch table is limited to four
> >> entries (for laziness reason -- only 1B relative jumps :-P). If the
> >> dispatch table is full, it will fallback to the retpoline path.
> >
> > So it's O(log n) with n =3D=3D 4? Have you compared the performance of =
just
> > doing four linear compare-and-jumps? Seems to me it may not be that big
> > of a difference for such a small N?
>
> Did you perform some microbenchmarks wrt search tree? Mainly wondering
> since for code emission for switch/case statements, clang/gcc turns off
> indirect calls entirely under retpoline, see [0] from back then.
>

As Toke stated, binsearch is not needed for 4 entries. I started out
with 16 (and explicit ids instead of pointers), and there it made more
sense. If folks think it's a good idea to move forward -- and with 4
entries, it makes sense to make the code generator easier, or maybe
based on static_calls like Ed did.

As for ubenchmarks I only compared with 1 cmp, vs 3 vs 4 + retpoline
stated in the cover. For a proper patch I can do more in-depth
analysis. Or was it anything particular you were looking for?

For switch/case code generation there's a great paper on that here [3]
from the 2008 GCC dev summit ("A Superoptimizer Analysis of Multiway
Branch Code Generation")

[3] http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=3D968AE7565678=
63243AC7B1728915861A?doi=3D10.1.1.602.1875&rep=3Drep1&type=3Dpdf


> >> An example: A module/driver allocates a dispatcher. The dispatcher is
> >> shared for all netdevs. Each netdev allocate a slot in the dispatcher
> >> and a BPF program. The netdev then uses the dispatcher to call the
> >> correct program with a direct call (actually a tail-call).
> >
> > Is it really accurate to call it a tail call? To me, that would imply
> > that it increments the tail call limit counter and all that? Isn't this
> > just a direct jump using the trampoline stuff?
>
> Not meant in BPF context here, but more general [1].
>
> (For actual BPF tail calls I have a series close to ready for getting
> rid of most indirect calls which I'll post later today.)
>

Thanks for the clarification, Daniel! (call vs jmp)

> Best,
> Daniel
>
>    [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/commit/?id=3Da9d57ef15cbe327fe54416dd194ee0ea66ae53a4
>    [1] https://en.wikipedia.org/wiki/Tail_call
