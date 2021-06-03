Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381739A4E5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFCPmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhFCPms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622734863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AvsQH1hyQpvPjHL2hTxdfQHPQhfR4l9xQwXErWo9HxI=;
        b=CZbXc2ySzAMOmsJhzuq+DxSHnZhWv/bbeZH0rn3MRWJkn5hpWf+aaHowPXON1fgCWvBnwV
        Y/6EV6dxc4FfRH6qF9vl0ru2eSEF1aU99Fx/ihT2hLltwCi78GHwh1sVFhLtkeTh4vc40w
        wnnS76kJT3sLGhL1Ntp7v1CUKz3WMfE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-mayqNeqYO0S--LoAO4nPGg-1; Thu, 03 Jun 2021 11:41:02 -0400
X-MC-Unique: mayqNeqYO0S--LoAO4nPGg-1
Received: by mail-ej1-f72.google.com with SMTP id eb10-20020a170907280ab02903d65bd14481so2072295ejc.21
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AvsQH1hyQpvPjHL2hTxdfQHPQhfR4l9xQwXErWo9HxI=;
        b=aLHJOJveGnm1AeyF+TD7d6Ed2TRdaniQ5JxOj/Fc+0kn1F+TFa1Fw8V0+RjSqd9IfF
         AL6yEj4ghz9hY64TsVMIkeQmiZpQ3mMeoN/hV2g82xSCYFyJP+Zs/Wty847/JZPb6CZn
         MUrDc3tB/CIFEEfagWPUF0fqX5EpkQrylC92LrPtwtiDS97ket2W0XEZFqZBWEgS1Rwk
         gI5lzGoKIeO+BI34i8skWOwGGeK0ppKxoKsUeKA4DscITdLzTkx4n3oKQHEz7qLw7VRx
         R7aDSGodz9uWdMiDo8m4Yy3XDk43ZtStBO8BM49gZT0JnRJ6Rn2QpQnN/D8XDiIuM1Dk
         QDIQ==
X-Gm-Message-State: AOAM531T2q15j37yuxFZX0AHEBFOKypt61y1gVWnGZ14W1eSp75McX7u
        rCOnk74nGDUhpcu8MmG5BXDy+cdRQRsFtUaoeJNi8gdJOiciohVEJjRww+XVele0gsprFF8mmR6
        d7BFLAb6zF3zedurK
X-Received: by 2002:a05:6402:4313:: with SMTP id m19mr80409edc.263.1622734860914;
        Thu, 03 Jun 2021 08:41:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY5YQ/utrtbJ0+zixQqmqhNKVQZErmThRj2KcDrDwxrmJQ2oZwOP9DefrKyZY+3MYgkheR+g==
X-Received: by 2002:a05:6402:4313:: with SMTP id m19mr80384edc.263.1622734860773;
        Thu, 03 Jun 2021 08:41:00 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id l8sm1930416edt.69.2021.06.03.08.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:41:00 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:40:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 18/18] virtio/vsock: update trace event for SEQPACKET
Message-ID: <20210603154056.e3zyk2wmmutq4nia@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520192008.1272910-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520192008.1272910-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:20:04PM +0300, Arseny Krasnov wrote:
>Add SEQPACKET socket type to vsock trace event.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/trace/events/vsock_virtio_transport_common.h | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/include/trace/events/vsock_virtio_transport_common.h b/include/trace/events/vsock_virtio_transport_common.h
>index 6782213778be..b30c0e319b0e 100644
>--- a/include/trace/events/vsock_virtio_transport_common.h
>+++ b/include/trace/events/vsock_virtio_transport_common.h
>@@ -9,9 +9,12 @@
> #include <linux/tracepoint.h>
>
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
>+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_SEQPACKET);
>
> #define show_type(val) \
>-	__print_symbolic(val, { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" })
>+	__print_symbolic(val, \
>+				{ VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
>+				{ VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })

I think we should fixe the indentation here (e.g. following show_op):
  #define show_type(val) \
	__print_symbolic(val, \
			 { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
			 { VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })

Thanks,
Stefano

>
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_INVALID);
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_REQUEST);
>-- 
>2.25.1
>

