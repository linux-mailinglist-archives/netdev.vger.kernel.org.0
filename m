Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540D158AAF2
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 14:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbiHEMmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 08:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiHEMms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 08:42:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7092918341
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 05:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659703366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JbNzuUNlONNPGBpeyjfKi2f8mYMJka6a1j60uZitIeU=;
        b=dyk/NYJrRNWrdFm4ZIvFlYQ8ihhmex0RsQd1hhHfpU5nUxm87qNlXN0mtyVuLtxt8pxFzC
        oTQe96/VUEBSTkFT62qd1mKSP3/deAEYikF5iyqLQa4TFsdocIP4tDwPSdJKhcOUQomQ49
        Xrnys8lFctUyKlv44ATaifUj4RS84e0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-k3asnM6JMQSgMffM0CIzNA-1; Fri, 05 Aug 2022 08:42:45 -0400
X-MC-Unique: k3asnM6JMQSgMffM0CIzNA-1
Received: by mail-wm1-f72.google.com with SMTP id c189-20020a1c35c6000000b003a4bfb16d86so1242074wma.3
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 05:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=JbNzuUNlONNPGBpeyjfKi2f8mYMJka6a1j60uZitIeU=;
        b=aONr+1ehpxfsrWoogC3XYGn8yHJG/+aj2ZhoGtJ0KlmAx7gcqFld1bm0YJbN25qQDX
         NzXmp0hi+i4EeerKTiKQSNrZpsLRlyYUE5KqVIQ/rxxnu3zTPbPRwUK8d+WroGo3uUUp
         +dma/zgD/CmooceZF1TxVGwPFSrZvdJksxRdREzaiZEesF1Leb7+vO3E1naNP34g3/ue
         d2zrtYPnnulGaRJQhMgViDtJnkdeDqIrTC4bGiOX4m9buoH8ruHIcqsqJqdZIe+5NaPF
         nuwL2LKtytsyl6+p1rJkUSmrybUIMLqjTp9oHTtQE0A6ppXd4Ogm6JcpnH4lk8Zr0iPM
         cwMA==
X-Gm-Message-State: ACgBeo0pT3WF1peYTukApobTiV9LxAmUTQxZ/teyghi+wqXvvVETfRHt
        p5H3UE7/4jU9BCrn7PCXWu/qaaSAXZ8ALo2xie/8OZKIiWIUOsNKbZrA71GF4xsExPlDggzhWGc
        rom5uBIA5ycwvhM45
X-Received: by 2002:a05:6000:10c3:b0:21f:15aa:1b68 with SMTP id b3-20020a05600010c300b0021f15aa1b68mr4285504wrx.693.1659703364148;
        Fri, 05 Aug 2022 05:42:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4FBixHL1jxLf6cGBv7tQy3XiRqmkIIqWAMrqrcbMs3wyml1Ga267IspwQxC1cUWPEdc4mg6g==
X-Received: by 2002:a05:6000:10c3:b0:21f:15aa:1b68 with SMTP id b3-20020a05600010c300b0021f15aa1b68mr4285486wrx.693.1659703363869;
        Fri, 05 Aug 2022 05:42:43 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id l3-20020a5d4803000000b0021e42e7c7dbsm3802357wrq.83.2022.08.05.05.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 05:42:43 -0700 (PDT)
Date:   Fri, 5 Aug 2022 14:42:39 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next] vsock: Reschedule connect_work for
 O_NONBLOCK connect() requests
Message-ID: <20220805124239.iy5lkeytqwjyvn7g@sgarzare-redhat>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
 <20220804065923.66bor7cyxwk2bwsf@sgarzare-redhat>
 <20220804234447.GA2294@bytedance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220804234447.GA2294@bytedance>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 04:44:47PM -0700, Peilin Ye wrote:
>Hi Stefano,
>
>On Thu, Aug 04, 2022 at 08:59:23AM +0200, Stefano Garzarella wrote:
>> The last thing I was trying to figure out before sending the patch was
>> whether to set sock->state = SS_UNCONNECTED in vsock_connect_timeout().
>>
>> I think we should do that, otherwise a subsequent to connect() with
>> O_NONBLOCK set would keep returning -EALREADY, even though the timeout has
>> expired.
>>
>> What do you think?
>
>Thanks for bringing this up, after thinking about sock->state, I have 3
>thoughts:
>
>1. I think the root cause of this memleak is, we keep @connect_work
>   pending, even after the 2nd, blocking request times out (or gets
>   interrupted) and sets sock->state back to SS_UNCONNECTED.
>
>   @connect_work is effectively no-op when sk->sk_state is
>   TCP_CLOS{E,ING} anyway, so why not we just cancel @connect_work when
>   blocking requests time out or get interrupted?  Something like:
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..62628af84164 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1402,6 +1402,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>                lock_sock(sk);
>
>                if (signal_pending(current)) {
>+                       if (cancel_delayed_work(&vsk->connect_work))
>+                               sock_put(sk);
>+
>                        err = sock_intr_errno(timeout);
>                        sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
>                        sock->state = SS_UNCONNECTED;
>@@ -1409,6 +1412,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>                        vsock_remove_connected(vsk);
>                        goto out_wait;
>                } else if (timeout == 0) {
>+                       if (cancel_delayed_work(&vsk->connect_work))
>+                               sock_put(sk);
>+
>                        err = -ETIMEDOUT;
>                        sk->sk_state = TCP_CLOSE;
>                        sock->state = SS_UNCONNECTED;
>
>   Then no need to worry about rescheduling @connect_work, and the state
>   machine becomes more accurate.  What do you think?  I will ask syzbot
>   to test this.

It could work, but should we set `sk->sk_err` and call sk_error_report() 
to wake up thread waiting on poll()?

Maybe the previous version is simpler.

>
>2. About your suggestion of setting sock->state = SS_UNCONNECTED in
>   vsock_connect_timeout(), I think it makes sense.  Are you going to
>   send a net-next patch for this?

If you have time, feel free to send it.

Since it is a fix, I believe you can use the "net" tree. (Also for this 
patch).

Remember to put the "Fixes" tag that should be the same.

>
>3. After a TCP_SYN_SENT sock receives VIRTIO_VSOCK_OP_RESPONSE in
>   virtio_transport_recv_connecting(), why don't we cancel 
>   @connect_work?
>   Am I missing something?

Because when the timeout will fire, vsock_connect_timeout() will just 
call sock_put() since sk->sk_state is changed.

Of course, we can cancel it if we want, but I think it's not worth it.
In the end, this rescheduling patch should solve all the problems.

Thanks,
Stefano

