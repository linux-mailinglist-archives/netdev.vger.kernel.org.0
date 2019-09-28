Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD942C1225
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfI1Ung (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:43:36 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46665 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfI1Unf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:43:35 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so4263550lfc.13
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Re8E8IWN8ORm5k8KT2j8/GVHvoXz5vlApvfxzulnXc=;
        b=ItrmiSv42LGiGRh6cTunHQPh+2m+xBqXBNCmlKpa7QlOS/cMTgfBj12ed0ecFJEUeI
         rlEuIwE+S4LojsvuwVST4n0yA5vYYjwG3Dl5T66lpezXGinredfG6CEqHnGgerHjYKuM
         rnFut2slKcjyWrfF/7w8lOKWKiAkUp2A3o6fhso1PBYC5wwdVt8Agy0hB1j7MYThqbGr
         DCJbv1ZpAhNf6HbYuJ64X6o2cVS4V/xS4dxHhd57yTME+an7c5bAQZ/lL6L/W6QlGyp2
         rOJF3iYjE9Lh+eqeXpt4vgJN5XuimRi+OgdU95gwPEPV8++wdnYs9W41JiCnefNBEv9p
         ZKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Re8E8IWN8ORm5k8KT2j8/GVHvoXz5vlApvfxzulnXc=;
        b=gb7VVPDPUSlDGdMb8a5zko2ZeBu6lgLZUARUMPPgjTUA8Xk5h9NeSXvXpeLR0wxQn5
         yWHMPSQ1VK5VqC/dKOvGxPqUsEoyJ//za+kwnDtUIjNVRjTHy1QdZOYbP7T0eR6dXhQX
         4IJagrS3o8jjhDCdF+t8CfSfWQoOf66VUTqVnvwc/ruC3RQ2FrAVb+pe686KJiT5PQmF
         CmMbQwa3zrUFJWl1tM7RT9tabfGQFSk1MHPEEi8l42ClhTbippdUMeNt35D/GtvtDbTz
         UlhSkpMh/XNBv610Svp5Nll9YU2/NYlwY3YNtaI3R4dvLqQqggtY40S/08ie/tjy1Aq/
         viHw==
X-Gm-Message-State: APjAAAXlcwN7N9AiZA5HJDD3hFQB6UUO+II5xBC77JMhrrHaqWBXfpXq
        E2E7H/q1N7bgqzitjkYY25i38lQOVOVmgwE78WQxIQ==
X-Google-Smtp-Source: APXvYqw2uKh9CDrPjWmznxQeEgoDvQwjT2DH6fL3bQUsquFxhP0wspTKF6cADM5jGGiyfbsfDKlNRNBrGo3GJ+T9qFU=
X-Received: by 2002:a19:117:: with SMTP id 23mr7032944lfb.115.1569703413426;
 Sat, 28 Sep 2019 13:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190927163911.11179-1-linus.walleij@linaro.org>
 <e21e9a80-c8e0-d758-2309-1a8f03dda400@gmail.com> <CACRpkdaLTf9x=yTBBcGXDUmu2fNjLhx_eWVce_LQcPCjeq9TcQ@mail.gmail.com>
 <8d34070c-4d35-e378-0b9e-4cfe279a7615@gmail.com>
In-Reply-To: <8d34070c-4d35-e378-0b9e-4cfe279a7615@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 28 Sep 2019 22:43:21 +0200
Message-ID: <CACRpkdaCV3c5mHDSO6Lw7rrEZVY2cw+4=nox3xgtkfJsVFM=Hg@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 10:36 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> Do we need to duplicate the same is_vlan_valid() check in both the
> vlan_prepare and vlan_add callbacks?

I'm unsure of the semantics of these calls, the check was in the
OpenWrt driver that I started from.

Is it guaranteed that .vlan_prepare() and .vlan_add() are
always called in succession? Then .vlan_prepare() should
be enough.

Yours,
Linus Walleij
