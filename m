Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BD2D4270
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 13:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbgLIMvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 07:51:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730239AbgLIMvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 07:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607518212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3rk0ejDD/QdmyhXmhnACbWCnOfZlWDy18TogCs6fwJc=;
        b=Hbslh6lPooTH8TpeGYuVN+JbIxZhMEIyitLoQmtnDUKL0ivM/TGJApR1OQxEGxETrSrX2q
        xE8Gz0IQwXMIlspE7krtOB9j/h6NXRs175NHZbKCnngEyevAcU1zdJIMI7H6zuo+pmEyp6
        o5tjY1FHxuCBB7s/Qz1+qHAOKsldfgY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-nJgZ3h57OsyNahVRbj_J2A-1; Wed, 09 Dec 2020 07:50:10 -0500
X-MC-Unique: nJgZ3h57OsyNahVRbj_J2A-1
Received: by mail-wm1-f69.google.com with SMTP id v5so534288wmj.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 04:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3rk0ejDD/QdmyhXmhnACbWCnOfZlWDy18TogCs6fwJc=;
        b=cfUaqE0yiIA9yL8dRZnFISqRF29rwfeQSX6v5eamLnEymiJTtxSQYxk5q90Dp8byga
         KJ/sQ+o7OKDYXsGKDSQxF708pjPgsFQNjLzMG3xmW5jX1d8iR1A/mgD6dpSX/LSODMLS
         /XE6PBUzsyme0C0VOI7sTYoKocKmRrDBMlvE2kOMmn5Xa63qP6DLtvZKjwJDrlnVqytm
         zhV9behCiCYqOGuEsEgitIMczutDjnbH8bNq2nUubhJFiUIdnoVQR7mPx1EKfR79huQe
         FDOvcmUyCC/YqenC1syfZ2bB1DzMZsMNlyj0HzKXQIgF4DPyHWOq3UDWOflxVSsPAWTu
         BFHg==
X-Gm-Message-State: AOAM533M+97bjioM99iRqnqzgPBesm1eXfPV3EtjsLl3/LmoqXoZSY1M
        zOllGJ5tjsUavIING86IVjQ0H7Vyxd9cREWcWEBrbB4G51IZhHUo10XGb+wj8D9Ht/08b9O061F
        3HbEjUc1bXaizKy4Q
X-Received: by 2002:a5d:4746:: with SMTP id o6mr2458196wrs.324.1607518209746;
        Wed, 09 Dec 2020 04:50:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyt/Xq9MGGEWkdqnz18kbdsDt/3I1ptobtgQHQhceGWRK01mdjNxG6qe9f5EodsVxgUOcJZGg==
X-Received: by 2002:a5d:4746:: with SMTP id o6mr2458177wrs.324.1607518209549;
        Wed, 09 Dec 2020 04:50:09 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id p19sm3986052wrg.18.2020.12.09.04.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 04:50:08 -0800 (PST)
Date:   Wed, 9 Dec 2020 07:49:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, jerry.lilijun@huawei.com,
        chenchanghu@huawei.com, xudingke@huawei.com
Subject: Re: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Message-ID: <20201209074832-mutt-send-email-mst@kernel.org>
References: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 07:48:24PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently we break the loop and wake up the vhost_worker when
> sendmsg fails. When the worker wakes up again, we'll meet the
> same error. This will cause high CPU load. To fix this issue,
> we can skip this description by ignoring the error.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/vhost/net.c | 24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 531a00d703cd..ac950b1120f5 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -829,14 +829,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  
>  		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> -		}
> -		if (err != len)
> -			pr_debug("Truncated TX packet: len %d != %zd\n",
> -				 err, len);
> +		if (unlikely(err < 0 || err != len))
> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>  done:
>  		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
>  		vq->heads[nvq->done_idx].len = 0;

One of the reasons for sendmsg to fail is ENOBUFS.
In that case for sure we don't want to drop packet.
There could be other transient errors.
Which error did you encounter, specifically?

> @@ -925,19 +919,11 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  
>  		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> -			if (zcopy_used) {
> +		if (unlikely(err < 0 || err != len)) {
> +			if (zcopy_used && err < 0)
>  				vhost_net_ubuf_put(ubufs);
> -				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> -					% UIO_MAXIOV;
> -			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>  		}
> -		if (err != len)
> -			pr_debug("Truncated TX packet: "
> -				 " len %d != %zd\n", err, len);
>  		if (!zcopy_used)
>  			vhost_add_used_and_signal(&net->dev, vq, head, 0);
>  		else
> -- 
> 2.23.0

