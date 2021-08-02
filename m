Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7263DDF55
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhHBSfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:35:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231958AbhHBSfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 14:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wminINGDgWcNHoLPUasL8rgS7uCgoeCj4rIW6d1gFd0=;
        b=YvBg4D6Ok09eOJC7TpSEwFAEQ2FIpkAD3RnFGXJllgtpEvvvY32RT1vEPaP+v9hID1svZ8
        IadKbOyRJWI8L53OId502PzHZFsdKqe9b3ZT219OP8kpZrOG124J/W9kmYAeKeXtHkZ1v6
        kb346tGfSInQ8X5ngvqAx7EFrrPb2rg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-2Tf68SrYMFqcu-FtQwRfnw-1; Mon, 02 Aug 2021 14:35:00 -0400
X-MC-Unique: 2Tf68SrYMFqcu-FtQwRfnw-1
Received: by mail-ej1-f69.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso5009499ejc.22
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 11:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wminINGDgWcNHoLPUasL8rgS7uCgoeCj4rIW6d1gFd0=;
        b=hGaXG4S1PVsTYqZ1DwLepOTI/UuPmrcO2zm6r7jYC5swk1GtNn6wG0+kxlq4W3DpmW
         QZALGIgymldG47oHiGIHdWlM1lwFAxDGdyOZ9m4+HljOu6rx/UCxMlh1FTvKlKm48T0e
         9IfRmt8WmUKBwNBATjIU5/ulT7axUHkDyzv8DAkOfGUksd8ZjmfkoVE8nT86X1f7dycw
         8IEb5iFIlByfDlW9nn1LBKhfm7MDPnXh/UXmdkG9raLkZtlQrTIPD9eVXVbYj1FO59V4
         4Buv1l5/xsluHSMCQiJ5Rm2jHXFsT+wKH/IfVbgFtnq6j4OhevK93C/CQbuK1zAM7C08
         IbKA==
X-Gm-Message-State: AOAM532uJ8cwJkwM1Hz9zDwuEGlxWfBA6+Z16PcrUEOjkRiUCeyTxqNt
        goA2Iv/lJHcyAzxXAPuTl9MA2zifc2c02/f4fgzwmf6icyFsXRe+XnyjRb5nFEc5aPgaZ6lBh/4
        E50Xiz0Y3te6KGB+l
X-Received: by 2002:a50:fb18:: with SMTP id d24mr20985350edq.225.1627929299328;
        Mon, 02 Aug 2021 11:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoCyMdXrDgg3jX2cUmgPnbyHqQZI1zsIxFF27gl9okbIV2OgI+ba2TaS/45evhjSuB8kSK5g==
X-Received: by 2002:a50:fb18:: with SMTP id d24mr20985334edq.225.1627929299147;
        Mon, 02 Aug 2021 11:34:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id n13sm6705376eda.36.2021.08.02.11.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:34:58 -0700 (PDT)
Date:   Mon, 2 Aug 2021 20:34:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kuba@kernel.org,
        asias@redhat.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
Message-ID: <20210802183456.zvr6raqtgwrm3s52@steredhat>
References: <20210802173506.2383-1-harshanavkis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802173506.2383-1-harshanavkis@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 07:35:06PM +0200, Harshavardhan Unnibhavi wrote:
>The original implementation of the virtio-vsock driver does not
>handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
>virtio-vsock specification. The vsock device emulated by
>vhost-vsock and the virtio-vsock driver never uses this request,
>which was probably why nobody noticed it. However, another
>implementation of the device may use this request type.
>
>Hence, this commit introduces a way to handle an explicit credit
>request by responding with a corresponding credit update as
>required by the virtio-vsock specification.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>
>Signed-off-by: Harshavardhan Unnibhavi <harshanavkis@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c 
>b/net/vmw_vsock/virtio_transport_common.c
>index 169ba8b72a63..081e7ae93cb1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1079,6 +1079,9 @@ virtio_transport_recv_connected(struct sock *sk,
> 		virtio_transport_recv_enqueue(vsk, pkt);
> 		sk->sk_data_ready(sk);
> 		return err;
>+	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>+		virtio_transport_send_credit_update(vsk);
>+		break;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 		sk->sk_write_space(sk);
> 		break;
>-- 2.17.1
>

The patch LGTM, thanks for fixing this long-time issue!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

