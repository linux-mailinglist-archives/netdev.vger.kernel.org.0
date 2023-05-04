Return-Path: <netdev+bounces-245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7E36F656D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 706BB1C20FA6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF50139F;
	Thu,  4 May 2023 07:06:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5CAA2D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:06:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648B0270C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 00:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683183978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iM8ql6U32hllNnQM8/MvCWRLr14Z6gVQHMHyvjhAJs=;
	b=aGDu/bNBlBaZI0bP+pV1nVfaTezeIFModt2rR7Kk5AgxvU70TciGGgTBHA6x2hjJnx8uLb
	H9TtQUpy+zE82NnqPSVjGlt3rp1TTj2IBW1tOSOnNmatpK/pquKOO8ecMQWHn1u+IaxvyL
	7B1da+5Hun/+0jWnv6AyrJMYPorZcms=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-G-pWvLKwND6j8aixmZncpQ-1; Thu, 04 May 2023 03:06:17 -0400
X-MC-Unique: G-pWvLKwND6j8aixmZncpQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f315735edeso31328535e9.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 00:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683183976; x=1685775976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iM8ql6U32hllNnQM8/MvCWRLr14Z6gVQHMHyvjhAJs=;
        b=bqVnz3uKQ4K1e9so6B3yNFL+uB3AE58tzfzHdD8O+DSC+6+vz1NZsuVBcTdaUjG4A6
         RWC8ndhmKfXhKiRZqduNUCbbex6yDxBb9JUrMgCs2iG2qdylAa04xcZ8oeVn4SIXxbU2
         GqDxg2kOu93vtmPYiRUHPIDc5SeE2EKGoCAuSEoHz86VJSX+cn8zRkLyLLp4iMeC9Fl7
         trVzODqSkxNF62V4wi+MnKhksNEU+BxDu5t4iACKSctsroL6d+UGIxi2INqUeupNeJ+S
         paqeEIfUR54t2KJASJAoinaG0hqBGfsg5u+/k5qSLqXCNwi/kHf/rssXcHCALcQyXNHQ
         w+CA==
X-Gm-Message-State: AC+VfDzYgPL6L8sjzpmOoProeksHhbfPlM8KNBazm5WMkL7lrRzO2s5O
	ZAmjNkONmZ6KeDdLn8T5oXQ7STEC4wduPLw+APqbwYxrSAZLJi+hxzTOfWROGdLoYYeP5slRbus
	Z/LEVJd0KMo1hArmS
X-Received: by 2002:adf:f950:0:b0:2f1:b74:5d8a with SMTP id q16-20020adff950000000b002f10b745d8amr1675318wrr.5.1683183976225;
        Thu, 04 May 2023 00:06:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4CgwTMT0Nhemerdz6SF54k/h2cU7j+aMDelbq7ULOYa16/suNYC6YVRr/AAzrrM8mjZYvILA==
X-Received: by 2002:adf:f950:0:b0:2f1:b74:5d8a with SMTP id q16-20020adff950000000b002f10b745d8amr1675292wrr.5.1683183975895;
        Thu, 04 May 2023 00:06:15 -0700 (PDT)
Received: from redhat.com ([31.187.78.120])
        by smtp.gmail.com with ESMTPSA id s1-20020adff801000000b00300aee6c9cesm35957612wrp.20.2023.05.04.00.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 00:06:15 -0700 (PDT)
Date: Thu, 4 May 2023 03:06:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc: jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, zhengqi.arch@bytedance.com,
	willemdebruijn.kernel@gmail.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230504030546-mutt-send-email-mst@kernel.org>
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 10:27:06AM +0800, Wenliang Wang wrote:
> For multi-queue and large ring-size use case, the following error
> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
> 
> Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Probably a good idea for stable, too.

> ---
> v2:
> -add need_resched check.
> -apply same logic to sq.
> v3:
> -use cond_resched instead.
> v4:
> -add fixes tag
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..a12ae26db0e2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
>  		struct virtqueue *vq = vi->sq[i].vq;
>  		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>  			virtnet_sq_free_unused_buf(vq, buf);
> +		cond_resched();
>  	}
>  
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		struct virtqueue *vq = vi->rq[i].vq;
>  		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>  			virtnet_rq_free_unused_buf(vq, buf);
> +		cond_resched();
>  	}
>  }
>  
> -- 
> 2.20.1


