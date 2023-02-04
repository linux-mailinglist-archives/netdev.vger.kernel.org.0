Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F069768A729
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjBDAPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBDAPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:15:02 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C14274C14;
        Fri,  3 Feb 2023 16:15:01 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id mf7so19752960ejc.6;
        Fri, 03 Feb 2023 16:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtwR7eldYPsFLdAoiY+9o5YJsCvXaWXt8Y32OHoLhV0=;
        b=k10dIcaR4n1JwF72K5bGo0zE3p1RVSuphxA1ZfQ25qlG/HkW1w0DQBRtei3oqOm308
         80akBvMVUFJwt67V7rkq3AcO1srNnjkd9aSawe2J22Nd7DNNhhXazb87wOzB45JI5neT
         oCGfisygbMZ1hj5rl2ECnSiPzVSkC0gBQvgB2RBbjaLrXh+xcRVK2s1lP1JveaTfetKA
         LhfTiIqS6kWyfWjNmmvku6AKZZVxY3UIvDSQHQX1q8YY7n4m17pPRGyPQpN9CekfdauC
         mOI+MqwmQro/T9ZLjSWcvO+TpiCazvZWNNrW1NkG0oPHAo3fBjTnHYmOipkNbnNFOO21
         54Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtwR7eldYPsFLdAoiY+9o5YJsCvXaWXt8Y32OHoLhV0=;
        b=DU7p8ak/4l6mxCRGGX0yp2GE81o+1e8WvpQA+o6LhW1yi5hV+8h6z1XUCHdnkqGhtJ
         t996dwfB1/Zt9ck0TR9UJQsflXckQ33ztW4JPhF1eiHbARA9hN/fryvBzskhOVsbPAQs
         8VElXzG/a/1Eo1P81FCb4svBZYpDNl1apLeaB0Jg5S8P6rLVMKkN1VJNKuLszQHs/oyv
         o7H0d1I3fhQdgkCQr6i9hYfmht5H3zf4qt8eXKkB1FKm3omNeYC39jv0iowCsGXwob3g
         5YZSlJ5hmNocpCVf2LLfKgUWjV6dFpv18Dv+oOsQM4/tXBriN/yQWvBOjjqSfJwT3b3m
         UdiA==
X-Gm-Message-State: AO0yUKWGLRG1Fnc9StolL00Uo9ldsDWBdxYXTd5bYO8lV6+Bg5bwChbR
        ggDOilUD2O4XI6x1a6ErG5c=
X-Google-Smtp-Source: AK7set+ave84QQ4e5pMuqvuKQDmKBfO4aLBUkf0XxlrrFvwe3oN3D7jUghyrChCmOQuIO1xUEpUbTQ==
X-Received: by 2002:a17:906:bc88:b0:884:ab29:bd0b with SMTP id lv8-20020a170906bc8800b00884ab29bd0bmr13384998ejb.69.1675469699349;
        Fri, 03 Feb 2023 16:14:59 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709065e0c00b0086a4bb74cf7sm2041915eju.212.2023.02.03.16.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 16:14:59 -0800 (PST)
Date:   Sat, 4 Feb 2023 02:14:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 01/23] net: dsa: microchip: enable EEE support
Message-ID: <20230204001456.qf7xfmhyun7jqvbt@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:23PM +0100, Oleksij Rempel wrote:
> +static int ksz_get_mac_eee(struct dsa_switch *ds, int port,
> +			   struct ethtool_eee *e)
> +{
> +	int ret;
> +
> +	ret = ksz_validate_eee(ds, port);
> +	if (ret)
> +		return ret;
> +
> +	/* There is no documented control of Tx LPI configuration.
> +	 */

comment fits on a single line

> +	e->tx_lpi_enabled = true;
> +	/* There is no documented control of Tx LPI timer. According to testes

according to tests, I hope, not testes

> +	 * Tx LPI timer seems to be set by default to minimal value.
> +	 */
> +	e->tx_lpi_timer = 0;
> +
> +	return 0;
> +}
