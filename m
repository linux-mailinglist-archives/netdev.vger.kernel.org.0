Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2106CBB45
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjC1Jkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjC1Jki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AE72101
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679996385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SwPWb91WcUx6K1IICpQUovViuiJcsfmj59FF6gVXRXI=;
        b=K2mScgF89m8kdNNTBGmFH8Y9aKve16K3FXu184eS6tIKR8lRbAaEmxTCGOMN1aFJFTtYvX
        FSlTO98al5e7f2/vINe6E71TOjeUYrbNLZPzEJVaHAxRIFGR2QUYak/PO7OD1DFoj63UQe
        OnRcrhetSCnKJHHUjjpWJxDjvyIt8Oo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-OqWoPXBlNxiNtiPFCS6drQ-1; Tue, 28 Mar 2023 05:39:41 -0400
X-MC-Unique: OqWoPXBlNxiNtiPFCS6drQ-1
Received: by mail-qk1-f197.google.com with SMTP id c186-20020a379ac3000000b007484744a472so5061723qke.22
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwPWb91WcUx6K1IICpQUovViuiJcsfmj59FF6gVXRXI=;
        b=RuFt+Rz19x3/1zZK/kiF7b2EkxM9SLdm63RP32JoyG3jX/5lrgBxKnxqO2E1FPy6my
         a2jywCmieESS/lm+gUfXpXmegEYG6D7T7Sc2Sz3P+kcy0kkibH8yfQl5rRc3Qr5GJiTZ
         mrX6FgsWlTTNT5GMTYuJ3DCfp0G+AKcdVpICulvyqdVsSco+t9NOZ+8SH64V96pkoiPL
         XmmmbBWM00tp6KmQ8eqIh/HllmMkszxFtxNfRuP9+HrzVA1jShY/ltWhNwmqG0FjRFwe
         gtOdvVfP1DkNDKYQSG1aBpwXadk9C+7zNqG3gd4bu+JEcxh2YEbU3e9cDBTU9qrKpJfA
         ADhA==
X-Gm-Message-State: AAQBX9dlUoZbfmm7yWzs9V/lioGTVxN3OzkXfJ7WFxzjAQWkvZraXw0a
        QYyau7BI/ZbUILXDw04WWLMe4ktkw6273d0+Z/PZUHb6D+XUwsNwBn/0fcqfFIOkAfc79UYkMq3
        ru0RYX8yJTUBfyw+s
X-Received: by 2002:a05:6214:518b:b0:5bb:eefc:1623 with SMTP id kl11-20020a056214518b00b005bbeefc1623mr21401847qvb.42.1679996381318;
        Tue, 28 Mar 2023 02:39:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvqOhRxjuWkb/qDRFEYG95lVTMqkyN1lH2NCL72/Gi430kGp8+0vpnXNL4RhABqLUioJi5lA==
X-Received: by 2002:a05:6214:518b:b0:5bb:eefc:1623 with SMTP id kl11-20020a056214518b00b005bbeefc1623mr21401832qvb.42.1679996381014;
        Tue, 28 Mar 2023 02:39:41 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id pe6-20020a056214494600b005dd8b9345a4sm3590288qvb.60.2023.03.28.02.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:39:40 -0700 (PDT)
Date:   Tue, 28 Mar 2023 11:39:35 +0200
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
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
>This removes behaviour, where error code returned from any transport
>was always switched to ENOMEM. This works in the same way as:
>commit
>c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>but for receive calls.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 19aea7cba26e..9262e0b77d47 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>
> 		read = transport->stream_dequeue(vsk, msg, len - copied, flags);

In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.

Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
those functions fail to keep the same behavior.

CCing Bryan, Vishnu, and pv-drivers@vmware.com

The other transports seem okay to me.

Thanks,
Stefano

> 		if (read < 0) {
>-			err = -ENOMEM;
>+			err = read;
> 			break;
> 		}
>
>@@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>
> 	if (msg_len < 0) {
>-		err = -ENOMEM;
>+		err = msg_len;
> 		goto out;
> 	}
>
>-- 
>2.25.1
>

