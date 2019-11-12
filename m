Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBF3F9A09
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKLTvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:51:42 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39897 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLTvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:51:42 -0500
Received: by mail-io1-f65.google.com with SMTP id k1so20133346ioj.6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 11:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tQtqMeot5LfcVlTdgWDwSqRbJuRC50V8XvcHZihKGG8=;
        b=pEYpkLyPH+Q301rHLJ8Kvnr1eTMi+fysebKB+dV0aT8wS7OK9njRbyWt/OrGymCl26
         umQA5eJMRUGkAWMAD9HqWTXO0tL7O5cc4/kAv0cQym46SDDK5P/c5WO6LrtRUyaBZ0Im
         +eKm0u8JWcvAvBOPhf8MRwz14xkTkpnvC8Qq48xE3cAeaO5LfRSxWUkFZv/pC56ZVBCB
         KJC59nIid7tWaNHwK058GuJ3QNCeKOBnuk5QXDA+n6Wrg8DFpNid3/Vl6wcLKGLP3XEY
         deqJB+1/H1SJOdawKdpBI2bm5dUEmTg2VWnWmkbiIWoPfj/8ds46/h9mY3N2IdB3gGzP
         fRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tQtqMeot5LfcVlTdgWDwSqRbJuRC50V8XvcHZihKGG8=;
        b=nubNCx5KXd2M0/L3LU+aHPKQyfONa1M9lADugj/sbwpDH9H/1+pfIIKjZy1dOxH1F6
         L3eNoSAqfGqClomThBPki+PQc5bCy+30PaPnygi9WLg9YjG0+t2OaFMwTodoUQtQwZos
         V0VNLnSRRGLbzYgo5nvwbD5Gc3j9MxibcgQIEC4m0kOiLyj8Md+K8whYxGkdlIW6q1qe
         rHM65lh8wX/WuFtegHyGGfeHugzKjpY0m/IRd9bDreQ1ryO0/D63p2oJzE4cs2BDhAKQ
         Mx4jBzyTiAgFh2aAtWGmRsdXKjtlLdCNWjUzBhJFiEo5kZ5qA5ojLWhMD5DuN9YcUCkS
         k7Lw==
X-Gm-Message-State: APjAAAUJPMqUTTJOm64f8RnD8PUJtqhGCgH8n2AKkGrFvQf1qsmbJS9J
        95uSLcAqdFV7xfqXJdCYuWIZyAF2SLi4JUxdzg/IFQ==
X-Google-Smtp-Source: APXvYqyQOcsKXkFC659627snfUO6v31s9OzLfN/tzsdHnX9psDit7p0+mxKJy9k82P8pcz2Sjh8jBms8VFvs8Iz5ECo=
X-Received: by 2002:a02:9f12:: with SMTP id z18mr7536892jal.10.1573588301333;
 Tue, 12 Nov 2019 11:51:41 -0800 (PST)
MIME-Version: 1.0
References: <20191111004211.96425-1-olof@lixom.net> <20191111.214658.1031500406952713920.davem@redhat.com>
 <20191112132311.GA5090@lunn.ch>
In-Reply-To: <20191112132311.GA5090@lunn.ch>
From:   Olof Johansson <olof@lixom.net>
Date:   Tue, 12 Nov 2019 11:51:29 -0800
Message-ID: <CAOesGMiCKYVjf+-uyU-NeFiXmsL_26OG9k5W7geCPY-aAB-8ow@mail.gmail.com>
Subject: Re: [PATCH] net: mdio-octeon: Fix pointer/integer casts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 5:23 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Nov 11, 2019 at 09:46:58PM -0800, David Miller wrote:
> > From: Olof Johansson <olof@lixom.net>
> > Date: Sun, 10 Nov 2019 16:42:11 -0800
> >
> > > -static inline void oct_mdio_writeq(u64 val, u64 addr)
> > > +static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
> > >  {
> > > -   cvmx_write_csr(addr, val);
> > > +   cvmx_write_csr((u64)addr, val);
> > >  }
> >
> > I hate stuff like this, I think you really need to fix this from the bottom
> > up or similar.  MMIO and such addresses are __iomem pointers, period.
>
> Yes, i agree, but did not want to push the work to Olof. The point of
> COMPILE_TEST is to find issues like this, code which should be
> architecture independent, but is not. The cast just papers over the
> cracks.
>
> At a minimum, could we fix the stub cvmx_write_csr() used for
> everything !MIPS. That should hopefully fix everything !MIPS, but
> cause MIPS to start issuing warning. The MIPS folks can then cleanup
> their code, which is really what is broken here.

I'm not disagreeing with Dave, going all the way down the rabbit hole
is preferred. In this case I mostly pushed the lack of __iomem usage
down one layer but not the whole way.

I'm unlikely to find time to do it in the near future myself (this was
a bit of a weekend drive-by from my side), but I don't mind doing it.
If someone else beats me to it, feel free to take it over.


-Olof
