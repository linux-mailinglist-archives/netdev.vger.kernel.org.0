Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF02E277624
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgIXQC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728381AbgIXQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600963371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HjfyIqm+fMI2qwxuazO2r9o7hq0du7rjNYxWCh/yhH8=;
        b=bFLZSIdgdLP2sy7S6R1UAde0+8AQKrhceQjmc4fsmw1kv41uPxoJSu2jQ7Go1vmdljGSV8
        IeltaZYzZipBXZu28wgA7uXdS/2ReJUVBHmZWqBo/TvIMUa+q3+M61A1U8vxavCJmx6mdy
        fUXj4+/fraMpTfcWTJhe+iewkICVtgM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-5ABs0DAaNUm_L4Zpj5uyCg-1; Thu, 24 Sep 2020 12:02:50 -0400
X-MC-Unique: 5ABs0DAaNUm_L4Zpj5uyCg-1
Received: by mail-wr1-f69.google.com with SMTP id i10so1417259wrq.5
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HjfyIqm+fMI2qwxuazO2r9o7hq0du7rjNYxWCh/yhH8=;
        b=YlaWR+ymSo3e/cNQW+jig0zaGArAG7pVuWIftuocdrA26cnbjJGxkdL97xpqmdEVD1
         iqPXyF0DyMf3mP8cJOpBrn9xfcg+r5n0qRbKREnYXNQ76v7k/erbvNKwe+T0gKD0sl36
         ISjLnlqLrODoOqXzty8vfoCqhm5MEllaWEvCGkNUlDClYAufqx8slwem7oQAd1s/fajS
         pNz2MPMkxW9VUELuaKe229H9Wr3BsWj4THaZFCX9/lp4O3Jv3b4rqLj/cUDf3a+aFlnO
         tnQJfe/NIFx2svzS8qnm+lkJ4Yq5CIw4C8OvTBvPKmuruivSnLk5R4YR9Da+ER02+7vA
         zoaw==
X-Gm-Message-State: AOAM530BU/o42SgU/ylqiNmhy//crWSOdmt9b188kCAQvfrvbh+nvwvu
        5dFy1tMDDCo+zAQf8H71UU+yooM4aBirSuUj95PwmgY2lSyxeJ82z92u/w1FfD4NKbYSDJyvOMn
        BUcuGvv3jrGR2RxhH
X-Received: by 2002:a1c:3985:: with SMTP id g127mr42197wma.32.1600963368765;
        Thu, 24 Sep 2020 09:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCPrKe4Frc7EN7ceX89EofTC20FnVIrKVkqVACJHY7m+Y40fca3g0NY1X+dwbg7ouM3QMnaA==
X-Received: by 2002:a1c:3985:: with SMTP id g127mr42161wma.32.1600963368443;
        Thu, 24 Sep 2020 09:02:48 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id t6sm4065953wre.30.2020.09.24.09.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 09:02:47 -0700 (PDT)
Date:   Thu, 24 Sep 2020 12:02:43 -0400
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
Message-ID: <20200924120217-mutt-send-email-mst@kernel.org>
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
> 
> > I can't see another driver doing that. Perhaps I can set dependency on
> > VHOST which by itself depends on VHOST_IOTLB?
> >>
> >>
> >>>>  	help
> >>>>  	  Support library for Mellanox VDPA drivers. Provides code that is
> >>>>
> >>
> 

Saeed what kind of problems? It's used with select in other places,
isn't it?

> -- 
> ~Randy

