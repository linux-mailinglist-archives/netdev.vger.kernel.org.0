Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4A1EE8D9
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgFDQt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 12:49:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729115AbgFDQt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 12:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591289366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OyLW1fac7NAPSEDPillI/dC2V76rxOcNx4vyXYfjc8=;
        b=eGu0qCkSURsJ8P3ylYtAXpPSXNVI2dLXOQoG0resCQY9eKrVdRw5hlSJzI4DFyy8ZiIIS9
        OEcogmOgwg9I+pMDHCREQH2EnroMZK0IHW36OaJEh2y+9GLuIW4ug63W5FfxIQiNMAs4AK
        Fl0GHMPYCMinyFE0qTFQQQ4jFtxOhgI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-Rrmhv1J8PZ6KMDqxYGj4pQ-1; Thu, 04 Jun 2020 12:49:24 -0400
X-MC-Unique: Rrmhv1J8PZ6KMDqxYGj4pQ-1
Received: by mail-wr1-f72.google.com with SMTP id d6so2655163wrn.1
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 09:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4OyLW1fac7NAPSEDPillI/dC2V76rxOcNx4vyXYfjc8=;
        b=uPFHJ5ti1/t7nQv20K2Jb88HTEoHAqKdGWplQwDwhtGRL1swIS0V/S9LrWjv9Hly/M
         fUTqV8ZM0LycuDNuf+U+OFdIHvtITHu9ZYWLhj2LUQFybaXoSVtNaAbCgg3t24w5M+o0
         HVZXe8fncFcaW0jwRAU6kh+O2GVa9qWm5+DQ5ZZrF8x/3wS0dNYUVLjj6GedVDGn010a
         I13FqkEket5pRWTmCK/pgYgodm2+q9UO8sx9dungytY8ue07z43Nur4NKgB1+X/XNOe2
         sZ6QmiWJ3mmA25MlKShTFR7rIZWm+tNkiNTZCJ2h/jOYePiL2GNnkdGVxd7rT7Ndnlfw
         cBvw==
X-Gm-Message-State: AOAM5316SgcwVDsz30wnYk0+a014Qc7v4uwGmmz0jkj8Khc7u7E1bqy8
        jd4Jd/STwqjahhea92z8Drw/OUYrzvSVlzBlPp25f0u/IM6ZY268oAajbzfd5wmJ3P+8qseiIGa
        3G+bvMrC6ElTXIJos
X-Received: by 2002:a5d:6750:: with SMTP id l16mr5253168wrw.295.1591289363284;
        Thu, 04 Jun 2020 09:49:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVBDu1CM90gAbOMzZLoWqlTv+bJxu4SVKEUrZgDNQq6aXeykhZDiXa7/pj91dzrPxrz7r/xA==
X-Received: by 2002:a5d:6750:: with SMTP id l16mr5253133wrw.295.1591289362681;
        Thu, 04 Jun 2020 09:49:22 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id j11sm8559836wru.69.2020.06.04.09.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 09:49:22 -0700 (PDT)
Date:   Thu, 4 Jun 2020 12:49:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604124759-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
 <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
 <20200603013600-mutt-send-email-mst@kernel.org>
 <b7de29fa-33f2-bbc1-08dc-d73b28e3ded5@redhat.com>
 <20200603022935-mutt-send-email-mst@kernel.org>
 <f0573536-e6cc-3f68-5beb-a53c8e1d0620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0573536-e6cc-3f68-5beb-a53c8e1d0620@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 02:36:46PM +0800, Jason Wang wrote:
> 
> On 2020/6/3 下午2:30, Michael S. Tsirkin wrote:
> > On Wed, Jun 03, 2020 at 02:23:08PM +0800, Jason Wang wrote:
> > > > BTW now I re-read it I don't understand __vhost_get_user_slow:
> > > > 
> > > > 
> > > > static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
> > > >                                             void __user *addr, unsigned int size,
> > > >                                             int type)
> > > > {
> > > >           int ret;
> > > > 
> > > >           ret = translate_desc(vq, (u64)(uintptr_t)addr, size, vq->iotlb_iov,
> > > >                                ARRAY_SIZE(vq->iotlb_iov),
> > > >                                VHOST_ACCESS_RO);
> > > > 
> > > > ..
> > > > }
> > > > 
> > > > how does this work? how can we cast a pointer to guest address without
> > > > adding any offsets?
> > > 
> > > I'm not sure I get you here. What kind of offset did you mean?
> > > 
> > > Thanks
> > OK so points:
> > 
> > 1. type argument seems unused. Right?
> 
> 
> Yes, we can remove that.
> 
> 
> > 2. Second argument to translate_desc is a GPA, isn't it?
> 
> 
> No, it's IOVA, this function will be called only when IOTLB is enabled.
> 
> Thanks

Right IOVA. Point stands how does it make sense to cast
a userspace pointer to an IOVA? I guess it's just
because it's talking to qemu actually, so it's abusing
the notation a bit ...

> 
> >     Here we cast a userspace address to this type. What if it
> >     matches a valid GPA by mistake?
> > 

