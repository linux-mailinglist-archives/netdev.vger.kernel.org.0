Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92022AF74C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgKKRUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKKRUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:20:25 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FEAC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:25 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id g15so2649167ilc.9
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=glnCV2wpnjjtFD/1iVjzHrN0Ja0+qw83ElGBtmnJ+ik=;
        b=Pt5RWSeDdjjFWomhdt17Bl1vRhY5qhuKFnpPi/7JFw7cLMnaKCToOOodywqrdqnMtg
         l2CDRlIFdSDfNdNCd546XQK+A6pB6rOL+gU5AXtZmxtk7v+YIEiqPNR5dCY4HC7eVo4U
         6fYYalT2hG0bTl3LYlndBjHiKgZY9Bg/qEagPEzp3uzZY+UCzwOKqHrlWJhfge5KN8Gf
         4lecirIu8qmGVOnP9A+ehG5Gvj0RzH5nGY2n+FhnYeZMbwPYCcxGxdVX/u+vnMP+oOGP
         Tb7AXiD21Gtt4O1Ca9++FAKO1WMeg4Cbpggzx2RNi/80xgUdpEV1Dpo2iD5DvbyyW1a2
         /KqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=glnCV2wpnjjtFD/1iVjzHrN0Ja0+qw83ElGBtmnJ+ik=;
        b=BYOBT+AoUoY0Y6uqZx9K1exVvVgN3RhKhX2FgVzOpg1/AP4em4+vAfZDScI0XoCNlN
         VytA+uRfV6SSdl0Sl6ohtL8OqYUW8/FHQhJbdQ0SzgW/qnb4qPg8v2aYOeeVQ9WYxO5g
         zlpvcKQGuu1uWV2KexW5DYJNifkCmgadPdg7tE51F1YlFS3YUDBERpLyzHhbOv5jAFNv
         78fdwFdGjfujFXZZazvg963OHose3ys6JX2mQ6w7vsmEdvlKeYKbJ/d5UJ9IX1VIh8mk
         arg/mBtnySGmlwAPMoo0XMcmaXQa6zT7Z7+qq/WpPg/PgJiYMcC5Lg4FQsxuPBTKsUqj
         zA9g==
X-Gm-Message-State: AOAM530/QjypWq6w9X18TO5Qj91TENk9w2Wdw79R6OuU8RVEEUZnIVef
        wzZZ83ORg2Zx64ToSJZIZG7+O4CozV1ap7mOGZQ=
X-Google-Smtp-Source: ABdhPJy1sEhW4fztMLGmzwompXcE6AY8mguD2UJGMWMu4eBjXCgcn+CpoUZnvxkBsFx6gm5Zmy/vLvkzNUHIA70Uxk8=
X-Received: by 2002:a05:6e02:1305:: with SMTP id g5mr19965513ilr.237.1605115224701;
 Wed, 11 Nov 2020 09:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com> <20201109233659.1953461-2-awogbemila@google.com>
In-Reply-To: <20201109233659.1953461-2-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Nov 2020 09:20:13 -0800
Message-ID: <CAKgT0UdKF86wzAxw1ZQybsDAggryvnqXM73NzP3XvcXb4MtYCg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/4] gve: Add support for raw addressing
 device option
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
>
> From: Catherine Sullivan <csully@google.com>
>
> Add support to describe device for parsing device options. As
> the first device option, add raw addressing.
>
> "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> operational mode which allows the driver avoid bounce buffer copies
> which it currently performs using pre-allocated qpls (queue_page_lists)
> when sending and receiving packets.
> For egress packets, the provided skb data addresses will be dma_map'ed and
> passed to the device, allowing the NIC can perform DMA directly - the
> driver will not have to copy the buffer content into pre-allocated
> buffers/qpls (as in qpl mode).
> For ingress packets, copies are also eliminated as buffers are handed to
> the networking stack and then recycled or re-allocated as
> necessary, avoiding the use of skb_copy_to_linear_data().
>
> This patch only introduces the option to the driver.
> Subsequent patches will add the ingress and egress functionality.
>
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>

