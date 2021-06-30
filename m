Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D32D3B81CE
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhF3MPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:15:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234435AbhF3MPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0N2yOcyFYV5CPN+IR8aqJYBNH6snD2VpY0jfF5xnCwA=;
        b=HKrRxoPN1kQXddDBiHgYDeo24+X8Zd9lBy2nzUhhHTnwRyfe/IWfH3rDm1pKwVYenxm4dP
        vY7zzNKLygJ1bh6Dl1rMZGhH68gPhPMgTR1F2wSRcKu26h2RQ0prH00wmXy/F9gH2PBULI
        Xrn2e0We6Oy3FLsFQ+CaviPsH5+FuLc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-AZwAOsSYPqazpWK4J0XCtQ-1; Wed, 30 Jun 2021 08:12:51 -0400
X-MC-Unique: AZwAOsSYPqazpWK4J0XCtQ-1
Received: by mail-ed1-f70.google.com with SMTP id ds1-20020a0564021cc1b02903956bf3b50cso1052599edb.8
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0N2yOcyFYV5CPN+IR8aqJYBNH6snD2VpY0jfF5xnCwA=;
        b=RaXMDb/BkAuDS2EI/P83pF9enerYX+wbEpdPxyfrUACzGThq122Ts8LZTvUkwG9vFf
         SZKsdiCHypLsYQmW24EPn3DojCj+vDZzsDiT2Tr5mUCa2lZkyGPC9m0df0jg+zPPbVe3
         C0VP5lA2ch4l3Jm3uYJgFW/CNOPV8TXHXazcR/ouDv9j3gvTtzsf95G1LBWz1DlEZQ3j
         Hpb0vM4USboB9sXWI359YMKtWAxzuVBVw3+oE48QPafL7Xp0+CKXQFJkx4eIiW+35hrR
         UFinMdaqqwXCDUfDWlj0c0lGN/g7XNLtYTSTK76h51kerkeWln7T6/X7AbvnrGAKFDrN
         +nJA==
X-Gm-Message-State: AOAM531sk3X7d1eVyfvu/2qn2KFBgCnaAwxSrtx/SdNOONlFguBuUJBA
        +74k0u5D1Zo6EYOqfwJj06OBRN0TEftGGKEKowrHc5h6RJK90bOaJjV+KJA5GxBGB5tJGbEbWcL
        VaCO8qFoV7tNtAhcL
X-Received: by 2002:a17:906:3755:: with SMTP id e21mr35502843ejc.0.1625055170500;
        Wed, 30 Jun 2021 05:12:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyQieQzL13kfgrAiQdC+xnDKI6+4gnyVHQvGrs/WltryrEMaxVn3e2E8N8jeK6pEWm6l6rvQ==
X-Received: by 2002:a17:906:3755:: with SMTP id e21mr35502827ejc.0.1625055170336;
        Wed, 30 Jun 2021 05:12:50 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id e17sm897093ejz.83.2021.06.30.05.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:12:49 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:12:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 11/16] afvsock: add 'seqpacket_drop()'
Message-ID: <CAGxU2F4mX5khjA+a_LQEfZYg1rjEmccXce-ab0DVyEJEX-kYcw@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100415.571391-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100415.571391-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:04:12PM +0300, Arseny Krasnov wrote:
>Add special callback for SEQPACKET socket which is called when
>we need to drop current in-progress record: part of record was
>copied successfully, reader wait rest of record, but signal
>interrupts it and reader leaves it's loop, leaving packets of
>current record still in queue. So to avoid copy of "orphaned"
>record, we tell transport to drop every packet until EOR will
>be found.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   | 1 +
> net/vmw_vsock/af_vsock.c | 1 +
> 2 files changed, 2 insertions(+)

And also for this change, I think you can merge with patches 12, 13, 14, 
15, otherwise if we bisect and we build at this patch, the 
seqpacket_drop pointer is not valid.

Thanks,
Stefano

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 1747c0b564ef..356878aabbd4 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -141,6 +141,7 @@ struct vsock_transport {
>       int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
>                                size_t len);
>       bool (*seqpacket_allow)(u32 remote_cid);
>+      void (*seqpacket_drop)(struct vsock_sock *vsk);
>
>       /* Notification. */
>       int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ec54e4222cbf..27fa38090e13 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2024,6 +2024,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>               intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>               if (intr_err <= 0) {
>                       err = intr_err;
>+                      transport->seqpacket_drop(vsk);
>                       break;
>               }
>
>--
>2.25.1
>

