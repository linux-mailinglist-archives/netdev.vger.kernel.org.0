Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6927A6871CE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 00:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjBAXWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 18:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBAXV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 18:21:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68CA1BDC;
        Wed,  1 Feb 2023 15:21:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h9so93809plf.9;
        Wed, 01 Feb 2023 15:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RuQ5ZmzHJIrYN8wm48zgeDU5xnjvRW/FpaERWiXybpo=;
        b=IqdLn+RFjvw7BwQXmWwheKLqRV++uYfps0JfKof5xVFHVTKzAeROH0xE6GdOa9mmmP
         dot32/qVThL03nNWutT7d/yl4O9c1g8kH+jRgfkAOLPH41znB4mN+B8LYTDul9qeeR8s
         RVzIwfPe4y4atzb2Aib96bvYV53CcWwlFna3kWB9WPeu6etn49ffj4IvEO62S/2gCMQ1
         9wGgn32LmBd7oyrAz4V0J6NNYcacqa3UJiOl4HEbiPxZxwLMYfyLvFEsgRILHCZxvg4N
         L3FKbP2/W5IgsTjBOeLUJyMExCCe/U9+jBTk/syYU9Br+o+nSEpTqdcZzRyTCOwnyalM
         eQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuQ5ZmzHJIrYN8wm48zgeDU5xnjvRW/FpaERWiXybpo=;
        b=31yBNNXuqkieK8f3Ep1V/SkOLLgpdHx/rt+iX0UkEIx49A48wAF5ENRLjyRXfDU9BG
         NQ4cRcwrs9TTzR6wcN8BuXplD2D8P5ZUk0hw9y0U47aVh81UiGTg1apGlfwjCcn8HCpW
         MO77G6N0+XGEjZ6NN/rEEJFOoKyi9OWoGUR18VdrFs+II1wPJyrWEYq4LuC4BeT0TR2Q
         lkjwfddScurVVSrdv4HEmW/cGr/oCioTdo1LKd+15CjcYEixwazB0W06jNhbbrcabIZH
         fOFAwxksWhIixiHmElZqNWaI7BKhTog7RGPM8+FnNL7ecWw+XZ2PQSjXIT9T6mQHn/36
         qlag==
X-Gm-Message-State: AO0yUKW/9nJyWNyFmH8piUDwgLAWsZwjBbRsAyNcumbXC8RhV2QkKiLU
        76LrqGCLL/Aq+y7oTLv7gv0=
X-Google-Smtp-Source: AK7set962Bo0v1fb70EvXQjNlgRDHTIQWJ0R/tcZLG8/EAxjYsRiNArEvM1gyiSS7T6gtR8QyUzSVQ==
X-Received: by 2002:a17:902:ec81:b0:196:7bfb:f0d1 with SMTP id x1-20020a170902ec8100b001967bfbf0d1mr5586980plg.34.1675293718268;
        Wed, 01 Feb 2023 15:21:58 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id jc7-20020a17090325c700b00192588bcce7sm12322178plb.125.2023.02.01.15.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:21:57 -0800 (PST)
Date:   Wed, 1 Feb 2023 15:21:53 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: fec: do not double-parse
 'phy-reset-active-high' property
Message-ID: <Y9r0EWOZbiBvkxj0@google.com>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
 <20230201215320.528319-2-dmitry.torokhov@gmail.com>
 <Y9rtil2/y3ykeQoF@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9rtil2/y3ykeQoF@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 11:54:02PM +0100, Andrew Lunn wrote:
> On Wed, Feb 01, 2023 at 01:53:20PM -0800, Dmitry Torokhov wrote:
> > Conversion to gpiod API done in commit 468ba54bd616 ("fec: convert
> > to gpio descriptor") clashed with gpiolib applying the same quirk to the
> > reset GPIO polarity (introduced in commit b02c85c9458c). This results in
> > the reset line being left active/device being left in reset state when
> > reset line is "active low".
> > 
> > Remove handling of 'phy-reset-active-high' property from the driver and
> > rely on gpiolib to apply needed adjustments to avoid ending up with the
> > double inversion/flipped logic.
> 
> I searched the in tree DT files from 4.7 to 6.0. None use
> phy-reset-active-high. I'm don't think it has ever had an in tree
> user.
> 
> This property was marked deprecated Jul 18 2019. So i suggest we
> completely drop it.

I'd be happy kill the quirk in gpiolibi-of.c if that is what we want to
do, although DT people sometimes are pretty touchy about keeping
backward compatibility.

I believe this should not stop us from merging this patch though, as the
code is currently broken when this deprecated property is not present.

Thanks.

-- 
Dmitry
