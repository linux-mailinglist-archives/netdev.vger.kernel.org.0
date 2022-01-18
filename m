Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB3491E51
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347142AbiARDxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344622AbiARDxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:53:23 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F70DC02B8DD
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 18:56:02 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q25so6085994pfl.8
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 18:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5wkWuCo7o/fPY7P+WJGLRyokZs5vvTs3KFkeaKk9wJM=;
        b=aWvwCkm4Poi/Ton3i657px+Adzebr4dzbb+YguwyFySm0qbso7K09p7ran0fUcYecZ
         6aqsg1MO5fDk4WPXPxC5yWJTbxu5EvVnIGjzdlYa3meqU9Zx1FZ0cX6qki3wQ2wjTkAo
         LqsGkZYeX69Tik2rSZ3V9SRg14sOOmtBWUT5wEdKPfh7r074Hc9zEXATCH4+wOl7EWt1
         XaodsICEmCb/TAaLTQJUugQED50CX8zuyQHRfoLkJlgyFUwPYL2TK1OUfxgrIRM89L1s
         8D02pTiVEkeY8cssMMeuriDHYeMCNWgIB/kHO9v12LtKHMLPS4Xb612s2fJKcY0wzFFw
         /jWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5wkWuCo7o/fPY7P+WJGLRyokZs5vvTs3KFkeaKk9wJM=;
        b=2CgI+umF3yvrX9gDv0yJ8xGTQmUJFPVuOaAz9lGb6DACyl8xvPXOo/vC3fiL5upPpZ
         4QnyKnjNAJgcfFev98pom08YxnSWMIk9BBdbO6kmuUp7EEGTBgHGRA8a7TSS+HtDDiWb
         H56Aj37RV0fLJCBjHUlAzOHS/hMMKxF+StipUMmnPpnadAwCTUlEVbXW8ra7vU6XWjr6
         sTiBrzqonqWASh+ktuTnYKjCFohOkc9SaCdoM/P7cWjZPh8hmNB0fRVU9FR8AEPiJKT5
         vaupw5g7q2iTSA0K46VmdnVeTPAQe640YCwyhFMJ0pe/vj1rk8w66WvXKYz0TCz7FcIc
         dKsA==
X-Gm-Message-State: AOAM5307/SA0AhX5+02Y0jP6BfaOEXK/rAlemOlfR/fz1UrndIJb28Jh
        FXZ4h3czeeLbudzGyZ10eXZVZXDVrAZttWExwr3NL54HQLmeZQ==
X-Google-Smtp-Source: ABdhPJxzPngMC3a6wnuLKxQAXJ6EU5jA6ZBUsI+ZaqPMjX8S+ETs7CQfxQ97iqnWEMt1S0h+Gl6VlUWpsoU0n8dQzpc=
X-Received: by 2002:a05:6a00:1404:b0:4c2:7c7c:f3d9 with SMTP id
 l4-20020a056a00140400b004c27c7cf3d9mr18774159pfu.77.1642474561973; Mon, 17
 Jan 2022 18:56:01 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-6-luizluca@gmail.com>
 <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com>
In-Reply-To: <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 17 Jan 2022 23:55:50 -0300
Message-ID: <CAJq09z4U5qmBuPUqBnGpT+qcG-vmtFwNMg5Uau3q3F53W-0YDA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in ds->ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> > The ds->ops->phy_read will only be used if the ds->slave_mii_bus
> > was not initialized. Calling realtek_smi_setup_mdio will create a
> > ds->slave_mii_bus, making ds->ops->phy_read dormant.
> >
> > Using ds->ops->phy_read will allow switches connected through non-SMI
> > interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
> > same code.
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Humm assigning dsa_switch_ops::phy_read will force DSA into tearing down
> the MDIO bus in dsa_switch_teardown() instead of letting your driver do
> it and since realtek-smi-core.c uses devm_mdiobus_unregister(), it is
> not clear to me what is going to happen but it sounds like a double free
> might happen?

Thanks, Florian. You should be correct. It might call
mdiobus_unregister() and mdiobus_free() twice, once inside the dsa
code and another one by the devm (if I understood how devm functions
work).

The issue is that the dsa switch is assuming that if slave_mii is
allocated and ds->ops->phy_read is defined, it has allocated the
slave_mii by itself and it should clean up the slave_mii during
teardown.
That assumption came from commit
5135e96a3dd2f4555ae6981c3155a62bcf3227f6 "So I can only guess that no
driver that implements ds->ops->phy_read also allocates and registers
ds->slave_mii_bus itself.". If that is true, the condition during
dsa_switch_setup() is not correct.

During dsa_switch_setup(), if it does not fail, I know that
ds->slave_mii_bus will be allocated, either by ds->ops->setup() or by
itself.

dsa_switch_setup() {
        ....
        ds->ops->setup()
        ....
        if (!ds->slave_mii_bus && ds->ops->phy_read) {
              ...allocate and register ds->slave_mii_bus...
        }
}

During the teardown, ds->slave_mii_bus will always be true (if not
cleaning from an error before it was allocated). So, the test is
really about having ds->ops->phy_read.

dsa_switch_teardown() {
        ...
        if (ds->slave_mii_bus && ds->ops->phy_read) {
             ...unregister and free ds->slave_mii_bus...
        }
        ...
        ds->ops->teardown();
        ...
}

As ds->ops->teardown() is called after slave_mii_bus is gone, there is
no opportunity for ds->ops to clean the mii_slave_bus it might have
allocated.
It does not make sense for me to have those two "if" conditions
working together. It should be either:

dsa_switch_setup() {
        ....
        ds->ops->setup()
        ....
        if (ds->ops->phy_read) {
              if (ds->slave_mii_bus)
                    error("ds->ops->phy_read is set, I should be the
one allocating ds->slave_mii_bus!")
              ...allocate and register ds->slave_mii_bus...
        }
}

if "no driver that implements ds->ops->phy_read also allocates and
registers ds->slave_mii_bus itself" or:

dsa_switch_teardown() {
        ...
        if (ds->slave_mii_bus && "slave_mii_bus was allocated by myself") {
             ...unregister and free ds->slave_mii_bus...
        }
        ds->ops->teardown();
        ...
}

if ds->ops->phy_read value should not tell if ds->slave_mii_bus should
be cleaned by the DSA switch.

I would selfishly hope the correct one was the second option because
it would make my code much cleaner. If not, that's a complex issue to
solve without lots of duplications: realtek-smi drivers should not
have ds->ops->phy_read defined while realtek-mdio requires it. I'll
need to duplicate dsa_switch_ops for each subdriver only to unset
phy_read and also duplicate realtek_variant for each interface only to
reference that different dsa_switch_ops.

BTW, the realtek-smi calls
of_node_put(priv->slave_mii_bus->dev.of_node) during shutdown while
other dsa drivers do not seem to care. Wouldn't devm controls be
enough for cleaning that mii_bus?
Even if not, wouldn't the ds->ops->teardown be the correct place for
that cleanup and not realtek_smi_remove()?

> It seems more prudent to me to leave existing code.

As I mentioned, It would require a good amount of duplications. But
I'll do what needs to be done.

Regards,

Luiz
