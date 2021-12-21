Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1C847BB27
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbhLUHdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbhLUHdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:33:51 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97B9C061574;
        Mon, 20 Dec 2021 23:33:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso2400018pjl.3;
        Mon, 20 Dec 2021 23:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KL+wssAsk0qApWBrmAkdmgwqHgyjxMNuRJTdQ6T4cWY=;
        b=JcOXkGKefK7vBwjt/2rz2Uk8EM2U7Hpa2obhLc8lkwbKDdm/hlzx88U8GpfSvT3i3H
         p9d2smdQiRO0/dxHFIXs3lU4rdrM9rw6Im07R6s5dMmN7rjgb8hRdVleV2roIONO6sHj
         iWG3l4GtcjYG1gV930ycz1w7Qg4RUYgXbNNUk8jTBSgDyDY8/pONxJSekeCc3TDxwmi6
         DUYkIxFrvkcxEGDWN0PfO5n2PY+GskLrisLW2F9jIfNJVu/P8y6cQ9ACVmaI6T0EImoI
         nkA4M4zFKChzx6g+fga10cg7wLN6BfnNTtUyzwe6AJpltJGM1tSURnlLZBZ3KEOcUVmz
         a1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KL+wssAsk0qApWBrmAkdmgwqHgyjxMNuRJTdQ6T4cWY=;
        b=a70n2YkgnQySEBd5/H9xkHcp+6vJ6u6cwrzPuiFQkGCLHq/YUdSvzuczI2HB3OzVtA
         lnkYkPaAN8wRoegINvhqaVP4Nv5TCi/Mc1RbaGytOKyLjddgDFrJmaq5Q5Q8YUWqEWkn
         L9sxLGJRx25HrUwFBp2vaz0OQ+92F1U6hnOUGq7VbUYxSHyCpRPZ015obyMsNHOPBFiA
         WoXGWTrj6NlzCOKl0jvFrSTQs4yrfB+FlGWdX+GAajdW6ImBjKeFQcCUfpD1t/G1urZs
         hc9uFRIlFDUKy0W9sPcgVT1EekjtSAOZOLxunT0B2Sl2YIwnCWBKh5CGx6G3ZlvNpEtN
         mfgQ==
X-Gm-Message-State: AOAM531Hw2lZLUoAXLzjfrInZLzrZTDa2+IMSIoulYzWNt2g0TGYV9uo
        AxC0Qoe5iLnaWalWMamIspTPMpGeQ1EumzqNRfQ=
X-Google-Smtp-Source: ABdhPJyMgpcg7l5+ejiOYIUYWrT5TV0aobcoIFdIEMnJVikeMFTTuswkWnMtOLMTdXm1LB8j9Z2ssRlACAu6L4USkN0=
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr2657309pjb.132.1640072031192;
 Mon, 20 Dec 2021 23:33:51 -0800 (PST)
MIME-Version: 1.0
References: <20211220155250.2746-1-ciara.loftus@intel.com>
In-Reply-To: <20211220155250.2746-1-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Dec 2021 08:33:40 +0100
Message-ID: <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 9:10 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> This commit initialises the xskb's free_list_node when the xskb is
> allocated. This prevents a potential false negative returned from a call
> to list_empty for that node, such as the one introduced in commit
> 199d983bc015 ("xsk: Fix crash on double free in buffer pool")
>
> In my environment this issue caused packets to not be received by
> the xdpsock application if the traffic was running prior to application
> launch. This happened when the first batch of packets failed the xskmap
> lookup and XDP_PASS was returned from the bpf program. This action is
> handled in the i40e zc driver (and others) by allocating an skbuff,
> freeing the xdp_buff and adding the associated xskb to the
> xsk_buff_pool's free_list if it hadn't been added already. Without this
> fix, the xskb is not added to the free_list because the check to determine
> if it was added already returns an invalid positive result. Later, this
> caused allocation errors in the driver and the failure to receive packets.

Thank you for this fix Ciara! Though I do think the Fixes tag should
be the one above: 199d983bc015 ("xsk: Fix crash on double free in
buffer pool"). Before that commit, there was no test for an empty list
in the xp_free path. The entry was unconditionally put on the list and
"initialized" in that way, so that code will work without this patch.
What do you think?

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  net/xdp/xsk_buff_pool.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index bc4ad48ea4f0..fd39bb660ebc 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -83,6 +83,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>                 xskb = &pool->heads[i];
>                 xskb->pool = pool;
>                 xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
> +               INIT_LIST_HEAD(&xskb->free_list_node);
>                 if (pool->unaligned)
>                         pool->free_heads[i] = xskb;
>                 else
> --
> 2.17.1
>
