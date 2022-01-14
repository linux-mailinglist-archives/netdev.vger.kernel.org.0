Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEC448E526
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 09:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiANICM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 03:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234249AbiANICM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 03:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642147331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=klb0nnUjuvobPotelSx3DfHypMSRSFWqMkVcwCb1ESI=;
        b=PoqYoQXlFIWys5suqyfWfH3zPzUoXWBWJbZr9p/XNjHoBcBJurpp5fjcWfArv2QeuLQDkm
        YbhxT6vuLL6hoCCHgEtsxdG6sHEMgAVLI3IvYQaypGsXu8g1TKK+Pa45Dtlx6Q3JS9Lrq+
        T3xHCO8BB7SfiFova3Tjmo0OYgdGskk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-YAlWiUIKOMaEOpF1MmkZjA-1; Fri, 14 Jan 2022 03:02:10 -0500
X-MC-Unique: YAlWiUIKOMaEOpF1MmkZjA-1
Received: by mail-wm1-f72.google.com with SMTP id n14-20020a7bcbce000000b003488820f0d9so5126048wmi.8
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 00:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=klb0nnUjuvobPotelSx3DfHypMSRSFWqMkVcwCb1ESI=;
        b=jBvBK/okkN+5AyN84Ggb6JLG4Vh5MsGso9pAMl80CbzfSCrL+PvGv5Qvkpyyby5XUa
         cNLCvqes/aHWbHjPbIPlt+AR2qU34W5PV2bPRPTjtIhg8g+6bCWY71RT5N+kn/+wjcwd
         5RXqsFpsi6aSCIt5VjqfzM7q+UrLP/7/wVmA6att6dbGob94gH2RXjXicMkrQYjwQWUE
         aHnbu0SqBN49i5uhFYXybBUvA44VHsIh+QRFpW+Wuwp49daMq8s+GVy/xoEtMaYrQZ1K
         VZqd+a3gkVB42UfYkbDIbxbRuJzAmotxVKuF+5dj+iKI3NEXxvoqaQExrfqHV/w9FhIN
         qTKQ==
X-Gm-Message-State: AOAM532p8tTK3HS1WlNoouRO6uEXB9rOKCb2jgAlN+RJJ9AF7P/nX6Rc
        FFEjotn0h2Z7wXa63fEHPwtEJXAoEj/vLosl0wDF/NxzB53NWFWwP5RIPhHyjVBRqot8U46ayai
        rLgLVaM9/WLjTmMdZ
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr7447589wri.297.1642147329127;
        Fri, 14 Jan 2022 00:02:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjqJT5sGU0ZJyw8nvYxiwmgy2EIiuoaOLJLNLYx14PQLad/rO2oCWq7DkWPydBZBlnn2TR1Q==
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr7447566wri.297.1642147328909;
        Fri, 14 Jan 2022 00:02:08 -0800 (PST)
Received: from steredhat (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id o12sm5576911wrc.69.2022.01.14.00.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 00:02:08 -0800 (PST)
Date:   Fri, 14 Jan 2022 09:02:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220114080205.ls4txgj7qbqmc3q5@steredhat>
References: <20220113145642.205388-1-sgarzare@redhat.com>
 <CACGkMEsqY5RHL=9=iny6xRVs_=EdACUCfX-Rmpq+itpdoT_rrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEsqY5RHL=9=iny6xRVs_=EdACUCfX-Rmpq+itpdoT_rrg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 02:18:01PM +0800, Jason Wang wrote:
>On Thu, Jan 13, 2022 at 10:57 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> In vhost_enable_notify() we enable the notifications and we read
>> the avail index to check if new buffers have become available in
>> the meantime. In this case, the device would go to re-read avail
>> index to access the descriptor.
>>
>> As we already do in other place, we can cache the value in `avail_idx`
>> and compare it with `last_avail_idx` to check if there are new
>> buffers available.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>Patch looks fine but I guess we won't get performance improvement
>since it doesn't save any userspace/VM memory access?

It should save the memory access when vhost_enable_notify() find 
something new in the VQ, so in this path:

     vhost_enable_notify() <- VM memory access for avail index
       == true

     vhost_disable_notify()
     ...

     vhost_get_vq_desc()   <- VM memory access for avail index
                              with the patch applied, this access is 
                              avoided since avail index is cached

In any case, I don't expect this to be a very common path, indeed we
usually use unlikely() for this path:

     if (unlikely(vhost_enable_notify(dev, vq))) {
         vhost_disable_notify(dev, vq);
         continue;
     }

So I don't expect a significant performance increase.

v1 coming with a better commit description.

Thanks,
Stefano

