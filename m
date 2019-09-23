Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645CCBB8DD
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbfIWQA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 12:00:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732887AbfIWQAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 12:00:55 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98AE880F91
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 16:00:54 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id w9so17869978qto.9
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 09:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FnrZlG9onHbzoUOas395WBpQBkqdPWiXJrz3kgJAMNs=;
        b=DIGjaRIGlf+Ua5lMnA4Bbneb67eSPkvljB87cxCigAqZ1rKsA5QmLVHpxf6LP0ckhp
         qNyA9iD36Rp4OCuOgm+4/941KcXOjXE+CqKJ5uMz7ioYI+ZeHoN9ZtVECygQ+m2DUHYV
         U8HVDf47r07cwI3D+LOMUjV5xku9F3+fxiUNMcLFDdH4lwMT2KHgSVJOD6s8YV/9ZErE
         Du1yC8V++4BPcRRvD04ZAo0/X1+yFMBYjmy/jj715txnPFPxAkXDwnMb3LLzvd1j5bCf
         vGYSi9oB1UhKfVFusnsY2vAxQd9ygye0dL9hV7oieomwlAgmU51HsPdnaAMHlRupjRZB
         wMIg==
X-Gm-Message-State: APjAAAUadFUuqsS6v29Fkcri8NxbepqUtFeTIKszD1/6QAxA2quExf3e
        BOR2t7wiM/+39r1cMsUIq2yy35pj+WFFO4jCqVyrRp0NxCB9erIsI7t1wA3wAZC5k+T2eYkBGCz
        ch5TszmPyvmCK4WUY
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr25662869qvl.38.1569254453754;
        Mon, 23 Sep 2019 09:00:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzeS0qH7VWztyzQkjfFK33LHuBL/0r9aVYJeACu8zWG4i5I+VaFWBP3hOAewtn9oF8WJysLNw==
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr25662820qvl.38.1569254453463;
        Mon, 23 Sep 2019 09:00:53 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id m125sm5840827qkd.3.2019.09.23.09.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 09:00:52 -0700 (PDT)
Date:   Mon, 23 Sep 2019 12:00:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        tiwei.bie@intel.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com
Subject: Re: [PATCH 5/6] vringh: fix copy direction of vringh_iov_push_kern()
Message-ID: <20190923115930-mutt-send-email-mst@kernel.org>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-6-jasowang@redhat.com>
 <20190923094559.765da494@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923094559.765da494@x1.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 09:45:59AM -0600, Alex Williamson wrote:
> On Mon, 23 Sep 2019 21:03:30 +0800
> Jason Wang <jasowang@redhat.com> wrote:
> 
> > We want to copy from iov to buf, so the direction was wrong.
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/vhost/vringh.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> 
> Why is this included in the series?  Seems like an unrelated fix being
> held up within a proposal for a new feature.  Thanks,
> 
> Alex

It's better to have it as patch 1/6, but it's a dependency of the
example driver in the series. I can reorder when I apply.


> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 08ad0d1f0476..a0a2d74967ef 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, size_t len)
> >  	return 0;
> >  }
> >  
> > +static inline int kern_xfer(void *dst, void *src, size_t len)
> > +{
> > +	memcpy(dst, src, len);
> > +	return 0;
> > +}
> > +
> >  /**
> >   * vringh_init_kern - initialize a vringh for a kernelspace vring.
> >   * @vrh: the vringh to initialize.
> > @@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
> >  ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
> >  			     const void *src, size_t len)
> >  {
> > -	return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
> > +	return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
> >  }
> >  EXPORT_SYMBOL(vringh_iov_push_kern);
> >  
