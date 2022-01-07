Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60548751C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 10:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346622AbiAGJzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 04:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiAGJzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 04:55:47 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3D0C061245;
        Fri,  7 Jan 2022 01:55:47 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w16so19963928edc.11;
        Fri, 07 Jan 2022 01:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ooscPa9TOlryt6N2qyAjoWJG3ETCPGiTW3k86Hswt4s=;
        b=cks1zYcs1Xgs5V1uOxCxOR/Qf1h3YplePHLQt8PrFB2csgVE4qG07afD/fyjCaGyzl
         1WD7t+TBP31vbykr5v82qNPkwItSkh5TD7OkW8rLgrqDrBW4vt9LwZfppqrYmXtcZoGR
         pi8XMTOHozBg7Am5I9HMsNAGfqbe68i3T8Ytvx47Ueot+iht4SELH1YhT6VKYZulNBAY
         0sZRwJJi/r5pYjrZ0j6jeUPMzPzGpVWt/HPZYGiKVfWnI4BA3JCMo1lLG2XPwKpipJ+5
         Dtwto3PdHvkXi3e6bsp1hoM4ZSRZvkbqCcyuKtAgcEtQhD4zTpYOv6A/lHpE61aa+Kgx
         +RPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ooscPa9TOlryt6N2qyAjoWJG3ETCPGiTW3k86Hswt4s=;
        b=wcPi0OkYHbvoxpPydP1k/PEoB/2jK+h0BP9Gdi/o6Yj0bu0oPteK8az95QCAeqAYI1
         GXKI0r+br6J7AuKhHn95aenr5u6nTc+8bqEyg9USQNJnF6V0sugOwpHi58FBBBc1XLsP
         8cIPwwrrou9X1mSpDW2ibNeFUxqRbdWxASPQMLaUWQA+Yl5EbCXcnWIQu0KPcpB9rp3x
         +zmHeKVBr30tX5SHtl+GnvZRBVIq9c0sRzseO61PSRq0MV0XHgrunO9W+K0l8IPIUoLL
         +Y8CRuuBxYh7rsgNNUZs4xImNIBewsKu84ZL1ECEIgP2YjqbY0MGDG6OT4Mu8cTTCSBG
         uCSA==
X-Gm-Message-State: AOAM533YLE9H6ztzuDzj1wQee/7OskkMAnrPepGEi7XCc4HKI3WANd16
        XWbjJ6cZAkE697TwtZrTnPcpRsulYDLquCY/MLY=
X-Google-Smtp-Source: ABdhPJyB4zmiPw+DT/UfLBkSbY7FHKdVrFhtBv4VRloJ0St9kcs4gSdd/nWXaQV+hqqHdpMvkryUkooa/wovLjUVVQQ=
X-Received: by 2002:a17:907:6d8d:: with SMTP id sb13mr50102935ejc.132.1641549345664;
 Fri, 07 Jan 2022 01:55:45 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com> <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
 <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com> <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
 <57716712-024d-af7e-394b-72ca9cb008d0@gmail.com> <CAHp75VdXk87x7oDT1O5Q32ZsL4n0HYt-fijeiXw8n9fgypkOgg@mail.gmail.com>
 <d608ab82-cffe-0d66-99d2-d0abd214dd0d@gmail.com>
In-Reply-To: <d608ab82-cffe-0d66-99d2-d0abd214dd0d@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 7 Jan 2022 11:55:09 +0200
Message-ID: <CAHp75VfCJhMi35OnnE+hxp43PjpGYN1vteuMqX0J+1xZ+=az5w@mail.gmail.com>
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt paths
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 5:12 AM Dmitry Osipenko <digetx@gmail.com> wrote:
> 06.01.2022 20:58, Andy Shevchenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Thu, Jan 6, 2022 at 7:40 PM Dmitry Osipenko <digetx@gmail.com> wrote=
:
> >> 05.01.2022 16:22, Hector Martin =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

...

> >> while (alt_paths.index)
> >>         kfree(alt_paths.path[--alt_paths.index]);
> >
> > Usual pattern is
> >
> >   while (x--)
> >     kfree(x);

I have to elaborate that my point is to have postdecrement in the
while() instead of doing predecrement in its body. So the above
example will look

  while (alt_paths.index--)
    kfree(alt_paths.path[alt_paths.index]);

> > easier to read, extend (if needed).
>
> That is indeed a usual patter for the driver removal code paths. I
> didn't like to have index of struct brcmf_fw underflowed, but I see now
> that fwctx is dynamically created and freed during driver probe, so it
> should be fine to use that usual pattern here too.



--=20
With Best Regards,
Andy Shevchenko
