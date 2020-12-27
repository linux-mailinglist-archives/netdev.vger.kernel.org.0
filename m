Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A495A2E314F
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 14:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgL0N1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 08:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgL0N1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 08:27:11 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A57C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:26:30 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h205so18490883lfd.5
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 05:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rC8WYDaPAGaKZsax6JzUfwPBT2bhu6OdOlZysCNVxEQ=;
        b=MyLFc95ZX/e+3qAPPm+anEekAlQBsjTcXdlf9VRrsPYD8mKInxAljdYc2Qrn9mG+9M
         qJiXSiQrl6yv3mqNaHGpVGviIBIEGZCfY53g5FOiS5mZGgffGq2+9r0SHDKIfxSePP3B
         6dJiI5/Ix9Cvhe6Af17UoingYoUdKnutyo/rKDItqhzjfqQh6tcTF2GVak6bkPt/C1iP
         ieZV41rAnBM/TF0StT0gjRLONOFqrO7NQ0cPaafgnFIJ/ktSGPLGyurO9hXs9r5cEPRf
         0uvGa+k5iOgHmRPsR9t5YXKTu7C7WqjS2QfDxOrK12rEHvN9fA9wv6MRjWcCJyrFpzd7
         zJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rC8WYDaPAGaKZsax6JzUfwPBT2bhu6OdOlZysCNVxEQ=;
        b=mIS85iu/e1XXMxrOQkKLcmej/xuVWJk8l8HbO7+9lVXdrFrfTDeVVRXPVmJydtIH4H
         gxGPWAoStRpWcjB/8Kobc/lV/JzZxvd8s8/BNfLuNMWzUYzBGJvY7y2eLJ1yIZG5VxtF
         QbQlU9D6ogF6q8uqfpCPdMiO0stLxcgKtP2U6NKtx1YRBStLRHSvksCObWoGCVeZYtk1
         psklr7hu9J7LAaJ/7ZNy4+SjKmwYPARZjFV+bgxxxObGyCMMLMBaB7VBvla9IcIbcQwa
         wGqfXZsAMka9zk0nCQ9B7h6qSVx8EeGHizT6QqXvKxbXcl4YEXLWU70SKgEiMrfQNjpX
         02zA==
X-Gm-Message-State: AOAM532xtsfEMBWOQ4Hu+ZBSBtTXmBhOM4rsot7Kli05g3Fv8wMGS3Z3
        usmruLo+NMQJrExKZKzrVqUBXH0QZlSszPdbmqtoUg==
X-Google-Smtp-Source: ABdhPJzrGWRHJfWOxkYG0uZPJWtKac7deYL4y52FYgWiFrF+XrFwybDqwVMKcDSi53uNkoxWsio1uXN3bmQe2uY9J5M=
X-Received: by 2002:ac2:5597:: with SMTP id v23mr11613584lfg.649.1609075588999;
 Sun, 27 Dec 2020 05:26:28 -0800 (PST)
MIME-Version: 1.0
References: <20201217015822.826304-1-vladimir.oltean@nxp.com> <20201217015822.826304-4-vladimir.oltean@nxp.com>
In-Reply-To: <20201217015822.826304-4-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 27 Dec 2020 14:26:18 +0100
Message-ID: <CACRpkdYODzaUT-OCpbsuQ=t8_DuCO5LtSurdMDx0nyWXXYjPzA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/9] net: switchdev: remove the transaction
 structure from port attributes
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

> Since the introduction of the switchdev API, port attributes were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
>
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
>
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
>
> This patch removes the struct switchdev_trans member from switchdev port
> attribute notifier structures, and converts drivers to not look at this
> member.
>
> In part, this patch contains a revert of my previous commit 2e554a7a5d8a
> ("net: dsa: propagate switchdev vlan_filtering prepare phase to
> drivers").
>
> For the most part, the conversion was trivial except for:
> - Rocker's world implementation based on Broadcom OF-DPA had an odd
>   implementation of ofdpa_port_attr_bridge_flags_set. The conversion was
>   done mechanically, by pasting the implementation twice, then only
>   keeping the code that would get executed during prepare phase on top,
>   then only keeping the code that gets executed during the commit phase
>   on bottom, then simplifying the resulting code until this was obtained.
> - DSA's offloading of STP state, bridge flags, VLAN filtering and
>   multicast router could be converted right away. But the ageing time
>   could not, so a shim was introduced and this was left for a further
>   commit.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

For RTL8366RB it seems to do what the commit text says so:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
