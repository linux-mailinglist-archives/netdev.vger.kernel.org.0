Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2349BC25
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiAYTcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:32:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbiAYTcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:32:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643139171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ciPfMtAL50TWYFEZLNyqHSn6Da8We+lU53UsYq3iOGI=;
        b=VlIBwN+NQZyEPhm5GQrvRl32KbIGK0nM5njn8pjJvMz85FrsQe9gYRqBYz5BxJWR5n7EGM
        IvIfkHB4+bhNXOCIkeuuUuSIcMTqiDwQhVohs/S8yZDwHZ7EgTanIIbOm/a3P+ProoAXKT
        3RfN9TSpm3yAqxM6mOJf/9ed93yM/Q4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-uniO82IpPkaj9zdYCoZKaQ-1; Tue, 25 Jan 2022 14:32:49 -0500
X-MC-Unique: uniO82IpPkaj9zdYCoZKaQ-1
Received: by mail-ej1-f69.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so3867666ejk.16
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:32:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ciPfMtAL50TWYFEZLNyqHSn6Da8We+lU53UsYq3iOGI=;
        b=Hf3T0mRyr2IAfFq6hxoMLBKK4u2H7pz87zdot9Hz0CRSr+huAWEdaJU5WKqatfIuQS
         I5DygWg/YHScBIKl5Q08DMQMbbFxjU3Rj2K8XcZF0GJWRJkNc1xA2IDtRNPQR4uQcydM
         i5HDpMasWZk8xxoe5Hq0RqVVq4P4l9e1GZqcP3p/3+P90Gs8rRpkBqmxLDgNuLW7vp4G
         TAoQqVv381FcR6IpfjHvtbSSV2067RdK+h5yDQqotf/bv1yf85M3STs8vk3pU5EOYTYH
         OAH4eSGkv4EL7tNPVSEUxBD2KqKqSna2sM49ckaeWFIzB0C5OLVc7mvOpfAGm/XZ3vxc
         xAJA==
X-Gm-Message-State: AOAM53274YSvsqDLfNX7Vu1E6a/8gC7iK3GUcx0MVBAMUWsVo+XLKNBs
        79UriPbL3jwjfY6uzZz5LJu3TXXh7RBE6+/sjWr85l0pCVWcVMdKSPCCdvLARUXjJ1+XuofW8yF
        fCNtmvT5s6loPmPbo
X-Received: by 2002:a05:6402:1104:: with SMTP id u4mr22299208edv.24.1643139168447;
        Tue, 25 Jan 2022 11:32:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmP7u7yUi6Xhu+9fK4nud1OqU+ebd0NePrm49LbmpmCD3peeOVKz96FWzu7vP+O7g76Bsd6A==
X-Received: by 2002:a05:6402:1104:: with SMTP id u4mr22299198edv.24.1643139168220;
        Tue, 25 Jan 2022 11:32:48 -0800 (PST)
Received: from redhat.com ([176.12.185.204])
        by smtp.gmail.com with ESMTPSA id s7sm6518410ejo.212.2022.01.25.11.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:32:47 -0800 (PST)
Date:   Tue, 25 Jan 2022 14:32:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 0/4] vDPA/ifcvf: implement shared IRQ feature
Message-ID: <20220125143151-mutt-send-email-mst@kernel.org>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125091744.115996-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 05:17:40PM +0800, Zhu Lingshan wrote:
> It has been observed that on some platforms/devices, there may
> not be enough MSI vectors for virtqueues and the config change.
> Under such circumstances, the interrupt sources of a device
> have to share vectors/IRQs.
> 
> This series implemented a shared IRQ feature for ifcvf.

Which configurations did you test with this, and what were
the results? Given patch 3 is broken ...


> Please help review.
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
>  drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++------
>  drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 254 ++++++++++++++++++++++++++++----
>  drivers/vhost/vdpa.c            |   3 +
>  4 files changed, 305 insertions(+), 79 deletions(-)
> 
> -- 
> 2.27.0

