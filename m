Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0349CC02
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiAZOON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:14:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235430AbiAZOOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643206450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIHOSHa8eGkKGGsPkDgJCA6OjwUd7QYCWYjmU+mG6O0=;
        b=YjGsliaLe+GJEvnt/Y+5wUXLcVzxsSmrMS8pZV3zvBcqkq1CxptHcYqRMXwm/30ryL8NDR
        KdmobClCuIx3EzHWBO9vyyhWCSkRGC6CoYMnche4CHXITN3jo1SGLPrlhPZ+g0MsuxLYtv
        lrfG+0ktx1aRGfEJ9WxKKGSQmWQiSko=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-wjvQ7gc8NlKlmSW1W7HFxA-1; Wed, 26 Jan 2022 09:14:09 -0500
X-MC-Unique: wjvQ7gc8NlKlmSW1W7HFxA-1
Received: by mail-wr1-f71.google.com with SMTP id r26-20020adfab5a000000b001d67d50a45cso4336907wrc.18
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:14:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sIHOSHa8eGkKGGsPkDgJCA6OjwUd7QYCWYjmU+mG6O0=;
        b=WJUe6ExH96NcAHZ55ODwLQ71VabWzS454oP3HrmQBSbwBYi+yxhtsKDhTHaju3yfCQ
         GDNtNEQ56/CxYZHT2hvEymg5/cdck/4j2twR0w53CSXlVuDtMOq1g+I7wpoBP0fnYZbe
         l5mMKraBEVR11Hcy/MVfbSlxOpSlJikx8/iPx+UgwACD95rSJ8SMsbqlrcA2LNntNxwF
         Z13kmvFKuJayA4jjOTLYvpliVi/xNmVtOHwgW92a7uNRMULk3H7oml8yrnD4Gy3d2Ydi
         3r+vEIxFUl0xKV9S04WRcvO+M7e7oQzZewa+JDGTLuKug/neAmSwQiUogDTlvWH1ACV8
         KZFQ==
X-Gm-Message-State: AOAM5320Sk6eIiRT8SncfYTvlGxgJ6+Iu5jfa/rBO4K+vb1Tv7gzmmtd
        C9jFZReaPL4RGzSdvA+rX61xsTgBkF3majLq1tX7/rKdUZf7Fdcyf93zqvAkw18r0m44ZOHk+wt
        u8fks3ZdvON0+l40d
X-Received: by 2002:a7b:c181:: with SMTP id y1mr7547568wmi.137.1643206447918;
        Wed, 26 Jan 2022 06:14:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxsuOF3MaH44FkbRm4WHcKCRq305PlEtcSv3SMmq9JgF98lmfEoXB0+wfRuQwNcMIKUfVgdQ==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr7547554wmi.137.1643206447732;
        Wed, 26 Jan 2022 06:14:07 -0800 (PST)
Received: from redhat.com ([2.55.9.226])
        by smtp.gmail.com with ESMTPSA id n14sm12369103wri.75.2022.01.26.06.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 06:14:07 -0800 (PST)
Date:   Wed, 26 Jan 2022 09:14:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 0/4] vDPA/ifcvf: implement shared IRQ feature
Message-ID: <20220126091329-mutt-send-email-mst@kernel.org>
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126124912.90205-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 08:49:08PM +0800, Zhu Lingshan wrote:
> It has been observed that on some platforms/devices, there may
> not be enough MSI vectors for virtqueues and the config change.
> Under such circumstances, the interrupt sources of a device
> have to share vectors/IRQs.
> 
> This series implemented a shared IRQ feature for ifcvf.
> 
> Please help review.

Given the history, can you please report which tests
were performed with this patchset? Which configs tested?
Thanks?

> Changes from V2:
> (1) Fix misuse of nvectors(in ifcvf_alloc_vectors return value)(Michael)
> (2) Fix misuse of irq = get_vq_irq() in setup irqbypass(Michael)
> (3) Coding style improvements(Michael)
> (4) Better naming of device shared irq/shared vq irq
> 
> Changes from V1:
> (1) Enable config interrupt when only one vector is allocated(Michael)
> (2) Clean vectors/IRQs if failed to request config interrupt
> since config interrupt is a must(Michael)
> (3) Keep local vdpa_ops, disable irq_bypass by setting IRQ = -EINVAL
> for shared IRQ case(Michael)
> (4) Improvements on error messages(Michael)
> (5) Squash functions implementation patches to the callers(Michael)
> 
> Zhu Lingshan (4):
>   vDPA/ifcvf: implement IO read/write helpers in the header file
>   vDPA/ifcvf: implement device MSIX vector allocator
>   vhost_vdpa: don't setup irq offloading when irq_num < 0
>   vDPA/ifcvf: implement shared IRQ feature
> 
>  drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++-----
>  drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 260 ++++++++++++++++++++++++++++----
>  drivers/vhost/vdpa.c            |   4 +
>  4 files changed, 312 insertions(+), 79 deletions(-)
> 
> -- 
> 2.27.0

