Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955B568F2D3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjBHQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBHQGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:06:45 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A647ED8;
        Wed,  8 Feb 2023 08:06:41 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id x31so4000031pgl.6;
        Wed, 08 Feb 2023 08:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BZ2KZyK75PHOOgpxlODdR/G0HpY9qCMGkSS03slsQX8=;
        b=IDqe/ueVDhlwdi/jWpIUP1Y6dkILounhTpCugx4b32WFEWIzCYE/ytA2yhOrozeUYx
         5bkxT3Mq8A5goVPGexZWyp3bUFOKvMlIjqMM7ung2AQniZBi2cA2P4X6iskof/wbEi5q
         SfOEArlsJgt8eNP+2Sm9m7h0mqUbsAn0ZEYDZuM/8FK+evByJhY0802SaCqqeZ12Q5wM
         7UlaNnJiDn05Jj3YObIVOlW21IubkKaTABcwqH1/hvIKe+YevzbSV4Qw7qux94tMeFhC
         3dIGw6083ugTuiJ5ehX6SuD3DtNSIhnR1BSZfwecLchLGSHrhQFQNtD7fujGrWgG5WHX
         KI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZ2KZyK75PHOOgpxlODdR/G0HpY9qCMGkSS03slsQX8=;
        b=5q1ge+t4VQSeoRi+mKvxJ0rxfl5CSEBKmtYkvgiduFFBYRngODj8fQfvorrrs8JnIM
         /KXHAGVJI3h0JLrDKtE9B9jLZbdqh1hgWIPMunF9JK2n+P/cV/VtmXHWLscunLvaTg2K
         1Ubl31wEA5U6Tlmzopx2L76CZmDKfuQNA5S9eeDSZVSC7LunUeFhfv47tV2yFv7/r4Pp
         9PYacqOUQG3KnltpL++G64rLaLCZGywG4SbmRtW0MCHzAfCvmLrwwYvg2Z89w8KR3UGp
         rDZ3sr9Xf03uBFhr+Srq1t0m8yNZEujnZxGNTVLxCf7SIp7OBPV5WpC/NVcaxcosgVCE
         m09w==
X-Gm-Message-State: AO0yUKVXrtIzXzBoNOx+Hh5LC2RDtxO1Jy2iObWR8nhkQLJ2QUNIsTxK
        IkmAIPnlXKLrSrIStYTT6AE=
X-Google-Smtp-Source: AK7set97Ga7b2d0vISj/OSjCfl8yBhssabnFJZt6eZwGi9bKqZQaIKdqkz3rqMxkHdybUKhCIB6PhQ==
X-Received: by 2002:aa7:97b1:0:b0:5a8:47e5:bbb5 with SMTP id d17-20020aa797b1000000b005a847e5bbb5mr1758269pfq.0.1675872400731;
        Wed, 08 Feb 2023 08:06:40 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id m26-20020aa78a1a000000b0056b4c5dde61sm11724892pfa.98.2023.02.08.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 08:06:40 -0800 (PST)
Message-ID: <4c2955c227087a2d50d3c7179e5edc2f392db1fc.camel@gmail.com>
Subject: Re: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag
 from rswitch_gwca_queue
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Date:   Wed, 08 Feb 2023 08:06:38 -0800
In-Reply-To: <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
         <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
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

On Wed, 2023-02-08 at 16:34 +0900, Yoshihiro Shimoda wrote:
> The gptp flag is completely related to the !dir_tx in struct
> rswitch_gwca_queue. In the future, a new queue handling for
> timestamp will be implemented and this gptp flag is confusable.
> So, remove the gptp flag.
>=20
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Based on these changes I am assuming that gptp =3D=3D !dir_tx? Am I
understanding it correctly? It would be useful if you called that out
in the patch description.

> ---
>  drivers/net/ethernet/renesas/rswitch.c | 26 +++++++++++---------------
>  drivers/net/ethernet/renesas/rswitch.h |  1 -
>  2 files changed, 11 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/etherne=
t/renesas/rswitch.c
> index b256dadada1d..e408d10184e8 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -280,11 +280,14 @@ static void rswitch_gwca_queue_free(struct net_devi=
ce *ndev,
>  {
>  	int i;
> =20
> -	if (gq->gptp) {
> +	if (!gq->dir_tx) {
>  		dma_free_coherent(ndev->dev.parent,
>  				  sizeof(struct rswitch_ext_ts_desc) *
>  				  (gq->ring_size + 1), gq->rx_ring, gq->ring_dma);
>  		gq->rx_ring =3D NULL;
> +
> +		for (i =3D 0; i < gq->ring_size; i++)
> +			dev_kfree_skb(gq->skbs[i]);
>  	} else {
>  		dma_free_coherent(ndev->dev.parent,
>  				  sizeof(struct rswitch_ext_desc) *
> @@ -292,11 +295,6 @@ static void rswitch_gwca_queue_free(struct net_devic=
e *ndev,
>  		gq->tx_ring =3D NULL;
>  	}
> =20
> -	if (!gq->dir_tx) {
> -		for (i =3D 0; i < gq->ring_size; i++)
> -			dev_kfree_skb(gq->skbs[i]);
> -	}
> -
>  	kfree(gq->skbs);
>  	gq->skbs =3D NULL;
>  }

One piece I don't understand is why freeing of the skbs stored in the
array here was removed. Is this cleaned up somewhere else before we
call this function?
