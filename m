Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1210D6B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfEATrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:47:36 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36301 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEATrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 15:47:35 -0400
Received: by mail-ot1-f67.google.com with SMTP id b18so43679otq.3;
        Wed, 01 May 2019 12:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5YzhllM92etO0io7FIdy5LneCJOMFGyjoYKOXsJVIvU=;
        b=TI9BHWera1jK36OUXBn9K7OM6HE2WDhcg+e4wFseSeK0xLQ2vC4Xhf4P8yzg6NN/xm
         o5kZruLa22gOlfKIc1SsUqFrf2ml0EgXXLz/oUWb+uqC5M1u9Gazxaz0h6cmwqTM08mY
         COjzTerSiKDTFzj4woTqP+v4NrSchx5ZKNOMfJxY1MvE7IBrjv3rsMIwquee64PQubW3
         Iq+1+nSd5mzvd5anBVMfymsCyM9AWzYMtEwUR/1WgK9+wuEPkFfnFXH2cqhvZTUEVPG5
         w5dk84rDGgO3OM2kUPvAjG7HwyrufD3UpGQCC+N6dzKKuNrWonP4e/gIhrBiMm5Zgd6p
         bfZA==
X-Gm-Message-State: APjAAAWeGAJcwj9UZBcn/GL/fMlL3kvLJe8olOoNeU/ipukMl3dfUGS2
        klDP6+EXXJuCiASlGqQrfH1w+7SJnOY=
X-Google-Smtp-Source: APXvYqyjAAtqISB0UYlacWbZ6j7hDIsGjG/AGAPspfzy1GhukVHpVp7cphvFnhY4OuJmhfwDSwxLGg==
X-Received: by 2002:a9d:3b06:: with SMTP id z6mr2141880otb.140.1556740054614;
        Wed, 01 May 2019 12:47:34 -0700 (PDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id g62sm785067otg.25.2019.05.01.12.47.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:47:33 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id n187so14622003oih.6;
        Wed, 01 May 2019 12:47:33 -0700 (PDT)
X-Received: by 2002:aca:d984:: with SMTP id q126mr15911oig.108.1556740053075;
 Wed, 01 May 2019 12:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com> <20190427071031.6563-3-laurentiu.tudor@nxp.com>
In-Reply-To: <20190427071031.6563-3-laurentiu.tudor@nxp.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Wed, 1 May 2019 14:47:21 -0500
X-Gmail-Original-Message-ID: <CADRPPNSUBYGKp9cQRdOhsdgr+z85Dtz1TKav9yoAmV6gqPOVUg@mail.gmail.com>
Message-ID: <CADRPPNSUBYGKp9cQRdOhsdgr+z85Dtz1TKav9yoAmV6gqPOVUg@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] soc/fsl/qbman_portals: add APIs to retrieve the
 probing status
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Netdev <netdev@vger.kernel.org>, madalin.bucur@nxp.com,
        Roy Pledge <roy.pledge@nxp.com>, camelia.groza@nxp.com,
        lkml <linux-kernel@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Miller <davem@davemloft.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 27, 2019 at 2:14 AM <laurentiu.tudor@nxp.com> wrote:
>
> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>
> Add a couple of new APIs to check the probing status of the required
> cpu bound qman and bman portals:
>  'int bman_portals_probed()' and 'int qman_portals_probed()'.
> They return the following values.
>  *  1 if qman/bman portals were all probed correctly
>  *  0 if qman/bman portals were not yet probed
>  * -1 if probing of qman/bman portals failed
> Portals are considered successful probed if no error occurred during
> the probing of any of the portals and if enough portals were probed
> to have one available for each cpu.
> The error handling paths were slightly rearranged in order to fit this
> new functionality without being too intrusive.
> Drivers that use qman/bman portal driver services are required to use
> these APIs before calling any functions exported by these drivers or
> otherwise they will crash the kernel.
> First user will be the dpaa1 ethernet driver, coming in a subsequent
> patch.
>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Applied for next.  Thanks.

Leo

