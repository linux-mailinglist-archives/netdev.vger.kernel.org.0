Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9099C2FE661
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbhAUJan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbhAUJCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:02:09 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFF7C061575
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:01:28 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id d13so2571622ioy.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zeLBO6WSHo5WuPaxi95ggZYeJtwjuVIwGw0oEtDg4vg=;
        b=tRPIEcsUyMJwE3z+9QDmQqKK0BCtxLsGwvoAI6FzC2fLG79uG5J9NePCSGEK6FRgcW
         MxdjmpLTTa1CKaqnMMTXMDYzBqvdQPgMAxR7JVTdnGbR2ieWCuOD5UvJS1dYyKkSTo03
         wXqSdVbTQH9RkvG/HrWjRwbYQQaTgbtEX2D6dWFrSUra/x9hQYA8FcTUMFwroyU9vtOR
         in0EZdOy7Frjd8pCbVKKG/Ze9BZ6V26QixZ3jU67lS/bGar9P2VFVXks33PaQPcO0Gzw
         5wo+8FDffQSp8P9J/Cx+3uK/lLnbn1cBy8iyxArqa98UOOSYcnmvTArTNEDaqwZiELjl
         JgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zeLBO6WSHo5WuPaxi95ggZYeJtwjuVIwGw0oEtDg4vg=;
        b=uE/YrtD2PGLAwXOASYwyZBonWFDY6O/gooi4vDMO6iCdKHBNEf8w8Vz2GECKyjOzR/
         u0mgd+AcBxriTZLogXuymtW3LtSQV/94nRcsFReHq9L2V5zLu4g1R81uluipAcHjPcs6
         b0X2+drp89Qcz+cgkxmcEOYBI1AY4W2l8leaf+ucApsxVsbYHaxH0ekC6P+BocJX+MSg
         el5Zk8NkhqE6gK7iIL74HdPn0Wi3Nli4pF/NSg78wyJGtCBf6iydx5LUMpMBWQyN/exq
         l17DvsilofHzc6mMGbUB7Ihupad7GpjO5sQ6emYA3GVrNjFx2FvM8+Jfm7ziCXlJq+Li
         GnrA==
X-Gm-Message-State: AOAM530dsxbeEIQeXCGrYzCh8JyFQlzEpUDW33gLxipTTreDGDykBgol
        DgxVp8vDS9/CiEYpEW1YitcWYVBxl27RW+Q84Vs=
X-Google-Smtp-Source: ABdhPJz5wkj4wviRjmTyrm/9knrHk8avmRoujBRCXzj7z+y4QnL4EKpeGy/kDiJFEasxn7TFaGbHA5nfrOBINlWK9SY=
X-Received: by 2002:a05:6e02:934:: with SMTP id o20mr11408385ilt.211.1611219688133;
 Thu, 21 Jan 2021 01:01:28 -0800 (PST)
MIME-Version: 1.0
References: <20210121070906.25380-1-haokexin@gmail.com>
In-Reply-To: <20210121070906.25380-1-haokexin@gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 21 Jan 2021 14:31:16 +0530
Message-ID: <CALHRZup6q_HT2ob9+JkqwxFXjPVzQD7W6gNJF92iQqRVc18Dog@mail.gmail.com>
Subject: Re: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kevin,

Tested at my end and works fine. Thanks for the patch.

Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>

Sundeep

On Thu, Jan 21, 2021 at 12:51 PM Kevin Hao <haokexin@gmail.com> wrote:
>
> The octeontx2 hardware needs the buffer to be 128 byte aligned.
> But in the current implementation of napi_alloc_frag(), it can't
> guarantee the return address is 128 byte aligned even the request size
> is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
>
> Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
> Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index bdfa2e293531..5ddedc3b754d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -488,10 +488,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
>         dma_addr_t iova;
>         u8 *buf;
>
> -       buf = napi_alloc_frag(pool->rbsize);
> +       buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
>         if (unlikely(!buf))
>                 return -ENOMEM;
>
> +       buf = PTR_ALIGN(buf, OTX2_ALIGN);
>         iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
>                                     DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
>         if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> --
> 2.29.2
>
