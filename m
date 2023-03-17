Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910FF6BF4AD
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjCQVyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjCQVyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:54:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A34984D6;
        Fri, 17 Mar 2023 14:54:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id y2so6713725pjg.3;
        Fri, 17 Mar 2023 14:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679090057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZLLDbPm3nkjoP0JuZeXds6jg7ClAAqz2Z12AuSnWK4=;
        b=hYjLY8ATu6it/don+rer9uslXtao78n3n6+zA1KdL2ODoAHrNNbCJ2I9kovibJhoQq
         SGNAEFVD2qE9qJxh1PJuBpFJ0jHQDZ+PtsxV97ycCGdeB4D87Eu+jDy/6m9oXgRECvwG
         nzSJ1fpOETu0qYWVJxWMwNDJk2g07Uko4IWxekBidZ/xoPnt78tyaSBveigFb3LmcGZZ
         UpS6pYVvJ3T1uhkkvmrqFwIepKop+0buA1nJ1cNSkFQiqhXJhPAEnD/FrgDd+ncwcHyn
         b4H1y2ewGun69vepLaWlidOi5iV5N91WjYIs7N1+8a2qwZPJxNWI7ZG8CvpRN3rJUkgg
         oyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679090057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZLLDbPm3nkjoP0JuZeXds6jg7ClAAqz2Z12AuSnWK4=;
        b=j25gaaTS6He4VeYXlk9FlIaAsGE5B1WyLb3I+U5xM2ewTfBbcHzmI2QsFCsHJPi0Np
         meC7s8JIaQ5v2tnr47o2To6Fyk3vDRDNnb6a+LR+rl5DszlKfB55QU6WQ0S91b/H8KNt
         5tApro0EBtFz4eK+m8VN9uddPP6N5Gdw7Jh81OU0Ax9z0gQWf2teQTKg2i57/ySbm2d9
         zcSpwdv6AOtA5U3ex/i+ne6/LMJ5qDzNJr41Z8wZf0VS5cYp7GL7qp4dfTXBmqmLDiEC
         mb6bxc7KyzHcY6rZbpFMGPrm4y2eYlVCQp7pkMOvah6BRIzRoM0xlhk+/fqIXEhU1iyM
         Jmvg==
X-Gm-Message-State: AO0yUKVP+O3gLh/oXrlfidL8gywiDBPT2oNCzBpegu/Ba1SPsqLUMke7
        I1R5rxUkoN58CalKTN136XA=
X-Google-Smtp-Source: AK7set/t9oC6xoocjc5+W6yf1YIOlsHqaitrdnjMfBG9ETATyxHCRUyhxEvcYhGrOlPY0zVrJdICRQ==
X-Received: by 2002:a17:90b:4c8d:b0:23d:2f73:d3c8 with SMTP id my13-20020a17090b4c8d00b0023d2f73d3c8mr10132317pjb.42.1679090056783;
        Fri, 17 Mar 2023 14:54:16 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id t18-20020a170902d21200b0019719f752c5sm1997319ply.59.2023.03.17.14.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 14:54:16 -0700 (PDT)
Date:   Fri, 17 Mar 2023 21:54:15 +0000
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
Subject: Re: [RFC PATCH v1] virtio/vsock: check transport before skb
 allocation
Message-ID: <ZBThh0y3yVNwhlM5@bullseye>
References: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:37:10PM +0300, Arseniy Krasnov wrote:
> Pointer to transport could be checked before allocation of skbuff, thus
> there is no need to free skbuff when this pointer is NULL.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index cda587196475..607149259e8b 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -867,6 +867,9 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>  	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
>  		return 0;
>  
> +	if (!t)
> +		return -ENOTCONN;
> +
>  	reply = virtio_transport_alloc_skb(&info, 0,
>  					   le64_to_cpu(hdr->dst_cid),
>  					   le32_to_cpu(hdr->dst_port),
> @@ -875,11 +878,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>  	if (!reply)
>  		return -ENOMEM;
>  
> -	if (!t) {
> -		kfree_skb(reply);
> -		return -ENOTCONN;
> -	}
> -
>  	return t->send_pkt(reply);
>  }
>  
> -- 
> 2.25.1

LGTM.

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
