Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1847630FC50
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhBDTMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbhBDTBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:37 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A56C061797
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:17 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id e11so3195699qtg.6
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RqZ8rygl55sOxLHGojRF+8G9b1ZOqwiFUfZbypZoZLg=;
        b=IalZioeoVLQEkhTqrRdqPEzoemActm15rC4bqLbYPlGpC8F26deSBrgO6Bs5ln1T3Q
         bIZVpzddh0sDKQ8jMQWYcN1auGBE+hrWGiMQn6c09W6oLpzNvotsKPeRzqdcdjKOW4v1
         pTt6wqVw1ahgpAko5xiX6lCxkBtAgVGZuTgnOfx3D8jVD3wyxcq6q0/INzNNg0XDasfE
         aOP8mYlr8gCSGUz8rJ3l1NlwGpG8+ydBe/2M+4qEF5IpYjqCF6ozSwO9v837MVkU2SXG
         OQn6z9LK72k1DR5LDyKKdq7V5XqhnR1I9CZwTsROTZa6MIwgEHf9iL54Ig/OUgPCdoNB
         rfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RqZ8rygl55sOxLHGojRF+8G9b1ZOqwiFUfZbypZoZLg=;
        b=sCHYLJJHcw/biK9EPGve9hwYgvcrBiZYNDEa0lTVwPrvDcBpNzR8JHGh5/HiE9E3e2
         POCuAgL/g1PcKRfhIkDaEUlzum5CKsFrVrQoIOVe5VbgK2rklDXglTNsNFfUAK/ZmVp1
         r9LiRyiAA4QyxXGni2DZOvWSKClHSUMQBmAe/Xkoogep9D/E1OE+8AJc2B/3ELyhLJRJ
         vwPjfvTcoLx//cmMhqNwkddX+s6A+EuL+4cGdREBkTAPbHpun53l8JngtikdvMzt3gsq
         yIQyQEd7+WatnxrOzCNDEx9KbEK0XrEtz9068Fa+G8Q4pN+KScuK/WswoZ4ndQrNevSd
         jbkQ==
X-Gm-Message-State: AOAM533CZTWebrJ6GNJtYOd/r3cskqpUzd+7uGzlD1fg6DtcUIFfmPR5
        UGamL6IDsPAHcpWQA7CZGrKZe+oEl6MKsbhL1zUx4A==
X-Google-Smtp-Source: ABdhPJwhUGNf3alu5buhHjjbQ5aCLec+FqzmdGl+Lsrdd5fCzmIt4cYq9bpmPu9TKLHEdv8ikstrpgVFiPwbnloSMso=
X-Received: by 2002:ac8:e0d:: with SMTP id a13mr1024600qti.16.1612465215632;
 Thu, 04 Feb 2021 11:00:15 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-9-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-9-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:04 +0100
Message-ID: <CAPv3WKeTOC8nNo0NfbrKaJb7L8kBwecYRdFsgH0m6Zo6bc0Q5Q@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 08/15] net: mvpp2: add FCA RXQ non occupied
 descriptor threshold
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

