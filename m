Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872F548EAF4
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbiANNkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:40:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241402AbiANNkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 08:40:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642167646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIY3gZLZkDvyIuN4E1WV5yUkfGDdChIOt3WJ/TVBqGs=;
        b=heg5OB+ZbBjWCp08GI2ZhIIDUn3hq997AtiW0HA/EnJUSqYK1KFDHJRfwjyzo4xzdXZ5N4
        Hz/zECTfP4gjt5ZvWVub9+uSi4khY24LNuKO7DTVsYyjxmiQettATSJKIRaE6JcxyoACxC
        sZd1sLI4LbwBCxV3o3ynAhb37d/kYpI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-PP-hz23UOpqtB-ux5NIFlw-1; Fri, 14 Jan 2022 08:40:45 -0500
X-MC-Unique: PP-hz23UOpqtB-ux5NIFlw-1
Received: by mail-ed1-f70.google.com with SMTP id g11-20020a056402090b00b003f8fd1ac475so8411961edz.1
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 05:40:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIY3gZLZkDvyIuN4E1WV5yUkfGDdChIOt3WJ/TVBqGs=;
        b=oS1aNAOy+jEP4nBwIlEM56sNOoLt7kDPWNjEY8SCx6nCEOQu740gyqp7t4cODOifSY
         d0q5OTSszQZ3NUh+AChkKZuI1GmCW/YAtGvWT0mNmlrqcw3sbNPt2HihKC+ekEzqCAqQ
         wjQOEjEiJlDk/uFjR2Uj4LW7fmYWYqgl4VDdpjWbEX3xOF/E92H2wDjvMXNCpRuqBr/L
         LpC6e5SCG62/QaJU/uV0t313m2bq6ANgaFa5yxMQnEGJYpj9sCUdUHGQBG/PSk9EqhnA
         naO+jq9+EWCVg8nS7gCr4Bnb//wUy53o8LjYao36X7124KRoD8syydSqOa+4OytRzWGk
         jV7Q==
X-Gm-Message-State: AOAM5317lqUfHjihgNrnI1h0ctL/tBYZtXvpjulK8229t+SPVD82ornU
        AIRAg3kTtD/iOJfJ572G46vRCd6CLmixoeews5H/7EKijx5NWppN+xbbGgLdZcgo93DaF7fw1Xz
        s4rqD/55RWPMSIgik
X-Received: by 2002:a50:e79a:: with SMTP id b26mr9036457edn.341.1642167644026;
        Fri, 14 Jan 2022 05:40:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2fVFvhVy+pmPWHeYWUSOIG58hk1uWTDrKAAI8J1+CadDXmJiQxrYFzLWCmLzTDxfKAupkRA==
X-Received: by 2002:a50:e79a:: with SMTP id b26mr9036435edn.341.1642167643845;
        Fri, 14 Jan 2022 05:40:43 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id qa35sm1854925ejc.67.2022.01.14.05.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:40:43 -0800 (PST)
Date:   Fri, 14 Jan 2022 08:40:39 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220114084016-mutt-send-email-mst@kernel.org>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <20220114074454-mutt-send-email-mst@kernel.org>
 <20220114133816.7niyaqygvdveddmi@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114133816.7niyaqygvdveddmi@steredhat>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 02:38:16PM +0100, Stefano Garzarella wrote:
> On Fri, Jan 14, 2022 at 07:45:35AM -0500, Michael S. Tsirkin wrote:
> > On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
> > > In vhost_enable_notify() we enable the notifications and we read
> > > the avail index to check if new buffers have become available in
> > > the meantime.
> > > 
> > > We are not caching the avail index, so when the device will call
> > > vhost_get_vq_desc(), it will find the old value in the cache and
> > > it will read the avail index again.
> > > 
> > > It would be better to refresh the cache every time we read avail
> > > index, so let's change vhost_enable_notify() caching the value in
> > > `avail_idx` and compare it with `last_avail_idx` to check if there
> > > are new buffers available.
> > > 
> > > Anyway, we don't expect a significant performance boost because
> > > the above path is not very common, indeed vhost_enable_notify()
> > > is often called with unlikely(), expecting that avail index has
> > > not been updated.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > ... and can in theory even hurt due to an extra memory write.
> > So ... performance test restults pls?
> 
> Right, could be.
> 
> I'll run some perf test with vsock, about net, do you have a test suite or
> common step to follow to test it?
> 
> Thanks,
> Stefano

You can use the vhost test as a unit test as well.

-- 
MST

