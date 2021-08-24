Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB73F5B6F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhHXJxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235698AbhHXJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629798788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQ7wXqd35jkq9u//jEUxGDrlsnHE5KbTspU7KytW0gQ=;
        b=KuHnb4H8j3bGIBI/Ubma1FRfFCggd7zCrhn1VCajkhVgD1P3CYTeKW8D6RK6y54YmHHm/U
        TeITbiJ9ycJGyEr+UiJabMuOpN6Q/79QnIHM3/qhnr+yYuiqoAVEMXIY+CQuHbjoDgR1We
        3aanONFHFXh/6uD35WPvsgw9mmV7czk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-HPC_EM1mN2q_kzCbqidrLg-1; Tue, 24 Aug 2021 05:53:07 -0400
X-MC-Unique: HPC_EM1mN2q_kzCbqidrLg-1
Received: by mail-ej1-f72.google.com with SMTP id ak17-20020a170906889100b005c5d1e5e707so2085190ejc.16
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OQ7wXqd35jkq9u//jEUxGDrlsnHE5KbTspU7KytW0gQ=;
        b=LDNYfTa2vq78fj7Z5KTbEWazNcwCVdltrhPF1wLwvQcngHGVv0jZJkraW93RfffCVG
         9nTmP9sEIwKqpRx8OSZNXmMfl1jzH+4EHWEyDhY94jObGL8mUdjMT0J3zic2ajlQBebT
         /uTZ7A6WTomTV419YGWPxza8qhs2KrxOtktzRRedpYFCbRLtA20XimwUhc67TnezCGdJ
         xEJwmUdX4ce1JiKuB4VZhInBjKoE7GrXPEabFZ3nPfJK907Z30gwTZKLD2tq+6CTxpHY
         9CPnsQ43tW5C3DOUnkyLaqYc8CEvQwhm3bL2IanTA2YL/gnImZhXWAwTzw2d4W5yODpK
         550g==
X-Gm-Message-State: AOAM532ae2TSmZkyIji2E3GaxUkCbnyyO3Myxi5/fOUv0mOBeCS6dU4a
        QhcCT45cy9z81q4mORJy6cV1VWT/1R44kDEKvZUGbt1n8fkn/kK95PgGw1S6OfQLIeGFkl8KzfH
        fDpEMa8lngcBUfJAm
X-Received: by 2002:a17:907:1dcf:: with SMTP id og15mr4899934ejc.470.1629798784612;
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9y5QQWKGxjE2KrEc2IutIocxe55cgt45xzuJQQ4MACHDUf8AJaPA8kHZYDYQkMpudS3S8yg==
X-Received: by 2002:a17:907:1dcf:: with SMTP id og15mr4899921ejc.470.1629798784495;
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id o6sm4341681eje.6.2021.08.24.02.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
Date:   Tue, 24 Aug 2021 11:53:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.co
Subject: Re: [RFC PATCH v3 2/6] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
Message-ID: <20210824095301.udvwh2hatrf2l3mh@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <20210816085126.4173978-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210816085126.4173978-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 11:51:23AM +0300, Arseny Krasnov wrote:
>This bit is used to handle POSIX MSG_EOR flag passed from
>userspace in 'sendXXX()' system calls. It marks end of each

Maybe better 'send*()'.

>record and is visible to receiver using 'recvmsg()' system
>call.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 8485b004a5f8..64738838bee5 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
> /* VIRTIO_VSOCK_OP_RW flags values */
> enum virtio_vsock_rw {
> 	VIRTIO_VSOCK_SEQ_EOM = 1,
>+	VIRTIO_VSOCK_SEQ_EOR = 2,
> };
>
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

