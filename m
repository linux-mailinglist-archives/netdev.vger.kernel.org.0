Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC63652E2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhDTHJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhDTHJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 03:09:45 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9686BC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 00:09:14 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso20892710otm.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 00:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MtYGhYbPrsDDV2Iif/+Wf1gZZtS4bQJ8n6ZQa22pdE=;
        b=Eg5Vb8yM8iURQMDQ3o87wZ5WdLVlMpwWngBScrrqFKa38WWgmzxpXIz0s9BW8h7X7Q
         G58tTzNsPZc0S8Ip8qaDsj9N3pqp3+6BwxjAMjbWxEFs3d7yG8WctEk0Q3MI6DJMDmvJ
         fA8Th05vPwEqc0fuYGq30B60wHtyC/n97IURvJ3xuARhQxcMeCQWinljTmHpm/3fkTfG
         ooIGnODKdthiJYlTL/wazx49S99aM6mGJ55S8vn2jjtUhKrHk4AhdtSMcpk70+4F/ITY
         xpRAv0CZsHq/ux2KTRX/3vRSVnjVgMsna9KxZ1eaH+DnaD11U3vtxIt84daDqNBfCMjj
         2w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MtYGhYbPrsDDV2Iif/+Wf1gZZtS4bQJ8n6ZQa22pdE=;
        b=hRuDOv7iBpudsEMNETXclOy0nRCRCM602XhBMKS0UHy2HfhnoljJzSeEclA8ZHo1/e
         VWJ5GVZBBnY7oHKOysP9UC7b5kyP1VAY9a5d8vtEHk17eT2CbgOUQwDf2Nkm83rsvyyf
         me4+KeVhR7Ekc0DGLHNPUayWJV5LKLhlegZa6K+oNwI51uaEPx4plAqsim3u4PVUNqpK
         Vp16Tr6W9FmJlrRfpwyzmqrDsjFf/WJ1WEquG8gnqwnepezbtlGv1lxeFmti7ZxAO+Di
         32uSPvtR5FSAxTXh6eSHmmThLFHk4PR9MNtpkiY6Pf9Ppkc/3GeHr/RnqUZyv9is7SyT
         SD4g==
X-Gm-Message-State: AOAM5307+hpwWIwRwLrvV9yMxZdZ1ChLma03C9Af8NxK6NcTJUyYbdmw
        JNUm7sY9lJrp3HfcxLcp1ElazOQlHwYdIyoygIk=
X-Google-Smtp-Source: ABdhPJwUtPct/+hlEhKbF/f3I4ZmMwZsqtOgaSnd94XRQjZcFRww/ecv09VRzsav3oC19Z8h6d+kdjvBgmFTxLnhlPE=
X-Received: by 2002:a9d:28d:: with SMTP id 13mr18093106otl.278.1618902554105;
 Tue, 20 Apr 2021 00:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Tue, 20 Apr 2021 15:09:03 +0800
Message-ID: <CAD=hENfAZZBm3iipTAv6q9u12z8WmT7LUgXSDFEdtSf_k9_Lcw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field moder.comps
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        netdev <netdev@vger.kernel.org>, dingxiaoxiong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 3:01 PM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> The 'comps' struct field in 'moder' is not being initialized in
> mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
> So initialize 'moder' to zero to avoid the issue.
>
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
> v2: update mlx5e_get_def_tx_moderation() also needs fixing
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 5db63b9f3b70..17a817b7e539 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4868,7 +4868,7 @@ static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
>
>  static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
>  {
> -       struct dim_cq_moder moder;

> +       struct dim_cq_moder moder = {};

If I remember correctly, some gcc compiler will report errors about this "{}".

Zhu Yanjun

>
>         moder.cq_period_mode = cq_period_mode;
>         moder.pkts = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_PKTS;
> @@ -4881,7 +4881,7 @@ static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
>
>  static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
>  {
> -       struct dim_cq_moder moder;
> +       struct dim_cq_moder moder = {};
>
>         moder.cq_period_mode = cq_period_mode;
>         moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
> --
> 2.23.0
>
