Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1CC4152B2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbhIVVZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbhIVVZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:25:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A05C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:23:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eg28so15432582edb.1
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=coLA4okrdb9Cycw07iDUhgI7uwuXao45fzQXmKwYAJ8=;
        b=pIx6ai+dWyiNkJRb9d0HcWQDgBaZTqbmOAFYQeXtZfRrngbqs/9Y/9YMKmRiwHlFbd
         dmW2SjaEl2YM8+Yisl5Ksju/0gFAgzrWIQ2elIQ3aKfQbBpT7FKZGuuxpXFi+RdtvI4J
         GvdI4N4jtxo8pSAmafSf9U2mSAvdbkQcJea8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=coLA4okrdb9Cycw07iDUhgI7uwuXao45fzQXmKwYAJ8=;
        b=NCJ3yllhu9LRQC3RMRu/My4v7lC5HmXsibvge531romKxM5B0wYmlqTLohf9I5KdcD
         4NmkgS7l3bL+M+nWe99GVAialFz7Y0FPNvbZtQDMmc5W/L/NVX7ALFekhzESRmjSD9Sj
         EvYlr0tqVQlaXvIRXsHiY2QQSE0Qt8MBscpmAyszH1qNS0KIMZztuACsYG3rTsLb1RsR
         Xs2j2K0K+JYpfeF+rQZAYHulgEAETtDBClYf2CcdzvAbWg7yNJkHJcDe3IfAHJCQlp11
         s2Zxrby6NoPsJ2vN40WcCRGRiJ7qn/Mx9JhMBGH48SVSV99R54YWTIX6TkEdouMAjutb
         ztjQ==
X-Gm-Message-State: AOAM532tIE524LnAR/1AkNW4Hxzn2FH7OcJw1ZDH0jJ8mXJ6lXaq6Bn+
        pJlcfJ2mUoyYEBA4HC+nMLRwYP++OM58FmWslE19vg==
X-Google-Smtp-Source: ABdhPJwGF7B1JqPQ51i/57mUcsLvTma1rQKmyY99kJh2ke24tnMzgf7XsYx3DYE4mTsm8cUdbaAm7AG1PKk0iJAPsoI=
X-Received: by 2002:a17:907:2d0b:: with SMTP id gs11mr1416079ejc.151.1632345814468;
 Wed, 22 Sep 2021 14:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk> <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
 <87czp13718.fsf@toke.dk> <20210921155118.439c0aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87mto41isy.fsf@toke.dk>
In-Reply-To: <87mto41isy.fsf@toke.dk>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Wed, 22 Sep 2021 14:23:23 -0700
Message-ID: <CAC1LvL2ZFHqqD4jkXdRNY0K-Sm-adb8OpQVcfv--aaQ+Z4j0EQ@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 1:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Wed, 22 Sep 2021 00:20:19 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> >> >> Neither of those are desirable outcomes, I think; and if we add a
> >> >> separate "XDP multi-buff" switch, we might as well make it system-w=
ide?
> >> >
> >> > If we have an internal flag 'this driver supports multi-buf xdp' can=
not we
> >> > make xdp_redirect to linearize in case the packet is being redirecte=
d
> >> > to non multi-buf aware driver (potentially with corresponding non mb=
 aware xdp
> >> > progs attached) from mb aware driver?
> >>
> >> Hmm, the assumption that XDP frames take up at most one page has been
> >> fundamental from the start of XDP. So what does linearise mean in this
> >> context? If we get a 9k packet, should we dynamically allocate a
> >> multi-page chunk of contiguous memory and copy the frame into that, or
> >> were you thinking something else?
> >
> > My $.02 would be to not care about redirect at all.
> >
> > It's not like the user experience with redirect is anywhere close
> > to amazing right now. Besides (with the exception of SW devices which
> > will likely gain mb support quickly) mixed-HW setups are very rare.
> > If the source of the redirect supports mb so will likely the target.
>
> It's not about device support it's about XDP program support: If I run
> an MB-aware XDP program on a physical interface and redirect the (MB)
> frame into a container, and there's an XDP program running inside that
> container that isn't MB-aware, bugs will ensue. Doesn't matter if the
> veth driver itself supports MB...
>
> We could leave that as a "don't do that, then" kind of thing, but that
> was what we were proposing (as the "do nothing" option) and got some
> pushback on, hence why we're having this conversation :)
>
> -Toke
>

I hadn't even considered the case of redirecting to a veth pair on the same
system. I'm assuming from your statement that the buffers are passed direct=
ly
to the ingress inside the container and don't go through the sort of egress
process they would if leaving the system? And I'm assuming that's as an
optimization?

I'm not sure that makes a difference, though. It's not about whether the
driver's code is mb-capable, it's about whether the driver _as currently
configured_ could generate multiple buffers. If it can, then only an mb-awa=
re
program should be able to be attached to it (and tail called from whatever'=
s
attached to it). If it can't, then there should be no way to have multiple
buffers come to it.

So in the situation you've described, either the veth driver should be in a
state where it coalesces the multiple buffers into one, fragmenting the fra=
me
if necessary or drops the frame, or the program attached inside the contain=
er
would need to be mb-aware. I'm assuming with the veth driver as written, th=
is
might mean that all programs attached to the veth driver would need to be
mb-aware, which is obviously undesirable.

All of which significantly adds to the complexity to support mb-aware, so m=
aybe
this could be developed later? Initially we could have a sysctl toggling th=
e
state 0 single-buffer only, 1 multibuffer allowed. Then later we _could_ ad=
d a
state for dynamic control once all XDP supporting drivers support the neces=
sary
dynamic functionality (if ever). At that point we'd have actual experience =
with
the sysctl and could see how much of a burden having static control is.

I may have been misinterpreting your use case though, and you were talking
about the XDP program running on the egress side of the redirect? Is that w=
hat
you were talking about case?

--Zvi
