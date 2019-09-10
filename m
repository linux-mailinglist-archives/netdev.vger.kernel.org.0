Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18EAAF027
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394158AbfIJRK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:10:56 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:36295 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731510AbfIJRKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:10:55 -0400
Received: by mail-yb1-f177.google.com with SMTP id m9so6385641ybm.3
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+H2ZdiKP0XawTCXDwY4M8ErUyftjDQhLpVHXixAnMs=;
        b=OqqN5iHP3U6ZKiPAEaQ6OZ57aeTmuEW0+KnKF3L0AHHUSaZ/3vEKThPvQvpCVGcJ0d
         XJPKuGFmqBAXU+uw1DjbtnmOANgAYz7yCtaD+X6+tipSFXRk9uaJUFe1zMBWnz94te+n
         B+N23uu7VJQJul4j7OERCdd8fLJZy2HCrSA8ej7Bm+lnP5aIpUHts4w8ZfCpdB+4bSB9
         3GthDvN4MMjmphDu9zKXncri/B+14b8p65XimvoCtwjHRQiBIrM1frcVS/lOdbn20Aso
         iXliyE6J/5s+FRGHfgTQ98d1P69d3KdOEtLnwYlQoiAhn9dZX3CGlt6kZzfBhTivwARp
         QVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+H2ZdiKP0XawTCXDwY4M8ErUyftjDQhLpVHXixAnMs=;
        b=c8G8mKu/vCuA1fgPhfJqkm9wd8nuZ4YJsCO9izAgms3nKv/uoNYXllCWkeuemIQb7h
         M8kE0mfELh4upimknRz69Vh4baj+/Z7oq+RdRpxM/Co9qMumDamNK8mGSHFQQCoDzju8
         8Wh/EjwyUGMpRFPU18vM3qUBf0ci37Hj5FMjlJwBuNRUS7HrBKXvz6tgxlxk5+scAYnh
         NU0tgi9SWgRclV6HjojMFjFSg2GRI1vUI1eZnC1ikIfu06IrmHfBf6/dbmzxrxOEhGHL
         cHGh1JWwesOdL/nY2g+s8mK2D1NGMKjAmCsPCwr9fiNqg8IZCBLCKdonK4X57u/RkMzR
         U1wA==
X-Gm-Message-State: APjAAAVyKESdidQioMV8k48vM1mL8F5jxzn0Q9qtA5RwBM1y+jdyHefk
        MVq4WdCt/gWpe8TxOVliT3MkuOVs
X-Google-Smtp-Source: APXvYqy3n3A76Wgg59UKrXK13oNJqV8lgqn/gCxw6J3te3chnKM0GwhN8Bk3aCp63dsHTeDMgcOV4g==
X-Received: by 2002:a25:9201:: with SMTP id b1mr20917906ybo.261.1568135453865;
        Tue, 10 Sep 2019 10:10:53 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id w123sm4483406yww.22.2019.09.10.10.10.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:10:52 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id y21so6380223ybi.11
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 10:10:52 -0700 (PDT)
X-Received: by 2002:a25:ad54:: with SMTP id l20mr21238220ybe.125.1568135451516;
 Tue, 10 Sep 2019 10:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net> <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
 <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com> <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
 <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
 <CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com> <e364d94b2d2a2342f192d6e80fec4798578a5d07.camel@redhat.com>
In-Reply-To: <e364d94b2d2a2342f192d6e80fec4798578a5d07.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Sep 2019 13:10:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeXo8j2iiFohxBimkzmS1RB872zViY5SOK3t0ZJZmp1VA@mail.gmail.com>
Message-ID: <CA+FuTSeXo8j2iiFohxBimkzmS1RB872zViY5SOK3t0ZJZmp1VA@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steve Zabele <zabele@comcast.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mark KEATON <mark.keaton@raytheon.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Craig Gallek <kraig@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 12:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi all,
>
> On Tue, 2019-09-10 at 11:52 -0400, Willem de Bruijn wrote:
> > This clearly has some loose ends and is no shorter or simpler. So
> > unless anyone has comments or a different solution, I'll finish
> > up the first variant.
>
> I'm sorry for the late feedback.
>
> I was wondering if we could use a new UDP-specific setsockopt to remove
> the connected socket from the reuseport group at connect() time?
>
> That would not have any behavioral change for existing application
> leveraging the current reuseport implementation and requires possibly a
> simpler implementation, but would need application changes for UDP
> servers doing reuse/connect().
>
> WDYT?

Thanks for taking a look, too, Paolo.

I looked into detaching the sockets from the group at connect time. It
could be done without setsockopt, even. Unfortunately, it brings other
problems.

The reuseport group is still there, so may still match sockets
before the connection. If the connected socket no longer has
sk_reuseport set, binding new sockets will fail on conflict. And so a
few more.
