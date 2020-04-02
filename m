Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF87119C463
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbgDBOgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:36:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732602AbgDBOgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585838210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlR2TRXNoUHH0cejtWwgFkeiMST3WWqkeQGN0pr6VCA=;
        b=gXzhi9blke8Ut2CtjcEE6gO0ne7PXiA24skhNMy8llV4Sw9g6HSx7iSTZIZZXWvd1KGjd/
        7hQ6aWPny5UFuLDJNcn/DSkvCjfXmSnq2s7oiG2YPfYiHsRxo9gpFAHcalv+o7EYG3z9wz
        L+PmxMNB25odJov8tdUDa7IltOt2VIw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-biwGaw8nMieTEamgTjM4Hg-1; Thu, 02 Apr 2020 10:36:48 -0400
X-MC-Unique: biwGaw8nMieTEamgTjM4Hg-1
Received: by mail-qv1-f70.google.com with SMTP id d2so2845914qve.11
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WlR2TRXNoUHH0cejtWwgFkeiMST3WWqkeQGN0pr6VCA=;
        b=Elk2J0ftHqZQ0+qR2N4UkugPgAourFuS4vYTIpQ/60PZXzwqL/5n97lRsnjBETH/uD
         /jJ5YFuwbBkesNrmYnxdVRrFvdVPQs6M5L5EkaW1lUnYHgYOu6Q3wfubJuCXBAfE2Bwh
         f9xNN3Sq3KaAH5H7rUBv9088uVmztf1dH9ijVtvLWZUawDnCsbJQraagqvOrPIKMMfOU
         zZEwt4z7/VXTSPF3we6uayuL25yl5rET4dOD4wNS3c9FvK33e68cX8RnvTuNmr4+GBfn
         XlMZj1tkswTFzKhK2P9uDHQ0gn1Pmu0waPKXb9EX70aOtuwHsucfdNOGLpoqVuGaXfmB
         T3vw==
X-Gm-Message-State: AGi0PuYCmlhxFgbPv//hFVl45/AYizOcA7IouvMiwf9XfcYiDQCKqgRg
        FUOfpXiZOGKZc3k8+y9H+zhkb0z6qPuQjCUyDPrJ/R7tJgfDH+GvFEfD3BviSDAMfRHvXs2I6wJ
        dBDNNezrqhjLgwyXz
X-Received: by 2002:ac8:1bf5:: with SMTP id m50mr3204224qtk.200.1585838208361;
        Thu, 02 Apr 2020 07:36:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJIJxmszAzRx8icml77RBvawgNMOKh/hgQNez6YoUnUaICm+K3+fAJ0a9bgYwRVNdObKb/nbw==
X-Received: by 2002:ac8:1bf5:: with SMTP id m50mr3204184qtk.200.1585838207990;
        Thu, 02 Apr 2020 07:36:47 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id u40sm3854770qtc.62.2020.04.02.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:36:47 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:36:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: drop vring dependency on iotlb
Message-ID: <20200402103551-mutt-send-email-mst@kernel.org>
References: <20200402141207.32628-1-mst@redhat.com>
 <afe230b9-708f-02a1-c3af-51e9d4fdd212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afe230b9-708f-02a1-c3af-51e9d4fdd212@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 10:28:28PM +0800, Jason Wang wrote:
> 
> On 2020/4/2 下午10:12, Michael S. Tsirkin wrote:
> > vringh can now be built without IOTLB.
> > Select IOTLB directly where it's used.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > This is on top of my previous patch (in vhost tree now).
> > 
> >   drivers/vdpa/Kconfig  | 1 +
> >   drivers/vhost/Kconfig | 1 -
> >   2 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > index 7db1460104b7..08b615f2da39 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -17,6 +17,7 @@ config VDPA_SIM
> >   	depends on RUNTIME_TESTING_MENU
> >   	select VDPA
> >   	select VHOST_RING
> > +	select VHOST_IOTLB
> >   	default n
> >   	help
> >   	  vDPA networking device simulator which loop TX traffic back
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index 21feea0d69c9..bdd270fede26 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -6,7 +6,6 @@ config VHOST_IOTLB
> >   config VHOST_RING
> >   	tristate
> > -	select VHOST_IOTLB
> >   	help
> >   	  This option is selected by any driver which needs to access
> >   	  the host side of a virtio ring.
> 
> 
> Do we need to mention driver need to select VHOST_IOTLB by itself here?
> 
> Thanks
> 

OK but I guess it's best to do it near where VHOST_IOTLB is defined.
Like this?


diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index bdd270fede26..ce51126f51e7 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -3,6 +3,8 @@ config VHOST_IOTLB
 	tristate
 	help
 	  Generic IOTLB implementation for vhost and vringh.
+	  This option is selected by any driver which needs to support
+	  an IOMMU in software.
 
 config VHOST_RING
 	tristate

