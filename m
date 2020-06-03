Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A468C1EC989
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgFCGa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:30:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgFCGa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591165857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qhE31HcIzDAxbPbDIk2wZyZIZFK9elalZKddVhonKnM=;
        b=FN9nU/V1jgDsTHhlUfT57dHAEDQzc3c4S5IB3nry5OEnKBnMpAHnNc1x1yDS73QycqzpVj
        ehC9F4Ie6qzcW35Xu9UuROK1bFSMQMFk+vEIzyd5Dtywz2bf/hBwWhlBUHJcqWRNvO+kx/
        FlKoSpSnZPKo+CSPg0JqckIFNnXC/x8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-iqHqb_M1OZmPzJNhhYIeeA-1; Wed, 03 Jun 2020 02:30:54 -0400
X-MC-Unique: iqHqb_M1OZmPzJNhhYIeeA-1
Received: by mail-wr1-f70.google.com with SMTP id p9so664223wrx.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 23:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qhE31HcIzDAxbPbDIk2wZyZIZFK9elalZKddVhonKnM=;
        b=nvMax/qm1IEfqZ0oFYiH3wrXRgQhCQw9D+bQXOrwjIEb5ODjRdlIyaorzxLdOYha9e
         iDw1PzE343PZfheg6Te8c2QVCEXY1qMBvoaC7olvL1hOmoboiwpvSYOG+MusIQt8VG1P
         BI9ftjvtSHwawCMsVHFyGNqOFbcPe+IfNifNz1iF3x6CSZt7vqorDParXYY6WxCTjDMV
         NJzMpr7IXRZKHtSXwZNSBJwqljA0jO7E8GH6bI36jd/jCRZ0lFrk9i6F6IIzmGaZ4k7s
         hbYZ1uxUQO6wLx77W3J9joihuoWbpD6UT/kppvcfF4zFap5POLoRpGddjUYaQnggW5lW
         5k7g==
X-Gm-Message-State: AOAM533LsriPn9K8vWfwxDzMkpbJQoz9SPOhlLnkfHMRXrbCdF9Uzfr2
        tQtIZHZEKyy4oYqNrDa1sJYEyhHRAmKJvhvnKVs0kpicx0evAcn6h3z7l7mHCm427ClV9XdfJvH
        mPNNQOJ4tEnnD0qbp
X-Received: by 2002:a7b:c74b:: with SMTP id w11mr7052447wmk.120.1591165853826;
        Tue, 02 Jun 2020 23:30:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzP9jW6Rsfd2VTCnqrAo+o9JORQHZzZImTA5f+mEAuJg4PHUsougvW0Y8tOcfWNrF5IfN+ohw==
X-Received: by 2002:a7b:c74b:: with SMTP id w11mr7052435wmk.120.1591165853665;
        Tue, 02 Jun 2020 23:30:53 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id q13sm1684498wrn.84.2020.06.02.23.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 23:30:53 -0700 (PDT)
Date:   Wed, 3 Jun 2020 02:30:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603022935-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
 <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
 <20200603013600-mutt-send-email-mst@kernel.org>
 <b7de29fa-33f2-bbc1-08dc-d73b28e3ded5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7de29fa-33f2-bbc1-08dc-d73b28e3ded5@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 02:23:08PM +0800, Jason Wang wrote:
> > 
> > BTW now I re-read it I don't understand __vhost_get_user_slow:
> > 
> > 
> > static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
> >                                            void __user *addr, unsigned int size,
> >                                            int type)
> > {
> >          int ret;
> > 
> >          ret = translate_desc(vq, (u64)(uintptr_t)addr, size, vq->iotlb_iov,
> >                               ARRAY_SIZE(vq->iotlb_iov),
> >                               VHOST_ACCESS_RO);
> > 
> > ..
> > }
> > 
> > how does this work? how can we cast a pointer to guest address without
> > adding any offsets?
> 
> 
> I'm not sure I get you here. What kind of offset did you mean?
> 
> Thanks

OK so points:

1. type argument seems unused. Right?
2. Second argument to translate_desc is a GPA, isn't it?
   Here we cast a userspace address to this type. What if it
   matches a valid GPA by mistake?

-- 
MST

