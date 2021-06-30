Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E763B81BC
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhF3MNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234414AbhF3MNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fPmSNjorX8tf2eCOIhHKnRjZ2avWw2QnQ177mXZw2z8=;
        b=AB+vOT+bV8eNOodMvEKqE/x0pf+jsnkzXssY+vGvEo6WoN+m0uV1aDjumPE3lbnRo1ObHQ
        aO7Sb8GB4WbLSgFKDLXu8JXfTOYaI9Ys0DXDCFVhhZEeWsaBteTik4FjFbzsWianMkePp/
        RbLAWPajkkXZFmRRI8lfu7GsU0i4VLo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-6zeCpO9FP0uNNjIbn3RpDw-1; Wed, 30 Jun 2021 08:10:48 -0400
X-MC-Unique: 6zeCpO9FP0uNNjIbn3RpDw-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a0564023591b02903951740fab5so1029229edc.23
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fPmSNjorX8tf2eCOIhHKnRjZ2avWw2QnQ177mXZw2z8=;
        b=lMDwYGtcFe/cyD99Qc7JWe8wYFF/4F+4VNfyGr6tg0AoYk/TgaNu9FQZuAhdkWwSue
         20rB2zHvdxGfAMHK0bH0J0nilnvap1uZxVBCDHZqF3ch4l32UjBzt6H1ZA0bHGnQ4dgZ
         So3amJ5Ik77HYFK6ER1FFTNmzqHrSrC5//BwgIN1+YWaT01i4pU4cd6Mfq+OJ/5ItCCO
         OMSrxT5ebS5p6x8SKsV0WLSs+jqyjozCjUDg5yJnEs+b87n61DxEpLX2dUnp4XWptqsM
         5hW7q0/7eX5e6e+FH2Nus5oZJGla+Ftfhy3hl473iTEotFRDhnK22ANOuDTum4eCVk9Q
         oEXQ==
X-Gm-Message-State: AOAM531KPqNF+EY/XQvFJAxZS5Nb8sPziYEGCcA6/OuiqRmbOo2hmoGE
        DH6NKjZbYypD4KGWOvm8Usv26B+jKWKezF+1h0XozRBph28qoJDet7fkaCKZmdd1pPnxrUcZqbl
        N3uxC/7xMRbpQjAQh
X-Received: by 2002:a17:906:3a53:: with SMTP id a19mr20641905ejf.88.1625055046854;
        Wed, 30 Jun 2021 05:10:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo3BecDCYPDPNSBAsV0lGMAxuPsG5my6j1jlO1OzMo1m4o9qrQKj6ON3wbX0lfltMQbD4JSw==
X-Received: by 2002:a17:906:3a53:: with SMTP id a19mr20641875ejf.88.1625055046551;
        Wed, 30 Jun 2021 05:10:46 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id v5sm947889edy.50.2021.06.30.05.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:10:46 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:10:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 05/16] af_vsock: use SOCK_STREAM function to check
 data
Message-ID: <CAGxU2F6owSKJWEkYSTBGy+yrVhp1tcjDmC+gwj9NAJzddMrFkQ@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100250.570726-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100250.570726-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:02:47PM +0300, Arseny Krasnov wrote:
>Also remove 'seqpacket_has_data' callback from transport.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  1 -
> net/vmw_vsock/af_vsock.c | 12 +-----------
> 2 files changed, 1 insertion(+), 12 deletions(-)

In order to avoid issues while bisecting the kernel, we should have
commit that doesn't break the build or the runtime, so please take this
in mind also for other commits.

For example here we removed the seqpacket_has_data callbacks assignment
before to remove where we use the callback, with a potential fault at
runtime.

I think you can simply put patches from 1 to 5 together in a single
patch.

In addition, we should move these changes after we don't need
vsock_connectible_has_data() anymore, for example, where we replace the
receive loop logic.

Thanks,
Stefano

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index ab207677e0a8..bf5ea1873e6f 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -141,7 +141,6 @@ struct vsock_transport {
>       int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
>                                size_t len);
>       bool (*seqpacket_allow)(u32 remote_cid);
>-      u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
>
>       /* Notification. */
>       int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 21ccf450e249..59ce35da2e5b 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -860,16 +860,6 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>
>-static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>-{
>-      struct sock *sk = sk_vsock(vsk);
>-
>-      if (sk->sk_type == SOCK_SEQPACKET)
>-              return vsk->transport->seqpacket_has_data(vsk);
>-      else
>-              return vsock_stream_has_data(vsk);
>-}
>-
> s64 vsock_stream_has_space(struct vsock_sock *vsk)
> {
>       return vsk->transport->stream_has_space(vsk);
>@@ -1881,7 +1871,7 @@ static int vsock_connectible_wait_data(struct
>sock *sk,
>       err = 0;
>       transport = vsk->transport;
>
>-      while ((data = vsock_connectible_has_data(vsk)) == 0) {
>+      while ((data = vsock_stream_has_data(vsk)) == 0) {
>               prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>
>               if (sk->sk_err != 0 ||
>-- 2.25.1
>

