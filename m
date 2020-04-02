Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D219C707
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389781AbgDBQ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 12:27:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731842AbgDBQ1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 12:27:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585844837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YiGejvc/Z1PscIO5Y2Td9wzrTW6YFSsKAEAcda9xkVg=;
        b=dhE5SrImN9eHxrTL9BOO3EPsDioxY1EIiRdxduuxgF5hHNG3kvPu/lIA0D9U3U/zebDGCs
        6L9OTouU/BS0+NVEd3IkeBGTHdRlzF22fymJleL87S3pyutXuuHRZr6Yd/P9IY4Xlk7Pk1
        QYXxz6u6ZZtoYZ/W1kcGCOoHXSZ1rio=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-SQKBzPnAN3-5exjNVT5H0w-1; Thu, 02 Apr 2020 12:27:15 -0400
X-MC-Unique: SQKBzPnAN3-5exjNVT5H0w-1
Received: by mail-qv1-f71.google.com with SMTP id v4so3190683qvt.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 09:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YiGejvc/Z1PscIO5Y2Td9wzrTW6YFSsKAEAcda9xkVg=;
        b=mBXmMlxpDdyYX6kSnWbavDrcNfkWGn9tGOLTuzBpnhDBPVp+2l4FDNiBFxR4jcA5FG
         mwTBscd1nGPveVoW0dZDFGcMo94msug9hIorbMy+aYs6YZDp60cQc5O2iaAHiAZqF/zC
         tEzwgNSW6tzP3d386TTrjE/IGoxi/OyHhqKPjkrdIznH/RjmJb8VKazJP5UtPrV9OnqN
         POkQG1NgKK/nyh5o0AQMTMXU5dC2pgCBJDsCgl0YrFBL32rqC9V9NDIMdWEGFqb13/YK
         S/ZrMsoOVVcNw3Lk1ZbvwxcZdxp2/C1sqsgqHXZjdlbPFqzDOZOKSVYgjgm6fGWGFvgc
         shsA==
X-Gm-Message-State: AGi0PuaTXftU4mELmIVAasiEpSTn1zgvT/PmaiH32oF8tg/VUkapkwsW
        vinpoImlk7zopG/GoRQffYU53mEGvVwPzCHQo+wWNuAK+rKyxFuiaoRawlxUHasv8mV9y87GeVa
        +y+wIeAiyuQwmAQRZ
X-Received: by 2002:ac8:4641:: with SMTP id f1mr3595343qto.216.1585844834571;
        Thu, 02 Apr 2020 09:27:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypI9uiNgZebAWGTM/6pTKMcpl2+Pbh6hcnrsxur+SijZm8gBzgmehd7nG3POHrAdyCwNw6XVFw==
X-Received: by 2002:ac8:4641:: with SMTP id f1mr3595317qto.216.1585844834186;
        Thu, 02 Apr 2020 09:27:14 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id v17sm3764796qkf.83.2020.04.02.09.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 09:27:13 -0700 (PDT)
Date:   Thu, 2 Apr 2020 12:27:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: drop vring dependency on iotlb
Message-ID: <20200402122544-mutt-send-email-mst@kernel.org>
References: <20200402144519.34194-1-mst@redhat.com>
 <44f9b9d3-3da2-fafe-aa45-edd574dc6484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44f9b9d3-3da2-fafe-aa45-edd574dc6484@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 11:01:13PM +0800, Jason Wang wrote:
> 
> On 2020/4/2 下午10:46, Michael S. Tsirkin wrote:
> > vringh can now be built without IOTLB.
> > Select IOTLB directly where it's used.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Applies on top of my vhost tree.
> > Changes from v1:
> > 	VDPA_SIM needs VHOST_IOTLB
> 
> 
> It looks to me the patch is identical to v1.
> 
> Thanks


you are right. I squashed the description into
    virtio/test: fix up after IOTLB changes
take a look at it in the vhost tree.

> 
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
> > index f0404ce255d1..cb6b17323eb2 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -8,7 +8,6 @@ config VHOST_IOTLB
> >   config VHOST_RING
> >   	tristate
> > -	select VHOST_IOTLB
> >   	help
> >   	  This option is selected by any driver which needs to access
> >   	  the host side of a virtio ring.

