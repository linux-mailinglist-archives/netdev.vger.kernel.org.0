Return-Path: <netdev+bounces-2924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C749D704860
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 839F628164E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58D4156EB;
	Tue, 16 May 2023 09:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ED1156E5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:01:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757AB2738
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684227684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uouDHzwyKCOfVfc0oyLKQ3cuTBh+BdzwOJFz6auqBmY=;
	b=IiehHkrcuclfxgSgVVFV9Dcn5wqMvSOH6/UUctpzSRDXsTbk7qjWAiVjQRzLMek5KdTrHB
	VDs4pTnI66Wz+gHysAFH/B+tnTJrC6xXrTVNzqLpPaN7scqcib6HRc7QSET1gvF+FTtdCe
	RrEo/qjFHpDa+ldCxQb75ROF4+Dfews=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-rXXfoYazM92lbvCm4cUlRw-1; Tue, 16 May 2023 05:01:15 -0400
X-MC-Unique: rXXfoYazM92lbvCm4cUlRw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f4fffe7883so3235095e9.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684227674; x=1686819674;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uouDHzwyKCOfVfc0oyLKQ3cuTBh+BdzwOJFz6auqBmY=;
        b=de8WACrYvY8sygrp9EeA5HF7ibsVdUgVeX97J9g6MUNbRUg6TorFdESrjhboFuU6fC
         xCRstcQoBOMrgezbjjRPf7VzT6CGmtuaIHN6snrUIXeqfffl1fFD6JWZXtSIlsqIFu0j
         mTEYBLlsHI0y4748rrcLgUm1aDYllClhnLKqVniobXlKaqJN86i8kbH1+p7/zutYRquu
         T7aFI7auZg90bn8/IATRBeQ5fHnPY4SUO6GCl2Djc8v2UaUpQZsojCHHppc9bW6vab6S
         mbF4CvZHyvynRUCqp2H/NDCjvKTP8P02vOupVAbXSUi3azP+vmgYu3UK7Jx0dcdXLsG8
         OD0Q==
X-Gm-Message-State: AC+VfDxg3fwOqGm1zJKxoG6u8DzMv4kxfrstT/addCxlaSS8MstsAfMW
	vrp0FKzR6qJoG63ww68hD2Q6902OkbPmcoomwIMS3BxQGCft25xLs94XgKePxOh+82gByFDrESm
	ofDYig/Njdg9M1Ccb
X-Received: by 2002:a05:600c:3b88:b0:3f4:2405:a0af with SMTP id n8-20020a05600c3b8800b003f42405a0afmr1669155wms.0.1684227674549;
        Tue, 16 May 2023 02:01:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4CrQC+cJc481OFA/7rWIIR2qxQYfxGRukNmwdoEsO8OASyoIH2ay8TvTlyh/wpF9ABfCDijw==
X-Received: by 2002:a05:600c:3b88:b0:3f4:2405:a0af with SMTP id n8-20020a05600c3b8800b003f42405a0afmr1669133wms.0.1684227674227;
        Tue, 16 May 2023 02:01:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003f07ef4e3e0sm33088768wmo.0.2023.05.16.02.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:01:13 -0700 (PDT)
Message-ID: <cf5c8fe8e5b47766005c1f093153f630774f644b.camel@redhat.com>
Subject: Re: [PATCH net-next] octeontx2-pf: Add support for page pool
From: Paolo Abeni <pabeni@redhat.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org
Date: Tue, 16 May 2023 11:01:12 +0200
In-Reply-To: <20230515055607.651799-1-rkannoth@marvell.com>
References: <20230515055607.651799-1-rkannoth@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-15 at 11:26 +0530, Ratheesh Kannoth wrote:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 7045fedfd73a..df5f45aa6980 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -217,9 +217,10 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf,=
 struct sk_buff *skb,
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
>  				va - page_address(page) + off,
>  				len - off, pfvf->rbsize);
> -
> +#ifndef CONFIG_PAGE_POOL
>  		otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
>  				    pfvf->rbsize, DMA_FROM_DEVICE);
> +#endif

Don't you need to do the same even when CONFIG_PAGE_POOL and !pool-
>page_pool ?

>  		return true;
>  	}
> =20
> @@ -382,6 +383,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfv=
f,
>  	if (pfvf->netdev->features & NETIF_F_RXCSUM)
>  		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> =20
> +	skb_mark_for_recycle(skb);

Don't you need to set the recycle only when pool->page_pool?

Overall it looks like that having both the pool->page_pool and
CONFIG_PAGE_POOL checks in place add a few possible sources of bugs.

Cheers,

Paolo


