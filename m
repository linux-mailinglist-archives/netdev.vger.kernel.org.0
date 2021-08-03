Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C0E3DF8A8
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhHCXyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhHCXyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 19:54:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8C0C061757;
        Tue,  3 Aug 2021 16:54:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id go31so1072009ejc.6;
        Tue, 03 Aug 2021 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YPFmNIw+yrL6Vwys09qoiCZ82cjs0qJnM22rwsvosfE=;
        b=GFYk9iIHpdjVstQ495pERkDGjlm06eekiz7uUxtdEcY70Ge1H1IS3RFSpYfpzRkjKX
         s4te386ArHsulQtxLv07zy24CjPV6sNfbBgOb7PyUvj3e8nBdU/uiAT0RWlQbf0rqiz0
         ETgDuwnc2G3R7NGLB9TT7+AyshlrBtexhmimZoYUALM7126hewFdwbuRn3LjqP3SN1XO
         3LhMq/isuf3zdL5RH5Kit0w70YLgYYRWVjZkC/1Byo5G9bo3JeTTgjurVNgA1GBHdcQY
         dYOFSWjWvXQUaeONozw+fva3cIgVqfpZ2djWWsADacELHDNABTlBGI0VRCTzQMPNlcDo
         Ku3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YPFmNIw+yrL6Vwys09qoiCZ82cjs0qJnM22rwsvosfE=;
        b=miCeHPsji/zupsbfFKC+X0DJjIhVh+gEk65Ps2wNV6gHvgGY/yqVXptjE7b7iHX4oo
         DH5tURnV9oP24bUqqJ19LV4OHBCoigWZuu5P9Km8jTGVot/CRRFFHwhFLuQ/K6XZXVQZ
         Q0GyM5G0XO2jDzLB7IcE2un6chr27LgJoPYyspzOCHOT/E7w7PGpjK2klqGF7F7I/AJZ
         fw3QEGfpH0YZCc68mycdL85t/q8H8wb0EGTPsFM3Uz8Gn2elNEKraevNix1hPxi/fti+
         dlUbYuufRcr0iWgKhI6jytcq8pg54/Qs347E7XFpiCq8nIKW54mhqyNKTDH/CozstEi9
         e3WA==
X-Gm-Message-State: AOAM533UeRDpnGDtVAO5RRL0L1ZTT5h4uzQY8ceWUwVS/EpWdb6zu/mK
        A+82aTOCgCQil8bp8jCzqC4=
X-Google-Smtp-Source: ABdhPJyECHP/nQBnn8BFsok2EET3ndAWnGt+qeys3LYWL6o4NcQPJmun6pvxaa9zJX13fiIKMBufVg==
X-Received: by 2002:a17:906:a08d:: with SMTP id q13mr22838074ejy.465.1628034842827;
        Tue, 03 Aug 2021 16:54:02 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id x42sm212236edy.86.2021.08.03.16.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 16:54:02 -0700 (PDT)
Date:   Wed, 4 Aug 2021 02:54:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210803235401.rctfylazg47cjah5@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 10:24:27PM +0530, Prasanna Vengateshan wrote:
> Thanks Vladimir & Andrew for the right pointers and info. The thread talks about
> "rgmii-*" are going to be applied by the PHY only as per the doc. For fixed-
> link, MAC needs to add the delay. This fixed-link can be No-PHY or MAC-MAC or
> MAC to in-accessible PHY. In such case, i am not convinced in using rgmii-tx-
> delay-ps & rgmii-rx-delay-ps on the MAC side and apply delay. I still think
> proposed code in earlier mail thread should still be okay.

Why? I genuinely do not understand your reasoning

  - I read a thread that brings some arguments for which MACs should not
    add delays based on the delay type in the "rgmii-*" phy-mode string
    [ but based on explicit rgmii-tx-delay-ps and rgmii-rx-delay-ps
    properties under the MAC OF node; this is written in the same
    message as the quote that you chose ]

  - I acknowledge that in certain configurations I need the MAC to apply
    internal delays.

  => I disagree that I should parse the rgmii-tx-delay-ps and
     rgmii-rx-delay-ps OF properties of the MAC, just apply RGMII delays
     based on the "rgmii-*" phy-mode string value, when I am a DSA CPU
     port and in no other circumstance

?!

I mean, feel free to feel convinced or not, but you have not actually
brought any argument to the table here, or I'm not seeing it.

Anyway, I don't believe that whatever you decide to do with the RGMII
delays is likely to be a decisive factor in whether the patches are
accepted or not, considering the fact that traditionally, everyone did
what suited their board best and that's about it; I will stop pushing back.

I have a theory that all the RGMII setups driven by the Linux PHY
library cannot all work at the same time, with the same code base.
Someone will sooner or later come and change a driver to make it do what
they need, which will break what the original author intended, which
will then be again patched, which will again break ..., which ....

If a perpetual motion device will ever be built by mankind, I am sure it
will be powered by RGMII delays.
