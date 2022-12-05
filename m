Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D2664285A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiLEMXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiLEMXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:23:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D24FCC4
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670242943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Fpu1oLPXixRs8SXVb53vX2+k8zH4l62xyUnVTqnhLI=;
        b=dMQDya763huKerwxVobS6BeuX5jwLh9sQmd5qcfnPClbwBVx8yBdagBmHsg+b5mbEkJNXc
        K4DK0CEW1n7hWM9c3lSrcmOh0sLluMksnVYL5Mjf2zTMy6DZ/1EjjENFcS/fODCQ66UNxt
        LzdZEWEsm413uh3xEkoGR26459G0584=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-hGSTzwylOvywMlU4GD5Vdw-1; Mon, 05 Dec 2022 07:22:21 -0500
X-MC-Unique: hGSTzwylOvywMlU4GD5Vdw-1
Received: by mail-wm1-f70.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso6793434wmb.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Fpu1oLPXixRs8SXVb53vX2+k8zH4l62xyUnVTqnhLI=;
        b=6sjdALzQ7yoJg3NeHYWc+ANOu6KMjVRr54blQd9t90RW8gEURch0HtRpe+cLL4DKNL
         1p4JjHW4+Xwz0HcMgutXDqmKofqr9ldvSWsDb8r3ZL6l7aj1IxXYS8UqNnE6L1F2wcGN
         /2QW1uXB7NRues/JTn/7LP2s6xYk7GPKPfYYaea3TmwIvuZTcmFfle+98qkeXgURPnRz
         RwnbrvUKCxFUCNUAaRV/gNgVhy93gQN0Wrhd94GTcmguoTjBCLo/Xo+iuilNw/8owwf7
         oj/bQF9Oj97WoYjc5lMIqJvi2EvhsrtbNikpDkBVKSyOAOxdmYFeRtiB+pygCLDS4Dbt
         6pbA==
X-Gm-Message-State: ANoB5plk4e2Y/0sjox1M8iyzv1aoBs5DaiKF8GBGfMiY9BskGBFjcvMj
        DLwoCY94gkr50B6klAogkqWkgMTE/Q3bqB9Lf0NUvbWqDinRsadgoBTx59V8vcLJJtc9Cn/P1DK
        ONUmQVseEH6eRgo8M
X-Received: by 2002:a05:6000:1b86:b0:241:9606:1123 with SMTP id r6-20020a0560001b8600b0024196061123mr45199175wru.537.1670242940856;
        Mon, 05 Dec 2022 04:22:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6lXoHQqNZ83Ji7T4v0uWQIKCS1P748eGLo9Jfj6gSuWt8L17oynW4Eb8SDldK2I9Z85TIOMg==
X-Received: by 2002:a05:6000:1b86:b0:241:9606:1123 with SMTP id r6-20020a0560001b8600b0024196061123mr45199150wru.537.1670242940594;
        Mon, 05 Dec 2022 04:22:20 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id a3-20020adffac3000000b0024245e543absm8823432wrs.88.2022.12.05.04.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:22:20 -0800 (PST)
Date:   Mon, 5 Dec 2022 13:22:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <20221205122214.bky3oxipck4hsqqe@sgarzare-redhat>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 09:35:18AM -0800, Bobby Eshleman wrote:
>This commit changes virtio/vsock to use sk_buff instead of
>virtio_vsock_pkt. Beyond better conforming to other net code, using
>sk_buff allows vsock to use sk_buff-dependent features in the future
>(such as sockmap) and improves throughput.
>
>This patch introduces the following performance changes:
>
>Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>Test Runs: 5, mean of results
>Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>
>Test: 64KB, g2h
>Before: 21.63 Gb/s
>After: 25.59 Gb/s (+18%)
>
>Test: 16B, g2h
>Before: 11.86 Mb/s
>After: 17.41 Mb/s (+46%)
>
>Test: 64KB, h2g
>Before: 2.15 Gb/s
>After: 3.6 Gb/s (+67%)
>
>Test: 16B, h2g
>Before: 14.38 Mb/s
>After: 18.43 Mb/s (+28%)
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
>Changes in v5:
>- last_skb instead of skb: last_hdr->len = cpu_to_le32(last_skb->len)

With this issue fixed, I confirm that all the tests passed:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


As pointed out in v4, this is net-next material, so you should use the 
net-next tag and base the patch on the net-next tree:
https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#netdev-faq

I locally applied the patch on net-next and everything is fine, so maybe 
the maintainers can apply it, otherwise you should resend it with the 
right tag.
Ah, in that case I suggest you send it before the next merge window 
opens (I guess next week), because net-next closes and you'll have to 
wait for the next cycle.

Thanks,
Stefano

