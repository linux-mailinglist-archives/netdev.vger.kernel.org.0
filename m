Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208E248ED6F
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbiANPvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiANPvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:51:52 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E7C061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:51:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id j27so3081123pgj.3
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jNaxVdqcvxk4ig8CiPTI/3ybr3pqmqtJQMGQjw9Y0e4=;
        b=Zvo62ixuU8bmNF6Y5DE2DlhCbe5x4+tyC0ye65STw4lO4Ah8L9UYJk+zp8t55vM6ZD
         GN+fwIJz3c7F4cmvcdxjlrZ4S/98M78y1JgqeJ969ySE1bOBR8uC57y1PBg75jrkb6mf
         HjqKBtKe31DVfoQilcoDIJhlboTPE7XsZYlU4uZchLeUHmVZrUB3XJbSG2t6GlMsN3ag
         bLC0ZgPjRtdp6FX3VJpiWiA2jmO6oRS9CKk8KPH0EOn7TgHRjvKEF1RVqLumID/bv7cc
         Ze6zX1RAzbquCMJTFGy4JqtLA7nfdKBKH9eZ3JHJJmmfj7r/G0JrTLuPdLd4Guky8GKK
         VYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jNaxVdqcvxk4ig8CiPTI/3ybr3pqmqtJQMGQjw9Y0e4=;
        b=EuNTfG2UFpGG+seFeLXcCFVZ9sd/m5bNIBsmEDjCgjXmkcDHc3adsiEelukPey9oP2
         EzpCgxUBhbKOd50hB1yHuYnr6WCgao/VGMNrCSv43EDNKnwV6aK2RMYRwO/znQzU+rsY
         UXDFjqC9hi5r0i3bKCnVSCupEzayFMZXrMb68xvkMr62e+2qma8qdPTaOVrX5dpFZKRD
         3MJHH+vK8rhgnbbKPn7rwntlAO1gm8aAPQDLfPGI9EpHBn8r+oqTzoSIYDjihRukKpnB
         kAEz9HTk4lfntB3nHLthVDigfHLKtlMHceBuRHgufPZ+DIWwSHOqnh6XAg6npmBHU6nX
         UR6Q==
X-Gm-Message-State: AOAM531x3YZ1O87zBMyLwlwXwcELqGbbhFv/4DzPyvf2tSaM2YmJQnAl
        EqqAMrwY6vw51Cno7bnMZ6Vg16xcBndTuZZH2v9/JQ==
X-Google-Smtp-Source: ABdhPJzgHZqeEWqDXUo85yK/4TLC9lKPbuYydlH4vKlf0ew0eMz5Gxm3aqldYzdN8gM7ew8yiXzsRhsGiu1QDwCgWUc=
X-Received: by 2002:a63:255:: with SMTP id 82mr8575780pgc.167.1642175510948;
 Fri, 14 Jan 2022 07:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20220114100731.4033-1-slark_xiao@163.com>
In-Reply-To: <20220114100731.4033-1-slark_xiao@163.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 14 Jan 2022 17:03:39 +0100
Message-ID: <CAMZdPi8g2VxBFzS7Lw=TAN_NPQSuzwLuhEGB2akqn-Tjqer7vQ@mail.gmail.com>
Subject: Re: [PATCH] Fix MRU mismatch issue which may lead to data connection lost
To:     Slark Xiao <slark_xiao@163.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shujun Wang <wsj20369@163.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 at 11:07, Slark Xiao <slark_xiao@163.com> wrote:
>
> In pci_generic.c there is a 'mru_default' in struct mhi_pci_dev_info.
> This value shall be used for whole mhi if it's given a value for a specific product.
> But in function mhi_net_rx_refill_work(), it's still using hard code value MHI_DEFAULT_MRU.
> 'mru_default' shall have higher priority than MHI_DEFAULT_MRU.
> And after checking, this change could help fix a data connection lost issue.

Interesting, not sure why it fixes data issues, since the device
should comply with any size.Can you add a Fixes tag then? and add the
correct [PATCH net] suffix in the subject:
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

With that:

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Thanks,
Loic




>
> Signed-off-by: Shujun Wang <wsj20369@163.com>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/net/wwan/mhi_wwan_mbim.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
> index 71bf9b4f769f..6872782e8dd8 100644
> --- a/drivers/net/wwan/mhi_wwan_mbim.c
> +++ b/drivers/net/wwan/mhi_wwan_mbim.c
> @@ -385,13 +385,13 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
>         int err;
>
>         while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
> -               struct sk_buff *skb = alloc_skb(MHI_DEFAULT_MRU, GFP_KERNEL);
> +               struct sk_buff *skb = alloc_skb(mbim->mru, GFP_KERNEL);
>
>                 if (unlikely(!skb))
>                         break;
>
>                 err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb,
> -                                   MHI_DEFAULT_MRU, MHI_EOT);
> +                                   mbim->mru, MHI_EOT);
>                 if (unlikely(err)) {
>                         kfree_skb(skb);
>                         break;
> --
> 2.25.1
>
