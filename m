Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA5306A87
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhA1Biv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhA1Bhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:37:41 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05412C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:36:59 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id e206so3909937ybh.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/bYkXfmXb8C2rGF7Qsf6Wobm0/Ll/oj6BlMfe82xb6E=;
        b=pZcoPrqQxlmqJ5usLuLOAN0s6P1+f2all9GbH0hJPJbN0rf9uRjjvCLh781dsmHcxm
         U19IQAEyl/FNaUggIHpLPm0942NiwmdUSoDxjgdHvCq5MoYCbSL4A3hdrP0jfi8v4FDo
         e9yvEPn07/mUYytWQQ793Zt5XV/GfkD4+6M+MunZO/QG1Wn5XRz/Vin7Uqg2leL9Bqnz
         CY25tvs/Y75y0A0Q1AVmMabyoM0/7Kto3mMhjmOCeW+T3t70uqt01+F7jj+q+Z7bTgqu
         A53Gno3FQUBex6V1/gi0FEQTP+FA4W+yDMe87Y59FILlKGS2YoKz62no6rNHZnLGrbii
         hM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/bYkXfmXb8C2rGF7Qsf6Wobm0/Ll/oj6BlMfe82xb6E=;
        b=QGPouCYxy1SbxjC69tQ1PodCNR9lhu2t7bJNGPIBn5Fr1iVRq8v/LlgU9kkffBmDfT
         JazQ+67kfICIpIMh0Y43xLTiKtQ8izLYv1VRU4PNaAIUBsz9qfKOnv0YOw/z2VAinHZQ
         ymKJkh2g8b3HmUZ6F3ZP1RtsG/ZeK/ikTuS6/THyWkgxWDnDUAUJ0/S2eHN2oXlM6Z3T
         sR7veq7Ud8/1ZFiRV7FQHmgzZmySef7Z74RhYtZYr/MNCBk0qNQ2KZumFOo1l8H2hdIa
         xesyticYvSq0dC7ROR634Ti6DnHGKdV1piMSydHwBs7UiOGzDSjOO0VyyRVSBR3KZ743
         vKbA==
X-Gm-Message-State: AOAM532G7PbMAhtYd6lqixXQk8LMvLv2vT2jk74WRR8lzK3qAihg/0Xb
        5ikPVcS4VLPxZ8GQgpruZFBakdOsVDUfp6cwFyDszC7aKFE=
X-Google-Smtp-Source: ABdhPJz9v04i+UD4IrDkXOZU7bUCEnOsibHNcj7xiSWCA80V79o8cvenXn4tLhyCpsCQ/pANk/0X6tXggqBck06DNHI=
X-Received: by 2002:a25:1d86:: with SMTP id d128mr2724899ybd.278.1611797818146;
 Wed, 27 Jan 2021 17:36:58 -0800 (PST)
MIME-Version: 1.0
References: <20210126011109.2425966-1-weiwan@google.com> <20210126011109.2425966-3-weiwan@google.com>
 <20210127161238.123840ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127161238.123840ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 27 Jan 2021 17:36:45 -0800
Message-ID: <CAEA6p_Ao7nhrk-jFf43O99zv6j4UkZW3d_wKiN8cmF2GgJRf2g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 2/3] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Jan 2021 17:11:08 -0800 Wei Wang wrote:
> > This patch allows running each napi poll loop inside its own
> > kernel thread.
> > The kthread is created during netif_napi_add() if dev->threaded
> > is set. And threaded mode is enabled in napi_enable(). We will
> > provide a way to set dev->threaded and enable threaded mode
> > without a device up/down in the following patch.
> >
> > Once that threaded mode is enabled and the kthread is
> > started, napi_schedule() will wake-up such thread instead
> > of scheduling the softirq.
> >
> > The threaded poll loop behaves quite likely the net_rx_action,
> > but it does not have to manipulate local irqs and uses
> > an explicit scheduling point based on netdev_budget.
> >
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Wei Wang <weiwan@google.com>
>
> include/linux/netdevice.h:2150: warning: Function parameter or member 'threaded' not described in 'net_device'
>
>
> scripts/kernel-doc -none $files
>
> is your friend - W=1 does not check headers.

Thanks! Will add description for this new field.
