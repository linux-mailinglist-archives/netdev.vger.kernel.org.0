Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446514B1806
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiBJWQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:16:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiBJWQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:16:09 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6281139
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:16:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u16so7089393pfg.3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8dy6nukpUU3XoOh9L9NN/hm6UJ10Lf1Ruk7hRlDYf+k=;
        b=Z/eyeu/sPiZCONdL7aMClqMIAfBv7EtF6uK19o+F9P1lYEofWKcWM1HIUuXBolqAXA
         lQoAqbYPIPGPzw2gtI5JbXQhot6XKqY9GWmu2xajORyPqyBeGomyx4ahlgANOe7Pej5z
         NO+DS6SnOMnm+HStEwonml7QD47yNkaweCcm40I2aX6LU8Qknk7PxIIZm0WRmEI+unW2
         dLpQeRBbKnPxYrachxj92aQelq9u2J+mHMvqDipoxpLjTq05DzI4FHv0Mfg9XEesm2HZ
         Yl0KZ9WuxF7pBldcPAtFfv24IycEMz0B6seeiIuTlzWUgkAJyBXTxRUW2YgIiLjPyOiW
         lWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8dy6nukpUU3XoOh9L9NN/hm6UJ10Lf1Ruk7hRlDYf+k=;
        b=0PZE4OUO4hIPzO/glEUJxyAwLn0Erur4MDFO+GfQBnOrnHtOvoEu5SbmreSwMTn/rV
         reYDX01301Q8awwpjAW2qB/y5GeEMnhflNRD7zMxGDI71cdTqFagSxbD/IDYlPdRMXkG
         R196yqpDhSY/L0+Prh7sbq2rs0NuA4BwI5VEp3e09h2sIGOKgR8fv/A54s6m7Z8yWhVC
         pNnndxar/J08MCMAU6M2rR9JHqrY05yD5jI9DhmiOIzMEMwZgoNDZShbJMYehUbWsJiv
         zagIzdutLvJZbDV54S0StD+RgSVdVA49O2osAULOMkpS2Fe9gPM+5MTYWmcv+mmojm6O
         c4cg==
X-Gm-Message-State: AOAM530Cs7APFHB6BUOKFu12VcWdLCrHmVylcMfJ/7/45kPgtSLzylAh
        A7Za2rf6mZ0r7VgaTTc7L2TJQ69ube/xUExJmHQ+pR44eI9AbAGl
X-Google-Smtp-Source: ABdhPJy+urq33hwXKasKUtypLlGT+KV/ebevLsvt3h9WO8DAuOwRFnAFLX2PgRxuBfUnRbvqGLYJt3sHsrct2ycG63E=
X-Received: by 2002:a62:190b:: with SMTP id 11mr9488390pfz.77.1644531369212;
 Thu, 10 Feb 2022 14:16:09 -0800 (PST)
MIME-Version: 1.0
References: <20220209224538.9028-1-luizluca@gmail.com> <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
In-Reply-To: <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 10 Feb 2022 19:15:58 -0300
Message-ID: <CAJq09z7QJ9qXteGMFCjYOVanu7iAP6aNO3=5a8cjYMAe+7TQfQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with realtek-mdio
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
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

> This assumes a 1:1 mapping between the port number and its PHY address
> on the internal MDIO bus, is that always true?

Thanks Florian,

As far as I know, for supported models, yes. I'm not sure about models
rtl8363nb and rtl8364nb because they have only 2 user ports at 1 and
3.
Anyway, they are not supported yet.

> It seems to me like we are resisting as much as possible the creating of
> the MDIO bus using of_mdiobus_register() and that seems to be forcing
> you to jump through hoops to get your per-port PHY interrupts mapped.
>
> Maybe this needs to be re-considered and you should just create that
> internal MDIO bus without the help of the DSA framework and reap the
> benefits? We could also change the DSA framework's way of creating the
> MDIO bus so as to be OF-aware.

That looks like a nice idea.

I do not have any problem duplicating the mdio setup from realtek-smi
into realtek-mdio.
However, it is just 3 copies of the same code (and I believe there are
a couple more of them):

1) dsa_switch_setup()+dsa_slave_mii_bus_init()
2) realtek_smi_setup_mdio()
3) realtek_mdio_setup_mdio() (NEW)

And realtek_smi_setup_mdio only exists as a way to reference the
OF-node. And OF-node is only needed because it needs to associate the
interrupt-parent and interrupts with each phy.
I think the best solution would be a way that the
dsa_slave_mii_bus_init could look for a specific subnode. Something
like:

dsa_slave_mii_bus_init(struct dsa_switch *ds)
{
        struct device_node *dn;
...
        dn = of_get_child_by_name(ds->dn, "slave_mii_bus");
        if (dn) {
                ds->slave_mii_bus->dev.of_node = dn;
        }
...
}

It would remove the realtek_smi_setup_mdio().

If possible, I would like to define safe default values (like assuming
1:1 mapping between the port number and its PHY address) for this
driver when interrupt-controller is present but
slave_mii_bus node is missing.

Does it sound ok?

--
Luiz
