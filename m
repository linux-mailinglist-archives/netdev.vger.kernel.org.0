Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B43306234
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbhA0RiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343981AbhA0RiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:38:05 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5ABC0613D6;
        Wed, 27 Jan 2021 09:37:25 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ke15so3792920ejc.12;
        Wed, 27 Jan 2021 09:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JeKSrl5MX8Qcwc3ikgn/d9vbKfAHw5aV8D7Q/o5y8Ew=;
        b=V9F8t7hDx1yLfMfrlUMIKwofNk8IyaE+kOjLKHLezNDRNJcn7SkljILcs7NygsfvBc
         P/aSjN2OlgC3RlZGVMsh6g5jP1BItZ5dY2F66vDxEGkNu3kn8+krl4rs9fljeB+Dd6Mz
         RPWvUgHaKNnXDeYUTPiS0MhfNql+aR2M/3wg9NEFjj3Vam0NTI82ILNNo9rrspuvvIZF
         90Px5nP91uBGaWqZBVsLPY2pLR49yGR0cB0OpBGDIZKgOHWZ3wBKsd5E3JWi47dIkJsl
         46zrr8fyS9xJcx1Dpxl2F7We8/Tsq1jGI5c50fM/umevwiRkB/lohV3fhUzWhHVF/ccJ
         mixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JeKSrl5MX8Qcwc3ikgn/d9vbKfAHw5aV8D7Q/o5y8Ew=;
        b=e3ufo/Uuh7Bc1jGUrw35vYTZvkg3hb1Xnz7dnFJDzUBvWOB4foJUtCFpffAk/is668
         OY39k7yz/7h7bdOn0UgtcB3ReCSfjkFQH4UaaxmK4T+7fpg+b1gJQ4cUsB6beiN6HhvV
         Ty83sZKiRfMNIIcR+MnsgROkKBpIlH8gdElV7l16RcqpfxZRkCB6ZdYZUaCCnBv3mZHB
         l5K3y8iySyU10QBQV5Q5Zwim8fC87EH6tUQeS4oOg4n9p4vm0Nc9ORrZfa7G+2wo8VYf
         ALvvNdkNl4Com711+s/vsFREishRZwv8D1rcceFSPEiVGKCs+EkL0v82IfpZMuFFc8Jo
         mHYg==
X-Gm-Message-State: AOAM530+6LCUYDHzq9T4H+lROHzLFdPJPxwEcYXktSry1miWVZ9EjHQZ
        yEPlFbZXULeA9ujcu+TutRDSnikPbzFF/hjUmZaF1eG2
X-Google-Smtp-Source: ABdhPJz2Nnok34eJejkXVVjtUV67nbqAVdUbhKuD0JWcAt7OcGyzLqPPOTEJGPCIY7JFxbHf+YlT6DQ0naQ4op1ma44=
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr7427842eja.265.1611769043938;
 Wed, 27 Jan 2021 09:37:23 -0800 (PST)
MIME-Version: 1.0
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com> <1611747815-1934-11-git-send-email-stefanc@marvell.com>
In-Reply-To: <1611747815-1934-11-git-send-email-stefanc@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 12:36:46 -0500
Message-ID: <CAF=yD-Lohx+1DRijK5=qgTj0uctBkS-Loh20zrMF7_Ditb2+pQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 10/19] net: mvpp2: add FCA RXQ non occupied
 descriptor threshold
To:     stefanc@marvell.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>, nadavh@marvell.com,
        ymarkman@marvell.com, LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        rmk+kernel@armlinux.org.uk, Antoine Tenart <atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 7:26 AM <stefanc@marvell.com> wrote:
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> RXQ non occupied descriptor threshold would be used by
> Flow Control Firmware feature to move to the XOFF mode.
> RXQ non occupied threshold would change interrupt cause
> that polled by CM3 Firmware.
> Actual non occupied interrupt masked and won't trigger interrupt.

