Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299CE3A83AE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFOPLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhFOPL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:11:29 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0D8C06175F
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:09:24 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c18so27187569qkc.11
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nB65CDqdsHbyItu4RdozG+XSpv/r8syDO6kFDqu5AyM=;
        b=MFgu9632Ue99EFPLgrgePPoMbwNBeQsMDiDQxfB/ioBKFh8qXKcGup9QvrQAWEnuyY
         cOHvFqxQNq6bA4oEh3WzVpYF89pz38zk6JkYdDyU3lvBLWe5+5RBiaizzNqg7Fas5EfF
         KcQ71ELJNySY+wleSpQWcq0rjZbrbWXYYmpcz1WNivQ8NOlqNhWNlUuPjuE3RQaGwa5z
         vZ+BidfipwEVOQLVdV3cLYhVkRWaU1nVD7Q30kQg7P4oZEHi7V15LfTeIux0zt7Nffku
         YycjSsKDZsV0zA93Ltaxr645Vm3iME1RZ6YYtZbU7wmPfcvmI4hW/II+5H0003a/r5xA
         j0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nB65CDqdsHbyItu4RdozG+XSpv/r8syDO6kFDqu5AyM=;
        b=ku6UAL2jjBcCoeiWlFuHi9WiFx4lmrQp0GOReitiz7Xo1Y0RivQxknD3whcLkIjBu9
         GRdJ5Y3ChbfCL6kLLm5Q5yt60oQkPQwBZzcyoEJMOy1DfjMrY10jR1B1Nl+3gwp8G1X8
         ttvjZ3sHMB1oZ4SmHYFGSfTX8IWtF2EWxxibZhZItlJGJnphotY8v11ySD1WkWmNOBrl
         f0V7cSDFzZLiwnQk3yY78czGKwlq7WsUv/t6BtwdYHsrsqa6ZsFQbF6Mn9jqdjI7HVe7
         9bXPf8xAYc1IgOJUn+H5y4+g+5EcXxr6EAC0Jvy2d8vq4Ef34uK2WVhYzsMkGQHebHE5
         pKmA==
X-Gm-Message-State: AOAM5308MxArCxfpmRpqFIGaDO6fje/vwUQemtYiFuimAGtTJIHQKZMk
        FeFFUN7L/VHvy9lK9uUrnly7QjCWgzhjRXojn48FnA==
X-Google-Smtp-Source: ABdhPJyiAb1yM3ODv0mAtMra0XHn5poqaIbBdYItxwHe3oBJs88y/zPNBwnUIMjZBeEp2Bw05pihKwnEP1cXGswXViw=
X-Received: by 2002:a05:620a:a83:: with SMTP id v3mr92673qkg.360.1623769764016;
 Tue, 15 Jun 2021 08:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-2-mw@semihalf.com>
 <YMZdvt4xlev3JQhF@lunn.ch> <CAHp75VdMsYJMCwH2o14e7nJBTj6A38dkcZJ+0WQfnW=keOyoAg@mail.gmail.com>
In-Reply-To: <CAHp75VdMsYJMCwH2o14e7nJBTj6A38dkcZJ+0WQfnW=keOyoAg@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 15 Jun 2021 17:09:12 +0200
Message-ID: <CAPv3WKeubNaxpv442d57bEqA1ZtPcTXOswcsuCsregW_2Akdww@mail.gmail.com>
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "gjb@semihalf.com" <gjb@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        "Samer.El-Haj-Mahmoud@arm.com" <Samer.El-Haj-Mahmoud@arm.com>,
        "jon@solid-run.com" <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

niedz., 13 cze 2021 o 22:08 Andy Shevchenko
<andy.shevchenko@gmail.com> napisa=C5=82(a):
>
>
>
> On Sunday, June 13, 2021, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> > @@ -336,7 +338,7 @@ static int orion_mdio_probe(struct platform_device=
 *pdev)
>> >                       dev_warn(&pdev->dev,
>> >                                "unsupported number of clocks, limiting=
 to the first "
>> >                                __stringify(ARRAY_SIZE(dev->clk)) "\n")=
;
>> > -     } else {
>> > +     } else if (!has_acpi_companion(&pdev->dev)) {
>> >               dev->clk[0] =3D clk_get(&pdev->dev, NULL);
>> >               if (PTR_ERR(dev->clk[0]) =3D=3D -EPROBE_DEFER) {
>> >                       ret =3D -EPROBE_DEFER;
>>
>> Is this needed? As you said, there are no clocks when ACPI is used, So
>> doesn't clk_get() return -ENODEV? Since this is not EPRODE_DEFER, it
>> keeps going. The clk_prepare_enable() won't be called.
>

Indeed, I'll double check if it works and will keep the if {} else {} intac=
t.

>
>
> The better approach is to switch to devm_get_clk_optional() as I have don=
e in several drivers, IIRC recently in mvpp2
>
>
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commi=
t/?id=3Dcf3399b731d36bc780803ff63e4d480a1efa33ac
>

Yes, this would be a nice improvement, however the
devm_get_clk_optional requires clock name (type char *) - mvmdio uses
raw indexes, so this helper unfortunately seems to be not applicable.

>>
>> > -     ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
>> > +     if (pdev->dev.of_node)
>> > +             ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
>> > +     else if (is_acpi_node(pdev->dev.fwnode))
>> > +             ret =3D acpi_mdiobus_register(bus, pdev->dev.fwnode);
>> > +     else
>> > +             ret =3D -EINVAL;
>> >       if (ret < 0) {
>> >               dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", r=
et);
>> >               goto out_mdio;
>> > @@ -383,6 +390,9 @@ static int orion_mdio_probe(struct platform_device=
 *pdev)
>> >       if (dev->err_interrupt > 0)
>> >               writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
>> >
>> > +     if (has_acpi_companion(&pdev->dev))
>> > +             return ret;
>> > +
>>
>> I think this can also be removed for the same reason.
>>
>> We should try to avoid adding has_acpi_companion() and
>> !pdev->dev.of_node whenever we can. It makes the driver code too much
>> of a maze.

Clock routines silently accept NULL pointers, so it will be safe to
drop this addition in v2.

Best regards,
Marcin
