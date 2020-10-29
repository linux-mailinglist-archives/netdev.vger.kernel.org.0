Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C629E63D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJ2IUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ2IUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:20:04 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D4BC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:20:03 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id h5so1045192vsp.3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DlhzIhGqTXSkYf0pLQhwfoHsk7crOZLVYsfwUAhOwK4=;
        b=uDY9UbsY4H9ghf5tJuNLDvCMKuXK+eFot6JMwPvOiu5iM3jeEHUHtnGG3kCnvOpT6/
         m9WEWACaUnBtuBt5U7VYs/X693HV22YBLjMVSXnbZevVIPRHjXCDek00w2NRo9TKGrCV
         7+3/BF8Ld10MsAKChMlKr5QFLNP0vvqxkf3sJzuH5MKbnhNCYsQZQu50WALjwEOjLVMl
         M8SFLJ9cHGaWwlRWRf5mX6GZJsffAf2/mvDdu61Nna1AKMjRKzofWOHYUgFCdylw271F
         JWN2f6rfjo3ae9jEu0aR6jYk7qOIUYUn356liR0oE/Swmez/F94J4wRpLPEECN9f6gpt
         u+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DlhzIhGqTXSkYf0pLQhwfoHsk7crOZLVYsfwUAhOwK4=;
        b=Co/hgA54hCksD0YX5xom69pkL5SkM+0nbffVb9O4G789TRp67YX1ARG6QqpBa9ON9T
         g4L7hNuNo7+qhQ7shQI74bPaUcF64zTKefEeZOTB5HMYyyDq8jPXKFkacWNYypEftM5L
         nfxRybuhpANKzyZtT9Dq+tM1tvB5XhpdL3ZlKoFHUhKuzUx8nqrMm0nGKn2wNF5J+M4o
         S/7wPJceSRa+OvLBsgby7rwO+o9G0dipEkUwhCsoh5qXiHBzEL5pKJlgv222SrEkcRfn
         J8gxJvOB4o449p6C3//UHSdR+Es0jdjDVOtFFMHx3VUHE/t18s1+BgvpA+NPHFyS5eqQ
         oGmw==
X-Gm-Message-State: AOAM530DFzhZSYsdD5PkFRomTZYR/iOq/PkjpdTFOzvJneUawwIvia5O
        2tirqaHQu33CTqjkHF3VV7LfxaVLnUwLIFXTN30=
X-Google-Smtp-Source: ABdhPJyeNPrrCZpcQbL5mHWi3Xts688Mq2ghZ45Y1HwqpL0IUdie/ggLXD7Rbzxfvca3Q6YbOMoMeBRJznAk9xLIMro=
X-Received: by 2002:a67:d84:: with SMTP id 126mr2130828vsn.43.1603959602942;
 Thu, 29 Oct 2020 01:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201028181221.30419-1-dqfext@gmail.com> <20201028183131.d4mxlqwl5v2hy2tb@skbuf>
 <CALW65jYa9rTRaE2jn67iWG3=w=CFYvR0VWDNqtj5Vc3L=s6Jpg@mail.gmail.com> <20201029081108.GB32650@earth.li>
In-Reply-To: <20201029081108.GB32650@earth.li>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 29 Oct 2020 16:19:50 +0800
Message-ID: <CALW65jZYeWdK--aNZiTo0cZTqB2WwJa0r1cP-=Tw37Y6n6ra4g@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 4:11 PM Jonathan McDowell <noodles@earth.li> wrote:
>
> On Thu, Oct 29, 2020 at 11:32:36AM +0800, DENG Qingfang wrote:
> > On Thu, Oct 29, 2020 at 2:31 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Thu, Oct 29, 2020 at 02:12:21AM +0800, DENG Qingfang wrote:
> ...
> > > > +static int
> > > > +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > > > +{
> > > > +     struct mt7530_priv *priv = ds->priv;
> > > > +     int length;
> > > > +
> > > > +     /* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> > > > +      * of the slave ports. Because the switch only has a global RX length register,
> > > > +      * only allowing CPU port here is enough.
> > > > +      */
> > >
> > > Good point, please tell that to Linus (cc) - I'm talking about
> > > e0b2e0d8e669 ("net: dsa: rtl8366rb: Roof MTU for switch"),
> >
> > And 6ae5834b983a ("net: dsa: b53: add MTU configuration support"),
> > 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU"),
> > f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> >
> > CC'd them as well.
>
> qca8k tracks and use the maximum provided mtu; perhaps that could be
> optimised by only allow the CPU port to be set but it feels a bit more
> future proof (e.g. if/when we support multiple CPU ports).

btw, there is a bug in your commit f58d2598cf70, in
qca8k_port_change_mtu the loop variable is not used inside the for
loop.

>
> > Also, the commit e0b2e0d8e669 states that the new_mtu parameter is L2
> > frame length instead of L2 payload. But according to my tests, it is
> > L2 payload (i.e. the same as the MTU shown in `ip link` or `ifconfig`.
> > Is that right?
>
> Certainly that's what I saw; qca8k sets the MTU to the provided MTU +
> ETH_HLEN + ETH_FCS_LEN.
>
> J.
>
> --
> Pretty please, with sugar on top, clean the f**king car.
> This .sig brought to you by the letter J and the number 13
> Product of the Republic of HuggieTag
