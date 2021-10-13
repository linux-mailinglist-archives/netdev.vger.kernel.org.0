Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA20A42BB7F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhJMJ3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbhJMJ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:29:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0A3C061570;
        Wed, 13 Oct 2021 02:27:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a25so7445359edx.8;
        Wed, 13 Oct 2021 02:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+/MfPZS60YJ0eap0AJdMs6gge+XO+BZUvon0pBTzNGA=;
        b=evc4kDT+QZNhO898nkNWsOvYd5uoHISP2WxjXfUrXPc/LAvzY9eu3qYsrzHLMiVRP3
         7ek8KrGpW83pP3+71f6NoTqJUNew57wgLSdZESolUuO3w3SjswV4oNuZrRCsx5d2Sz6Z
         U6Dil/exw/Z01VwoZLKDTI9+cXYT6HoMhvbPnOyg97B0PkHUENz49VLf5qJ3twBM3fy6
         bHXGjIYLA3Q6jVCBIp04R0UFvkX24frr6ijNGP3vuZmaos7c/PDqm98vd8l9QZ2VLZ00
         0EBJxe8ZaQK4AqNo/Rk1lDSww7yrEMjrcnUEwQvCtD2OBAhLhOYcZrSIMXdkiq7GrIG/
         lN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+/MfPZS60YJ0eap0AJdMs6gge+XO+BZUvon0pBTzNGA=;
        b=sB4NJpdNsDPkUy6mxgmKe4HtKEN2nu+cK//OpsRyWcLfqCQ31MaLagEbI4kFORFqWT
         DXbHANfm+km5qyLipWbKv5591O8apIQedw6yhqLc6B1Lu6kV3JmypGG4iKk2WO5NLkRa
         zJbI6VauabL7kp7wxsO8rh1LG//nT89gz2Z0A/Ir7ZciqzBTL295g8CrovWFVz0JNd4K
         KMhMg5Ydf7Xmdxs2sxIPMdWWfBLbKkwgNmHyJEe1KkptIjkS7UtgLwkWzDKnP6F1oiOm
         4z+NWC8E31Hcy0XwUwG6HCd8EhncS4c00qRbwmTVYNuK5UhVy/FLe+YQo9dJvL2k0Srj
         swAg==
X-Gm-Message-State: AOAM531TZwmZkz1ZBJo16E9AqcvamrBTbCU10ocMMZ9lBNlzUFX1/LQp
        +Azpq2TJkpSzwoXVZ2AYXYmrGbmWlW/LJhHRc6k=
X-Google-Smtp-Source: ABdhPJzL0SqFZyZBLTfBNcE8CpMsywyY4boERpEcXyUfc9yUq7Z2mLOKk/hnon0PQ/WXXVk02NgEbEHqrWvW2H64g2s=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr40092015ejc.69.1634117238956;
 Wed, 13 Oct 2021 02:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125935.2300113-1-u.kleine-koenig@pengutronix.de> <20211012233212.GA1806189@bhelgaas>
In-Reply-To: <20211012233212.GA1806189@bhelgaas>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 13 Oct 2021 12:26:42 +0300
Message-ID: <CAHp75Vd0uYEdfB0XaQuUV34V91qJdHR5ARku1hX_TCJLJHEjxQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        linux-pci <linux-pci@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jack Xu <jack.xu@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, netdev <netdev@vger.kernel.org>,
        oss-drivers@corigine.com, qat-linux@intel.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 2:33 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> On Mon, Oct 04, 2021 at 02:59:24PM +0200, Uwe Kleine-K=C3=B6nig wrote:

> I split some of the bigger patches apart so they only touched one
> driver or subsystem at a time.  I also updated to_pci_driver() so it
> returns NULL when given NULL, which makes some of the validations
> quite a bit simpler, especially in the PM code in pci-driver.c.

It's a bit unusual. Other to_*_dev() are not NULL-aware IIRC.

Below are some comments as well.

...

