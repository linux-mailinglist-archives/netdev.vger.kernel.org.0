Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D50D32569C
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhBYT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhBYTYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:24:54 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A628CC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:23:42 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id c8so7765031ljd.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=qW/sjy0hfjGwjWHXQMhBp+DwJ6ynKlUh1N8h3YdUK/s=;
        b=KjMGjMDEsJ/kibWL7bwDzIz2lQXaRgTZlQdsurbP+d0KDd84LKVj+IkHIVD3kDgFAh
         qj0Q1LP7CIUDWzwmI7Gye5hUZNf8lR4RpOpNbY8luAp2Js0s1KbhztktuWe70P3JKl/u
         jRabHro89JqPkdueiCqi6nj64VfG5Y7bDdxVF+KRuTzOSXJXXGgH4man04CCdmCyHDjb
         pwyUfTVW09EqzVVhuYFqvG2vU8GrSACxBo/fI+dyb9yLV8C3954QUtT/rZv//rgr67MN
         LfOAfeTeT5Ex9Ow5cOv4llzr5P18P/rGk8SnHRWWcEuIhXVNkQRy6vq4pKkmLydpx3tj
         GmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qW/sjy0hfjGwjWHXQMhBp+DwJ6ynKlUh1N8h3YdUK/s=;
        b=c5vNPjb6nTrbN4n/MpR9lz3yeNIUq2UIVyoUryenpHcRUeUirGPXzEMdKlNkZi1agC
         po1JQsEPkbYbZg4DqgKY9NdrczAuQjPYXfzHPww9I4vGpbvCd7QeUv7uhSl+bGjkG0iJ
         3/MZkxpS0cgJFGnGJSUkRcrMskG6iKLnB/x+ICL9FKQCGbuuYLMOH7YpjjckkS4leDad
         RINoZaqQ9fsPRCB0MK3OSXO55dTUq7KedZqTjgSe9EjMDOP4r9JOcD2raazY847jzfCD
         khd4zlbPsHmCqjV3XwmK8XgXq6Dfb57L6zaY3StOcDm9EfV+EGGwvmj+pLdfCF/7xSW/
         ib9A==
X-Gm-Message-State: AOAM532RIpdYnu3QoohiItfhor4qQ7Np9hpudnaLe7/xojPgATqUFLVA
        EY2nICkGiNcMOPpnM3bmluPiOg==
X-Google-Smtp-Source: ABdhPJyXCGE1v1PM1e9BFgO+b8rdui7jNnJrJZjjD8u9UFM/ZsoBp1eBglAfEPryfE21lbN7FJ6YFg==
X-Received: by 2002:a05:651c:22f:: with SMTP id z15mr890657ljn.38.1614281020967;
        Thu, 25 Feb 2021 11:23:40 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id l21sm1179814ljc.78.2021.02.25.11.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:23:40 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next 1/4] net: dsa: don't offload switchdev objects on ports that don't offload the bridge
In-Reply-To: <20210214155326.1783266-2-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com> <20210214155326.1783266-2-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 20:23:38 +0100
Message-ID: <87eeh4rlxh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 17:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Starting with commit 058102a6e9eb ("net: dsa: Link aggregation support"),
> DSA warns that certain configurations of upper interfaces are not offloaded
> to hardware. When a DSA port does not offload a LAG interface, the
> dp->lag_dev pointer is always NULL. However the same cannot be said about
> offloading a bridge: dp->bridge_dev will get populated regardless of
> whether the driver can put the port into the bridge's forwarding domain
> or not.
>
> Instead of silently returning 0 if the driver doesn't implement
> .port_bridge_join, return -EOPNOTSUPP instead, and print a message via
> netlink extack that the configuration was not offloaded to hardware.
>
> Now we can use the check whether dp->bridge_dev is NULL in order to
> avoid offloading at all switchdev attributes and objects for ports that
> don't even offload the basic operation of switching. Those can still do
> the required L2 forwarding using the bridge software datapath, but
> enabling any hardware features specific to the bridge such as address
> learning would just ask for problems.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
