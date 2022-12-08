Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED5264772B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLHUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLHUYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:24:03 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B3D21E3B;
        Thu,  8 Dec 2022 12:24:02 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vv4so6735701ejc.2;
        Thu, 08 Dec 2022 12:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vXzR938OUovXCt7bgJhdL3De7hYMb/Y+x0vg/+7HEI=;
        b=QP3aH3jGFDDI23oKUJCA39pAxK035EdzzMwCcrfXTIFFFmJmShY4FMN8HowI1/A5Xy
         fzFspNXemTAwTAAv6VHsVN8Cg/Y+qVX7tbcf732siMcpHBgRO9KFj6pZUTEKKYSc/5GQ
         XNKz5VYfnMMjRIJuHChdUQlP0zE86VO8R6KLl23Rzqzodfo3ESQyXu6p3lZVAPuVjqFX
         3kWvrks4K+NA6Mgl7KL+lUNAFLg1Zw9kUbtCFeTgvr1lbUAAwaQtzzi9yjq+jT0qwROr
         PEwPX+e8ZFmTB321PqbhMeXemNxeDXiovefyuzqrDFkp7K6vcmqImO4FZo94uSYZa0Zy
         PTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vXzR938OUovXCt7bgJhdL3De7hYMb/Y+x0vg/+7HEI=;
        b=dZfI+5oiM3Q+aYA24nHdwPVWjP0I2nYtT7DTgYXlFwZMqjzsuQOLpML4d+ZQw8sEde
         dQ69O3TF582UbKAgl55X4WxneDWfmLzpitLQ9dYJKM0MUIVtvXDbGHDgWqcwq6I71Vm+
         kHz7NwZLqgPbRqfEATZTtPhMmzzEC/gGF2Z7tj2R0ufNX9k6ffPpzlfxZUeQSdlkIwF+
         GQmoeGVQRlp+Ra82hGgEpzlw/48UD8Fn/S4hRj+9C56rrf+cXwUxF8PMbbKFIRDh+wjw
         aa5TQuf6haQPjZaVrWFb0QJNnUBzUtVtaNO07DiRDXIgP98O4Y9DCXhS0cgyHPbl1SWG
         cCGg==
X-Gm-Message-State: ANoB5pk1aCFDMjJck+7lgDFqmnM89JPY2J5WotdvIRigQRuhkPP4aYhv
        fdCIx/Cj81P9IIbG1dbsYUM=
X-Google-Smtp-Source: AA0mqf5r5OQhu8ML9Gxi1fHYml+nmjRexekKMvh+BiSjR6q4Ff9yFPnnUG+/Z1jle1mfCjgYpfwxGQ==
X-Received: by 2002:a17:906:3c03:b0:7c1:9c6:aaa1 with SMTP id h3-20020a1709063c0300b007c109c6aaa1mr9300927ejg.583.1670531040982;
        Thu, 08 Dec 2022 12:24:00 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id b11-20020a0564021f0b00b00461816beef9sm3777768edb.14.2022.12.08.12.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 12:24:00 -0800 (PST)
Message-ID: <71718db2-d302-ab24-940b-c785bc7439d1@gmail.com>
Date:   Thu, 8 Dec 2022 22:23:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v3 08/12] mxl4: Support RX XDP metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-9-sdf@google.com>
 <d97a9bc2-7d78-44e5-b223-16723a11c021@gmail.com>
 <CAKH8qBsuNGu_V+Ww7Ci57J4OrGv=dvGRA=ZEP7RsqLL-SMW29A@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CAKH8qBsuNGu_V+Ww7Ci57J4OrGv=dvGRA=ZEP7RsqLL-SMW29A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 9:07 PM, Stanislav Fomichev wrote:
> On Wed, Dec 7, 2022 at 10:09 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>
>> Typo in title mxl4 -> mlx4.
>> Preferably: net/mlx4_en.
> 
> Oh, I always have to fight with this. Somehow mxl feels more natural
> :-) Thanks for spotting, will use net/mlx4_en instead. (presumably the
> same should be for mlx5?)
> 

For the newer mlx5 driver we use a shorter form, net/mlx5e.

