Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C36AC73B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCFQFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCFQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:04:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C2E38B76
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:01:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id a2so10906985plm.4
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 08:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678118492;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dbsj51DwbENYvX9N0ISd+tCJwhUTPLkYgmjoQwCZUso=;
        b=cbWIRT6xOk3/hkPWBYp058u7/oMUz/XrB3Poq7QaysAp3J5lRZ1zUrKwqh38TiR5aC
         cyCRJ2ujCioV/lhRhDihioJZcvSrgDTdP+p7qZwaowAXReDFVjBFrS+CRj1460RE6DP7
         SgguH8dFX6Uulj88Iv68eJFu34F8aevOjlNnc/5fmNsEmEJQ7Z6FlBllxQCma7Bl2qdp
         t/grK343CMdnoUMHEHjfdfN+Nz4y5XNNIPlGiqolbbQYqzzxgn/Ibel51glKISy4gRCc
         E3CYDVrrRm0MvaE+cr+tYFZ/LblTBo8efR5P7UUFEaMZ7vIrAsJwV4bJAE4DHP8stKB5
         GJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118492;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dbsj51DwbENYvX9N0ISd+tCJwhUTPLkYgmjoQwCZUso=;
        b=7rf/Oql+HlVcV1ivUEPPK51zy7Csa1x52L9VbILSRrtvf0aYObUJsR1b6tefkl+Odn
         2q8bWy7B7NGnQv2usJCDEJwXD7caGPSWy4y88HdqsjROKQnQVekwJcLH8BJDlfNQHynf
         q0T3OlsfnZaLomoVBYcW89bvmCbA/p83tPIS5+ZxzgYKua/YQ5tETU3gIMv7A5pONCS5
         1c2KFNjAudlhLlwTK+g/b+z6Ov81BkC8UQz1SoaEzR9J8kfH07Us1JN33fKMAS3+q8sn
         zw8TtY+KhIABrXlSHuP+OXXoF15c9X4kgcEBOaNVFcegokvG/u+dcHYx5abaOV7lNV/g
         oSsg==
X-Gm-Message-State: AO0yUKXbbboeGqGMxLkktdyjmZH0d/lRUaBBxSbo2ZDfKGiO4oCuKoUb
        Oevy8VH6kZfo93IwcDIhkTc=
X-Google-Smtp-Source: AK7set+nGcPfNvI5Zv87l23rOiwX9kpu5/jVFbmu3VEJyIfUJFGnEjpq7ybo7SQUGlPcUrfS66pDNg==
X-Received: by 2002:a05:6a20:1e61:b0:cb:a0e3:4598 with SMTP id cy33-20020a056a201e6100b000cba0e34598mr10799724pzb.43.1678118492298;
        Mon, 06 Mar 2023 08:01:32 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id w190-20020a6382c7000000b00502fdc789c5sm6496098pgd.27.2023.03.06.08.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:01:31 -0800 (PST)
Message-ID: <116190ee91ddb97e4498dcb6e58548c5332aaf54.camel@gmail.com>
Subject: Re: [PATCH net v7 2/2] net/ps3_gelic_net: Use dma_mapping_error
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Mon, 06 Mar 2023 08:01:30 -0800
In-Reply-To: <45545484eadcf15a3ef06e35ccf34981cda2e867.1677981671.git.geoff@infradead.org>
References: <cover.1677981671.git.geoff@infradead.org>
         <45545484eadcf15a3ef06e35ccf34981cda2e867.1677981671.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-05 at 02:08 +0000, Geoff Levand wrote:
> The current Gelic Etherenet driver was checking the return value of its
> dma_map_single call, and not using the dma_mapping_error() routine.
>=20
> Fixes runtime problems like these:
>=20
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map erro=
r
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x=
8dc
>=20
> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index b0ebe0e603b4..40261947e0ea 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -323,7 +323,7 @@ static int gelic_card_init_chain(struct gelic_card *c=
ard,
>  				       GELIC_DESCR_SIZE,
>  				       DMA_BIDIRECTIONAL);
> =20
> -		if (!descr->bus_addr)
> +		if (dma_mapping_error(ctodev(card), descr->bus_addr))
>  			goto iommu_error;
> =20
>  		descr->next =3D descr + 1;

The bus_addr value is __be32 and the dma_mapping_error should be CPU
ordered. I think there was a byteswap using cpu_to_be32 missing here.
In addition you will probably need to have an intermediate variable to
store it in to test the DMA address before you byte swap it and store
it in the descriptor.

> @@ -401,7 +401,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *=
card,
>  						     descr->skb->data,
>  						     GELIC_NET_MAX_FRAME,
>  						     DMA_FROM_DEVICE));
> -	if (!descr->buf_addr) {
> +	if (dma_mapping_error(ctodev(card), descr->buf_addr)) {
>  		dev_kfree_skb_any(descr->skb);
>  		descr->skb =3D NULL;
>  		dev_info(ctodev(card),

This is happening AFTER the DMA is passed through a cpu_to_be32 right?
The test should be on the raw value, not the byteswapped value.

> @@ -781,7 +781,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *=
card,
> =20
>  	buf =3D dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE=
);
> =20
> -	if (!buf) {
> +	if (dma_mapping_error(ctodev(card), buf)) {
>  		dev_err(ctodev(card),
>  			"dma map 2 failed (%p, %i). Dropping packet\n",
>  			skb->data, skb->len);

This one is correct from what I can tell. I would recommend using it as
a template and applying it to the two above so that you can sort out
the byte ordering issues and perform the test and the CPU ordered DMA
variable.
