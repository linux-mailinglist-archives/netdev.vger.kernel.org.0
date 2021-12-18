Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF6479DE6
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 23:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhLRWHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 17:07:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhLRWHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 17:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639865243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VCDl2Qks9geyT3GytmA7fcu+PaD1/o6QVHzA5DhKnjI=;
        b=T7q1jFmvfEf6SfWRMEHdSmu33vviuTtXyDPg41o7u/79uMs/1qFkjQ9olzOimHCisXpT/a
        prPXk5T5EvQB6Y1rpDsAv2ezVATiImC2OEQrnIeIfz7b3AbgHonwf5ddF75BSRpc2pqCcf
        wnve/kilpAocI0F2Z+Vof+Pl2jbChJM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-nF7uHuwqOrCKabF0P6NZ6w-1; Sat, 18 Dec 2021 17:07:21 -0500
X-MC-Unique: nF7uHuwqOrCKabF0P6NZ6w-1
Received: by mail-ed1-f70.google.com with SMTP id y17-20020a056402271100b003f7ef5ca612so4614147edd.17
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 14:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VCDl2Qks9geyT3GytmA7fcu+PaD1/o6QVHzA5DhKnjI=;
        b=R8lh0uke+gPZcqtxMhKC4T0bCI29v1/FHqv1tiWT5J6QGBetuEaJ4dePSQWC8JK39E
         N5KswJhPDmzzxscIhi04ujblcokS7syTcCuGGRKHykkehVVbAsNgLBwpWRUPlEeF/PwS
         wbs/2tOrN0uWMvTpy+CtsW/ph1rVYeobS+oSJ7GYoAsfPD6wuDMxSCcqEowevdwhSThg
         99GnWweMgGi99XVtDf+qzZJu5TVSPP4XA1/Uod4YZCevJ9eQdbue+imTQgw+NmpoCLM3
         +DN7kk1fbE2u+62+OL3FDGEAAqn5ttBFaINB1fhJklrZNQ2uQScjOW1dJz4fgvcZRfdF
         NlnQ==
X-Gm-Message-State: AOAM532lXz77+oknMixk4GSWBxlTnLzLE+8jMmzBJRyHnpF/IIQLUwIc
        AY2d5aLl7nBvSAt+BZpO838aOA50+8qFg/cHw44Pkisq6tW7rhQF2Tt7r2bPU3DTiHoc9Y/JjGo
        MTG4T9XGIvzXast5i
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr9074813edb.185.1639865240808;
        Sat, 18 Dec 2021 14:07:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJIrmRZ37IeMwKI8zajuO3r+oGkf4SiQ5vVw40enLelqNdOhKqls4BUJqXLFYvzR36B1w9Ng==
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr9074800edb.185.1639865240582;
        Sat, 18 Dec 2021 14:07:20 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:85fe:33f4:b53f:99ab:57c7])
        by smtp.gmail.com with ESMTPSA id c12sm5225163edx.80.2021.12.18.14.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 14:07:19 -0800 (PST)
Date:   Sat, 18 Dec 2021 17:07:15 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com
Subject: Re: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Message-ID: <20211218170602-mutt-send-email-mst@kernel.org>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 01:53:01PM -0700, David Ahern wrote:
> On 12/17/21 1:08 AM, Parav Pandit wrote:
> > @@ -204,6 +217,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
> >  	if (opts->present & VDPA_OPT_VDEV_MAC)
> >  		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> >  			     sizeof(opts->mac), opts->mac);
> > +	if (opts->present & VDPA_OPT_VDEV_MTU)
> > +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> 
> Why limit the MTU to a u16? Eric for example is working on "Big TCP"
> where IPv6 can work with Jumbograms where mtu can be > 64k.
> 
> https://datatracker.ietf.org/doc/html/rfc2675

Well it's 16 bit at the virtio level, though we can extend that of
course. Making it match for now removes need for validation.
-- 
MST

