Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7DB79BE
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbfISMua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:50:30 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34745 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389506AbfISMua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:50:30 -0400
Received: by mail-yw1-f68.google.com with SMTP id h73so1186906ywa.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSx7cABvGZFiRI8GmWboDT4XbAPUCI3fmgM7DcCBUds=;
        b=GHNWGgtAn848gWfLuFD/LJ2Oe2erMqYJtAXw82FMUtDTA2SyRQ+6v7MDx1e1CMnPSR
         ss8uAjumrQeNL5cxSHiSwlaES6uSWl4yN5ru0iVxhOHjGTFelPhAKuQyrvpuMCoOQDMf
         GOETEdLWNAJ/caQ9j+DaPfXi2fs5qVEVwQvDO/88bitdgZJrSnskONJQBRlstR6txDnp
         EytNZTBsrtRkGJ14mUSKkIM+/oyGBmMl85wPrXa7vi15mfDkPuXhp2SABjaST0zbUhTK
         8P9Vv+b0F6TBn5qC9x6Mh0H8f8qafJ7Dr41uQPheO7iBt8b8hpq3AfwCKHi7QUllnMAq
         wjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSx7cABvGZFiRI8GmWboDT4XbAPUCI3fmgM7DcCBUds=;
        b=aUrhxBrGpaApSVd9uAygHF193HA2lDZBJpTGP/JaaLWL/6hmkXeYnZPUJgTkOvXT5y
         0NDprv2CYiIEo7x0PvlvCZYB7S6uUbrPFQR9GQx7TwutuFFLMUVlspxHgaWOZfuVIXC6
         8WB01JHBDCcSQI/I6Qyrug2DC6FTcl7V+gFSzvi+QV7pAKdRE+Jvc+AjaRktGCEHYhCB
         EjWg3fX3GGvql8A/mnJF2W9zz7eZk2uKXEHPti5GVktQV3w7txhVfCJVYQBzKvznrAcc
         d9JfUdr4MxXpmeI2UVFEEIV0H/HA4h7a+CGguEszMnwvhCgXyLE/OWBjgvM14W820xWn
         fQYA==
X-Gm-Message-State: APjAAAVVOY9EI6zC61H4yKTWoGLSWq7JZO7ULVc/ppSyNBLk3bJj3Biy
        3g8ri6aSuuZ1+0FZe/HUfgl2LwFyH+hsC9EtCtk=
X-Google-Smtp-Source: APXvYqwFlJ0mrGPB3oz8TXcF8e0uNjQjLHSeKOlnzVmM2Ll1e06Etr071/ZPxzwQc9deeB1u8YTSVA5PrGFsQS7UaZs=
X-Received: by 2002:a81:81c6:: with SMTP id r189mr7903885ywf.147.1568897428917;
 Thu, 19 Sep 2019 05:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 19 Sep 2019 15:50:17 +0300
Message-ID: <CAJ3xEMhQTr=HPsMs-j3_V6XRKHa0Jo7iYVY+R4U8etoEu9R7jw@mail.gmail.com>
Subject: Re: [PATCH net v3] net/sched: cls_api: Fix nooffloaddevcnt counter
 when indr block call success
To:     wenxu@ucloud.cn,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Oz Shlomo <ozsh@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:39 AM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> A vxlan or gretap device offload through indr block methord. If the device

nit: method --> method

> successfully bind with a real hw through indr block call, It also add
> nooffloadcnt counter. This counter will lead the rule add failed in
> fl_hw_replace_filter-->tc_setup_cb_call with skip_sw flags.

wait.. indirect tc callbacks are typically used to do hw offloading
for decap rules (tunnel key unset action) set on SW devices (gretap, vxlan).

However, AFAIK, it's been couple of years since the kernel doesn't support
skip_sw for such rules. Did we enable it again? when? I am somehow
far from the details, so copied some folks..

Or.


>
> In the tc_setup_cb_call will check the nooffloaddevcnt and skip_sw flags
> as following:
> if (block->nooffloaddevcnt && err_stop)
>         return -EOPNOTSUPP;
>
> So with this patch, if the indr block call success, it will not modify
> the nooffloaddevcnt counter.
>
> Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: rebase to the net
>
>  net/sched/cls_api.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 32577c2..c980127 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -607,11 +607,11 @@ static void tc_indr_block_get_and_ing_cmd(struct net_device *dev,
>         tc_indr_block_ing_cmd(dev, block, cb, cb_priv, command);
>  }
>
> -static void tc_indr_block_call(struct tcf_block *block,
> -                              struct net_device *dev,
> -                              struct tcf_block_ext_info *ei,
> -                              enum flow_block_command command,
> -                              struct netlink_ext_ack *extack)
> +static int tc_indr_block_call(struct tcf_block *block,
> +                             struct net_device *dev,
> +                             struct tcf_block_ext_info *ei,
> +                             enum flow_block_command command,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct flow_block_offload bo = {
>                 .command        = command,
> @@ -621,10 +621,15 @@ static void tc_indr_block_call(struct tcf_block *block,
>                 .block_shared   = tcf_block_shared(block),
>                 .extack         = extack,
>         };
> +
>         INIT_LIST_HEAD(&bo.cb_list);
>
>         flow_indr_block_call(dev, &bo, command);
> -       tcf_block_setup(block, &bo);
> +
> +       if (list_empty(&bo.cb_list))
> +               return -EOPNOTSUPP;
> +
> +       return tcf_block_setup(block, &bo);
>  }
>
>  static bool tcf_block_offload_in_use(struct tcf_block *block)
> @@ -681,8 +686,6 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>                 goto no_offload_dev_inc;
>         if (err)
>                 goto err_unlock;
> -
> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>         up_write(&block->cb_lock);
>         return 0;
>
> @@ -691,9 +694,10 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>                 err = -EOPNOTSUPP;
>                 goto err_unlock;
>         }
> +       err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> +       if (err)
> +               block->nooffloaddevcnt++;
>         err = 0;
> -       block->nooffloaddevcnt++;
> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>  err_unlock:
>         up_write(&block->cb_lock);
>         return err;
> @@ -706,8 +710,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
>         int err;
>
>         down_write(&block->cb_lock);
> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> -
>         if (!dev->netdev_ops->ndo_setup_tc)
>                 goto no_offload_dev_dec;
>         err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> @@ -717,7 +719,9 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
>         return;
>
>  no_offload_dev_dec:
> -       WARN_ON(block->nooffloaddevcnt-- == 0);
> +       err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> +       if (err)
> +               WARN_ON(block->nooffloaddevcnt-- == 0);
>         up_write(&block->cb_lock);
>  }
>
> --
> 1.8.3.1
>
