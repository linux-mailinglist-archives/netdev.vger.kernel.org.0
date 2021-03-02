Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A632A3F1
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349496AbhCBKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:04:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577778AbhCBJw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614678689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=taBd6uLnFKceyekg9FzDQkJCAu7LLfUBn3MWlZnlhHs=;
        b=KQEohFOkapG+ik5KRzdS/Ox1ItL/qWY16uzuq62GKYA/0FezKWDxQiNsXt7/2D/Cwm5yPK
        iN4sj8PVKoRhyHm5z3aB63/Rb5dZv9xp0kUSO/JkMwB/mcxwROTLxl0N0198KoTvFZFYl3
        dybprdGJJw+2WVs0oxzhGz2lt94ht58=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-N3TqeL2aMIeqgrzjh6g0ww-1; Tue, 02 Mar 2021 04:51:27 -0500
X-MC-Unique: N3TqeL2aMIeqgrzjh6g0ww-1
Received: by mail-ej1-f70.google.com with SMTP id h14so4341644ejg.7
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:51:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=taBd6uLnFKceyekg9FzDQkJCAu7LLfUBn3MWlZnlhHs=;
        b=LB5azI31JyMlTjYaRYiw+Cm251VUFi6UYTK1PA9p4UsTSm/BK7NTNgfsayYP/0TTUz
         7exbeI8oXlfz0oU2uckzKnQkNvUAFy0Yxt0o/awI9np2tl3QtdFLX+/oqm4VhMwEVXtV
         oYJ/6wMgi+uIRao711BFc6Aehk+4NJjeiZpx1D0Yw15i4TSkf3o567Civ9Smv2UJr4O3
         oLy79+DMtDts/AfXaKXJmcZAFgeUvi/M7IK21kM5mqLjiEzpcKb0+WCQBBdFclF/OfL5
         ouSPlhVFWLXNZVMwooV+fRioPyhyRcyqznPh7Sbq6Ahp4TG7ArYPpPlEJSQBP44d7wP/
         kzsA==
X-Gm-Message-State: AOAM530hLcpO5IXfvt1KMPea+a9y6+3rZmlOS3tUmsoY9OZk4GEjBDK1
        mNwLJxkTXsiSFNw85gZnpgHcfKupOPiJh0kDanmX7QH2ogid01UrjzWm/3d9ORM5B0gNgQFJyvl
        GntB1CaCGDcDQNsqs
X-Received: by 2002:a50:e183:: with SMTP id k3mr20106119edl.45.1614678686032;
        Tue, 02 Mar 2021 01:51:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVGIo5XKn8nNvUOxG42+dGS0VnbP0nQwS9Jyziu/Fx8Ig8UChySv7eaRLgbNCVP6IBt5vl/w==
X-Received: by 2002:a50:e183:: with SMTP id k3mr20106110edl.45.1614678685903;
        Tue, 02 Mar 2021 01:51:25 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id v11sm17608252eds.14.2021.03.02.01.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 01:51:25 -0800 (PST)
Date:   Tue, 2 Mar 2021 04:51:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: honor CAP_IPC_LOCK
Message-ID: <20210302044918-mutt-send-email-mst@kernel.org>
References: <20210302091418.7226-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302091418.7226-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 04:14:18AM -0500, Jason Wang wrote:
> When CAP_IPC_LOCK is set we should not check locked memory against
> rlimit as what has been implemented in mlock().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Indeed and it's not just mlock.

Documentation/admin-guide/perf-security.rst:

RLIMIT_MEMLOCK and perf_event_mlock_kb resource constraints are ignored
for processes with the CAP_IPC_LOCK capability.

and let's add a Fixes: tag?

> ---
>  drivers/vhost/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..e93572e2e344 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -638,7 +638,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  	mmap_read_lock(dev->mm);
>  
>  	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
> +	if (!capable(CAP_IPC_LOCK) &&
> +	    (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit)) {
>  		ret = -ENOMEM;
>  		goto unlock;
>  	}
> -- 
> 2.18.1

