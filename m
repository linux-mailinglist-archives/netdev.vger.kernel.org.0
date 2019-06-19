Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218984B517
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfFSJkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:40:53 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40689 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfFSJkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:40:53 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so36644077ioc.7
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 02:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9E1KRk5GS4oXR0jhMk478AJenwyDL2d36E4SSe6bTfY=;
        b=rf6a5cJs06tJrrTZmHnLdC8Gjfs7W+yHXhA4qwh7zeLGcPlWT738lJj525LMLKY/D0
         KgeZHPmH9F76TeK2BMd3eFDmQXuvdqsLQ1Ek87u4u9myNbWgug1jHdcQ/EwpaPJJOFa7
         B/4Yf0E8w50fKzPHUHl1F4RGjl0K0Uy6ExRqQcF25h3epouYswZoQxRKh618oiB7uyLq
         /UWU3x2JHTI1AXqefa16J7pvhwBBvIIERLhOtE/vWasuf2VvKQIfrUn3+aHuafFnEQMW
         foCbR+DLnk8jW3CbPhzOWm6+IYv2Kyj7G69wAwLDH3/rZGtfIcLTzb38FBy96ZPqp8Wm
         EBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9E1KRk5GS4oXR0jhMk478AJenwyDL2d36E4SSe6bTfY=;
        b=CLNop+0gcOCAnuDwhpXqyPkuLj3nRlaU+lUyITBtDOJsC2ZJZJzdOQ+s/mm7tBXI1I
         wCQsTLiC6acarMte7Rfn25UNqXhARb591Gok3t+uy38z0ZeFIAMykJECVDUEAitRkmtC
         sFUDNIBu5G+P0IrUchVQrR6D8lqwzW+7NB+FCSCgnSOtXY4N3plpmnZz4QEOeBr5keB+
         dd/QJ06yx66gsp0+JZST7lCcd40wyVe0zO4DQurxuiD3jwadyJjX8w8sP4Y971qcoxgx
         PIzTjZrOqpkQAtw57cIC/I7cQ1PQriSQpdxuj/sj9YENNYbj56neb/a6XneCxvNK/YIA
         /Lag==
X-Gm-Message-State: APjAAAWIRc9sidC4lgXOlaT/zD0rKPG4Ntt5VTGwj7h7EvNA/mBCJT+q
        bAm8DsbpdmfNtAJkmyltS/+S/mnST9Kjqp3GMi2WaA==
X-Google-Smtp-Source: APXvYqy7T8RjpR6oMBuJd3OM0JdQHtc5Kq3bDBD+rmy9SSDEtlq1zYV/s8cgopMpkgQhVywNiuJ2n7OnUkGrFQM3k1Y=
X-Received: by 2002:a5d:9d97:: with SMTP id 23mr10861363ion.204.1560937252081;
 Wed, 19 Jun 2019 02:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org>
In-Reply-To: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 11:40:40 +0200
Message-ID: <CAKv+Gu9tdWM=ECwB0HaPuc=dCvPS0=3jtye8gctW9SoVi0b18Q@mail.gmail.com>
Subject: Re: [net-next, PATCH 1/2] net: netsec: initialize tx ring on ndo_open
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jaswinder Singh <jaswinder.singh@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 at 09:57, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Since we changed the Tx ring handling and now depend not bit31 to figure

s/not/on/

> out the owner of the descriptor, we should initialize this every time
> the device goes down-up instead of doing it once on driver init. If the
> value is not correctly initialized the device won't have any available
> descriptors
>
> Fixes: 35e07d23473972b8876f98bcfc631ebcf779e870 ("net: socionext: remove mmio reads on Tx")
>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/net/ethernet/socionext/netsec.c | 32 ++++++++++++++-----------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index cba5881b2746..a10ef700f16d 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -1029,7 +1029,6 @@ static void netsec_free_dring(struct netsec_priv *priv, int id)
>  static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
>  {
>         struct netsec_desc_ring *dring = &priv->desc_ring[id];
> -       int i;
>
>         dring->vaddr = dma_alloc_coherent(priv->dev, DESC_SZ * DESC_NUM,
>                                           &dring->desc_dma, GFP_KERNEL);
> @@ -1040,19 +1039,6 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
>         if (!dring->desc)
>                 goto err;
>
> -       if (id == NETSEC_RING_TX) {
> -               for (i = 0; i < DESC_NUM; i++) {
> -                       struct netsec_de *de;
> -
> -                       de = dring->vaddr + (DESC_SZ * i);
> -                       /* de->attr is not going to be accessed by the NIC
> -                        * until netsec_set_tx_de() is called.
> -                        * No need for a dma_wmb() here
> -                        */
> -                       de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
> -               }
> -       }
> -
>         return 0;
>  err:
>         netsec_free_dring(priv, id);
> @@ -1060,6 +1046,23 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
>         return -ENOMEM;
>  }
>
> +static void netsec_setup_tx_dring(struct netsec_priv *priv)
> +{
> +       struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
> +       int i;
> +
> +       for (i = 0; i < DESC_NUM; i++) {
> +               struct netsec_de *de;
> +
> +               de = dring->vaddr + (DESC_SZ * i);
> +               /* de->attr is not going to be accessed by the NIC
> +                * until netsec_set_tx_de() is called.
> +                * No need for a dma_wmb() here
> +                */
> +               de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
> +       }
> +}
> +
>  static int netsec_setup_rx_dring(struct netsec_priv *priv)
>  {
>         struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> @@ -1361,6 +1364,7 @@ static int netsec_netdev_open(struct net_device *ndev)
>
>         pm_runtime_get_sync(priv->dev);
>
> +       netsec_setup_tx_dring(priv);
>         ret = netsec_setup_rx_dring(priv);
>         if (ret) {
>                 netif_err(priv, probe, priv->ndev,
> --
> 2.20.1
>
