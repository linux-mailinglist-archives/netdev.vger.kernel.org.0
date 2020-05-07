Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9B41C85A2
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 11:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEGJZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgEGJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 05:25:14 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC563C061A41
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 02:25:12 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g185so5246070qke.7
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 02:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JbyrTxjTZIm41hIBopPv7oBGmFhzJlTGvI6JGZoJteY=;
        b=hVcFRSKFl9lmb9j77HI03fHv6Hk1v73kcQa902XWtGd6PrAdnJrdvBGI59aZDmbRnl
         QnTav+0K5mLsSEZQ+KAHILuJauchPaRpwCZ2HSvGeKxlR2yK4cJ0EcXZADu40Fwy4x1Z
         7Td0waIzoSgNxJnjGTqKuH6UjSRss+Omt6RfgBDuoNZUOr1hny/f+F+Kqz8+YBJjRvbF
         VI5sQ5IOLK/ydoybPZPeKcEAJqD5SJUS8bRmzndUxkTm6yJSD6dATGFBmttsyzC366Lk
         ATnnN77ZG4GiXFS++MXDBiLfnEwEZzbIJZrEkoVLXC2F5G/7JO9R6O9saQzfQLTr4med
         V/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JbyrTxjTZIm41hIBopPv7oBGmFhzJlTGvI6JGZoJteY=;
        b=B5pCSFgxvc6evdFJzl8WvCKK2JMVSis+kRe7xGIltmfcicDGLAg5rDEfNpETdi/ea6
         agRpf95qXsSuRwK2W01ilos7NSNumW+xXq5la1cLikBa0+ZJjNnOH9L99dAWBSz0LbSK
         wIEvCEUViGxSOTmk06NDYRkolbmW2IhT0z5aK/gBnE/CbahlJUag61266uWe+ODN8kpj
         zcENM1S6JAZKkQUcnQ4bush3oS220gg722gX/yTen/+lNuZoSzdqCml44nbC8h+F0XP1
         fw6EWSFaab4XdXCSWeBu1I1hstwpNEgyADr3jABembNDEnHhnDUnkecfTgpgaYC4bck0
         bcYg==
X-Gm-Message-State: AGi0PubqbPOOPindD5uCpHsx/t70EeFS3tFWwU4dwSJ9nsL1ntzsJcHf
        znZPABC+vcStwNqcceidI8eoM9ZbQZPMfs2Y7f1mnw==
X-Google-Smtp-Source: APiQypLSXck1EaP6FHaf/R4OayTt1mguGYQPHoVpSdiDDIrFzvY+Z5TozNRG3W20rgYO4xwmyohpCkW+LYwhZ5sejQE=
X-Received: by 2002:a05:620a:1289:: with SMTP id w9mr12058283qki.263.1588843511709;
 Thu, 07 May 2020 02:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-6-brgl@bgdev.pl>
 <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com> <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 7 May 2020 11:25:01 +0200
Message-ID: <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 6 maj 2020 o 19:12 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(=
a):
>
> On Wed, 6 May 2020 08:39:47 +0200 Bartosz Golaszewski wrote:
> > wt., 5 maj 2020 o 19:31 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a=
):
> > >
> > > On Tue,  5 May 2020 16:02:25 +0200 Bartosz Golaszewski wrote:
> > > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > >
> > > > Provide devm_register_netdev() - a device resource managed variant
> > > > of register_netdev(). This new helper will only work for net_device
> > > > structs that have a parent device assigned and are devres managed t=
oo.
> > > >
> > > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 522288177bbd..99db537c9468 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *dev)
> > > >  }
> > > >  EXPORT_SYMBOL(register_netdev);
> > > >
> > > > +struct netdevice_devres {
> > > > +     struct net_device *ndev;
> > > > +};
> > >
> > > Is there really a need to define a structure if we only need a pointe=
r?
> > >
> >
> > There is no need for that, but it really is more readable this way.
> > Also: using a pointer directly doesn't save us any memory nor code
> > here.
>
> I don't care either way but devm_alloc_etherdev_mqs() and co. are using
> the double pointer directly. Please make things consistent. Either do
> the same, or define the structure in some header and convert other
> helpers to also make use of it.

In order to use devres_find() to check if struct net_device is managed
in devm_register_netdev() I need to know the address of the release
function used by devm_alloc_etherdev_mqs(). Do you mind if I move all
networking devres routines (currently only devm_alloc_etherdev_mqs())
into a separate .c file (e.g. under net/devres.c)?

Bart
