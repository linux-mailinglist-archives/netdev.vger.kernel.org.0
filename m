Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77552E3152
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgL0NdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 08:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgL0Nc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 08:32:59 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8F2C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:32:19 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id x20so18436038lfe.12
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+2MaTVk9MO/ZlMlRNbdyrazjx7GQTPFQAFjVFjafBY=;
        b=qz5UDvjTpcHtF/aA56EQLAmwXBCmNEaiAF6llEWtxqGFHJqjGdJFyi4xAZDGOP3tc2
         xTyCuWZE54JpvaQ3mtxdgDxslcPhtxfPOLrNO2y/W6fb9Be85ALafmFaAowJVV3lK/EP
         ZKi4m0Ix/SDwA9F0LpMiwLWIEBSCXbU5goNVWtL3NDDVqSSMWFf3lG4Y1WnRqTTLy7Ei
         +2r6GU6KyFHS5ZIZqLC+o0yPqhcjXp7YcOGKI1+7Og8ITglD7F9lgWONv+1LhbAlbv79
         nsxmpWXg/GeMB4zAyRnX7nlBR3bnCwoWK18FkflQR6gl1xDTF+Px3r+/2lja41EntcOk
         3TBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+2MaTVk9MO/ZlMlRNbdyrazjx7GQTPFQAFjVFjafBY=;
        b=lnnKs69o+YQ6GRkKVowovYM26SV6cVlGO48wMv5bZfVTO5W57ESwNI4vpSYf0axzYm
         HrMH+nZ8d32Lj4lmhIKW5vO2uj0xTdxoynCYOzSBsBPvaxIx3/bu9mGqEafEV95V19aR
         wE+JWSW/Jm3xukc/76sgJZlmUSPQRHB9ok6jmcPxGeZCuhMc2WvzMEYmaqXtc+qD/vz8
         tQWWhdx73IHDr2+43FJt8BUgobbRiZ57cYFxQqBygQI9x1rpdZ82oYLBFXYRjIsJ3oOL
         p6Y5HaCr7b83RwISD2X9tvncdptKz3zBO4RArDGe3qbZC8lEMjFxV4WIBMuvFpyUBoXZ
         Rb1A==
X-Gm-Message-State: AOAM533j25Q8NPEFd2CEgZ4o5AtKlwD6qBFzqXOYYdh3mMuSAj85YT3E
        oXCodmTdRfQE8tSi19d5vkozGggFWxNsGDn79D2P6g==
X-Google-Smtp-Source: ABdhPJzSqIG9dRqmDEuRhJG8EFDVDbN3EWy8sjym5t05J6B7o6KfPSN4tytH++CB5HZ/Xvm9OtXPy53vu9hxitigfzo=
X-Received: by 2002:a05:6512:3238:: with SMTP id f24mr17170390lfe.29.1609075937583;
 Sun, 27 Dec 2020 05:32:17 -0800 (PST)
MIME-Version: 1.0
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 27 Dec 2020 14:32:06 +0100
Message-ID: <CACRpkdbVX2NmJyPwPfEn40H543aUoQmobHUoq0sY3ReEoECq8Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/9] Get rid of the switchdev transactional model
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

> This series comes after the late realization that the prepare/commit
> separation imposed by switchdev does not help literally anybody:
> https://patchwork.kernel.org/project/netdevbpf/patch/20201212203901.351331-1-vladimir.oltean@nxp.com/
>
> We should kill it before it inflicts even more damage to the error
> handling logic in drivers.

I agree with the goal and the series make the kernel less
complex so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>
for the series.

Yours,
Linus Walleij
