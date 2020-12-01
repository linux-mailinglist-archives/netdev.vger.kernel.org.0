Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CF92CA82B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgLAQXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:23:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLAQXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606839740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uaNc1bG02ND+drTHBuHv0YOXrPi3zYs4BlR7gJGzseU=;
        b=jOWUtgaMWW27CJfhds5ZWEN4x1PJvtz0lghyEVa+TkmNyZP/CFM5bmmvjCACcGJ9s808Al
        aNn52C4b0ml1sR6GycbNwqxUeMdO4+eoWHlpKpNdgd3hvn2me1wAY+Fpij5CaY1ysWKaBH
        O+W44vetvNw7ptQYoeEwOjIl68+K/tg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-XYkEQt3wNYS_hxZki-R8Og-1; Tue, 01 Dec 2020 11:22:18 -0500
X-MC-Unique: XYkEQt3wNYS_hxZki-R8Og-1
Received: by mail-wr1-f72.google.com with SMTP id l5so1204105wrn.18
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uaNc1bG02ND+drTHBuHv0YOXrPi3zYs4BlR7gJGzseU=;
        b=iL3S78lM4QbgWDHqaj/EM9rjNm4oy985llgDH5/HPc8dTP4hW21x0z488eV0cbZEf+
         KDvl22h36ApMe0ZCpG4ndCMF0Jj8Pe/kabwDzdnx1nta3YPl0FCEKIpEj64IMha7jghP
         8cXe6jdtdprnA1gxO1mX79P9ugqrjzxnZB/eYYTGPcEjGRW7GXpfN7dVHJOP2JVaYu4q
         TWXaz9I43xAEQ8GlliM7TcUseMWtq4ialbzVW/nqpLy0q83tJdTzcCsOvr/rSvBe0+/n
         Dqzp5FYC7MxhttAI4unjazYJVDAFC4PHI60U/Y5PZIgWHn2lCULNIGepeVZi0q8iwbpy
         AA7g==
X-Gm-Message-State: AOAM530Z7UtFu6XF3kOUXnUp6aKPck2GZo3haHp8dEIXF5E85YksXnC7
        WSLFn537ji/zUEmMCUhOQb8Fuv2Zc3KwAXJVKR8fN94VdJgijzbCdDW+ShuvKILEbTaLOTf7EUS
        PtrGg7aYpMtRCVpUb
X-Received: by 2002:a1c:e084:: with SMTP id x126mr3496709wmg.109.1606839736563;
        Tue, 01 Dec 2020 08:22:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxL+nBC5nM1oqnfl74075vP/XvG9KeD2bzHCX+2QK5ZsH1NiuYezbXRvPOoOc3keUvrKOCleg==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr3496684wmg.109.1606839736355;
        Tue, 01 Dec 2020 08:22:16 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id o2sm66934wrq.37.2020.12.01.08.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:22:15 -0800 (PST)
Date:   Tue, 1 Dec 2020 17:22:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v1 2/3] virtio_transport_common: Set sibling VMs
 flag on the receive path
Message-ID: <20201201162213.adcshbtspleosyod@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201201152505.19445-3-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 05:25:04PM +0200, Andra Paraschiv wrote:
>The vsock flag can be set during the connect() setup logic, when
>initializing the vsock address data structure variable. Then the vsock
>transport is assigned, also considering this flag.
>
>The vsock transport is also assigned on the (listen) receive path. The
>flag needs to be set considering the use case.
>
>Set the vsock flag of the remote address to the one targeted for sibling
>VMs communication if the following conditions are met:
>
>* The source CID of the packet is higher than VMADDR_CID_HOST.
>* The destination CID of the packet is higher than VMADDR_CID_HOST.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 5956939eebb78..871c84e0916b1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1062,6 +1062,14 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
> 	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(pkt->hdr.src_cid),
> 			le32_to_cpu(pkt->hdr.src_port));
>

Maybe is better to create an helper function that other transports can 
use for the same purpose or we can put this code in the 
vsock_assign_transport() and set this flag only when the 'psk' argument 
is not NULL (this is the case when it's called by the transports when we 
receive a new connection request and 'psk' is the listener socket).

The second way should allow us to support all the transports without 
touching them.

>+	/* If the packet is coming with the source and destination CIDs higher
>+	 * than VMADDR_CID_HOST, then a vsock channel should be established for
>+	 * sibling VMs communication.
>+	 */
>+	if (vchild->local_addr.svm_cid > VMADDR_CID_HOST &&
>+	    vchild->remote_addr.svm_cid > VMADDR_CID_HOST)
>+		vchild->remote_addr.svm_flag = VMADDR_FLAG_SIBLING_VMS_COMMUNICATION;

svm_flag is always initialized to 0 in vsock_addr_init(), so this 
assignment is the first one and it's okay, but to avoid future issues 
I'd use |= here to set the flag.

Thanks,
Stefano

>+
> 	ret = vsock_assign_transport(vchild, vsk);
> 	/* Transport assigned (looking at remote_addr) must be the same
> 	 * where we received the request.
>-- 2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

