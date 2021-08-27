Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339AA3FA17A
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 00:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhH0W2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 18:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhH0W2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 18:28:06 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505BC0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:27:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id i28so13978334ljm.7
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j7gpQi41GfWLDXk4SQxK9/VZniTBJC2H4vXHd3mpxDI=;
        b=WFxEVwSr8C6nLqlA8hjmllPCkqrXNfl3PX28AgXhRIR5Z8JQ3SLzbRDIp3GPKPz7VF
         iB6DvFxHiF0mFSeA6FBVui9GCutIhRPL27sc4o8psNzDFpvmKXqbBX9myqbSgjRjtZ9+
         KAFDpwncXr1u/EuAHo49LikyGbVTg7IBvArPu9NXb39otOMgzIdHb0NfBn1+/6Bs6eFR
         +RudzMivSJZHYzsbokC2OAH8fMQvM0dhcGszjR4gTz9gX0K6boz5TMKG9GB7e310xv3F
         pIMDrZSDXcmgzNyuVHYcAPOhuwfXU4nPaizyxsvgXXd3/O3799neJXr8GtokkzysFv0H
         bw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j7gpQi41GfWLDXk4SQxK9/VZniTBJC2H4vXHd3mpxDI=;
        b=VX6iRFKKhvdLyi0n2grto9BywupWU6d/+dXf0WwRZQIbLicgaNgFiTIRmLmveae2ZP
         yqK9xV+toeCSv2Z++da0p7BWtJypwaW/riqRMapnsAh2YbaY/dSL9cuymRB37i/Iryll
         hXOarbHj+fpAMLvzDVrgGhgwDu4SpsLbyBa87uo8y4qfHN9Dg9exvB+QhyikOpQsA6T2
         Pl3I08vJyVKk1hCxK4Fs7tcR96+qBpHgoAollw4AykKX9W096WSDyFwJs3tkon7dHKxP
         ts/7VhavxJHeiLSqf1YwYydeMsdxp99iSD35NfD/56Erk1uArXHeQCxyuskeiaJHFcfo
         WAWA==
X-Gm-Message-State: AOAM533TxTcBTZswSZVt0/K1SvykJ8woRcMqDpI49SA4d46KuVqcZcpA
        dpjUmVVQEXaYOx5vdDIHVKngR3VQC+EnsfazGg/WSA==
X-Google-Smtp-Source: ABdhPJzIQZQRIagSRKqyBrJ/0H7R9Wa+WarQ5IW/cVSBxNQOcWMQ2Ne+O9eNE6w8uOrVyxiok8aJlKsRW9oefCnC4Es=
X-Received: by 2002:a2e:7d11:: with SMTP id y17mr9565604ljc.368.1630103235393;
 Fri, 27 Aug 2021 15:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210822193145.1312668-1-alvin@pqrs.dk> <20210822193145.1312668-6-alvin@pqrs.dk>
In-Reply-To: <20210822193145.1312668-6-alvin@pqrs.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 28 Aug 2021 00:27:04 +0200
Message-ID: <CACRpkdaUM_M5GAt6MruYBKTSTsYbN6sEYY=7Oz-fQzgzq+81ug@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 5/5] net: phy: realtek: add support for
 RTL8365MB-VC internal PHYs
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 9:32 PM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:

> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> The RTL8365MB-VC ethernet switch controller has 4 internal PHYs for its
> user-facing ports. All that is needed is to let the PHY driver core
> pick up the IRQ made available by the switch driver.
>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
