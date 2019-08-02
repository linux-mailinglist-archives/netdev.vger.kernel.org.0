Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20E57FB73
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436542AbfHBNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:46:57 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43411 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbfHBNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 09:46:56 -0400
Received: by mail-yb1-f195.google.com with SMTP id y123so23849474yby.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 06:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=87nWth1qwkhZ1eXAHRwTJ+WjegXhw+N8PNzvPKErqiI=;
        b=mCk6lApFIOYFCE3bZlJdfRIULk2LdKeUPxWmUybHzo0Yaxeyj+CpyB+J/wuFoVrWSF
         gzGYdcnNrMDeTW8ONpOP30VbBDbMbNXAPePMk1DVPPjNrHDPGHEfKSpba6h/3gFnh7gm
         B3C390NPInuszW/nW11OokHsjQwZRedE4pDrAUS7uJbLdEHqwn4S7jYgeuUrH0l7SV5K
         elRfwudymEVNzdFUD6Kh6NUXNbC37Hs1QM67ptqkbvATaEUz4MHpZ+pE7GCu+MoJgFrU
         qGQVBNSIaEi1LCi+GpoQ5uIrukfNuDGhy0bILWVeYFDvnUXTGr5Ar4u0xt9avya5677U
         qaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=87nWth1qwkhZ1eXAHRwTJ+WjegXhw+N8PNzvPKErqiI=;
        b=PVP710cK+S/WYlL3UzGB0DuFh1fpx2ZXxwU44BP4S/00DlViJQTqV+onu6ehK19pCt
         QfpGm3lQdKbJG+C8pdfTYKY//peLa6OkiJJ1AjOJ6i9CZ8EIkoO4Dnry6PvvDhO8CVXz
         IduWrri6hUzUmPaDzkqKMdUBn+bwv0ldinGn0/H2oUBhffeB2x6B5GoJ94hzwMoenuvs
         Q8jTDubWkMszPI6Rv3EROWXaHJa8hU4cdZgAutCoiHfWDpY6aYk4M2Xko0KZCwe2T5j3
         uYJcTHaM5d1cSw7ZwKnwWcigTRgpH4NSukAEVq6BndxAMdTExYS//a8hsUB66UkuW1kD
         lxqQ==
X-Gm-Message-State: APjAAAWKXR1ZksxKrvOgd4JrvI1SC9YU9GIS/VovYG5175PflnM0k+uC
        xQBeAv+KNq87KUg2KiNodfMeA3ID
X-Google-Smtp-Source: APXvYqwmy5Y5cOoW4VSEIutelQitIsxZBd7dEZQvHbq/BW99Mi8OTGSt0vVDdgTow5ty5sY12TQJ7A==
X-Received: by 2002:a25:6541:: with SMTP id z62mr85435754ybb.304.1564753614595;
        Fri, 02 Aug 2019 06:46:54 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id x195sm17798712ywx.57.2019.08.02.06.46.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 06:46:53 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id g19so26633344ywe.2
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 06:46:53 -0700 (PDT)
X-Received: by 2002:a81:4d86:: with SMTP id a128mr79663944ywb.291.1564753613185;
 Fri, 02 Aug 2019 06:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190802105507.16650-1-hslester96@gmail.com>
In-Reply-To: <20190802105507.16650-1-hslester96@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 2 Aug 2019 09:46:17 -0400
X-Gmail-Original-Message-ID: <CA+FuTScLs-qJApj5Yw9OOjVk4++HSjn__Vdy+xX2V1rpWU8uLg@mail.gmail.com>
Message-ID: <CA+FuTScLs-qJApj5Yw9OOjVk4++HSjn__Vdy+xX2V1rpWU8uLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ixgbe: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 6:55 AM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
>
> Also convert refcount from 0-based to 1-based.
>
> This patch depends on PATCH 1/2.
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 6 +++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> index 00710f43cfd2..d313d00065cd 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> @@ -773,7 +773,7 @@ int ixgbe_setup_fcoe_ddp_resources(struct ixgbe_adapter *adapter)
>
>         fcoe->extra_ddp_buffer = buffer;
>         fcoe->extra_ddp_buffer_dma = dma;
> -       atomic_set(&fcoe->refcnt, 0);
> +       refcount_set(&fcoe->refcnt, 1);

Same point as in the cxgb4 driver patch: how can you just change the
initial value without modifying the condition for release?

This is not a suggestion to resubmit all these changes again with a
change to the release condition.
