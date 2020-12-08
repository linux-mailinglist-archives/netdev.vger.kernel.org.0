Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569DE2D306C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgLHRA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgLHRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 12:00:56 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AEFC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 09:00:12 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ce23so21792146ejb.8
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 09:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCXU1EZEtOO7iYIk2OjCuIxcl89xOmIC4+0USBu4TuI=;
        b=Zb7ZG/hqBfgN0QuFE3o+CD/i8q4F2cECvmxQVTjc4DRKpfXkPg9PBEUR7PsQrW64F7
         5Gi8f9hi6qePuzJL8QN9/vQ+iIqz+PWNMALz+O4QMuFszMrqvQ9m1xeOHvtm1ZcCiRak
         HsC5fBkJhL+ZHTJbUnEnuKHPSkdx8xMEu4SIaKJrWWxaQK3OYKkyRuHe3gvgxkq1pMfG
         3I5FxufL0EXtbuBNP/efCUyFgfqyz9GwhBqajb4HCMfgGVnajBBvKFjUUH0vwGRCBIpw
         GMcGPVgb4O5+mXjsUStmBFLuv/m3/OrqeLDX9n9MyYamI23RqufNMDh3EpHpbHlAfqke
         lC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCXU1EZEtOO7iYIk2OjCuIxcl89xOmIC4+0USBu4TuI=;
        b=IXGebXI/MExDOlDIraHhf3efJ46gpiQUN4HClne47A00o/+5kqf/uZML65WB4qpHgL
         MZ5tyhIF8+d5yCuBA/5eViYHM+wYDo/g87HIZCSAQ6WDhsytOu7CDeJaexD/TpTuurGJ
         9nAs5E1PQWZv6UfN/lC7Jdwto9NUukKLwAZpcSpBBGDJN+OVKF3roE6BH6PHhFklo/EN
         yQ9PtrUv6Pu9b5EfHmkNIRDpOC3DmEh6PS9eTelz12oNfUVpJwOdA8Xe70wSith/RZO0
         kj7i7+Zyzkr3QKn84JBcHd0cabYefYTK6T9mFMdbriSFFzhxJazT3cqfmuZGAH2gLTtS
         eeQg==
X-Gm-Message-State: AOAM531ND7+kfsPZZO2l5ZO0msp0SoEfw/DUt0w5eBsGKb7zKSDEeHcl
        ySeDhdjEz5jvrDPw2uBXrbuKUep31LM7Vgkb/GgYgA==
X-Google-Smtp-Source: ABdhPJx7Lkeu6dtyqRm6AY0hjAqvGI/1iXFouIvsad/63I1MPNfnni1R1luYOXTba1Fb6GsyOU/5D1VfppHMGCQuXSo=
X-Received: by 2002:a17:906:e94c:: with SMTP id jw12mr24259158ejb.56.1607446810993;
 Tue, 08 Dec 2020 09:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20201207224526.95773-1-awogbemila@google.com> <CAKgT0UeRdj4ek=3OZQSHLT8NNH04k+ziK_3LVtBpr4T8k=+U9w@mail.gmail.com>
In-Reply-To: <CAKgT0UeRdj4ek=3OZQSHLT8NNH04k+ziK_3LVtBpr4T8k=+U9w@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 8 Dec 2020 09:00:00 -0800
Message-ID: <CAL9ddJc0CbXrSz5ymt_Bp5v47oYKwD+QFqTymeLg5ywi8ts9Xw@mail.gmail.com>
Subject: Re: [PATCH net-next v10 0/4] GVE Raw Addressing
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeed@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 7:17 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Dec 7, 2020 at 2:45 PM David Awogbemila <awogbemila@google.com> wrote:
> >
> > Patchset description:
> > This  patchset introduces "raw addressing" mode to the GVE driver.
> > Previously (in "queue_page_list" or "qpl" mode), the driver would
> > pre-allocate and dma_map buffers to be used on egress and ingress.
> > On egress, it would copy data from the skb provided to the
> > pre-allocated buffers - this was expensive.
> > In raw addressing mode, the driver can avoid this copy and simply
> > dma_map the skb's data so that the NIC can use it.
> > On ingress, the driver passes buffers up to the networking stack and
> > then frees and reallocates buffers when necessary instead of using
> > skb_copy_to_linear_data.
> > Patch 3 separates the page refcount tracking mechanism
> > into a function gve_rx_can_recycle_buffer which uses get_page - this will
> > be changed in a future patch to eliminate the use of get_page in tracking
> > page refcounts.
> >
> > Changes from v9:
> >   Patch 4: Use u64, not u32 for new tx stat counters.
> >
> > Catherine Sullivan (3):
> >   gve: Add support for raw addressing device option
> >   gve: Add support for raw addressing to the rx path
> >   gve: Add support for raw addressing in the tx path
> >
> > David Awogbemila (1):
> >   gve: Rx Buffer Recycling
> >
> >
> >  drivers/net/ethernet/google/gve/gve.h         |  39 +-
> >  drivers/net/ethernet/google/gve/gve_adminq.c  |  89 ++++-
> >  drivers/net/ethernet/google/gve/gve_adminq.h  |  15 +-
> >  drivers/net/ethernet/google/gve/gve_desc.h    |  19 +-
> >  drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
> >  drivers/net/ethernet/google/gve/gve_main.c    |  11 +-
> >  drivers/net/ethernet/google/gve/gve_rx.c      | 364 +++++++++++++-----
> >  drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++--
> >  8 files changed, 574 insertions(+), 162 deletions(-)
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>
> Normally the reviewed-by should be included on the individual patches
> instead of here. It can be moved if you end up needing to resubmit.

Thanks, I'll take note.
