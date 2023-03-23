Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC30F6C63B3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCWJeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCWJdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF12A19114
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679563758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fH6RVdKUD2qMc5iJ7El8bayWDBifjWMzYWs3C5XGkao=;
        b=NO3zghou7Nq+G5wDEc94eU4ubHRr+VZEiCyC2pJ4djh1YInibXGS7+p6U0CLBtXFzjzQjS
        LqZQtkdc3bxVByipWuaVpJbTJyZQbzl/NJ+YJoa1m2PGOV0JVDXAoUB2d6XQIdenceNZ2/
        ncAvalRSDPh9XvXXRM1mAmzr6VVy2PE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-iKRM3nBIP-KSzLSpiN2uZA-1; Thu, 23 Mar 2023 05:29:13 -0400
X-MC-Unique: iKRM3nBIP-KSzLSpiN2uZA-1
Received: by mail-qk1-f199.google.com with SMTP id ou5-20020a05620a620500b007423e532628so9901528qkn.5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679563753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fH6RVdKUD2qMc5iJ7El8bayWDBifjWMzYWs3C5XGkao=;
        b=6grmpPmHjYHsgzPhnM2UI5y4QWFqP8mK1oq4ZYxEl/bFizn1HSiKxee4h6+EOoovKK
         /qgLNBQyfERKvWMn1jCUwTXPmJmIRzuw/91OzurjGbhv+5VaeU3WGr0jHEBqbTeRRmhf
         W6mcG4Q9kVD7YIoJKn1jxA+IhT9dEsk9HHbRjCYKyiixQJCweQBUtWBb0ty2gzVCIyt/
         WLgd8yZ+lZ+sLCFSoMlU5Xhqjh+8IKx4IKs8cVirch/k+Hrcs+SPDGv5sbUh+BXblOVC
         qbJa45l7YOjhDCJtp5e0ps+pNfX1coqpXbWpdrp3+CkLpFG60JBUrqkXNe3Cb3pl8QYk
         eYkg==
X-Gm-Message-State: AO0yUKU11rXPIkId3pVNKNISX2qSE67jTx5Yy9w78tFhF+4ejO1xdpM3
        GwP/9nmUOHlcnQAnMRKzl1+4XQpC98CPEx3r0Bp1qjcwwkdTrv5aOSEdDFcSZnE8SVEB9l/maUe
        uOAvYgy7LHoYfaJxH
X-Received: by 2002:a05:622a:34e:b0:3e1:9557:123c with SMTP id r14-20020a05622a034e00b003e19557123cmr9437371qtw.52.1679563753153;
        Thu, 23 Mar 2023 02:29:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set+dTXZSkoRXA666MxWsVBLAIywm8KzMAVacD1thH1ce+YO4OCqSzCTtD2lH0cRCelCFnUU+cQ==
X-Received: by 2002:a05:622a:34e:b0:3e1:9557:123c with SMTP id r14-20020a05622a034e00b003e19557123cmr9437356qtw.52.1679563752860;
        Thu, 23 Mar 2023 02:29:12 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a228a00b007441b675e81sm12893452qkh.22.2023.03.23.02.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:29:12 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:29:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 2/2] virtio/vsock: check argument to avoid no
 effect call
Message-ID: <20230323092905.fpsiiaca2ba2wug3@sgarzare-redhat>
References: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
 <50bb0210-1ed7-42fb-b5f6-8d97247209b5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <50bb0210-1ed7-42fb-b5f6-8d97247209b5@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 09:36:24PM +0300, Arseniy Krasnov wrote:
>Both of these functions have no effect when input argument is 0, so to
>avoid useless spinlock access, check argument before it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 6 ++++++
> 1 file changed, 6 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 9e87c7d4d7cf..312658c176bd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -302,6 +302,9 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>
>+	if (!credit)
>+		return 0;
>+
> 	spin_lock_bh(&vvs->tx_lock);
> 	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (ret > credit)
>@@ -315,6 +318,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_get_credit);
>
> void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
>+	if (!credit)
>+		return;
>+
> 	spin_lock_bh(&vvs->tx_lock);
> 	vvs->tx_cnt -= credit;
> 	spin_unlock_bh(&vvs->tx_lock);
>-- 
>2.25.1
>

