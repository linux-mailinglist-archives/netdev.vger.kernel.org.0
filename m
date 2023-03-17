Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA26B6BF4AB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjCQVxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCQVxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:53:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CF2D0E50;
        Fri, 17 Mar 2023 14:53:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso6673032pjb.2;
        Fri, 17 Mar 2023 14:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679089978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4poqTf05FiPQHsMRuHP+xbWISjWPqpxmI37fFELJAGs=;
        b=ARGbcukXCyyo8jyVnWbuRYt/PGdiQXSlT3xZxNST4aeJvEf6CjBW3f9uVm4iAy/Okk
         7wWpC4apGT+uEyGiBiTVZB/Jfv7nhEaSvrTztYZAgMcOg3GllNldv/wwrMXrli1G/x0Z
         AUcKepLXGJOqPIyR1khQMONOTqI6f+0d86l1ssDBzAHWbeO3JTnn5shOa2E1sSZwFAok
         iekn0QRh+Aqih5SQU6IXdSWzEOOSEtR+ve1ZLGWYn5CHzc1xph5Iupc7FOogPQfsSwOH
         sp/cz3edsNFlmZFzYVXmwPRPQn29CyIpEFUH3wkzpeCFe3otvUB22GGbm0a3iHD6+165
         g8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679089978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4poqTf05FiPQHsMRuHP+xbWISjWPqpxmI37fFELJAGs=;
        b=fhTgWzjEwu4KqmrgCNWzEOUmSYRvChjOOHlPUUCxOO3VrWIsln2vsQu5Bx2S4JYY8W
         r9WClW+GGSLxghtP5RkjX0QGFuX3Dw6p7PBqhBYf+yxuJJ1zpARYvtwMRDtbD0E+OuZm
         T4BFmrl0WTf9L9mpiP3h2jHjeBwoZPebXhER2KXiureZB7lEU7tQ69iZfJnXPK69HPdV
         HJ4BgtlVzo7UVkeDwmQg7gcSqa/BwdrV+vK3FTBtU6/CbSd72bbYdHq6sjEG4aZ8oN1B
         e+pXThUtH57zCl8xTLpjFQJcMa64CHCTV92eV6+7SjNVEtm7RRDy4PhIN3sot3+xTcFs
         yK+w==
X-Gm-Message-State: AO0yUKXAgkGMP+A+e3Q/zHZ0IOzWWQaQCxQ3hmfjJKvf0LD8tkRiC0pb
        9cilK5Gb0aieuvDbL99IjZI=
X-Google-Smtp-Source: AK7set/caK4qYFgs6zEDm+RZ2wHn9RMnd08MMGlpv81ljN3yUqSFSEDTg8AkDU/YU9Ddsqv4n4BeLw==
X-Received: by 2002:a17:902:fa0b:b0:1a1:956e:5417 with SMTP id la11-20020a170902fa0b00b001a1956e5417mr5910746plb.22.1679089978238;
        Fri, 17 Mar 2023 14:52:58 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id p12-20020a1709028a8c00b001a198422025sm1990339plo.125.2023.03.17.14.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 14:52:57 -0700 (PDT)
Date:   Fri, 17 Mar 2023 21:52:56 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <ZBThOG/nISvqbllq@bullseye>
References: <2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:38:39PM +0300, Arseniy Krasnov wrote:
> This adds small optimization for tx path: instead of allocating single
> skbuff on every call to transport, allocate multiple skbuffs until
> credit space allows, thus trying to send as much as possible data without
> return to af_vsock.c.

Hey Arseniy, I really like this optimization. I have a few
questions/comments below.

> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 45 +++++++++++++++++--------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 6564192e7f20..cda587196475 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  	const struct virtio_transport *t_ops;
>  	struct virtio_vsock_sock *vvs;
>  	u32 pkt_len = info->pkt_len;
> -	struct sk_buff *skb;
> +	u32 rest_len;
> +	int ret;
>  
>  	info->type = virtio_transport_get_type(sk_vsock(vsk));
>  
> @@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  
>  	vvs = vsk->trans;
>  
> -	/* we can send less than pkt_len bytes */
> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> -
>  	/* virtio_transport_get_credit might return less than pkt_len credit */
>  	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>  
> @@ -227,17 +224,37 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>  		return pkt_len;
>  
> -	skb = virtio_transport_alloc_skb(info, pkt_len,
> -					 src_cid, src_port,
> -					 dst_cid, dst_port);
> -	if (!skb) {
> -		virtio_transport_put_credit(vvs, pkt_len);
> -		return -ENOMEM;
> -	}
> +	rest_len = pkt_len;
>  
> -	virtio_transport_inc_tx_pkt(vvs, skb);
> +	do {
> +		struct sk_buff *skb;
> +		size_t skb_len;
> +
> +		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
> +
> +		skb = virtio_transport_alloc_skb(info, skb_len,
> +						 src_cid, src_port,
> +						 dst_cid, dst_port);
> +		if (!skb) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}

In this case, if a previous round of the loop succeeded with send_pkt(),
I think that we may still want to return the number of bytes that have
successfully been sent so far?

>  
> -	return t_ops->send_pkt(skb);
> +		virtio_transport_inc_tx_pkt(vvs, skb);
> +
> +		ret = t_ops->send_pkt(skb);
> +
> +		if (ret < 0)
> +			goto out;

Ditto here.

> +
> +		rest_len -= skb_len;
> +	} while (rest_len);
> +
> +	return pkt_len;
> +
> +out:
> +	virtio_transport_put_credit(vvs, rest_len);
> +	return ret;
>  }
>  
>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> -- 
> 2.25.1
