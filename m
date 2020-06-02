Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B671EB4D7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFBFCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:02:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbgFBFCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=unNhbaKpoHgJDBrC7Eb3u/ZNlGD55wlBW/mLz0bPcnk=;
        b=Jl0OWvei2I2/20rFmmvH5/WTo3p4W7Ci1LtJSJ9nuDjhlZXPjWOUYOBQXfPZnj+fRrTLf4
        bucKAOoFgJlfeZB4XIT8+5/rm3Nbw0ZtJyG8iZVsaChChrbCM9jcTlOiaqNp9Fi7IT95xV
        kg1A9PlRk0h/JuxKkfX1OnQthEXmy3s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-ki4rz9-WPn-3BFsGhMjDJg-1; Tue, 02 Jun 2020 01:02:02 -0400
X-MC-Unique: ki4rz9-WPn-3BFsGhMjDJg-1
Received: by mail-wm1-f72.google.com with SMTP id x6so462734wmj.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=unNhbaKpoHgJDBrC7Eb3u/ZNlGD55wlBW/mLz0bPcnk=;
        b=DnDrQ0xFhEj5kE5u5N3jGi2TODZAbfUuQqIGZjhZgSxs7evBByTD9rUDQEEqA2DNo8
         QMZbbt/YNDfbY6dJsJoqPeu1Xab5yfeeen1PfgX8MM4hhFzG92aAkhvO/wh/cWLd7Rzx
         K1LV6yYjbCWOVIHd5NZcGGMk2xFQ0EC4bOlQQZOggRNrZcCVm3vTFrLt6DUNeZ0PDP83
         cbT6VyN6PjkXY4Q1zy+QTWh/eBc4J0vzDhiNKeyJp1mCyn/mjgc1OZ4YOx7988jLzzeT
         gje80TwjPEON3pgtGxjYL8AW3SqlbI1W7iLLs5ECqhjTL3K78l/S4zwEajkqKQK6ho/o
         o7aA==
X-Gm-Message-State: AOAM532/EMi0yoqil5J3nBOJFhaDanYgU2+B+Lo5pdlnRJx+v7X9Qfnu
        Tgv9yKgum5u5mrlF111ToQyz2l+rwYYUkWiE3q/QHtBJK/ia5ZPT1SZYEzMzq3O4croplTy+k3d
        WYkCm5ysxOs5RM15C
X-Received: by 2002:adf:9b9e:: with SMTP id d30mr25308473wrc.345.1591074121761;
        Mon, 01 Jun 2020 22:02:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3nr1AXCn3Z5SMmVoLwH2lrM47voNMRhlWpVupnJ+5ZSE/pBwVxy8G2I2bBBJ+b49EcSyp0Q==
X-Received: by 2002:adf:9b9e:: with SMTP id d30mr25308453wrc.345.1591074121511;
        Mon, 01 Jun 2020 22:02:01 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id w3sm1759935wmg.44.2020.06.01.22.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:02:00 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:01:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 1/6] vhost: allow device that does not depend on vhost
 worker
Message-ID: <20200602005904-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-2-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:02:58PM +0800, Jason Wang wrote:
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d450e16c5c25..70105e045768 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -166,11 +166,16 @@ static int vhost_poll_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync,
>  			     void *key)
>  {
>  	struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
> +	struct vhost_work *work = &poll->work;
>  
>  	if (!(key_to_poll(key) & poll->mask))
>  		return 0;
>  
> -	vhost_poll_queue(poll);
> +	if (!poll->dev->use_worker)
> +		work->fn(work);
> +	else
> +		vhost_poll_queue(poll);
> +
>  	return 0;
>  }
>

So a wakeup function wakes up eventfd directly.

What if user supplies e.g. the same eventfd as ioeventfd?

Won't this cause infinite loops?

-- 
MST

