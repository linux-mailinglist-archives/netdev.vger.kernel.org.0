Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A691B49E60E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiA0P2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiA0P2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:28:45 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EF6C061714;
        Thu, 27 Jan 2022 07:28:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k17so2852798plk.0;
        Thu, 27 Jan 2022 07:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dvt/8H5X4Zu8vAr/0WKV1yh961pOvsSRhMVZVcge7QU=;
        b=aP3OU9wQlYl7w7q5mU6E5txvQDHnWyvnBTn0UnSEGFgujIo4qtasfeUxsh83W7+Ed5
         6KRoCPljieaoptQtIP9OlBPwC1ZANkTzKF9vzmGit6rtC7Wt63WL239O1QkfDvJlCRDS
         nMCio86UyQcbkspE/gkm+wwB0yYEp1PINlz1m2SOPMk12o4eX3PwvjgHdgcFL1RBIOy7
         T5f0Qq2+mWtdxI+f0Ei6ih8VB3fgxRrRipE03Jv1gLVag84gqgV8nZoiNuQmFogHrMs7
         BJp9Bo/bcpfJYgrN6TqI4AVjlsoZvbfSXhTmNqJLLvkIPc08hdtMAdX41EP219TEun85
         0KLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dvt/8H5X4Zu8vAr/0WKV1yh961pOvsSRhMVZVcge7QU=;
        b=poouGcyNclQSphUUf4aMEP4U5fdPSGsoezEiYenQflK+5PR/Q7+T6Q8fgd9H1hSdhF
         LbQdGkS7fF1ZVrAovRHp1g2+erxq1Irm9QcxMLk9oAEZmM/EQz/yNnT+2RixtBAh6X/s
         ZmvOzloi2A6B919PJ6b1NjrGiwE9Zo6ecl9yWlnTur0ST02lFq1Qg70YhmApxBOylDc6
         WXa50D20dKXeLNx+NkGlknKwUEa3PvX7gk8qlS+wZejVd1TUOHxmoz+KUtHyZy6x4XtL
         TMmGtuh+7MSm7iELwnnNUS4GJtmNl6Q2gqWQ9TpG7l2cd9J2/GltPlMYWf6aRakHssNS
         TFEw==
X-Gm-Message-State: AOAM5320JB3/Nfy43/iocwavtqFMLTQuy9DMbTJNiw4x7eY0+y8wA+TC
        SwEcPXyb/ssWmLj9d7yt408=
X-Google-Smtp-Source: ABdhPJw+nm3D4fY68u1pWfnw+pvJovu9UopHutnPRw7WlCh4v85Y8Kiy6nA9r0Su89o6XlGAkHApFQ==
X-Received: by 2002:a17:902:f083:: with SMTP id p3mr4296192pla.72.1643297324332;
        Thu, 27 Jan 2022 07:28:44 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g11sm4310269pfj.21.2022.01.27.07.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:28:43 -0800 (PST)
Date:   Thu, 27 Jan 2022 07:28:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 3/7] net: lan966x: Add support for ptp clocks
Message-ID: <20220127152841.GC20642@hoboy.vegasvil.org>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127102333.987195-4-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:23:29AM +0100, Horatiu Vultur wrote:

> +static int lan966x_ptp_phc_init(struct lan966x *lan966x,
> +				int index,
> +				struct ptp_clock_info *clock_info)
> +{
> +	struct lan966x_phc *phc = &lan966x->phc[index];
> +
> +	phc->info = *clock_info;
> +	phc->clock = ptp_clock_register(&phc->info, lan966x->dev);
> +	if (IS_ERR(phc->clock))
> +		return PTR_ERR(phc->clock);
> +
> +	phc->index = index;
> +	phc->lan966x = lan966x;
> +
> +	/* PTP Rx stamping is always enabled.  */
> +	phc->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;

Not true -- you allow it to be disabled in the next patch!

Thanks,
Richard


> +
> +	return 0;
> +}