>  static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsign=
ed short device)
>  {
> +       struct pci_driver *drv =3D to_pci_driver(pdev->dev.driver);
>         const struct pci_device_id *id;
>
>         if (pdev->vendor =3D=3D vendor && pdev->device =3D=3D device)
>                 return true;

> +       for (id =3D drv ? drv->id_table : NULL; id && id->vendor; id++)
> +               if (id->vendor =3D=3D vendor && id->device =3D=3D device)

> +                       break;

return true;

>         return id && id->vendor;

return false;

>  }

...

> +                       afu_result =3D err_handler->error_detected(afu_de=
v,
> +                                                                state);

One line?

...

>         device_lock(&vf_dev->dev);
> -       if (vf_dev->dev.driver) {
> +       if (to_pci_driver(vf_dev->dev.driver)) {

Hmm...

...

> +               if (!pci_dev->state_saved && pci_dev->current_state !=3D =
PCI_D0

> +                   && pci_dev->current_state !=3D PCI_UNKNOWN) {

Can we keep && on the previous line?

> +                       pci_WARN_ONCE(pci_dev, pci_dev->current_state !=
=3D prev,
> +                                     "PCI PM: Device state not saved by =
%pS\n",
> +                                     drv->suspend);
>                 }

...

> +       return drv && drv->resume ?
> +                       drv->resume(pci_dev) : pci_pm_reenable_device(pci=
_dev);

One line?

...

> +       struct pci_driver *drv =3D to_pci_driver(dev->dev.driver);
>         const struct pci_error_handlers *err_handler =3D
> -                       dev->dev.driver ? to_pci_driver(dev->dev.driver)-=
>err_handler : NULL;
> +                       drv ? drv->err_handler : NULL;

Isn't dev->driver =3D=3D to_pci_driver(dev->dev.driver)?

...

> +       struct pci_driver *drv =3D to_pci_driver(dev->dev.driver);
>         const struct pci_error_handlers *err_handler =3D
> -                       dev->dev.driver ? to_pci_driver(dev->dev.driver)-=
>err_handler : NULL;
> +                       drv ? drv->err_handler : NULL;

Ditto.

...

>         device_lock(&dev->dev);
> +       pdrv =3D to_pci_driver(dev->dev.driver);
>         if (!pci_dev_set_io_state(dev, state) ||
> -               !dev->dev.driver ||
> -               !(pdrv =3D to_pci_driver(dev->dev.driver))->err_handler |=
|

> +               !pdrv ||
> +               !pdrv->err_handler ||

One line now?

>                 !pdrv->err_handler->error_detected) {

Or this and the previous line?

...

> +       pdrv =3D to_pci_driver(dev->dev.driver);
> +       if (!pdrv ||
> +               !pdrv->err_handler ||
>                 !pdrv->err_handler->mmio_enabled)
>                 goto out;

Ditto.

...

> +       pdrv =3D to_pci_driver(dev->dev.driver);
> +       if (!pdrv ||
> +               !pdrv->err_handler ||
>                 !pdrv->err_handler->slot_reset)
>                 goto out;

Ditto.

...

>         if (!pci_dev_set_io_state(dev, pci_channel_io_normal) ||
> -               !dev->dev.driver ||
> -               !(pdrv =3D to_pci_driver(dev->dev.driver))->err_handler |=
|
> +               !pdrv ||
> +               !pdrv->err_handler ||
>                 !pdrv->err_handler->resume)
>                 goto out;

Ditto.

> -       result =3D PCI_ERS_RESULT_NONE;
>
>         pcidev =3D pci_get_domain_bus_and_slot(domain, bus, devfn);
>         if (!pcidev || !pcidev->dev.driver) {
>                 dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n=
");
>                 pci_dev_put(pcidev);
> -               return result;
> +               return PCI_ERS_RESULT_NONE;
>         }
>         pdrv =3D to_pci_driver(pcidev->dev.driver);

What about splitting the conditional to two with clear error message
in each and use pci_err() in the second one?

...

>                 default:
>                         dev_err(&pdev->xdev->dev,
> -                               "bad request in aer recovery "
> -                               "operation!\n");
> +                               "bad request in AER recovery operation!\n=
");

Stray change? Or is it in a separate patch in your tree?

--=20
With Best Regards,
Andy Shevchenko
