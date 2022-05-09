Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBCA51F5F1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbiEIHm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiEIHmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:42:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EB819C396
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:38:24 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 202so11324847pgc.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gkGi7REa/fobYkRo+r4uhLnY4nc5WFp41XKntwoF3rI=;
        b=DjuK8Qq19xtDBXiCzLp9jsgIsTUqi8gtlqIpDoiEqlw2nXiRg1h/V67IjfbLBzBl0p
         oQbj6E21vYO1qVpQ/WEo7OKMFn5nxuMxgnLzWymmphTxLXsMlObxmVpEUCmqPAaJqSNK
         cEwstvv3S9/FHsdxqAa6zoitdQOkKcSXKAeMypBSbd7MHQZtdSdt27IYZH0E3oTEt0Q2
         WNyDerP0BJhmNH/QbY1rUrILQth3ZohJfZtIB9PwTTtLEW+iA5Y0VIZbG+2I538mOQOE
         1P7heeavOZ0t3ZR/eyNHIiQ/zOz1XOhsyn6aHM9DvNeIVbJL0AobEv5L7zr7hhnzNv2f
         Gp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gkGi7REa/fobYkRo+r4uhLnY4nc5WFp41XKntwoF3rI=;
        b=glB/l6axccvtB8lqfn3Cok5Z86mpQRovXRovf6tiVOuQRDUUU4G1bEIjsNTNujeerG
         03LSs6734qTp3gOk2XaqsgGciHpRCO+GiWSeCaIl3R4Y0K2pQlyFVBc0KJH7bfwLLrXv
         BehNCTG/6uc5x0DI1WYimXKdDP1Y6E/xLgdDa1kwoFaXmDms+bmqMWZPwPxGnYaqsiMd
         YoikWvXNxLTTzZqIIvmXXEC6HUGvloSOSoo1uQKHoLjMN9y86ui+QXt5axWQDqGLmyyc
         BobZBIybXsbkWk93GgZaVNiz9ZCDw8vTgFD9Gyl03MZk1OT9bzwl9xDSNtVyzbtS75hq
         Zq8w==
X-Gm-Message-State: AOAM532HqUecmnHaWTVK83Sf6tglPBFCrrefuknWU4SIciO2iCE9m7bo
        7iQXbfWbve2vaThfnZHATwnIQx1EeG3l5cgl9Sw=
X-Google-Smtp-Source: ABdhPJwN35RhoKeyunnq2E3WRGzPjyHzfIS+1Ckd6VgLxRtV24A1IqMpfaUr5pr3LxcxMDWSwme09QzBVwesotkmuyc=
X-Received: by 2002:a63:4f48:0:b0:3c6:b640:6046 with SMTP id
 p8-20020a634f48000000b003c6b6406046mr3839752pgl.118.1652081897173; Mon, 09
 May 2022 00:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220508224848.2384723-1-hauke@hauke-m.de> <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
In-Reply-To: <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 9 May 2022 04:38:06 -0300
Message-ID: <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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

> > Hauke Mehrtens (4):
> >   net: dsa: realtek: rtl8365mb: Fix interface type mask
> >   net: dsa: realtek: rtl8365mb: Get chip option
> >   net: dsa: realtek: rtl8365mb: Add setting MTU
> >   net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support

I didn't get these two, although patchwork got them:

  net: dsa: realtek: rtl8365mb: Get chip option
  net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
