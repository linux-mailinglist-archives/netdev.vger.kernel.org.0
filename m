Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC31536546C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhDTIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhDTIpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:45:01 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7340AC061763
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:44:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d27so3420671lfv.9
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4mFxLVbYSplqIc5xuULL9eYZcZsAy3QovP+kVJzVto=;
        b=Tf2a/BXqPC5aBOxCS+ySPj82Ut32t8U8ive1ZXyuAmEqaUU+nQ+2jJkLAnoqscOfR8
         wdfAym/g+cOSgXybreTMIBmuv63c75BGCmbd0G4ZbhXeP3Mx8GuasUuOa19T9WEvwnuH
         zMFJIL6gSy4j8f/J5kxe5BtkendoV0tTzvkxVKlu2725Jady2kKOtJ7oXEn8n008riNc
         csZmN4cHGT+fZLjFU8odjfy/Wwm9My87tTlBvHZKPdNwaSrhB6OG+76KUKNFzyLc2j69
         ya3nxjontEKGeCqSaZhl3srhD2S7lfH2244eeQ2uSlqAiCWSTqNVI0gtRNsajt8UiX+r
         U/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4mFxLVbYSplqIc5xuULL9eYZcZsAy3QovP+kVJzVto=;
        b=Vllh0dBhDDFxGNVUj2TujbbBVGNHyvDgUVekJPh4ANDqvFN/79vQ8Zep7GBA83+xHn
         m3sx0tHYBbyCmybF4VJMPTOI2C5gz7NrAmTHJlNZFo+6FwP1zk8BWraegSUud0mukcq4
         hIS4oXBsmvdRDuilPu9M2hV2VJ9eNU/3dlsDR/qMC7OgURfDL1CUnjc3iwCoNGgtHqJh
         6EHSq6Bb7vzRG9xGCAAIgNEmtOKXiBmoTQGPdUEuQh5K00GN9XquWVaCafJtruAsmYw/
         q4NrXAPRYMHyeZDTsL0WeDlasiqrxQm4N8MobmX0MbMw60TOzqsNce/HfFf+TeK/9beL
         Kjfw==
X-Gm-Message-State: AOAM5328rlzxfhyS5ZARCM9NnGy/4yLW1929DYnUoW13CeeGH/AtdWo6
        jY06JW6PcUSn56155fCeLqz0b7hxwV6f3mlegIi3Og==
X-Google-Smtp-Source: ABdhPJy/RujBnXS94IZb9TTFCI8xhK2xYIhEqq6SWoGoMl91vcQaILTl3jdurt2ahB42nhm4X61dB/m497+hvlnw/zQ=
X-Received: by 2002:a19:520b:: with SMTP id m11mr5842381lfb.157.1618908266974;
 Tue, 20 Apr 2021 01:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <20210419225133.2005360-3-linus.walleij@linaro.org> <YH4yqLn6llQdLVax@lunn.ch>
In-Reply-To: <YH4yqLn6llQdLVax@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Apr 2021 10:44:16 +0200
Message-ID: <CACRpkdb8L=V+=5XVSV_viC5dLcLPWH5s9ztuESXjyRBWJOu9iA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: ethernet: ixp4xx: Use OF MDIO bus registration
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 3:47 AM Andrew Lunn <andrew@lunn.ch> wrote:

> > @@ -1381,25 +1382,12 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
> >       /* NPE ID 0x00, 0x10, 0x20... */
> >       plat->npe = (val << 4);
> >
> > -     phy_np = of_parse_phandle(np, "phy-handle", 0);
> > -     if (phy_np) {
> > -             ret = of_property_read_u32(phy_np, "reg", &val);
> > -             if (ret) {
> > -                     dev_err(dev, "cannot find phy reg\n");
> > -                     return NULL;
> > -             }
> > -             of_node_put(phy_np);
> > -     } else {
> > -             dev_err(dev, "cannot find phy instance\n");
> > -             val = 0;
> > -     }
> > -     plat->phy = val;
> > -
>
> Isn't this code you just added in the previous patch?

Yep. It's by the token of "one technical step per patch" but I
suggested that maybe you prefer to take two technical
steps in one big patch, then we can just squash
patches 2 & 3. I'll fix it as you want it just tell me how :)

> > -     snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> > -              mdio_bus->id, plat->phy);
> > -     phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
> > -                          PHY_INTERFACE_MODE_MII);
> > +     if (np) {
> > +             phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
> > +     } else {
> > +             snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> > +                      mdio_bus->id, plat->phy);
>
> mdiobus_get_phy() and phy_connect_direct() might be better.

Do you mean for the legacy code path (else clause), or the
new code path with of_phy_get_and_connect() or both?

I tried not to change the legacy code in order to not introduce
regressions, so if I change that I suppose it should be a
separate patch.

On the other hand this driver has not been much maintained
the recent years so we might need to be a bit rough when
bringing it into shape. (After migrating all of IXP4xx to
device tree a lot of the legacy code will eventually be deleted.)

Yours,
Linus Walleij
