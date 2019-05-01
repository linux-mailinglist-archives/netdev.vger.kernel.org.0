Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C114810DC1
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfEAUIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:08:51 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45362 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfEAUIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 16:08:51 -0400
Received: by mail-oi1-f196.google.com with SMTP id t189so11642087oih.12;
        Wed, 01 May 2019 13:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MhhNnHbahaGD1ttZfVO4EhM/RU7xN3mKfU+xr7R87yk=;
        b=hI6oktlvKf+Ger9NgBwx/iOt3LV9jj4U7z8ssAlDj6mukQSYflV6FP97cKGCYXan0I
         vljAfduz5gxZpYH5ph4/bzXwHDAULBcZQgUzIrVYO95hQisNH89wYA5j+hQbdkzIxRpE
         3XYe6fu9go1xU31eTKikEMVwRC4nb5VDWuz/CqF+WKzSYjCEr3Q/98qa+bQfYEFkmixm
         7GmUj7JVLCUr/nnf5EGzgpG9K5A74bOMFd0aqEbGlRrhVTHkoN2w65/RRgLIYJhNYG0p
         M3HzpihJC/lBpbMhhOj8ZTYezsVDzKaBu54L/PtiMzin6uJ5cvQuP2G4Q2Vguic+70/6
         5AEQ==
X-Gm-Message-State: APjAAAXrpB4WtvQuAkDw2/kVAiViZWtfVkU74lKS9naZ7pYWuBJKByih
        6KJCqmgW4AWjpyepnFreMnrKIhZflos=
X-Google-Smtp-Source: APXvYqzR1olsNduTJsdwTlemApTsjad5n0OFjYzdfFwFXFzE3AdxuB0ZTj1CXtat3hGvPBo/9chNuA==
X-Received: by 2002:aca:d9c4:: with SMTP id q187mr55118oig.91.1556741330228;
        Wed, 01 May 2019 13:08:50 -0700 (PDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id y17sm1101701oix.54.2019.05.01.13.08.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 13:08:49 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id d62so8798518oib.13;
        Wed, 01 May 2019 13:08:49 -0700 (PDT)
X-Received: by 2002:aca:4e83:: with SMTP id c125mr62690oib.13.1556741329634;
 Wed, 01 May 2019 13:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com> <20190427071031.6563-2-laurentiu.tudor@nxp.com>
In-Reply-To: <20190427071031.6563-2-laurentiu.tudor@nxp.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Wed, 1 May 2019 15:08:38 -0500
X-Gmail-Original-Message-ID: <CADRPPNRGxEz_YXhzrJPCZrz_Xc-9Fh21tgbjERoOazMMQmiVbA@mail.gmail.com>
Message-ID: <CADRPPNRGxEz_YXhzrJPCZrz_Xc-9Fh21tgbjERoOazMMQmiVbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] soc/fsl/qman: fixup liodns only on ppc targets
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Netdev <netdev@vger.kernel.org>, madalin.bucur@nxp.com,
        Roy Pledge <roy.pledge@nxp.com>, camelia.groza@nxp.com,
        David Miller <davem@davemloft.net>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 27, 2019 at 2:14 AM <laurentiu.tudor@nxp.com> wrote:
>
> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>
> ARM SoCs use SMMU so the liodn fixup done in the qman driver is no
> longer making sense and it also breaks the ICID settings inherited
> from u-boot. Do the fixups only for PPC targets.
>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Applied for next.  Thanks.

Leo
> ---
>  drivers/soc/fsl/qbman/qman_ccsr.c | 2 +-
>  drivers/soc/fsl/qbman/qman_priv.h | 9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/soc/fsl/qbman/qman_ccsr.c b/drivers/soc/fsl/qbman/qman_ccsr.c
> index 109b38de3176..a6bb43007d03 100644
> --- a/drivers/soc/fsl/qbman/qman_ccsr.c
> +++ b/drivers/soc/fsl/qbman/qman_ccsr.c
> @@ -596,7 +596,7 @@ static int qman_init_ccsr(struct device *dev)
>  }
>
>  #define LIO_CFG_LIODN_MASK 0x0fff0000
> -void qman_liodn_fixup(u16 channel)
> +void __qman_liodn_fixup(u16 channel)
>  {
>         static int done;
>         static u32 liodn_offset;
> diff --git a/drivers/soc/fsl/qbman/qman_priv.h b/drivers/soc/fsl/qbman/qman_priv.h
> index 75a8f905f8f7..04515718cfd9 100644
> --- a/drivers/soc/fsl/qbman/qman_priv.h
> +++ b/drivers/soc/fsl/qbman/qman_priv.h
> @@ -193,7 +193,14 @@ extern struct gen_pool *qm_cgralloc; /* CGR ID allocator */
>  u32 qm_get_pools_sdqcr(void);
>
>  int qman_wq_alloc(void);
> -void qman_liodn_fixup(u16 channel);
> +#ifdef CONFIG_FSL_PAMU
> +#define qman_liodn_fixup __qman_liodn_fixup
> +#else
> +static inline void qman_liodn_fixup(u16 channel)
> +{
> +}
> +#endif
> +void __qman_liodn_fixup(u16 channel);
>  void qman_set_sdest(u16 channel, unsigned int cpu_idx);
>
>  struct qman_portal *qman_create_affine_portal(
> --
> 2.17.1
>
