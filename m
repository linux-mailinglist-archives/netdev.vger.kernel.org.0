Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9882AC682
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgKIVC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKIVC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:02:56 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28281C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 13:02:56 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o9so14363603ejg.1
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 13:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1MpqAr7WUWLVR6sicCUs2LlVAQDrfhnkN0gYmTcIL4=;
        b=hYrE+IYZmkWMAqzYrSj/M/Ib194DeQCHHWOBT3uaSYyiy/dgLC9u63GFfTMogzwAmS
         BoggCWkFz5/XnuK8O8ISVa9K8p2fCGqvI/bV1N85IDMvnN5QAzOP24dk8yVKuvHqxVx3
         nJrvZrvOXMASM10OcixRgdHfq+QlWrQTwJpDkgMagDmxvQvfeKJ/FmwSdtk5hw2U7hlD
         TkXPoUNR+6VLfhguM13a42tjmXslwrJ3lzzZg3j4HltjpU0qlRPSQ8feQ8l5qqdYXYhw
         o+0q8ihg5jDZZeAXCfqS+48Zeu8DlytlfxGtY3mgT83f/fHVNVhnA5xhyIiCdrBM2yfd
         g6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1MpqAr7WUWLVR6sicCUs2LlVAQDrfhnkN0gYmTcIL4=;
        b=FKW2bJI0KfKJtTAh3jE2ceaJ+gPCGhaS3OwNyKwLRtNy0ZF3/5xHIj8e8Idxwns98B
         3/+brix9YoJT6Orj60tbi0PB8shQy6IiH2BlByV0Bt1GePY80+ljELmJIEF8Po+K5NEq
         EEWlVd8dm9XZDmHWmlkJs/hbrqWE/ZpSAHAamLeOsIIJy6HPCAD8FW59DvawwS0stnuK
         i9rNwf1eQqrtjvwBQOiGjgkjG82hdN11SP4V3iWl214HOoTJz1i+dOynfaIDZgmLhc8D
         5WTJ6SoRz+ja4v3Ytl1rs3SSTa+ekeXZSPcgOHizS20XZJaGxeN6j6TQH+D0TXpVZ+t5
         xcyQ==
X-Gm-Message-State: AOAM531H0BxiQcuXvAbvXrUyOl9aZdGrjSDoxqSAU9F78FVbiezQAtSw
        dolBtvAMexZRFIqDvtBJeciGl0KYDfcJoMLr9FOf9g==
X-Google-Smtp-Source: ABdhPJya9da5/lYkK/loQ1w5id5ejoMnXv2iEhQRqtPOsr8sfSDp2TORIOcZWWqVgg2Bj0sHP/qAcExyz/y6ED0DudI=
X-Received: by 2002:a17:906:5793:: with SMTP id k19mr17422032ejq.410.1604955774676;
 Mon, 09 Nov 2020 13:02:54 -0800 (PST)
MIME-Version: 1.0
References: <20201103174651.590586-1-awogbemila@google.com>
 <20201103174651.590586-2-awogbemila@google.com> <f4b03d3c70c2b1e19e42d0209e270110b7668039.camel@kernel.org>
 <CAL9ddJdgFvSZ-4F9XXHec-NDCbQjX20nWJF8=YQc7iiC_OSfoQ@mail.gmail.com>
In-Reply-To: <CAL9ddJdgFvSZ-4F9XXHec-NDCbQjX20nWJF8=YQc7iiC_OSfoQ@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Mon, 9 Nov 2020 13:02:43 -0800
Message-ID: <CAL9ddJcS4oPhvOgsrXD6au0P8MFPBAoHW9TNEOTjMGB_jbwt-g@mail.gmail.com>
Subject: Re: [PATCH 1/4] gve: Add support for raw addressing device option
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, I think I'll adopt a helper static inline function - it may
be tidier than a macro.

