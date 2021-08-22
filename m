Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF703F4235
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 00:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhHVWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 18:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhHVWsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 18:48:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E93C061575;
        Sun, 22 Aug 2021 15:48:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q17so1405804edv.2;
        Sun, 22 Aug 2021 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=I5Owurw5IdOxKRX/tSDIAlceU7c8W7+6pucBkQK5ewM=;
        b=o4eEYg+w9S/UljoS+G6GW65TSymwUzMP1jHqYyJSIlP6ty2X/r2Om464HTvH9JoUrN
         f1lwbVI1U1e+6eCY0NlcZ7TMLcUTdEh+iD5mqLPkB2DUBSmCcYpvXhGDierBN/64AJfv
         T8bQqUpatfA9qgO3ALYQevK6U/+hpK2BEdKuxMPekhMt5l328bXtEy3oCHGok1y093RU
         lnhyDt0uf2MTcsrpHKqP8SvLb7T6uf4I3M+f2C2rZA78TNlpe65QOKR5HPD+ZEOKaK4o
         pdASY1ETxkhwsCImAiuI/vF3cQU2Gn8v5ygC+lgkcyAlGTcPPuJXB8cPd6pOOxteZ+Ab
         TQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=I5Owurw5IdOxKRX/tSDIAlceU7c8W7+6pucBkQK5ewM=;
        b=bb7UBHuro3xWjFKT2mAOXi+ZnsyTkqGifSQ6RpSLnsCnejdKqLj1djOp+zCD6+QJAh
         U4o0Chjkj//dTWWGOEYdNe2SkLND0uqJygtHw1jLUUeuXrC3GVJiZJb+nhC2w5Wv19BC
         tCkxOPp63EcYBNtI4Ful5QJmBjof/tssfWxsNW6InC7GZLHUHYQbPrWyps1bprdv/tYM
         kGChmlAvzfDib+95ECYautU3HhRTgUSbUW5XNM4TANQvLyEElNT0DAk4K0C9OHcXZzFl
         hVhXPiRvnoJukL1pCBs0sb4Qn8R2prH31KdUS0+zmOuT8lwPJFKc7EQZZCdEanZrtsOa
         eKkQ==
X-Gm-Message-State: AOAM532hbaLIPRBQhyb6OSZqA2Y71qasUGWMe7AcecaKQOzN/ufuKABW
        Trn7xk67sLjNsyH5f88DKr0=
X-Google-Smtp-Source: ABdhPJxcpTX6QUiB5C5I0Wixdm/681JypZnP4CDw9KXiIViF8Q9+e2UJw/BfIadqxVqpjg9G+aNGSw==
X-Received: by 2002:a05:6402:452:: with SMTP id p18mr33865208edw.34.1629672487219;
        Sun, 22 Aug 2021 15:48:07 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id t10sm8116095edv.1.2021.08.22.15.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 15:48:07 -0700 (PDT)
Date:   Mon, 23 Aug 2021 01:48:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20210822224805.p4ifpynog2jvx3il@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-5-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:42PM +0200, Alvin Šipraga wrote:
> +static bool rtl8365mb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)

Maybe it would be more efficient to make smi->ops->is_vlan_valid optional?

> +{
> +	if (vlan > RTL8365MB_VIDMAX)
> +		return false;
> +
> +	return true;
> +}
> +
> +static int rtl8365mb_enable_vlan(struct realtek_smi *smi, bool enable)
> +{
> +	dev_dbg(smi->dev, "%s VLAN\n", enable ? "enable" : "disable");
> +	return regmap_update_bits(
> +		smi->map, RTL8365MB_VLAN_CTRL_REG, RTL8365MB_VLAN_CTRL_EN_MASK,
> +		FIELD_PREP(RTL8365MB_VLAN_CTRL_EN_MASK, enable ? 1 : 0));
> +}
> +
> +static int rtl8365mb_enable_vlan4k(struct realtek_smi *smi, bool enable)
> +{
> +	return rtl8365mb_enable_vlan(smi, enable);
> +}

I'm not going to lie, the realtek_smi_ops VLAN methods seem highly
cryptic to me. Why do you do the same thing from .enable_vlan4k as from
.enable_vlan? What are these supposed to do in the first place?
Or to quote from rtl8366_vlan_add: "what's with this 4k business?"

Also, stupid question: what do you need the VLAN ops for if you haven't
implemented .port_bridge_join and .port_bridge_leave? How have you
tested them?
