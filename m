Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88E01EBA5A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgFBL1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgFBL1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 07:27:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECBCC061A0E;
        Tue,  2 Jun 2020 04:27:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so3012056wrc.7;
        Tue, 02 Jun 2020 04:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3Fvjz5nBs/wCPZQr4wyZqYWxZlG2zuno0ejPtDD3mqU=;
        b=ctgK7uh3jB8lao2PJrtxn1AgQt7DY3C9KKjwPEMP2Xld3UXepVhpOf/Q62b5pJwWcw
         4xE7xu6YoXVDIR0VkU1CWdx+owZXci96PLl0MKlZhuAAbNmdc/TXme2y7BeqwOMNLbiq
         ErPDweuzXSEIjhHR7n5o8Jy3v8FtfXyrvKvHJ+iAtGHOecUpth6PFG5ISAKf6SmB10D/
         V3q6x8scgl4hWVTb7bGbV+Cu+dgicXXbsaPD+AeJvMrtZcbBloFtnnmYMszHJ1bj5PQA
         RXb2gEnRHyL+h9FNmcL+CJC+wBtUxkQzTcfvGewvjf0Y6xV3fmBS8QlLwQQufrFKI/5C
         IWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3Fvjz5nBs/wCPZQr4wyZqYWxZlG2zuno0ejPtDD3mqU=;
        b=oD6Vd8wgaVxbX96jykTTXQq4g3kxNzNghwh/I3Y3SS9BH69QIsaf7hoyJJV2MwL2tr
         VQ5CGT1jVik2/yc9IlpCY5ysdsEKf7K+SiSOq9nxRYXxlCjpgSogEufpoC7jBneEBC5c
         G7WZwYOoHowqLJipB78Ih1zPBKpJLX6fZ4seObeZBrVMZ0v2bnz10ZqLScAuKY9Wzaeq
         3LFBO9kMmFEuKFF98fpTwWr9h/KzM6W/5DrmLNGZ52lJZ/NC+j02MYywSQlEtDm/YsgT
         0u7TbbScXLIBIPaZlkcoafkPhROi5jG2AQQ7ZDCerG/5Tf2c1n1oULse8W8caOMaGKtQ
         fTaA==
X-Gm-Message-State: AOAM530oUGkWoOal8jwPniISkB/6L9PCYvn/vwUbCn3G79NxnG/9Qnd5
        WIqOSCbvlnV+6k72ZJMOdfX7yiMPZWj/2hgqh5UP2oPW7nc=
X-Google-Smtp-Source: ABdhPJwdEnHroVV2FiwYU0FGgqX8cmpzRgjiDdPOUkntb86drOV2W4P2ZkFWMlv2sB1PM4Gz5YyVYxaBo3cRqMT02Lc=
X-Received: by 2002:adf:e90b:: with SMTP id f11mr25491527wrm.248.1591097226370;
 Tue, 02 Jun 2020 04:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <1591089148-959-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1591089148-959-1-git-send-email-lirongqing@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 2 Jun 2020 13:26:55 +0200
Message-ID: <CAJ+HfNjXh882Dc2N9qpYDGhEuTed9Vp36RuHSXnBMmWXfV9iHg@mail.gmail.com>
Subject: Re: [PATCH] i40e: fix wrong index in i40e_xsk_umem_dma_map
To:     Li RongQing <lirongqing@baidu.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 at 11:20, Li RongQing <lirongqing@baidu.com> wrote:
>

Li, thanks for the patch! Good catch!

Please add a proper description for the patch. The fix should be added
to the stable branches (5.7 and earlier). Note that this code was
recently removed in favor of the new AF_XDP buffer allocation scheme.


Bj=C3=B6rn

> Fixes: 0a714186d3c0 "(i40e: add AF_XDP zero-copy Rx support)"
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index 0b7d29192b2c..c926438118ea 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -37,9 +37,9 @@ static int i40e_xsk_umem_dma_map(struct i40e_vsi *vsi, =
struct xdp_umem *umem)
>
>  out_unmap:
>         for (j =3D 0; j < i; j++) {
> -               dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
> +               dma_unmap_page_attrs(dev, umem->pages[j].dma, PAGE_SIZE,
>                                      DMA_BIDIRECTIONAL, I40E_RX_DMA_ATTR)=
;
> -               umem->pages[i].dma =3D 0;
> +               umem->pages[j].dma =3D 0;
>         }
>
>         return -1;
> --
> 2.16.2
>
