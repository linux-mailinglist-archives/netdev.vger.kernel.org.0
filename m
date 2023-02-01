Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489B5686DDD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjBASZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjBASZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:25:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CBA7F338;
        Wed,  1 Feb 2023 10:25:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id pj3so5288244pjb.1;
        Wed, 01 Feb 2023 10:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WT1kYk71H5+F2NIHrZR2ueHQKDmqPxHY0Sy9yM/Jt/U=;
        b=W1kcdOPsY9NR/pom5pLjLb482PINGXLbueZICSBtQNSt8qJ95BM+rqPOzCjbaVs3/X
         BMvmtvDr/ikGQ+nQDTEG5sd/u3So03MMi4AijNBxshj3jiePqF7O1VR5TnWQ+fRJ16WH
         ArQ4apiDNUC71NntKg0TmozqgIBlXbare24It9qhmbZ4W3JFGwFFe6SMtCHXKdegOzR2
         nyjgF1KNgwyuaYLMSUNpwfhRP+xs0tyeRTWEvlgJLLk4YaixUMfgDslnaEZ5xoe6TVgh
         sIROCEubLAC+BnlPqYwnqaVvYTa6C9anYog46BDwOVuGWz4X9wmcpjVTyv6sPljxXAsn
         hqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WT1kYk71H5+F2NIHrZR2ueHQKDmqPxHY0Sy9yM/Jt/U=;
        b=UAlHuMfoKqvhLZqZLcj2FN027No4Z0xgmQuq3/+Q23hG0yv1QTjjj8BGQq/zDmZwkz
         xecOAWoO0yEJMhNCWEtBgcADU4QfKBy6UzGt6XQmBFMEvqsPTAg+M8jqCx6Ujk/ZsbGw
         BBWKedpkKK3cXJIVtVPt2KNgw+BsYD3YjPZmp8JCgT+LKYZDYd6wP+AwzGD92vpLVQZt
         /cZthCR/LaHnkdD7qZUcWgfoYY91CjE3n1J+hUCH/LzJ27kDyecf6ZoMfbWBHLajCr9S
         poCIJVfbhs6uehysK2BEqXq5ojgxGVqXyTcQIsENhKrnMTJwPJkZSCNK3XgPnmuSG8Zq
         xPTw==
X-Gm-Message-State: AO0yUKW09g6wKc4OuP3OksL/BvHKk9adtn7hZ3AblUwo9fLaUlDb7Tvt
        6vk+mNg/g6yFOnKDbbEVARQ=
X-Google-Smtp-Source: AK7set/pnb0eWwpI76x18nzTVch/uj1fmn8qELtYyV7aoHwyCho/5m5WqDYG+29mbNx7ukB+A6C7VA==
X-Received: by 2002:a17:902:d293:b0:196:6215:8856 with SMTP id t19-20020a170902d29300b0019662158856mr2792979plc.64.1675275920116;
        Wed, 01 Feb 2023 10:25:20 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id g23-20020a170902869700b00195f0f318b0sm10537138plo.91.2023.02.01.10.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:25:18 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:25:15 -0800
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
Subject: Re: [PATCH v2] net: fec: fix conversion to gpiod API
Message-ID: <Y9qui5431SMSUy0K@google.com>
References: <Y9nbJJP/2gvJmpnO@google.com>
 <Y9qprbyr/0sa3sBN@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9qprbyr/0sa3sBN@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 07:04:29PM +0100, Andrew Lunn wrote:
> On Tue, Jan 31, 2023 at 07:23:16PM -0800, Dmitry Torokhov wrote:
> > The reset line is optional, so we should be using devm_gpiod_get_optional()
> > and not abort probing if it is not available. Also, there is a quirk in
> > gpiolib (introduced in b02c85c9458cdd15e2c43413d7d2541a468cde57) that
> > transparently handles "phy-reset-active-high" property. Remove handling
> > from the driver to avoid ending up with the double inversion/flipped
> > logic.
> > 
> > Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Please split this into two:
> 
> 1) Fix for it being optional
> 2) Removing support for phy-reset-active-high
> 
> The breakage is in net-next, so we are not in a rush, and we don't
> need a minimum of patches. So since this is two logical changes, it
> should be two patches.

Hm, so you want the driver be still broken after changing the call to be
devm_gpiod_get_optional()? Because you can not have this driver use
gpiod API and keep parsing 'phy-reset-active-high' (by the driver
itself).

OK, I suppose I can do that...

> 
> Please also update the binding document to indicate that
> 'phy-reset-active-high' is no longer deprecated, it has actually been
> removed. So we want the DT checking tools to error out if such a
> property is found.

We still parse 'phy-reset-active-high', just parsing happens elsewhere
(in gpiolib), so it is not an error to have it in a binding.

Thanks.

-- 
Dmitry
