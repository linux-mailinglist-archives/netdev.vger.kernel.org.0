Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CF71C693A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEFGqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725882AbgEFGqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:46:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0914FC061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 23:46:22 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so714832ilh.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 23:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+/CvsVsRvsIe2fdwin42oKRwBiHMUNkSBi3zIOYY4k4=;
        b=DT6WmVJOSFGWbwoJzWlGLC1MHvldjbW1aPbGsebQDxlwZe7iwnSNTolfUa76eOd29p
         bY4+DyIu0HM7Ux+b79wpjv1HEfzbH79157RfuHSyksqzSHLknytmZWYPfXFm5QGWRjr4
         trPVXMgze6AHFPvmnwrxjqlJKc728qaSJfARZbGbfhF4give+X0eaTP+oNhRMf+5ac8P
         Arpc631AY/NRljNjuR5I9hcJdirqymusRyVIeUrXArJFWuT3SoexMOmMizUv/8UFF/8J
         GTpCWHc3c1BWYWTjKwX/5uBZaJK6C+gV4m4MOKsh1M5DtywTmEZjpryYodVi30SRoDCo
         EcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+/CvsVsRvsIe2fdwin42oKRwBiHMUNkSBi3zIOYY4k4=;
        b=sJ6v2q21lRvEi9UF+8T6bWQ7YhhTgkE6u54lyU6kzg2Ji9TlMxgvGKdDb45laZ5mHF
         wKiuQ5dMWQkeZlurlmIO9bNncXyrX/wGat5lyDSvgPOQZUPNBDB5iVSGb3V5IqMHGsVH
         Oqk4zA6Oqu1GPckzxZlrVSeR1S2ZawPIYgllkd16IRnNgvz3OtWhxF21/7rklUOxeG51
         sl7rPhOaWK5Yw+5Yskfu7mAg6ITwDt1N8JUX70zxBgEp1eu0V8e3BDDd5Q2SaNVSXbnY
         Cr9tUf/hiKiQdnVB9gV57sThgO9oQ0zWMXGBIBZ1p9rbs+3y6LAtQyHL2SSEHBds+XHu
         BmmQ==
X-Gm-Message-State: AGi0PuYhtktgw50f+DNrY1eGfB020Trt9OJqvTYx1rvLjiGybXdP84dr
        z2RNvUXWk8zCma1Q8H+YEXPRltv5cj8R6MFufbPmgg==
X-Google-Smtp-Source: APiQypKJEgnZebPwGNweIcvVeYvS0XTuBvG2j4m7bwSAxW9ci9eJ/kiRyX1pjwNIRh6SnysmSCqDdQb9gXdF8OxrFFg=
X-Received: by 2002:a92:aa07:: with SMTP id j7mr7777424ili.40.1588747581285;
 Tue, 05 May 2020 23:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-6-brgl@bgdev.pl>
 <CAKOOJTzcNr7mc9xusQm3nCzkq5P=ha-si3fizeEL2_KJUOC3-Q@mail.gmail.com>
In-Reply-To: <CAKOOJTzcNr7mc9xusQm3nCzkq5P=ha-si3fizeEL2_KJUOC3-Q@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 6 May 2020 08:46:10 +0200
Message-ID: <CAMRc=Md7gLMThfGF-7YLqW17MpMhU=UFbdTvfjbr9fFHTLir8g@mail.gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 5 maj 2020 o 21:25 Edwin Peer <edwin.peer@broadcom.com> napisa=C5=82(a=
):
> > +
> > +static void devm_netdev_release(struct device *dev, void *this)
> > +{
> > +       struct netdevice_devres *res =3D this;
> > +
> > +       unregister_netdev(res->ndev);
> > +}
> > +
> > +/**
> > + *     devm_register_netdev - resource managed variant of register_net=
dev()
> > + *     @ndev: device to register
> > + *
> > + *     This is a devres variant of register_netdev() for which the unr=
egister
> > + *     function will be call automatically when the parent device of n=
dev
> > + *     is detached.
> > + */
> > +int devm_register_netdev(struct net_device *ndev)
> > +{
> > +       struct netdevice_devres *dr;
> > +       int ret;
> > +
> > +       /* struct net_device itself must be devres managed. */
> > +       BUG_ON(!(ndev->priv_flags & IFF_IS_DEVRES));
> > +       /* struct net_device must have a parent device - it will be the=
 device
> > +        * managing this resource.
> > +        */
>
> Catching static programming errors seems like an expensive use of the
> last runtime flag in the enum. It would be weird to devres manage the
> unregister and not also choose to manage the underlying memory in the
> same fashion, so it wouldn't be an obvious mistake to make. If it must
> be enforced, one could also iterate over the registered release
> functions and check for the presence of devm_free_netdev without
> burning the flag.
>

Hi Edwin,

I've submitted this patch some time ago already and was told to check
if the underlying memory is managed too. I guess I could try to use
devres_find() here though.

Re the last bit in priv_flags: is this really a problem though? It's
not like struct net_device must remain stable - e.g. we can make
priv_flags a bitmap.

Bart
