Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D679E37FAF2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhEMPmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234869AbhEMPmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 11:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620920489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sXZYS/0BUExKj3W5kBmFWrcfidrqXplf+lopV9pbEik=;
        b=ZQxPMSSLi6i3jWRQqgibWzu1Rk5nmCVeiGUvLk2rHBMmSSu4XVveR5qfa7ioi3sS6Zm4na
        o63658A61e+joJoXVc0Z7L0YzKzB7Cy7713KCh1rp+965+TomTuUkA6Q2GT3Oi9v0h1NYh
        +Q9qIbY2KzsdiBC7ZDqFk+cQVVicq+w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-uTg6IWuPPDuvXI8HrxrQhg-1; Thu, 13 May 2021 11:41:27 -0400
X-MC-Unique: uTg6IWuPPDuvXI8HrxrQhg-1
Received: by mail-ed1-f70.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so14838336edd.2
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 08:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sXZYS/0BUExKj3W5kBmFWrcfidrqXplf+lopV9pbEik=;
        b=FkHbU79D4sc2GwH/4BjC5N0S0TTifxzx6ud6Na/PO5cna9RawqTSl6VgBAAsMNjijY
         SjaOYNQDJmjU52MHLDYEkwWALDT02S5MxpElaCejerGPG4X+euxBCc8zvTiDzkBauyh5
         W3xN5/mOak7PJHuA5KdSF9Bz6BUr7jLoGvzpg/FIZxLWv0EKpqxhK1Kx0e2aW2OyxtLx
         R/wkoK5OY5JGaffaMofQhM+2DvVOcKExoo3jcXYXkotkn1yFSknntHycEbKFQ4G8PPXL
         e6UMqLBO+OpsQw6wst2xBEAzUWFoqoxz+DL/4NG7Z10WjF/NRERHrEXlk9BwoLalB9x1
         rpOg==
X-Gm-Message-State: AOAM533/xb7ZPl6WmTY1Tkvvba2uDNkbtGEbXYlYea0jxvo9+J7XxhSw
        8FLSusxihmPQsllvzFN9d8CrUcyojkYl+F7W1hNwXww9VKBTghYzbayBpL+YNKkuY9fiZxpgQi2
        KpKtBzCYStdFH15jf
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr50245490edw.361.1620920486218;
        Thu, 13 May 2021 08:41:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPjtArqT2SrP+FHXngcrCXNm8mzmb8hWvhCdzDFicV/Wrm8pfSoY4vN4Vx8FaRAq4VLVTKdw==
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr50245467edw.361.1620920486053;
        Thu, 13 May 2021 08:41:26 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id o3sm2624150edr.84.2021.05.13.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 08:41:25 -0700 (PDT)
Date:   Thu, 13 May 2021 17:41:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
Message-ID: <20210513154121.a4p2gxwnrxxlj64n@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
 <20210513140150.ugw6foy742fxan4w@steredhat>
 <20210513144653.ogzfvypqpjsz2iga@steredhat>
 <a0cd1806-22d1-8197-50dc-b63a43f33807@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a0cd1806-22d1-8197-50dc-b63a43f33807@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 05:48:19PM +0300, Arseny Krasnov wrote:
>
>On 13.05.2021 17:46, Stefano Garzarella wrote:
>> On Thu, May 13, 2021 at 04:01:50PM +0200, Stefano Garzarella wrote:
>>> On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>>>> This add logic, that serializes write access to single socket
>>>> by multiple threads. It is implemented be adding field with TID
>>>> of current writer. When writer tries to send something, it checks
>>>> that field is -1(free), else it sleep in the same way as waiting
>>>> for free space at peers' side.
>>>>
>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>> ---
>>>> include/net/af_vsock.h   |  1 +
>>>> net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>>> 2 files changed, 10 insertions(+), 1 deletion(-)
>>> I think you forgot to move this patch at the beginning of the series.
>>> It's important because in this way we can backport to stable branches
>>> easily.
>>>
>>> About the implementation, can't we just add a mutex that we hold until
>>> we have sent all the payload?
>> Re-thinking, I guess we can't because we have the timeout to deal
>> with...
>Yes, i forgot about why i've implemented it using 'tid_owner' :)

It is not clear to me if we need to do this also for stream.

I think will be better to follow af_inet/af_unix, but I need to check 
their implementation.

Thanks,
Stefano

