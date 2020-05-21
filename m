Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A37F1DD26D
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgEUPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEUPzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:55:33 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE010C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:55:31 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b123so3058586yba.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xjvIBzn5puNJST7R77RvEX1q8gqs9kTDdMtB1Ef7poE=;
        b=NKscpmQ1+ylhwCu1QXz4iovW5Gj+0eF2f3kFi/LF1iSn+EJhnywC1B683xsMHO5Nkr
         Wc511v5SPDmqVbWLqkIpKvJJR5cPvwOw48wCdzU3Kd5+ThTW9PA/xQO6JG29vdr7Kom4
         KcQuz2ZHoIVnPMJ6WEeBgX4OROyiqzZAHjeMHSBR2eelLySomyBvrAPPB4e8Tg9s8YyI
         lXMIjZOf0EpWtNpbwe0lqE3wuUlDOhSmxmXfRlLg+VfxbJNpImP7vAh9ORsxLYSTOCsE
         Ga74dZKNzb/W7Oweuqv3DScWcvW8XPfBA1u0vn3NCHPNUv8vaS7eYSt84PWbMtv8qQEi
         MGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xjvIBzn5puNJST7R77RvEX1q8gqs9kTDdMtB1Ef7poE=;
        b=HNnoMXKAHpEiRF+tlhM1oh+GzkeHFAi08l2SZBeKMv50dRTcPfG6qX+i/vBD5VhXdL
         9u/Cel38pGG4vGPbMKw9fJQs+zFf5OGMteBUTrvBR15rK5To8Bf4a/+TbruVk8ejjIZs
         g0oQ8SuCWuhYMAMom+LNmlEZkONWLnAo8c2HT6jNBPKR6Jv/LJnyJwAT+Yez8PjFyI+Q
         0Xps6m+bR9IYFiPC8LDincmFhLVIjHFZOcafSVuoeebSX6GFF7eu2AiX1cNb6tbN8ufG
         tS5xJ6a5ELFTr/1cTss7ULZBvyKG0qJXYxvuG+CvpH/gWAD7t/9avwp5DOwSSJU8fgI8
         FFpw==
X-Gm-Message-State: AOAM531X+xZqNxWxXN4rh5/a7UhPhWiPidFI6zOrUlU93Wq2nme2ngdW
        1tIj504ic6t5xfUI+ebMFSUSE6yxMu0KC1P1TQmM4fEt
X-Google-Smtp-Source: ABdhPJx+lh0Xd7RgpZU5nMmVrKQwPRzbunsDHhYH1FRl/oUMisscgQQuPTiWwk6CIgJJ8iY64yEH9GHzmMon2aHhYEw=
X-Received: by 2002:a25:ec08:: with SMTP id j8mr15024978ybh.281.1590076531075;
 Thu, 21 May 2020 08:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <3268996.Ej3Lftc7GC@tool> <20200521151916.GC677363@lunn.ch> <20200521152656.GU1551@shell.armlinux.org.uk>
In-Reply-To: <20200521152656.GU1551@shell.armlinux.org.uk>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Thu, 21 May 2020 17:55:19 +0200
Message-ID: <CABwr4_vdWWRBMXeK9uGLnuK++9uuM_FBygypv_2PhCRnsOEcEA@mail.gmail.com>
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the comments.

I'll look for a better approach.

Regards
Daniel

El jue., 21 may. 2020 a las 17:27, Russell King - ARM Linux admin
(<linux@armlinux.org.uk>) escribi=C3=B3:
>
> On Thu, May 21, 2020 at 05:19:16PM +0200, Andrew Lunn wrote:
> > >  drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethe=
rnet/marvell/mvneta.c
> > > index 41d2a0eac..f9170bc93 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -3567,8 +3567,9 @@ static void mvneta_start_dev(struct mvneta_port=
 *pp)
> > >
> > >     phylink_start(pp->phylink);
> > >
> > > -   /* We may have called phy_speed_down before */
> > > -   phy_speed_up(pp->dev->phydev);
> > > +   if(pp->dev->phydev)
> > > +           /* We may have called phy_speed_down before */
> > > +           phy_speed_up(pp->dev->phydev);
> >
> > I don't think it is as simple as this. You should not really be mixing
> > phy_ and phylink_ calls within one driver. You might of noticed there
> > are no other phy_ calls in this driver. So ideally you want to add
> > phylink_ calls which do the right thing.
>
> And... what is mvneta doing getting the phydev?  I removed all that
> code when converting it to phylink, since the idea with phylink is
> that the PHY is the responsibility of phylink not the network driver.
>
> I hope the patch adding pp->dev->phydev hasn't been merged as it's
> almost certainly wrong.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbp=
s up
