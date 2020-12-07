Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2B2D0DB2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgLGKBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:01:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgLGKBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1LyTFerekovKrRoriYwNaLHxIW4TPTpyekpuOlkC8W4=;
        b=HfhZ2QId0Ax+AhtrUKUTVus2FhfUFk3Jdc9uWu7CPiG/Tlf59pKvglVqXhfcxOYvikoakJ
        2DOx3AFCJhx8phDpamcvbYzo4FMYhmrJNcEdE1+mDCwHyeHuD3VQJECBROfAacrpjwfUQ+
        Mx4b9ePiQuD2p2oARjV7ZXo3LHnpphI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-kSAJ12poO3KospQ2EqBvXg-1; Mon, 07 Dec 2020 05:00:20 -0500
X-MC-Unique: kSAJ12poO3KospQ2EqBvXg-1
Received: by mail-wm1-f71.google.com with SMTP id o203so3952173wmo.3
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 02:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LyTFerekovKrRoriYwNaLHxIW4TPTpyekpuOlkC8W4=;
        b=K98EtrXtL/qGjnWYWfgnxdK5HlctqULTT+97mCa3h32NZKHXA36yBnVehCy1+wATNB
         ntmgIoB+WjG07GK/gXpUgIFrvHhXejT/CcLCW4yVp5UV2IIRl6+CrEcpaPgKAiUEvinT
         PqblYviC2VsWdOGkV+5H3LILQfofe6sHE6R69bNmHNVfW8KYJREGoK5GLrPqUZsXJCUH
         JwolS39CoSW+eKsHvS79oQif5kXWPaBxWoQJonvmmKGHeO57MbxVOzT/sleeyGXUKDJ6
         nLDTJ+29KR3FHkUcFOsXRadBCV05Mkp+5R/p+xXaAr9mdC5IVsXCsUxr63n1qf7OiKdr
         ZT9w==
X-Gm-Message-State: AOAM530H80ZaBwu0VrzAtckpLvImMSPEx8FYzgH6dhBrWv/+VxME81BK
        l9gEdpXBoE3DXVsJIWTPXg6EJghLRVYmsbahzmueosoxmmSmAQ29ezm1naAtzDNPUsUoN03dAZu
        kNV/lBJrYaQloQ4a3
X-Received: by 2002:a1c:2bc2:: with SMTP id r185mr1574988wmr.13.1607335219385;
        Mon, 07 Dec 2020 02:00:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDwRGlbEJvgsJXcfvdacxQuheeOSq8WvkrHNzRgR2aybbArIELoXECM77omMRty92P5EwysA==
X-Received: by 2002:a1c:2bc2:: with SMTP id r185mr1574968wmr.13.1607335219201;
        Mon, 07 Dec 2020 02:00:19 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id e17sm4387653wrw.84.2020.12.07.02.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 02:00:18 -0800 (PST)
Date:   Mon, 7 Dec 2020 11:00:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
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
Subject: Re: [PATCH net-next v2 4/4] af_vsock: Assign the vsock transport
 considering the vsock address flags
Message-ID: <20201207100016.6n5x7bd2fqvf2mmi@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-5-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204170235.84387-5-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:02:35PM +0200, Andra Paraschiv wrote:
>The vsock flags field can be set in the connect and (listen) receive
>paths.
>
>When the vsock transport is assigned, the remote CID is used to
>distinguish between types of connection.
>
>Use the vsock flags value (in addition to the CID) from the remote
>address to decide which vsock transport to assign. For the sibling VMs
>use case, all the vsock packets need to be forwarded to the host, so
>always assign the guest->host transport if the VMADDR_FLAG_TO_HOST flag
>is set. For the other use cases, the vsock transport assignment logic is
>not changed.
>
>Changelog
>
>v1 -> v2
>
>* Use bitwise operator to check the vsock flag.
>* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.
>* Merge the checks for the g2h transport assignment in one "if" block.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> net/vmw_vsock/af_vsock.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 83d035eab0b05..66e643c3b5f85 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -421,7 +421,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
>  * The vsk->remote_addr is used to decide which transport to use:
>  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
>  *    g2h is not loaded, will use local transport;
>- *  - remote CID <= VMADDR_CID_HOST will use guest->host transport;
>+ *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
>+ *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
>  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
>  */
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>@@ -429,6 +430,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	const struct vsock_transport *new_transport;
> 	struct sock *sk = sk_vsock(vsk);
> 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
>+	unsigned short remote_flags;
> 	int ret;
>
> 	/* If the packet is coming with the source and destination CIDs higher
>@@ -443,6 +445,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> 		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
>
>+	remote_flags = vsk->remote_addr.svm_flags;
>+
> 	switch (sk->sk_type) {
> 	case SOCK_DGRAM:
> 		new_transport = transport_dgram;
>@@ -450,7 +454,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	case SOCK_STREAM:
> 		if (vsock_use_local_transport(remote_cid))
> 			new_transport = transport_local;
>-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
>+		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>+			 (remote_flags & VMADDR_FLAG_TO_HOST) == VMADDR_FLAG_TO_HOST)

Maybe "remote_flags & VMADDR_FLAG_TO_HOST" should be enough, but the 
patch is okay:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 			new_transport = transport_g2h;
> 		else
> 			new_transport = transport_h2g;
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

