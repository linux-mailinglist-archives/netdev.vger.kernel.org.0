Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43A26869E0
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjBAPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjBAPRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:17:23 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550286C12E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:16:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id g8so4297357qtq.13
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=koIfQU/IlXrNYeN5rsjpnJ64SDYl1SUTYEJnhhNEjXE=;
        b=Mybxe/FN1h+WqvZM0/4hPqE4yMhkASAFg+6qIZ2ur+kf52i808WVrdbZREBcP2n6sR
         MA6gljSRHTQYno/1trZ5srkJhxhwV6Ph9iV2kJeibdEl9N40Zl3hEKCwHXfn6oTb9RL1
         EOEmzmfx3ZZ92tH+X6rvKVekvikTmzPZNoiBDsJ5PotpBDHa5dEJqer0roVpQTTu+vaQ
         9KRZl5UK0Y19Ls8RMs1zoB3psFWgdeGnh561TP8oTQGAbXePm77ZuPpynDtR8R+AgbNg
         RR/BfPHJpcjCufNBJw7OIyqwDzqkjVvvQ84HZZgy1SQTDacjw8iRRyCQPw0ZGAGPF6Fx
         8j4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=koIfQU/IlXrNYeN5rsjpnJ64SDYl1SUTYEJnhhNEjXE=;
        b=WpFehYrtrVad52t4sRnd6ZoQAVA+RAFs95EQvG9Zwo4dpM62hK07FzwpNK7mcWN+gV
         OSU2kWtPZ5NpEIzUibea28VE7821p/UzIanOKNnNbRaBodgdPk3Qap1JxYoXTtgv1z5F
         w19NftD2efoCoNar2N2AngYqwohWHrR+z0gSiKqEDg4OX0jr9JzyJUqe6yLR/vaF+O2a
         3z0NHONOdaTW+kYYMz5JuAt1mfmwI/2x0HBO/Y6dsGBzAbE4n58z8c3IXm7yBXbzUXlv
         sqS6GUndqb5UlJ7gjouPoKJHuaWubaHd/ZxR/TBGtX7W26kZ+NjuRZn8IqGBOpe7bR8s
         P1vQ==
X-Gm-Message-State: AO0yUKVmCzkY/LKsdq5BXBqw0b4pM8Iefc9CrgkSCvjpLLqV4R5y8FjP
        /cdqnKiOaBCsUAG8XuweqEtoQaJmYpfkqSpId8Y=
X-Google-Smtp-Source: AK7set8wK/uMIz2cun5XrxHIic3/RQKaVU4LpEGu/mhZlfgxgz/rTWrjOgtESqmTkwSRFaBRWCsiEasYMuu1wVdS7hE=
X-Received: by 2002:ac8:57c8:0:b0:3a9:7ff2:3b85 with SMTP id
 w8-20020ac857c8000000b003a97ff23b85mr283061qta.102.1675264601885; Wed, 01 Feb
 2023 07:16:41 -0800 (PST)
MIME-Version: 1.0
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com> <20230131215528.7a791a54@kernel.org>
In-Reply-To: <20230131215528.7a791a54@kernel.org>
From:   Chris Healy <cphealy@gmail.com>
Date:   Wed, 1 Feb 2023 07:16:30 -0800
Message-ID: <CAFXsbZqPx-YWY9CAavoyR9YyA=uZTCYny8+4_zDqxwi3Gy0GXA@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Kevin Hao <haokexin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 9:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 Jan 2023 22:03:21 +0100 Heiner Kallweit wrote:
> > Jerome provided the information that also the GXL internal PHY doesn't
> > support MMD register access and EEE. MMD reads return 0xffff, what
> > results in e.g. completely wrong ethtool --show-eee output.
> > Therefore use the MMD dummy stubs.
> >
> > Note: The Fixes tag references the commit that added the MMD dummy
> > access stubs.
> >
> > Fixes: 5df7af85ecd8 ("net: phy: Add general dummy stubs for MMD register access")
>
> Please make sure to CC the author. Adding Kevin Hao <haokexin@gmail.com>

Good point, I'll do that next time.
