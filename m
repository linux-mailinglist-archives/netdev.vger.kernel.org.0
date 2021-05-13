Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B3E37F4F4
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 11:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhEMJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 05:43:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231523AbhEMJm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 05:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620898908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tEXPPpt56VkLlB1sxfQc5mmkjZ2bJkUMWLVzzmgeQlI=;
        b=OO1+bCPOFeaSP47DrmnROwELIuLd+5KTN5dj4Vm+g9wib1WYFlrjxCCmoyfiWYpWZdbwPE
        hv6B9SKr582namreght0In/k2OAIdO1BEHPebMhF9O/Qanf1cvu67r7deOaeY1UbCkTRKo
        4q8wtEJB6CUSn7QqtpyKz/l7RAfZ82Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-NTHvBz_SN_WNqgfdvz9vYA-1; Thu, 13 May 2021 05:41:47 -0400
X-MC-Unique: NTHvBz_SN_WNqgfdvz9vYA-1
Received: by mail-ed1-f72.google.com with SMTP id z12-20020aa7d40c0000b0290388179cc8bfso14269150edq.21
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 02:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tEXPPpt56VkLlB1sxfQc5mmkjZ2bJkUMWLVzzmgeQlI=;
        b=Qnb/9dnQaVMc3mvajHjNPEyaa+pabyKqRYPlPpTZ9OCj4pS1TcNJjZbpzuNW3laxwg
         Zqvmn/1+OspLoWXwrRtBjiL3PvhMqWP23Fzpkbvhs+Hyj6XRdFYcBBtLk+qrHMtLepQp
         6Gk9UZ55bF9Fy+dW3uajG4jVO9NQ5uafR2O5jBShWXB9QtumGvuS4xCFS8tq183ap2Yn
         nHczRMovygu0HBWhNEx6nm4K+XRZVrcd5Awk5ELZSBBLzcAW8p7HlcTA5SUGhy2MPYhl
         FlW9fut4Mej7ujxeOGjREgCJG3Q1LQm2ckK3UQCiuvf4CpA+DKCQ3xVXwbRayALKL/WG
         K+HQ==
X-Gm-Message-State: AOAM532CzT4AprqagJBHz2pbr4QZWoTPwtNLjF6LpQLqnqkES1WWJIo+
        sPjVDpbK9PRS8NhFbpRyemygpyQiwMWiDVOcsM2jtNOLb8l3Bo9zu/vPwxLeGH22wi+gx0JNw5Q
        Gq9HY2MhTDb+ISTms
X-Received: by 2002:a05:6402:2218:: with SMTP id cq24mr32137403edb.213.1620898905994;
        Thu, 13 May 2021 02:41:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJVi1oEMy1G+Ywub1hPnPWN5TD5l/FhJybfYGA5Yj2BjUVuK2h8oCU1i60XTsPyqrKWp64mg==
X-Received: by 2002:a05:6402:2218:: with SMTP id cq24mr32137390edb.213.1620898905840;
        Thu, 13 May 2021 02:41:45 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id by20sm1493666ejc.74.2021.05.13.02.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 02:41:45 -0700 (PDT)
Date:   Thu, 13 May 2021 11:41:43 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, subo7@huawei.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        lixianming <lixianming5@huawei.com>
Subject: Re: [RFC] vsock: notify server to shutdown when client has pending
 signal
Message-ID: <20210513094143.pir5vzsludut3xdc@steredhat>
References: <20210511094127.724-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210511094127.724-1-longpeng2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
thanks for this patch, comments below...

On Tue, May 11, 2021 at 05:41:27PM +0800, Longpeng(Mike) wrote:
>The client's sk_state will be set to TCP_ESTABLISHED if the
>server replay the client's connect request.
>However, if the client has pending signal, its sk_state will
>be set to TCP_CLOSE without notify the server, so the server
>will hold the corrupt connection.
>
>            client                        server
>
>1. sk_state=TCP_SYN_SENT         |
>2. call ->connect()              |
>3. wait reply                    |
>                                 | 4. sk_state=TCP_ESTABLISHED
>                                 | 5. insert to connected list
>                                 | 6. reply to the client
>7. sk_state=TCP_ESTABLISHED      |
>8. insert to connected list      |
>9. *signal pending* <--------------------- the user kill client
>10. sk_state=TCP_CLOSE           |
>client is exiting...             |
>11. call ->release()             |
>     virtio_transport_close
>      if (!(sk->sk_state == TCP_ESTABLISHED ||
>	      sk->sk_state == TCP_CLOSING))
>		return true; <------------- return at here
>As a result, the server cannot notice the connection is corrupt.
>So the client should notify the peer in this case.
>
>Cc: David S. Miller <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: Jorgen Hansen <jhansen@vmware.com>
>Cc: Norbert Slusarek <nslusarek@gmx.net>
>Cc: Andra Paraschiv <andraprs@amazon.com>
>Cc: Colin Ian King <colin.king@canonical.com>
>Cc: David Brazdil <dbrazdil@google.com>
>Cc: Alexander Popov <alex.popov@linux.com>
>Signed-off-by: lixianming <lixianming5@huawei.com>
>Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>---
> net/vmw_vsock/af_vsock.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 92a72f0..d5df908 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1368,6 +1368,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
> 		lock_sock(sk);
>
> 		if (signal_pending(current)) {
>+			vsock_send_shutdown(sk, SHUTDOWN_MASK);

I see the issue, but I'm not sure is okay to send the shutdown in any 
case, think about the server didn't setup the connection.

Maybe is better to set TCP_CLOSING if the socket state was 
TCP_ESTABLISHED, so the shutdown will be handled by the 
transport->release() as usual.

What do you think?

Anyway, also without the patch, the server should receive a RST if it 
sends any data to the client, but of course, is better to let it know 
the socket is closed in advance.

Thanks,
Stefano

