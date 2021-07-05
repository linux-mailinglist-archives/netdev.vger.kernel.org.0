Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693023BC29C
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGES3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 14:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229743AbhGES3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 14:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625509599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRRrtMgruURgChxNxWwRZrL7plq4LfVLAvPpmCv92RU=;
        b=XK91vIPuiVFWkedjaL15FkF9kQ0Lf63CoDdb5obdvVFh2eGhoPW1yPCYAKvSGuDryQ+hT/
        GK/IuCui3kaWp+n8HJtjoc8rzSvJKVOhNMFptQVSMLLg8q275u3ZSROij6kfBLW8I43gQP
        iN0DSt9gGyWn6236d84/Ceb7vdps9aA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-9vR1nEn2MY-iRET2s-iePw-1; Mon, 05 Jul 2021 14:26:38 -0400
X-MC-Unique: 9vR1nEn2MY-iRET2s-iePw-1
Received: by mail-wr1-f70.google.com with SMTP id u13-20020a5d6dad0000b029012e76845945so4390076wrs.11
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 11:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRRrtMgruURgChxNxWwRZrL7plq4LfVLAvPpmCv92RU=;
        b=rTLWt1zTwLWrdiqvz86Z5CCAna+A7GM+ZZoO63hojAjedWvjzSZjirgb72jLf024h2
         wmg7kCTTM3XelSK4R3iwUMwFS7P+USaH20FusnqjUrtcCncLiq9Qg3/T92ZrA85152n1
         GgSRDhrLvubYTZpMg41Rbh2cKCgX/ySInhKYw0KDvqFyscb5nqWOfaHGNaIqERDqUk0A
         C2kx6uUGs/xrl2PMaBR2zKqfXWq0SQxbv/gsBkV2hnEwMCFjDCHOgRviCp4qzeWI3LTx
         0A+vmIL6Ue0KePfe/RbocXE+qkHtuRTFwHE3EwB8e6zKMnrGyDN6I33hVyMl7owlZGaC
         O3hA==
X-Gm-Message-State: AOAM533zCfAvCnx3KdRw1xK8XwB7maO9c7kswsk4QTfv1H9eJqu4vEke
        YC4f1OC/iP6W+YvwCHUh3kOG9uFqb7heRtxAXjdTkr6tEdAryyDDUA76kAgY1inW/EIkF55RtVJ
        gbQoWY9nX0N5LqmL4
X-Received: by 2002:a1c:2142:: with SMTP id h63mr16343516wmh.84.1625509597595;
        Mon, 05 Jul 2021 11:26:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxg6lV2mV2E4Ksstg1b9UaYYm1/na0HeVq/bH0oy4JNEBKaSdID8JncYLnj87O5OZ1B8dHdg==
X-Received: by 2002:a1c:2142:: with SMTP id h63mr16343485wmh.84.1625509597375;
        Mon, 05 Jul 2021 11:26:37 -0700 (PDT)
Received: from redhat.com ([2.55.8.91])
        by smtp.gmail.com with ESMTPSA id n8sm13899936wrt.95.2021.07.05.11.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:26:36 -0700 (PDT)
Date:   Mon, 5 Jul 2021 14:26:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        nickhu@andestech.com, green.hu@gmail.com, deanbo422@gmail.com,
        akpm@linux-foundation.org, yury.norov@gmail.com, ojeda@kernel.org,
        ndesaulniers@gooogle.com, joe@perches.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
Message-ID: <20210705142555-mutt-send-email-mst@kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
 <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 08:06:50PM +0800, Yunsheng Lin wrote:
> On 2021/7/5 17:56, Andy Shevchenko wrote:
> > On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
> >> tools/include/* have a lot of abstract layer for building
> >> kernel code from userspace, so reuse or add the abstract
> >> layer in tools/include/ to build the ptr_ring for ringtest
> >> testing.
> > 
> > ...
> > 
> >>  create mode 100644 tools/include/asm/cache.h
> >>  create mode 100644 tools/include/asm/processor.h
> >>  create mode 100644 tools/include/generated/autoconf.h
> >>  create mode 100644 tools/include/linux/align.h
> >>  create mode 100644 tools/include/linux/cache.h
> >>  create mode 100644 tools/include/linux/slab.h
> > 
> > Maybe somebody can change this to be able to include in-tree headers directly?
> 
> If the above works, maybe the files in tools/include/* is not
> necessary any more, just use the in-tree headers to compile
> the user space app?
> 
> Or I missed something here?

why would it work? kernel headers outside of uapi are not
intended to be consumed by userspace.


> > 
> > Besides above, had you tested this with `make O=...`?
> 
> You are right, the generated/autoconf.h is in another directory
> with `make O=...`.
> 
> Any nice idea to fix the above problem?
> 
> > 

