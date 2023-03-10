Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90C6B49CD
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjCJPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbjCJPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:15:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904EE26C37;
        Fri, 10 Mar 2023 07:06:28 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so5460692pjp.2;
        Fri, 10 Mar 2023 07:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678460729;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ofHHg6fIbSRzVuSUsZdgjV1B186kH8cm7+Ef7BphX3g=;
        b=nN5DW1bWkerWgy4Rj0Rhc4VoP6Nt+wfTg1kWN6uWR1+RpGbC2XDs1uA9XXb2p7rIL8
         11wtM42KsGZ3obAuL32fU0YsJ6hw6XpfFYL9wpyEMvQ7Il8LXCk7GXqajUXF7yTOcAKB
         xc8N+gTtQZS403QkTvH1los7U7RxOI0P4K1NWEFMpcZ/uIko7LChMolev1GQ/wdDccsK
         DEj4trqb4BB9f3yC1SIvvAdTXLoG6mlEkEeBS+fwaOZCCngyS9HcPMTvbr8BUrTuQ9wN
         bNFNFHUqnFCl5XhS5xbzMa3IJf8ocQG2n6tanRoRgv2w5EmlqrnuTZ/iogkdA5HgXvnF
         5uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460729;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ofHHg6fIbSRzVuSUsZdgjV1B186kH8cm7+Ef7BphX3g=;
        b=L4flV6r+XBSjnyi62CTsL3O5qJ8TOmd8rMheA6vUX15ckeyGAo+1iyKmsoqG/XZ9yH
         YetDMjFrdFERjurlP47v82jaVDF1MfBVkfNwBC/gbEtEaSw5pg7GWKgZ5aiq4YGECecf
         P/tjwztTAPtbd2wv8TTWMuI7w+gASQq9ZnYyUK3jZ4ru7NKD0MtTmgJ3dRO2C6npg+sj
         JHSRJAaSq7OHoQ/stypVSLR3M7WthfC43RkLJF70tJDidCOTIYdbOa0Tc0cys5Vo5pC1
         Ye7BMdjxmJQtijWqwQRdij6LVxcolDCrmSytZMdvNa4Wed8tNZC98E8EAQec2W+mz2L2
         h40w==
X-Gm-Message-State: AO0yUKVYa754DdakcAeVQgVUSJLXPZqQbNJI0uj+iuKG+D0tGXfKz4O7
        BtsFGZS67LDu10uclQCd3IxAMqosDZAkAw==
X-Google-Smtp-Source: AK7set+oY1uoFFeNgUn1yO1HrcKEHwrb1cP1IDqiRtZTxJ4Zq7qGTFhjLZ6bAledhV1X3jvLbwAg2Q==
X-Received: by 2002:a17:90a:2ec4:b0:233:dd4d:6b1a with SMTP id h4-20020a17090a2ec400b00233dd4d6b1amr2718674pjs.3.1678460728870;
        Fri, 10 Mar 2023 07:05:28 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r20-20020a17090b051400b002376d85844dsm32741pjz.51.2023.03.10.07.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:05:28 -0800 (PST)
Date:   Fri, 10 Mar 2023 07:05:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Michael Walle <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <ZAtHNKPuZog0tnzW@hoboy.vegasvil.org>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <0d2304a9bc276a0d321629108cf8febd@walle.cc>
 <20230310150436.40ed168d@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310150436.40ed168d@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 03:04:36PM +0100, Köry Maincent wrote:

> Adding this whitelist will add some PHY driver specific name in the phy API
> core.
> Will it be accepted? Is it not better to add a "legacy_default_timestamping"
> boolean in the phy_device struct and set it for these 5 PHY drivers?
> Then move on the default behavior to MAC default timestamping on the otehr
> cases.

This sounds okay to me.  @Russell will that work for your board?

Thanks,
Richard
