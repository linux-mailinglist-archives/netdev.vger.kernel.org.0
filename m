Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F312365559
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhDTJ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhDTJ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:29:25 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA17C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:28:54 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id r186so10536797oif.8
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3thFeITcIJvzSD+xHbfHxl5U6AbwqUp3lXkWHOz3Urs=;
        b=MfP5cYtBEyVdE7J+WdC4UDem8NwKwW25lR6cg0g5gnYezBHMT1kDAUd6OfAAz8WiQC
         V4r1uJ3ZUZFwG5nTWkQxr/Zr5ePz4BQN+zrNOZPnzv7DQ+fo+d8VvpRwqxxmGHqaNrsm
         067zDijbHWN9rh9PHZ58bo8uIBsL8I9qYx3XWzt9UUyFdHvHgYbP9PqPbZpUQH/FA6UG
         jwxevU7HLHxQMm/U6Q6dKsbo2Uc6m8NKBR0PZp9zjuiS53wjNgH9COKSSbaLxGLLKcfY
         PpgSBRQejcwJmIwKyEdeV1qbVu2YS4KifWiEWEF7PJxMFFbRHN83n0BMevii6ybGkrj5
         9+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3thFeITcIJvzSD+xHbfHxl5U6AbwqUp3lXkWHOz3Urs=;
        b=QSutXFde260PUuHhMqnwzuM6wuO4v3gG6iBlNlu2mJQCnJ/Mxtkgw0WTC+ICdtinEV
         G2CGsLjaFzeWLA+Zz0DiM4xlcNtZ/91PFC2fk7gyTnjOFasKo1elEN6IPEsJWFOcRmbj
         m+RkJk+HtJ4jKlPPUmrGsoVfE2HRTGALSRvMSzZ6lgSTS3yLmZgtJKDeUOSqRa7UllmW
         MtEtR/POHwVjOaleiZ7ZwTohYvoe/fu/VkeBocE5E1Npd5g7Oh2nVSywV+oTFGqfYKgV
         TDtcCF9r1fCHm3lzoSsWwDWRo2PHu+5dm8OHwqSiSCtuLnP/VBUAVDnf+Tycq4/S/aEz
         klrA==
X-Gm-Message-State: AOAM5320LvGd+kBJUILPFreVFhJWZ3rEmvqb1y4laLMuwxv3x7P4rs2O
        iyNfquPOZpgsWfrPbjpZ+xxegBMw2v7QY5QEjok=
X-Google-Smtp-Source: ABdhPJy3PdFH4rQ+vAdm4/1mdejGsrDyzwYGdCckGdYN1iGzUghg/WDnMtEfqAAfzbGqZ9pVd+R6PnsuUF3qQEMglfs=
X-Received: by 2002:a05:6808:8c6:: with SMTP id k6mr2326563oij.163.1618910934235;
 Tue, 20 Apr 2021 02:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
 <CAD=hENfAZZBm3iipTAv6q9u12z8WmT7LUgXSDFEdtSf_k9_Lcw@mail.gmail.com> <YH6dCCh5vgWcnzc+@unreal>
In-Reply-To: <YH6dCCh5vgWcnzc+@unreal>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Tue, 20 Apr 2021 17:28:43 +0800
Message-ID: <CAD=hENc45EapYYj1yhyf8wzyUd_9+fbkkJYtN0h0Hefdf+1ykQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field moder.comps
To:     Leon Romanovsky <leon@kernel.org>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        netdev <netdev@vger.kernel.org>, dingxiaoxiong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 5:21 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Apr 20, 2021 at 03:09:03PM +0800, Zhu Yanjun wrote:
> > On Tue, Apr 20, 2021 at 3:01 PM wangyunjian <wangyunjian@huawei.com> wrote:
> > >
> > > From: Yunjian Wang <wangyunjian@huawei.com>
> > >
> > > The 'comps' struct field in 'moder' is not being initialized in
> > > mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
> > > So initialize 'moder' to zero to avoid the issue.
>
> Please state that it is false alarm and this patch doesn't fix anything
> except broken static analyzer tool.
>
> > >
> > > Addresses-Coverity: ("Uninitialized scalar variable")
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > ---
> > > v2: update mlx5e_get_def_tx_moderation() also needs fixing
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > index 5db63b9f3b70..17a817b7e539 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > @@ -4868,7 +4868,7 @@ static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
> > >
> > >  static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
> > >  {
> > > -       struct dim_cq_moder moder;
> >
> > > +       struct dim_cq_moder moder = {};
> >
> > If I remember correctly, some gcc compiler will report errors about this "{}".
>
> Kernel doesn't support such compilers.

Are you sure? Why are you so confirmative?

Zhu Yanjun

>
> Thanks
