Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31F6D169C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCaFGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaFGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:06:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DB11FE7;
        Thu, 30 Mar 2023 22:06:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so24247345pjb.4;
        Thu, 30 Mar 2023 22:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680239170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0t3z8Ll/uReIPR/3nRpifyNILrCT9yM4ZdYTLqjtu0=;
        b=ZGwswa5Zk9irpEAJpBsIrBZG9WdRzRZjADdspVPCd65zQ/SU8+QK/WlHoWN+Mkkqmm
         4o471Yx53YGqgnBVTtkfjYk9H5fMPZW/SXBM0RuwhMl5w8JYV5zg1A9mlrR+abiYf3Ga
         EhgN7YXpJOEkpOVLqSNJuxX6nOqR+6ugMYGtSITk5LMuhVDZ5b9YsvwH+BnDtgEWx5vY
         tGhssbtXyJgGcbZsCBGyOF7kXUisE9e876VIkUt4mtBkC7VZNtsQmvFLKq9pITeDDkhj
         Cyec4T4q7cWJcQCSQixBwVS3Bg901gdYX78s7oxZsdF1nLE4KS/mMzYksaIA3TQyaYmE
         Wj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680239170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0t3z8Ll/uReIPR/3nRpifyNILrCT9yM4ZdYTLqjtu0=;
        b=DarsAQIkAZJ55DixWL3pDNedJptE7S3pW+XdGHwMXtBMWoIAeERdJMCEcHg+g5eNbI
         N85HqtGf4qSfJy2pcjsVsoUZSui/R3J4WKv9Un82nkHZvUeOGtEAUzXNCotCfC86K1Wm
         q1nCP76uQIN5gsx9Ls3H5/2hkkSttdYm8VGqF0jhTJN1o+/sgxA2eD/cnBgzhO1lNMWY
         b8koOdGgiBXiTq/pTooDkllzJaClhEx/sdInUyZZix3T9sTnPTZqQuIt2RH19PUFFvRy
         8KMw6n2Qm8mTbEjc+lPB85P6gqq57BXcipJJmc4dK19IgAb2T2Ax8riHMUEPURsK7NWM
         Vliw==
X-Gm-Message-State: AAQBX9eipRJpikQi002gj2Jp6JkjFIax35TpPA65EJTEXxL3u6dceUl1
        NnsnUn2nXC52g2C/ASc1PHH2oI4JQ2Gy8GsjUtM=
X-Google-Smtp-Source: AKy350YOZEZ2eC5gHAHyUuiNpeEpbH/K/qa1CnvLltQ6k/EIuCtIIZXZHqzNgBQAHFZITX7ZO3yBVGOj7oLSYd8RfoM=
X-Received: by 2002:a17:903:455:b0:1a2:6e4d:782c with SMTP id
 iw21-20020a170903045500b001a26e4d782cmr3245223plb.13.1680239169665; Thu, 30
 Mar 2023 22:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf> <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf> <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1> <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de> <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf> <20230317120744.5b7f1666@kernel.org>
 <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
 <20230330143824.43eb0c56@kmaincent-XPS-13-7390> <20230330092651.4acb7b64@kernel.org>
In-Reply-To: <20230330092651.4acb7b64@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 30 Mar 2023 23:05:58 -0600
Message-ID: <CAP5jrPE-hWvnumjhJ71feETvXF9y33eArKV3iKyf+37Y2qt9Cw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be selectable.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 30 Mar 2023 14:38:24 +0200 K=C3=B6ry Maincent wrote:
> > > I started working on a patch introducing NDO functions for hw
> > > timestamping, but unfortunately put it on hold.
> > > Let me finish it and send it out for review.
> >
> > What is your timeline for it? Do you think of sending it in the followi=
ngs
> > weeks, months, years? If you don't have much time ask for help, I am no=
t really
> > a PTP core expert but I would gladly work with you on this.
>
> +1 Max, could you push what you have to GitHub or post as an RFC?

I'm awfully sorry for the delay.

I've sent out what I had as an RFC to netdev list, the subject is
"[PATCH net-next RFC] Add NDOs for hardware timestamp get/set".
I'll continue working on testing the patch. Looking forward to
comments and suggestions.
