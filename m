Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B900C625C28
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 15:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiKKOBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 09:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiKKOAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 09:00:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F6C787B1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 05:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668174969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TJKpwo9c5AlIwO79tP1KNz4b2zBwa7daS3MoX79E/OA=;
        b=gO/7oG6w1FKey3oRLIBT/i7+/uQF6pcuXU2iPCJxl0lgCslloayXctkXNVrd910GPw0LWN
        WkApgZgl9w04yhQUq+Z3utmD18GaGKodv51ozP0zq7EdR3u+tHbG7LyZ2obxvWEy1HILAm
        t2Nwfu2CCaJo/3umO2jvqytPMbIegjQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-ECpH8q0CPLWW_wAk9bJJmA-1; Fri, 11 Nov 2022 08:56:07 -0500
X-MC-Unique: ECpH8q0CPLWW_wAk9bJJmA-1
Received: by mail-qv1-f71.google.com with SMTP id d8-20020a0cfe88000000b004bb65193fdcso3694245qvs.12
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 05:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJKpwo9c5AlIwO79tP1KNz4b2zBwa7daS3MoX79E/OA=;
        b=eaMkTy5Q77x6MyrigGTDG5PfMZW0Ztm/lII39y8XbW1p4kC+2EcwZcU8JD/grh/9F5
         Qs3r8KEEomcHWx0lWJ6/EgYPgfQAfDmxiFX2x8vN4vI5IOtZEJ2u7w+CFnS/dQKtBicm
         KgIpVjIK0viy44pPOPB+dovKO6EDumAFIcUfYBiGMBvlEdZwm24fxsoa4tGPxBgs+yqn
         wuTAE81dQx3mvBaOVgPbR/RFhMren8ZNtrR/0+zmgUNpBrBzPfmXu27Bm/tfDVCrWm3l
         Ofyl+KAc+cnwA8cm/4HfpZZ63DXtlRhAzOpdEwrDsDzob2Mxah1t2PMSCh2HmnLutSUa
         A39A==
X-Gm-Message-State: ANoB5pmT3z3yBl4+5aPdkajTf966tM1prWc+6rokfmCFUzByOO99UBSf
        zehNSDE2OnixxWUef1kdW21Nqb6m5DvZ8KimeilToFcGDCOjivf+FPB+ZpbRy9rFQhkHQVRYtro
        oOK+zSawplIb1MJyc
X-Received: by 2002:a05:620a:31a6:b0:6fa:172:c37d with SMTP id bi38-20020a05620a31a600b006fa0172c37dmr1097466qkb.92.1668174967411;
        Fri, 11 Nov 2022 05:56:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6E5N9TDha/oV3wOK0mu591qSZ1deevMEXV4lCRSdcvw2q6QTjtAAHLB3tamhyy49x6iMriNA==
X-Received: by 2002:a05:620a:31a6:b0:6fa:172:c37d with SMTP id bi38-20020a05620a31a600b006fa0172c37dmr1097448qkb.92.1668174967146;
        Fri, 11 Nov 2022 05:56:07 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id ay13-20020a05620a178d00b006b929a56a2bsm1486708qkb.3.2022.11.11.05.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 05:56:06 -0800 (PST)
Date:   Fri, 11 Nov 2022 14:55:49 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 03/11] af_vsock: add zerocopy receive logic
Message-ID: <20221111135549.2fqufprbc3muedmr@sgarzare-redhat>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <7aeba781-db09-9be1-a9a3-a4c16da38fb5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7aeba781-db09-9be1-a9a3-a4c16da38fb5@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:40:12PM +0000, Arseniy Krasnov wrote:
>This:
>1) Adds callback for 'mmap()' call on socket. It checks vm area flags
>   and sets vm area ops.
>2) Adds special 'getsockopt()' case which calls transport zerocopy
>   callback. Input argument is vm area address.
>3) Adds 'getsockopt()/setsockopt()' for switching on/off rx zerocopy
>   mode.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h          |   8 ++
> include/uapi/linux/vm_sockets.h |   3 +
> net/vmw_vsock/af_vsock.c        | 187 +++++++++++++++++++++++++++++++-
> 3 files changed, 196 insertions(+), 2 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 568a87c5e0d0..e4f12ef8e623 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -73,6 +73,8 @@ struct vsock_sock {
>
> 	/* Private to transport. */
> 	void *trans;
>+
>+	bool rx_zerocopy_on;

Maybe better to leave the last fields the private ones to transports, so 
I would say put it before trans;

> };
>
> s64 vsock_stream_has_data(struct vsock_sock *vsk);
>@@ -138,6 +140,12 @@ struct vsock_transport {
> 	bool (*stream_allow)(u32 cid, u32 port);
> 	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
>
>+	int (*zerocopy_rx_mmap)(struct vsock_sock *vsk,
>+				struct vm_area_struct *vma);
>+	int (*zerocopy_dequeue)(struct vsock_sock *vsk,
>+				struct page **pages,
>+				unsigned long *pages_num);
>+
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> 				     int flags);
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index c60ca33eac59..d1f792bed1a7 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -83,6 +83,9 @@
>
> #define SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW 8
>
>+#define SO_VM_SOCKETS_MAP_RX 9
>+#define SO_VM_SOCKETS_ZEROCOPY 10

