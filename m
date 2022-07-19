Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0318D579FBD
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbiGSNfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiGSNel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A83B8EEF2
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658234948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQ7i8DMmDNLQBzOxesas/9REVBIK8tkfXNsEsnI0ryg=;
        b=Rq/ifcv1AdJVs/VpkGcVe41ohxb3Kbj8iReyWfnJSZyXk68CNlk6LQY42wQ3cYdYWewDaK
        r2V7PzCSg3nUevyy5XJ5e/at/wSys11hGMcwMJiIVrIb9Ia79KTLZrZJG6B2yk9+0XNX90
        vejHKAFqaeVATduPEcXFPQi0Jj/f9iU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-XwMMYqcGP6OsuKC0QdXzsQ-1; Tue, 19 Jul 2022 08:49:07 -0400
X-MC-Unique: XwMMYqcGP6OsuKC0QdXzsQ-1
Received: by mail-qk1-f200.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so11587514qkp.7
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SQ7i8DMmDNLQBzOxesas/9REVBIK8tkfXNsEsnI0ryg=;
        b=7x1y73NXX2GiMfiVdd2ZqCYBRR61SRpGbsiIf5mg1dU5EWSc6lMWuf0kvRIl7XxJA7
         mf2Jqd9sFEK9WnyKvNSKYZ8VE0HDtPa2Vwk3cFDoyYOgCEsunXFFkJyZoaIYVCL6ZNUC
         J2nSknC9TTezQhuc2V7cE9v42AYN69+Nz49iATlVnnIjq0U4e7okXfNvz+PvBpGOSm/i
         MrJ1i4c4u7iOMkldzLRHzICUMeRVrqqHD8TwlRgZJCG/j29LRK/NoP7/4EEdU4EO+Cnt
         e72QUNggB6D9t8Xeh9SDdOuT4WPD2oG5nfkMDU2563uiWzS6VdY7xRLKLupgNL+tDrmd
         eKzQ==
X-Gm-Message-State: AJIora9Dx9kCjmoUJT3u4afbOYLSl1/bewHm0bZJ6qof0GcnmTO927sY
        OJ9eZFe1bGDKE1XF/0y8avfrcIFZx6xuaANDHba9+mX3P2OT521NfWrbsjPtguPIHU43wPeTTyY
        fqJn6BSymiQ1qZI67
X-Received: by 2002:a05:6214:5285:b0:472:ed70:23a0 with SMTP id kj5-20020a056214528500b00472ed7023a0mr24653533qvb.121.1658234946741;
        Tue, 19 Jul 2022 05:49:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uZuaMPjQgfS6W9/DnlaK0uE0XgUkrEb2ofE1GV4HHuSsM3Xbj6XHQUCZkbhYbWbuoG/U//nQ==
X-Received: by 2002:a05:6214:5285:b0:472:ed70:23a0 with SMTP id kj5-20020a056214528500b00472ed7023a0mr24653509qvb.121.1658234946505;
        Tue, 19 Jul 2022 05:49:06 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id dm53-20020a05620a1d7500b006b4880b08a9sm14522441qkb.88.2022.07.19.05.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:49:05 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:48:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Message-ID: <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:17:31AM +0000, Arseniy Krasnov wrote:
>This callback controls setting of POLLIN,POLLRDNORM output bits
>of poll() syscall,but in some cases,it is incorrectly to set it,
>when socket has at least 1 bytes of available data. Use 'target'
>which is already exists and equal to sk_rcvlowat in this case.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ec2c2afbf0d0..591908740992 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -634,7 +634,7 @@ virtio_transport_notify_poll_in(struct vsock_sock *vsk,
> 				size_t target,
> 				bool *data_ready_now)
> {
>-	if (vsock_stream_has_data(vsk))
>+	if (vsock_stream_has_data(vsk) >= target)
> 		*data_ready_now = true;
> 	else
> 		*data_ready_now = false;

Perhaps we can take the opportunity to clean up the code in this way:

	*data_ready_now = vsock_stream_has_data(vsk) >= target;

Anyway, I think we also need to fix the other transports (vmci and 
hyperv), what do you think?

Thanks,
Stefano

