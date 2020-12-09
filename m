Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B12D4072
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgLIK67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgLIK66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:58:58 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE7C0613CF;
        Wed,  9 Dec 2020 02:58:18 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id lb18so669508pjb.5;
        Wed, 09 Dec 2020 02:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCjb4FnXIRrp7l79EOU0U/feX8csTUC9oavV8Czx9F4=;
        b=ErnJYh4cG8Ig4aTzcMUhimYD9LWUibSHKruLOgcjPO1uL4zBMxQ248ix3uKyPqLK3B
         XYdmhiuBn32lJZ0kxKfymnSrWDyxyLCSxuk58VdHpko9L9mDCSZ1pjeFOnh488Zp+YVw
         j8GgAibfytQPdMIptABjiCy6tga08rKYP6ZEGJYLwKT/qYZI9yieLNzAaw6o/6holQtp
         y2LI9tOpvTJdaVt7GcsvFd16vQgLgFNUlTIYdjtrD65vRvJoMU5AT1mLkzY3sy1XZbvG
         vGZpZs9Cr8mtKOgWgfsWqxqaC01eUpRc3NDHEcWHlXN1asRIN+/kpGqFJ0QyCcWx9Mv2
         RMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCjb4FnXIRrp7l79EOU0U/feX8csTUC9oavV8Czx9F4=;
        b=Gnf07zNt49H2ChjcbqsxAo9yWVex1K+KFLbjcVXBMb1RxzsZ2oEa3GrQ5FF6T35JkQ
         4V2vqxQ2K3NfTOmjLR1ZqrGcI7NfwdlP8xaMdo8xkC79RPSmIGIrWvCzr0h5+5QerJ2H
         YDG0Fs2+UuJAWITgL4ebr+Sc5PvAC7UiqCbUmzb5OSgyjIlxOsAiJteJLVjEhOw12f8u
         0yoD1ywUuGQI/ryIXWW9o2U3+rsqBXtBVAI5XpusVyd7jXp1QYSoHgjEMlXfx9x/0tnc
         jWj0F8ZzXp+ESTY7Yh6oo1/ZX5O5U9cBxYFmCyfyqW0eXrPiUPhUX+BLnOhNOIIhMOC1
         CQBg==
X-Gm-Message-State: AOAM532kyou3UO6RYfRSS5yggYRE987tk/VQwUJ8hyorbyZzp1ADxspc
        oA9yyku7xXra49P4iPGUZY16wN1VjME3MrG/1Ik=
X-Google-Smtp-Source: ABdhPJx8Osk6gOc8Z4ZAGTvbA66X3lSIWvUsn0Zy5q3lfIPt27f4S82ZJ0SgTTApYHWQYNs9Zf+gIo5v91HuO4EzVpQ=
X-Received: by 2002:a17:90b:a17:: with SMTP id gg23mr1713984pjb.129.1607511497899;
 Wed, 09 Dec 2020 02:58:17 -0800 (PST)
MIME-Version: 1.0
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
In-Reply-To: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 9 Dec 2020 12:59:06 +0200
Message-ID: <CAHp75VfBtRS=BA83Q4U9hJ14bO4wW_o44CKs=DBOtWnzqTXO3w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine <dmaengine@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 10:35 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> former one is declared as __must_check. However also some callers of

However also -> However

> pci_set_mwi() have a comment that it's an optional feature. I don't
> think there's much sense in this separation and the use of
> __must_check. Therefore remove pci_try_set_mwi() and remove the
> __must_check attribute from pci_set_mwi().


> I don't expect either function to be used in new code anyway.

You probably want to elaborate here that the feature is specific to
PCI and isn't present on PCIe.

Besides that one comment below.
After addressing, have my
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
for the files left in this message.

...

>  drivers/dma/dw/pci.c                          |  2 +-
>  drivers/dma/hsu/pci.c                         |  2 +-

>  drivers/mfd/intel-lpss-pci.c                  |  2 +-

>  drivers/pci/pci.c                             | 19 -------------------

>  drivers/tty/serial/8250/8250_lpss.c           |  2 +-
>  drivers/usb/chipidea/ci_hdrc_pci.c            |  2 +-

>  drivers/usb/gadget/udc/pch_udc.c              |  2 +-
>  include/linux/pci.h                           |  5 ++---

> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
> index 814b40f83..120362cc9 100644
> --- a/Documentation/PCI/pci.rst
> +++ b/Documentation/PCI/pci.rst
> @@ -226,10 +226,7 @@ If the PCI device can use the PCI Memory-Write-Invalidate transaction,
>  call pci_set_mwi().  This enables the PCI_COMMAND bit for Mem-Wr-Inval
>  and also ensures that the cache line size register is set correctly.
>  Check the return value of pci_set_mwi() as not all architectures
> -or chip-sets may support Memory-Write-Invalidate.  Alternatively,
> -if Mem-Wr-Inval would be nice to have but is not required, call
> -pci_try_set_mwi() to have the system do its best effort at enabling
> -Mem-Wr-Inval.
> +or chip-sets may support Memory-Write-Invalidate.

...

> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> index 1142aa6f8..1c20b7485 100644
> --- a/drivers/dma/dw/pci.c
> +++ b/drivers/dma/dw/pci.c
> @@ -30,7 +30,7 @@ static int dw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
>         }
>
>         pci_set_master(pdev);
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>         if (ret)
> diff --git a/drivers/dma/hsu/pci.c b/drivers/dma/hsu/pci.c
> index 07cc7320a..420dd3706 100644
> --- a/drivers/dma/hsu/pci.c
> +++ b/drivers/dma/hsu/pci.c
> @@ -73,7 +73,7 @@ static int hsu_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         }
>
>         pci_set_master(pdev);
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>         if (ret)

...

> diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> index 2d7c588ef..a0c3be750 100644
> --- a/drivers/mfd/intel-lpss-pci.c
> +++ b/drivers/mfd/intel-lpss-pci.c
> @@ -39,7 +39,7 @@ static int intel_lpss_pci_probe(struct pci_dev *pdev,
>
>         /* Probably it is enough to set this for iDMA capable devices only */
>         pci_set_master(pdev);
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         ret = intel_lpss_probe(&pdev->dev, info);
>         if (ret)

...

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 9a5500287..f0ab432d2 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4389,25 +4389,6 @@ int pcim_set_mwi(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pcim_set_mwi);
>
> -/**
> - * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
> - * @dev: the PCI device for which MWI is enabled
> - *
> - * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
> - * Callers are not required to check the return value.
> - *
> - * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
> - */
> -int pci_try_set_mwi(struct pci_dev *dev)
> -{

> -#ifdef PCI_DISABLE_MWI
> -       return 0;
> -#else
> -       return pci_set_mwi(dev);
> -#endif

This seems still valid case for PowerPC and SH.

> -}
> -EXPORT_SYMBOL(pci_try_set_mwi);

...

> diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
> index 4dee8a9e0..8acc1e5c9 100644
> --- a/drivers/tty/serial/8250/8250_lpss.c
> +++ b/drivers/tty/serial/8250/8250_lpss.c
> @@ -193,7 +193,7 @@ static void qrk_serial_setup_dma(struct lpss8250 *lpss, struct uart_port *port)
>         if (ret)
>                 return;
>
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         /* Special DMA address for UART */
>         dma->rx_dma_addr = 0xfffff000;
> diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
> index d63479e1a..d412fa910 100644
> --- a/drivers/usb/chipidea/ci_hdrc_pci.c
> +++ b/drivers/usb/chipidea/ci_hdrc_pci.c
> @@ -78,7 +78,7 @@ static int ci_hdrc_pci_probe(struct pci_dev *pdev,
>         }
>
>         pci_set_master(pdev);
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         /* register a nop PHY */
>         ci->phy = usb_phy_generic_register();

...

> diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
> index a3c1fc924..4a0484a0c 100644
> --- a/drivers/usb/gadget/udc/pch_udc.c
> +++ b/drivers/usb/gadget/udc/pch_udc.c
> @@ -3100,7 +3100,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
>         }
>
>         pci_set_master(pdev);
> -       pci_try_set_mwi(pdev);
> +       pci_set_mwi(pdev);
>
>         /* device struct setup */
>         spin_lock_init(&dev->lock);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index de75f6a4d..c590f616d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1191,9 +1191,8 @@ void pci_clear_master(struct pci_dev *dev);
>
>  int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
>  int pci_set_cacheline_size(struct pci_dev *dev);
> -int __must_check pci_set_mwi(struct pci_dev *dev);
> -int __must_check pcim_set_mwi(struct pci_dev *dev);
> -int pci_try_set_mwi(struct pci_dev *dev);
> +int pci_set_mwi(struct pci_dev *dev);
> +int pcim_set_mwi(struct pci_dev *dev);
>  void pci_clear_mwi(struct pci_dev *dev);
>  void pci_intx(struct pci_dev *dev, int enable);
>  bool pci_check_and_mask_intx(struct pci_dev *dev);


-- 
With Best Regards,
Andy Shevchenko
