Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389282B883F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKRXPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgKRXPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:15:02 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29137C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:15:02 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so5174931ejb.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n3FIP6AYyCemDzRFjdjIYV9OwpOyUm6Qemuz5uHuck8=;
        b=W/ql0nibCIHfWrnllyWaDHuklWZgdCXNn9RaLRMoR6eTbC2uQwiz+4VIkvmVk00dAV
         vcvPGq8saEGdDHKM5wy9RkcowyUZyipn/9zJrCBKSR7taeGp7FL0JCW3B8fzPTQgLCl0
         ICBi8xBHi62ZAaPgI6hEgkeD4WmT4a3gEwrWPlLtoRL2/a5VcbzskSuYJCAHXFLxtCLJ
         X9ON8hC9ergeQQ0D0db3KZYamA86FGm4z7EW9kxcplrzSuEOCCzeag+FMAUECIQ81I/B
         rKHYNgquMGXZ0iJw/0kliw7W7JSZtIeo1JyeXUE+ta2QVZPHC8W8OF7lMawshYUaC8SX
         CPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n3FIP6AYyCemDzRFjdjIYV9OwpOyUm6Qemuz5uHuck8=;
        b=SxkVeX9XBs/99BGp2G9Lv3t02p/rxySGZNuPAr1Y0DC+LwqDMybZbXMGD2M/npp2ts
         X0pAPPrAVywIGP8WGdA0HUNI9eygAn8SRGnQMnwYxC38AqynW19joKz7+L0ugZGAei4Z
         SJy2BFHyjJ8lwsPEPpBjvOsJpSgf9a2I2Lxn7PajZ8DqUoqR25hLXIPFEhwkmdlPPp38
         4roHED6lVoPhe3h4c+JgWg5/OLlVgys2Uvop5U3p8j8eU+JCsez+3XK9K+fwZPH9VrsS
         ILVxQpopundEE9tdEhCcCtt4J7A5EShobm1JhCkbnDoUivGOlfWzNpMibdcG/njiwDsd
         sZNA==
X-Gm-Message-State: AOAM531fcm83/66gxGyhd9Tt60AL3N7AeRview5YXrdscJPDHF4hcRSm
        cQNAuc9iEskrLIZ2nKB7icONV2H4xHd9P5fm+xR0PztCluc=
X-Google-Smtp-Source: ABdhPJx9dd8ZFGxzH6iLgw0gBnkfa70557BWoseJk2/8eLNrzxSmTYBlr4yFd185p/jddMh4eoc32TnGNrQXpLJpXV0=
X-Received: by 2002:a17:906:36d6:: with SMTP id b22mr14191714ejc.313.1605741300618;
 Wed, 18 Nov 2020 15:15:00 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-2-awogbemila@google.com> <CAKgT0UdKF86wzAxw1ZQybsDAggryvnqXM73NzP3XvcXb4MtYCg@mail.gmail.com>