A few minor nits called out below. Otherwise it looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ethernet/google/gve/gve.h        |  1 +
>  drivers/net/ethernet/google/gve/gve_adminq.c | 64 ++++++++++++++++++++
>  drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++--
>  drivers/net/ethernet/google/gve/gve_main.c   |  9 +++
>  4 files changed, 85 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index f5c80229ea96..80cdae06ee39 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -199,6 +199,7 @@ struct gve_priv {
>         u64 num_registered_pages; /* num pages registered with NIC */
>         u32 rx_copybreak; /* copy packets smaller than this */
>         u16 default_num_queues; /* default num queues to set up */
> +       bool raw_addressing; /* true if this dev supports raw addressing */

The use of bool is generally frowned upon in structures if you care
about the cache alignment. You should probably just make this a char
or u8.

>
>         struct gve_queue_config tx_cfg;
>         struct gve_queue_config rx_cfg;
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 24ae6a28a806..3e6de659b274 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -14,6 +14,18 @@
>  #define GVE_ADMINQ_SLEEP_LEN           20
>  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK     100
>
> +static inline
> +struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *descriptor,
> +                                             struct gve_device_option *option)
> +{
> +       void *option_end, *descriptor_end;
> +
> +       option_end = (void *)option + sizeof(*option) + be16_to_cpu(option->option_length);

If I am not mistaken you can make this statement more compact with the
following:
        option_end = (void *)(option + 1) + be16_to_cpu(option->option_length);

> +       descriptor_end = (void *)descriptor + be16_to_cpu(descriptor->total_length);
> +
> +       return option_end > descriptor_end ? NULL : (struct gve_device_option *)option_end;
> +}
> +
>  int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
>  {
>         priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
> @@ -460,11 +472,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
>  int gve_adminq_describe_device(struct gve_priv *priv)
>  {
>         struct gve_device_descriptor *descriptor;
> +       struct gve_device_option *dev_opt;
>         union gve_adminq_command cmd;
>         dma_addr_t descriptor_bus;
> +       u16 num_options;
>         int err = 0;
>         u8 *mac;
>         u16 mtu;
> +       int i;
>
>         memset(&cmd, 0, sizeof(cmd));
>         descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
> @@ -518,6 +533,55 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>                 priv->rx_desc_cnt = priv->rx_pages_per_qpl;
>         }
>         priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
> +       dev_opt = (void *)(descriptor + 1);
> +
> +       num_options = be16_to_cpu(descriptor->num_device_options);
> +       for (i = 0; i < num_options; i++) {
> +               u16 option_length = be16_to_cpu(dev_opt->option_length);
> +               u16 option_id = be16_to_cpu(dev_opt->option_id);
> +               struct gve_device_option *next_opt;
> +
> +               next_opt = gve_get_next_option(descriptor, dev_opt);
> +               if (!next_opt) {
> +                       dev_err(&priv->dev->dev,
> +                               "options exceed device_descriptor's total length.\n");
> +                       err = -EINVAL;
> +                       goto free_device_descriptor;
> +               }
> +
> +               switch (option_id) {
> +               case GVE_DEV_OPT_ID_RAW_ADDRESSING:
> +                       /* If the length or feature mask doesn't match,
> +                        * continue without enabling the feature.
> +                        */
> +                       if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
> +                           dev_opt->feat_mask !=
> +                           cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
> +                               dev_warn(&priv->pdev->dev,
> +                                        "Raw addressing option error:\n"
> +                                        "      Expected: length=%d, feature_mask=%x.\n"
> +                                        "      Actual: length=%d, feature_mask=%x.\n",
> +                                        GVE_DEV_OPT_LEN_RAW_ADDRESSING,
> +                                        cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
> +                                        option_length, dev_opt->feat_mask);
> +                               priv->raw_addressing = false;
> +                       } else {
> +                               dev_info(&priv->pdev->dev,
> +                                        "Raw addressing device option enabled.\n");
> +                               priv->raw_addressing = true;
> +                       }
> +                       break;
> +               default:
> +                       /* If we don't recognize the option just continue
> +                        * without doing anything.
> +                        */
> +                       dev_dbg(&priv->pdev->dev,
> +                               "Unrecognized device option 0x%hx not enabled.\n",
> +                               option_id);
> +                       break;
> +               }
> +               dev_opt = next_opt;

Is there any reason for having this switch statement as a part of the
function instead of a function onto itself? Seems like you could take
all the code in the switch statement and move it into a seperate
function and only need to pass priv and dev_opt. That way you could
reduce the indentation a bit and help to make this a bit more readable
by possibly not having to fold lines like you did in the if statement
above.



> +       }
>
>  free_device_descriptor:
>         dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
> index 281de8326bc5..af5f586167bd 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.h
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.h
> @@ -79,12 +79,17 @@ struct gve_device_descriptor {
>
>  static_assert(sizeof(struct gve_device_descriptor) == 40);
>
> -struct device_option {
> -       __be32 option_id;
> -       __be32 option_length;
> +struct gve_device_option {
> +       __be16 option_id;
> +       __be16 option_length;
> +       __be32 feat_mask;
>  };
>
> -static_assert(sizeof(struct device_option) == 8);
> +static_assert(sizeof(struct gve_device_option) == 8);
> +
> +#define GVE_DEV_OPT_ID_RAW_ADDRESSING 0x1
> +#define GVE_DEV_OPT_LEN_RAW_ADDRESSING 0x0
> +#define GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING 0x0
>
>  struct gve_adminq_configure_device_resources {
>         __be64 counter_array;
> @@ -111,6 +116,8 @@ struct gve_adminq_unregister_page_list {
>
>  static_assert(sizeof(struct gve_adminq_unregister_page_list) == 4);
>
> +#define GVE_RAW_ADDRESSING_QPL_ID 0xFFFFFFFF
> +
>  struct gve_adminq_create_tx_queue {
>         __be32 queue_id;
>         __be32 reserved;
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 48a433154ce0..70685c10db0e 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -678,6 +678,10 @@ static int gve_alloc_qpls(struct gve_priv *priv)
>         int i, j;
>         int err;
>
> +       /* Raw addressing means no QPLs */
> +       if (priv->raw_addressing)
> +               return 0;
> +
>         priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
>         if (!priv->qpls)
>                 return -ENOMEM;
> @@ -718,6 +722,10 @@ static void gve_free_qpls(struct gve_priv *priv)
>         int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
>         int i;
>
> +       /* Raw addressing means no QPLs */
> +       if (priv->raw_addressing)
> +               return;
> +
>         kvfree(priv->qpl_cfg.qpl_id_map);
>
>         for (i = 0; i < num_qpls; i++)
> @@ -1078,6 +1086,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
>         if (skip_describe_device)
>                 goto setup_device;
>
> +       priv->raw_addressing = false;
>         /* Get the initial information we need from the device */
>         err = gve_adminq_describe_device(priv);
>         if (err) {
> --
> 2.29.2.222.g5d2a92d10f8-goog
>
