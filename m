Return-Path: <netdev+bounces-6329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B612715C5C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A22711C20BB9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B62168D1;
	Tue, 30 May 2023 10:58:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580394A0C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:58:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA493
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685444291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/mrKC8ILHaKXXoBpxuUunqGJNBqiIV2zUbO9MiyevM=;
	b=SMkZ8X+tEBIpWjJG8rZJ1ew5c9xJ+sBMPQcezIR86qiU60U22sbRLO+Xh9fJHx1qrzEb7o
	XaqDRV5ans0fnk7hKwwbXQXWxxoI+ICn5Z/3ua20BXPjZ170kqhXGrYly1d1UOOiwzCdJE
	2AIcGCMqfG98uXkwb6/ITTG+tg2p3+E=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-ASZmcigBO3aizUthnXriuQ-1; Tue, 30 May 2023 06:58:10 -0400
X-MC-Unique: ASZmcigBO3aizUthnXriuQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-62632620f00so1637876d6.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444289; x=1688036289;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/mrKC8ILHaKXXoBpxuUunqGJNBqiIV2zUbO9MiyevM=;
        b=LLNC3XJc6v0XaHsJwQfxL0nIWSiruJv3cYzSdDd7wHryLy7sI5kiwkCi6fVdTJ+2xY
         fRR9dHRIrYJZEnWS/ENKQgG/TfAQTlIryT1BlzxiyWWLXr04V+HVYSTRIc5nQjY/sTQO
         KL5d/Nt1yevY4PW0POgxLvy3pXm9CTuPHaJxSE5Qym4tSKMf4aJ2hAaeuPM0rN7/VezK
         cffYKMZVTjQXldye4PvojZuwVhDUOGvylqkDjPBlZStMVMUmflc7ifCx5R3STZ9iDpYo
         uw0DMrMCCGtUlWJVf2fhZCXsPlX62F3PdIAKl1ZrcnAOyofmELwKK5czajREpwxB4HxF
         a1Lw==
X-Gm-Message-State: AC+VfDw5R9NntPi5LIwHutYQX2Fy52AOzCIPevSguqyP1qEykGVMzp4I
	0V44FNUR0m+be66AUrH6vNOinLCqiRJPvXxDhigUuKoNRQi6LVphVODWm2GZa+zUejR4vpdYVaF
	EyBxhBf6M0ThJ/XV8
X-Received: by 2002:a05:620a:2d91:b0:75b:23a1:69e5 with SMTP id tr17-20020a05620a2d9100b0075b23a169e5mr1290248qkn.5.1685444289583;
        Tue, 30 May 2023 03:58:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5P8f332Qne3qa6pX9Dt7cxTt0lpnKwMfeH1oT5PFDwT9uomOdfCfZkvu2ZMJ88vFZU8XMTeA==
X-Received: by 2002:a05:620a:2d91:b0:75b:23a1:69e5 with SMTP id tr17-20020a05620a2d9100b0075b23a169e5mr1290233qkn.5.1685444289310;
        Tue, 30 May 2023 03:58:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id q26-20020a05620a039a00b0075d031ba684sm116914qkm.99.2023.05.30.03.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 03:58:09 -0700 (PDT)
Message-ID: <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] usbnet: ipheth: add CDC NCM support
From: Paolo Abeni <pabeni@redhat.com>
To: Foster Snowhill <forst@pen.gy>, "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Georgi Valkov <gvalkov@gmail.com>, Simon Horman
 <simon.horman@corigine.com>,  Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 30 May 2023 12:58:06 +0200
In-Reply-To: <20230527130309.34090-2-forst@pen.gy>
References: <20230527130309.34090-1-forst@pen.gy>
	 <20230527130309.34090-2-forst@pen.gy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Sat, 2023-05-27 at 15:03 +0200, Foster Snowhill wrote:
> @@ -116,12 +124,12 @@ static int ipheth_alloc_urbs(struct ipheth_device *=
iphone)
>  	if (rx_urb =3D=3D NULL)
>  		goto free_tx_urb;
> =20
> -	tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
> +	tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_TX_BUF_SIZE,
>  				    GFP_KERNEL, &tx_urb->transfer_dma);
>  	if (tx_buf =3D=3D NULL)
>  		goto free_rx_urb;
> =20
> -	rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP=
_ALIGN,
> +	rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
>  				    GFP_KERNEL, &rx_urb->transfer_dma);
>  	if (rx_buf =3D=3D NULL)
>  		goto free_tx_buf;

Here the driver already knows if the device is in NCM or legacy mode,
so perhaps we could select the buffer size accordingly? You would
probably need to store the actual buffer size somewhere to keep the
buffer handling consistent and simple in later code.

> @@ -373,12 +489,10 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, s=
truct net_device *net)
>  	}
> =20
>  	memcpy(dev->tx_buf, skb->data, skb->len);
> -	if (skb->len < IPHETH_BUF_SIZE)
> -		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
> =20
>  	usb_fill_bulk_urb(dev->tx_urb, udev,
>  			  usb_sndbulkpipe(udev, dev->bulk_out),
> -			  dev->tx_buf, IPHETH_BUF_SIZE,
> +			  dev->tx_buf, skb->len,
>  			  ipheth_sndbulk_callback,
>  			  dev);
>  	dev->tx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;

This chunk looks unrelated from NCM support, and unconditionally
changes the established behaviour even with legacy mode, why?

Does that works even with old(er) devices?

Thanks,

Paolo


