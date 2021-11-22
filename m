Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15764458B96
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhKVJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 04:35:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238973AbhKVJfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 04:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637573528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=belxqpIEPM8b5ddVw8XKTj7NYwBuhVnMMeNM/xGD1js=;
        b=EmHpjYzrwpEm0HtcjiRdqU6j3iaHxYY6ckHVZwVP40wAxBdsJNO0uuZHKT9irqEt/GW69t
        WQbMmxyjzFRCPIxpsgRzyF1WD5P/i/F46n+dtiA7M2ZF6IaZbG9ybU8TMWKIMg6cogR8um
        YI687xxpOqXyjs+VkqrQo2XaPBfdx2c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-ozrFILdJOOWn-L2dXpOrZQ-1; Mon, 22 Nov 2021 04:32:06 -0500
X-MC-Unique: ozrFILdJOOWn-L2dXpOrZQ-1
Received: by mail-ed1-f72.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so14233557edq.16
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 01:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=belxqpIEPM8b5ddVw8XKTj7NYwBuhVnMMeNM/xGD1js=;
        b=ZRFvM756G4htAdIrGHjlCT9Xwr9qyr5iKk1S7diSJAwU6k3k6czXlKQ+XMtY9vGbnN
         d+e4sPgvRX6OaImfDU+lt3py/qwh4r7hHuqfD4ZSc1OY9I6PYpNeY7gPmcYPMJAoDWvD
         y+Pigp3M8NePvnfu41ygxvwu7nDO3dQVNnVB8vy4JURjsI7pfBd4HRKaGA8vyA/V9Rxk
         8KUa4taX5eRbWuQAi65KwiOPFEubp9d+L2WNZ7klZJmooloFpCPke6BVK4R6ipAi6G6s
         nNltNnurrgPqtGfoeZbGkcahVcqAJ60tLTEr760f28kbcicLhL+IVfKGXfBcrUNevTjD
         Szrg==
X-Gm-Message-State: AOAM533rmMM+3o9IxliMiRbtrQw9zFGd1WEb9/HFKVL4JptsIKcBPzQ+
        jNoCmnwucTsOUHGJJvSX25YW7efTV2/d0LpB71BtIIVJWmW0ulxfYUADF2QZliMNG3tK2zOTYGR
        CDoSZqMWtjK4A9ojJ
X-Received: by 2002:a17:906:b2d0:: with SMTP id cf16mr38631561ejb.52.1637573525285;
        Mon, 22 Nov 2021 01:32:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwaDt8hngfWzHfFUTs49+2toJfr7BA5IoCX89wF8FGrB5kAMe2yz7xlpf9wWvnAeYerGQlgwg==
X-Received: by 2002:a17:906:b2d0:: with SMTP id cf16mr38631543ejb.52.1637573525115;
        Mon, 22 Nov 2021 01:32:05 -0800 (PST)
Received: from redhat.com ([2.55.128.84])
        by smtp.gmail.com with ESMTPSA id jg32sm3539120ejc.43.2021.11.22.01.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 01:32:04 -0800 (PST)
Date:   Mon, 22 Nov 2021 04:32:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        f.hetzelt@tu-berlin.de, david.kaplan@amd.com,
        konrad.wilk@oracle.com
Subject: [PATCH] vsock/virtio: suppress used length validation
Message-ID: <20211122093036.285952-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out that vhost vsock violates the virtio spec
by supplying the out buffer length in the used length
(should just be the in length).
As a result, attempts to validate the used length fail with:
vmw_vsock_virtio_transport virtio1: tx: used len 44 is larger than in buflen 0

Since vsock driver does not use the length fox tx and
validates the length before use for rx, it is safe to
suppress the validation in virtio core for this driver.

Reported-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 939779f5152d ("virtio_ring: validate used buffer length")
Cc: "Jason Wang" <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 4f7c99dfd16c..3f82b2f1e6dd 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -731,6 +731,7 @@ static unsigned int features[] = {
 static struct virtio_driver virtio_vsock_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
+	.suppress_used_validation = true,
 	.driver.name = KBUILD_MODNAME,
 	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
-- 
MST

