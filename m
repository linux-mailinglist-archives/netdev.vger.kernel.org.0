Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE012E30A1
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 10:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgL0JlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 04:41:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgL0JlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 04:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609061993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SDEqYZRZclqBhMldoq9bY6xgs7Lh4HmudHFX/7CD63k=;
        b=Xg0MTzu0OkTDG5MebEuND3HUhiKzJm2dbqYEV65q9qPzVpqwR/wCVNecYOze8pAMYGHXK6
        +zhdVtaPO3HCmT2zKAWB6rKdDL9FEyDBLHcPpMltlcT08PPFUvHo7qyf1WulkzKEv77zIJ
        7GigvMtouHmXmmW83EOClh5q886nlQE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-l88g9hcvPgaerxBpf5D_Hg-1; Sun, 27 Dec 2020 04:39:51 -0500
X-MC-Unique: l88g9hcvPgaerxBpf5D_Hg-1
Received: by mail-wm1-f71.google.com with SMTP id r1so5484499wmn.8
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 01:39:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDEqYZRZclqBhMldoq9bY6xgs7Lh4HmudHFX/7CD63k=;
        b=samlJOhI5JHQKjAfB8FCKTOforl9AM4WFOz6q0UdY9wxiWILM7viJ/qvr+UendRSUa
         xCkcpGxAyo4R7qZvaxn9wPIGzzYefWbXtaNZ4o5L6dYW47my7TUAs1kVkOFNVxLHXK53
         8NgkacKZSkfdXpiqRt9xmHkpMhNyabcsK9db5gVQLdDdwrXaD5b7IMcnajnoQSHZqI3c
         6VCxj5ASI9molhwcn+eE1G7q9c0qWCtNwD8DGRwF6+mXNN1Rk2RUtxakTPc6zKwahoBq
         IM7oqwvYddfPgROUu+H+wSwsRIfdzKdS/Q3NoTMkz/GGA70+UwmDGm+zm1C8SuaEhJD4
         b5LQ==
X-Gm-Message-State: AOAM530/9tx5CctZwEFLK0VJI6H5ioV8frHoASAvrWnnFTGjL1m3a0gF
        AIKUiNxHQb/aZjqeX6ytaGtJH0avHtNaJT3DhCD4m9a9GY+7eu6STZ2yxH8UXEud14Ag8/Nyi10
        HnMLa/XBFsr02GtVN
X-Received: by 2002:a1c:7d88:: with SMTP id y130mr15488437wmc.158.1609061990095;
        Sun, 27 Dec 2020 01:39:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyGtuwxz5HGvWvcbVAvqWIfomIkgczDaTC3a9t3mqTRPR8mdFVT51IpWw97J793o5pGcfjMQ==
X-Received: by 2002:a1c:7d88:: with SMTP id y130mr15488419wmc.158.1609061989905;
        Sun, 27 Dec 2020 01:39:49 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id j7sm14708444wmb.40.2020.12.27.01.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 01:39:48 -0800 (PST)
Date:   Sun, 27 Dec 2020 04:39:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net] tun: fix return value when the number of iovs
 exceeds MAX_SKB_FRAGS
Message-ID: <20201227043940-mutt-send-email-mst@kernel.org>
References: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 07:48:53PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> we should use -EMSGSIZE instead of -ENOMEM.
> 
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/tun.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..15c6dd7fb04c 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1365,7 +1365,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>  	int i;
>  
>  	if (it->nr_segs > MAX_SKB_FRAGS + 1)
> -		return ERR_PTR(-ENOMEM);
> +		return ERR_PTR(-EMSGSIZE);
>  
>  	local_bh_disable();
>  	skb = napi_get_frags(&tfile->napi);
> -- 
> 2.23.0

