Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C34F6B9ACD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCNQOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCNQOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:14:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B285A5FE89;
        Tue, 14 Mar 2023 09:14:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so15653843pjg.4;
        Tue, 14 Mar 2023 09:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CC2W8QjMD1ypSnrCCIS8nLiA3E2M+kFtJBrpVClTVyk=;
        b=a08lj7EiXyJGJpcKcxAUzJcP02WQoI2Ma7WudZpW00sEr9kKeW+VqcAicvYm1Pm47l
         F2He0yd55hDqERHDzk9i/cR057I2bvQ2HoMAcgIqvC8MePio7d5xxg47m+r8nnfPPidx
         hcxI3utG4d9hn0VfzFgbpTimntvaJS+DV6WRdq63hi7WYakbC/bE9tlKzTWBR1XWyNeN
         4/+jIM5nuqiy6zwn5E/+a47ohu0YA12U0dPBas/xjO67LixOWOQeh9MhK6G/NLuQq8rW
         EGtc6U0INXTW2/PIwLIjYtsRv7ar5+L8rE+LtBx1JeizBpad0V+83BFXYQY3LBAR+LLA
         eJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CC2W8QjMD1ypSnrCCIS8nLiA3E2M+kFtJBrpVClTVyk=;
        b=PNi90Ht9PU7JtRirpC6UJ33kk7N8qBia9NuA50lc312XV4c24WBQdeBcPdnCTXtCHK
         HD8zTjT+YtNFFMPBNs+WAihDGOyQSlcQjf+K/vFMhHDqBYgZdCJkqhDp6dR7XbKYkwi8
         yvqr4gCTYvdCUiM+zjcFcTDF4k8kSP6pGMYpQDOcrpXi1h4kOHAsKsjNZtNn0z+hIpVv
         keOaj9Ps90NebKZLtzXE7sIua851rv2uQRHw8PrmwvEHL5YrzfsteKzcAU4EVT7OmUmP
         WzG4ct2XkPoKHF3+jkeU+YEPQWYTsrCY1liJ8pqV2toeLLBX16CLo/icSEM1UT2gjdlQ
         mqsA==
X-Gm-Message-State: AO0yUKUy07B2l+XAnO5gGr8iArKGYjmh28dfrZ0KoMERCA/n0sm4e0tj
        a9UObOds07ZBdBWWjnobwrI=
X-Google-Smtp-Source: AK7set//XPVfG0KxBl89YqjKLqlrVUVChnRcz9GUK07nw02Z7ZGl7Vimg3n/83sI7W0LXCuqNneWRQ==
X-Received: by 2002:a05:6a20:b919:b0:cc:7f86:a804 with SMTP id fe25-20020a056a20b91900b000cc7f86a804mr34208846pzb.6.1678810461176;
        Tue, 14 Mar 2023 09:14:21 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7924d000000b0061998311344sm1778049pfp.211.2023.03.14.09.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:14:20 -0700 (PDT)
Date:   Wed, 8 Mar 2023 15:16:45 +0000
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
Subject: Re: [PATCH RESEND net v4 3/4] virtio/vsock: don't drop skbuff on
 copy failure
Message-ID: <ZAim3WjwQ24lpjZi@bullseye>
References: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
 <3f8fcfb1-6d5e-93db-f2d6-651e22dba9ce@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8fcfb1-6d5e-93db-f2d6-651e22dba9ce@sberdevices.ru>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:08:20PM +0300, Arseniy Krasnov wrote:
> This returns behaviour of SOCK_STREAM read as before skbuff usage. When
> copying to user fails current skbuff won't be dropped, but returned to
> sockets's queue. Technically instead of 'skb_dequeue()', 'skb_peek()' is
> called and when skbuff becomes empty, it is removed from queue by
> '__skb_unlink()'.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 9a411475e201..6564192e7f20 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -364,7 +364,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  
>  	spin_lock_bh(&vvs->rx_lock);
>  	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> -		skb = __skb_dequeue(&vvs->rx_queue);
> +		skb = skb_peek(&vvs->rx_queue);
>  
>  		bytes = len - total;
>  		if (bytes > skb->len)
> @@ -388,9 +388,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>  
>  			virtio_transport_dec_rx_pkt(vvs, pkt_len);
> +			__skb_unlink(skb, &vvs->rx_queue);
>  			consume_skb(skb);
> -		} else {
> -			__skb_queue_head(&vvs->rx_queue, skb);
>  		}
>  	}
>  
> -- 
> 2.25.1

Acked-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
