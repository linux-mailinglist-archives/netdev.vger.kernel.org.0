Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA522E25F2
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 11:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgLXK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 05:29:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgLXK3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 05:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608805704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VSr/ca7o3b8Xl8HIOqOlEsieB2uuzUBzabdw9q+MNzY=;
        b=eGhKUUYFU5wSO5M0akWLUCjQ5sHxkY8Kb0ffYI5xtzctS0EmVJPB5rpWRCCyViUDAo6Ukb
        2UXwAnlJpuWVGiFQBTdBVkKxLuLvSlKY4JuYILi6Jh/gQnNSb38tZ5Ld1J5MJXtQN86nU4
        tDMxyI2IjmCbV0SO4IbCXEw+I/YFYhM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-pLPQFI_4MP2rDhqua3PRhQ-1; Thu, 24 Dec 2020 05:28:22 -0500
X-MC-Unique: pLPQFI_4MP2rDhqua3PRhQ-1
Received: by mail-wm1-f69.google.com with SMTP id k67so577824wmk.5
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 02:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VSr/ca7o3b8Xl8HIOqOlEsieB2uuzUBzabdw9q+MNzY=;
        b=UEOaPEDbvUTyNL9EORNypzcjjzfCgdJ+2Ik3vP7RLdR69iFPgeql/uzPdLdfu+YKRY
         0lxytUEbV+WUMme2oUIBViMxxuirtl3CmyoJ1USkSMO2L4I61mKrgFPOF2CEmGr9V0yX
         cnWM00n9IkE02lCwV0AW7sbsWAxHWNzUQZzNtAavIl/zTYQfqOVird4FrPiwxN4G9efP
         BK8UrBgXr4tgHGwcMH1Teo2BBjTocYxdS8rjxAjszOEIUvMdkA8byvy1W1WclxkHdJ7Y
         kmnew43EKoN+vE5oVvowS6cBczL5UKIpphf5hf0c2NwWVR0THMLFpfSnbRvc2QutD/Zw
         /FLg==
X-Gm-Message-State: AOAM530HX6Ug1JG6HwvjxspmLpABqsbuh7cF/XW9c66dl+zvloburq5B
        I+F+wkCPFP0sLS4nZSMbaDkcy9KRyTMH2fFckFKkc6Dq41020CMJRfUHw9Be2qQQVDbMKdSAQum
        VzNVoC9Bv4zFno9X4
X-Received: by 2002:adf:db43:: with SMTP id f3mr34719979wrj.70.1608805701179;
        Thu, 24 Dec 2020 02:28:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyH7tEoZv98cNPWR3XTkDPKIzsIPggNUAnTiTrGRQD7MXcLK+BI6ZQg7K6+jiRReA99ypqipg==
X-Received: by 2002:adf:db43:: with SMTP id f3mr34719963wrj.70.1608805700962;
        Thu, 24 Dec 2020 02:28:20 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id w13sm38017280wrt.52.2020.12.24.02.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 02:28:20 -0800 (PST)
Date:   Thu, 24 Dec 2020 11:28:18 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net] ppp: hold mutex when unbridging channels in
 unregister path
Message-ID: <20201224102818.GA27423@linux.home>
References: <20201223184730.30057-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223184730.30057-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 06:47:30PM +0000, Tom Parkin wrote:
> Channels are bridged using the PPPIOCBRIDGECHAN ioctl, which executes
> with the ppp_mutex held.
> 
> Unbridging may occur in two code paths: firstly an explicit
> PPPIOCUNBRIDGECHAN ioctl, and secondly on channel unregister.  The
> latter may occur when closing the /dev/ppp instance or on teardown of
> the channel itself.
> 
> This opens up a refcount underflow bug if ppp_bridge_channels called via.
> ioctl races with ppp_unbridge_channels called via. file release.
> 
> The race is triggered by ppp_unbridge_channels taking the error path

This is actually ppp_bridge_channels.

> through the 'err_unset' label.  In this scenario, pch->bridge has been
> set, but no reference will be taken on pch->file because the function
> errors out.  Therefore, if ppp_unbridge_channels is called in the window
> between pch->bridge being set and pch->bridge being unset, it will
> erroneously drop the reference on pch->file and cause a refcount
> underflow.
> 
> To avoid this, hold the ppp_mutex while calling ppp_unbridge_channels in
> the shutdown path.  This serialises the unbridge operation with any
> concurrently executing ioctl.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>
> ---
>  drivers/net/ppp/ppp_generic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 09c27f7773f9..e87a05fee2db 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -2938,7 +2938,9 @@ ppp_unregister_channel(struct ppp_channel *chan)
>  	list_del(&pch->list);
>  	spin_unlock_bh(&pn->all_channels_lock);
>  
> +	mutex_lock(&ppp_mutex);
>  	ppp_unbridge_channels(pch);
> +	mutex_unlock(&ppp_mutex);
>  
>  	pch->file.dead = 1;
>  	wake_up_interruptible(&pch->file.rwait);
> -- 
> 2.17.1
> 

The problem is that assigning ->bridge and taking a reference on that
channel isn't atomic. Holding ppp_mutex looks like a workaround for
this problem.

I think the refcount should be taken before unlocking ->upl in
ppp_bridge_channels().

Something like this (completely untested):

---- 8< ----
 static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
 {
 	write_lock_bh(&pch->upl);
 	if (pch->ppp ||
 	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
 		write_unlock_bh(&pch->upl);
 		return -EALREADY;
 	}
+
+	refcount_inc(&pchb->file.refcnt);
 	rcu_assign_pointer(pch->bridge, pchb);
 	write_unlock_bh(&pch->upl);

	write_lock_bh(&pchb->upl);
	if (pchb->ppp ||
	    rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl))) {
		write_unlock_bh(&pchb->upl);
		goto err_unset;
	}
+
+	refcount_inc(&pch->file.refcnt);
	rcu_assign_pointer(pchb->bridge, pch);
	write_unlock_bh(&pchb->upl);

-	refcount_inc(&pch->file.refcnt);
-	refcount_inc(&pchb->file.refcnt);
-
	return 0;

err_unset:
	write_lock_bh(&pch->upl);
	RCU_INIT_POINTER(pch->bridge, NULL);
	write_unlock_bh(&pch->upl);
	synchronize_rcu();
+
+	if (refcount_dec_and_test(&pchb->file.refcnt))
+		ppp_destroy_channel(pchb);
+
	return -EALREADY;
}

