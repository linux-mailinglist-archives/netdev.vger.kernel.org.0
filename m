Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38BD687DE0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjBBMvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjBBMvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:51:36 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF13C5255;
        Thu,  2 Feb 2023 04:51:33 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d26so1519221eds.12;
        Thu, 02 Feb 2023 04:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8hseVnWX4XYrzHezpLozN3J7tJFRqM3ENa+HKdRfPEE=;
        b=qCyJ4l3KjWT9iDlENLDqE2Bl4cvNyTjEVf3fGfcjyg/LGFkqIPZOF0mSPdUCm/+XzF
         XuDKpWbE6UnW8k1oHhaCekJdxDxV8hTMz3WI1aGi1YBkNrVviPNPD5XYK+J7skmxDtnH
         NS5/OcERUfztoZhSjbo3hEhsT7D2p1kMFKF4TDKs6phjUQGkN6T0u1GrPHL4LkuPAcE9
         Gw01T7eHf6eK0y4Z/PVnnc62XztfC1ZvYb2uVMeQz4mn1BRPSJU5D0eKgjDeDP8GC3IA
         +e1ILdEgTj7tNMek6sDapl2DCR8xa75UaZFuTngvTovJ+TOLsJnnSXqxF0v4UuqKDAV3
         Kjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hseVnWX4XYrzHezpLozN3J7tJFRqM3ENa+HKdRfPEE=;
        b=XLyIgLk8gK/e9XYeNtd9H/pzjxm4OBzzUkHIKF1F13ZzK3Y6UN562BAv1RpdvrBAQg
         VqSNdPkSTO25EsiuhEW3hPiQBFd2tGPuE1/k0ym3PQjS4AeHZRZRgrMpbh/8hMXFxgao
         fv42CwLenBd2AJxbeEyOkHvlGnnB630PzzT8JSmY2TGJwa5n+DsfiBDM2ybc6KnyEBvi
         1ECnxP/+h1Sz56z5uuKiMnGpjT8b/Q0MqZmFi3ayItmTACMeqc5z90WG8R2RxFONWTfB
         gPPJ6RIv59E2wGI5QaDqs6iI2dCVsH+3LdRbYl378OdKH58ISAqQilMMS1RSWQQjjaX0
         PV6w==
X-Gm-Message-State: AO0yUKWd1Jyt6orgak20ercg4pExaWRN1IM/cRV+l5lM2i2QkeHXgnp8
        OUGOdH97K0+QoAf9rGva3BU9GHIEaWU9T+GqiuU=
X-Google-Smtp-Source: AK7set/9CxKycoa4cRhiBGzECDwr/kSV1JIM9Uy0+zFDKYwsLzR6Aau7OqmLVlFX3hnKgKkJB2JcDc6yCzROW32oeOA=
X-Received: by 2002:aa7:d886:0:b0:4a2:3637:568 with SMTP id
 u6-20020aa7d886000000b004a236370568mr1867928edq.83.1675342292299; Thu, 02 Feb
 2023 04:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com> <20230202110058.130695-10-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230202110058.130695-10-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 2 Feb 2023 13:51:20 +0100
Message-ID: <CAJ8uoz2+4+wUFYF1GjF51DFBV8ZsBRtTEVWpu_2fBmFUEQzOLQ@mail.gmail.com>
Subject: Re: [PATCH 09/33] xsk: xsk_buff_pool add callback for dma_sync
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 at 12:05, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Use callback to implement dma sync to simplify subsequent support for
> virtio dma sync.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  include/net/xsk_buff_pool.h |  6 ++++++
>  net/xdp/xsk_buff_pool.c     | 24 ++++++++++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..53b681120354 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -75,6 +75,12 @@ struct xsk_buff_pool {
>         u32 chunk_size;
>         u32 chunk_shift;
>         u32 frame_len;
> +       void (*dma_sync_for_cpu)(struct device *dev, dma_addr_t addr,
> +                                unsigned long offset, size_t size,
> +                                enum dma_data_direction dir);
> +       void (*dma_sync_for_device)(struct device *dev, dma_addr_t addr,
> +                                   unsigned long offset, size_t size,
> +                                   enum dma_data_direction dir);

If we put these two pointers here, the number of cache lines required
in the data path for this struct will be increased from 2 to 3 which
will likely affect performance negatively. These sync operations are
also not used on most systems. So how about we put them in the first
section of this struct labeled "Members only used in the control path
first." instead. There is a 26-byte hole at the end of it that can be
used.

>         u8 cached_need_wakeup;
>         bool uses_need_wakeup;
>         bool dma_need_sync;
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index ed6c71826d31..78e325e195fa 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -403,6 +403,20 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
>         return 0;
>  }
>
> +static void dma_sync_for_cpu(struct device *dev, dma_addr_t addr,
> +                            unsigned long offset, size_t size,
> +                            enum dma_data_direction dir)
> +{
> +       dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
> +}
> +
> +static void dma_sync_for_device(struct device *dev, dma_addr_t addr,
> +                               unsigned long offset, size_t size,
> +                               enum dma_data_direction dir)
> +{
> +       dma_sync_single_range_for_device(dev, addr, offset, size, dir);
> +}
> +
>  int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>                unsigned long attrs, struct page **pages, u32 nr_pages)
>  {
> @@ -421,6 +435,9 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>                 return 0;
>         }
>
> +       pool->dma_sync_for_cpu = dma_sync_for_cpu;
> +       pool->dma_sync_for_device = dma_sync_for_device;
> +
>         dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
>         if (!dma_map)
>                 return -ENOMEM;
> @@ -667,15 +684,14 @@ EXPORT_SYMBOL(xp_raw_get_dma);
>
>  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
>  {
> -       dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
> -                                     xskb->pool->frame_len, DMA_BIDIRECTIONAL);
> +       xskb->pool->dma_sync_for_cpu(xskb->pool->dev, xskb->dma, 0,
> +                                    xskb->pool->frame_len, DMA_BIDIRECTIONAL);
>  }
>  EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
>
>  void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
>                                  size_t size)
>  {
> -       dma_sync_single_range_for_device(pool->dev, dma, 0,
> -                                        size, DMA_BIDIRECTIONAL);
> +       pool->dma_sync_for_device(pool->dev, dma, 0, size, DMA_BIDIRECTIONAL);
>  }
>  EXPORT_SYMBOL(xp_dma_sync_for_device_slow);
> --
> 2.32.0.3.g01195cf9f
>
