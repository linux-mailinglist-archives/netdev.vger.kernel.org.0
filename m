Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0A48CAEA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356192AbiALSZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356223AbiALSYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:24:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67917C06175C
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:24:43 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso13792781pjm.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JpfNq1c3sE1WhdGYKIS0ftjO4NBaLyS7DBSMNWoLJHI=;
        b=GlIiBaF6dnpwDfdu4gkhjmVdaaSbadefQdROFC7ChPMpFMnW/b7OHsQM9Mx6b2iRh4
         Jc5C/nfB41M+idSzLKtM52wBPm+NFgB8ml8TJcOd476tfBCdOrPrsz3Rm+BaypwvAgbq
         J2ZtmL2HOjxYrvPzs0vVyKeU3VqbZSI5UsIOUDp9j7+JcSgW9D5uP4/ctU58sdBXdo60
         UM3C7mOnmzi1xJgkTb2qrG42+rh8WsYqcmS9X+qPlXL5F7UiapHjIMXQ2dCj0h/Rzy5j
         Ro7Gjo2pCHwF8sP3jkxFKjx+afncmqtSokAMqrm1VL9sWgu1kKnnBLoeTfDhZci5LQvW
         /8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JpfNq1c3sE1WhdGYKIS0ftjO4NBaLyS7DBSMNWoLJHI=;
        b=v+Mv41NQU/4Asw1MSW3lpCmTo+SU/e7NhVxbaotmkD3apYuaPNNii4xItyQ+79tZWN
         GwuReT+Tn+Lytn3b5mrrw+p3H7lwpWgxT6Z6LooRqf0FXkeEih70eriK1Ms7+c9qPmlp
         h6489I6oJ2HJ1Aaskto62FfA87U1z6mgsb+WiBJIxgYXuBeZHzJcLGbJW+Y6worqsDjZ
         6svf6jexAqKLdoJCCdc1OmP7pRILIeCYJLKvbxkkLtG4YxUso8K6qOVzdZAkrQE/3huZ
         ZCehUU6+C73on/ze5M43v1T1R2FPbI41unnC92d+xA6vp9lrSpgKmd5upMFTrRZxJ6Mq
         DJWw==
X-Gm-Message-State: AOAM532AlVkJmqd3hziJHrUhcUBQnractPd4qHoXf0OoyuCrWTXa8+qO
        Bddxu8TSqCrR6OI07oFHN2c4UnieI6oCVBoSguwYEg==
X-Google-Smtp-Source: ABdhPJw68X6m4+77CEdM91UjbLJ6uhSp3l4p8Vg66CvqBxY10j/EnvM2Z0tQHnRtlMIYAiNPOzJUdYBIKzkcqU+M9Eo=
X-Received: by 2002:a63:b517:: with SMTP id y23mr771749pge.115.1642011882808;
 Wed, 12 Jan 2022 10:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20210719082756.15733-1-ms@dev.tdt.de> <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de> <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <7fe5e3b3ff8fe9375fef409521b93102@dev.tdt.de> <Yd7UHYeAl3wigMmr@lunn.ch>
In-Reply-To: <Yd7UHYeAl3wigMmr@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 12 Jan 2022 10:24:29 -0800
Message-ID: <CAJ+vNU0r6N_ePohyZy5t7v4QpdaJWQ7mXrKr=qxhExVxm-ChRg@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 5:14 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > If I add a 'genphy_soft_reset(phydev);' at the top of
> > > xway_gphy_rgmii_init before the write to XWAY_MDIO_MIICTRL the values
> > > do take effect so perhaps that's the proper fix.
> >
> > OK, I see that we have to change something here.
> > But I would like to avoid a complete reset (BMCR_RESET) if possible.
>
> What does the datasheet say about BMCR_RESET? Some PHYs, like Marvell,
> it only resets the internal state machines. Register values are not
> changed back to defaults or anything like that. Also for many register
> writes in Marvell PHYs the write does not take effect until the next
> reset.
>
> So a BMCR_RESET can be the correct thing to do.
>

Andrew,

Datasheet [1] says "Resets the PHY to its default state. Active links
are terminated. Note that this is a self-clearing bit which is set to
zero by the hardware after reset has been done. See also IEEE
802.3-2008 22.2.4.1.1."

Experimentally I can change the delays and read them back as such,
then issue a BMCR_RESET and read them and they revert to strapped
values so I know BMCR_RESET resets at least some of the registers.

I suppose something to force auto-negotiation to occur again
(BMCR_ANEN?) would suffice. I'm not sure what the best course of
action is.

Tim
[1] https://assets.maxlinear.com/web/documents/618152_gpy111_pef7071vv16_hd_rev1.5.pdf
