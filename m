Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B139F4A3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhFHLKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:10:31 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:38536 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhFHLKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 07:10:31 -0400
Received: by mail-pg1-f169.google.com with SMTP id 6so16221740pgk.5;
        Tue, 08 Jun 2021 04:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJVsqI/ei0WczshYuB8pLAQsFgqQWwx9v5zxVqgopwU=;
        b=B9ab52pbsKXDXa+qRWwLhBk1hn1Q5Y5Epsog2G5yDfhkg5IOo9jKJ2yFIQFwMAzGud
         AcSRIaZ8KgYDCs+rim+4y/6lRxahUee70hAve0OSKrKrsbZZQij7nBPhyvvDc1HBnS6M
         ngcCKuustZvvUxVhpJYky5CuYcYU4kUvomXBT9SOle0uV5+XZoXfXEQH4t9GhG2hbRS3
         Bj3KqAasLfgPV7LJBkffZQB5uBR+wC3S/r/+wrwD79PoJZgN9ov0Q6SlyNIkVznJzrKx
         VikGD3Fo8rv+94mK8O47KXO6kqFcS+lnDOMXrGGMWVpyB8mztLWH4TukVO7Hh8ZWKPf7
         eXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJVsqI/ei0WczshYuB8pLAQsFgqQWwx9v5zxVqgopwU=;
        b=HUw/8bMBXZJWaXcNHSSIyXEuYo/qLlqkRjSN8CkC3ubQghE3vC4uUWXyVwGZifr5cm
         ahaFWnspBd2vVz0f5drpl66DzAHG5/k9b+IMVwHH7DNQiL8cujP82FXIGlpwDEgPOAnz
         LMP/6R5XN/+kY/uV2I90NZ1qW3atNWCoPm8MonRjavOOEf02cboymmmDEP+IFlQFZLfO
         xq8Je1PEjPiXKyi8qEuqviWy3gVd0B02vblaz7G42Fx4M1rfX2KYudXykmSlylKCqWtl
         L4tpJtE5QAzUCa61IehC6CmidqXy6Iu+MZTZvhXMWybSPZ/4UD/afsInNKVFxjRsQpW4
         o5sA==
X-Gm-Message-State: AOAM530W1bgvsqoODc/Ux9gqtu7bakhW4b9dM6g6mWokEOqn6cNYcoj9
        Apr3jDSC3hCUo58fI5Vq1yuX9A1aCqOpkyxjMwU=
X-Google-Smtp-Source: ABdhPJxjGu8PU0C2DW8HKf2a2BcxewJ3P/4FVJ4FKwCahJzQrzq27XcDUuxYrsnQ3WmcxDTGCfmmKI5172RPm/6SJlM=
X-Received: by 2002:a63:4e4f:: with SMTP id o15mr22260611pgl.208.1623150442052;
 Tue, 08 Jun 2021 04:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210607122644.59021-1-wanghai38@huawei.com>
In-Reply-To: <20210607122644.59021-1-wanghai38@huawei.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 8 Jun 2021 13:07:11 +0200
Message-ID: <CAJ8uoz2mfCGNmEaAhGZAaSs=Mrer008f3+C7MdoAySsLn=busw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe, xsk: clean up the resources
 in ixgbe_xsk_pool_enable error path
To:     Wang Hai <wanghai38@huawei.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        jan.sokolowski@intel.com,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 2:17 PM Wang Hai <wanghai38@huawei.com> wrote:
>
> In ixgbe_xsk_pool_enable(), if ixgbe_xsk_wakeup() fails,
> We should restore the previous state and clean up the
> resources. Add the missing clear af_xdp_zc_qps and unmap dma
> to fix this bug.
>
> Fixes: d49e286d354e ("ixgbe: add tracking of AF_XDP zero-copy state for each queue pair")
> Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for AF_XDP")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Thanks Wang.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index 91ad5b902673..d912f14d2ba4 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -52,8 +52,11 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
>
>                 /* Kick start the NAPI context so that receiving will start */
>                 err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
> -               if (err)
> +               if (err) {
> +                       clear_bit(qid, adapter->af_xdp_zc_qps);
> +                       xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
>                         return err;
> +               }
>         }
>
>         return 0;
> --
> 2.17.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
