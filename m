Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E4027BE5B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgI2HsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:48:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI2HsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:48:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601365685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8xO7rZy5t133U8JIyK4JzoQDnu4pz1aGJERQ/woAzd8=;
        b=F2j7Ia8lwg1mAWuoFPxwuwl4aoIYR7dT+Dd8v/PE7Q0bv9aW1f8qdilGaWKLB36Gkt85n6
        vGauMro7vAA+EYuNE6vrIK+UZZ40jmdTpVoh8zVIe72x9vTVdT1pFpbploibWf4AfsiKKY
        iMLJB/2HqXzOxp3lkUUd2bN8HWJkt0A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Sd7hSjdGMXe9tbf3W4rYhQ-1; Tue, 29 Sep 2020 03:48:03 -0400
X-MC-Unique: Sd7hSjdGMXe9tbf3W4rYhQ-1
Received: by mail-wr1-f71.google.com with SMTP id o6so1391720wrp.1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8xO7rZy5t133U8JIyK4JzoQDnu4pz1aGJERQ/woAzd8=;
        b=dodFouqfE4QFKtJudfFJOxfIUbAbWGu2EVDNvMrXdiPbqwF12uDi8jczr5EoYq/2I8
         U0litFS+Go7h6aCmb5ZhNVrl0qQqwq6EQZN2+RMiyv2Q7J2FN5QtXqRN+IOY+e6Bs8tz
         IGmBwAhATGwQCn6jn3s2XPMOxwzqBKiF6OLMtSWIYkKSzem9cNLwi9sZTvcbehLUvD8G
         K4t1Wn+10AB4x1HD6Z5cgY5psZQAR3OhDkyFXaryx9xp3OvhwYh0Pc/65uIRHitdwoVF
         Ep6ikwpzt5RcHgQZu2MyaYyP+eGAlBTuXJb0HIM6ywAuLuIBRHEHCc3HjNErj0PqXzgV
         3Ahw==
X-Gm-Message-State: AOAM531x3Yrexi07cBtY8QzhDR5W1fX7mf7dPuBiSYl+34XzmtlpT+jN
        Db289AkQmP6OneDfeOMJrWslRr0T7gtvY5aViJZKRBjfRi69o8WYOp72DJxFpA83EhT+NLO8Zqf
        eehS41i5twIQK72Nm
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr2845830wmc.143.1601365682200;
        Tue, 29 Sep 2020 00:48:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy9cvP6BH1Mw0CQeNnVZeFoeM27Cd6X6OrMih1YP8wEj9eAKG/lzVukmjjG2bhZg1Xt9CE+Q==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr2845808wmc.143.1601365681993;
        Tue, 29 Sep 2020 00:48:01 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id 70sm4346876wme.15.2020.09.29.00.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 00:48:01 -0700 (PDT)
Date:   Tue, 29 Sep 2020 03:47:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200929034636-mutt-send-email-mst@kernel.org>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 08:47:05AM -0700, Randy Dunlap wrote:
> On 9/24/20 3:24 AM, Eli Cohen wrote:
> > On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> >>>> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> >>>> +++ linux-next-20200917/drivers/vdpa/Kconfig
> >>>> @@ -31,7 +31,7 @@ config IFCVF
> >>>>
> >>>>  config MLX5_VDPA
> >>>>  	bool "MLX5 VDPA support library for ConnectX devices"
> >>>> -	depends on MLX5_CORE
> >>>> +	depends on VHOST_IOTLB && MLX5_CORE
> >>>>  	default n
> >>>
> >>> While we are here, can anyone who apply this patch delete the "default n" line?
> >>> It is by default "n".
> > 
> > I can do that
> > 
> >>>
> >>> Thanks
> >>
> >> Hmm other drivers select VHOST_IOTLB, why not do the same?
> 
> v1 used select, but Saeed requested use of depends instead because
> select can cause problems.

OK I went over the history. v1 selected VHOST, that as the issue I think.
A later version switched to VHOST_IOTLB, that is ok to select.

> > I can't see another driver doing that. Perhaps I can set dependency on
> > VHOST which by itself depends on VHOST_IOTLB?
> >>
> >>
> >>>>  	help
> >>>>  	  Support library for Mellanox VDPA drivers. Provides code that is
> >>>>
> >>
> 
> 
> -- 
> ~Randy

