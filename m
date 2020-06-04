Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3101EEA8B
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 20:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgFDSuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 14:50:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43195 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728780AbgFDSuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 14:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591296644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6snlKjU8aRgZULuYnJpe7wNQI9bh2ev/bXaAzVSEvQ=;
        b=WmLl8KBQrOUEGCtp9YoGxmRFPdxgBNUh+NdrV+asBoOHDzqPKZqPR3GVYCyZoBJ11FbsJW
        WI1eq9K3RFxYiMoxl0uITD4p6j2d6B3LM24Hhi8G/BE/hO06XSM0HWUzqFqd0c4V5H1B6Z
        UgoqP4RLZ5z4hCdhuLhlMBFdIRHLmjI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-acqcj_hDMgqYnvbto2rndQ-1; Thu, 04 Jun 2020 14:50:43 -0400
X-MC-Unique: acqcj_hDMgqYnvbto2rndQ-1
Received: by mail-wr1-f70.google.com with SMTP id e7so2789498wrp.14
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 11:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=W6snlKjU8aRgZULuYnJpe7wNQI9bh2ev/bXaAzVSEvQ=;
        b=AkgLdM0YOrVAzPYgy9HWz4o6ta4q6ek3OxZokN2LG9j7WGrlKTpkDtZMEUYEcag3hK
         0sb2wE2fOP2dXiJ5iPMR61CMUSl/KZ9OGcSY7ARuNoCWIDi9EXSoZDW7FxfOULfRSks7
         El48zcAklx4bTcDBFcYr1UI86lpV3BX/F+zF93vhjceLO+r1zJjjdf5rpDtvtJD0dWe4
         rnD8Io2mclTsIWrxqtsx8DXf9HxGuzkORycbSAzXyrLA0ilJAQ8cK/v/RS5u33W0otEk
         sCnkKrARYS9wp/jG/ctIyyBX9k0OV0INQLxwhJ36H/vu43rWFXAYy8rRNgZRFhQOMFUo
         BOFg==
X-Gm-Message-State: AOAM533iKAUBCCUr2A1JkaRvjoekioDqhHOD5f8+zykf1xFOxMZeD4mK
        70clG2l1w4CMPhXxxRUYq/eAUZXhUtkjVms2NSem0bSVOmQWmfp89paV30OOM3rQ5cyF6yXhDB2
        uOS2BFuM1y6f/tJk7
X-Received: by 2002:a1c:b656:: with SMTP id g83mr5563943wmf.151.1591296641701;
        Thu, 04 Jun 2020 11:50:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFWuENQHpNppZbCtXmj/W7gbwDx2OeFjgcac3birrs4llztufXXrEhiTnzIxGTS74oUPNMZw==
X-Received: by 2002:a1c:b656:: with SMTP id g83mr5563911wmf.151.1591296641446;
        Thu, 04 Jun 2020 11:50:41 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id d24sm8081830wmb.45.2020.06.04.11.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 11:50:40 -0700 (PDT)
Date:   Thu, 4 Jun 2020 14:50:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200604145002-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010809-mutt-send-email-mst@kernel.org>
 <e722bb62-2a72-779a-f542-1096e8f609b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e722bb62-2a72-779a-f542-1096e8f609b8@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 03:12:27PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午1:09, Michael S. Tsirkin wrote:
> > On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
> > > Note that since virtio specification does not support get/restore
> > > virtqueue state. So we can not use this driver for VM. This can be
> > > addressed by extending the virtio specification.
> > Looks like exactly the kind of hardware limitation VDPA is supposed to
> > paper over within guest. So I suggest we use this as
> > a litmus test, and find ways for VDPA to handle this without
> > spec changes.
> 
> 
> Yes, and just to confirm, do you think it's beneficial to extend virtio
> specification to support state get/set?
> 
> Thanks

Let's leave that for another day. For now vdpa should be flexible enough
to work on spec compliant VMs.

> 
> > 