Before removing RFC, we should document these macros because they are 
exposed to the user.

>+
> #if !defined(__KERNEL__)
> #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && 
> defined(__ILP32__))
> #define SO_VM_SOCKETS_CONNECT_TIMEOUT SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ee418701cdee..21a915eb0820 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1663,6 +1663,16 @@ static int vsock_connectible_setsockopt(struct socket *sock,
> 		}
> 		break;
> 	}
>+	case SO_VM_SOCKETS_ZEROCOPY: {
>+		if (sock->state != SS_UNCONNECTED) {
>+			err = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		COPY_IN(val);
>+		vsk->rx_zerocopy_on = val;
>+		break;
>+	}
>
> 	default:
> 		err = -ENOPROTOOPT;
>@@ -1676,6 +1686,124 @@ static int vsock_connectible_setsockopt(struct socket *sock,
> 	return err;
> }
>
>+static const struct vm_operations_struct afvsock_vm_ops = {
>+};
>+
>+static int vsock_recv_zerocopy(struct socket *sock,
>+			       unsigned long address)
>+{
>+	const struct vsock_transport *transport;
>+	struct vm_area_struct *vma;
>+	unsigned long vma_pages;
>+	struct vsock_sock *vsk;
>+	struct page **pages;
>+	struct sock *sk;
>+	int err;
>+	int i;
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+
>+	lock_sock(sk);
>+
>+	if (!vsk->rx_zerocopy_on) {
>+		err = -EOPNOTSUPP;
>+		goto out_unlock_sock;
>+	}
>+
>+	transport = vsk->transport;
>+
>+	if (!transport->zerocopy_dequeue) {
>+		err = -EOPNOTSUPP;
>+		goto out_unlock_sock;
>+	}
>+
>+	mmap_write_lock(current->mm);
>+
>+	vma = vma_lookup(current->mm, address);
>+
>+	if (!vma || vma->vm_ops != &afvsock_vm_ops) {
>+		err = -EINVAL;
>+		goto out_unlock_vma;
>+	}
>+
>+	/* Allow to use vm area only from the first page. */
>+	if (vma->vm_start != address) {
>+		err = -EINVAL;
>+		goto out_unlock_vma;
>+	}
>+
>+	vma_pages = (vma->vm_end - vma->vm_start) / PAGE_SIZE;
>+	pages = kmalloc_array(vma_pages, sizeof(pages[0]),
>+			      GFP_KERNEL | __GFP_ZERO);
>+
>+	if (!pages) {
>+		err = -EINVAL;
>+		goto out_unlock_vma;
>+	}
>+
>+	err = transport->zerocopy_dequeue(vsk, pages, &vma_pages);
>+
>+	if (err)
>+		goto out_unlock_vma;
>+
>+	/* Now 'vma_pages' contains number of pages in array.
>+	 * If array element is NULL, skip it, go to next page.
>+	 */
>+	for (i = 0; i < vma_pages; i++) {
>+		if (pages[i]) {
>+			unsigned long pages_inserted;
>+
>+			pages_inserted = 1;
>+			err = vm_insert_pages(vma, address, &pages[i], &pages_inserted);
>+
>+			if (err || pages_inserted) {
>+				/* Failed to insert some pages, we have "partially"
>+				 * mapped vma. Do not return, set error code. This
>+				 * code will be returned to user. User needs to call
>+				 * 'madvise()/mmap()' to clear this vma. Anyway,
>+				 * references to all pages will to be dropped below.
>+				 */
>+				if (!err) {
>+					err = -EFAULT;
>+					break;
>+				}
>+			}
>+		}
>+
>+		address += PAGE_SIZE;
>+	}
>+
>+	i = 0;
>+
>+	while (i < vma_pages) {
>+		/* Drop ref count for all pages, returned by transport.
>+		 * We call 'put_page()' only once, as transport needed
>+		 * to 'get_page()' at least only once also, to prevent
>+		 * pages being freed. If transport calls 'get_page()'
>+		 * more twice or more for every page - we don't care,
>+		 * if transport calls 'get_page()' only one time, this
>+		 * meanse that every page had ref count equal to 1,then
>+		 * 'vm_insert_pages()' increments it to 2. After this
>+		 * loop, ref count will be 1 again, and page will be
>+		 * returned to allocator by user.
>+		 */
>+		if (pages[i])
>+			put_page(pages[i]);
>+		i++;
>+	}
>+
>+	kfree(pages);
>+
>+out_unlock_vma:
>+	mmap_write_unlock(current->mm);
>+out_unlock_sock:
>+	release_sock(sk);
>+
>+	return err;
>+}
>+
> static int vsock_connectible_getsockopt(struct socket *sock,
> 					int level, int optname,
> 					char __user *optval,
>@@ -1720,6 +1848,26 @@ static int vsock_connectible_getsockopt(struct socket *sock,
> 		lv = sock_get_timeout(vsk->connect_timeout, &v,
> 				      optname == SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD);
> 		break;
>+	case SO_VM_SOCKETS_ZEROCOPY: {
>+		lock_sock(sk);
>+
>+		v.val64 = vsk->rx_zerocopy_on;
>+
>+		release_sock(sk);
>+
>+		break;
>+	}
>+	case SO_VM_SOCKETS_MAP_RX: {
>+		unsigned long vma_addr;
>+
>+		if (len < sizeof(vma_addr))
>+			return -EINVAL;
>+
>+		if (copy_from_user(&vma_addr, optval, sizeof(vma_addr)))
>+			return -EFAULT;
>+
>+		return vsock_recv_zerocopy(sock, vma_addr);
>+	}
>
> 	default:
> 		return -ENOPROTOOPT;
>@@ -2167,6 +2315,41 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
> 	return 0;
> }
>
>+static int afvsock_mmap(struct file *file, struct socket *sock,
>+			struct vm_area_struct *vma)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	struct sock *sk;
>+	int err;
>+
>+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
>+		return -EPERM;
>+
>+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
>+	vma->vm_flags |= (VM_MIXEDMAP);
>+	vma->vm_ops = &afvsock_vm_ops;
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+
>+	lock_sock(sk);
>+
>+	transport = vsk->transport;
>+
>+	if (!transport || !transport->zerocopy_rx_mmap) {
>+		err = -EOPNOTSUPP;
>+		goto out_unlock;
>+	}
>+
>+	err = transport->zerocopy_rx_mmap(vsk, vma);
>+
>+out_unlock:
>+	release_sock(sk);
>+
>+	return err;
>+}
>+
> static const struct proto_ops vsock_stream_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>@@ -2184,7 +2367,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.getsockopt = vsock_connectible_getsockopt,
> 	.sendmsg = vsock_connectible_sendmsg,
> 	.recvmsg = vsock_connectible_recvmsg,
>-	.mmap = sock_no_mmap,
>+	.mmap = afvsock_mmap,
> 	.sendpage = sock_no_sendpage,
> 	.set_rcvlowat = vsock_set_rcvlowat,
> };
>@@ -2206,7 +2389,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
> 	.getsockopt = vsock_connectible_getsockopt,
> 	.sendmsg = vsock_connectible_sendmsg,
> 	.recvmsg = vsock_connectible_recvmsg,
>-	.mmap = sock_no_mmap,
>+	.mmap = afvsock_mmap,
> 	.sendpage = sock_no_sendpage,
> };
>
>-- 
>2.35.0

