Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D194821B1
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhLaDLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbhLaDLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:11:03 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5181C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 19:11:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so24656521pjq.4
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 19:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9szJ+UmXuiCGNJc9NTUqqSXaJQVur6BZuNHtEn34wDQ=;
        b=l1k7SXLvnQ3+26Ecz/qK9J76T62KLBhXtplKRvtkeYUFqbvWDbT7+Bn9eWlhHKaGWx
         WxYRGe48KJZ3ggMO+J8yF4+KLGf5S0vQ2XkqQF98NOIs80yMYYVl/o+OE9HSAGji/mw1
         US7k20Q84IU7bZfhrJePWSwbSsugot3PWJPFjM2z1BlgiQy4R9Q6EhY3UvPJX4MuKGAp
         UrGDfyDJx/nfv2iN0bCjbvTDztqjcSFigMB4AV+N47kFBUs6Q4xAQAYvL23TjA0GVFy3
         DraUdgJSLPtFbHmp3Vuqw8Xy1R1AWY1FiEteJc1s3/TU5lFnGDjt1YUenf2HqM6WNxJv
         14OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9szJ+UmXuiCGNJc9NTUqqSXaJQVur6BZuNHtEn34wDQ=;
        b=Z6Co8+RrKfzpmUAv3BGUzJSFhJmpaFFmfZDfbgrPpkpnfDzyuRaYEduqDz5BP+0KRo
         LFNJRT5IxwbrLikmV7RoI6cSM1X43+zLgh5P/kvrIOlUR86uMePNEYlvMpXdZyPpJ6RE
         xJzjuzniRsmzV6/F3FshAd9bVLmRVmHfwFHj0CrRSJEoqXGMI1svNdCsB2G0WGksm+ib
         HjckMWH2m8gbS8V7dCI6vFpKSaOFBFXQCUhbtkagvv4tYXdWHUJW6ckKwVPNXNEavLsf
         TqauNB1vLGAsvl8c5CpEcS+N/MxnFJlxrAbquhSZWlZA4KjvBTPyZRUt6SuqD+VF7EO5
         y1oQ==
X-Gm-Message-State: AOAM530vVUlJ1bymgSqlVvpneGfFm7rkY9qP0+wD0PKU7JNk2DCUHLWs
        eRkwcHG9MGQ9blswreztGOv1EgGlWzfAr7l6P2nKuOpQx31y+w==
X-Google-Smtp-Source: ABdhPJxY99Cl2d1yxHiQdbbnvuyCVO/wIQDEr1Mvf/4WjtdZ04itqKKySWeH8EZDL5Adlq5p1IijA2ByxP3jFjafHiw=
X-Received: by 2002:a17:902:a60e:b0:148:ad72:f8e8 with SMTP id
 u14-20020a170902a60e00b00148ad72f8e8mr34791440plq.143.1640920263192; Thu, 30
 Dec 2021 19:11:03 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-8-luizluca@gmail.com> <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
In-Reply-To: <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 31 Dec 2021 00:10:51 -0300
Message-ID: <CAJq09z7QMvcW6eiY7OcmpxXiNMpd5h+2v+tH_YMeGsL2qRr7nQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/13] net: dsa: realtek: add new mdio
 interface for drivers
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
>
> I'm curious where these START commands came from because I cannot find
> an anlogous procedure in the Realtek driver dump I have. Did you figure
> this out empirically? Does it not work without? Same goes for the other
> ones downstairs.

It works without the MDC_MDIO_START_REG. I'm also curious that it
really does. It is present in uboot driver and OpenWrt driver. That
MDC_MDIO_START_REG is even defined in Realtek rtl8637c, but not used.
I think it might be something that an old family (rtl8637b) required
but not newer ones.

I'll drop it.
