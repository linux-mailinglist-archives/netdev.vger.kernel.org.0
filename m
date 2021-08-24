Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9189A3F5CEB
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHXLNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236443AbhHXLNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 07:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629803536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sp6r3OzWSMu57KiEYb4z4Sr1QBf9aXwrMsxdCi+UL3c=;
        b=LnaeJtdnvz+wt9mV7wf6yrYySFJSe+PR7Kxt0NeeHv1rz71UVGb+kQQszA1jNvyKvgFnUS
        gNkR2qacvPoA33fDQFBMueHDjoBn4/Z5+5qA0c3yKMHNqi0sICGdhTgaYtVOmOzEi8E9P+
        02Km4iX82Y25gwrtbMTf3DHTAJWFh6Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379--xc8YqkxNDCOk7SsbVB26Q-1; Tue, 24 Aug 2021 07:12:15 -0400
X-MC-Unique: -xc8YqkxNDCOk7SsbVB26Q-1
Received: by mail-ej1-f70.google.com with SMTP id bi9-20020a170906a24900b005c74b30ff24so191110ejb.5
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 04:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sp6r3OzWSMu57KiEYb4z4Sr1QBf9aXwrMsxdCi+UL3c=;
        b=gIy/LbeqimitDCgtphBZQUy0b6Zc+sb2EsB6HFoJgteJt5aCbWzvLw/tJu6XwGQCrS
         9vVP2AMjSf7mJ+N+cwsiyCF50YglBx9brPguRIgMTIGW2JdqHeYT5XqKZivEbMzQR82/
         E/s888bV8Xwxg4vhr23HiuVpFuE8oW5NtDNNPOHsEgtFh2/Y6uJeDY9O9taxqlSc/GsX
         w8cw0+W5gc4aPVRzwOlRr1G758mSukG22wW0PdEzYIYVWkGEN1/rMZCZ3jy7O/dXyQyz
         /RTFjhkc1ZT6LP4swFgJPrXu5q83gYPMOxjD08EXvemz0/KNzyLV9k1GZ+8JWFBEX5M3
         m3Cw==
X-Gm-Message-State: AOAM533mxdgDFjbbLGaYOF+QuOqNiFUA+LLv6QPPfQWgFyEwKJrgMhAF
        kmcrGhL/1y05ZVbR3SQJuORsUKfb7JuypjObnemjO32kH4zfsoYH0eBzXVsRJNDMygMHzLhuCBt
        1Wkdcxf5ODG7YG5dq
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr40193366eje.425.1629803534055;
        Tue, 24 Aug 2021 04:12:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDklZBFBy5QnXrgs3+cqOF2EU5CCgdvdd15GqRk67R8P3Nj6qlQx0g2cCYgrph1uoICqAc7Q==
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr40193358eje.425.1629803533933;
        Tue, 24 Aug 2021 04:12:13 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id h21sm331619ejb.101.2021.08.24.04.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 04:12:13 -0700 (PDT)
Date:   Tue, 24 Aug 2021 13:12:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 05/12] vhost-vdpa: Handle the failure of vdpa_reset()
Message-ID: <20210824111207.ppvop52hyq5xyny5@steredhat>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-6-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210818120642.165-6-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:06:35PM +0800, Xie Yongji wrote:
>The vdpa_reset() may fail now. This adds check to its return
>value and fail the vhost_vdpa_open().
>
>Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>---
> drivers/vhost/vdpa.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

