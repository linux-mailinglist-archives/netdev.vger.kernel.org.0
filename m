Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51270210366
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 07:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgGAFqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 01:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgGAFqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 01:46:52 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED1C061755;
        Tue, 30 Jun 2020 22:46:52 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so23711067iof.6;
        Tue, 30 Jun 2020 22:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BToyqAFI5f5u68K+7r1bZ4zx3KgdmDtvzPbHmq3uErs=;
        b=KfKiRC9tQw4BCTxYEe5fbyThBOQ4OzQNMWT9nS95Dd2MUMUd4FcSRV0ZZbF7URZAPa
         IOz4B4rhquUvz50tSYGyUG9ddbU4xGCIlCZqlBwuypVK+1NnxFvIovJiyZTRa6CgUXKo
         fJoPvVBIYPf5P9TD1QpSwrt6Qt1i5rjDug6EjxjrbRCVSM2s+DGwmuTNcl4brScjdo/F
         mZ5q5gXYBjX/eF67htk0QBbhmYk8+MsIRWkkkIj2+2T/atFwbjXy7PqT2WQ2FkdIHkQ2
         xb5Z5p+3Bc7HukIhmcAQC8j0OWveM2gFaU9B1N84o58YoXE4joD+STj8nAbMadqSyQcb
         s9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BToyqAFI5f5u68K+7r1bZ4zx3KgdmDtvzPbHmq3uErs=;
        b=qZfqr6OXP4XZOgY91LeXnZAiVkIJR/ozR0D7VwxbB0qyovWzit6e9tIZ5zVrctbSfh
         eeH6d00Cfr5ql1RaGuWT4Z08uNXuHT0fp4CgiOlH1LI6qNAMkCfgOHSD1b475HRCenoQ
         QRJY1v9C8I0n26X0+8hFaa5kQkivuHo0LGZpzpYKxb/dnPoY0L4lNNeWbFHWEI38rPk0
         nWfQZ8+qK8KjAndeAK/MMD7ae23F0572OWIg90nvcOfmlc7arhFpTQhDlHzTIzG93nGs
         rY0LJ3SUIRg8cShZ8OHuYeLq37XXKV/+Q/QDV+Wnk/hu/obmI79b4O6bmQasmZyjJDgk
         qLLA==
X-Gm-Message-State: AOAM530Ljn75y6AKV4Lk700Yi5D+Lf8jbFCwzTk0GIUmxhhymS3oQjWW
        g19MU3QJ/jMIHkacheSef7QE/PCLgn9wm2NA0eU=
X-Google-Smtp-Source: ABdhPJxZHh81Bt4nofbb5kaKkT4tjWBeDMkWORXVUhNQejFAOhSFnOLyfE8HJptfnuZMxxjozz4R2n+Jm1Crv+nZgnQ=
X-Received: by 2002:a5d:9c44:: with SMTP id 4mr629061iof.15.1593582411483;
 Tue, 30 Jun 2020 22:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200624174048.64754-1-vaibhavgupta40@gmail.com>