On Fri, Nov 6, 2020 at 11:41 AM David Awogbemila <awogbemila@google.com> wrote:
>
> On Tue, Nov 3, 2020 at 2:43 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >
> > On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> > > From: Catherine Sullivan <csully@google.com>
> > >
> > > Add support to describe device for parsing device options. As
> > > the first device option, add raw addressing.
> > >
> > > "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> > > operational mode which allows the driver avoid bounce buffer copies
> > > which it currently performs using pre-allocated qpls
> > > (queue_page_lists)
> > > when sending and receiving packets.
> > > For egress packets, the provided skb data addresses will be
> > > dma_map'ed and
> > > passed to the device, allowing the NIC can perform DMA directly - the
> > > driver will not have to copy the buffer content into pre-allocated
> > > buffers/qpls (as in qpl mode).
> > > For ingress packets, copies are also eliminated as buffers are handed
> > > to
> > > the networking stack and then recycled or re-allocated as
> > > necessary, avoiding the use of skb_copy_to_linear_data().
> > >
> > > This patch only introduces the option to the driver.
> > > Subsequent patches will add the ingress and egress functionality.
> > >
> > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > ---
> > >  drivers/net/ethernet/google/gve/gve.h        |  1 +
> > >  drivers/net/ethernet/google/gve/gve_adminq.c | 52
> > > ++++++++++++++++++++
> > >  drivers/net/ethernet/google/gve/gve_adminq.h | 15 ++++--
> > >  drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
> > >  4 files changed, 73 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/google/gve/gve.h
> > > b/drivers/net/ethernet/google/gve/gve.h
> > > index f5c80229ea96..80cdae06ee39 100644
> > > --- a/drivers/net/ethernet/google/gve/gve.h
> > > +++ b/drivers/net/ethernet/google/gve/gve.h
> > > @@ -199,6 +199,7 @@ struct gve_priv {
> > >       u64 num_registered_pages; /* num pages registered with NIC */
> > >       u32 rx_copybreak; /* copy packets smaller than this */
> > >       u16 default_num_queues; /* default num queues to set up */
> > > +     bool raw_addressing; /* true if this dev supports raw
> > > addressing */
> > >
> > >       struct gve_queue_config tx_cfg;
> > >       struct gve_queue_config rx_cfg;
> > > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > index 24ae6a28a806..0b7a2653fe33 100644
> > > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > @@ -460,11 +460,14 @@ int gve_adminq_destroy_rx_queues(struct
> > > gve_priv *priv, u32 num_queues)
> > >  int gve_adminq_describe_device(struct gve_priv *priv)
> > >  {
> > >       struct gve_device_descriptor *descriptor;
> > > +     struct gve_device_option *dev_opt;
> > >       union gve_adminq_command cmd;
> > >       dma_addr_t descriptor_bus;
> > > +     u16 num_options;
> > >       int err = 0;
> > >       u8 *mac;
> > >       u16 mtu;
> > > +     int i;
> > >
> > >       memset(&cmd, 0, sizeof(cmd));
> > >       descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
> > > @@ -518,6 +521,55 @@ int gve_adminq_describe_device(struct gve_priv
> > > *priv)
> > >               priv->rx_desc_cnt = priv->rx_pages_per_qpl;
> > >       }
> > >       priv->default_num_queues = be16_to_cpu(descriptor-
> > > >default_num_queues);
> > > +     dev_opt = (void *)(descriptor + 1);
> > > +
> > > +     num_options = be16_to_cpu(descriptor->num_device_options);
> > > +     for (i = 0; i < num_options; i++) {
> > > +             u16 option_length = be16_to_cpu(dev_opt-
> > > >option_length);
> > > +             u16 option_id = be16_to_cpu(dev_opt->option_id);
> > > +             void *option_end;
> > > +
> > > +             option_end = (void *)dev_opt + sizeof(*dev_opt) +
> > > option_length;
> > > +             if (option_end > (void *)descriptor +
> > > be16_to_cpu(descriptor->total_length)) {
> > > +                     dev_err(&priv->dev->dev,
> > > +                             "options exceed device_descriptor's
> > > total length.\n");
> > > +                     err = -EINVAL;
> > > +                     goto free_device_descriptor;
> > > +             }
> > > +
> > > +             switch (option_id) {
> > > +             case GVE_DEV_OPT_ID_RAW_ADDRESSING:
> > > +                     /* If the length or feature mask doesn't match,
> > > +                      * continue without enabling the feature.
> > > +                      */
> > > +                     if (option_length !=
> > > GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
> > > +                         dev_opt->feat_mask !=
> > > +                         cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRE
> > > SSING)) {
> > > +                             dev_warn(&priv->pdev->dev,
> > > +                                      "Raw addressing option
> > > error:\n"
> > > +                                      "      Expected: length=%d,
> > > feature_mask=%x.\n"
> > > +                                      "      Actual: length=%d,
> > > feature_mask=%x.\n",
> > > +                                      GVE_DEV_OPT_LEN_RAW_ADDRESSING
> > > ,
> > > +                                      cpu_to_be32(GVE_DEV_OPT_FEAT_M
> > > ASK_RAW_ADDRESSING),
> > > +                                      option_length, dev_opt-
> > > >feat_mask);
> > > +                             priv->raw_addressing = false;
> > > +                     } else {
> > > +                             dev_info(&priv->pdev->dev,
> > > +                                      "Raw addressing device option
> > > enabled.\n");
> > > +                             priv->raw_addressing = true;
> > > +                     }
> > > +                     break;
> > > +             default:
> > > +                     /* If we don't recognize the option just
> > > continue
> > > +                      * without doing anything.
> > > +                      */
> > > +                     dev_dbg(&priv->pdev->dev,
> > > +                             "Unrecognized device option 0x%hx not
> > > enabled.\n",
> > > +                             option_id);
> > > +                     break;
> > > +             }
> > > +             dev_opt = (void *)dev_opt + sizeof(*dev_opt) +
> > > option_length;
> >
> > This was already calculated above, "option_end"
> >
> >
> > Suggestion: you can make an iterator macro to return the next opt
> >
> > next_opt = GET_NEXT_OPT(descriptor, curr_opt);
> >
> > you can make it check boundaries and return null on last iteration or
> > when total length is exceeded, and just use it in a more readable
> > iterator loop.
> >
> Thanks for the suggestion. I will adopt a macro but it'll only return
> NULL if the options exceed the boundary - that way we can distinguish
> between an error (boundary exceeded) and the last option.
