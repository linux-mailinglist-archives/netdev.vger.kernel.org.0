Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490456D52BD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjDCUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjDCUmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:42:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B78E1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:42:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so122390914ede.8
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 13:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680554520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCRvFoFqM45NTDEZm3j6oGCxNdqYdLwX1AAKzWK7X6A=;
        b=CQGHWDDXwzAPbNwv0V7hwLcAI8ir7pOTdF8U+W/WO1G8AO7VJBHEPyhpnXZuMPS32K
         K+CQJB8nyVia74Nh1GNzSAk0JQcwKmRqVIzuWJELrnVcNCAAqQx3Zsd1uIIb4TRpZFV7
         sQTTFytL0ZAVf810sbGSkhguLbJoBa8AN5N5k9HKepLfdvIsY9u8/W7duxut7CU9xTUS
         XtBeLn/dFcURYZcE3xTghdUwtn4hmUk1TICIFYQD1lvDEpvQYUJHPoQfmcPdaCScqBe4
         VV4ZE5ZzK/NR2cSZSqeg4xJgZBG/3gxj+bx/pw+x2AxUIq/fNScwqJV6UX86dnPYSyMm
         wPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680554520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCRvFoFqM45NTDEZm3j6oGCxNdqYdLwX1AAKzWK7X6A=;
        b=E8S1D4UgkgK3vC+LK2mB93nxV6kRGTdhCjbv3saB/1naBIhqbp3ZVnA8r418/FTope
         2QwShbCMsHSihgcdUQ39Hnk/0H5zqJ9TkfXnpFNbSElJ9UlyTDVBqxme0F9H4vZPQs+b
         vAU1K/2s+njdf6X7hAMZG2y0ss2gT4TxZJ6ghZEA1GVXfrWEgAbGMGLdCPxk9T9CwSJP
         2HDsN92EBO51YvyAkCj1JDc9korYl1/LZ076v1R2Mpaz2prgqrKYXw8E65YRqelRKya9
         TMxN5R0RwmG8IC+P6v9r3Y+jczjmyppeq+T/SKamj4UN0+H0g50RqkrwbJE3trc7N67R
         4uqg==
X-Gm-Message-State: AAQBX9d3mRCEGoAbC5w4Lgvw1mm1XW5UbDIFyrG+amqrokACJx4DCAtH
        ONUGkLTB/4XMZBkGkmWNsVGrUfl+5u59E5959tA=
X-Google-Smtp-Source: AKy350bLr9dE1NqZwo6m8yGAz/fsHnuoSBpgL2oDKYO6GD12JaoDFrn0EFxyCgwD1uLd07XPaIkW+KK1bp13KdhZOP0=
X-Received: by 2002:a17:906:3701:b0:920:da8c:f7b0 with SMTP id
 d1-20020a170906370100b00920da8cf7b0mr3132ejc.6.1680554519873; Mon, 03 Apr
 2023 13:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
In-Reply-To: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 3 Apr 2023 22:41:49 +0200
Message-ID: <CAFBinCDJcJA=unTQ=DqkKiRGJ441BrnER7+MUK1sr08X2wVT6g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable support
 for G12A internal PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
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

On Mon, Apr 3, 2023 at 9:35=E2=80=AFPM Heiner Kallweit <hkallweit1@gmail.co=
m> wrote:
>
> Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
> recently added tunable support in the smsc driver.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
