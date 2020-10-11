Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD38E28A60C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 08:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgJKGqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 02:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728549AbgJKGqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 02:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602398761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJ3BlgkCnk7q4i6A6rDWI4Y07VULo0UVj4WHUXEfZVc=;
        b=f9Bub+zJsXKCwuhmFlyWlUR8keZUGJ0ceSnNH3YD29+Vj8WGVEmnPq0t7c777GNqpYsIKn
        dLgHRUBADz4DQ0oWS49TieBGVO6BsGlCWmuOybHzHVqR9i20H3OtmFvNDPF1uSt0CWuIFG
        +uiFIH0olqR8FUAE4f62d6TE7y+8+pQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-D9Unr-EQPPOycmFI2woWSQ-1; Sun, 11 Oct 2020 02:45:57 -0400
X-MC-Unique: D9Unr-EQPPOycmFI2woWSQ-1
Received: by mail-wr1-f69.google.com with SMTP id b6so7416270wrn.17
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 23:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dJ3BlgkCnk7q4i6A6rDWI4Y07VULo0UVj4WHUXEfZVc=;
        b=AfaQtbxg+V4yo466hgUulxUobl5+mlW0QeUDF8NfQdI5RyHQq2nMGu08s68olXJnEC
         JUevCeuUXe1ojIFIprEIq7bD5xBs1yyZ1yLnbxh/xMC65vEGvhdIW4hHj8w5wHQEa6JS
         7Yt7mAP/8CXbzRzFid/IyzRId4rqIx8smqhV7HZOxusosyFzBXYWlPFN8rzY/xyxUc/j
         kIinz8/kBTZlXJBuU3ZUwJUjL+F50jKdECeXYT715M4tUkLTRA0ZEcAnj2pd/La8QIgG
         Aahb3iK0kKaoy77ukywih4cJrVdggu+WhjP1KYGw4i8Yzp8uRa1OYYr/bYqktjncIf+o
         DwSA==
X-Gm-Message-State: AOAM531tAJkmcQgoGSg5LVJD0bXP7Y1UcbgcCMgHgqZ6aIb6KLrASMVL
        YEpzxT0y4Q20jOPdVLXNEcqWjDnjBvzOKdHJvav8e8e4xa/lYyC7CioZOScBbv5fyFvg2nCfxQB
        roJLfKn1nvYgTDsRw
X-Received: by 2002:a7b:c183:: with SMTP id y3mr5518157wmi.84.1602398755967;
        Sat, 10 Oct 2020 23:45:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymVd3zPBGJk+gsm5hB6NEr0sdsOHn19hXK54y5exKXDFRh+F/ZOFStkaryviOkX38fGRPEVg==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr5518140wmi.84.1602398755755;
        Sat, 10 Oct 2020 23:45:55 -0700 (PDT)
Received: from redhat.com (bzq-79-179-76-41.red.bezeqint.net. [79.179.76.41])
        by smtp.gmail.com with ESMTPSA id y66sm1509945wmd.14.2020.10.10.23.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 23:45:55 -0700 (PDT)
Date:   Sun, 11 Oct 2020 02:45:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, lingshan.zhu@intel.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] vhost-vdpa: fix vhost_vdpa_map() on error
 condition
Message-ID: <20201011024533-mutt-send-email-mst@kernel.org>
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-2-git-send-email-si-wei.liu@oracle.com>
 <a780b2e2-d8ce-4c27-df6b-47523c356d02@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a780b2e2-d8ce-4c27-df6b-47523c356d02@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 09:48:42AM +0800, Jason Wang wrote:
> 
> On 2020/10/3 下午1:02, Si-Wei Liu wrote:
> > vhost_vdpa_map() should remove the iotlb entry just added
> > if the corresponding mapping fails to set up properly.
> > 
> > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > ---
> >   drivers/vhost/vdpa.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 796fe97..0f27919 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -565,6 +565,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> >   			      perm_to_iommu_flags(perm));
> >   	}
> > +	if (r)
> > +		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
> > +
> >   	return r;
> >   }
> 
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

Linus already merged this, I can't add your ack, sorry!

-- 
MST

