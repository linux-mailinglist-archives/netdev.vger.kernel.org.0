Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3342C496
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhJMPO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 11:14:57 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DF6C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 08:12:53 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r19so13066079lfe.10
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 08:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KeBf3L7IIF8Rv/Bp70om/1tZpd3FOupbjhm8llgp0W8=;
        b=upCptVhN8O7PL7K/2Xmyntm8koWnqGyv185dyC0zDf2wLGIeqwnkvsk7yMCUfO0Rwm
         lM6c+2SZ9LJBJojVFJSPXgfhPn92tnIXEX6iePeZJ8ERM3AWA5QLV0FMSXxtYiKxUwbU
         c+r1OeF3bw05W6ouhHvp1ezmlmEwMIxH4b5ZtpadYQVs0QhBrdwHhb2KddOyC+VXP7gU
         gP78rYq5pG7XPc7dnfMNpD5c8Ln+O2E91/A/bsu9Hoj9PbrHElK2rCxQWncYnlzRGTgr
         BxKzio5Zmeo2SBAUBEwlyAqgvE5V7SA1GJ7HR2KHLuzdeuI9uRqVYtR7ABBfcL+B5XTt
         FCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KeBf3L7IIF8Rv/Bp70om/1tZpd3FOupbjhm8llgp0W8=;
        b=yz6Z9ZOGWwo96PetFY3yUVoUeJTfj+udg8W//iWxzFa6ziCeZU103ayesXYMHABIxG
         13JIR+pLJhFeiGUm7zAh+rMbZ4aBq9n1ngFcK9FNNYhhn0jQupQQ6UEsJxva6v4GhmSe
         0DDp4EVfYmMXmkTpiKf8CK8IhgvEDIHt0eNO4XLUSPLCjEopnm0tW86R+wwTvvG6Gm5J
         wH71ql2QsaeU3NLE8iG7a25nmdeYNkmi+Qp2RWaWmTr8V6jCfOP8zaFfx07oqawrJ7fX
         3MtiBD4/I54fLXy7VLXWfFKbwYyoMaPax37YhO7vT/IXN6Un9xiBRULNVJhIv0F9ft8u
         ddOA==
X-Gm-Message-State: AOAM532+PBDHfqICd1ZQHQkIsxjLazn5/KK/gJgOlOz5pbpsW3fEqdes
        OOoP0h1zCq9PQr5IUCfTay29bXVY4n3KGSyuN/mPNQ==
X-Google-Smtp-Source: ABdhPJxsi6yl4d+fJISK8+JZ/UaD4XqCzsHCSENtim47MqwOVR+AZEyZ64Jm3UrawMFcA93DGim4kE6c9FW1FJ1nhUM=
X-Received: by 2002:a05:6512:1303:: with SMTP id x3mr40718274lfu.291.1634137971739;
 Wed, 13 Oct 2021 08:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211012123557.3547280-1-alvin@pqrs.dk> <20211012123557.3547280-6-alvin@pqrs.dk>
In-Reply-To: <20211012123557.3547280-6-alvin@pqrs.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 13 Oct 2021 17:12:39 +0200
Message-ID: <CACRpkdYwTUopZ_6khRpkAPFg6qiRTOgyKe=URzVRrNagK2HZMw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
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
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 2:37 PM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:

> This patch adds a realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M switch controller. The driver has been developed based on a
> GPL-licensed OS-agnostic Realtek vendor driver known as rtl8367c found
> in the OpenWrt source tree.
(...)
> Co-developed-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Overall this driver looks very good :)

Some minor nits below:

> +static irqreturn_t rtl8365mb_irq(int irq, void *data)
> +{
(...)
> +       if (!line_changes)
> +               goto out_none;
> +
> +       while (line_changes) {
> +               int line =3D __ffs(line_changes);
> +               int child_irq;
> +
> +               line_changes &=3D ~BIT(line);
> +
> +               child_irq =3D irq_find_mapping(smi->irqdomain, line);
> +               handle_nested_irq(child_irq);
> +       }

What about just:

for_each_set_bit(offset, &line_changes, 32) {
  child_irq =3D irq_find_mapping(smi->irqdomain, line);
  handle_nested_irq(child_irq);
}

?

I don't know how many or which bits are valid IRQs, 16 maybe rather
than 32.

> +static struct irq_chip rtl8365mb_irq_chip =3D {
> +       .name =3D "rtl8365mb",
> +       /* The hardware doesn't support masking IRQs on a per-port basis =
*/
> +};

I would rathe make this a dynamically allocated struct inside
struct rtl8365mb, so the irqchip lives with the instance of the
chip. (Which is nice if there would happen to be two of these
chips in a system.)

> +static int _rtl8365mb_irq_enable(struct realtek_smi *smi, bool enable)

I'm personally a bit allergic to _rand_underscore_naming, as sometimes
that means "inner function" and sometimes it means "compiler intrinsic"
I would just name it rtl8365mb_irq_config_commit()

(no strong opinion)

> +       /* Configure chip interrupt signal polarity */
> +       irq_trig =3D irqd_get_trigger_type(irq_get_irq_data(irq));

Nice that you preserve this edge trigger config from the machine
description (DT)!

With this fixed or not (your preference)
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
