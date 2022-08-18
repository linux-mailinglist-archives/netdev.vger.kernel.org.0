Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38499597DCC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243490AbiHRFB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243484AbiHRFBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:01:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217295E7B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:01:23 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a9so683532lfm.12
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=i50TsWfzD1rOYDA+g6ULxMvaHUt5/Y8yXObW0WH7gXY=;
        b=b/gGpCQ8BeUba83Z2cWrojMiMEZ7zRyZUMUKmVQzVNWpZkTYA24KeNj/HZxrY9ghZz
         ji6xgql4TvZF89UH6xh4/slpJhegH3A1twx+hb2GgtkYddBxY73IR3CqsU/rMgHj/+dq
         WPK6zi1qcyQsTw2R16fr24UbXifu6mJtuFKKsFw9i5GfPrsmB6+3CG9i2xLpD1K9sqhz
         7EV6CDhMLPopOG5PIHfSEKz0eT/aImei9xxPlH01lC95w3eGoSmvlF5VedAJ6ZwasGyY
         vKyKz7J7632xXbbxD3y6ec6Lbm/aE7knmxEZngRgz+U4jHzEpwD9kyOB7jkzb0aYw50a
         6d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=i50TsWfzD1rOYDA+g6ULxMvaHUt5/Y8yXObW0WH7gXY=;
        b=nRNeggFum52cUirRQmrh9GrEbcFAx3VSG+SJ/CnmqNePb0kTvW8h1d4QyE8bCPKSFB
         oI1s8A1z10EawX3v1kGnmB1pL/1yPv5jMU8xofB/gSnw5r7SZhni4VI2MNZkL4Oekm2C
         o7J1dqZKem3zAoneEk/rfU180HhAX7fS27EI5WFacPCByCYgNlQq/xquaxDUTVH1/k7t
         L8VAoESqfNm+RV6oTR0GAVzeWLC7Cc3GMvktUodNV/AidOM/QdYATzfH9ukOkHswEVaU
         IRpkK+VfX68h2XauuLh7r4a5470vyAaYmwaKheADz2wkn2x6P1B+Duwa40rCqHclYGyE
         o15w==
X-Gm-Message-State: ACgBeo01Y1x4OdQyBGXmXIZoObe0ML+PAET9CwHogmn61UTItoIviG9d
        l9ay/LmEHPQhD9PJC38T6+s8VeuM7OOvA0YHBcI=
X-Google-Smtp-Source: AA6agR7gZ/R2sxPTmG61RwKPKjQwsCfbRryiN2jfbyB2gVg7z34LZklaPwqPIySvDpp4IZJ5Kt26XGMW2ll6jUyjRno=
X-Received: by 2002:a05:6512:ac3:b0:48a:fa85:7b20 with SMTP id
 n3-20020a0565120ac300b0048afa857b20mr397579lfu.340.1660798881945; Wed, 17 Aug
 2022 22:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220816102537.33986-1-chenfeiyang@loongson.cn> <Yv2gy3I+yLzU1dYH@lunn.ch>
In-Reply-To: <Yv2gy3I+yLzU1dYH@lunn.ch>
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
Date:   Thu, 18 Aug 2022 13:01:09 +0800
Message-ID: <CACWXhK=aS9Y+hWxCoE3-Y7=T+C9VyuSD_jiegviAArFde1GSWA@mail.gmail.com>
Subject: Re: [PATCH] stmmac: pci: Add LS7A support for dwmac-loongson
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Feiyang Chen <chenfeiyang@loongson.cn>,
        zhangqing@loongson.cn, Huacai Chen <chenhuacai@loongson.cn>,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
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

On Thu, 18 Aug 2022 at 10:15, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static void loongson_gnet_fix_speed(void *priv, unsigned int speed)
> > +{
> > +     struct net_device *ndev = (struct net_device *)(*(unsigned long *)priv);
> > +     struct stmmac_priv *ptr = netdev_priv(ndev);
> > +
> > +     if (speed == SPEED_1000) {
> > +             if (readl(ptr->ioaddr + MAC_CTRL_REG) & (1 << 15) /* PS */) {
> > +                     /* reset phy */
> > +                     phy_set_bits(ndev->phydev, 0 /*MII_BMCR*/,
> > +                                  0x200 /*BMCR_ANRESTART*/);
>
> The MAC driver should not be accessing PHY registers. Why does the PHY
> need a reset? Can you call phy_stop()/phy_start()?
>

Hi, Andrew,

This is a PHY bug, I'll try other methods.

Thanks,
Feiyang

>      Andrew
