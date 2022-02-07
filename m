Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36A94AC7C5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbiBGRlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiBGR2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:28:06 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA9C0401DB;
        Mon,  7 Feb 2022 09:28:04 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id d10so44301418eje.10;
        Mon, 07 Feb 2022 09:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9KrCsNlSpMOXqBPHbtPt8EJlN8H5IGboWNo2QLZWHG4=;
        b=fPDbjzdv2YQHbocYKzR7lKfakLSXETJtsbXyTcxWZFhabWDROG8JnTgMc3/iP1cXGp
         Fuq4a1iEeisbuPYQiUCGJUv1bUa2+kwQH9fSM2CmziSQp5L4WpKYGQkCe3VFEXxJGote
         YPIPGqxIruPyUdrcqf0NrlV30ccYqEIUQ3lq3UPG9V4NYkzaMJpkIzg5LmbphF0v5BM4
         jwhZzZkUzbYGBL0v+ZJl7wxL3zwg3CTfuYIjS0d5aUGpgjGKhCo1dKd7QmB7IdcaM+aX
         Uanepaysc9MhTe+iMn4IUw+WAQDqcmPofTzQXNQmmG0r5PUsUUE0xip6ZBIuRtNpDIVN
         0Hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9KrCsNlSpMOXqBPHbtPt8EJlN8H5IGboWNo2QLZWHG4=;
        b=ngfnnXqajuBmcEFo1G8fiNPKVBkSYRVCbIOPcFRaUOtYSnoQLjNfcCYJp6S2wACQwO
         W/swsIuXuZ0fzPjSbvsrckvvmnpqcarGsgc6z4rABiQperlA8d2I60cTVqiAEhZFlFVB
         LhPuORLGCtGrzdqqLpN8DZ1CNhcOqVYns2nDZHcfnTFm27+L2nycXMSIs6T3nTebgX5K
         soNxruD4MmflDZS97QDJuH6+3+fn3VxzIF6ls5BcW96uWDixEcQ74Gmwo9bBZF2AaRtF
         7HurwKisnE2pUmo9b8aF/fSErzM2jN0rll1i485mclNTIY4RXZ4tdCpsT/GCrGkLZKe8
         uzNg==
X-Gm-Message-State: AOAM530sk05oyjgOAZCTbCwHUUj+Av3MFSE4jY6aLdlvHvykXdoPDVa5
        iU/NTKS8h3zUu7g7/r+fFiw=
X-Google-Smtp-Source: ABdhPJw2uPZZj1Ypr9pMKOVBG3hvveB9qsGwGfdZxHLXiKqevUi4nL24IpQDGuXHhzeLBmbqK2TH3w==
X-Received: by 2002:a17:906:880f:: with SMTP id zh15mr550839ejb.709.1644254882795;
        Mon, 07 Feb 2022 09:28:02 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id gh24sm2390074ejb.76.2022.02.07.09.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:28:02 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:28:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v8 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20220207172800.r35juho7vbdkf634@skbuf>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207172204.589190-6-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:51:59PM +0530, Prasanna Vengateshan wrote:
> +static int lan937x_parse_dt_rgmii_delay(struct ksz_device *dev)
> +{
> +	struct device_node *ports, *port;
> +	int err, p;
> +	u32 val;
> +
> +	ports = of_get_child_by_name(dev->dev->of_node, "ports");
> +	if (!ports)
> +		ports = of_get_child_by_name(dev->dev->of_node,
> +					     "ethernet-ports");
> +	if (!ports) {
> +		dev_err(dev->dev, "no ports child node found\n");
> +		return -EINVAL;
> +	}
> +
> +	for_each_available_child_of_node(ports, port) {
> +		err = of_property_read_u32(port, "reg", &p);
> +		if (err) {
> +			dev_err(dev->dev, "Port num not defined in the DT, \"reg\" property\n");
> +			of_node_put(ports);
> +			of_node_put(port);
> +			return err;
> +		}
> +
> +		/* skip for internal ports */
> +		if (lan937x_is_internal_phy_port(dev, p))
> +			continue;
> +
> +		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
> +			val = 0;
> +
> +		err = lan937x_set_rgmii_delay(dev, p, val, false);
> +		if (err)

I think this call and the one below are missing calls to of_node_put()
on error.

> +			return err;
> +
> +		if (of_property_read_u32(port, "tx-internal-delay-ps", &val))
> +			val = 0;
> +
> +		err = lan937x_set_rgmii_delay(dev, p, val, true);
> +		if (err)
> +			return err;
> +	}
> +
> +	of_node_put(ports);
> +	return 0;
> +}
