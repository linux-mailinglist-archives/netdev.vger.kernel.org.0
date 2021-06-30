Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ED43B81C2
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhF3MOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:14:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234388AbhF3MN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HjLKivpmTxani+XPF3iGAiHLl5i/SxVPZjv2mKGxTR4=;
        b=EbluSdyFvc3I9Jb278vJRzcmj9H63nr1Uy1MKJ0/PmNffMiPhz2VcdyapobQYg9gl9MwPT
        qPvXxeXaNS6L4s4HvvwNGFWo8VYYpwBRphxVhsiV1N4RVOubkob13pcm3V+bEEfVeLp5hd
        r7s57EfPwA8HztDEfPId6IONjNfmccg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-gNoQNXSmMbinGng4gIsmjA-1; Wed, 30 Jun 2021 08:11:28 -0400
X-MC-Unique: gNoQNXSmMbinGng4gIsmjA-1
Received: by mail-ed1-f71.google.com with SMTP id d5-20020a0564020785b02903958939248aso1029738edy.15
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HjLKivpmTxani+XPF3iGAiHLl5i/SxVPZjv2mKGxTR4=;
        b=gSU5OfSgPAooMpuA7qAmxbL0D0Qs0zbGNsvYKMFw0mmyoRyaGOK6gjhkcusS+Wjp7O
         PwpXlZe7JYGnIk9cNEpcMZjGgqQYoCPZYkliM/quh6cqLXP7s4bvLnXkWvNoh/fufWm5
         FFVq015AUYOegM4UWfd4fzZfWRh548Z6xllgitThHOMFa38m99aFQCmc9Kib83SLkZuR
         A+dn2CNfK+qO5L1q7AiOrZDNF5W5HkOMyxu7R0iuhj63IgWMgOiIITXH0QxxLPwjMuUg
         ztQOGi8cdXKrA/T1g8KPQkqXGyd1Z5CZDQRfeqCt4CDP72MIok+uDrqJ5pevKYvD8k7o
         N81w==
X-Gm-Message-State: AOAM532k8GumrJuzCfA+9i2SFK5hc3Eq+sTMFpAvBYZDiIP4EedEIaXT
        NoXJrxBeco6e6znDHqm0cSz0FFxaRvbopwEVS2BtsDPTJP+XaKDWSoD0CO8u4TmgFinsZgb6M3f
        5829Dg8crh2H8Hc04
X-Received: by 2002:a17:906:4899:: with SMTP id v25mr35863385ejq.451.1625055087447;
        Wed, 30 Jun 2021 05:11:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS+TPipViKVTyOBRlKGUsXt+XwfFGYR4iIVDCFdEFv1bf670kbuHjhW5TA+alh5BwQNtL7Mw==
X-Received: by 2002:a17:906:4899:: with SMTP id v25mr35863362ejq.451.1625055087282;
        Wed, 30 Jun 2021 05:11:27 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id r12sm12637350edd.52.2021.06.30.05.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:11:26 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:11:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 07/16] virtio/vsock: don't count EORs on receive
Message-ID: <CAGxU2F7SsxvCht2HbDb7dKsM_auHoxvHirgWwNMObjxOci=5nA@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100318.570947-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100318.570947-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:03:15PM +0300, Arseny Krasnov wrote:
>There is no sense to count EORs, because 'rx_bytes' is
>used to check data presence on socket.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 3 ---
> 1 file changed, 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 84431d7a87a5..319c3345f3e0 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1005,9 +1005,6 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>               goto out;
>       }
>
>-      if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>-              vvs->msg_count++;
>-

Same here, please remove it when you don't need it, and also remove from
the struct virtio_vsock_sock.

Thanks,
Stefano

>       /* Try to copy small packets into the buffer of last packet queued,
>        * to avoid wasting memory queueing the entire buffer with a small
>        * payload.
>--
>2.25.1
>

