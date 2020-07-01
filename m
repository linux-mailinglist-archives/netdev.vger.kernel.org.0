Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB5210C65
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbgGANhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgGANhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:37:54 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4823AC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 06:37:54 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so10717882edr.5
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 06:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rV1tr32mjsUqz4iecxhPn3NjDB7PmLqVFUyCZlr+v1k=;
        b=Nhb84tEjDzNsPZojrZYzI3LEX07zGPjx1z9BWuSamTQUI/T3HlJ5pdPMAb2FRGhGOj
         /td7O8HYKZSsjo7rgiZtlZWSMax656BOY+cjcZIOhHmwIODy3s3CV06RFcwOpgds2MBo
         CTYm/9SZLDJgy700wHmLVErGyiHqALVjS2CRg3RkQwVExh3rb6LFCj4/EfFSLJcF47Ov
         WdqUKeN3GTs+Wy7xXI6yORYvGTsLJ32NjF9cNDKkYOnyWlIUkcEXjv7pa/L8CHU8CTK6
         /2+GSM5O1RKYbvXpknUhlCfoR8H4iKlQOiYufZJ7BGNvgtRXGR1kXi4RqlQwyi25y5Ju
         XJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rV1tr32mjsUqz4iecxhPn3NjDB7PmLqVFUyCZlr+v1k=;
        b=T5IHA8vHYlnfV1vJVlI9lex7/lpycs+8Uck6bK85D2pncm0gmdiEa/szeYTAyw4VXZ
         1JA2ObGN01/lKlaxolg+/f9E9xnXDU5nxL5a2TXaJDxv9X0rOAWFdHu3eaDL0uzAF8hA
         1mpcl23sWfUF4jPICbpqyfKO2AvCO4UN1c0rDRTjBeZqXNlGbl6BE7fTZMglZMJPRPlR
         HhcSYAIvaScP/IydlQkPY20O4Cun2xOJlqug6FYKEh7g9s4+lU5i401yOrgCIOUrja+O
         wG5lemffUmR+zZNMnW9dZjcKOMeNPP5GUI58C9goi9uySTIT/LsLNSQ7Up7iNJa29jf3
         uHbg==
X-Gm-Message-State: AOAM532GjEEQkB7xn+NieEfv3Aonzk/umQVykY1wArj3R4FxrdjhFLo0
        BqtJOENBnG7P/ma4SPTMCEBO99FKabL3UUBRLJM=
X-Google-Smtp-Source: ABdhPJwENyOLUfPQu6mwnpgKzzy17I+uVYJCvyXXMaTqWmkS56IyXCbelIg3JRPYiliCl5B3hunF/oHROFWMt2UDtnM=
X-Received: by 2002:a05:6402:cb3:: with SMTP id cn19mr25762509edb.368.1593610671937;
 Wed, 01 Jul 2020 06:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200621225451.12435-1-ioana.ciornei@nxp.com> <20200622092944.GB1551@shell.armlinux.org.uk>
 <CA+h21hq146U6Zb38Nrc=BKwMu4esNtpK5g79oojxVmGs5gLcYg@mail.gmail.com> <0a2c0e6ea53be6c77875022916fbb33d@walle.cc>
In-Reply-To: <0a2c0e6ea53be6c77875022916fbb33d@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 1 Jul 2020 16:37:40 +0300
Message-ID: <CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
To:     Michael Walle <michael@walle.cc>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, 30 Jun 2020 at 09:01, Michael Walle <michael@walle.cc> wrote:
>
> Hi all,
>
> Am 2020-06-22 11:34, schrieb Vladimir Oltean:
> > On Mon, 22 Jun 2020 at 12:29, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> >>
> >> On Mon, Jun 22, 2020 at 01:54:42AM +0300, Ioana Ciornei wrote:
> >> > Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> >> > The advantage of this structure is that multiple ethernet or switch
> >> > drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
> >> > same implementation of PCS configuration and runtime management.
> >> >
> >> > The PCS is represented as an mdio_device and the callbacks exported are
> >> > highly tied with PHYLINK and can't be used without it.
> >> >
> >> > The first 3 patches add some missing pieces in PHYLINK and the locked
> >> > mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> >> > standalone module. The majority of the code is extracted from the Felix
> >> > DSA driver. The last patch makes the necessary changes in the Felix
> >> > driver in order to use the new common PCS implementation.
> >> >
> >> > At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> >> > SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
> >> > in-band AN) are supported by the Lynx PCS MDIO module since these were
> >> > also supported by Felix and no functional change is intended at this
> >> > time.
> >>
> >> Overall, I think we need to sort out the remaining changes in phylink
> >> before moving forward with this patch set - I've made some progress
> >> with Florian and the Broadcom DSA switches late last night.  I'm now
> >> working on updating the felix DSA driver.
> >>
> >
> > What needs to be done in the felix driver that is not part of this
> > series? Maybe you could review this instead?
> >
> >> There's another reason - having looked at the work I did with this
> >> same PHY, I think you are missing configuration of the link timer,
> >> which is different in SGMII and 1000BASE-X.  Please can you look at
> >> the code I came up with?  "dpaa2-mac: add 1000BASE-X/SGMII PCS
> >> support".
> >>
> >> Thanks.
> >>
> >
> > felix does not have support code for 1000base-x, so I think it's
> > natural to not clutter this series with things like that.
> > Things like USXGMII up to 10G, 10GBase-R, are also missing, for much
> > of the same reason - we wanted to make no functional change to the
> > existing code, precisely because we wanted it to go in quickly. There
> > are multiple things that are waiting for it:
> > - Michael Walle's enetc patches are going to use pcs-lynx
>
> How likely is it that this will be sorted out before the 5.9 merge
> window will be closed? The thing is, we have boards out in the
> wild which have a non-working ethernet with their stock bootloader
> and which depend on the following patch series to get that fixed:
>
> https://lore.kernel.org/netdev/20200528063847.27704-1-michael@walle.cc/
>
> Thus, if this is going to take longer, I'd do a respin of that
> series. We already missed the 5.8 release and I don't know if
> a "Fixes:" tag (or a CC stable) is appropriate here because it
> is kind of a new functionality.
>
> -michael

From my side I think it is reasonable that you resubmit your enetc
patches using the existing framework. Looks like we're in for some
pretty significant API changes for phylink, not sure if you need to
depend on those if you just need the PCS to work.
But, I don't know if marketing your patches as "fixes" is going to go
that well. In fact, you are also moving some definitions around, from
felix to enetc. I think if you want to break dependencies from felix
here, you should leave the definitions where they are and just
duplicate them.

Thanks,
-Vladimir
