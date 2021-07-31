Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E33F3DC6A8
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhGaP1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhGaP1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:27:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE5C0613CF;
        Sat, 31 Jul 2021 08:27:33 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b13so4563748wrs.3;
        Sat, 31 Jul 2021 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1T0tuyB0F24HpXiF8uKV8+EDj75NBQkNPibktOrj6HY=;
        b=IPCqWmPBeNJvUqKBTyuiqHYy9KASj+NMne1PuJDpoIzTncJDXKfxi6Qe7VM/ctIN2C
         jZpbEhlLSIz1a1pJJYup94EN75OnNq3Pg1Mg0HftbzyL2R5UGcO6k5uN1kPy1jcVW+ZX
         TtmrjwqrtDmMyz3jcZdY5gNAyeoKTWMQ0rNOcRFlRGyPUqW3kEgb0YHYP5opxtp6Bhlf
         rl2d83cT2Gd+fBR7XsgV3kFWThvroyPvt49qf10AJqSICFnMUbmEWM5cDhqIYAeS4b1v
         ovFqesWdGliTmpDNm5s/4Wj0D3civk8BEdB+UaPCUeVZrKFcN3LKLBiyNzLI4AJ/B9h3
         Csmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1T0tuyB0F24HpXiF8uKV8+EDj75NBQkNPibktOrj6HY=;
        b=Dl+XwOTJ8uCUGzAySJP86Z84W1D3n5EVH1+xcDyR8vhoJu9MK1UAsBzm9W07L+ZsUG
         ZY5TDbvRBCcwK0BgAfdaXm8cFGC5NWom7W0rKp/rjAsLZNIz5/CJ7uOewSnDwSpjlf56
         42bc6W63M1DDLFF66zS3FaL97drqij67RREY6fYEfu33gUzSF72/s51T902NfIpzkHxA
         wyqPObksNoBSrKwhXUDT8Qsb2nwPEKVwhqI7lkVbQabsqQxJZvZJuVpN6acTeMZjEns3
         oI7GD6gHYwD96fYgl+lZi4wPIWleXW5nDA8qri2jNsIEL4zVEuhgx2ZD4oNZYmYK453q
         uO0Q==
X-Gm-Message-State: AOAM532Z7WXrDptr23kzpa2kn9yneCVdgbp219Tgm/DALbNaewyt6cKd
        hlwpV28+NtL5ZyfT17SykY8=
X-Google-Smtp-Source: ABdhPJzk+V/eBBJLnPbR5MpnyanEvpyfPvQCtH1Cvzh/47jt7jjFz01f2lirYtNBBucEYp0+kfujRw==
X-Received: by 2002:adf:ee51:: with SMTP id w17mr8410522wro.279.1627745251691;
        Sat, 31 Jul 2021 08:27:31 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id b20sm2264569wmj.20.2021.07.31.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:27:31 -0700 (PDT)
Date:   Sat, 31 Jul 2021 18:27:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <20210731152729.r4lzc3md2bql2too@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-7-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:04PM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
> +				     unsigned long *supported,
> +				     struct phylink_link_state *state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	/* Check for unsupported interfaces */
> +	if (!phy_interface_mode_is_rgmii(state->interface) &&
> +	    state->interface != PHY_INTERFACE_MODE_RMII &&
> +	    state->interface != PHY_INTERFACE_MODE_MII &&
> +	    state->interface != PHY_INTERFACE_MODE_INTERNAL) {

According to include/linux/phylink.h, when phylink passes
state->interface == PHY_INTERFACE_MODE_NA, you are expected to return
all supported link modes.
