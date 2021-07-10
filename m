Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE353C36D0
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGJUjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:39:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8C2C0613DD;
        Sat, 10 Jul 2021 13:36:54 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so6596513eds.4;
        Sat, 10 Jul 2021 13:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZoGYVD7fTRgT5wK85r18uGGhTvztJHkjBILIZcXG6E=;
        b=rFVjdPrrtWXdT5OYdHE4ylW0nw/S5d/5nOY8DphMOtDdBXiVRWNPtzb+bT9Ez/+LrF
         YOzoRSK1k9dHtcYyMrcOLgRny7EM+yO93h4zefRI4f875e2S5aJcbDSm0tzt1ZuFXEEn
         yPsSKBJaHpNeMR1Js7wVAudwCN8j9w9lI1P7icduRSosX+gCn0ZI1/OOmg7+xvs7WIkE
         LmKAT269cz3CI2EKMFm1oA0yIL8lpGQZRYYBkGv1eDbfLcv5EwJfimQuxcTG/QyC3SoA
         cH+stPXWw0vbV87YIYO+R6r13B9uJLK4IHB7bhpJeG0LjW/27pUJlbNu6rsEmtPPK1Ku
         o7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZoGYVD7fTRgT5wK85r18uGGhTvztJHkjBILIZcXG6E=;
        b=ogG/u1nscI9A3QlxOn5gqSpo9I2YkbsrZAba8KI15ZTcIikYh2RG0GGZcRNj24e82/
         nViRoavBpgPFBwhpKz1OlMh09sBf9TkwzejNt5qhNci8vQRJ5Jtibm/qDtoj14ZfEJA4
         9rTW2S2z4ENw42QjGf6kZ3AJg96KkjLAa2umjIjrO9NxnkcwDGmaXTcK6KD/aohp8Vu0
         devJt6Yai9LnOI9LLuqwZ1qeY0PA6SO1AfdbnoO2kvZkf5ALTWuA+YZvWKvjGp9OeGNl
         HTKXae3JYh6DuE+Bmk3O08Q74GTKLIA64ibon0fXxuRgThDkOorDcPJfuucuLA7J8hAq
         hx7A==
X-Gm-Message-State: AOAM530xAC0D6k/3NN0zzMxRbz70k9zwccaVOLwgiRe3mFqv7zCMvHlT
        s0W7KknEztXV9WOjCBtbTWs=
X-Google-Smtp-Source: ABdhPJyHtc9Eok2zTTZJ69yARyVvJ/hPq3lLkJKKeNhpJUBxMY+Ujutl5DmvDKlNV1u/0SxYY+jUMQ==
X-Received: by 2002:a05:6402:430f:: with SMTP id m15mr43679851edc.113.1625949413505;
        Sat, 10 Jul 2021 13:36:53 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id u4sm4124207eje.81.2021.07.10.13.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:36:53 -0700 (PDT)
Date:   Sat, 10 Jul 2021 23:36:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 6/8] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <20210710203651.k76teuhovyob52wq@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-7-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:26:00PM -0700, Colin Foster wrote:
> diff --git a/drivers/net/ethernet/mscc/ocelot_wm.c b/drivers/net/ethernet/mscc/ocelot_wm.c
> new file mode 100644
> index 000000000000..f9a11a6a059d
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/ocelot_wm.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Microsemi Ocelot Switch driver
> + *
> + * Copyright (c) 2017 Microsemi Corporation
> + */
> +
> +#include "ocelot.h"
> +
> +/* Watermark encode
> + * Bit 8:   Unit; 0:1, 1:16
> + * Bit 7-0: Value to be multiplied with unit
> + */
> +u16 ocelot_wm_enc(u16 value)
> +{
> +	WARN_ON(value >= 16 * BIT(8));
> +
> +	if (value >= BIT(8))
> +		return BIT(8) | (value / 16);
> +
> +	return value;
> +}
> +EXPORT_SYMBOL(ocelot_wm_enc);
> +
> +u16 ocelot_wm_dec(u16 wm)
> +{
> +	if (wm & BIT(8))
> +		return (wm & GENMASK(7, 0)) * 16;
> +
> +	return wm;
> +}
> +EXPORT_SYMBOL(ocelot_wm_dec);
> +
> +void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
> +{
> +	*inuse = (val & GENMASK(23, 12)) >> 12;
> +	*maxuse = val & GENMASK(11, 0);
> +}
> +EXPORT_SYMBOL(ocelot_wm_stat);
> +

Do not use blank lines at the end of files, 'git am' will complain that
the patches are whitespace damaged.
