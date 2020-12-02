Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2655F2CB7D6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 09:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgLBIzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 03:55:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728806AbgLBIzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 03:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606899233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9w4m/sge0TuQGCR2gfcG6iYSJrjNihD2+bXvVGYUQ5s=;
        b=PCXefezrKzJIxhLLCBbxj1Vt3Xpeo7jf/wFIJM9NP+w62SSeB2Qq/8KLINk4Jeiwv51IjR
        VVRfdLmwxq0PLVYHbA8Zyi57C5kFdgssSkG6D+OwdGDpj0XBnHF/zjEkITJ/zjtbuB08oa
        2GLPhKW4V3w5Uq2cye9Z342wY2FuQdA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-XriJ3w4bMPuwXG4u26wctg-1; Wed, 02 Dec 2020 03:53:51 -0500
X-MC-Unique: XriJ3w4bMPuwXG4u26wctg-1
Received: by mail-wm1-f72.google.com with SMTP id v5so2100020wmj.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 00:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9w4m/sge0TuQGCR2gfcG6iYSJrjNihD2+bXvVGYUQ5s=;
        b=AC2c9Afp+qA85lzVuNeKgf5v8rdMcJ6AQDgyjVUcErDdIf66uc8mmrqfmcpGEkmzCf
         YYjdC2YoxT8qY4DJulu7eP7AJPiKjbcctSK7knxphXxMCBxMnnpNodkn+iHaDLFod13U
         JhvBEsB89iV2exvmxpqeLA6XfSp3GPP+P0P16f/wXPjKfK+hUzp2miM5HZ/OSjwh7Iwq
         Y180BWOvFPRxZFZJ2huz0sgVk0st6/ryxTge/u14q5JiLTo5elXdBwaOClKG94Qot7Iy
         vvAXrGkHcN/bzj4X01TMyV7DdcMAmsB97Expa07Xf1yFfOljA8uQr0yBJmc03ta7RigO
         a0gQ==
X-Gm-Message-State: AOAM53216rFJh3GQXBqrWgZGdYyXNhB6EMIknEy+AiGmEtiC//yjcbwH
        oDq+TbZdhefZFUcmuQEC/WAQxQBDeP9IE/cH+lXeBTQElhnh4DMQG8iDWDE6nIsnx1LtJlN0iWL
        9hgg/CU0yBGFqKnTP
X-Received: by 2002:adf:e787:: with SMTP id n7mr2051718wrm.153.1606899229153;
        Wed, 02 Dec 2020 00:53:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2048Xx8/ayUKGwyTTcOiylk11X8e3WTcE5a5N28YO0bg7w+guMxBK8554ryoCCjBYE11PtA==
X-Received: by 2002:adf:e787:: with SMTP id n7mr2051697wrm.153.1606899228929;
        Wed, 02 Dec 2020 00:53:48 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id j13sm1202268wrp.70.2020.12.02.00.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 00:53:48 -0800 (PST)
Date:   Wed, 2 Dec 2020 09:53:45 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
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
Message-ID: <20201202085345.jfzxuxbeoics6f2a@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-3-andraprs@amazon.com>
 <20201201162213.adcshbtspleosyod@steredhat>
 <447c0557-68f7-54ae-88ac-ebe50c6f2f9b@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <447c0557-68f7-54ae-88ac-ebe50c6f2f9b@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:01:05PM +0200, Paraschiv, Andra-Irina wrote:
>
>
>On 01/12/2020 18:22, Stefano Garzarella wrote:
>>
>>On Tue, Dec 01, 2020 at 05:25:04PM +0200, Andra Paraschiv wrote:
>>>The vsock flag can be set during the connect() setup logic, when
>>>initializing the vsock address data structure variable. Then the vsock
>>>transport is assigned, also considering this flag.
>>>
>>>The vsock transport is also assigned on the (listen) receive path. The
>>>flag needs to be set considering the use case.
>>>
>>>Set the vsock flag of the remote address to the one targeted for sibling
>>>VMs communication if the following conditions are met:
>>>
>>>* The source CID of the packet is higher than VMADDR_CID_HOST.
>>>* The destination CID of the packet is higher than VMADDR_CID_HOST.
>>>
>>>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>>---
>>>net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
>>>1 file changed, 8 insertions(+)
>>>
>>>diff --git a/net/vmw_vsock/virtio_transport_common.c 
>>>b/net/vmw_vsock/virtio_transport_common.c
>>>index 5956939eebb78..871c84e0916b1 100644
>>>--- a/net/vmw_vsock/virtio_transport_common.c
>>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>>@@ -1062,6 +1062,14 @@ virtio_transport_recv_listen(struct sock 
>>>*sk, struct virtio_vsock_pkt *pkt,
>>>      vsock_addr_init(&vchild->remote_addr, 
>>>le64_to_cpu(pkt->hdr.src_cid),
>>>                      le32_to_cpu(pkt->hdr.src_port));
>>>
>>
>>Maybe is better to create an helper function that other transports can
>>use for the same purpose or we can put this code in the
>>vsock_assign_transport() and set this flag only when the 'psk' argument
>>is not NULL (this is the case when it's called by the transports when we
>>receive a new connection request and 'psk' is the listener socket).
>>
>>The second way should allow us to support all the transports without
>>touching them.
>
>Ack, I was wondering about the other transports such as vmci or hyperv.
>
>I can move the logic below in the codebase that assigns the transport, 
>after checking 'psk'.
>
>>
>>>+      /* If the packet is coming with the source and destination 
>>>CIDs higher
>>>+       * than VMADDR_CID_HOST, then a vsock channel should be 
>>>established for
>>>+       * sibling VMs communication.
>>>+       */
>>>+      if (vchild->local_addr.svm_cid > VMADDR_CID_HOST &&
>>>+          vchild->remote_addr.svm_cid > VMADDR_CID_HOST)
>>>+              vchild->remote_addr.svm_flag = 
>>>VMADDR_FLAG_SIBLING_VMS_COMMUNICATION;
>>
>>svm_flag is always initialized to 0 in vsock_addr_init(), so this
>>assignment is the first one and it's okay, but to avoid future issues
>>I'd use |= here to set the flag.
>
>Fair point. I was thinking more towards exclusive flags values 
>(purposes), but that's fine with the bitwise operator if we would get 
>a set of flag values together. I will also update the field name to 
>'svm_flags', let me know if we should keep the previous one or there 
>is a better option.

Yeah, maybe in the future we will add some new flags and we'll only need 
to add them without touching this code.

Agree with the new 'svm_flags' field name.

Thanks,
Stefano

