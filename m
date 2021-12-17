Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2EE47889F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 11:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhLQKUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 05:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhLQKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 05:20:02 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BEFC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 02:20:02 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id k4so1668192pgb.8
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 02:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wHR7a/OqWwCdwJnWPhWZ1C0oF1LSC8aGJ0vAPdlgZRw=;
        b=kUrV797sl0qdDd/c7cR8IqyWBXsF+jGt5KxXRX8+L8sYDnC/N+N/+Ku0s4BjLf6O9G
         gV96jhD9Cmuym4NU8pk1zwttiIb6ey9vTTAovGiXRuj4YoamJSPUDEhD7JO6pf0UGcyb
         c+84048Bp1+m9hI2w6Lh/5EkAR1v/buy3kphcGcT9jHiD5DPUqH7m3m+FXO16K9DvhrE
         VQW2Lp4zm1SrzEEM7mUCxhOPX1Pf1/Ip0+iH1IqBSvTp1UcYp2dWTtyaN1Koylw4LSlD
         3oeRQjY7ckaqE0gNSRG4aWw8DwUv5un5Irq0V6mrCFCSRkViWHTGA+WKxgk2EmJmggv7
         5oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wHR7a/OqWwCdwJnWPhWZ1C0oF1LSC8aGJ0vAPdlgZRw=;
        b=m+o8BvGibaFy/vViasdTguFCCbZNNytlwxAW5hKi1YXqWmntJpxSrqfkwVgQCUBjkM
         t8WUHjD2h9p2xmqxfsUTmh7xlCpmhI70Gnnl4SAPt4Fa49bmq2oo8+fatFZ0dpSNzcc5
         QhePb77ouFAFRCLGm4X+qSDC/dLARUKQeMW+mORPALCHDJjFo3KxH9G7n3jVDVesVDho
         bc5BPH2E6M9nS2OCRYGnIJ17crubxfZTiPPTUzabq1x/4J1nj0SNrCbxWvwo/lXz8Kty
         LT6DR/Joz3z10W4XrAmo93u2vkwTvQceub2Rn3pDhSEe2pXdbPh5RrrNdmGl0fgtAw7D
         Tu8Q==
X-Gm-Message-State: AOAM5305p7fnQQxgOxczc55R1IgFbzNTM5BhnlLmvtNVhML3TQZXSSYR
        kJ8/JmYTYX417qmL9eo5Dfbjd1JmBVFouqdmNwR+jlSg+6lyjWTK
X-Google-Smtp-Source: ABdhPJxRroVScjWBK1roNS0q8gGgPUcez4w/DFSdbW55ufKYrpSgHeCDFCn42trsJd7byIfPMFje0e1QRhXcTPixnyo=
X-Received: by 2002:a05:6a00:811:b0:4af:d1c9:fa3f with SMTP id
 m17-20020a056a00081100b004afd1c9fa3fmr2531090pfk.21.1639736402029; Fri, 17
 Dec 2021 02:20:02 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216162557.7e279ff6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJq09z4P6fGe6Og4tHAg0qZZ1eR609ytCZj3h_+yp=UD_czh1Q@mail.gmail.com> <YbxXt/qQ5CudjkX6@lunn.ch>
In-Reply-To: <YbxXt/qQ5CudjkX6@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 17 Dec 2021 07:19:51 -0300
Message-ID: <CAJq09z54yX3w-g=6CnDW58NsC+2jAVzfi367pRdprE0wgYDybA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and RTL8367S
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linus.walleij@linaro.org, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>, olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew,

I was not planning on reposting too soon. The new version only fixes
formatting issues, adds module author/description and this code
change:

--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1030,10 +1030,12 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
       if (ret)
               dev_info(priv->dev, "no interrupt support\n");

-       ret =3D priv->setup_interface(ds);
-       if (ret) {
-               dev_info(priv->dev, "could not set up MDIO bus\n");
-               return -ENODEV;
+       if (priv->setup_interface) {
+               ret =3D priv->setup_interface(ds);
+               if (ret) {
+                       dev_err(priv->dev, "could not set up MDIO bus\n");
+                       return -ENODEV;
+               }
       }

       return 0;

Anyway, there is my github repo if someone wants to take a fresh look.
I think the module name issue will take some time.

---
     Luiz Angelo Daros de Luca
            luizluca@gmail.com

Em sex., 17 de dez. de 2021 =C3=A0s 06:26, Andrew Lunn <andrew@lunn.ch> esc=
reveu:
>
> On Fri, Dec 17, 2021 at 05:53:49AM -0300, Luiz Angelo Daros de Luca wrote=
:
> > > On Thu, 16 Dec 2021 17:13:29 -0300 luizluca@gmail.com wrote:
> > > > This series refactors the current Realtek DSA driver to support MDI=
O
> > > > connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethe=
rnet
> > > > switch, with one of those 2 external ports supporting SGMII/High-SG=
MII.
> > >
> > > nit: plenty of warnings in patch 3 and patch 8, please try building
> > > patch-by-patch with C=3D1 and W=3D1. Also some checkpatch warnings th=
at
> > > should be fixed (scripts/checkpatch.pl).
> >
> > Yes, I got those problems fixed. I'll resend as soon as the
> > rtl8365mb/rtl8367c name discussion settles.
> > Or should I already send the patches before that one?
> >
> > For now, here is my repo:
> > https://github.com/luizluca/linux/commits/realtek_mdio_refactor
>
> Please give people time to comment on the patches. Don't do a resend
> in less than 24 hours. It is really annoying to do a review on v1 and
> then find lower down in your mailbox v2. Also, comments made to v1
> sometimes get lost and never make it into v3.
>
>           Andrew
