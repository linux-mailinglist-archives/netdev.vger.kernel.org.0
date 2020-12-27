Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9222E3151
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgL0Nbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 08:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgL0Nbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 08:31:32 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024AAC061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:30:51 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o13so18529335lfr.3
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tz1mAFw66QY5Tipa3rFek9g52QGL2+XNARFqDDD7d3k=;
        b=dkkMx6B45ucpdecFpa0rNUAFRtLd0CLlaqMNLhAqeDKNWgRu95Z7xhgquqtWbKgny5
         ZTBmqmXe2wCtuzKl3uATCzT9vajL4Yg0DaKvE+sNLnZmQdL5dA8zrkjmoeZx6ti+CjYG
         XIG+QwP1jeL4PyA9i5gfUR0Ji8gKi90dvy03RRqlw76Pfy8kYTrYDZUaB764dBZO3Rci
         IjW0Xs6URALcZgwAJazJhqi5gU4584qGOFXLWAhLo3Sa5N+mY/7rribShUpUOigRi/T4
         Mpkli1/2TokHnbF4zwUv2zoEh6IUWEE0Z43B6WfRKBVX7SYNQdeEaXypYubzFqxGhNEO
         J8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tz1mAFw66QY5Tipa3rFek9g52QGL2+XNARFqDDD7d3k=;
        b=hOt0465JCSj74/p64UN4jvqwRK8LuzlZOYZps+IlpXzxEOsOLEXm2hzRVAeqLosRrP
         J+O2pP5LSXr/L78ffCU/18JoSCHpKkQx2YERwIcRE9IyRohVxu+uBMzG1bAE9LXGOruN
         YSPH2U+84hvxNdYKhCbTr3bDTVmLMzcxqWzY9yLMQ0BHQZd3IGVhsXf7vGuOTLXhG7Tq
         Dx0/si48tExuSt9rGo+kK6RsAkJLa3kIn6R44HDJPjWh34YFXlaE9DPB8+aOR5q8H8mY
         lWlvWb8Dg8iVKbMDCOgzf/exLTbPl3e+zOiw7ikPlRG1HD/ocJ96G13dotmQ23pnB5pk
         +YyA==
X-Gm-Message-State: AOAM5332w09J/fFjuHHFQjH6/CVQfhzOzhxAKTdLX35YToMg5qFP1Ig8
        gY3jhn4xPGx6SggP3ze6e/T8XL820nr14wIAMJTmuA==
X-Google-Smtp-Source: ABdhPJyR6gaQ5e4tR9/517i/V4cwMK13k2OqsG+yetQR4XPj4GEBHy9ogpB0oxSKRXrSTXui9eVOx8sBqSYiWDnESkw=
X-Received: by 2002:a19:8bc6:: with SMTP id n189mr16717281lfd.291.1609075848866;
 Sun, 27 Dec 2020 05:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20201217015822.826304-1-vladimir.oltean@nxp.com> <20201217015822.826304-7-vladimir.oltean@nxp.com>
In-Reply-To: <20201217015822.826304-7-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 27 Dec 2020 14:30:37 +0100
Message-ID: <CACRpkdbJAwFNDgsJ6dhrH8DA=YBiDf=c-dwBsQi=XMSfGsZJ0A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 6/9] net: dsa: remove the transactional logic
 from VLAN objects
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 2:59 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> It should be the driver's business to logically separate its VLAN
> offloading into a preparation and a commit phase, and some drivers don't
> need / can't do this.
>
> So remove the transactional shim from DSA and let drivers to propagate
> errors directly from the .port_vlan_add callback.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This makes the RTL8366 handle errors in a strict way so:
Reviewed-by: Linus Wallei <linus.walleij@linaro.org>

Yours,
Linus Walleij
