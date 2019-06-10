Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED413BC4E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbfFJS7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388544AbfFJS7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 14:59:42 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62B1208E3;
        Mon, 10 Jun 2019 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560193181;
        bh=NiQ6TSS68zMVARMk1UxtRrBtgarpzq8OIbKEFYq7Nyw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PZy7xeMMzhmsda1hjKJ29ExmrhdZQYjnrUmbMWO8BP81vJK3DXvIkdTzD9GV/r1Ta
         QEwqvvJUFE93GJeXm1+pobl+zg78XWx5FA1zDP9ROVKQooOyrpWOkm9JmoyVZS0fRR
         MUiMJ+kawdHnnw7xPP3a2XNiVFIPhPOLiKhjgY48=
Received: by mail-qt1-f173.google.com with SMTP id a15so11667525qtn.7;
        Mon, 10 Jun 2019 11:59:41 -0700 (PDT)
X-Gm-Message-State: APjAAAVmF2BcdQmI8Am0Ogx47VBRuwPgxXMSlXkmLJ+7yMki04Ls6xA/
        Zc24LvBpMWUj8N6Xk8C3aK/Fy5FFx/kRaeE7vQ==
X-Google-Smtp-Source: APXvYqwCmscLJYNa3hNvdJokj1iSTo/T0hJq/eoSYOtoTwBoqS29ewgLPnrTr6A8IxSA+xvJ3iYP3g7C2lZ8C89tCMA=
X-Received: by 2002:ac8:36b9:: with SMTP id a54mr61317703qtc.300.1560193180904;
 Mon, 10 Jun 2019 11:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143139.GG28724@lunn.ch>
In-Reply-To: <20190610143139.GG28724@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 12:59:29 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
Message-ID: <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 8:31 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - phy
> > +  - allwinner,sram
>
> Quoting ethernet.txt:
>
> - phy: the same as "phy-handle" property, not recommended for new bindings.
>
> - phy-handle: phandle, specifies a reference to a node representing a PHY
>   device; this property is described in the Devicetree Specification and so
>   preferred;
>
> Can this be expressed in Yaml? Accept phy, but give a warning. Accept
> phy-handle without a warning? Enforce that one or the other is
> present?

The common schema could have 'phy: false'. This works as long as we've
updated (or plan to) all the dts files to use phy-handle. The issue is
how far back do you need kernels to work with newer dtbs.

Rob