Does this mean that this change enables a feature, but it is unused
due to a masked interrupt?

>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 46 +++++++++++++++++---
>  2 files changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 73f087c..9d8993f 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -295,6 +295,8 @@
>  #define     MVPP2_PON_CAUSE_TXP_OCCUP_DESC_ALL_MASK    0x3fc00000
>  #define     MVPP2_PON_CAUSE_MISC_SUM_MASK              BIT(31)
>  #define MVPP2_ISR_MISC_CAUSE_REG               0x55b0
> +#define MVPP2_ISR_RX_ERR_CAUSE_REG(port)       (0x5520 + 4 * (port))
> +#define            MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK  0x00ff

The indentation in this file is inconsistent. Here even between the
two newly introduced lines.

>  /* Buffer Manager registers */
>  #define MVPP2_BM_POOL_BASE_REG(pool)           (0x6000 + ((pool) * 4))
> @@ -764,6 +766,7 @@
>  #define MSS_SRAM_SIZE          0x800
>  #define FC_QUANTA              0xFFFF
>  #define FC_CLK_DIVIDER         100
> +#define MSS_THRESHOLD_STOP     768
>
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 8f40293a..a4933c4 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1144,14 +1144,19 @@ static inline void mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)
>  static void mvpp2_interrupts_mask(void *arg)
>  {
>         struct mvpp2_port *port = arg;
> +       int cpu = smp_processor_id();
> +       u32 thread;
>
>         /* If the thread isn't used, don't do anything */
> -       if (smp_processor_id() > port->priv->nthreads)
> +       if (cpu >= port->priv->nthreads)
>                 return;

Here and below, the change from greater than to greater than is really
a (standalone) fix?

> -       mvpp2_thread_write(port->priv,
> -                          mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
> +       thread = mvpp2_cpu_to_thread(port->priv, cpu);
> +
> +       mvpp2_thread_write(port->priv, thread,
>                            MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
> +       mvpp2_thread_write(port->priv, thread,
> +                          MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
>  }
>
>  /* Unmask the current thread's Rx/Tx interrupts.
> @@ -1161,20 +1166,25 @@ static void mvpp2_interrupts_mask(void *arg)
>  static void mvpp2_interrupts_unmask(void *arg)
>  {
>         struct mvpp2_port *port = arg;
> -       u32 val;
> +       int cpu = smp_processor_id();
> +       u32 val, thread;
>
>         /* If the thread isn't used, don't do anything */
> -       if (smp_processor_id() > port->priv->nthreads)
> +       if (cpu >= port->priv->nthreads)
>                 return;
>
> +       thread = mvpp2_cpu_to_thread(port->priv, cpu);
> +
>         val = MVPP2_CAUSE_MISC_SUM_MASK |
>                 MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(port->priv->hw_version);
>         if (port->has_tx_irqs)
>                 val |= MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_MASK;
>
> -       mvpp2_thread_write(port->priv,
> -                          mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
> +       mvpp2_thread_write(port->priv, thread,
>                            MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
> +       mvpp2_thread_write(port->priv, thread,
> +                          MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
> +                          MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
>  }
>
>  static void
> @@ -1199,6 +1209,9 @@ static void mvpp2_interrupts_unmask(void *arg)
>
>                 mvpp2_thread_write(port->priv, v->sw_thread_id,
>                                    MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
> +               mvpp2_thread_write(port->priv, v->sw_thread_id,
> +                                  MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
> +                                  MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
>         }
>  }
>
> @@ -2404,6 +2417,22 @@ static void mvpp2_txp_max_tx_size_set(struct mvpp2_port *port)
>         }
>  }
>
> +/* Routine set the number of non-occupied descriptors threshold that change
> + * interrupt error cause polled by FW Flow Control
> + */

nit: no need for "Routine". Also, does "change .. cause" mean "that
triggers an interrupt"?
