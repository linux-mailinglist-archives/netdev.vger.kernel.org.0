Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8E5E636C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIVNRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiIVNRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:17:44 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768C2ECCCE
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:17:43 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a26so21026345ejc.4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LIf5TH9JGQQ/iaEojY/AW+9YyJO9O+pApuj6h9Zn+Oo=;
        b=XR9CfTR7JsHu1nQ276Pg97a2Go3cZXDzH3wqMdLhOuw/E6ma/YOsDW/inMM/Q15q5J
         xVacX4oM//6iHAirQLEKJuOESGiBahZqJyqY/i9/rJSemwwtmVKvn0hOOoYcF5QWrlcG
         Rqrz1RBMkeemL5KyKf0wiBz0yumU33S8kQPinYmvl0UbpDOdR6O6SRo9eAzSNXvXY6AD
         q6unIcPyDQ279Ma2kmKocwOkANlklRomJu7b7vnaGr6kozRAXfhI6EihnkzNq8ZaDjQt
         kBUQnlQQ7c9ahuzZQNTKsFlbI3EOWHb4vltTRZ0T0I+lnYTA4wgisHuIBBgk6fnHk2i0
         9Bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LIf5TH9JGQQ/iaEojY/AW+9YyJO9O+pApuj6h9Zn+Oo=;
        b=q+UWvOzVDsHVc5yQGKjK20G7xk+6KIrHma6r6TEqOTNVx7xST0eBsFr5A8keFw0ypB
         8+m6hpr0kKtitQolu/QomSZ/NDfUSdXsZier30U41mxA36R5k5CiJc/SP/ZwJoMWBVc2
         JxRQsWB82J/YqURbS7kJGiUKv99cycX+Oj5sNaezxN9bgVUlmxUqFLlAn8Lr8Nf2Xv/S
         WpzZMnV0g5xM9OdiFAYm20tinR16+fY+DJd+7plwpzHMGnbrdbMZYLKMI8lr4dZM5GFB
         QkrJgFuGJByE1eK8U02MLZQyWhhnmZuP4/eE5vcLe18WeNagOkLUR1Sgl4qZgiNd5Wh1
         aCJg==
X-Gm-Message-State: ACrzQf0HBWsWNqmVNi+6Ima0A0AYDLVBE/6bCGB+Q18QsEa4RxKLdO+V
        nYjNRX30GIsbfKG3zZaT41sTVAQ+A3ndVpmYZKAZJA==
X-Google-Smtp-Source: AMsMyM4AEYF9CYt5YlAWyS50lUMZDdk6imalOw5ibnI533T1FNtkfVSBoIAnTvx1ltXOT8MpKwI7hpeXId97fwlOgQQ=
X-Received: by 2002:a17:907:e9e:b0:77f:9688:2714 with SMTP id
 ho30-20020a1709070e9e00b0077f96882714mr2765135ejc.208.1663852661951; Thu, 22
 Sep 2022 06:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220921140524.3831101-1-yangyingliang@huawei.com> <20220921140524.3831101-18-yangyingliang@huawei.com>
In-Reply-To: <20220921140524.3831101-18-yangyingliang@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 22 Sep 2022 15:17:30 +0200
Message-ID: <CACRpkdZz_1S-qoOEED3UXj=ONtn5wdcJwyq6t9a7POUVgtFF9w@mail.gmail.com>
Subject: Re: [PATCH net-next 17/18] net: dsa: vitesse-vsc73xx: remove
 unnecessary set_drvdata()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, kurt@linutronix.de,
        hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, clement.leger@bootlin.com,
        george.mccollister@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 3:58 PM Yang Yingliang <yangyingliang@huawei.com> wrote:

> Remove unnecessary set_drvdata(NULL) function in ->remove(),
> the driver_data will be set to NULL in device_unbind_cleanup()
> after calling ->remove().
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
