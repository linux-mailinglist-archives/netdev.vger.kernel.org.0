Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236CA3822AA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhEQCUM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 May 2021 22:20:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2935 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhEQCUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 22:20:10 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fk2ml6XWyzCtLp;
        Mon, 17 May 2021 10:16:07 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 10:18:52 +0800
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 10:18:52 +0800
Received: from dggpeml500016.china.huawei.com ([7.185.36.70]) by
 dggpeml500016.china.huawei.com ([7.185.36.70]) with mapi id 15.01.2176.012;
 Mon, 17 May 2021 10:18:52 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Subo (Subo, Cloud Infrastructure Service Product Dept.)" 
        <subo7@huawei.com>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "David Brazdil" <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "lixianming (E)" <lixianming5@huawei.com>,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Subject: RE: [RFC] vsock: notify server to shutdown when client has pending
 signal
Thread-Topic: [RFC] vsock: notify server to shutdown when client has pending
 signal
Thread-Index: AQHXRkna70IyCpulcUmMFYMN4BnQYKrgpa2AgACTRtCABasjMA==
Date:   Mon, 17 May 2021 02:18:51 +0000
Message-ID: <09562f9b35c3419f9b5844b35b4276ae@huawei.com>
References: <20210511094127.724-1-longpeng2@huawei.com>
 <20210513094143.pir5vzsludut3xdc@steredhat>
 <558d53dd31dc4841b94c4ec35249ac80@huawei.com>
In-Reply-To: <558d53dd31dc4841b94c4ec35249ac80@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

> -----Original Message-----
> From: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> [mailto:longpeng2@huawei.com]
> Sent: Thursday, May 13, 2021 6:36 PM
> To: Stefano Garzarella <sgarzare@redhat.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Subo (Subo, Cloud Infrastructure Service Product
> Dept.) <subo7@huawei.com>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Jorgen Hansen <jhansen@vmware.com>; Norbert
> Slusarek <nslusarek@gmx.net>; Andra Paraschiv <andraprs@amazon.com>;
> Colin Ian King <colin.king@canonical.com>; David Brazdil
> <dbrazdil@google.com>; Alexander Popov <alex.popov@linux.com>;
> lixianming (E) <lixianming5@huawei.com>
> Subject: RE: [RFC] vsock: notify server to shutdown when client has pending
> signal
> 
> Hi Stefano,
> 
> > -----Original Message-----
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Thursday, May 13, 2021 5:42 PM
> > To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> > <longpeng2@huawei.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Gonglei
> > (Arei) <arei.gonglei@huawei.com>; Subo (Subo, Cloud Infrastructure
> > Service Product
> > Dept.) <subo7@huawei.com>; David S . Miller <davem@davemloft.net>;
> > Jakub Kicinski <kuba@kernel.org>; Jorgen Hansen <jhansen@vmware.com>;
> > Norbert Slusarek <nslusarek@gmx.net>; Andra Paraschiv
> > <andraprs@amazon.com>; Colin Ian King <colin.king@canonical.com>;
> > David Brazdil <dbrazdil@google.com>; Alexander Popov
> > <alex.popov@linux.com>; lixianming (E) <lixianming5@huawei.com>
> > Subject: Re: [RFC] vsock: notify server to shutdown when client has
> > pending signal
> >
> > Hi,
> > thanks for this patch, comments below...
> >
> > On Tue, May 11, 2021 at 05:41:27PM +0800, Longpeng(Mike) wrote:
> > >The client's sk_state will be set to TCP_ESTABLISHED if the server
> > >replay the client's connect request.
> > >However, if the client has pending signal, its sk_state will be set
> > >to TCP_CLOSE without notify the server, so the server will hold the
> > >corrupt connection.
> > >
> > >            client                        server
> > >
> > >1. sk_state=TCP_SYN_SENT         |
> > >2. call ->connect()              |
> > >3. wait reply                    |
> > >                                 | 4. sk_state=TCP_ESTABLISHED
> > >                                 | 5. insert to connected list
> > >                                 | 6. reply to the client
> > >7. sk_state=TCP_ESTABLISHED      |
> > >8. insert to connected list      |
> > >9. *signal pending* <--------------------- the user kill client
> > >10. sk_state=TCP_CLOSE           |
> > >client is exiting...             |
> > >11. call ->release()             |
> > >     virtio_transport_close
> > >      if (!(sk->sk_state == TCP_ESTABLISHED ||
> > >	      sk->sk_state == TCP_CLOSING))
> > >		return true; <------------- return at here As a result, the server
> > >cannot notice the connection is corrupt.
> > >So the client should notify the peer in this case.
> > >
> > >Cc: David S. Miller <davem@davemloft.net>
> > >Cc: Jakub Kicinski <kuba@kernel.org>
> > >Cc: Stefano Garzarella <sgarzare@redhat.com>
> > >Cc: Jorgen Hansen <jhansen@vmware.com>
> > >Cc: Norbert Slusarek <nslusarek@gmx.net>
> > >Cc: Andra Paraschiv <andraprs@amazon.com>
> > >Cc: Colin Ian King <colin.king@canonical.com>
> > >Cc: David Brazdil <dbrazdil@google.com>
> > >Cc: Alexander Popov <alex.popov@linux.com>
> > >Signed-off-by: lixianming <lixianming5@huawei.com>
> > >Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> > >---
> > > net/vmw_vsock/af_vsock.c | 1 +
> > > 1 file changed, 1 insertion(+)
> > >
> > >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > >index
> > >92a72f0..d5df908 100644
> > >--- a/net/vmw_vsock/af_vsock.c
> > >+++ b/net/vmw_vsock/af_vsock.c
> > >@@ -1368,6 +1368,7 @@ static int vsock_stream_connect(struct socket
> > >*sock,
> > struct sockaddr *addr,
> > > 		lock_sock(sk);
> > >
> > > 		if (signal_pending(current)) {
> > >+			vsock_send_shutdown(sk, SHUTDOWN_MASK);
> >
> > I see the issue, but I'm not sure is okay to send the shutdown in any
> > case, think about the server didn't setup the connection.
> >
> > Maybe is better to set TCP_CLOSING if the socket state was
> > TCP_ESTABLISHED, so the shutdown will be handled by the
> > transport->release() as usual.
> >
> > What do you think?
> >
> 
> Your method looks more gracefully, we'll try it and get back to you, thanks.
> 

As your suggestion, the following code can solve the problem:

                if (signal_pending(current)) {
                        err = sock_intr_errno(timeout);
-                       sk->sk_state = TCP_CLOSE;
+                       sk->sk_state = TCP_CLOSING;
                        sock->state = SS_UNCONNECTED;
                        vsock_transport_cancel_pkt(vsk);
                        goto out_wait;

This will send shutdown to the server even if the connection is not established, but
I don't see any side effects yet, right ?

The problem is also in the timeout case, we should fix it together ?


> > Anyway, also without the patch, the server should receive a RST if it
> > sends any data to the client, but of course, is better to let it know
> > the socket is closed in advance.
> >
> 
> Yes, agree.
> 
> > Thanks,
> > Stefano

