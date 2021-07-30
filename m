Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0A3DBEF8
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhG3T2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:28:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhG3T2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627673280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PIywLjF9bhGG91hz6k+Z/hNScCoEIRSj0PrJUDAWtOI=;
        b=FU0h28QGbscLAMqt63Ub8ifi9DF9Pz0u24OAGJ6U6lgGnZGWejrWKadiiwiLFt++saMZw8
        GQV/+Gz0q7570I1ad4f9pY5T2m1huFyEi+YOHaD7BVdytXcsOhiEwNqzgHuoyQX7WK+oJe
        dCkwO78OduU4Cld10xnB4CqBYzGJm1g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-Ocy_S8Q7OPWOenxdIskuqw-1; Fri, 30 Jul 2021 15:27:59 -0400
X-MC-Unique: Ocy_S8Q7OPWOenxdIskuqw-1
Received: by mail-wm1-f70.google.com with SMTP id 25-20020a05600c0219b029024ebb12928cso3575160wmi.3
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 12:27:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PIywLjF9bhGG91hz6k+Z/hNScCoEIRSj0PrJUDAWtOI=;
        b=lcuhLgjOWaNGQ21beqrSGal70K9VMvz3eUQYL+5XwLSSlzoRFv6hgvfmjsEAav5JGq
         c8M6SkVCP3uk1UJz6oYq2KFlTBeRh4aIEuWD+KcfkvyOdPIoxNamYx1u7F9YD3gA8xtm
         fsamO/y9R+9p/882VJwAhLjhKNh2ar8y9PJa+py4QEpsGN3fZqkgbsNUvd7DVmndkFhX
         xH6Cd4EsbLjRyLcia7RS3K8onIWqU3dMemKIx1mQVAsIsBgYDL5r/CZ3UWARLWQE6Ucs
         g3ucYfdxuYaiCJmuy74flqE3pi7VGbL4pmwfL6tKIyaLD0RdPotV6TPyBVrJM7QmVtYR
         mrVg==
X-Gm-Message-State: AOAM530u7IVFUyg/oLJTa6tLle3Q6fZUWkZmEa5/o6u8S0ICNjaRh2Qq
        2tzrlZ6jUA8ZvyvBWuz1J0FexH/FUo+wi5OI2oRxkDuDDztMVjaMcjJX9bcclio5KOjo5Xst5ty
        gJWAF9IZ+RSs3SIax5KRmI8/RFD0WZtaNJb2Bq3IK50Ze1gMuJdeunR9iAIIJsIkLzEga
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr4976128wrt.140.1627673277954;
        Fri, 30 Jul 2021 12:27:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTsdeikAB49nLAgfRJ+NxBKxLo6VygWS0g5vnebrGyL4KqoSgh1ajzXAO4izThzTZWJm+k0A==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr4976107wrt.140.1627673277683;
        Fri, 30 Jul 2021 12:27:57 -0700 (PDT)
Received: from localhost (mob-176-242-6-116.net.vodafone.it. [176.242.6.116])
        by smtp.gmail.com with ESMTPSA id x9sm2698455wmj.41.2021.07.30.12.27.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:27:57 -0700 (PDT)
Date:   Fri, 30 Jul 2021 21:27:16 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/sched: store the last executed chain also
 for clsact egress
Message-ID: <YQRSlETLgowgik2x@dcaratti.users.ipa.redhat.com>
References: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
 <CAM_iQpU--x8PRprG8W6btdXFBr0bNnYaJF6CorELmK+tOgry=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpU--x8PRprG8W6btdXFBr0bNnYaJF6CorELmK+tOgry=Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks for looking at this!

On Wed, Jul 28, 2021 at 03:16:02PM -0700, Cong Wang wrote:
> On Wed, Jul 28, 2021 at 11:40 AM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
> > id' in the skb extension. However, userspace programs (like ovs) are able
> > to setup egress rules, and datapath gets confused in case it doesn't find
> > the 'chain id' for a packet that's "recirculated" by tc.
> > Change tcf_classify() to have the same semantic as tcf_classify_ingress()
> > so that a single function can be called in ingress / egress, using the tc
> > ingress / egress block respectively.
> 
> I wonder if there is any performance impact with this change? As
> tcf_classify() now may allocate skb ext (tc_skb_ext_alloc()) too,
> right after __tcf_classify().
> 
> Thanks.

I think there is some performance drop for users that activate
TC_SKB_EXT, in case packet doesn't match the filter *and* last
executed_chain is non-zero. But in this case, I also think it's a good
choice to spend some cycles to save the chain id in the extension: I
might be wrong, but AFAIK openvswitch is the only "user" that configures
TC in this way.

Do you have in mind a specific case where performance can be degraded
because of this commit? if so, I can try to investigate more.

thanks!
-- 
davide




