Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF0310E72
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhBEPfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:35:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhBEPcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612545224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bxCLpuUwWt1gg6OSB2ieJi7hWIMXaITYAuvEaLLuDoo=;
        b=Zd/n5fjGsQlO9a2ta6iE9ZpMqWtORUgbLzUT4BawyKG5rrjCiU1F3UEjKw5nv5PHNw/gxe
        GGs0XoJH/1jQMhfezI/QlqvAQIs4gWnopxtuwYvOzBEeTqOYd9T/bFX7X/YWgvZq0KKF0C
        bRJ2GOnBZiIFfdYY0XPzckCy6RcmbLs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-NUZj-k9bM8OVAvpFbfEEVg-1; Fri, 05 Feb 2021 12:13:40 -0500
X-MC-Unique: NUZj-k9bM8OVAvpFbfEEVg-1
Received: by mail-wr1-f71.google.com with SMTP id m7so5773632wro.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 09:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bxCLpuUwWt1gg6OSB2ieJi7hWIMXaITYAuvEaLLuDoo=;
        b=YiscUoNJ4nwz4xFeEA89DbMetJwLbBFh+6thSv1k1r6GhoXhD5IvXVQlKCamzZNpH8
         98eWR4a9otGXuyKx5RupuKOj0KXylGrq8gGavIFVUjqDoDQ3JJ0WjQ0kMPpGeCoXpGJn
         rkz4Qw3f/gbljZ2mGsGxxCjP1Hm2EIcvzD0eqkbIskAANnxK271kT4OdWmdImKciqfYM
         Fj0PPhrtfrkBVLdRAc1wf+Mj+/YmpZlg5Bd4o1uKL0ztOLhut/PuuOlQXhhnOJUv4RP7
         g6ZXRbQSCEBDeCU9ur6OAjhxJ9/PSQzA896pTW9yT9l7hE3vra8tvQoappar6mxUCqnX
         kItA==
X-Gm-Message-State: AOAM530Utb+1C3FIHA83YySOxWGRJJmAsClzlruAitdFCyzgfaNt/Bqv
        Idg4vTFqvGJNIbNwTFL+7BTX14FiMuVue4X0Rv/tu8hYbuQ7EKXNNGSqBvGvYJPStWbvJeNVipH
        chC4z4gVS/9WUSQK4
X-Received: by 2002:a05:600c:1986:: with SMTP id t6mr4438787wmq.92.1612545219037;
        Fri, 05 Feb 2021 09:13:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlj1IF8C6TZrkZPMhFRHLmpRrQtRxGuNgZ9jm6u1KaDWsMeg3hqorayNkVWd/qsNBA1L1XmA==
X-Received: by 2002:a05:600c:1986:: with SMTP id t6mr4438771wmq.92.1612545218803;
        Fri, 05 Feb 2021 09:13:38 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id b2sm9971371wmd.41.2021.02.05.09.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:13:38 -0800 (PST)
Date:   Fri, 5 Feb 2021 18:13:35 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     alex.popov@linux.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer dereference
Message-ID: <20210205171335.hpzoysoynko4bkhe@steredhat>
References: <trinity-c2d6cede-bfb1-44e2-85af-1fbc7f541715-1612535117028@3c-app-gmx-bap12>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <trinity-c2d6cede-bfb1-44e2-85af-1fbc7f541715-1612535117028@3c-app-gmx-bap12>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 03:25:17PM +0100, Norbert Slusarek wrote:
>From: Norbert Slusarek <nslusarek@gmx.net>
>Date: Fri, 5 Feb 2021 13:12:06 +0100
>Subject: [PATCH] net/vmw_vsock: fix NULL pointer dereference
>
>In vsock_stream_connect(), a thread will enter schedule_timeout().
>While being scheduled out, another thread can enter vsock_stream_connect()
>as well and set vsk->transport to NULL. In case a signal was sent, the
>first thread can leave schedule_timeout() and vsock_transport_cancel_pkt()
>will be called right after. Inside vsock_transport_cancel_pkt(), a null
>dereference will happen on transport->cancel_pkt.
>
>Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>Reported-by: Norbert Slusarek <nslusarek@gmx.net>
>Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 6894f21dc147..cb81cfb47a78 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1233,7 +1233,7 @@ static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
> {
> 	const struct vsock_transport *transport = vsk->transport;
>
>-	if (!transport->cancel_pkt)
>+	if (!transport || !transport->cancel_pkt)
> 		return -EOPNOTSUPP;
>
> 	return transport->cancel_pkt(vsk);
>--
>2.30.0
>

I can't see this patch on https://patchwork.kernel.org/project/netdevbpf/list/

Maybe because you forgot to CC the netdev maintainers.
Please next time use scripts/get_maintainer.pl

Anyway the patch LGTM, so

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


