Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEAA4D42F9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiCJJAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiCJJAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:00:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13144F65F0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646902777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WQ/dYEhklhPcMo587rvR2qJ7KNlk74jXJG+JhU1AbRA=;
        b=e95muxb6WI7Hm9hXGWAp8uv0ThoXIjHOCRlbmL7zXuig99OnnF9PEjOZgQGWcZcSarYvok
        4NQLEaZSYCrgLpu9y67M9V0sgPWvAl5xN7rIzYdjSpGa7Evjn5f2cKrJ0Mg6neTKy0Ppcg
        jIAgUeLI56yyLDAOUKosebunRUNhUFo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-gMxQQk2VPcehpv9JUoY70w-1; Thu, 10 Mar 2022 03:59:36 -0500
X-MC-Unique: gMxQQk2VPcehpv9JUoY70w-1
Received: by mail-ed1-f72.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso2759224edh.1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WQ/dYEhklhPcMo587rvR2qJ7KNlk74jXJG+JhU1AbRA=;
        b=KMNsi2/rsj0lbgTWxLRNuMFeVhBUvCDZpiekOuPfKFehxEjgTjSxLaTRlqGu6wjkH+
         itsGRo3UcEjcek0UeW+3IeAMlvXZXHSanzz/mrZD82DkIHXN9EyXzc/jaM0u+ySKgZcU
         cNd+3xv1/8PJVIqHYrY6tgh/608XSwPmL5h/ORs6gQb3ax74tInd7vKI5bcTpcVWvld7
         1BhIQsFk8s8GPiJPb1DBS4ffsiBtbld6wFfDLlInffkT1tyszaYAgkxq2NewZqUQKdDZ
         IJlZMYcc2cQiUdk4t8scdtNETxrAL70zQMIPcqUZoI17WP8LHnbsFGGjXqrZysyFTrdL
         pz9w==
X-Gm-Message-State: AOAM531e9g5B+Vw4n6QseOGDZMsNcjRZg3GaZTIJsbWN9bZYBgOwmowJ
        3jt9Jq7IbV8IxO11OiY5YHXw8X1F4n1JMld2lfVjYenmiMiLFAO8d41aGxsXJzGG+RV4cmoemNX
        QkKpUFPNxWnwmDRuZ
X-Received: by 2002:a17:907:2a53:b0:6ce:e4fe:3f92 with SMTP id fe19-20020a1709072a5300b006cee4fe3f92mr3207212ejc.389.1646902774852;
        Thu, 10 Mar 2022 00:59:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3lIVlYhT5pB9vGmIIkaBIM5FzigFqHE7Plk2kLwaMt42aBHUIWqvpJN1SkNr5CjX+UXVYzg==
X-Received: by 2002:a17:907:2a53:b0:6ce:e4fe:3f92 with SMTP id fe19-20020a1709072a5300b006cee4fe3f92mr3207197ejc.389.1646902774597;
        Thu, 10 Mar 2022 00:59:34 -0800 (PST)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id n13-20020a1709062bcd00b006cf71d46a1csm1546859ejg.136.2022.03.10.00.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 00:59:34 -0800 (PST)
Date:   Thu, 10 Mar 2022 09:59:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: reset only the h2g connections upon release
Message-ID: <20220310085931.cpgc2cv4yg7sd4vu@sgarzare-redhat>
References: <20220310081854.2487280-1-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220310081854.2487280-1-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiyong,

On Thu, Mar 10, 2022 at 05:18:54PM +0900, Jiyong Park wrote:
>Filtering non-h2g connections out when determining orphaned connections.
>Otherwise, in a nested VM configuration, destroying the nested VM (which
>often involves the closing of /dev/vhost-vsock if there was h2g
>connections to the nested VM) kills not only the h2g connections, but
>also all existing g2h connections to the (outmost) host which are
>totally unrelated.
>
>Tested: Executed the following steps on Cuttlefish (Android running on a
>VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
>connection inside the VM, (2) open and then close /dev/vhost-vsock by
>`exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
>session is not reset.
>
>[1] https://android.googlesource.com/device/google/cuttlefish/
>
>Signed-off-by: Jiyong Park <jiyong@google.com>
>---
> drivers/vhost/vsock.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 37f0b4274113..2f6d5d66f5ed 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> 	 * executing.
> 	 */
>
>+	/* Only the h2g connections are reset */
>+	if (vsk->transport != &vhost_transport.transport)
>+		return;
>+
> 	/* If the peer is still valid, no need to reset connection */
> 	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> 		return;
>-- 
>2.35.1.723.g4982287a31-goog
>

Thanks for your patch!

Yes, I see the problem and I think I introduced it with the 
multi-transports support (ooops).

So we should add this fixes tag:

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")


IIUC the problem is for all transports that should only cycle on their 
own sockets. Indeed I think there is the same problem if the g2h driver 
will be unloaded (or a reset event is received after a VM migration), it 
will close all sockets of the nested h2g.

So I suggest a more generic solution, modifying 
vsock_for_each_connected_socket() like this (not tested):

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 38baeb189d4e..f04abf662ec6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
  }
  EXPORT_SYMBOL_GPL(vsock_remove_sock);

-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+                                    void (*fn)(struct sock *sk))
  {
         int i;

@@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
         for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
                 struct vsock_sock *vsk;
                 list_for_each_entry(vsk, &vsock_connected_table[i],
-                                   connected_table)
+                                   connected_table) {
+                       if (vsk->transport != transport)
+                               continue;
+
                         fn(sk_vsock(vsk));
+               }
         }


And all transports that call it.

Thanks,
Stefano

