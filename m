Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653741CECD2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgELGEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726032AbgELGEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 02:04:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1882EC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 23:04:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j8so12561806iog.13
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 23:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GmXNnj8j0/DuRakjHfxnYDbYR3/p1C2Z1WRm/EsJUCQ=;
        b=m7upY6SSbbF74mMD/6Ct02MUFC+lcQkE0M2ZSEfUwz8/zFr2LXYe+zyjsa7QHwNxLU
         E1xtIq6cls/6Xl5PC2oNnB9MLcngcGNCboLNlcaeqdA/QhxuPYlg6fSrcTJ1yt3PhSm8
         p4nRLQKIhwwNJhMXFsKo8spE1CkbB7rxxDxOXRA7BfDWjuXaNdcoB7xzLfrvlvITzqGj
         GRDhl86kJpFQABV/jgrZEMNArbKiAHRlWiOkJuHnOqoDLPX8y/BKcsiIq/fZA9FWsRgS
         M6x3a8yUDx3NluBpbUUiWoIc4eo6aHzDUy3W/pNCYGkvOGYvjt9nct4K+D71V8iCXDLZ
         4eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GmXNnj8j0/DuRakjHfxnYDbYR3/p1C2Z1WRm/EsJUCQ=;
        b=Y6iwRkr0p+6IuNRG5bZt3X/rL2J/CaHOIl0CNVhQv6DLA2TUFyIHmwgfmDcMmB7Puf
         umRbivHjQKu1uT8rwrBorvYxF433Q9geCbMriw9Tw/AWZsVGfT4efnuDxBDpMj+gfZ4D
         9pBbv+KyEW+kbybGN2+PKq/fjc6Ma7Df0eDXStq68yAVCoDHogI5yMQveBN445kxLIkV
         WFRZ9t4wokMRCNqbZoH61Dyr51Pi34/anoqRvIQOgl1tM6oejL749L9rt9f5+rR8DbYS
         Z/RE3zo9TT+dbF8b8+IaXgY/be0DvOp61aGt3O+ep0BgBwZZFQPf6XQAvfw+jWQ+JEqB
         51iA==
X-Gm-Message-State: AGi0PuYEfGx5PSPs4/D6SOrScT7Hm3Wj0Ik3UEDkbi55bPJ/m5RDEP8O
        NiqVxWkI2FpOuUvkEuTEZDuj9ZoFzQRkCvsb7OzlDw==
X-Google-Smtp-Source: APiQypJHsy1ID5UWXbduZedwCawN698UUwnJAsyuBfNBmcx4c7aVWyTBXfSDemrrZVvNV8ztJq5Z7EWAvNiviNgU3nE=
X-Received: by 2002:a5d:91c6:: with SMTP id k6mr18867980ior.13.1589263490440;
 Mon, 11 May 2020 23:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200511150759.18766-1-brgl@bgdev.pl> <20200511150759.18766-6-brgl@bgdev.pl>
 <20200511.134117.1336222619714836904.davem@davemloft.net>
In-Reply-To: <20200511.134117.1336222619714836904.davem@davemloft.net>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 12 May 2020 08:04:39 +0200
Message-ID: <CAMRc=MdUCkgCo8UndDbhQRZt_tXJJjtR4uM2g05N5ti7Hw1f2w@mail.gmail.com>
Subject: Re: [PATCH v2 05/14] net: core: provide priv_to_netdev()
To:     David Miller <davem@davemloft.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 11 maj 2020 o 22:41 David Miller <davem@davemloft.net> napisa=C5=82(a=
):
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
> Date: Mon, 11 May 2020 17:07:50 +0200
>
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > Appropriate amount of extra memory for private data is allocated at
> > the end of struct net_device. We have a helper - netdev_priv() - that
> > returns its address but we don't have the reverse: a function which
> > given the address of the private data, returns the address of struct
> > net_device.
> >
> > This has caused many drivers to store the pointer to net_device in
> > the private data structure, which basically means storing the pointer
> > to a structure in this very structure.
> >
> > This patch proposes to add priv_to_netdev() - a helper which converts
> > the address of the private data to the address of the associated
> > net_device.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Sorry, please don't do this.  We had this almost two decades ago and
> explicitly removed it intentionally.
>
> Store the back pointer in your software state just like everyone else
> does.

I will if you insist but would you mind sharing some details on why it
was removed? To me it still makes more sense than storing the pointer
to a structure in *that* structure.

Bart
