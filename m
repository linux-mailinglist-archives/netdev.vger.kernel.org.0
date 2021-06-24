Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B623B39E4
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 01:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFXX5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 19:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXX5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 19:57:42 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B23C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 16:55:21 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u11so10092068ljh.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 16:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6vKGBcExfnmfHRrNoEpxB0dY1zxMbnRLqexKezEB6E=;
        b=MnXVv92XIFjdXaPRKI1OW60v60B6ahiidm8zVdHQKxPMAAMSnupvbOlwrcVXt5YzcH
         cGXfHOfscAWIYfWI2G9Trc6iqH5QQRNZG6qjzm0yobWtcccPcppiINHeg1efmnFw5Ep0
         zCNqPolrpVW7ODkURLZSh9Qep9s2eCdJUibr5tqesxcY4YV7DkOrOhyeXU/xrae1gz/G
         xq3xfn0pvJIYwVYGi9Yz9fGqqNcE5zyIeKUtTJglpswi++VulRNfGMI9GnEDAxaQZ1lT
         0E9ICNjGsDvkAzsAaj5RjLpUH6hsi1Q9Mz9X8S6rc1TVUonsOBpq25ig2PnBkFrZnA9Z
         559w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6vKGBcExfnmfHRrNoEpxB0dY1zxMbnRLqexKezEB6E=;
        b=nyg/Eq1PeUhT9IqjjUhaPR237mgK21N28J63/k6xTyzodugeevDFShO61RLIedGaRU
         Wf1uO2EpZiGXYKnoJDT148xFRa1EhCPA/jp5Uc5tKTVKul1Oo5cXg6gKfFxBAOHSnE+r
         gwWbM5IouSPZSbfQq8fC4/XZhcU+Gus4OjdHsoUSHRGifirqxQWE938j3b1/Yeqprq7C
         1OrBvvQm7iS/8pUGc+IfPU10pE/xaQm5vx4q1XRUmAcgo6yq3mDBuuKRjhb/KEWZ8fnP
         /s4+W0zkLM+Vy4QI98VlwCf/VE57X+hoswpUwHDlMtM41RDvmmAO+QpBkCmfDSaevKaC
         6qgQ==
X-Gm-Message-State: AOAM532MfTGERWfemx8DUdIDEO6i0VIerx37KmIKqyWPUFGoweqBtAWK
        mjhYPKadKEga1PoVmInMNwSL5lJWyU7tbo1GJg71ZTNmLfRvfpBW
X-Google-Smtp-Source: ABdhPJwRAbdknOAme+jZcL/3R3YWZ8wuJIujV+AC+ZnMvNKqrZCO3AFjrpiTIat/sYEgz2vmArV5aN7KQ6QmavQZA20=
X-Received: by 2002:a2e:bc0d:: with SMTP id b13mr6033871ljf.245.1624578919611;
 Thu, 24 Jun 2021 16:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com> <20210624180632.3659809-13-bcf@google.com>
 <793c316c-e367-bf55-c4da-f4fc3d4aa587@intel.com>
In-Reply-To: <793c316c-e367-bf55-c4da-f4fc3d4aa587@intel.com>
From:   Bailey Forrest <bcf@google.com>
Date:   Thu, 24 Jun 2021 16:55:08 -0700
Message-ID: <CANH7hM5R8CR2pP5oLY-C7OcmdnX1xc9tZuimobPrdXiOGmi6BA@mail.gmail.com>
Subject: Re: [PATCH net-next 12/16] gve: DQO: Add core netdev features
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 4:18 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
> On 6/24/2021 11:06 AM, Bailey Forrest wrote:
> > Add napi netdev device registration, interrupt handling and initial tx
> > and rx polling stubs. The stubs will be filled in follow-on patches.
> >
> > Also:
> > - LRO feature advertisement and handling
> > - Also update ethtool logic
> >
> > Signed-off-by: Bailey Forrest <bcf@google.com>
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > Reviewed-by: Catherine Sullivan <csully@google.com>
> > ---
> >   drivers/net/ethernet/google/gve/Makefile      |   2 +-
> >   drivers/net/ethernet/google/gve/gve.h         |   2 +
> >   drivers/net/ethernet/google/gve/gve_adminq.c  |   2 +
> >   drivers/net/ethernet/google/gve/gve_dqo.h     |  32 +++
> >   drivers/net/ethernet/google/gve/gve_ethtool.c |  12 +-
> >   drivers/net/ethernet/google/gve/gve_main.c    | 188 ++++++++++++++++--
> >   drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  24 +++
> >   drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  23 +++
> >   8 files changed, 260 insertions(+), 25 deletions(-)
> >   create mode 100644 drivers/net/ethernet/google/gve/gve_dqo.h
> >   create mode 100644 drivers/net/ethernet/google/gve/gve_rx_dqo.c
> >   create mode 100644 drivers/net/ethernet/google/gve/gve_tx_dqo.c
> >
> > diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
> > index 0143f4471e42..b9a6be76531b 100644
> > --- a/drivers/net/ethernet/google/gve/Makefile
> > +++ b/drivers/net/ethernet/google/gve/Makefile
> > @@ -1,4 +1,4 @@
> >   # Makefile for the Google virtual Ethernet (gve) driver
> >
> >   obj-$(CONFIG_GVE) += gve.o
> > -gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o gve_utils.o
> > +gve-objs := gve_main.o gve_tx.o gve_tx_dqo.o gve_rx.o gve_rx_dqo.o gve_ethtool.o gve_adminq.o gve_utils.o
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> > index 8a2a8d125090..d6bf0466ae8b 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -45,6 +45,8 @@
> >   /* PTYPEs are always 10 bits. */
> >   #define GVE_NUM_PTYPES      1024
> >
> > +#define GVE_RX_BUFFER_SIZE_DQO 2048
> > +
> >   /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
> >   struct gve_rx_desc_queue {
> >       struct gve_rx_desc *desc_ring; /* the descriptor ring */
> > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> > index cf017a499119..5bb56b454541 100644
> > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > @@ -714,6 +714,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
> >       if (gve_is_gqi(priv)) {
> >               err = gve_set_desc_cnt(priv, descriptor);
> >       } else {
> > +             /* DQO supports LRO. */
> > +             priv->dev->hw_features |= NETIF_F_LRO;
>
> Shouldn't this be NETIF_F_HW_GRO?
> Also, what does DQO stands for?

DQO stands for "Dual Queue Out of order completions"

For now we only support LRO. HW GRO support may come in the future.

The reason for this is I was unable to get HW GRO to function in
conjunction with `napi_gro_frags()`. On our system, we need to use
`napi_gro_frags()` to achieve good performance. I did not see any
other drivers which support NETIF_F_HW_GRO and also use
`napi_gro_frags()`.

>
> <snip>
>
