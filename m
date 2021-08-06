Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E773E23DB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhHFHTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243583AbhHFHTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3mKwkaoUVrfQ+lC5tkgN91edlf3gr8pvb0ti7ZT+lk=;
        b=ea+3BASv/yl5fT0y35R0yF6ZkdXj1lFlyhCSbu7jo2j59UNHG2RdICL61MP0P58UJ8HMEV
        5ceNXcJCZvLdhetCkICqU3i7/nJfkFAe8Ij+ecSW3DH/5wYNU6Y6/H+14STvpj+6gRdhaM
        fMjWfR4I7r7lSbf3QGbD7/qfjRURmh4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-I0WA8umSMgq1b1yFGwd2rg-1; Fri, 06 Aug 2021 03:19:01 -0400
X-MC-Unique: I0WA8umSMgq1b1yFGwd2rg-1
Received: by mail-ed1-f71.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so4448731edn.11
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3mKwkaoUVrfQ+lC5tkgN91edlf3gr8pvb0ti7ZT+lk=;
        b=bzbiwLGtVp9xtzNpAEy36LrliZ6RF6Kg6BtSlT5L0k1VXJPFaviHP2B4I9BS0AArmX
         KV8UYWjmRjRfjFoqrGKpTQEQzKdGv5m2QDlqfU+IyUFAE3SNPSpngTHYRZliSCbaUMBR
         K1IQwKN6BV2CfiRC92bUsNKEWbjkQ/1e6Dus219JPAPC8OIXOHMCx9s63qfNgqFpGUST
         KDc99c7cyyVs8ieiaua3jlyl+LylSzdjJB3a87WU7XTQBcQ+j9e2gvhRB9pBSljJdM8m
         rgB0SWqhlRuWOeqaD5s5RsKEpWe4ipl5JbP6zIMWjMVOiYGZWhd0TLBr+qzQmHHZs79j
         y78w==
X-Gm-Message-State: AOAM533eoTpkHg9WYr5OUWfNY9SMgolpR8fXwmAhROyI7twkbDH0wX9e
        ficy64loo0LyhrXXgSI784dKk2+7mDwzQXCTpxDsTYJj7hrxYtq+bV4YYwNxnsE51ATar4c4Cec
        Wy9vqarg97AAGipZo
X-Received: by 2002:a17:906:1c81:: with SMTP id g1mr8634578ejh.361.1628234339945;
        Fri, 06 Aug 2021 00:18:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6JY7p7UFxuDeInSSMYr1fMOjaIuzdqeeTRahm0VW7d3WQBlqeSCHdg1JEhMKVsqgo8q29Yw==
X-Received: by 2002:a17:906:1c81:: with SMTP id g1mr8634556ejh.361.1628234339817;
        Fri, 06 Aug 2021 00:18:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id g9sm3459573edl.52.2021.08.06.00.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:18:59 -0700 (PDT)
Date:   Fri, 6 Aug 2021 09:18:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 1/7] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
Message-ID: <20210806071857.h4zneiblcf5tathq@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163307.2589516-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163307.2589516-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:33:04PM +0300, Arseny Krasnov wrote:
>This bit is used to mark end of messages('EOM' - end of message), while
>'VIRIO_VSOCK_SEQ_EOR' is used to pass MSG_EOR.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 3dd3555b2740..1de3211a2988 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
> /* VIRTIO_VSOCK_OP_RW flags values */
> enum virtio_vsock_rw {
> 	VIRTIO_VSOCK_SEQ_EOR = 1,
>+	VIRTIO_VSOCK_SEQ_EOM = 2,
> };

Already said, but I'll repeat it for completeness.

It's better to rename the flag 1 and use it in the same way we did 
before, so it's backward compatible.

Obviously we have to update the specifications too, explaining the 
difference between the two :-)

Thanks,
Stefano

