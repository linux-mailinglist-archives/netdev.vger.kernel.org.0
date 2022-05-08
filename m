Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0B51F1C7
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 23:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiEHVSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiEHVSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 17:18:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CE1765F;
        Sun,  8 May 2022 14:14:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g23so14195257edy.13;
        Sun, 08 May 2022 14:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w+wW2j4Qi2ZhKYtEoYitFu0KdkNdZFsS+kowU+VfreY=;
        b=Wj4XjWI2kf1xIO5YfBwwdg2vdJWpb1sNLQhpYx1yxsTqitNWCVQ5/Kb65yVMFm5coF
         Mu8rT6p6VeemiMfz28Aw4L+MoYBvc4sU+5ESTP50bzMSQjPe+W5W0J61hV6cA05+0KG4
         W+LUm4H2iFJ3qf4CHWPu+iTCKRXJKY1jDbCKFtsHBK6pLOaXXterBldefbbTAJJ9syx8
         ffu5FuTqyUsL6bqL1Hm+bbX/q3vnW4zaLw9nmI8HvNrNWQ0HRP3AFhRuLcjP/jBne3O+
         CmNFjgj09fq4+lsny6mVR78KIS/FtEdGZ2Yhm07WUkkwNyTtilEQkmW97TQWJ9/u8WkR
         cCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w+wW2j4Qi2ZhKYtEoYitFu0KdkNdZFsS+kowU+VfreY=;
        b=LrJe8Sn6eHlN+z334h+68Gl4vV4KRJ+fbECmX3FXg8R3z6h9crzM990pneL+YCGBL6
         Yftm8Etl6XLFi9Zm4lb3EM6KL3XRz+1b/rTmZxROdpK2JNtHJRnwCh7Do8ARdS/6FSm9
         w4TnHhBYfZwf66RRXjizc2DCvTySzqYWbZuduNeKGQ6HH4dw8D2rnWCrHAagR7+z7Adh
         XHuXQGV/TjzLaxJ06dZbu0u/1Md9kjyHbzSEibzKJo9krP6VWt5ooiKDMbL8toE2sJGI
         rxSQDgf+S8oH8lH2qws9VbyPAOWT5zA1detYenfKxD5/QpL3Xtges8Zc97Pbb9b1CIA6
         +W3Q==
X-Gm-Message-State: AOAM532Rtoou9YURBMCzmmU6OROoFij8lSysyhEeDMi2L72npyuNJh24
        zwtQfS+/5YK17sOHrggvoShRmmTGxtteCb9Jw7s=
X-Google-Smtp-Source: ABdhPJyoW50uF0WrtGrEbHbI9iwmrV+S8/zNPOIFMyKSdKez42MdNCM8dpOaAKhXpe/Sf/uREYeC+0buKxPavuthygY=
X-Received: by 2002:a05:6402:1d4c:b0:427:d1f5:3a41 with SMTP id
 dz12-20020a0564021d4c00b00427d1f53a41mr14079196edb.218.1652044488894; Sun, 08
 May 2022 14:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220508185313.2222956-1-colin.foster@in-advantage.com> <20220508185313.2222956-5-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-5-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 8 May 2022 23:14:12 +0200
Message-ID: <CAHp75VdAE70EbAyuPXFQPLq+4E_Bj+8VbmY7amEB7TFB=U5HZQ@mail.gmail.com>
Subject: Re: [RFC v8 net-next 04/16] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 8, 2022 at 8:53 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

...

> +               res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> +               if (!res) {
> +                       dev_err(dev, "Unable to get MIIM resource\n");
> +                       return -ENODEV;

return dev_err_probe(...); ?

> +               }

...

> +       if (IS_ERR(phy_regmap)) {
> +               dev_err(dev, "Unable to create phy register regmap\n");
> +               return PTR_ERR(phy_regmap);

Ditto.

>         }

-- 
With Best Regards,
Andy Shevchenko
