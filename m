Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB61673F
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 17:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfEGP5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 11:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfEGP5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 11:57:50 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECBE20C01;
        Tue,  7 May 2019 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557244669;
        bh=yYeUtQyXycJKGzzKbaR03Sgh1x8livGCDAEBIteSL1I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m21zi0uw6YcaiMutrzLXpu2AH8gOQclBvy0xOtN3MrLBng7lPp8C8QFVwZJUsGC5k
         opQvIYdSitiQLmo6xw5A/6HMFIboVYByWnoL6xlNjVBBpWd5sqUZDjnIk3s9cmXba3
         ydobS7X0pn8834+IwkOGzoqFiD0vX8icyqbJKcoE=
Received: by mail-qk1-f182.google.com with SMTP id a132so10367524qkb.13;
        Tue, 07 May 2019 08:57:49 -0700 (PDT)
X-Gm-Message-State: APjAAAXkZfhC38ZpGU7C3PcbXe4vqVU5uexG0dufJ1K8dh9EASxreL3r
        d3x+JmIjpUSiT8fnHS4KhZXv4+k8gCV+k63OQA==
X-Google-Smtp-Source: APXvYqwk+Jr303x3CaQ9QFpPib22XA30jtdBeT+DhVsEK0IVy2YDsaZ0ABIqg81EzByodZnq8CpRQJzVsrmS0QBUy9A=
X-Received: by 2002:a37:4b92:: with SMTP id y140mr25992725qka.79.1557244668293;
 Tue, 07 May 2019 08:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <1556893635-18549-1-git-send-email-ynezz@true.cz> <20190505.214727.1839442238121977055.davem@davemloft.net>
In-Reply-To: <20190505.214727.1839442238121977055.davem@davemloft.net>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 7 May 2019 10:57:36 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL66PdCv7bFwfD9p6VQCcXOesz3EjPcYB9FGosgjOS8yw@mail.gmail.com>
Message-ID: <CAL_JsqL66PdCv7bFwfD9p6VQCcXOesz3EjPcYB9FGosgjOS8yw@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] of_net: Add NVMEM support to of_get_mac_address
To:     David Miller <davem@davemloft.net>
Cc:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 5, 2019 at 11:47 PM David Miller <davem@davemloft.net> wrote:
>
> From: Petr =C5=A0tetiar <ynezz@true.cz>
> Date: Fri,  3 May 2019 16:27:05 +0200
>
> > this patch series is a continuation of my previous attempt[1], where I'=
ve
> > tried to wire MTD layer into of_get_mac_address, so it would be possibl=
e to
> > load MAC addresses from various NVMEMs as EEPROMs etc.
>  ...
>
> Series applied, thank you.

Patch 1 at least is still be discussed. What was implemented based on
my comments on v2 is really broken. Now the allocated buffer is
tracked by both devm and DT refcounting. Whoever's ref count drops
first will free the buffer.

Rob
