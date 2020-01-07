Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC31328A5
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgAGORf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:17:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37677 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:17:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so38994644lfc.4;
        Tue, 07 Jan 2020 06:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MG/hwOo1TbMGz5QNwBkeVB5AaGQC720IKD5nFdiKRnQ=;
        b=oLgWIfJijxrp7bOmY11IFaLImJy9hK+TayZPSsRrQZ+nHabLkO4K3x3Va9gYetUvqF
         3J0mpj7xshuOtA5Qcw7DPyAdEgVpJk31cJDZocTV/GTG5GCRfT/CVWW3ibM4V6p5ctf/
         LIH5HmZoSjLDiD77n4UzInjT18y69fYeOzlJ7avvfGPptQDd8h3BJ8K/UZXVFBFtlte/
         Gu/csG9d4vOMzrQXWg5R8dcCI2LsXrx7gqjk4T8ttAJ4mlAbI0aTI5faCqfoFAIJEfJr
         5CxnMYyIyR6BVbbHdlbQQAOAMKHY/zrCW4RgGGcaEv1iTbk27v9mEzAH3VyeaURT4CJj
         InpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MG/hwOo1TbMGz5QNwBkeVB5AaGQC720IKD5nFdiKRnQ=;
        b=bWsSEyTDjVmcZ/CD+hlQiBq6OPTUUrEGLwu0m8wIV6IqPNrc1a17Nlu+PrCDN7J77D
         wgD8n5K/mAZ4coHzS/AVKcWgv5Ast1mkRdlHPkLYs3dFDbk1egAQh9subAtliRl7mUC3
         SkkIu9g9CM0JNsTHJ9rBPYImIbSxLkZmVitkHmIJoxr2+yo+fdQdfUtMnRkQhU4LIeSz
         IMVKnfei6DXq3zNR3W8g9Ua57wNLHyXcLbMxWrl5GJb28FiUtMlL8i/QQ6VLAOFUCV3b
         Mu8HYX4pEKfIjEdlNtuoWBIPtd2r0lqTo3GS1eq+vsf+l4sOUa+uXEgCZtKq2fL9FnH9
         4Rrg==
X-Gm-Message-State: APjAAAUgw9mBiUUe5R/3upre/l4upb1ZEAnfAqC8cDqMH8P9jp6rpBAy
        H32m5BTS9iPwXKgGQqpxOH08fZGyNVJ4iiXqbv0=
X-Google-Smtp-Source: APXvYqxzJ1c+Xn63QIR0ZvtAlNv1GP4t8ExxZWjbPkqF8YZaj1FZgBnz5Zx0YKNBdcTC7QXHuSbwHnpxBo1u4RKG41w=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr60764253lfh.20.1578406653155;
 Tue, 07 Jan 2020 06:17:33 -0800 (PST)
MIME-Version: 1.0
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
 <20200107132150.GB23819@lunn.ch>
In-Reply-To: <20200107132150.GB23819@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 7 Jan 2020 11:17:41 -0300
Message-ID: <CAOMZO5AE1eFjfHwh5HQjn3XmA=_tYZ2qjcU-sX63qFuV=f8ccw@mail.gmail.com>
Subject: Re: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 11:13 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> > index 72868a28b621..ab4e45199df9 100644
> > --- a/drivers/net/ethernet/freescale/gianfar.c
> > +++ b/drivers/net/ethernet/freescale/gianfar.c
> > @@ -833,6 +833,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
> >
> >       /* Find the TBI PHY.  If it's not there, we don't support SGMII */
> >       priv->tbi_node = of_parse_phandle(np, "tbi-handle", 0);
> > +     priv->dma_endian_le = of_property_read_bool(np, "fsl,dma-endian-le");
>
> Hi Johnson
>
> You need to document this new property in the binding.

Yes, but what about calling it 'little-endian' which is commonly used
in arch/arm64/boot/dts/freescale/fsl-lsxxx device trees?
