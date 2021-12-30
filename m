Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E430481FFA
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbhL3Tok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbhL3Tok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:44:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F63C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 11:44:39 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p14so18888630plf.3
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 11:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Z5fvRTcgAVG7TtVwiqib0TKcLlO9v57XTSoMdqUgzQ=;
        b=WEnPOIsnbvc8MFMAA9HsPkBSk/at1EzFJVmmXiB1TMxsB7WEsp6cb+THX76pRj2BfG
         0GCXifxIzuokBdqgMAcpgxf4Wy2qWycVWSWV6Pfbw09HreXmk4uArXsDFzmQto8j8o4W
         i90UfbneUk/xmTPhxvd5L/C3r7N9LW08+AK49wHe7XBmIQBUGPdhVTTBVebM/UZjsjaz
         MNjcXDp/6CB4LQKzzZHeg74tNdkl1b34o4v+OiGH3rIV6pyppTcfRTn4fLjQWTiH9rJr
         FFS/8GBU/V+r84ZQJCRc7HC/HsMTmo+1zzQJaQwV4t/DX+2LI12eJXqCnJJywuzTchMb
         jgnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Z5fvRTcgAVG7TtVwiqib0TKcLlO9v57XTSoMdqUgzQ=;
        b=HLziRubXBbnkd3ORUnXy1N0TfUbn8gOvgx4Rw7Iqlbvc5nCP7iJMgKbfVzC/jPGhVu
         LHwY93jc0T3qG6xCV5JKYplL3RE9xoyiaTZdZeg5OUJyK/p3oNzGSw/HczUnHH9mL51T
         zCkEe/Sqchf+w7JGwWQr89wnBBYjFRpS67caxANjyXh9grY9zLKXFFoY2BJi+QZ0tzOX
         1TXDuHXMscKHDStsbPVtqRuFQ3OmdAoQRM9mTcNkE/69hZ+DAkaNaJ+yFcDwHAXH3QjL
         c9+2DNtSQUtQXIUp3TcL5xhbkqIF+x2aAXhe5hlxORtPB73OLXv1hbVH8QEGOU6vusIp
         ZrLw==
X-Gm-Message-State: AOAM533NlEeDemhzmXpUB71E4s16MoJKgYJaSfKSIUdtPmhjideqvYLj
        AVL2jik4NXiHaDT5mGOpKSOpLoogzTXscfFTyas=
X-Google-Smtp-Source: ABdhPJzVdylbHia8ykGELUEYiT1et3eckHilti21G3Ks+jcQpbRUgbd4rU8p0LU7BdnAjF57TTqqxqMafqT4VlKIsdY=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr40220253pjb.32.1640893479150;
 Thu, 30 Dec 2021 11:44:39 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-7-luizluca@gmail.com> <71f3fa2d-56c0-3e9b-520e-3d6cc1225f1c@gmail.com>
In-Reply-To: <71f3fa2d-56c0-3e9b-520e-3d6cc1225f1c@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 30 Dec 2021 16:44:26 -0300
Message-ID: <CAJq09z6_ZWvcnbO7VvGGU8ayBYGU1eVR72G7mWgZGNTNFkdZjg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 06/13] net: dsa: realtek: use phy_read in ds->ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >   static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
> >   {
> > -     struct realtek_priv *priv = bus->priv;
> > +     struct dsa_switch *ds = ((struct realtek_priv *)bus->priv)->ds;
>
> No need to cast a void pointer, this applies throughout the entire patch
> series.
> --
Hi Florian,

Apologize for my poor C experience but I didn't understand your
suggestion. Simply removing the cast will not work because bus->priv
is void* and it needs to know it is realtek_priv in order to
indirectly reference ds. Should I keep the local priv variable instead
of removing it (this way, cast is not needed)?

Luiz
