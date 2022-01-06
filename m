Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C336486948
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbiAFR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242232AbiAFR7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:59:16 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90101C061245;
        Thu,  6 Jan 2022 09:59:15 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w16so12398542edc.11;
        Thu, 06 Jan 2022 09:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xu3gtBGXL1jf6kCxzSaeWpzGpdunrBP5nIzH9T+JX7A=;
        b=QABhckc492awaaxXuAXNmNQu84OS4dvWLO16RonMxReG9y4I9SOXpp9WNwch9Fu6UD
         wmm3heRhU9A29LYtvo6Fn7aozoN+g991Jwt9RQ7xtA5tdoKYkbngv0/w3NI4ZVAmWjEe
         Qf4FaRnSLHeLAijAeS/SW44fLuapJUWTDIGRkFNvJpXa8kJPYZ+hODXTxDEvfvkWa3zg
         T6+U8IghcX2VT+PrROhDOtA9Sc5BZrHyPtOxSVkXOiPtglKvyuZManVi2xWmII9unYNd
         sqJ+ex5Wb8WXfDFg6t08ESunjSYjwNDofHokjRvAm3QXtSggwSxZDRb7FLTRRDuEpWPv
         48Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xu3gtBGXL1jf6kCxzSaeWpzGpdunrBP5nIzH9T+JX7A=;
        b=V5MWU30OhNB7Epl0PXpk98tB9JE17mQCpHrrwl6U7KSQQ8ZkA3X2zSHEdu7jFAwV6E
         axKGcgcFZimeC6sl6E0nlsJcYykwzK8GuQ7HLPVg5BPQFu8HjA1QJ4G2iSUCUHOY6/0h
         JB4eEmR1vjfsMUkobX6EbpyrQkr903BtDCdVskkgs5roFD9rLlciFtTrwfbsv/UBisrw
         cehX9FsOXGZntjrgZmRMm9lua0H1WAbG1TehKQmo3N9CGxiQBILEnmp4ObhIGmQ+ZSgk
         b8bC2DcDs/LRASQLI5tyzpDkzSJxlxM2gROn99L9x2bshrT7RVDs+CX7ahV6PpVFrcl2
         PyzA==
X-Gm-Message-State: AOAM533BhJ8y7qI86syCGmfFVbA9Ms97BYonjU6DAngL5HBFqDLtXlFw
        i923WQzGlF8/PP44OsHnPsq7BDmUJZUiTBJiuSbZ7hP1hiE=
X-Google-Smtp-Source: ABdhPJzBNWHoXSccLNv4/kXTZMpIBFu2W7xWcOFWFZ0eKIGCw7v4B7Ac94VkJf5xLM106JYy95MA0G2b5DDQhfv1iuU=
X-Received: by 2002:a05:6402:d51:: with SMTP id ec17mr7460258edb.296.1641491954182;
 Thu, 06 Jan 2022 09:59:14 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com> <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
 <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com> <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
 <57716712-024d-af7e-394b-72ca9cb008d0@gmail.com>
In-Reply-To: <57716712-024d-af7e-394b-72ca9cb008d0@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 6 Jan 2022 19:58:37 +0200
Message-ID: <CAHp75VdXk87x7oDT1O5Q32ZsL4n0HYt-fijeiXw8n9fgypkOgg@mail.gmail.com>
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

On Thu, Jan 6, 2022 at 7:40 PM Dmitry Osipenko <digetx@gmail.com> wrote:
> 05.01.2022 16:22, Hector Martin =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On 05/01/2022 07.09, Dmitry Osipenko wrote:

...

> > I'm confused; the array size is constant. What would index contain and
> > why would would brcm_free_alt_fw_paths use it? Just as an iterator
> > variable instead of using a local variable? Or do you mean count?
>
> Yes, use index for the count of active entries in the alt_paths[].
>
> for (i =3D 0; i < alt_paths.index; i++)
>         kfree(alt_paths.path[i]);
>
> alt_paths.index =3D 0;
>
> or
>
> while (alt_paths.index)
>         kfree(alt_paths.path[--alt_paths.index]);

Usual pattern is

  while (x--)
    kfree(x);

easier to read, extend (if needed).

--=20
With Best Regards,
Andy Shevchenko
