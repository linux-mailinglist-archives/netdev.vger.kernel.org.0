Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3D5282D6
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiEPLIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiEPLIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:08:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB3510F7;
        Mon, 16 May 2022 04:08:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id j28so3752340eda.13;
        Mon, 16 May 2022 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9gbZwGd5qYzEvS9I4v7Fq4LdbPgd9ZLugg8VsPMZSkM=;
        b=lmpw9QR1JIPoVdL1nxCr7Oe4nRqYxa4A9JYL3UeUUYtGQRih256O43tgDnp7gYTZKw
         2DvCCePxHVxCrSBNUGLcGm/EKWZ7ee64nClCI5pk07KpmAKi8mevQxdpeHn7xPa2B9JM
         r5fkQ65I8Tgk+gZjaGLNaSQH7St3k1dCd5wFVC3y6EU2CoaFF/tZqxKSA8E6B+gYXv89
         GlfK0h/hglTRjdqxVd0NpMHeO37GWdYPQxeL0mhwzpQY/e7iKs498P+46qWFIDw73rv5
         3sgDa3W4Aqqkn+XuLSaRCvMMq0kEu2H9l6z8qGcwrUPrjdP3N3DFWoWyp+4noliX39b0
         QyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9gbZwGd5qYzEvS9I4v7Fq4LdbPgd9ZLugg8VsPMZSkM=;
        b=t7D+IphFRYnLo6y+kpEagleTJZy7LPRyje9QUuBYucdclGa5qwkVODev/pHaRuEM2K
         wb4DFA8VVN0GGONBaFYM1Ub1cQR5j8jXR9BZ5FBE/mMfny+Q12vIWDn8XCwQBIxUAs0h
         DALa4N2MEe58dHfo6hYrtq9ZhYR2VZ0PWjXyvxT8mZ5LmIGkTEJgnWGne8HGiRYjZlqm
         YpRperk6uctyzzBI3nsN8R4ChPZQby97Yi2Rrk7GmCGRzHyxzJPKOG3KpU9i4nepGuSn
         Tk/mQiHAUatgQC20BpvttlsdGH4J0QQex4oAuBhsMHJoUqyKIKT6JaST6QSHhPw+1efo
         Q4/g==
X-Gm-Message-State: AOAM533NSart/YRLN8b5U20pqc7xOJRoiLpCME+xudO+ihwKHmlCMnb4
        Rona0Shfp/v7L+eFcld2mCVdq/4FIaQ=
X-Google-Smtp-Source: ABdhPJyREuL0BUJPkmJEQMabY76p0aixIqzKdcT2V23LYv40qH7vmhRG19LiTML1AzH3YvQWpfRrZQ==
X-Received: by 2002:a05:6402:d05:b0:425:b7ab:776e with SMTP id eb5-20020a0564020d0500b00425b7ab776emr12235190edb.142.1652699285871;
        Mon, 16 May 2022 04:08:05 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id p6-20020a17090664c600b006f3ef214de8sm3602500ejn.78.2022.05.16.04.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:08:05 -0700 (PDT)
Date:   Mon, 16 May 2022 14:08:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 3/9] net: dsa: microchip: perform the
 compatibility check for dev probed
Message-ID: <20220516110803.zzpb6kwjovnfsshi@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:13PM +0530, Arun Ramadoss wrote:
> +static int ksz_check_device_id(struct ksz_device *dev)
> +{
> +	const struct ksz_chip_data *dt_chip_data;
> +
> +	dt_chip_data = of_device_get_match_data(dev->dev);

And one other comment. You haven't converted ksz8863_smi.c to put
anything in struct of_device_id :: data, so that driver will dereference
NULL here.

> +
> +	/* Check for Device Tree and Chip ID */
> +	if (dt_chip_data->chip_id != dev->chip_id) {
> +		dev_err(dev->dev,
> +			"Device tree specifies chip %s but found %s, please fix it!\n",
> +			dt_chip_data->dev_name, dev->info->dev_name);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
