Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F34300A8F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbhAVSA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbhAVRy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:54:58 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544D6C061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:54:18 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d81so12831745iof.3
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=en0pKUDdVrjCdZfapa198SUX27NqVVu0iZ8HtPzzk/Y=;
        b=pXK8O8ZLUptUgimH8Q88ZdsOAsdemWPfaK3PDmnWIMfx72UZbtRcuwBh2slDxzyDgq
         SoDlXuz5rqlhxESo+oWmRy4oV//b7Z3UpKmOZAnyKACooXv2Kw92EYdLbgr4AmJX4Kcx
         l2M82iaZJ6wZxrLg1dxe/EhFcNKDtzKb1/GQbwaKLutMFpIz6koHbXD4glAy1LTor659
         2CtJqAXImkWQpehbYOTv/qlCiS+EN7iTG+KOkC76IpqYjbUxDwzZ505echJYHhPEPd0s
         RIjDCPnUGD50psnfH8IeqjhlEjZ9IA0W4fhyEpRYAKzTqaVlez+G75CDWde2jJbNXv+a
         ATUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=en0pKUDdVrjCdZfapa198SUX27NqVVu0iZ8HtPzzk/Y=;
        b=tfFe0YIasGLDhtZ5jXgIukZbgnbgIWKzjyKhWNqebOhINcZrlIvn9TRlxUky31M8Gh
         k2PB3jBKMMcPeyVHnGMNzROqdSnLWDDcBMpOuCpV331Ew6xd/WvO5kbr+6GuiUxbTD8X
         Ivv/vAl7IeqKFaUHqe8NTIxq1TBEaEXCV0SzdJLLqVtLQKVpYGQOPw3vENmKN7wg+Q1X
         W5IowrpZ3/Mrlfk23LgskSkSOUPwnuySAETPKD/wdG4ZxAwV5wh7kkAnv6dPQ4zTcUBC
         cK399GcQMzEpI1upv/NkxY5AukfGQgaUUEFrgJrNQXidS9CXa0CQlgVzt5vTv/RaCi+g
         rImw==
X-Gm-Message-State: AOAM532Ha8qdQto0fIbnwoKG5TWbNcRc0k68e6MSMB8ZhoQznfgEW+2S
        4nfY0xtLGl2vMx18qj2vVUQDiBGFfbabhBFthh8=
X-Google-Smtp-Source: ABdhPJyErizpSLTVDb3WVf3ROd1EhRz1fDFKJeYebB7dS8QpmS5oVknkL7R3SwMUqaWc81/ZrUGZXbnHY3QsGe0jInY=
X-Received: by 2002:a92:cf04:: with SMTP id c4mr1706787ilo.237.1611338057641;
 Fri, 22 Jan 2021 09:54:17 -0800 (PST)
MIME-Version: 1.0
References: <1611322105-30688-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1611322105-30688-1-git-send-email-wangyunjian@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 22 Jan 2021 09:54:06 -0800
Message-ID: <CAKgT0UcpQpGLCdRbaEzyb4Q4gC9gmefg4bMFcgrQoRwy6UJvrQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net v2] ixgbe: add NULL pointer check
 before calling xdp_rxq_info_reg
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        jerry.lilijun@huawei.com, xudingke@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 5:29 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> The rx_ring->q_vector could be NULL, so it needs to be checked before
> calling xdp_rxq_info_reg.
>
> Fixes: b02e5a0ebb172 ("xsk: Propagate napi_id to XDP socket Rx path")
> Addresses-Coverity: ("Dereference after null check")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

This is kind of a big escape for the driver. From what I can tell it
looks like the "ethtool -t" test now causes a NULL pointer
dereference.

As far as the patch itself it looks good to me. This should probably
be pushed for any of the other Intel drivers that follow a similar
model as I suspect they were exhibit the same symptom with "ethtool
-t" triggering a NULL pointer dereference.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
> v2:
>   * fix commit log
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 6cbbe09ce8a0..7b76b3f448f7 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6586,8 +6586,9 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
>         rx_ring->next_to_use = 0;
>
>         /* XDP RX-queue info */
> -       if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
> -                            rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
> +       if (rx_ring->q_vector && xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
> +                                                 rx_ring->queue_index,
> +                                                 rx_ring->q_vector->napi.napi_id) < 0)
>                 goto err;
>
>         rx_ring->xdp_prog = adapter->xdp_prog;
> --
> 2.23.0
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
