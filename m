Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132BE37F6F3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhEMLnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:43:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232327AbhEMLnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620906142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R+xpriwoqMR4hMxYIDQ9tzTIIOzNsv7iGskqwPCMAtI=;
        b=c9K1MwA73IAmmeL3NHpniD729Tj8N2NrM0OGLarSP3FUcyfDuf+UZPAiT0UUqE7a66HzaH
        BFp/nKmMc1kPZEukytk/vTICUx20lbsxhcu4Y/53sFY9jfjgj1aqgBTe/7fquXltVi27DC
        JlSOQwVjWaKyuBuHnwxyfFjLjHn+F1g=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-iHfLPm_6MfOuZidbYdh33A-1; Thu, 13 May 2021 07:42:18 -0400
X-MC-Unique: iHfLPm_6MfOuZidbYdh33A-1
Received: by mail-ej1-f69.google.com with SMTP id h4-20020a1709067184b02903cbbd4c3d8fso3422331ejk.6
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 04:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+xpriwoqMR4hMxYIDQ9tzTIIOzNsv7iGskqwPCMAtI=;
        b=GoZrATsQQr3G2p8YdsrDoEiWgf7vNUDR7g47zjPqk7RvEyp8sF4pvGlhHEncbAcqBO
         9zENV251Imyf+Z+OaCSvi5xg2vRiDCgT2o9317r0NwH8jCXOj0IED6lM+pMMDrNJIyg2
         VqbYh4wa/2Q9eRMxHxXKuPXVzplu38AepTBUBtoRzLHfxdKCuApQWiEAFGHjgSmH5vgJ
         Yx0aiJ078I5oy6vF+VCr2C68aCPLc7NCHs5qjYxAfZ+ZFkWYO5hiUXNlJW6faB9KgZIf
         gTWhJHIx3eyA0HgOU3zFpuljcOWuMcfvj3FIvUkIYGFuUONoxdYcLmCzxO+PvSzwf5x6
         A9bA==
X-Gm-Message-State: AOAM533FHzZNKl/4FAUrtXaWPS5YHief2VcBMZk5np7irLWNRm/F9r84
        /kR/e/yzEPCCRE3Tv1B2xKE2ptVQizEmmcmJfRyrY9tCOzOi1qdGK4y08pixaJLxqNnPoXzgOwb
        Blbb1ac40M1R7eXkA
X-Received: by 2002:a17:906:11d5:: with SMTP id o21mr39425178eja.176.1620906137651;
        Thu, 13 May 2021 04:42:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4evvrqMGAM5r4UR85o5vJGUe4V1rA7BD2JGHOAS51E0jB0311f1ua3YMBd6FJgtBjiTezpQ==
X-Received: by 2002:a17:906:11d5:: with SMTP id o21mr39425159eja.176.1620906137418;
        Thu, 13 May 2021 04:42:17 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id q25sm1704765ejd.9.2021.05.13.04.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:42:17 -0700 (PDT)
Date:   Thu, 13 May 2021 13:42:14 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 06/19] af_vsock: rest of SEQPACKET support
Message-ID: <20210513114214.66mfm76tp65af5yq@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163350.3431361-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163350.3431361-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:33:46PM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

This patch is changed, so usually you should remove the R-b tags.

>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
> 2 files changed, 36 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 5860027d5173..1747c0b564ef 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -140,6 +140,7 @@ struct vsock_transport {
> 				     int flags, bool *msg_ready);
> 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
> 				 size_t len);
>+	bool (*seqpacket_allow)(u32 remote_cid);

I'm thinking if it's better to follow .dgram_allow() and .stream_allow(),
specifying also the `port` param, but since it's not used, we can add
later if needed.

So, I think this is fine:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

