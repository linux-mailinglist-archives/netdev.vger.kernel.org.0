Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A562A1851
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgJaOvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 10:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJaOvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 10:51:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0DDC0617A6;
        Sat, 31 Oct 2020 07:51:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s15so12545718ejf.8;
        Sat, 31 Oct 2020 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xeoqSsCGy6lTHKb5i/FB3Sn7FnwCv5pc3NVImeJNRB8=;
        b=HTqYXnVAZEYca4dwQIlJytP+mRVD8IFnsBMPMlPmYjk2ikBIo2b31cfj/1J6nkOjGA
         eSV8BM6Q0jdjN2tTB8E8I4Pcvf4MVdLL6uZ8doy3F2jK4IxmCXL23TJpFVUYsIjTqPQn
         g0hb/2D/hc6VwQpuXBRED1+Ufty8s/jf+QuTk3uVyYBJfFq9M+Ekn9qAzufolqLAjqxS
         KGq8toRd8BqqSoz4ICGbS0cLnLidFCUtOYTIyjFEmaZWiTieOfQRdvoDxoS91RV7l63n
         6lzGPuhzsTj6Gil1b2SUZPo7vFbICOMUsNoxiLOrZoXfeZpU2rkqUYveIbX4rfgaFM+x
         iv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xeoqSsCGy6lTHKb5i/FB3Sn7FnwCv5pc3NVImeJNRB8=;
        b=KWg8aKfYrXJwUzsTlelc0Am27/FIgTQtjU+uno0//W0vhJfB6S9UP8sr0lLuZ9hI88
         KWuZUKKOV0gGSgLlEtVVU3+uxMXAbreo/+Sht6VVxDVfTTHuD9NlFB2g9WjjRdIBp1QZ
         t7tMVCNjlYo1rFF7TtyMqSt9C/sqKxwc3kJvl3oUaVscHYGK8+JLzb6uDokEBruXjrQr
         AZeflYQGwtROm9j2hCo0FiBwBuieR/9hPZM/OHyd1phwCHxif+fo5WdTZhqHttGxvDhz
         Dy8fpXUl8X19Q1BqqhRuweWkScWeLb5yp9yIuwDLlf+hl3GeiCRWKDxU9r39XU13Y9e+
         f6Jw==
X-Gm-Message-State: AOAM531HlDWVQjJZ9QG3EUzwS/Y4xidb0thikUVH8ZMCumW4c8Hzwlhz
        FKSwU0MpCgHiJnde86nQ6yU=
X-Google-Smtp-Source: ABdhPJxPWUswFvEeDDaxaC/HDhdifsx7MwYbM6jNwquvTyZRGPUxjhxLmDnU66RyuY+jaoldxe+Omg==
X-Received: by 2002:a17:906:3acd:: with SMTP id z13mr7716765ejd.118.1604155864422;
        Sat, 31 Oct 2020 07:51:04 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ok21sm4990707ejb.96.2020.10.31.07.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 07:51:03 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 16:51:01 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
Message-ID: <20201031145101.ehxb2boekevppu3d@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
 <20201030233627.GA1054829@lunn.ch>
 <fee0997d-f4bc-dfc3-9423-476f04218614@gmail.com>
 <20201031143215.GA1076434@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031143215.GA1076434@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 03:32:15PM +0100, Andrew Lunn wrote:
> > Sure, I just wanted to add the comment before others simply copy and
> > paste this (pseudo) code. And in patch 9 (aquantia) and 18 (realtek)
> > it is used as is. And IIRC at least the Aquantia PHY doesn't mask
> > the interrupt status.
> 
> And that is were we are going to have issues with this patch set, and
> need review by individual PHY driver maintainers, or a good look at
> the datasheet.
> 

Yep, I already started to comb through all the drivers and their
datasheets so that I can only check for the interrupts that the driver
enables.

Ioana