>> On 12/6/2022 4:45 AM, Stanislav Fomichev wrote:
>>> RX timestamp and hash for now. Tested using the prog from the next
>>> patch.
>>>
>>> Also enabling xdp metadata support; don't see why it's disabled,
>>> there is enough headroom..
>>>
>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>> Cc: David Ahern <dsahern@gmail.com>
>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Willem de Bruijn <willemb@google.com>
>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>> Cc: xdp-hints@xdp-project.net
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> ---
>>>    drivers/net/ethernet/mellanox/mlx4/en_clock.c | 13 +++++--
>>>    .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 +++++
>>>    drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 38 ++++++++++++++++++-
>>>    drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  1 +
>>>    include/linux/mlx4/device.h                   |  7 ++++
>>>    5 files changed, 64 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
>>> index 98b5ffb4d729..9e3b76182088 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
>>> @@ -58,9 +58,7 @@ u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
>>>        return hi | lo;
>>>    }
>>>
>>> -void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>>> -                         struct skb_shared_hwtstamps *hwts,
>>> -                         u64 timestamp)
>>> +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp)
>>>    {
>>>        unsigned int seq;
>>>        u64 nsec;
>>> @@ -70,8 +68,15 @@ void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>>>                nsec = timecounter_cyc2time(&mdev->clock, timestamp);
>>>        } while (read_seqretry(&mdev->clock_lock, seq));
>>>
>>> +     return ns_to_ktime(nsec);
>>> +}
>>> +
>>> +void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>>> +                         struct skb_shared_hwtstamps *hwts,
>>> +                         u64 timestamp)
>>> +{
>>>        memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
>>> -     hwts->hwtstamp = ns_to_ktime(nsec);
>>> +     hwts->hwtstamp = mlx4_en_get_hwtstamp(mdev, timestamp);
>>>    }
>>>
>>>    /**
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>>> index 8800d3f1f55c..1cb63746a851 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>>> @@ -2855,6 +2855,11 @@ static const struct net_device_ops mlx4_netdev_ops = {
>>>        .ndo_features_check     = mlx4_en_features_check,
>>>        .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
>>>        .ndo_bpf                = mlx4_xdp,
>>> +
>>> +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
>>> +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
>>> +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
>>> +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
>>>    };
>>>
>>>    static const struct net_device_ops mlx4_netdev_ops_master = {
>>> @@ -2887,6 +2892,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
>>>        .ndo_features_check     = mlx4_en_features_check,
>>>        .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
>>>        .ndo_bpf                = mlx4_xdp,
>>> +
>>> +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
>>> +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
>>> +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
>>> +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
>>>    };
>>>
>>>    struct mlx4_en_bond {
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>>> index 9c114fc723e3..1b8e1b2d8729 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>>> @@ -663,8 +663,40 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>>>
>>>    struct mlx4_xdp_buff {
>>>        struct xdp_buff xdp;
>>> +     struct mlx4_cqe *cqe;
>>> +     struct mlx4_en_dev *mdev;
>>> +     struct mlx4_en_rx_ring *ring;
>>> +     struct net_device *dev;
>>>    };
>>>
>>> +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
>>> +{
>>> +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     return _ctx->ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL;
>>> +}
>>> +
>>> +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx)
>>> +{
>>> +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     return mlx4_en_get_hwtstamp(_ctx->mdev, mlx4_en_get_cqe_ts(_ctx->cqe));
>>> +}
>>> +
>>> +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx)
>>> +{
>>> +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     return _ctx->dev->features & NETIF_F_RXHASH;
>>> +}
>>> +
>>> +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx)
>>> +{
>>> +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     return be32_to_cpu(_ctx->cqe->immed_rss_invalid);
>>> +}
>>> +
>>>    int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>>>    {
>>>        struct mlx4_en_priv *priv = netdev_priv(dev);
>>> @@ -781,8 +813,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>>>                                                DMA_FROM_DEVICE);
>>>
>>>                        xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
>>> -                                      frags[0].page_offset, length, false);
>>> +                                      frags[0].page_offset, length, true);
>>>                        orig_data = mxbuf.xdp.data;
>>> +                     mxbuf.cqe = cqe;
>>> +                     mxbuf.mdev = priv->mdev;
>>> +                     mxbuf.ring = ring;
>>> +                     mxbuf.dev = dev;
>>>
>>>                        act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>> index e132ff4c82f2..b7c0d4899ad7 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>> @@ -792,6 +792,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
>>>     * Functions for time stamping
>>>     */
>>>    u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe);
>>> +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp);
>>>    void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>>>                            struct skb_shared_hwtstamps *hwts,
>>>                            u64 timestamp);
>>> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
>>> index 6646634a0b9d..d5904da1d490 100644
>>> --- a/include/linux/mlx4/device.h
>>> +++ b/include/linux/mlx4/device.h
>>> @@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
>>>        /* The first 128 UARs are used for EQ doorbells */
>>>        return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
>>>    }
>>> +
>>> +struct xdp_md;
>>> +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
>>> +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx);
>>> +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx);
>>> +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx);
>>> +
>>
>> These are ethernet only functions, not known to the mlx4 core driver.
>> Please move to mlx4_en.h, and use mlx4_en_xdp_*() prefix.
> 
> For sure, thanks for the review!
> 
>>>    #endif /* MLX4_DEVICE_H */
