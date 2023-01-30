Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA86813D7
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbjA3Oy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237881AbjA3Oy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:54:57 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B9C13DCB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:54:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h16so11289306wrz.12
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DBOpQJYrFBTRisXeKisTfMrcTyjxLh2di8KfVPbWNqU=;
        b=yKHFfxGFUyCjIMcxvHJEvAUDSj9OgEptKjOD4txVEqyNPntE8lDUViVchodbt0Hj1k
         c9FHCupazK3N7mGho43gKincjUaeyT7uCaNAy/6uOEg8XZxxztCvFK7oTBh2cJ4gmLgE
         7r+5gKQ7fPfY3b+YJ8LnW/fwL0vA7ZiaIvLYtuOwEue7lNs7ZVJXg8eZIT8qFLdc8zvt
         kaMj/LcWL6RJdqqLRdgOT7I+67H8NdS2dsMECQStAZAddAVkeXByo+gddLNkh9BOuc3R
         1CexiZK4c6kCRryEirmAuBMG8PTviOWRK0QWC5qWNALfDzShp++ifTbl7sJXONrQamjH
         VxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBOpQJYrFBTRisXeKisTfMrcTyjxLh2di8KfVPbWNqU=;
        b=IN+UkQZ08pjwl2unCjnCCcylYsvuP+wgQ23NTbmT7DhChNXHKq5NkTVB6Wiwaj/+jf
         XGeRhSycVyryfVXaYc6/DNs827yTigqcg3hP2fcRoPH/v6Fa3gEpkXQrAeDTOgF+jYVE
         xF6GtVXupkIRxzkYDrkhtdkCezYa0kwsVdL5rDuTMiFJBhXu0WCDLtT03rtTGpdWBWha
         TqCob0TA/+8aqYWcCxpiZlwRUzVLtC0Th55xi9zV6dxJRTYCxPKJUN4MF8B+sLxZIvBL
         TfQL5T6n2sNg13OsDtvkQ3ipCEzzH5QSzgj5z2yi3k5bsiccum0q4rJLKefR8BQsN9L/
         e/3g==
X-Gm-Message-State: AO0yUKVppWM/PEN4MGD2/m9Ux9FHqtHf9XHfxqD42NWa8MQmxMDhj8Jy
        y5Eiy9s0/dD6jbZyD1oN/JftTg==
X-Google-Smtp-Source: AK7set984+SMpkQTbwcvMG4YeVGE0ndrZoyiRnap/3z+W0qvqktcQHTobeelX/749h7V8DxCcL4QEg==
X-Received: by 2002:a5d:4c49:0:b0:2bf:c82d:7ad4 with SMTP id n9-20020a5d4c49000000b002bfc82d7ad4mr13257293wrt.7.1675090494310;
        Mon, 30 Jan 2023 06:54:54 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id m13-20020a5d56cd000000b002bfd462d13asm11233373wrw.18.2023.01.30.06.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 06:54:52 -0800 (PST)
Date:   Mon, 30 Jan 2023 16:54:51 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Stephen Boyd <sboyd@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-clk@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Abel Vesa <abelvesa@kernel.org>
Subject: Re: [PATCH v2 15/19] clk: imx6ul: fix enet1 gate configuration
Message-ID: <Y9faOzCkeNea1bmd@linaro.org>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-16-o.rempel@pengutronix.de>
 <Y9atr+Gn60+m4nOg@linaro.org>
 <20230130121530.GA10978@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130121530.GA10978@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-30 13:15:30, Oleksij Rempel wrote:
> On Sun, Jan 29, 2023 at 07:32:31PM +0200, Abel Vesa wrote:
> > On 23-01-17 07:14:49, Oleksij Rempel wrote:
> > > According to the "i.MX 6UltraLite Applications Processor Reference Manual,
> > > Rev. 2, 03/2017", BIT(13) is ENET1_125M_EN which is not controlling root
> > > of PLL6. It is controlling ENET1 separately.
> > > 
> > > So, instead of this picture (implementation before this patch):
> > > fec1 <- enet_ref (divider) <---------------------------,
> > >                                                        |- pll6_enet (gate)
> > > fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> > > 
> > > we should have this one (after this patch):
> > > fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
> > >                                                        |- pll6_enet
> > > fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> > > 
> > > With this fix, the RMII reference clock will be turned off, after
> > > setting network interface down on each separate interface
> > > (ip l s dev eth0 down). Which was not working before, on system with both
> > > FECs enabled.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > 
> > I'm OK with this. Maybe a fixes tag ?
> 
> Hm. Initial commit was:
> Fixes: 787b4271a6a0 ("clk: imx: add imx6ul clk tree support")
> but this patch will not apply on top of it.
> Next possible commit would be:
> Fixes: 1487b60dc2d2 ("clk: imx6ul: Switch to clk_hw based API")
> But this patch didn't introduce this issue, it was just refactoring.

Hm, in that case I don't think is qoing to be backported ever.

> 
> What do you prefer?

I'll apply it as it is.

Thanks.

> 
> Regards,
> Oleksij
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
