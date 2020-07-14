Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF7F21FB6D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgGNTBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731129AbgGNS7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:59:24 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EEEC061755;
        Tue, 14 Jul 2020 11:59:24 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o38so13687149qtf.6;
        Tue, 14 Jul 2020 11:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SQZ00sUCFnel9yqqo0aD/Thg+rH2CFzCWvrAhQAmR4Y=;
        b=pxsPoBRNgvgtzt0s6ir/SJNqIKlL32pzRaRClpSjHM4nIAaK2ja06jP1LvSLIQi/xv
         KZS+Rq1IJgP1HIQLxH/oi4G59H9yPHrkTkLv/YPxQgHckIqL7fST+TQrlcqqqMms3GNs
         +FtkdH1QfzAfrVTsnRjWf7UDmdG21GXiPwH1o+Vfl/mpiGhdatCMFNOskh0R0Oy7p1ca
         RV/QhKvUOynuSoQUY4WKI7KkFv7UFHwltEL5VpESvWioRvaOtCIBMRTpfbz52L/ShLv7
         HWDJmj20tibJsZhJiPclW80ntkQYKOdfH1z/Nj3CeCOqKdOfu+T7R9IrJ3sUNQNwFcWW
         0KsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SQZ00sUCFnel9yqqo0aD/Thg+rH2CFzCWvrAhQAmR4Y=;
        b=OZGeeEZmVdz8WVG90lJnauiExxg+ttvv3umW+FZDU/i6A7B8GeOG+FVerzogFn/5Xd
         eXEifHbzlC9fAMKOMWE1l/b/fT6ELr1nDtfuA1QaDJRUHkOhAMk5Wv0NPhAf+2HvfaKz
         e+5tead698VevXrzSXdbT9G/EJGOHvTSyARoFHyLRP8ZBxJYNSNLPF/rc0ECi8ZHyZ81
         KJLY8HSGiBBFuXVKsYrw4nirCZyOpURUqpoG4Kb+xmecu2QrW5rjWAeXI0K/b3uwTIUs
         WQup+JRdBUPL2y0w3E/LarDprwA+Zq4dxOF5dF5jpuqABLmQwW3VJJ/hQCD7jLyvGdLy
         Usiw==
X-Gm-Message-State: AOAM5338ypG9fx3BR+IpdaI8FsMq5P9QiFti9GYio6YNPIK6lWlA5rJr
        /bo265nnIcIeBVcU0ECEB6JGJ/252gvpR6YZyUg=
X-Google-Smtp-Source: ABdhPJwb14USRU4G8ZXT5ZjlT7X1fyeRX3VQtWRTBrwcDqM7dUb+nEpGX+g4bV7Ut4ai9tZApJIN6LtdU1zgMTOdklM=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr6181861qtp.141.1594753163239;
 Tue, 14 Jul 2020 11:59:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <877dv6gpxd.fsf@toke.dk>
In-Reply-To: <877dv6gpxd.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jul 2020 11:59:12 -0700
Message-ID: <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 6:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program through
> > BPF_LINK_CREATE command.
>
> I'm still not convinced this is a good idea. As far as I can tell, at
> this point adding this gets you three things:
>
> 1. The ability to 'lock' an attachment in place.
>
> 2. Automatic detach on fd close
>
> 3. API unification with other uses of BPF_LINK_CREATE.
>
>
> Of those, 1. is certainly useful, but can be trivially achieved with the
> existing netlink API (add a flag on attach that prevents removal unless
> the original prog_fd is supplied as EXPECTED_FD).

Given it's trivial to discover attached prog FD on a given ifindex, it
doesn't add much of a peace of mind to the application that installs
bpf_link. Any other XDP-enabled program (even some trivial test
program) can unknowingly break other applications by deciding to
"auto-cleanup" it's previous instance on restart ("what's my previous
prog FD? let's replace it with my up-to-date program FD! What do you
mean it wasn't my prog FD before?). We went over this discussion many
times already: relying on the correct behavior of *other*
applications, which you don't necessarily control, is not working well
in real production use cases.

>
> 2. is IMO the wrong model for XDP, as I believe I argued the last time
> we discussed this :)
> In particular, in a situation with multiple XDP programs attached
> through a dispatcher, the 'owner' application of each program don't
> 'own' the interface attachment anyway, so if using bpf_link for that it
> would have to be pinned somewhere anyway. So the 'automatic detach'
> feature is only useful in the "xdpd" deployment scenario, whereas in the
> common usage model of command-line attachment ('ip link set xdp...') it
> is something that needs to be worked around.

Right, nothing changed since we last discussed. There are cases where
one or another approach is more convenient. Having bpf_link for XDP
finally gives an option to have an auto-detaching (on last FD close)
approach, but you still insist there shouldn't be such an option. Why?

>
> 3. would be kinda nice, I guess, if we were designing the API from
> scratch. But we already have an existing API, so IMO the cost of
> duplication outweighs any benefits of API unification.

Not unification of BPF_LINK_CREATE, but unification of bpf_link
infrastructure in general, with its introspection and discoverability
APIs. bpftool can show which programs are attached where and it can
show PIDs of processes that own the BPF link. With CAP_BPF you have
also more options now how to control who can mess with your bpf_link.

>
> So why is XDP worth it? I assume you weigh this differently, but please
> explain how. Ideally, this should have been in the commit message
> already...

It's the 6th BPF link class we are implementing, I didn't think I
needed to go over all the same general points again. I can point to
patches originally adding BPF link for justification, I suppose.

>
> > bpf_xdp_link is mutually exclusive with direct BPF program attachment,
> > previous BPF program should be detached prior to attempting to create a=
 new
> > bpf_xdp_link attachment (for a given XDP mode). Once link is attached, =
it
> > can't be replaced by other BPF program attachment or link attachment. I=
t will
> > be detached only when the last BPF link FD is closed.
>
> I was under the impression that forcible attachment of bpf_links was
> already possible, but looking at the code now it doesn't appear to be?
> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link FD
> and force-remove it? I certainly think this should be added before we
> expand bpf_link usage any more...

I still maintain that killing processes that installed the bpf_link is
the better approach. Instead of letting the process believe and act as
if it has an active XDP program, while it doesn't, it's better to
altogether kill/restart the process.

>
> -Toke
>
