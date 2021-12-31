Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C40482189
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbhLaCad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241028AbhLaCac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:30:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556FEC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 18:30:32 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso24622352pjb.1
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 18:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHiQ6rYGiHMLohBJSoafIpfBfg49ITefFTLChNuU9+I=;
        b=kIC/PO5VYlQfP+Oikdo5V38ZPfanrGvR9D8y5GNsmzn/QCKIYeu5jv7TGRvB9D+y/U
         mUDQrHHfBUwBTmgpytmTuVTXCpym11BM8gkIpdT5aoFClp/sbZsEPt61Soe3GGj7JXv2
         UX4NYyyMPKzjiFsWizN2T6YAt3qHx0p+3KsbzFuWkrFUPIeYl91NoameHKZsv07x6Ai0
         8pvishgB9r3XLnPpI6iVpyvjQCcvpqfsH7HFLYQ2+RyXVwmgmc8YCFN2VUGwy6jUxCMx
         anO6dR9mbwb0t3hNe9ZpmA+SdGNkoAVRt/7+V0YgUT2tM+MGYJ7mVEZeDTVHryOnmn0U
         A6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHiQ6rYGiHMLohBJSoafIpfBfg49ITefFTLChNuU9+I=;
        b=OMyDrhe9VjEVSwfRiaM8nLV+PROPB/3YsAO4xcRlv1ZXneSD7Ldp9P6DDmKuVzxSGg
         +X1Ki8UQnJgQKVu3WRbGNR4o2tYmNvdESIN7GR+n7iIJ4P9VRIVsW8n2LHwo1dqr6fO1
         tNi/dqxPSiC3X05YhUklkhfd+oPMTbds9gJLSIiQYVzVuLzT3mzYlL7lB1irhoqOV746
         zF4LJPX+pWOrVHeq7JjXkUr+auIoxnh08SZVuzCjIxwqlDd19E57+/zKrFYaKGKMjdd3
         RP5WlyDmKrscx9BnPKCx1iCfrUBqbWkbZweGnzAVVkh54c5YM/CXb6GI7mc3Zs3FaLjs
         8cyw==
X-Gm-Message-State: AOAM530daWCYsDPHmO2lJJ5weG+0/a7h0sRCUTtJOPKUr2R0I68HlHyA
        MXalHdXmE1wG9285AG/rgxlP7lQ+gBN4jwTXnkw=
X-Google-Smtp-Source: ABdhPJyHnNN0757/iWBuIi0yQ3GguA508KVm06UOt+vp3J3INvNF0HHePzNhmmwyrtfNGjuahN0afNenooOi4iWyxNc=
X-Received: by 2002:a17:90b:360e:: with SMTP id ml14mr41555426pjb.135.1640917831846;
 Thu, 30 Dec 2021 18:30:31 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-7-luizluca@gmail.com> <71f3fa2d-56c0-3e9b-520e-3d6cc1225f1c@gmail.com>
 <CAJq09z6_ZWvcnbO7VvGGU8ayBYGU1eVR72G7mWgZGNTNFkdZjg@mail.gmail.com> <Yc4P64Ee+cwGF8PL@lunn.ch>
In-Reply-To: <Yc4P64Ee+cwGF8PL@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 30 Dec 2021 23:30:20 -0300
Message-ID: <CAJq09z4EXZZ_G=9+rZXip_duw4yRiYmeXi2UZ_c63ObV8d+KfA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 06/13] net: dsa: realtek: use phy_read in ds->ops
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Apologize for my poor C experience but I didn't understand your
> > suggestion. Simply removing the cast will not work because bus->priv
> > is void*
>
> You can do
>
>      struct realtek_priv *priv = bus->priv;
>      struct dsa_switch *ds = priv->ds;
>
> This is more readable than what you suggested, and avoids the cast.
>
>      Andrew
>
Got it! Thanks Andrew.
