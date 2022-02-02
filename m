Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8A4A6FDF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343898AbiBBLYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:24:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbiBBLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643801053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVSUqNEz2jDEjuO9vqQ6YiHSzS42/Um2cKAf3ocZuFc=;
        b=cPEM4gdezrn4Z1fk/B8+YiaVYhPDaXgh0/NAsz8+Cv6qvcKuUwH+xbSZXVPQaxE80KHHvZ
        p8BBqyagPVGCpw9pIkG8hMcA6IrvwKZMD175kL65sy2QeZoqk/TrA2KjzacRockVxVMyzL
        N2eDM0CzSQp+4VFigF/CtXt5/XqyZtA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-pFJtjkLINzCHBbwVnOaBJA-1; Wed, 02 Feb 2022 06:24:12 -0500
X-MC-Unique: pFJtjkLINzCHBbwVnOaBJA-1
Received: by mail-wr1-f71.google.com with SMTP id t14-20020adfa2ce000000b001e1ad2deb3dso1609039wra.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 03:24:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wVSUqNEz2jDEjuO9vqQ6YiHSzS42/Um2cKAf3ocZuFc=;
        b=JY+CPDfXMuB4j9dNyIjgBAqd9taVh3zlA6mlUDzTPV8S/lixA9+d8x81s5cWkOzXgl
         IbR0uJaV3eS8CwDydYgZ+AwvqUR1/8kv/5tU3MvKiU6RBBJOYHI8El1KujpqxwulV/8i
         ZrzcspIldlredyI2DIXKqDJMuIXGcPQylmxZX5IyiVCUu1YeEbsXyUMrSPvqdS5qALqC
         ylJUk735Ww8iVdpyrcnPnvFtez1RcPTuj1OaNUC7g3YIdnFor+0WuoDIz0T9akBETH5y
         BvZ5FwDwKT9smylwWdrnUMHqYYWyhSuIygi1LCsY7V9DsH7x4VNDXvDNgCu6jRLJueSL
         X15w==
X-Gm-Message-State: AOAM530M2TaSrmB6kmxCchRXxXIlc6GsPGzqCQCj+BCssy+9DXWAZqcV
        1NguMSBMMMQA//uhEzjD9SG+eAk0SNr7VychwOEElQZQSVlkZ1eV222U6k1WlP+mR3VdPLYJ6kA
        YCLzb55vC0z/npePj
X-Received: by 2002:adf:eb83:: with SMTP id t3mr24004832wrn.240.1643801051273;
        Wed, 02 Feb 2022 03:24:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2Azzg5CZ10Dv4Exq5q/4lmS9rKnBzuf3jhyJbt3gpU5+v7KjQRr2AcoAMrPFvDcBLPf9iag==
X-Received: by 2002:adf:eb83:: with SMTP id t3mr24004815wrn.240.1643801051038;
        Wed, 02 Feb 2022 03:24:11 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id g6sm5047158wmq.3.2022.02.02.03.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 03:24:09 -0800 (PST)
Date:   Wed, 2 Feb 2022 06:24:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220202062340-mutt-send-email-mst@kernel.org>
References: <20220128094129.40809-1-sgarzare@redhat.com>
 <Yfpnlv2GudpPFwok@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfpnlv2GudpPFwok@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 11:14:30AM +0000, Stefan Hajnoczi wrote:
> On Fri, Jan 28, 2022 at 10:41:29AM +0100, Stefano Garzarella wrote:
> > In vhost_enable_notify() we enable the notifications and we read
> > the avail index to check if new buffers have become available in
> > the meantime.
> > 
> > We do not update the cached avail index value, so when the device
> > will call vhost_get_vq_desc(), it will find the old value in the
> > cache and it will read the avail index again.
> > 
> > It would be better to refresh the cache every time we read avail
> > index, so let's change vhost_enable_notify() caching the value in
> > `avail_idx` and compare it with `last_avail_idx` to check if there
> > are new buffers available.
> > 
> > We don't expect a significant performance boost because
> > the above path is not very common, indeed vhost_enable_notify()
> > is often called with unlikely(), expecting that avail index has
> > not been updated.
> > 
> > We ran virtio-test/vhost-test and noticed minimal improvement as
> > expected. To stress the patch more, we modified vhost_test.ko to
> > call vhost_enable_notify()/vhost_disable_notify() on every cycle
> > when calling vhost_get_vq_desc(); in this case we observed a more
> > evident improvement, with a reduction of the test execution time
> > of about 3.7%.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > v3
> > - reworded commit description [Stefan]
> > ---
> >  drivers/vhost/vhost.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe2..07363dff559e 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
> >  		       &vq->avail->idx, r);
> >  		return false;
> >  	}
> > +	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
> >  
> > -	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
> > +	return vq->avail_idx != vq->last_avail_idx;
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_enable_notify);
> 
> This changes behavior (fixes a bug?): previously the function returned
> false when called with avail buffers still pending (vq->last_avail_idx <
> vq->avail_idx). Now it returns true because we compare against
> vq->last_avail_idx and I think that's reasonable.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

I don't see the behaviour change... could you explain the
scanario in more detail pls?

Thanks!

