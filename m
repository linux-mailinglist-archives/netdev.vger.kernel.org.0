Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112605619B6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiF3L5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbiF3L5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:57:06 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ABF58FF9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:57:01 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3176b6ed923so176218027b3.11
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T2nf43YSG2Rmj+bAJwbn+WqQ9U0uX95RW/bS0f0BEIk=;
        b=xX22BKzLNWetYuGqacglbCbctbEFAqaw/9VSCakoyY1uZ/lUsbRrOi5MPNjNdCKQN7
         auegeivkAV5FQ+lTQkNytjNOQrKUT15ORn8L+4LjcV4/uZT3Ecv8R4+ZE2VzN/1pkJCB
         LTWU6L9wNQlbxiWOMY3eRQzSab60pao7/ezDEKGrL6FPkEZrhFYs3flAtJlnGJ67hw+W
         DuugEAx86feg+q2PbjwxvDQ7IXtr/G2VXfl/TsXaUiX539ecJD45jYNRoQ5QyTV8/qgz
         8Y5gnJ6P5kyLFyFoIGcVUWqtd/mvRLwwkDlWsR9NkgrPm0BFzV0FtoyvPPkJU/bWtbjE
         CpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T2nf43YSG2Rmj+bAJwbn+WqQ9U0uX95RW/bS0f0BEIk=;
        b=7oX5Ik5d2838I1rXQRMbfxFKOgaUdnuQ0fA0HTJNzPbpwvSr2xQLAdn0H82jHRk1YB
         DOxOfILRZeBRIZ4n3oX++YhNAw4VoMJXPRIXh3L84xQ/5tdNTtFvBurrHGV9iFSKSkvV
         BYgg9DpHfzxdmQyaX1VxKsosh+UbvN3iGc02vR10DSjtGicQgxeK4gETFq3nvmRFPwox
         NX3TTWipZCfN05A5AuPdpmlZoM41Cye9EslGXIPiuHkV2vgi2kFxYRZzI1fSfU1I/9SZ
         m1TKD9LTpVX33RaDuWZUHL5SKZ7WMWZ3dXcwQe8UigzE9A/hhaIvl/CK9oYc6EKEAwrF
         PhsA==
X-Gm-Message-State: AJIora9pjm/pJclb/cZyJs52Mrj4K0UjJ4T5zcXodulIAL//mrc27oaC
        /wVQfF4So1QXvsSelhq6lZa58vMc+E7py1FjXH9emA==
X-Google-Smtp-Source: AGRyM1vpjSh9Y05u4DDxMAgxG1Ha5a6O1Yp1CqeRVvx6hQ7LjjtidYeoQ5W9aC0ImR5rk487POkEk9TQdl0wKxfgqfc=
X-Received: by 2002:a81:d05:0:b0:317:76a1:9507 with SMTP id
 5-20020a810d05000000b0031776a19507mr10201231ywn.151.1656590220853; Thu, 30
 Jun 2022 04:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-4-colin.foster@in-advantage.com> <CAHp75Vcm=Zopv2CZZFWwqgxQ_g8XqNRZB6zEcX3F4BhmcPGxFA@mail.gmail.com>
 <20220628182535.GC855398@euler> <CAHp75VejZB8Wg4tuz51r1ezLw0vawP+LNcYkmHd5FjyQTW4asA@mail.gmail.com>
In-Reply-To: <CAHp75VejZB8Wg4tuz51r1ezLw0vawP+LNcYkmHd5FjyQTW4asA@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 30 Jun 2022 13:56:49 +0200
Message-ID: <CACRpkdbi+LmLSuqLn5=K-KvSzLrYQs2H5mwSkOVi+5xTJoZBzQ@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot to
 be loaded as a module
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 9:00 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Tue, Jun 28, 2022 at 8:25 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> > On Tue, Jun 28, 2022 at 02:53:49PM +0200, Andy Shevchenko wrote:
> > > On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
> > > <colin.foster@in-advantage.com> wrote:
>
> ...
>
> > > >  builtin_platform_driver(ocelot_pinctrl_driver);
> > >
> > > This contradicts the logic behind this change. Perhaps you need to
> > > move to module_platform_driver(). (Yes, I think functionally it won't
> > > be any changes if ->remove() is not needed, but for the sake of
> > > logical correctness...)
> >
> > I'll do this. Thanks.
> >
> > Process question: If I make this change is it typical to remove all
> > Reviewed-By tags? I assume "yes"
>
> I would not. This change is logical continuation and I truly believe
> every reviewer will agree on it.

I would have to think hard to remember a single review comment from Andy
where I didn't think "ah, yeah he's right", so definately keep mine.

Yours,
Linus Walleij
