Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD476BF1DB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCQTnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQTnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:43:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A89A1024B;
        Fri, 17 Mar 2023 12:43:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id x37so3545624pga.1;
        Fri, 17 Mar 2023 12:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679082225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=On053GRmvak1ihY8RYqod2dWpDbMYWVHxbUsiBufrE4=;
        b=bWuWBxePZdmS6fAxELkPLZtrc3YBaRacBPWnUC8Fg9k847PqQEM6GBoznngWHnRiM1
         UD2BY5mT1+gURMJ3oeXJBqMYo+/nA5HbL1pRA7qV/EVYvjnuKdh2rPo+oSs2cLja4vEa
         FZdnsYdwMwvpyqc0ZOEjyN1BSRdOghVTk+z64Eprz4YLPxPixUWdRzgK45LObe5IgHu6
         YPfN0xcIyKqY+RGRzwWlhhzMs5hUNkwWGv1/5bbcBTg0q6ubmKQeiXFXLQC5gYD4LMBg
         o/uZ9tU8y+5MWct8zPWDGetHzEBI9/GQ4F7jxYsVXYxcUWg9HpxLT6AwiLpYgk0XJsaK
         ynVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=On053GRmvak1ihY8RYqod2dWpDbMYWVHxbUsiBufrE4=;
        b=jp5/gkBRn9oYA9xebmIUjpbbhKxAljJIWemE8iw8fwT1ww7+eVfZ/5amohEYw+uXzT
         Svg8dcvOQA/tYN55Vc02c/+Coub8t4KOU8W4/aE+BuX//AEIqal3z3t/+Y8RLu1B+V/y
         iyzHaiCdeCTibydUmuBiXwygW+N04u05oISXfN/7BNdrzP8TP9IAhm0MW0r+QILPm+g/
         AF7BVO0JTcj+6dGK2b6oeK/kPt12IAnXnqmoBRhrdOBURmX/dWnTZDHoPCi85rp0hgnu
         ukdDExBPFnwbHZ0rAveLL8aArmBiQOocm4ULnEQqnzuRD00ghLI9SFJk/RRUjjXNvgjL
         hexg==
X-Gm-Message-State: AO0yUKUy0fvVdKU1fLqwyAfIjvEeFblBIYJkhYTDzmbsdXL0LK/Gy2NO
        +/kg2Xt0/eMY+ho0zu0IH1fnfmtoYWAUDwkQg+Y=
X-Google-Smtp-Source: AK7set/VvoBvLQmtjKHDMAsTOMhGtcA3zjyXPp1c3IIegaU12wGeed1P6f+RMZv7TSZVS2hLxgZnuJm8cIHFpckQksw=
X-Received: by 2002:a05:6a00:4ac7:b0:5a8:daec:c325 with SMTP id
 ds7-20020a056a004ac700b005a8daecc325mr1894046pfb.1.1679082225507; Fri, 17 Mar
 2023 12:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf> <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf> <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1> <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de> <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf> <20230317120744.5b7f1666@kernel.org>
In-Reply-To: <20230317120744.5b7f1666@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Fri, 17 Mar 2023 13:43:34 -0600
Message-ID: <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be selectable.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

I started working on a patch introducing NDO functions for hw
timestamping, but unfortunately put it on hold.
Let me finish it and send it out for review.

On Fri, Mar 17, 2023 at 1:07=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 17 Mar 2023 17:21:50 +0200 Vladimir Oltean wrote:
> > On Thu, Mar 16, 2023 at 04:09:20PM +0100, K=C3=B6ry Maincent wrote:
> > > Was there any useful work that could be continued on managing timesta=
mp through
> > > NDOs. As it seem we will made some change to the timestamp API, maybe=
 it is a
> > > good time to also take care of this.
> >
> > Not to my knowledge. Yes, I agree that it would be a good time to add a=
n
> > NDO for hwtimestamping (while keeping the ioctl fallback), then
> > transitioning as many devices as we can, and removing the fallback when
> > the transition is complete.
>
> I believe Max was looking into it - hi Max! Did you make much
> progress? Any code you could share to build on?
