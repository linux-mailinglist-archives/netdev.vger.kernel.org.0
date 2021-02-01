Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D530A7D6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhBAMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhBAMmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:42:11 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F5BC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:41:30 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 16so17172459ioz.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qj3gtsKwB6ap9M2JpuAICku9x3ifzgxPYufNViFQVLM=;
        b=OmVRENI8jA/oUqCZk8fnU5kScJTiNSUMGCNPBkb0GsKQNrmcq6eB3x+zNkcCm0xt0t
         4AVhlb+19ulfQA7wPbog+J3rF08ejWNryPw9j13EWwZCFOq4QuN0EefUKbBV06lrIPta
         C02DKNdKpXHigwldaaObeswnEXhAB2/3VRZTLgkfmL3crgwAIMO5xOa9wU8PvwjNkUGT
         n5pM2yeMYR3xbv8GhOHk8m656PRaXN9jutVd+uqs04pa9lGa5wePOERyKkl3pyNjo0rR
         LBcCuqRCxrQhAk+AFJLYt3FRAbdh3alM421pb9UTNBQKIodBwTU447fWw03yWSrQgaV0
         EonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qj3gtsKwB6ap9M2JpuAICku9x3ifzgxPYufNViFQVLM=;
        b=cALOBybhLAi0ZmGnTrUiPsw+Jhp+Z4SAM0F6Phez32wURZcJKDc03b4lQAkzAwqsoQ
         slj2JfgAo3+JIlIO8MHuEzPDwbUfg3WCVDugPK/PL476B39Nrgj6KJ2wqSbGejWTtXhJ
         kAOArxzmAOYW+a4C/5fp7VOTPzotoiesj/d5Mwd0zPHGCrgi/5aGwHP/0A32Gq6ithOV
         edQr+jRi6sMATET3wMRr12gPxFtEQtwEDFWOIbcxMcncLRXwOkAIdGoxEKaGlPTcWWkq
         cpNbd4uy46HH14K+F6D2DoN/FHb5C6yZzIVQPPEAeZfFXnRgf8GGQk3/XtvRvPZEdGMw
         5msQ==
X-Gm-Message-State: AOAM530tV8lqdYrijr0evRFfdUsK3mDd/C9Y+MSapbUAIfZ1UG6rTKHP
        KdaJX/96hPDO7Ywe2km5zvGsa+fV15Mb9330Dwo=
X-Google-Smtp-Source: ABdhPJwKm9spYH2eJGF720clXit5QH6bJF8YQXKk7FF7Zmf18NkigjYhPHFhnbOQtX4mGgOqWQQDkFUN3KbfiGMdS5A=
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr13918217jaj.87.1612183290368;
 Mon, 01 Feb 2021 04:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20210131074426.44154-1-haokexin@gmail.com> <20210131074426.44154-4-haokexin@gmail.com>
In-Reply-To: <20210131074426.44154-4-haokexin@gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 1 Feb 2021 18:11:19 +0530
Message-ID: <CALHRZuqdEg11kvpbEkX1G-i1OkBX=tSf1eeQmBBQCeBs3mSEqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: octeontx2: Use napi_alloc_frag_align()
 to avoid the memory waste
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>

Thanks,
Sundeep

On Sun, Jan 31, 2021 at 1:49 PM Kevin Hao <haokexin@gmail.com> wrote:
>
> The napi_alloc_frag_align() will guarantee that a correctly align
> buffer address is returned. So use this function to simplify the buffer
> alloc and avoid the unnecessary memory waste.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
> v2: No change.
>
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 5ddedc3b754d..cbd68fa9f1d6 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -488,11 +488,10 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
>         dma_addr_t iova;
>         u8 *buf;
>
> -       buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
> +       buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
>         if (unlikely(!buf))
>                 return -ENOMEM;
>
> -       buf = PTR_ALIGN(buf, OTX2_ALIGN);
>         iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
>                                     DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
>         if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> --
> 2.29.2
>
