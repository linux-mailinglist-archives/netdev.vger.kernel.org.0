Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F836D16A1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCaFHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCaFHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:07:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FB4CA36;
        Thu, 30 Mar 2023 22:07:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x37so12729383pga.1;
        Thu, 30 Mar 2023 22:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680239255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88Z57OGg3cwPCqThSTGlVSFUSYsA9hWzAPsi7A60mvs=;
        b=iXnX0cLfuO/Up0wGmvlhCNoeIONpD3jgq3i3WpRqqAo8TK9GgWSkS5A99zEyTSf5XI
         KfmlmgFNBSlLbMtu+TP12vc1sxbylWLNR3MsRifTKRr67KY6S2y2jFKWG7k4Ghqz2COR
         5HINeLPUjZDhKRBK2sJ+L9HBSBRkygOV3iQtQQo2XjiZYpL1JQTY62H0PJrZzLIzdF5G
         wlx7TRfF//yOcIXTqK9ONy6QdQHddHmMg+cHDPGRHSLOC8QUjvSaux7sKK46IpjplVuO
         wEWFYLYwzCJNKZMuBzpmJuTmj+AwCKfs9NdQn4Hlu83rOql7ARbVO6aSqAY7HGay4Hx9
         dXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680239255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88Z57OGg3cwPCqThSTGlVSFUSYsA9hWzAPsi7A60mvs=;
        b=66C8CluhriLjGhHEFy0br4b/DjwLRqamG8ImoSGH14a2uXvINaLBe1ZNrAcJWRwBTp
         db9m+jshNf4z2obpcCNyEr9DdVvtsk42QpS4OCooXHy69C20U0A9lNEXqMYJpLo4hQGT
         oQfzESW7Z4g9m70zXZwuvBhAD7aI0jDuCmsgPgv9RE2dwGzW47oPKBA9GUQH0WXkzFLF
         6HgxW74DRqfQy3bYwKBgKE24/4IGspoWSuCFyXZAmOyAzZTYjBWaUfFjYanIYGllCQGj
         UOpPs5xLss4FaoGg4eXX6DdvX6or07yliui7ClusjpYac1XIvonrF+NF9kj85WeVnNxA
         vTIw==
X-Gm-Message-State: AAQBX9fp1Dk1mfP0R0XHzoOaM6BjfewkLiJFyZU2t48+0rt4ZnM+L/ii
        LNA2FVLDHg1a6Uu0MOjYC7eBbATr/kRLuZu/7yI=
X-Google-Smtp-Source: AKy350ZE4EOZdEvUc8MwsERuvROFpRDrZf/cfe+Uuc59b3+h1td1Lxl8ogsioDu6BwwI5K92eFeZPY4ncAqFJGTK87c=
X-Received: by 2002:a63:5f02:0:b0:507:3e33:43e3 with SMTP id
 t2-20020a635f02000000b005073e3343e3mr7137369pgb.7.1680239254940; Thu, 30 Mar
 2023 22:07:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf> <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf> <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1> <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de> <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf> <20230317120744.5b7f1666@kernel.org>
 <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
 <20230330143824.43eb0c56@kmaincent-XPS-13-7390> <20230330092651.4acb7b64@kernel.org>
 <CAP5jrPE-hWvnumjhJ71feETvXF9y33eArKV3iKyf+37Y2qt9Cw@mail.gmail.com>
In-Reply-To: <CAP5jrPE-hWvnumjhJ71feETvXF9y33eArKV3iKyf+37Y2qt9Cw@mail.gmail.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 30 Mar 2023 23:07:23 -0600
Message-ID: <CAP5jrPEViyQzKvTE3Q+cKWXUnqA8u_L4XcwYq8UxgYkenfWVkA@mail.gmail.com>
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

On Thu, Mar 30, 2023 at 11:05=E2=80=AFPM Max Georgiev <glipus@gmail.com> wr=
ote:
>
> On Thu, Mar 30, 2023 at 10:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> >
> > On Thu, 30 Mar 2023 14:38:24 +0200 K=C3=B6ry Maincent wrote:
> > > > I started working on a patch introducing NDO functions for hw
> > > > timestamping, but unfortunately put it on hold.
> > > > Let me finish it and send it out for review.
> > >
> > > What is your timeline for it? Do you think of sending it in the follo=
wings
> > > weeks, months, years? If you don't have much time ask for help, I am =
not really
> > > a PTP core expert but I would gladly work with you on this.
> >
> > +1 Max, could you push what you have to GitHub or post as an RFC?
>
> I'm awfully sorry for the delay.
>
> I've sent out what I had as an RFC to netdev list, the subject is
> "[PATCH net-next RFC] Add NDOs for hardware timestamp get/set".
> I'll continue working on testing the patch. Looking forward to
> comments and suggestions.

Here is a link to the RFC patch:
https://lore.kernel.org/netdev/20230331045619.40256-1-glipus@gmail.com/
