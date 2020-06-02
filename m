Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617621EBB87
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBMV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 08:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgFBMV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 08:21:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6952C061A0E;
        Tue,  2 Jun 2020 05:21:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j10so3178182wrw.8;
        Tue, 02 Jun 2020 05:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zVkoeEucMeIB6OH4Qmi1bhGaxhtXTko9euXWTEwxvl0=;
        b=XscHkRVto8JiXm+09mevclIQBPj9mO0eUQeqbr2EOFQD1wBZuQYDPTkHMsUKzYllY+
         8JG0gu+OEHHme4sIVkhkWKa+urWzI9Jcg3CxzaveH+UiFR04e6s9ZAN3f2sT0ozr0c77
         ld4LKdO1cXAiEBh+wECRRew7L3xF+wxpUHG9A7seynd8pLlVkCbwLd0UYMXbIL2stsFb
         ZSSiqtc9Ad+wuX9HxwIAN2MIeVmZxAiDNby1VtwQYkC+zVQWJoHypm4KkaJmtanm95+a
         eRpHR4FGVBZtPD7GeoQihdrtESR6ERYVQIA/NjvYqnJrDY/phmdjWJG8iHWPpHhJ+Xvf
         BQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zVkoeEucMeIB6OH4Qmi1bhGaxhtXTko9euXWTEwxvl0=;
        b=SxLxVpg2OzbaVfrGU43NszrDCymt1CQ6FYNPGoNlqiSDMItiyKEACOkTcuYMGwx1uC
         5s73csQ539pGLZ/9vp3qyvc9MVA8PbNgstUG/lkz41NpAWgdJv/RuBlkz+J8muOZEiLZ
         4yBPwDx1YlAop3v3mxsjkI1DdivfKHGSFZ+kFXhayX6pDrv5Vm6nytN2FqFzkuezSd2G
         NqIOKKaWc63+UawxPajilnRncYjW+jvP8LQ0fr+oRVnTat+B5R88mUX1jat1OZzBVx1+
         yD8DxRloR3xS/zPhadPPM/iLjiYRongk/lz5lQ6YWtrMlDXj2VGjwbG/B4H+zd9xHhab
         /zkA==
X-Gm-Message-State: AOAM531Vnzu/5OripWcBWGw90J228EiSbS0dpUqUcKrx5KcTIWBbD/GT
        yUIv7p+IL2Mro7IS8btaN1fOs7+8gweGMytCyYA93YsTYnw=
X-Google-Smtp-Source: ABdhPJysJTB7g4BRZDYt/1PUgTUC9O1tUv0IHmEXYc46vBbqJHejZsDndVIn+FSCxZYfOZRCtR1fxnUlrpUMR1Godn0=
X-Received: by 2002:adf:edc8:: with SMTP id v8mr25154696wro.176.1591100514661;
 Tue, 02 Jun 2020 05:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <1591099973-3091-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1591099973-3091-1-git-send-email-lirongqing@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 2 Jun 2020 14:21:42 +0200
Message-ID: <CAJ+HfNgOoFecFbA3p7QM=bFwuV1k6895w57yH4EWFtSPNZ_wQg@mail.gmail.com>
Subject: Re: [PATCH][v2] i40e: fix wrong index in i40e_xsk_umem_dma_map
To:     Li RongQing <lirongqing@baidu.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 at 14:13, Li RongQing <lirongqing@baidu.com> wrote:
>
> The dma should be unmapped in rollback path from
> umem->pages[0].dma till umem->pages[i-1].dma which
> is last dma map address
>
> Fixes: 0a714186d3c0 "(i40e: add AF_XDP zero-copy Rx support)"
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1: add description
>

Thanks! I think this should be queued for -stable.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


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