In-Reply-To: <CAKgT0UdKF86wzAxw1ZQybsDAggryvnqXM73NzP3XvcXb4MtYCg@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 18 Nov 2020 15:14:49 -0800
Message-ID: <CAL9ddJeeWOC+3-zvx1A6UrdMRh4nsrBMiQXTmw5TcH_grXE-+w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/4] gve: Add support for raw addressing
 device option
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> A few minor nits called out below. Otherwise it looks good to me.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h        |  1 +
> >  drivers/net/ethernet/google/gve/gve_adminq.c | 64 ++++++++++++++++++++
> >  drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++--
> >  drivers/net/ethernet/google/gve/gve_main.c   |  9 +++
> >  4 files changed, 85 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> > index f5c80229ea96..80cdae06ee39 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -199,6 +199,7 @@ struct gve_priv {
> >         u64 num_registered_pages; /* num pages registered with NIC */
> >         u32 rx_copybreak; /* copy packets smaller than this */
> >         u16 default_num_queues; /* default num queues to set up */
> > +       bool raw_addressing; /* true if this dev supports raw addressing */
>
> The use of bool is generally frowned upon in structures if you care
> about the cache alignment. You should probably just make this a char
> or u8.

Thanks for the suggestions, I'll use u8.
>
> >
> >         struct gve_queue_config tx_cfg;
> >         struct gve_queue_config rx_cfg;
> > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> > index 24ae6a28a806..3e6de659b274 100644
> > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > @@ -14,6 +14,18 @@
> >  #define GVE_ADMINQ_SLEEP_LEN           20
> >  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK     100
> >
> > +static inline
> > +struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *descriptor,
> > +                                             struct gve_device_option *option)
> > +{
> > +       void *option_end, *descriptor_end;
> > +
> > +       option_end = (void *)option + sizeof(*option) + be16_to_cpu(option->option_length);
>
> If I am not mistaken you can make this statement more compact with the
> following:
>         option_end = (void *)(option + 1) + be16_to_cpu(option->option_length);
>
Yes, I'll use (option + 1) instead.

> > +       descriptor_end = (void *)descriptor + be16_to_cpu(descriptor->total_length);
> > +
> > +       return option_end > descriptor_end ? NULL : (struct gve_device_option *)option_end;
> > +}
> > +
> >  int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
> >  {
> >         priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
> > @@ -460,11 +472,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
> >  int gve_adminq_describe_device(struct gve_priv *priv)
> >  {
> >         struct gve_device_descriptor *descriptor;
> > +       struct gve_device_option *dev_opt;
> >         union gve_adminq_command cmd;
> >         dma_addr_t descriptor_bus;
> > +       u16 num_options;
> >         int err = 0;
> >         u8 *mac;
> >         u16 mtu;
> > +       int i;
> >
> >         memset(&cmd, 0, sizeof(cmd));
> >         descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
> > @@ -518,6 +533,55 @@ int gve_adminq_describe_device(struct gve_priv *priv)
> >                 priv->rx_desc_cnt = priv->rx_pages_per_qpl;
> >         }
> >         priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
> > +       dev_opt = (void *)(descriptor + 1);
> > +
> > +       num_options = be16_to_cpu(descriptor->num_device_options);
> > +       for (i = 0; i < num_options; i++) {
> > +               u16 option_length = be16_to_cpu(dev_opt->option_length);
> > +               u16 option_id = be16_to_cpu(dev_opt->option_id);
> > +               struct gve_device_option *next_opt;
> > +
> > +               next_opt = gve_get_next_option(descriptor, dev_opt);
> > +               if (!next_opt) {
> > +                       dev_err(&priv->dev->dev,
> > +                               "options exceed device_descriptor's total length.\n");
> > +                       err = -EINVAL;
> > +                       goto free_device_descriptor;
> > +               }
> > +
> > +               switch (option_id) {
> > +               case GVE_DEV_OPT_ID_RAW_ADDRESSING:
> > +                       /* If the length or feature mask doesn't match,
> > +                        * continue without enabling the feature.
> > +                        */
> > +                       if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
> > +                           dev_opt->feat_mask !=
> > +                           cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
> > +                               dev_warn(&priv->pdev->dev,
> > +                                        "Raw addressing option error:\n"
> > +                                        "      Expected: length=%d, feature_mask=%x.\n"
> > +                                        "      Actual: length=%d, feature_mask=%x.\n",
> > +                                        GVE_DEV_OPT_LEN_RAW_ADDRESSING,
> > +                                        cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
> > +                                        option_length, dev_opt->feat_mask);
> > +                               priv->raw_addressing = false;
> > +                       } else {
> > +                               dev_info(&priv->pdev->dev,
> > +                                        "Raw addressing device option enabled.\n");
> > +                               priv->raw_addressing = true;
> > +                       }
> > +                       break;
> > +               default:
> > +                       /* If we don't recognize the option just continue
> > +                        * without doing anything.
> > +                        */
> > +                       dev_dbg(&priv->pdev->dev,
> > +                               "Unrecognized device option 0x%hx not enabled.\n",
> > +                               option_id);
> > +                       break;
> > +               }
> > +               dev_opt = next_opt;
>
> Is there any reason for having this switch statement as a part of the
> function instead of a function onto itself? Seems like you could take
> all the code in the switch statement and move it into a seperate
> function and only need to pass priv and dev_opt. That way you could
> reduce the indentation a bit and help to make this a bit more readable
> by possibly not having to fold lines like you did in the if statement
> above.
Ok, I'll separate this into a different function.


>
>
>
> > +       }
> >
> >  free_device_descriptor:
> >         dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
> > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
> > index 281de8326bc5..af5f586167bd 100644
> > --- a/drivers/net/ethernet/google/gve/gve_adminq.h
> > +++ b/drivers/net/ethernet/google/gve/gve_adminq.h
> > @@ -79,12 +79,17 @@ struct gve_device_descriptor {
> >
> >  static_assert(sizeof(struct gve_device_descriptor) == 40);
> >
> > -struct device_option {
> > -       __be32 option_id;
> > -       __be32 option_length;
> > +struct gve_device_option {
> > +       __be16 option_id;
> > +       __be16 option_length;
> > +       __be32 feat_mask;
> >  };
> >
> > -static_assert(sizeof(struct device_option) == 8);
> > +static_assert(sizeof(struct gve_device_option) == 8);
> > +
> > +#define GVE_DEV_OPT_ID_RAW_ADDRESSING 0x1
> > +#define GVE_DEV_OPT_LEN_RAW_ADDRESSING 0x0
> > +#define GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING 0x0
> >
> >  struct gve_adminq_configure_device_resources {
> >         __be64 counter_array;
> > @@ -111,6 +116,8 @@ struct gve_adminq_unregister_page_list {
> >
> >  static_assert(sizeof(struct gve_adminq_unregister_page_list) == 4);
> >
> > +#define GVE_RAW_ADDRESSING_QPL_ID 0xFFFFFFFF
> > +
> >  struct gve_adminq_create_tx_queue {
> >         __be32 queue_id;
> >         __be32 reserved;
> > diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> > index 48a433154ce0..70685c10db0e 100644
> > --- a/drivers/net/ethernet/google/gve/gve_main.c
> > +++ b/drivers/net/ethernet/google/gve/gve_main.c
> > @@ -678,6 +678,10 @@ static int gve_alloc_qpls(struct gve_priv *priv)
> >         int i, j;
> >         int err;
> >
> > +       /* Raw addressing means no QPLs */
> > +       if (priv->raw_addressing)
> > +               return 0;
> > +
> >         priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
> >         if (!priv->qpls)
> >                 return -ENOMEM;
> > @@ -718,6 +722,10 @@ static void gve_free_qpls(struct gve_priv *priv)
> >         int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
> >         int i;
> >
> > +       /* Raw addressing means no QPLs */
> > +       if (priv->raw_addressing)
> > +               return;
> > +
> >         kvfree(priv->qpl_cfg.qpl_id_map);
> >
> >         for (i = 0; i < num_qpls; i++)
> > @@ -1078,6 +1086,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
> >         if (skip_describe_device)
> >                 goto setup_device;
> >
> > +       priv->raw_addressing = false;
> >         /* Get the initial information we need from the device */
> >         err = gve_adminq_describe_device(priv);
> >         if (err) {
> > --
> > 2.29.2.222.g5d2a92d10f8-goog
> >
