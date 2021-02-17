Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D0531D5AA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 08:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhBQHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 02:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhBQHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 02:17:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC80C061574;
        Tue, 16 Feb 2021 23:16:27 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fy5so955625pjb.5;
        Tue, 16 Feb 2021 23:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XmdW6hN3Wr8myofU5b7ngzG7W30Qvrk/F+0xoCB8yfg=;
        b=p0Z2GN9X3CnMAIR5isVvw/v8HH3Ak40s+4U+9VMBG6X1c/NAIsv9FjyttQNAMKjwRO
         e60Qy/vpEn3NSGQKZ2LFGi36YW4YRSuVUq65nIhz50Lag6xclcDN96YGWxjINp9O0SKx
         xKDIP9o8fno3WKS+jPtfRvabmtHfcLPsnOySA6JQTLL684AtYTTxtOUhlvLd7TJs9dNc
         bgG1Q8oi5iZI0+sgdIVLVTZjYiiUZ1HQSTkA531ZVzytHbFWKMVYS6Dql8ArK5Rjo0q/
         9zYLry/YGA5YoQJ35dvkSqjlLDUSmtzaHs10GQU0eAvwjf5hEBW6cFHnloZmtj+hpHRM
         fEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XmdW6hN3Wr8myofU5b7ngzG7W30Qvrk/F+0xoCB8yfg=;
        b=tGPqDNYBEis6IzgyLSw+Wwoks+tUEV3zZXNiK+QF75Mp5H3JhQV2y6MkX2LFKZvPee
         8CFq6v1Fk3LXbSgxDme3z56G53C7GmjOIbvtX+Kut8JUK0Q+rSnvXK3+v4HtDxjS6sOM
         pNBKRn1P2AEJ4ik7RIQYrsitQCt639+mjgYh5/cCMW6uqshcSHi6tgDMp/PrgvLqZdCr
         dDL0qF1BJUuUDMcFkwaxnqxwOT5h85UDGx8/LELUSeFkEBc1WgL/4JFMvY05ZTEtJviI
         /gqvWeh2ZVWMuz8uatt9NMzd8mKIw2L0Ml/OZcIPMHpe5t4zEXsSLNHgTwFxcxbJPHMq
         Sszg==
X-Gm-Message-State: AOAM532WTRBbPU/tJ8WcMjdFnjDOgGsQNjl6c4LgRsQx9NoqJbmSaDgn
        m4yJvY/xfyG7E1Bw+tRPEXfNirj2mjl24AIvYf0=
X-Google-Smtp-Source: ABdhPJzyQOrpF7QDaoiHGBOj+vO1IrcZz4kng8inBMGwJVaA5QN6Y3iK6LJ9BydJQfcn17c7E9ayNXsHY4qqeKOa9MU=
X-Received: by 2002:a17:90a:7286:: with SMTP id e6mr1240029pjg.117.1613546187415;
 Tue, 16 Feb 2021 23:16:27 -0800 (PST)
MIME-Version: 1.0
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com> <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk> <6e9842b289ff2c54e528eb89d69a9b4f678c65da.camel@coverfire.com>
In-Reply-To: <6e9842b289ff2c54e528eb89d69a9b4f678c65da.camel@coverfire.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 17 Feb 2021 08:16:15 +0100
Message-ID: <CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     Dan Siemon <dan@coverfire.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ciara Loftus <ciara.loftus@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 3:26 AM Dan Siemon <dan@coverfire.com> wrote:
>
> On Mon, 2021-02-15 at 22:38 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff
> > to
> > libxdp (so the socket stuff in xsk.h). We're adding the existing code
> > wholesale, and keeping API compatibility during the move, so all
> > that's
> > needed is adding -lxdp when compiling. And obviously the existing
> > libbpf
> > code isn't going anywhere until such a time as there's a general
> > backwards compatibility-breaking deprecation in libbpf (which I
> > believe
> > Andrii is planning to do in an upcoming and as-of-yet unannounced
> > v1.0
> > release).
>
> I maintain a Rust binding to the AF_XDP parts of libbpf [1][2]. On the
> chance that more significant changes can be entertained in the switch
> to libxdp... The fact that many required functions like the ring access
> functions exist only in xsk.h makes building a binding more difficult
> because we need to wrap it with an extra C function [3]. From that
> perspective, it would be great if those could move to xsk.c.

The only reason they were put in xsk.h is performance. But with LTO
(link-time optimizations) being present in most C-compilers these
days, it might not be a valid argument anymore. I will perform some
experiments and let you know. As you say, it would be much nicer to
hide away these functions in the library proper and make your life
easier.

> [1] - https://github.com/aterlo/afxdp-rs
> [2] - https://github.com/alexforster/libbpf-sys
> [3] - https://github.com/alexforster/libbpf-sys/blob/master/bindings.c
>
