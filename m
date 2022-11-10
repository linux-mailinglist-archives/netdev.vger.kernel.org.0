Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586E1624DA6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKJWdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiKJWdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:33:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA656554;
        Thu, 10 Nov 2022 14:33:11 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so6179632pjs.4;
        Thu, 10 Nov 2022 14:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gY/OzJoPnw06nvF/ax1dzsyttFIg/d8ctj7MuL258E=;
        b=M+4u4lcZ0g8mC7ch0OT4x5PLDybVoticZj3bC8HjO0tdR+1iL639F8CnsHSzkCO75v
         xq+TTSX9X81HBms18pplxiyp73xjplqMJyC8NOu2cLnB+Pv1TUaLwYu92VpnUs1lta57
         +TKvsOynQ7nkn3rHnIAm08/WyKt7pjRXcLsbA2pWt6xXpSEOX4/1uLNz7Wm6CXiKhBkP
         Q1kBOIwCb5EEKVJsYP/jf2GoNVtIfEk3aiwiZ/RMufstZm3QXYX5POHepKlBZQ8O25yN
         ifLSDAFG1y3pzyqP+q0ANwOqz7EBlx2rvM9koKUZAD5x934+tzva5HcE4lZvf0Q5eIQ+
         mjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gY/OzJoPnw06nvF/ax1dzsyttFIg/d8ctj7MuL258E=;
        b=NaxemziIDgA7cIDlyhp8yS/Gy3Vklm5aDHurpmGCvnWd0STmNruzw3BxsoBV1MJJxC
         n8tFl43GraN3rqmhlBcP6tIpvGDUNVgtFGo+i8txmfzVjQB4KbTdjq60D5I2c1K0NHb7
         u5ZoI6l8ObwT9VhHtHlw3RDbRc7iW4kBfL+EPAF7HmQ2hHCUgZ9DkVbhumVL7c0C1zcn
         I/qzOjo6L1sWKFDPhemNcFjRtpardepaxuqHTuGWgcL3e9mjIENNf49XJuh7YbTQg3ML
         4VRAQ9fx0kl7uIYB3loX680yncrTbq5AifwTsaieby2r1L/1zryam8rCMdtzrPpCG/+I
         HpPQ==
X-Gm-Message-State: ACrzQf2GFSFUT9JcySnmIYqt1v2CTHsS6k2sLBMzYGEhDPaDUhViy5G9
        K/v2RKrp1v0RJTzx0Y7oZLY=
X-Google-Smtp-Source: AMsMyM4uxqy0CAq22wSngxYpEuQrP/za0C3jljiPdLH6FvdkUTfDrtGBxiG84ErK0aCiPHpUkUU35g==
X-Received: by 2002:a17:90a:8503:b0:212:9b3f:dee5 with SMTP id l3-20020a17090a850300b002129b3fdee5mr2317401pjn.62.1668119590803;
        Thu, 10 Nov 2022 14:33:10 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:2eb5:1c59:61e8:a36d])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b00186727e5f5csm164375plh.248.2022.11.10.14.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:33:09 -0800 (PST)
Date:   Thu, 10 Nov 2022 14:33:06 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>,
        ludovic.desroches@microchip.com, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, 3chas3@gmail.com,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] mmc: atmel-mci: Convert to gpio descriptors
Message-ID: <Y218Itfc4wp3XZvt@google.com>
References: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
 <CAPDyKFo+FUAZ=1Vu4+503ch5_Wrw47BanTjdB=7J8XhRwczyqg@mail.gmail.com>
 <CACRpkdYeJ0NuJr_RF10oMAEuhYTBfaLfHoZ=b3A2f4BqXkvzOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYeJ0NuJr_RF10oMAEuhYTBfaLfHoZ=b3A2f4BqXkvzOQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 09, 2022 at 03:48:32PM +0100, Linus Walleij wrote:
> On Wed, Nov 9, 2022 at 1:39 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> > On Wed, 9 Nov 2022 at 05:39, Balamanikandan Gunasundar
> (...)
> > > --- a/drivers/mmc/host/atmel-mci.c
> > > +++ b/drivers/mmc/host/atmel-mci.c
> > > @@ -19,7 +19,8 @@
> > >  #include <linux/module.h>
> > >  #include <linux/of.h>
> > >  #include <linux/of_device.h>
> > > -#include <linux/of_gpio.h>
> > > +#include <linux/irq.h>
> > > +#include <linux/gpio/consumer.h>
> 
> This is nice, but higher up the driver also #include <linux/gpio.h>
> so delete that line too, <linux/gpio/consumer.h> should be enough.
> 
> > > -                       of_get_named_gpio(cnp, "cd-gpios", 0);
> > > +                       devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> > > +                                                   "cd-gpios",
> > > +                                                   0, GPIOD_IN, "cd-gpios");
> (...)
> > >                 pdata->slot[slot_id].wp_pin =
> > > -                       of_get_named_gpio(cnp, "wp-gpios", 0);
> > > +                       devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> > > +                                                   "wp-gpios",
> > > +                                                   0, GPIOD_IN, "wp-gpios");
> 
> Hm. Dmitry is trying to get rid of of_get_named_gpio() I think.
> 
> But I suppose we can migrate to fwnode later.

I'd much rather we changed this right away to

	devm_fwnode_gpiod_get(&pdev->dev, of_fwnode_handle(cnp),
			      "wp", GPIOD_IN, "wp-gpios");

and not added new users of devm_gpiod_get_from_of_node() which is there
only 2 left.

Thanks!

-- 
Dmitry