wt., 2 lut 2021 o 09:18 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> The firmware needs to monitor the RX Non-occupied descriptor
> bits for flow control to move to XOFF mode.
> These bits need to be unmasked to be functional, but they will
> not raise interrupts as we leave the RX exception summary
> bit in MVPP2_ISR_RX_TX_MASK_REG clear.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 44 ++++++++++++++++---=
-
>  2 files changed, 40 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index 73f087c..ca84995 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -295,6 +295,8 @@
>  #define     MVPP2_PON_CAUSE_TXP_OCCUP_DESC_ALL_MASK    0x3fc00000
>  #define     MVPP2_PON_CAUSE_MISC_SUM_MASK              BIT(31)
>  #define MVPP2_ISR_MISC_CAUSE_REG               0x55b0
> +#define MVPP2_ISR_RX_ERR_CAUSE_REG(port)       (0x5520 + 4 * (port))
> +#define     MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK 0x00ff
>
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
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 6e59d07..19a3f38 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1134,14 +1134,19 @@ static inline void mvpp2_qvec_interrupt_disable(s=
truct mvpp2_queue_vector *qvec)
>  static void mvpp2_interrupts_mask(void *arg)
>  {
>         struct mvpp2_port *port =3D arg;
> +       int cpu =3D smp_processor_id();
> +       u32 thread;
>
>         /* If the thread isn't used, don't do anything */
> -       if (smp_processor_id() > port->priv->nthreads)
> +       if (cpu >=3D port->priv->nthreads)

The condition is changed - correctly, but it is a separate fix, that
IMO should go through 'net' tree.

>                 return;
>
> -       mvpp2_thread_write(port->priv,
> -                          mvpp2_cpu_to_thread(port->priv, smp_processor_=
id()),
> +       thread =3D mvpp2_cpu_to_thread(port->priv, cpu);
> +
> +       mvpp2_thread_write(port->priv, thread,
>                            MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
> +       mvpp2_thread_write(port->priv, thread,
> +                          MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
>  }
>
>  /* Unmask the current thread's Rx/Tx interrupts.
> @@ -1151,20 +1156,25 @@ static void mvpp2_interrupts_mask(void *arg)
>  static void mvpp2_interrupts_unmask(void *arg)
>  {
>         struct mvpp2_port *port =3D arg;
> -       u32 val;
> +       int cpu =3D smp_processor_id();
> +       u32 val, thread;
>
>         /* If the thread isn't used, don't do anything */
> -       if (smp_processor_id() > port->priv->nthreads)
> +       if (cpu >=3D port->priv->nthreads)

Ditto.

Thanks,
Marcin


>                 return;
>
> +       thread =3D mvpp2_cpu_to_thread(port->priv, cpu);
> +
>         val =3D MVPP2_CAUSE_MISC_SUM_MASK |
>                 MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(port->priv->hw_versio=
n);
>         if (port->has_tx_irqs)
>                 val |=3D MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_MASK;
>
> -       mvpp2_thread_write(port->priv,
> -                          mvpp2_cpu_to_thread(port->priv, smp_processor_=
id()),
> +       mvpp2_thread_write(port->priv, thread,
>                            MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
> +       mvpp2_thread_write(port->priv, thread,
> +                          MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
> +                          MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
>  }
>
>  static void
> @@ -1189,6 +1199,9 @@ static void mvpp2_interrupts_unmask(void *arg)
>
>                 mvpp2_thread_write(port->priv, v->sw_thread_id,
>                                    MVPP2_ISR_RX_TX_MASK_REG(port->id), va=
l);
> +               mvpp2_thread_write(port->priv, v->sw_thread_id,
> +                                  MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
> +                                  MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
>         }
>  }
>
> @@ -2394,6 +2407,20 @@ static void mvpp2_txp_max_tx_size_set(struct mvpp2=
_port *port)
>         }
>  }
>
> +/* Set the number of non-occupied descriptors threshold */
> +static void mvpp2_set_rxq_free_tresh(struct mvpp2_port *port,
> +                                    struct mvpp2_rx_queue *rxq)
> +{
> +       u32 val;
> +
> +       mvpp2_write(port->priv, MVPP2_RXQ_NUM_REG, rxq->id);
> +
> +       val =3D mvpp2_read(port->priv, MVPP2_RXQ_THRESH_REG);
> +       val &=3D ~MVPP2_RXQ_NON_OCCUPIED_MASK;
> +       val |=3D MSS_THRESHOLD_STOP << MVPP2_RXQ_NON_OCCUPIED_OFFSET;
> +       mvpp2_write(port->priv, MVPP2_RXQ_THRESH_REG, val);
> +}
> +
>  /* Set the number of packets that will be received before Rx interrupt
>   * will be generated by HW.
>   */
> @@ -2649,6 +2676,9 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
>         mvpp2_rx_pkts_coal_set(port, rxq);
>         mvpp2_rx_time_coal_set(port, rxq);
>
> +       /* Set the number of non occupied descriptors threshold */
> +       mvpp2_set_rxq_free_tresh(port, rxq);
> +
>         /* Add number of descriptors ready for receiving packets */
>         mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
>
> --
> 1.9.1
>
