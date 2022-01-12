Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17648C6B3
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 16:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354415AbiALPEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 10:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348043AbiALPEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 10:04:35 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EDBC061757
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 07:04:35 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id j11so9198965lfg.3
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 07:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=swEbmnyLSeN7aiIoLnsPgDG3gh2KSMSrPSEJTJTzFbQ=;
        b=lvkw4cRKCOzBKAPvoz7fYi4Ww+7YlPfKoAgKVLsIgKF1EJ+8wEQe6UxECLKYwzDnLE
         B6oDSef20ebGk9u85lnz7rEBAUMWRtwpyuCT7L5tzcrfQOz8wh7TZ2HKYlneuRS6vvZL
         2mzMh6se/ObK3+x60YBQABVSeb3VrI4eHRc1v7BRB2NV0kOKjry5g7lgbvmVmJtVueJ9
         KnDoZbh+45MmI7u5fj7DHOebV2iwZmI1uYwa1RpTgz0hD3M/CnW+fBXsXOOTtlYGu/16
         A5HG6WxtCNk9V2MKJTFdEJHaI/4RRxI0j/0ly6jrKbitmexN4vjhY8socp2Bkpl/gWCl
         FZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=swEbmnyLSeN7aiIoLnsPgDG3gh2KSMSrPSEJTJTzFbQ=;
        b=VvbgujLi8GF551pc+/i+3pUC/zsV7v5V0106Qhx4kS1iJvfFes/G//SisPc3XvAi43
         AkpQKzIsZonStTYuHuuT6IXcsTg/Wcsy+UXXCgX9W8gGqsnOMj0EjYdGaEYawuhjYNSk
         ZFqCrlAyg45uk6nGQCwrTgP1HyBC3V3iQDxI7MHtqxZVnc703+KbxF5UySiuT2YDPXGH
         p/hTLe0t6MVkm1LFC6ju2687FPgwVLAMAcvYxGoeXaOBDzBLBJNjkL9b/OeshjnqiNKY
         9RBgzM3dV+vFJUPGhjQQsRxIMYkyLbD9/gs7KgwU34WpbstedSMz4qwOlRy+vvX3omTX
         8nXQ==
X-Gm-Message-State: AOAM531ypHbl7CH+irDgj/RFsQrjbRxNKCnPjMWf6SWvrntFnknZwqh7
        3Gxkeb2k+ciEl889yb8hAJSLIFCdTJ+BakQbmNz9Pg==
X-Google-Smtp-Source: ABdhPJxWuTxHLQXjEWO9OANtBu36BWztuVV7d1EJLRw+gXvuvHBCzsnZLCgUQS4k1kJ8fOzX1Y3szncGvdkFuOkuwPI=
X-Received: by 2002:a19:6748:: with SMTP id e8mr118080lfj.358.1641999873143;
 Wed, 12 Jan 2022 07:04:33 -0800 (PST)
MIME-Version: 1.0
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-9-Jerome.Pouiller@silabs.com> <20220112105859.u4j76o7cpsr4znmb@pali>
 <42104281.b1Mx7tgHyx@pc-42> <20220112114332.jadw527pe7r2j4vv@pali>
In-Reply-To: <20220112114332.jadw527pe7r2j4vv@pali>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 12 Jan 2022 16:03:56 +0100
Message-ID: <CAPDyKFoMj1r+bEh-MqOdTVzs0C=LCFPPbXj3jHwB4Yty=bA03Q@mail.gmail.com>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 at 12:43, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Wednesday 12 January 2022 12:18:58 J=C3=A9r=C3=B4me Pouiller wrote:
> > On Wednesday 12 January 2022 11:58:59 CET Pali Roh=C3=A1r wrote:
> > > On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF=
200) },
> > > > +     { },
> > > > +};
> > >
> > > Hello! Is this table still required?
> >
> > As far as I understand, if the driver does not provide an id_table, the
> > probe function won't be never called (see sdio_match_device()).
> >
> > Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_SILA=
BS
> > and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does not hu=
rt
> > to add an extra filter here.
>
> Now when this particular id is not required, I'm thinking if it is still
> required and it is a good idea to define these SDIO_VENDOR_ID_SILABS
> macros into kernel include files. As it would mean that other broken
> SDIO devices could define these bogus numbers too... And having them in
> common kernel includes files can cause issues... e.g. other developers
> could think that it is correct to use them as they are defined in common
> header files. But as these numbers are not reliable (other broken cards
> may have same ids as wf200) and their usage may cause issues in future.
>
> Ulf, any opinion?

The sdio_match_device() is what is being used to match the device to
its sdio_driver, which is being called from the sdio_bus_type's
->match() callback.

In regards to the DT compatible strings from a drivers'
.of_match_table, that is currently left to be matched by the sdio
driver's ->probe() function internally, by calling
of_driver_match_device().

In other words, I think what Jerome has suggested here seems
reasonable to me. Matching on "SDIO_ANY_ID" would work too, but I
think it's better with a poor filter like SDIO_VENDOR_ID_SILABS*,
rather than none.

An entirely different and new approach would be to extend
sdio_match_device() to call of_driver_match_device() too. However, in
that case we would also need to add a new corresponding ->probe()
callback for the sdio_driver, as the current one takes a const struct
sdio_device_id, which doesn't work when matching on DT compatibles.

>
> Btw, is there any project which maintains SDIO ids, like there is
> pci-ids.ucw.cz for PCI or www.linux-usb.org/usb-ids.html for USB?
>
> > > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > > > +
> > > > +struct sdio_driver wfx_sdio_driver =3D {
> > > > +     .name =3D "wfx-sdio",
> > > > +     .id_table =3D wfx_sdio_ids,
> > > > +     .probe =3D wfx_sdio_probe,
> > > > +     .remove =3D wfx_sdio_remove,
> > > > +     .drv =3D {
> > > > +             .owner =3D THIS_MODULE,
> > > > +             .of_match_table =3D wfx_sdio_of_match,
> > > > +     }
> > > > +};
> > > > --
> > > > 2.34.1
> > > >
> > >
> >
> >
> > --
> > J=C3=A9r=C3=B4me Pouiller

Kind regards
Uffe