In-Reply-To: <20200624174048.64754-1-vaibhavgupta40@gmail.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 1 Jul 2020 11:15:13 +0530
Message-ID: <CAPBsFfCGfyFkeVvUC0QCnr9J4uvfubHoHjgPR9e+muPkYRj9vg@mail.gmail.com>
Subject: Re: [PATCH v1] orinoco: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 at 23:14, Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:
>
> With the support of generic PM callbacks, drivers no longer need to use
> legacy .suspend() and .resume() in which they had to maintain PCI states
> changes and device's power state themselves. The required operations are
> done by PCI core.
>
> PCI drivers are not expected to invoke PCI helper functions like
> pci_save/restore_state(), pci_enable/disable_device(),
> pci_set_power_state(), etc. Their tasks are completed by PCI core itself.
>
> Compile-tested only.
>
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  .../intersil/orinoco/orinoco_nortel.c         |  3 +-
>  .../wireless/intersil/orinoco/orinoco_pci.c   |  3 +-
>  .../wireless/intersil/orinoco/orinoco_pci.h   | 32 ++++++-------------
>  .../wireless/intersil/orinoco/orinoco_plx.c   |  3 +-
>  .../wireless/intersil/orinoco/orinoco_tmd.c   |  3 +-
>  5 files changed, 13 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c b/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
> index 048693b6c6c2..96a03d10a080 100644
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
> @@ -290,8 +290,7 @@ static struct pci_driver orinoco_nortel_driver = {
>         .id_table       = orinoco_nortel_id_table,
>         .probe          = orinoco_nortel_init_one,
>         .remove         = orinoco_nortel_remove_one,
> -       .suspend        = orinoco_pci_suspend,
> -       .resume         = orinoco_pci_resume,
> +       .driver.pm      = &orinoco_pci_pm_ops,
>  };
>
>  static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
> diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c b/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
> index 4938a2208a37..f3c86b07b1b9 100644
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
> @@ -230,8 +230,7 @@ static struct pci_driver orinoco_pci_driver = {
>         .id_table       = orinoco_pci_id_table,
>         .probe          = orinoco_pci_init_one,
>         .remove         = orinoco_pci_remove_one,
> -       .suspend        = orinoco_pci_suspend,
> -       .resume         = orinoco_pci_resume,
> +       .driver.pm      = &orinoco_pci_pm_ops,
>  };
>
>  static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
> diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_pci.h b/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
> index 43f5b9f5a0b0..d49d940864b4 100644
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
> @@ -18,51 +18,37 @@ struct orinoco_pci_card {
>         void __iomem *attr_io;
>  };
>
> -#ifdef CONFIG_PM
> -static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused orinoco_pci_suspend(struct device *dev_d)
>  {
> +       struct pci_dev *pdev = to_pci_dev(dev_d);
>         struct orinoco_private *priv = pci_get_drvdata(pdev);
>
>         orinoco_down(priv);
>         free_irq(pdev->irq, priv);
> -       pci_save_state(pdev);
> -       pci_disable_device(pdev);
> -       pci_set_power_state(pdev, PCI_D3hot);
>
>         return 0;
>  }
>
> -static int orinoco_pci_resume(struct pci_dev *pdev)
> +static int __maybe_unused orinoco_pci_resume(struct device *dev_d)
>  {
> +       struct pci_dev *pdev = to_pci_dev(dev_d);
>         struct orinoco_private *priv = pci_get_drvdata(pdev);
>         struct net_device *dev = priv->ndev;
>         int err;
>
> -       pci_set_power_state(pdev, PCI_D0);
> -       err = pci_enable_device(pdev);
> -       if (err) {
> -               printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
> -                      dev->name);
> -               return err;
> -       }
> -       pci_restore_state(pdev);
> -
>         err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
>                           dev->name, priv);
>         if (err) {
>                 printk(KERN_ERR "%s: cannot re-allocate IRQ on resume\n",
>                        dev->name);
> -               pci_disable_device(pdev);
>                 return -EBUSY;
>         }
>
> -       err = orinoco_up(priv);
> -
> -       return err;
> +       return orinoco_up(priv);
>  }
> -#else
> -#define orinoco_pci_suspend NULL
> -#define orinoco_pci_resume NULL
> -#endif
> +
> +static SIMPLE_DEV_PM_OPS(orinoco_pci_pm_ops,
> +                        orinoco_pci_suspend,
> +                        orinoco_pci_resume);
>
>  #endif /* _ORINOCO_PCI_H */
> diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c b/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
> index 221352027779..16dada94c774 100644
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
> @@ -336,8 +336,7 @@ static struct pci_driver orinoco_plx_driver = {
>         .id_table       = orinoco_plx_id_table,
>         .probe          = orinoco_plx_init_one,
>         .remove         = orinoco_plx_remove_one,
> -       .suspend        = orinoco_pci_suspend,
> -       .resume         = orinoco_pci_resume,
> +       .driver.pm      = &orinoco_pci_pm_ops,
>  };
>
>  static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
> diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c b/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
> index 20ce569b8a43..9a9d335611ac 100644
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
> @@ -213,8 +213,7 @@ static struct pci_driver orinoco_tmd_driver = {
>         .id_table       = orinoco_tmd_id_table,
>         .probe          = orinoco_tmd_init_one,
>         .remove         = orinoco_tmd_remove_one,
> -       .suspend        = orinoco_pci_suspend,
> -       .resume         = orinoco_pci_resume,
> +       .driver.pm      = &orinoco_pci_pm_ops,
>  };
>
>  static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
> --
> 2.27.0
>
