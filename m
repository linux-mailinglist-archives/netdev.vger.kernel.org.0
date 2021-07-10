Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711143C36D7
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhGJUyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:54:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E12C0613DD;
        Sat, 10 Jul 2021 13:52:08 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o5so24035859ejy.7;
        Sat, 10 Jul 2021 13:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=79nDPPhzMUdqY/HoQvtNoGx5K1d4gf+exWkNwx3ridI=;
        b=ebGmXZhKg5B3ySOC3CMoPRdgy5KbrSu5oP9GL9eo8B8OoveTFjEeMLxGaImy/ym+h4
         8D/O2YrirP1MXOb/ajnNn8lChcx8Ny5KERXXNWRmN62vhoP7OdsAT8cuC7tIKtoYCzzG
         0kFXouvkCFaLXw3lgDF9ziL8ECYgjtJS1hvUClpjTrjbazX5QyN3oeAmPpzK70EqgPcD
         kdi5ehNxkNR3wYmiKwy8iU/jrP1zldPeffHxIczH5qqtQLXn/+bZKfz2au0ixQplBNd9
         WwopNOwJiSUF7Z1vuxBnzhx1v75xT8Okq7sGXuz3YFOg23HnE6glbn9b8HPuzkROxuBO
         LwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=79nDPPhzMUdqY/HoQvtNoGx5K1d4gf+exWkNwx3ridI=;
        b=R0witO7j6wbOSneqiggVJTDL++s/f/bwZ4RoKPogaPIDpfr5E0reOd9mqTKU/LoOkg
         +kTbXKfC+p9NM6CXFBMudFjVzrBKb0XDpg98wMDPquzARAZ8yv3Dw2dZYVFUAPY1OnJf
         FF8+J2SyVNfWERN8O/AieYAHTKlQvxTQ8SEoGgpkCq7UAy8kF33u4XRUlZdKSS4V79CX
         IOfgvqa7vV50QWsa5synxzH8GV+2k9TL3WQnXITn14Ur5umFiYj7PQS2jy41el1TNc1F
         kPub/C64oGC2GIKIuzu/mOV+vGswl1GN74RME7eogSypzGLco38pY/o3taeLc+d7SrfT
         3Ahg==
X-Gm-Message-State: AOAM531UUAUDJL6GWcl7phQg6FLBniMBi126R/j6+hJ+npuT2/c1yD6N
        y1iyO7JsUrAqQzinDBGG4DY=
X-Google-Smtp-Source: ABdhPJzqaC35oHHK1IQahspaoHYpcQH0liZDpevV/3puO3dyOGvCcsB//CA6bdQ4KWYVMp1CMgcZpg==
X-Received: by 2002:a17:907:990d:: with SMTP id ka13mr45551211ejc.392.1625950326866;
        Sat, 10 Jul 2021 13:52:06 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id ce21sm1724473ejc.25.2021.07.10.13.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:52:06 -0700 (PDT)
Date:   Sat, 10 Jul 2021 23:52:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 7/8] net: dsa: ocelot: felix: add support
 for VSC75XX control over SPI
Message-ID: <20210710205205.blitrpvdwmf4au7z@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-8-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:26:01PM -0700, Colin Foster wrote:
> +static const struct felix_info ocelot_spi_info = {
> +	.target_io_res			= vsc7512_target_io_res,
> +	.port_io_res			= vsc7512_port_io_res,
> +	.regfields			= vsc7512_regfields,
> +	.map				= vsc7512_regmap,
> +	.ops				= &vsc7512_ops,
> +	.stats_layout			= vsc7512_stats_layout,
> +	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
> +	.vcap				= vsc7512_vcap_props,
> +	.num_mact_rows			= 1024,
> +
> +	/* The 7512 and 7514 both have support for up to 10 ports. The 7511 and
> +	 * 7513 have support for 4. Due to lack of hardware to test and
> +	 * validate external phys, this is currently limited to 4 ports.
> +	 * Expanding this to 10 for the 7512 and 7514 and defining the
> +	 * appropriate phy-handle values in the device tree should be possible.
> +	 */
> +	.num_ports			= 4,

Ouch, this was probably not a good move.
felix_setup() -> felix_init_structs sets ocelot->num_phys_ports based on
this value.
If you search for ocelot->num_phys_ports in ocelot and in felix, it is
widely used to denote "the index of the CPU port module within the
analyzer block", since the CPU port module's number is equal to the
number of the last physical port + 1. If VSC7512 has 10 ports, then the
CPU port module is port 10, and if you set num_ports to 4 you will cause
the driver to misbehave.

> +	.num_tx_queues			= OCELOT_NUM_TC,
> +	.mdio_bus_alloc			= felix_mdio_bus_alloc,
> +	.mdio_bus_free			= felix_mdio_bus_free,
> +	.phylink_validate		= vsc7512_phylink_validate,
> +	.prevalidate_phy_mode		= vsc7512_prevalidate_phy_mode,
> +	.port_setup_tc			= vsc7512_port_setup_tc,
> +	.init_regmap			= vsc7512_regmap_init,
> +};

> +	/* Not sure about this */
> +	ocelot->num_flooding_pgids = 1;

Why are you not sure? It's the same as ocelot.
