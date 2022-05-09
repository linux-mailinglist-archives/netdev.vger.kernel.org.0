Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30745201B4
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbiEIP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238792AbiEIP4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:56:16 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C61C83CB;
        Mon,  9 May 2022 08:52:21 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ba17so16823693edb.5;
        Mon, 09 May 2022 08:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=T4W3R+aw33VcSaWnTP2sFL45c75EFxdaakc2vCb8haw=;
        b=frArOZv2QWXyGt51ho8PKXrVN4tfIm0kqmW/YznWOW70opLM768dlqojLg6C3Ht/mb
         iPI1bHDjLwoQ24yYKJJzlnjcHx+/DwktNWK47YIqbXzMO8mg7avM+NU1s9lq6UG1uvIL
         atiILDmXdXkSRSBzTJrfUo9GYsNPt+Rz0Q1KjNRrSeRRCPqxQtX6a5EWcgqRjxs4q7Cw
         sX3N6ns8rZXlXe4ZBpw2+wGnKM+DqbxIHH0vJ+qoVawK5Swdgp95hP/n5Od/y4pTucpC
         gIHl2YE/iUoit+CyMAlDVwIwpbPNZb3tlmfaIEsWjSqtj8lJBlm50tstYqy71xXL64oi
         gVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T4W3R+aw33VcSaWnTP2sFL45c75EFxdaakc2vCb8haw=;
        b=ZaP/7cghs9UVAI++a5DsM+BbJekKmMShGNK1d/BGO5+Y7D9rPpazsAC0R1y8TvF1G4
         SlWcjSoI6Wz20843SYdT1m2o0OICgj/5M7B3Dgh5gcRH1B+pA92E22k6Xl8FI0tNh7bA
         eFgT+dHLbSioXxhnD0gGk37q4WOj2T81AvHY8pGHaAXEBGoinU5mgmrdwfEwL1HUaBpS
         ElAgCAVio0PAjRRaThergFa1+sEPvUU6zzlzhXv7aKttW33kogz11TH1AInhL4zQ83tW
         jVngri6i0zaAurzLnb3tikLyCMWfHPBQiEXAPXgaOfH4Q5wm/HKda4EGOm8HtJYudmKL
         azAQ==
X-Gm-Message-State: AOAM533ooqwjIiOVqECRgzsMizBskNg1cR8dA4/j9zOly3P5d+fIlVvx
        wWPwSE9DLBnBrLNpQrXvR7o=
X-Google-Smtp-Source: ABdhPJwq4n5/jPNzmdbqn/KfhjMByaspFBDbgGXP+1UiPo5jwEWXj1Uc/Z7GfLmkX5XIFy+ZLWRgMQ==
X-Received: by 2002:a05:6402:cb6:b0:425:f2e0:3644 with SMTP id cn22-20020a0564020cb600b00425f2e03644mr17935888edb.301.1652111540059;
        Mon, 09 May 2022 08:52:20 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id u8-20020a50eac8000000b0042617ba63c9sm6472240edp.83.2022.05.09.08.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:52:19 -0700 (PDT)
Date:   Mon, 9 May 2022 18:52:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220509155217.jrepbl3j4c5fmbpk@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509131900.7840-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:18:50PM +0200, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
