Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203242CA82D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgLAQY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726670AbgLAQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606839809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHS3kkYggRLy+5fMrWoIB0GgrNcrW36mXXiiHAGr4Pk=;
        b=TTVoc2njvTAZFr/5A2BSpZG+k9HTyc5cLdFT2gFk0/NyOzSQjM7IBVwj05WwlTXeYnzg3x
        1X4pGzqKl/A8igh5N+Q5bWmcUTOtHTHzLpUYOd/DI3tr7Qezz47xbiod5yf9Z51/odjbTQ
        biv1HxMxZMruc8h/E7zdVPb8WTdj5yo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-wvgMZfpVMYKEExqyzuDyEA-1; Tue, 01 Dec 2020 11:23:27 -0500
X-MC-Unique: wvgMZfpVMYKEExqyzuDyEA-1
Received: by mail-wr1-f69.google.com with SMTP id z6so1230402wrl.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gHS3kkYggRLy+5fMrWoIB0GgrNcrW36mXXiiHAGr4Pk=;
        b=jQXKWYy+USb4UeIai2acjohKWREET3d1j99wp7pBHR6fwe++JV1cCFv4N7/vE971gZ
         R0315OUEzqQC6qB8QjxLHAg+/1KVUdHBsb+GL2BJ7DMi3OC29uy6ixuCSBKMCi4ceDXk
         tbj6vvSYSvMFW28kOBcA54bkfHPt6aKt6LBPfJyETkRcS4e0EISuSTtFZCyutJyvt3EE
         MFErUIE7mH9q3+IJRqs/U1CIqKUZRNjZIGkVn33BgaRtAFPmmchPGHIImbFidbuUC8wD
         MjhBTu4Inn50cfOPiOx3Z34uibqq1WT8Mcl84nueZEagCaOdKyNs8OYTIo//TrCeS6fy
         aSFg==
X-Gm-Message-State: AOAM532qdf2UG4ZRh+Ze8aYlQIm/wp8XUlUoed4lPfM64yoQ9KWf+hEk
        /b1MDe4D4KMaOQz638VwqKiSe7OEZwh9j0GJuo037atVddVbL/Sc6PITrprF0yvf2d1AaIPHyff
        dWGLf/wcgTT79I2Mm
X-Received: by 2002:adf:f88c:: with SMTP id u12mr4978113wrp.209.1606839806267;
        Tue, 01 Dec 2020 08:23:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMzlkHaVe3TzHploDAHelHS+jFVLyPnEfjgtjahqXyoGh2s8BCarcKwuVJSImK4JNC0Xdt7Q==
X-Received: by 2002:adf:f88c:: with SMTP id u12mr4978086wrp.209.1606839806086;
        Tue, 01 Dec 2020 08:23:26 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id a1sm41293wrv.61.2020.12.01.08.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:23:25 -0800 (PST)
Date:   Tue, 1 Dec 2020 17:23:23 +0100
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
Subject: Re: [PATCH net-next v1 3/3] af_vsock: Assign the vsock transport
 considering the vsock address flag
Message-ID: <20201201162323.gwfzktkwtu6x4eef@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201201152505.19445-4-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 05:25:05PM +0200, Andra Paraschiv wrote:
>The vsock flag has been set in the connect and (listen) receive paths.
>
>When the vsock transport is assigned, the remote CID is used to
>distinguish between types of connection.
>
>Use the vsock flag (in addition to the CID) from the remote address to
>decide which vsock transport to assign. For the sibling VMs use case,
>all the vsock packets need to be forwarded to the host, so always assign
>the guest->host transport if the vsock flag is set. For the other use
>cases, the vsock transport assignment logic is not changed.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> net/vmw_vsock/af_vsock.c | 15 +++++++++++----
> 1 file changed, 11 insertions(+), 4 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d10916ab45267..bafc1cb20abd4 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -419,16 +419,21 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
>  * (e.g. during the connect() or when a connection request on a listener
>  * socket is received).
>  * The vsk->remote_addr is used to decide which transport to use:
>- *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
>- *    g2h is not loaded, will use local transport;
>- *  - remote CID <= VMADDR_CID_HOST will use guest->host transport;
>- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
>+ *  - remote flag == VMADDR_FLAG_SIBLING_VMS_COMMUNICATION, will always
>+ *    forward the vsock packets to the host and use guest->host transport;
>+ *  - otherwise, going forward with the remote flag default value:
>+ *    - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST
>+ *      if g2h is not loaded, will use local transport;
>+ *    - remote CID <= VMADDR_CID_HOST or h2g is not loaded, will use
>+ *      guest->host transport;
>+ *    - remote CID > VMADDR_CID_HOST will use host->guest transport;
>  */
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> {
> 	const struct vsock_transport *new_transport;
> 	struct sock *sk = sk_vsock(vsk);
> 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
>+	unsigned short remote_flag = vsk->remote_addr.svm_flag;
> 	int ret;
>
> 	switch (sk->sk_type) {
>@@ -438,6 +443,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	case SOCK_STREAM:
> 		if (vsock_use_local_transport(remote_cid))
> 			new_transport = transport_local;
>+		else if (remote_flag == VMADDR_FLAG_SIBLING_VMS_COMMUNICATION)

Others flags can be added, so here we should use the bitwise AND 
operator to check if this flag is set.

And what about merging with the next if clause?


Thanks,
Stefano

>+			new_transport = transport_g2h;
> 		else if (remote_cid <= VMADDR_CID_HOST || 
> 		!transport_h2g)
> 			new_transport = transport_g2h;
> 		else
>-- 
>2.20.1 (Apple Git-117)
>

