Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7725F46C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgIGH43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgIGH4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:56:07 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2376BC061573;
        Mon,  7 Sep 2020 00:56:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v196so8231922pfc.1;
        Mon, 07 Sep 2020 00:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=798Cw8bFLQAbARh4SPwYPWqLwJW0cQuU04Rn0/q3c9A=;
        b=D2syiUkxxm48DVBgqZ9pRsJgTZ4P2VL456g/UUyDu03Z6lvECVbPnlGRW7o9HkIQrt
         a/dQK7AYRa/SaHh6NJ2L+mkreCLN7uUKv1A9cLhtRPHvfTGLVpWSKTG+dGYM31WjrKfN
         LRTb+k3QyGqnT21RMEi7KR2dKe6lXu4BaH8pWTRdc9QSo5CMPmFtdxjwS9cAL3htnz5w
         DDJVRTMM8FczmKzaytrgIbb8dBcVeoue1pYYrbDSj6FPsMWM7joEsfy05zAYcSfjsBgy
         jaydvQyKIjopRs+Np53TjqgY8okvTZ3FMe5g38QMjmUF7jZx/T5od72wLd27w7nHeS9t
         BqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=798Cw8bFLQAbARh4SPwYPWqLwJW0cQuU04Rn0/q3c9A=;
        b=G+35RQavc6KfDrZIXFpa2EDIJUG3QVZizmvvE2/hhp7a8mzlakgDSkliE8L8gKYkXt
         dWbsCkDeOrIug8WuCEQgJjeO4M4SJIGj0H5UqFfjux4Fjm9J9S3ehKoaFK3MARN+AyUr
         v6nPa2MOQtc8rewJncoFaYi55O7A68v2hx+lQTqnedYn9qiJjJbZHdi8mOVwzjTtaYzz
         1xhr8lDd/9YCiXctN1QiZEHUzr2ejh6ZzapqXbfrEfqj5OApijyj8cFobnfZvESIZtPp
         vdZ7oTXMJQeOfB9u02mkbPbhyHyggbNfCHqfUGc5qLKY7oW+7+XMc10Hn7QnRyNYd+/y
         tn5g==
X-Gm-Message-State: AOAM530akgDsNwWbsTByu7Z8Z5gZYm/zQQvIChQNeMAwcNIa5BXYaEpc
        bTnTjlhyl+teZHJ7RdL9n/KIjNCgXQZaPNPo4ws=
X-Google-Smtp-Source: ABdhPJzDRd8WxipLju4i1VmdhYX0UHgzaJ6qaFId8ULsyfjyQJ9kWpk5S6bel4uhAwW3V/2UMye8lXCS+m5p7ZaKlUc=
X-Received: by 2002:a63:ec4c:: with SMTP id r12mr15445185pgj.74.1599465366622;
 Mon, 07 Sep 2020 00:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu> <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200907073040.GA3562@plvision.eu>
In-Reply-To: <20200907073040.GA3562@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 7 Sep 2020 10:55:49 +0300
Message-ID: <CAHp75Ve_YJneS7qOY-CXtjB0QJKUBPMUi6nMkp93YMXkuYOfkw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 10:30 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

I'm assuming that you agree on all non-commented.

...

> > > +#define prestera_dev(sw)               ((sw)->dev->dev)
> >
> > The point of this is...? (What I see it's 2 characters longer)
> >
> > ...
> It is not about the length but rather about easier semantics, so
> the prestera_dev() is more easier to remember than sw->dev->dev.

It actually makes it opposite, now I have to go somewhere in the file,
quite far from the place where it is used, and check what it is. Then
I return to the code I'm reading and after a few more lines of code I
will forget what that macro means.

...

> > > +       /* firmware requires that port's mac address consist of the first
> > > +        * 5 bytes of base mac address
> > > +        */
> >
> >
> > > +       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> >
> > Can't you call above helper for that?
>
> Not sure if I got this right, but I assume that may be just use
> ether_addr_copy() and then just perform the below assignment on the
> last byte ?

No, I mean the function where you have the same comment and something
else. I'm wondering if you may call it from here. Or refactor code to
make it possible to call from here.

-- 
With Best Regards,
Andy Shevchenko