> ---
>  drivers/soc/fsl/qbman/bman_portal.c | 20 ++++++++++++++++----
>  drivers/soc/fsl/qbman/qman_portal.c | 21 +++++++++++++++++----
>  include/soc/fsl/bman.h              |  8 ++++++++
>  include/soc/fsl/qman.h              |  9 +++++++++
>  4 files changed, 50 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/soc/fsl/qbman/bman_portal.c b/drivers/soc/fsl/qbman/bman_portal.c
> index 2c95cf59f3e7..cf4f10d6f590 100644
> --- a/drivers/soc/fsl/qbman/bman_portal.c
> +++ b/drivers/soc/fsl/qbman/bman_portal.c
> @@ -32,6 +32,7 @@
>
>  static struct bman_portal *affine_bportals[NR_CPUS];
>  static struct cpumask portal_cpus;
> +static int __bman_portals_probed;
>  /* protect bman global registers and global data shared among portals */
>  static DEFINE_SPINLOCK(bman_lock);
>
> @@ -87,6 +88,12 @@ static int bman_online_cpu(unsigned int cpu)
>         return 0;
>  }
>
> +int bman_portals_probed(void)
> +{
> +       return __bman_portals_probed;
> +}
> +EXPORT_SYMBOL_GPL(bman_portals_probed);
> +
>  static int bman_portal_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> @@ -104,8 +111,10 @@ static int bman_portal_probe(struct platform_device *pdev)
>         }
>
>         pcfg = devm_kmalloc(dev, sizeof(*pcfg), GFP_KERNEL);
> -       if (!pcfg)
> +       if (!pcfg) {
> +               __bman_portals_probed = -1;
>                 return -ENOMEM;
> +       }
>
>         pcfg->dev = dev;
>
> @@ -113,14 +122,14 @@ static int bman_portal_probe(struct platform_device *pdev)
>                                              DPAA_PORTAL_CE);
>         if (!addr_phys[0]) {
>                 dev_err(dev, "Can't get %pOF property 'reg::CE'\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>
>         addr_phys[1] = platform_get_resource(pdev, IORESOURCE_MEM,
>                                              DPAA_PORTAL_CI);
>         if (!addr_phys[1]) {
>                 dev_err(dev, "Can't get %pOF property 'reg::CI'\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>
>         pcfg->cpu = -1;
> @@ -128,7 +137,7 @@ static int bman_portal_probe(struct platform_device *pdev)
>         irq = platform_get_irq(pdev, 0);
>         if (irq <= 0) {
>                 dev_err(dev, "Can't get %pOF IRQ'\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>         pcfg->irq = irq;
>
> @@ -150,6 +159,7 @@ static int bman_portal_probe(struct platform_device *pdev)
>         spin_lock(&bman_lock);
>         cpu = cpumask_next_zero(-1, &portal_cpus);
>         if (cpu >= nr_cpu_ids) {
> +               __bman_portals_probed = 1;
>                 /* unassigned portal, skip init */
>                 spin_unlock(&bman_lock);
>                 return 0;
> @@ -175,6 +185,8 @@ static int bman_portal_probe(struct platform_device *pdev)
>  err_ioremap2:
>         memunmap(pcfg->addr_virt_ce);
>  err_ioremap1:
> +        __bman_portals_probed = -1;
> +
>         return -ENXIO;
>  }
>
> diff --git a/drivers/soc/fsl/qbman/qman_portal.c b/drivers/soc/fsl/qbman/qman_portal.c
> index 661c9b234d32..e2186b681d87 100644
> --- a/drivers/soc/fsl/qbman/qman_portal.c
> +++ b/drivers/soc/fsl/qbman/qman_portal.c
> @@ -38,6 +38,7 @@ EXPORT_SYMBOL(qman_dma_portal);
>  #define CONFIG_FSL_DPA_PIRQ_FAST  1
>
>  static struct cpumask portal_cpus;
> +static int __qman_portals_probed;
>  /* protect qman global registers and global data shared among portals */
>  static DEFINE_SPINLOCK(qman_lock);
>
> @@ -220,6 +221,12 @@ static int qman_online_cpu(unsigned int cpu)
>         return 0;
>  }
>
> +int qman_portals_probed(void)
> +{
> +       return __qman_portals_probed;
> +}
> +EXPORT_SYMBOL_GPL(qman_portals_probed);
> +
>  static int qman_portal_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> @@ -238,8 +245,10 @@ static int qman_portal_probe(struct platform_device *pdev)
>         }
>
>         pcfg = devm_kmalloc(dev, sizeof(*pcfg), GFP_KERNEL);
> -       if (!pcfg)
> +       if (!pcfg) {
> +               __qman_portals_probed = -1;
>                 return -ENOMEM;
> +       }
>
>         pcfg->dev = dev;
>
> @@ -247,19 +256,20 @@ static int qman_portal_probe(struct platform_device *pdev)
>                                              DPAA_PORTAL_CE);
>         if (!addr_phys[0]) {
>                 dev_err(dev, "Can't get %pOF property 'reg::CE'\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>
>         addr_phys[1] = platform_get_resource(pdev, IORESOURCE_MEM,
>                                              DPAA_PORTAL_CI);
>         if (!addr_phys[1]) {
>                 dev_err(dev, "Can't get %pOF property 'reg::CI'\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>
>         err = of_property_read_u32(node, "cell-index", &val);
>         if (err) {
>                 dev_err(dev, "Can't get %pOF property 'cell-index'\n", node);
> +               __qman_portals_probed = -1;
>                 return err;
>         }
>         pcfg->channel = val;
> @@ -267,7 +277,7 @@ static int qman_portal_probe(struct platform_device *pdev)
>         irq = platform_get_irq(pdev, 0);
>         if (irq <= 0) {
>                 dev_err(dev, "Can't get %pOF IRQ\n", node);
> -               return -ENXIO;
> +               goto err_ioremap1;
>         }
>         pcfg->irq = irq;
>
> @@ -291,6 +301,7 @@ static int qman_portal_probe(struct platform_device *pdev)
>         spin_lock(&qman_lock);
>         cpu = cpumask_next_zero(-1, &portal_cpus);
>         if (cpu >= nr_cpu_ids) {
> +               __qman_portals_probed = 1;
>                 /* unassigned portal, skip init */
>                 spin_unlock(&qman_lock);
>                 return 0;
> @@ -321,6 +332,8 @@ static int qman_portal_probe(struct platform_device *pdev)
>  err_ioremap2:
>         memunmap(pcfg->addr_virt_ce);
>  err_ioremap1:
> +       __qman_portals_probed = -1;
> +
>         return -ENXIO;
>  }
>
> diff --git a/include/soc/fsl/bman.h b/include/soc/fsl/bman.h
> index 5b99cb2ea5ef..173e4049d963 100644
> --- a/include/soc/fsl/bman.h
> +++ b/include/soc/fsl/bman.h
> @@ -133,5 +133,13 @@ int bman_acquire(struct bman_pool *pool, struct bm_buffer *bufs, u8 num);
>   * failed to probe or 0 if the bman driver did not probed yet.
>   */
>  int bman_is_probed(void);
> +/**
> + * bman_portals_probed - Check if all cpu bound bman portals are probed
> + *
> + * Returns 1 if all the required cpu bound bman portals successfully probed,
> + * -1 if probe errors appeared or 0 if the bman portals did not yet finished
> + * probing.
> + */
> +int bman_portals_probed(void);
>
>  #endif /* __FSL_BMAN_H */
> diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
> index 5cc7af06c1ba..aa31c05a103a 100644
> --- a/include/soc/fsl/qman.h
> +++ b/include/soc/fsl/qman.h
> @@ -1194,6 +1194,15 @@ int qman_release_cgrid(u32 id);
>   */
>  int qman_is_probed(void);
>
> +/**
> + * qman_portals_probed - Check if all cpu bound qman portals are probed
> + *
> + * Returns 1 if all the required cpu bound qman portals successfully probed,
> + * -1 if probe errors appeared or 0 if the qman portals did not yet finished
> + * probing.
> + */
> +int qman_portals_probed(void);
> +
>  /**
>   * qman_dqrr_get_ithresh - Get coalesce interrupt threshold
>   * @portal: portal to get the value for
> --
> 2.17.1
>
