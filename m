Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D105AD2B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF2TkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:40:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38782 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfF2TkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:40:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id r9so9154713ljg.5
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 12:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mS7NbHPTU5zxr4PB5iLA0AQQQ8J8KIDuDHXph6+7nRY=;
        b=f11cNXkpfOhhWblZd/0dpz14sKXJtmPet/ZPX56jsXHtLX9H2vqHFId+hz77yf2vPi
         MuYQvsUqJYvLNbMOVfKzY/0uiBrIFUxdr74HC0XvJBfLJPBJ89QUb1ijeH9API7dsRgj
         +F2JzOOFmAxWDgM4r0VpqL8TDIBxp/qxfkjSDjvTFkF6/i69cTruujzYD8TaoTIVFJkN
         ztHxdNfkhn/eegb0RQg6hCBt+hg/8cCsXOR/M5jW6cEYbSnddMTI/NF3H45Dv+zstoG4
         WNortmzjsBUyE0q9ohKVWFT4KH497SIHwnRdmog0Ukkb4y21YdR6nnnF7qUumt+vEVBr
         +gUQ==
X-Gm-Message-State: APjAAAW0t3vmhbTaGSq7XY+I82BbkLsK2/18+RQipLjbSYrBfbchtieJ
        iN/ZzFYgmCHr0K3sHDvyHnuiDZgy5FCKRd2389lQmg==
X-Google-Smtp-Source: APXvYqwN0+ksHHBiKjpUh37/8JcKiiuAy7OyftGGvM3hM04uAp6wt3EfoMhDs4ClkreVLwL1R8nV50KmaI9rDBaNVSo=
X-Received: by 2002:a2e:3013:: with SMTP id w19mr9626540ljw.73.1561837215301;
 Sat, 29 Jun 2019 12:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm> <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
 <20190629074553.GA28708@kroah.com>
In-Reply-To: <20190629074553.GA28708@kroah.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 29 Jun 2019 21:39:39 +0200
Message-ID: <CAGnkfhzmGbeQe7L55nEv575XyubWqCLz=7NQPpH+TajDkkDiXg@mail.gmail.com>
Subject: Re: net: check before dereferencing netdev_ops during busy poll
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Josh Elsasser <jelsasser@appneta.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 9:45 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 28, 2019 at 07:03:01PM -0700, Josh Elsasser wrote:
> > On Jun 28, 2019, at 3:55 PM, Sasha Levin <sashal@kernel.org> wrote:
> >
> > > What's the upstream commit id?
> >
> > The commit wasn't needed upstream, as I only sent the original patch after
> > 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()") had
> > made the fix unnecessary in Linus' tree.
> >
> > May've gotten lost in the shuffle due to my poor Fixes tags. The patch in
> > question applied only on top of the 4.9 stable release at the time, but the
> > actual NPE had been around in some form since 3.11 / 0602129286705 ("net: add
> > low latency socket poll").
>
> Ok, can people then resend this and be very explicit as to why this is
> needed only in a stable kernel tree and get reviews from people agreeing
> that this really is the correct fix?
>
> thanks,
>
> greg k-h

Hi Greg,

I think that David alredy reviewed the patch here:

https://lore.kernel.org/netdev/20180313.105115.682846171057663636.davem@davemloft.net/

Anyway, I tested the patch and it fixes the panic, at least on my
iwlwifi card, so:

Tested-by: Matteo Croce <mcroce@redhat.com>

Regards,
-- 
Matteo Croce
per aspera ad upstream
