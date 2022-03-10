Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03F64D4795
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242253AbiCJNDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiCJNDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:03:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1F5714AC9D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646917320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RWMS1CuuTjg/dxyi6dNPKqfhAnq0QfD6tRtdo/5dGxE=;
        b=M8vdPttm3qoDioC6t6zAahc/jPD7xmN4zOYjG72kxvkZJVhNgSgHJ3ZtDQrlNOZKHPknpW
        TGvu98CmtS7JXR2RI9QbErd7jljKUPvrfhsvznR6x97nshfRzr6qhcwcZKtgn/R5HuMw9J
        qYUdO5eqNS2PG+g9esWMs64IJ8L7SAQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-FxLNtp0iMfi-hnAkYCNL1w-1; Thu, 10 Mar 2022 08:01:59 -0500
X-MC-Unique: FxLNtp0iMfi-hnAkYCNL1w-1
Received: by mail-wm1-f70.google.com with SMTP id 187-20020a1c19c4000000b0037cc0d56524so4054911wmz.2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:01:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RWMS1CuuTjg/dxyi6dNPKqfhAnq0QfD6tRtdo/5dGxE=;
        b=g/bhhL5dlHw91hhqqNgB0gj0xZ9VVh0tcVa0sE2m4jd5GGUgtmqJokXlehYFdQL1Fa
         G/AR9fnSBR4RgWAw6RcqzV1rPzXmU2IkgIIkWXEAhDzYuWkgsIrrsqPowukcFRL3ZD0O
         IlM9A81lTDuxxvB8bFw1MoV+/Ry5IX/5OGTSLNkCAiN3e67DiwjZY2LPhXxGKMYGy2VL
         zBcidk+oomZaaDO7mfRSEplgYnG/Qgcoeo+Vua90BYrFABlUFrLAym8kVzl/U/8E9ibu
         mCOPP8fud68+7nG/MfQoNSqni/nls3CSVQEf4Sv2OhVcxpxWGq8YFOEj+cvSUYlZcua3
         1uGg==
X-Gm-Message-State: AOAM532byS8tTn1o6TdWifLaHZdbSbdw2UhquBLFbQuHNRVMfyoA9Eqy
        JfQBkoKd04GwDCZLNLiqamXTE8rIA4o+6cXqDpiBVoUBbq0N+uxzQe6z3RD7E1oq9cpgEIMr8fs
        XnDwpg5CQfKHKFVmi
X-Received: by 2002:a5d:6d41:0:b0:1ef:f32c:18ee with SMTP id k1-20020a5d6d41000000b001eff32c18eemr3489829wri.532.1646917318298;
        Thu, 10 Mar 2022 05:01:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzG8zUynya3aZ1k62/HZYUuzx+jvS8PFleAyItoEwxyNae7kQtcQuOPFd+KwfonhP3HTCC0Bw==
X-Received: by 2002:a5d:6d41:0:b0:1ef:f32c:18ee with SMTP id k1-20020a5d6d41000000b001eff32c18eemr3489798wri.532.1646917317914;
        Thu, 10 Mar 2022 05:01:57 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id r186-20020a1c2bc3000000b0037bdd94a4e5sm4477363wmr.39.2022.03.10.05.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 05:01:57 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:01:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
Message-ID: <20220310075933-mutt-send-email-mst@kernel.org>
References: <20220310125425.4193879-1-jiyong@google.com>
 <20220310125425.4193879-2-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310125425.4193879-2-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 09:54:24PM +0900, Jiyong Park wrote:
> When iterating over sockets using vsock_for_each_connected_socket, make
> sure that a transport filters out sockets that don't belong to the
> transport.
> 
> There actually was an issue caused by this; in a nested VM
> configuration, destroying the nested VM (which often involves the
> closing of /dev/vhost-vsock if there was h2g connections to the nested
> VM) kills not only the h2g connections, but also all existing g2h
> connections to the (outmost) host which are totally unrelated.
> 
> Tested: Executed the following steps on Cuttlefish (Android running on a
> VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> connection inside the VM, (2) open and then close /dev/vhost-vsock by
> `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> session is not reset.
> 
> [1] https://android.googlesource.com/device/google/cuttlefish/
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Signed-off-by: Jiyong Park <jiyong@google.com>
> ---
>  drivers/vhost/vsock.c            | 4 ++++
>  net/vmw_vsock/virtio_transport.c | 7 +++++++
>  net/vmw_vsock/vmci_transport.c   | 5 +++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 37f0b4274113..853ddac00d5b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>  	 * executing.
>  	 */
>  
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &vhost_transport.transport)
> +		return;
> +
>  	/* If the peer is still valid, no need to reset connection */
>  	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
>  		return;


We know this is incomplete though. So I think it's the wrong thing to do
when you backport, too. If all you worry about is breaking a binary
module interface, how about simply exporting a new function when you
backport. Thus you will have downstream both:

void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));

void vsock_for_each_connected_socket_new(struct vsock_transport *transport,
                                    void (*fn)(struct sock *sk));


and then upstream we can squash these two patches.

Hmm?


> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index fb3302fff627..61b24eb31d4b 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -24,6 +24,7 @@
>  static struct workqueue_struct *virtio_vsock_workqueue;
>  static struct virtio_vsock __rcu *the_virtio_vsock;
>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> +static struct virtio_transport virtio_transport; /* forward declaration */
>  
>  struct virtio_vsock {
>  	struct virtio_device *vdev;
> @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
>  
>  static void virtio_vsock_reset_sock(struct sock *sk)
>  {
> +	struct vsock_sock *vsk = vsock_sk(sk);
> +
>  	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
>  	 * under vsock_table_lock so the sock cannot disappear while we're
>  	 * executing.
>  	 */
>  
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &virtio_transport.transport)
> +		return;
> +
>  	sk->sk_state = TCP_CLOSE;
>  	sk->sk_err = ECONNRESET;
>  	sk_error_report(sk);
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index 7aef34e32bdf..cd2f01513fae 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
>  	struct vsock_sock *vsk;
>  
>  	vsk = vsock_sk(sk);
> +
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &vmci_transport)
> +		return;
> +
>  	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
>  		sock_set_flag(sk, SOCK_DONE);
>  
> -- 
> 2.35.1.723.g4982287a31-goog

