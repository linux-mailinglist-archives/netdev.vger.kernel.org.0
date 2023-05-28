Return-Path: <netdev+bounces-5940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6E27137F4
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 08:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E31B280EA3
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 06:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648BE65A;
	Sun, 28 May 2023 06:16:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393C366
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 06:16:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1BBD8
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685254600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xyjjfsHJGz4btJpbkZnZFyAqXrjeVJSFODC6tRwjNqo=;
	b=Gnocmnp8YdeOfmf8uRjh0Qzq55Br+fL6nUu3pGz/RJWwmW9R5mbG+gC4/Tx5JeFBMBkvaq
	VrPIG25UoElgu9WgwuFv4wnIv4+VvAF7D7RTxCOgbWTjzdRwLTkZ8ZdsBLJNtMAqdmGjfd
	KF//xX6vXKiDgYzTxkQfoSxusPlEd/0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-v0HaW2zLPqeYrNfVqlT9pQ-1; Sun, 28 May 2023 02:16:39 -0400
X-MC-Unique: v0HaW2zLPqeYrNfVqlT9pQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30ae9958ff6so4795f8f.1
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685254598; x=1687846598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyjjfsHJGz4btJpbkZnZFyAqXrjeVJSFODC6tRwjNqo=;
        b=X8BL7d27avxegriuUxTW0/OksEdCUri8Y5PVtVcKnlzzZ5KNs4F62eI4w2RJUxC/RN
         P4tYZSdKlgIy4wAmgxwkfuGx4XFc652mx0HgLzbOZp/XumCTInYqrGGeXYYvQ/Cx18FB
         JDQFXPeUKjR4swECOnj9xeqjGzrjqKJAj8q2ghanatnFS1La3sGnu5gdo/Qa3m06939X
         H38n0ibEIOFt4zkvOQ2NbGo83TitvhTMm3fQ7Urbho8CW2lPa6DkhyOlDUr8xFEbj2qM
         9iwoutjVZgA8RCBMePYgqf9c4mhnFrFbC2/Q2+Ez7aBZCBbHEF/00xDXTUIjzUq65bxW
         QMQw==
X-Gm-Message-State: AC+VfDyAV8tB8cm7F+HxJ9+6Lip3CzPjMQPaPj1O+HZwUzLxSefjhMfO
	iL/ls6TvY9QbmfR0l83OvGkVvFEMl87neF7ClMXOrq3XbSU9aNsPmQHe9g7ekqjyNYrIbcHQgVG
	nXaK5NoQwl27/A2Ph
X-Received: by 2002:adf:eccc:0:b0:306:2aa0:ce81 with SMTP id s12-20020adfeccc000000b003062aa0ce81mr6910618wro.30.1685254598297;
        Sat, 27 May 2023 23:16:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dFHG2HLfd2Q3dXDNjbmL0ir54ug1fj6Cozz0mkZHs3U/h67Qlj5dhak5C/0LI3cKmRJ/97g==
X-Received: by 2002:adf:eccc:0:b0:306:2aa0:ce81 with SMTP id s12-20020adfeccc000000b003062aa0ce81mr6910604wro.30.1685254597977;
        Sat, 27 May 2023 23:16:37 -0700 (PDT)
Received: from redhat.com ([2.52.146.27])
        by smtp.gmail.com with ESMTPSA id l21-20020a1c7915000000b003f603b8eb5asm10308080wme.7.2023.05.27.23.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 23:16:37 -0700 (PDT)
Date: Sun, 28 May 2023 02:16:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
Message-ID: <20230528021008-mutt-send-email-mst@kernel.org>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-1-liangchen.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 01:46:17PM +0800, Liang Chen wrote:
> "private" of buffer page is currently used for big mode to chain pages.
> But in mergeable mode, that offset of page could mean something else,
> e.g. when page_pool page is used instead. So excluding mergeable mode to
> avoid such a problem.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

Ugh the subject makes it looks like current code has a problem
but I don't think so because I don't think anything besides
big packets uses page->private.

The reason patch is needed is because follow up patches
use page_pool.
pls adjust commit log and subject to make all this clear.


> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5a7f7a76b920..c5dca0d92e64 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  			return NULL;
>  
>  		page = (struct page *)page->private;
> -		if (page)
> +		if (!vi->mergeable_rx_bufs && page)

To be safe let's limit to big packets too:

	if (!vi->mergeable_rx_bufs && vi->big_packets && page)



>  			give_pages(rq, page);
>  		goto ok;
>  	}
> -- 
> 2.31.1


