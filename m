Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F43903BE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhEYOS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233719AbhEYOSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621952234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qs8EjzEOCz++s3CVPlPwuFgTHOtbAQXpJzzRW8nZD74=;
        b=NdPVrTJY7DpjEPizKjOvkYXoqbFCWTG5VnDBayKAmQcI3jPDBH5+HBbMV6iZV9J9gBLswP
        OuIgMh/Z8PiZJfAWbnVVJiW/zouaB6H0jt2HEU3FNcK28YC9W5FDKpfPN6Z2I7SMBvTV/g
        5Utaljakc3AHLWzFe2XH6KGN+/Okv5Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-WxpTTDzvMiSMFygZc2lW2Q-1; Tue, 25 May 2021 10:17:12 -0400
X-MC-Unique: WxpTTDzvMiSMFygZc2lW2Q-1
Received: by mail-ej1-f71.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso5639017ejo.13
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qs8EjzEOCz++s3CVPlPwuFgTHOtbAQXpJzzRW8nZD74=;
        b=mVIfP4x0AZy1bzqYrPZWNzu/+dLYSccKEdyx+8QmhsgzZoAQ5OOVFfV9c2YJblM2rA
         80tdt3V4terMlOy3yaq9IkFqYpmE/6M5eiWgv/qHtfaUcvdN/iFG8RsFIdxeWahChrHV
         I8/xW6lUvd+r84Rp6/GpyF9mOt9yCxu9uyjWxH9IKHppfMv36nXqIce+GwzKvj62dAug
         c6uPG9wKS4cJ1w2pDwKd9///jkfGB4HgcHbJ5x+BGGlOkC+66vVkw61wIgqiH8nSQfPt
         sQrp33vk7fIYoAg/WUPGCMhG/81K2pt3aO3GdBomtnMGd4TCf10YgVYjO9IE0E/mng7Z
         jinw==
X-Gm-Message-State: AOAM532u4mEPTUCE4wtiDilRZOrSQCdLOyLC90Sx99nY4zDuZPOyuTEm
        s7EGY+0ThDwX/bvYQDd0mDKcUHLXTmTRwvBLFUx8rpFw+pZox//bcAzgl3LpGq2lGn/k2wUleUQ
        plZL0T8SQrDbqQsJZ
X-Received: by 2002:a05:6402:190e:: with SMTP id e14mr32337351edz.146.1621952231504;
        Tue, 25 May 2021 07:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFKL2as0znk9EfRE37BQywDQJb+X3ks+d5tVQoRqTJJqOiRkyF4ZCUMGJz3wAnrUijDO8n7A==
X-Received: by 2002:a05:6402:190e:: with SMTP id e14mr32337320edz.146.1621952231368;
        Tue, 25 May 2021 07:17:11 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id bv17sm9143813ejb.37.2021.05.25.07.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:17:10 -0700 (PDT)
Date:   Tue, 25 May 2021 16:17:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 06/18] af_vsock: rest of SEQPACKET support
Message-ID: <20210525141708.nklo776yq2nnhju7@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191639.1271423-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191639.1271423-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:16:36PM +0300, Arseny Krasnov wrote:
>To make SEQPACKET socket functional, socket ops was added
>for SEQPACKET type and such type of socket was allowed
>to create.

If you need to resend, I think is better to use the present in the 
commit message.

Maybe you can rephrase something like this:
"Add socket ops for SEQPACKET type and .seqpacket_allow() callback
to query transports if they support SEQPACKET"


>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
> 2 files changed, 36 insertions(+), 1 deletion(-)

The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

