Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3323E2D0DAD
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgLGKB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:01:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbgLGKB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:01:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MeeG0OxJl0Wqa0+h/cgdVYDpvRXoWkEFJelsPnzYQ2A=;
        b=J8X5Lr3KnO2mnv1Y6letElFpyanUN4f0/7ghWox7+iO6ucHNdHHCDPYnCIFzgZMu5ClTpS
        tVXhqaLr06TBTfzSvLOYZZk10PA+ag4RDiia4vTmQn8fGtRc2AqOxitkZ/sRQfefoQ98GR
        OWsUjC4427GbZqNKogWEe1oqOojheeQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-orOsCCmNMJKOUxF5SisHyQ-1; Mon, 07 Dec 2020 04:59:59 -0500
X-MC-Unique: orOsCCmNMJKOUxF5SisHyQ-1
Received: by mail-wm1-f70.google.com with SMTP id u123so3939989wmu.5
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 01:59:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MeeG0OxJl0Wqa0+h/cgdVYDpvRXoWkEFJelsPnzYQ2A=;
        b=J9c8lcDu6Yxto6cgaAIPoHgcX5hvl1bTN1V2WZwaTCyW1Q1sQeGiM4wjgnmsH4enoz
         g4mFuidez/oIjhB0Zs+amgVkRGg6e2eUKkr7lfSXbtzZm4MMwn81Oazs8h7ERmuEa12O
         sd5DydW3NsBppfZW1BNnuzZUgbJblLAJYsr521Xz9ngWO1OfF7OmRmm5AnMRldxFnFYl
         Zp6iWlT3uFtfOWb9v1iI7XDr62bF4dfAJR6K9E0c7HC7ScSF0v3E6Wl5pyIExOKK/ws0
         IexqZs8m1odz5cAiL7i69pz0kl+euJfP5rR5Q4tmh3KxjdtzJmONrVOgEhhUK0VOLc5i
         xslQ==
X-Gm-Message-State: AOAM532uDz5mal3g1Pu0z2son2rLdMvqaQVXOBz34pIqzjMkOsTMbhrw
        FW/ZB7txVi4vN9xupWgwvuZ16BC+esQDnB/A07Ir6v3HZjuBW7uF0Yk9smQIXk5motJd/MxSADk
        6zD1qxHFQDUhPGoZL
X-Received: by 2002:adf:c648:: with SMTP id u8mr18783893wrg.215.1607335197818;
        Mon, 07 Dec 2020 01:59:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDi2lyVb4GCNib4TwGV0pQfYMjbA1IKPguqVDqsqxyLFn/MepU5WZs0cTe5uAf0UGWQriXsA==
X-Received: by 2002:adf:c648:: with SMTP id u8mr18783877wrg.215.1607335197622;
        Mon, 07 Dec 2020 01:59:57 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id m4sm13401938wmi.41.2020.12.07.01.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:59:57 -0800 (PST)
Date:   Mon, 7 Dec 2020 10:59:54 +0100
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
Subject: Re: [PATCH net-next v2 3/4] af_vsock: Set VMADDR_FLAG_TO_HOST flag
 on the receive path
Message-ID: <20201207095954.5gvp557xnulvledx@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204170235.84387-4-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:02:34PM +0200, Andra Paraschiv wrote:
>The vsock flags can be set during the connect() setup logic, when
>initializing the vsock address data structure variable. Then the vsock
>transport is assigned, also considering this flags field.
>
>The vsock transport is also assigned on the (listen) receive path. The
>flags field needs to be set considering the use case.
>
>Set the value of the vsock flags of the remote address to the one
>targeted for packets forwarding to the host, if the following conditions
>are met:
>
>* The source CID of the packet is higher than VMADDR_CID_HOST.
>* The destination CID of the packet is higher than VMADDR_CID_HOST.
>
>Changelog
>
>v1 -> v2
>
>* Set the vsock flag on the receive path in the vsock transport
>  assignment logic.
>* Use bitwise operator for the vsock flag setup.
>* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> net/vmw_vsock/af_vsock.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d10916ab45267..83d035eab0b05 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -431,6 +431,18 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
> 	int ret;
>
>+	/* If the packet is coming with the source and destination CIDs higher
>+	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
>+	 * forwarded to the host should be established. Then the host will
>+	 * need to forward the packets to the guest.
>+	 *
>+	 * The flag is set on the (listen) receive path (psk is not NULL). On
>+	 * the connect path the flag can be set by the user space application.
>+	 */
>+	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
>+	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
>+		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
>+
> 	switch (sk->sk_type) {
> 	case SOCK_DGRAM:
> 		new_transport = transport_dgram;
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

