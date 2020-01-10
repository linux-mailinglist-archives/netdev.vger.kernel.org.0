Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C10F1371E4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgAJPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:54:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44499 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgAJPyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:54:43 -0500
Received: by mail-qt1-f194.google.com with SMTP id t3so2267078qtr.11;
        Fri, 10 Jan 2020 07:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7kS34Kh824MXdqzaT9xZaYUn4IjVN8JAkErv6PrL1oo=;
        b=eOoUpUgMuOAo5W1Yq39zLBY9p+Ow4wBVv+qSgQD0qqozIVPDs9813bpHqWOPNRN9OD
         /BD3lGTIsBMFxNerOMJlg+psCX7rEQY6nwMIzB3boYLRUMXd4tihgfiEuo7Dqmiw2qFG
         JZLICVJfGumQXaMowXrv5Emw7JI0m6YmCi+bh+sVvNIbXn/a0kwC7cHXll+yZYUU9kpA
         hhQXBM0eem+TTiuREiQmltDPLBMM9MynHdJsSphT4SirxkVWxRMy4ECkn9VPf09n1GZ3
         UUBRIncRGeu7c0q5Cgqaih+A4B8cIMruOjFHc3GTuLwmx0w1M3+rVRUS9ZDgs3xsYe+O
         YJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7kS34Kh824MXdqzaT9xZaYUn4IjVN8JAkErv6PrL1oo=;
        b=SMLHfJxaQGvpzfcdEsqzJB44y8vENY5GnYneKXbDEC8VFymJ2pXfx3652yX2TpMHd9
         ccDraIsUYYgdxLRAoEr9cxPnKzgjRnD/4A0no2xSUZnjQiGfyo0iuyqRVfJEcD6hu/Io
         CwoGnlZTeiw7cV1ZENR2+/aJKMj0eJqGGzGgcR1Ndm71z5r0ag4yGCso8DpvZ/PjxwZj
         AjmisxWvzAPrRDbpknaBzjfqmAzix5yi2z+epqqq9VsMx6M+0c9Z0GcxNnh7hq/EsLtJ
         7lftREQIoAemfnrXLmp3/shp6RYK3K2tk5KunTi4SF+9WI2qlsue8SrTotUkkA2f/xUi
         mFwA==
X-Gm-Message-State: APjAAAW3T1NfF1GpZ70hyGXR1Os0HHM++sDyGCvlgeUW6x/Jav70tSq8
        Rv1AMjeR984OjBTI+pSzkYTbaaFooIIsSGLFbBHvvTsiwug=
X-Google-Smtp-Source: APXvYqxKH4YSYwLbkCQwYZ3b3GNdrwrSv5W2G6WyRW7Zft0PURGas2pFnfSgAosTc5aSYtiD70R9wSAtfRqG8aflDfU=
X-Received: by 2002:ac8:33a5:: with SMTP id c34mr2998546qtb.359.1578671682025;
 Fri, 10 Jan 2020 07:54:42 -0800 (PST)
MIME-Version: 1.0
References: <157866612174.432695.5077671447287539053.stgit@toke.dk>
 <157866612392.432695.249078779633883278.stgit@toke.dk> <CAJ+HfNhM8SQK6dem9vhvAh68AqaxouSDhhWjXiidB3=LBRmsUA@mail.gmail.com>
 <87d0brxr9u.fsf@toke.dk>
In-Reply-To: <87d0brxr9u.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 10 Jan 2020 16:54:30 +0100
Message-ID: <CAJ+HfNhO9Mn-hzysEfri3hAH29HXiBWDZE1XUVhOj1UFbBrp4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] xdp: Use bulking for non-map XDP_REDIRECT
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 at 16:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
[...]
> >
> > After these changes, does the noinline (commit 47b123ed9e99 ("xdp:
> > split code for map vs non-map redirect")) still make sense?
>
> Hmm, good question. The two code paths are certainly close to one
> another; and I guess they could be consolidated further.
>
> The best case would be if we had a way to lookup the ifindex directly in
> the helper. Do you know if there's a way to get the current net
> namespace from the helper? Can we use current->nsproxy->net_ns in that
> context?
>

Nope, interrupt context. :-( Another (ugly) way is adding a netns
member to the bpf_redirect_info, that is populated by the driver
(driver changes everywhere -- ick). So no.

(And *if* one would go the route of changing all drivers, I think the
percpu bpf_redirect_info should be replaced a by a context that is
passed from the driver to the XDP program execution and
xdp_do_redirect/flush. But that's a much bigger patch. :-))


Bj=C3=B6rn


> If we can, and if we don't mind merging the two different tracepoints,
> the xdp_do_redirect() function could be made quite a bit leaner...
>
> -Toke
>
