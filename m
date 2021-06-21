Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073213AF162
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhFURIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhFURIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:08:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67329C061767;
        Mon, 21 Jun 2021 09:56:22 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h17so9997667edw.11;
        Mon, 21 Jun 2021 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=il3Apfe4nxzz64UdgTYkANA2nzVdT1n6YLDs+l6Yw9o=;
        b=HrZxFU6c8rbnYiSloiVGdJaSEVGOXGW2MAYDUApkuw450OhyyFZ0Le/CKleBzu0FPC
         7g08x+D5QIMmnGXQselFSzhikl8moQWjQ2qadi4xhH7c8DF3fRMnAVielfzm76Mm2Ai5
         vtn6ZtJWOM6wcdf3f3rp/DgLSTCrd6xdnolUTNUqSf9iWoPKVhypBWcrcPs0BN9zSqd3
         NVDZQtee5K5j57Ttq8hQdRRfuRXaKBj6Qzwq+KDuqa8LRX/PA6xn25ywnTz2Z2S4rQvD
         vyu/BtUI6fB+94nGfkzGNyVlXvsI49Tw7ta5vJkNzd+h58tUf8WYkPR/PmV/oDwF7477
         YZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=il3Apfe4nxzz64UdgTYkANA2nzVdT1n6YLDs+l6Yw9o=;
        b=hYtRh2ptek5gdJS+Hngr6zV57Z6AlC7oyXW5xHi9doGBGeJwc8ijKJe33hHFBUTbcx
         UXG6pqfomIhKq5s6tN3lRZ/NtgQk1MurYxy0b/WcJ6LgVwTEv8/QGwiheaH8zlIzbgBd
         ugVvdeka9yNow5C4bVklFkH8/bIdxTRIS2QRXeeEssh02g9MkAEU88I9IDDygpCoG3Mk
         TLYvh36nhh4utNECYrVxHS3cb1idir959UXm98ldmYsFkki24w7iN/v6YlFyM7Ca2l6J
         vwsnYjawvcLmaX9FBu9KGE60eGXHFxj2OfTz4Xn8GvLku5IYVp3wM0IQ+6Tp/zieUiDA
         DH/g==
X-Gm-Message-State: AOAM5309vocFpE+BldK3abSlI0YLDulbAHYztr+7/JeC7+/040JJjMUt
        vVw7y/JjZ2TWxi1pvk0kFjiA4Q9FynHugI5R+RM=
X-Google-Smtp-Source: ABdhPJzDlHEzlMszUufU4mLUc8yxeJCsxxBXbiaS2yxHWkEKGXi2I6zEgpqlMCQwLljoVALhuZLk83Ta1Nr9MiAlzlY=
X-Received: by 2002:a05:6402:5cc:: with SMTP id n12mr21540502edx.354.1624294581030;
 Mon, 21 Jun 2021 09:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210621103310.186334-1-jhp@endlessos.org> <YNCPcmEPuwdwoLto@lunn.ch>
 <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
In-Reply-To: <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Mon, 21 Jun 2021 17:56:08 +0100
Message-ID: <CALeDE9MjRLjTQ1R2nw_rnXsCXKHLMx8XqvG881xgqKz2aJRGfA@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jian-Hong Pan <jhp@endlessos.org>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 5:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 6/21/21 6:09 AM, Andrew Lunn wrote:
> > On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
> >> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
> >> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
> >> PHY.
> >>
> >> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> >> ...
> >> could not attach to PHY
> >> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >> uart-pl011 fe201000.serial: no DMA platform data
> >> libphy: bcmgenet MII bus: probed
> >> ...
> >> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >>
> >> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
> >> a while between each time for mdio-bcm-unimac module's loading and
> >> probing.
> >
> > Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
> > driver again later, by which time, the MDIO bus driver should of
> > probed.
>
> This is unlikely to work because GENET register the mdio-bcm-unimac
> platform device so we will likely run into a chicken and egg problem,
> though surprisingly I have not seen this on STB platforms where GENET is
> used, I will try building everything as a module like you do. Can you
> see if the following helps:

For reference we have mdio_bcm_unimac/genet both built as modules in
Fedora and I've not seen this issue reported using vanilla upstream
kernels if that's a useful reference point.

Regards,
Peter
