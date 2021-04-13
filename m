Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2735E923
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348605AbhDMWmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347533AbhDMWl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:41:59 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCF4C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:41:37 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id t17-20020a9d77510000b0290287a5143b41so6396682otl.11
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wQW7Ir0V37N8aEpZSFC+UlR8nY6Um1rb/71MJ1Oce0=;
        b=iKmssD/eJapSXNm5fS65nXtlBLsOifF4OlJoxfLEiErVAggwzz2Vrp/gvsrjxN4SQK
         9sh6OX162tZpNKgD2IWjm+Xw1AiOero39JiIa2jn3FZvMOmPAOpqGjNHN2JaCt5C37DS
         gIkgs+jDdsAf4QdP0lIHa3dImlE51iU88JjGYovO8dGWCct6l7jBtGxsDIHV1Jx+mjHa
         hXW7UgYdbz7i8hXwbozo+5gDd/4X2NGMVFU1Iyzsx1Sb1LAM430xW53V1c87myUFV9ob
         VY3CY0Oi42cSJmQGZE77zrneNTdPxcf2D0iu98yc8vknMUlszDoyPQoqkDzz/PHvO2HT
         qwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wQW7Ir0V37N8aEpZSFC+UlR8nY6Um1rb/71MJ1Oce0=;
        b=CXzTBEJh6P/jrICNp/KG5+vKYxz0Lz9Ko7KFTH2KAW8AWdCCFLbvOJM48Y+Xyw6hOp
         HkAVhmIC69ZPhaRtjvwVvAqWAx8jtsFiB6sSmrgulv7YkZ7YNvQ75yJNH9xb+NW0JaLE
         +90Tvo8/yiTIyh36Dsu8jE6Q+PZJwdcUY69pCMpZmqmDo1YFgwARAehOs0r/Dn4SWZjN
         pttPMDwfZH731jXy3rgWz384BMvsS3OMwbycAOHbDEQy4te7k3qg8EAzk9XUcEelIO7z
         IfckGYwDnl5C4M4HezIn9sFND0/5QKMO/g6LkQwP1CsneJasVZ977iy0nsKYoaiEQiYq
         Zxjw==
X-Gm-Message-State: AOAM533uIi3DJ1RNOtxh9LYS5o6vahsgp2QB1Eh8rgQMVPeeKc3yYukQ
        37wKUOYS++7I6ZsBcvEPZmOqDDFtyXlOH1rwTCuxAQ==
X-Google-Smtp-Source: ABdhPJx3grn25dA54vJd+We6mIK3WpGQiGK+itq3HIOrbObCPrGTxQfsIUv52S6uyRphIk4dusA6WeyiikzI/ct6+38=
X-Received: by 2002:a9d:5c0f:: with SMTP id o15mr29423176otk.279.1618353696942;
 Tue, 13 Apr 2021 15:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210406183112.1150657-1-jiang.wang@bytedance.com>
 <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com> <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
 <20210412140437.6k3zxw2cv4p54lvm@steredhat> <CAP_N_Z9yi96YDW3gJdCFrPJpNhwpJnaT8gruk7JJSsBne8J-8Q@mail.gmail.com>
 <2EE65DBC-30AC-4E11-BFD5-73586B94C985@vmware.com> <20210413125231.k4qtyayp5eoiyxln@steredhat>
In-Reply-To: <20210413125231.k4qtyayp5eoiyxln@steredhat>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Tue, 13 Apr 2021 15:41:26 -0700
Message-ID: <CAP_N_Z9uOeEjw1ZCkqrpKRhiMC1KXdooG0X-oQ_wpcJiiX3_mg@mail.gmail.com>
Subject: Re: Re: [RFC] vsock: add multiple transports support for dgram
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jorgen Hansen <jhansen@vmware.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jorgen,

Thanks for the detailed explanation and I agree with you. For the bind list=
,
my  prototype is doing
something similar to that. I will double check it.

Hi Stefano,

I don't have other questions for now. Thanks.

Regards,

Jiang

On Tue, Apr 13, 2021 at 5:52 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Tue, Apr 13, 2021 at 12:12:50PM +0000, Jorgen Hansen wrote:
> >
> >
> >On 12 Apr 2021, at 20:53, Jiang Wang . <jiang.wang@bytedance.com<mailto:=
jiang.wang@bytedance.com>> wrote:
> >
> >On Mon, Apr 12, 2021 at 7:04 AM Stefano Garzarella <sgarzare@redhat.com<=
mailto:sgarzare@redhat.com>> wrote:
> >
> >Hi Jiang,
> >thanks for re-starting the multi-transport support for dgram!
> >
> >No problem.
> >
> >On Wed, Apr 07, 2021 at 11:25:36AM -0700, Jiang Wang . wrote:
> >On Wed, Apr 7, 2021 at 2:51 AM Jorgen Hansen <jhansen@vmware.com<mailto:=
jhansen@vmware.com>> wrote:
> >
> >
> >On 6 Apr 2021, at 20:31, Jiang Wang <jiang.wang@bytedance.com<mailto:jia=
ng.wang@bytedance.com>> wrote:
> >
> >From: "jiang.wang<http://jiang.wang>" <jiang.wang@bytedance.com<mailto:j=
iang.wang@bytedance.com>>
> >
> >Currently, only VMCI supports dgram sockets. To supported
> >nested VM use case, this patch removes transport_dgram and
> >uses transport_g2h and transport_h2g for dgram too.
> >
> >I agree on this part, I think that's the direction to go.
> >transport_dgram was added as a shortcut.
> >
> >Got it.
> >
> >
> >Could you provide some background for introducing this change - are you
> >looking at introducing datagrams for a different transport? VMCI datagra=
ms
> >already support the nested use case,
> >
> >Yes, I am trying to introduce datagram for virtio transport. I wrote a
> >spec patch for
> >virtio dgram support and also a code patch, but the code patch is still =
WIP.
> >When I wrote this commit message, I was thinking nested VM is the same a=
s
> >multiple transport support. But now, I realize they are different.
> >Nested VMs may use
> >the same virtualization layer(KVM on KVM), or different virtualization l=
ayers
> >(KVM on ESXi). Thanks for letting me know that VMCI already supported ne=
sted
> >use cases. I think you mean VMCI on VMCI, right?
> >
> >but if we need to support multiple datagram
> >transports we need to rework how we administer port assignment for datag=
rams.
> >One specific issue is that the vmci transport won=E2=80=99t receive any =
datagrams for a
> >port unless the datagram socket has already been assigned the vmci trans=
port
> >and the port bound to the underlying VMCI device (see below for more det=
ails).
> >
> >I see.
> >
> >The transport is assgined when sending every packet and
> >receiving every packet on dgram sockets.
> >
> >Is the intent that the same datagram socket can be used for sending pack=
ets both
> >In the host to guest, and the guest to directions?
> >
> >Nope. One datagram socket will only send packets to one direction, eithe=
r to the
> >host or to the guest. My above description is wrong. When sending packet=
s, the
> >transport is assigned with the first packet (with auto_bind).
> >
> >I'm not sure this is right.
> >The auto_bind on the first packet should only assign a local port to the
> >socket, but does not affect the transport to be used.
> >
> >A user could send one packet to the nested guest and another to the host
> >using the same socket, or am I wrong?
> >
> >OK. I think you are right.
> >
> >
> >The problem is when receiving packets. The listener can bind to the
> >VMADDR_CID_ANY
> >address. Then it is unclear which transport we should use. For stream
> >sockets, there will be a new socket for each connection, and transport
> >can be decided
> >at that time. For datagram sockets, I am not sure how to handle that.
> >
> >yes, this I think is the main problem, but maybe the sender one is even
> >more complicated.
> >
> >Maybe we should remove the 1:1 association we have now between vsk and
> >transport.
> >
> >Yes, I thought about that too. One idea is to define two transports in v=
sk.
> >For sending pkt, we can pick the right transport when we get the packet,=
 like
> >in virtio_transport_send_pkt_info(). For receiving pkts, we have to chec=
k
> >and call both
> >transports dequeue callbacks if the local cid is CID_ANY.
> >
> >At least for DGRAM, for connected sockets I think the association makes
> >sense.
> >
> >Yeah. For a connected socket, we will only use one transport.
> >
> >For VMCI, does the same transport can be used for both receiving from
> >host and from
> >the guest?
> >
> >Yes, they're registered at different times, but it's the same transport.
> >
> >
> >For virtio, the h2g and g2h transports are different,, so we have to
> >choose
> >one of them. My original thought is to wait until the first packet
> >arrives.
> >
> >Another idea is that we always bind to host addr and use h2g
> >transport because I think that might
> >be more common. If a listener wants to recv packets from the host, then
> >it
> >should bind to the guest addr instead of CID_ANY.
> >
> >Yes, I remember we discussed this idea, this would simplify the
> >receiving, but there is still the issue of a user wanting to receive
> >packets from both the nested guest and the host.
> >
> >OK. Agree.
> >
> >Any other suggestions?
> >
> >
> >I think one solution could be to remove the 1:1 association between
> >DGRAM socket and transport.
> >
> >IIUC VMCI creates a skb for each received packet and queues it through
> >sk_receive_skb() directly in the struct sock.
> >
> >Then the .dgram_dequeue() callback dequeues them using
> >skb_recv_datagram().
> >
> >We can move these parts in the vsock core, and create some helpers to
> >allow the transports to enqueue received DGRAM packets in the same way
> >(and with the same format) directly in the struct sock.
> >
> >
> >I agree to use skbs (and move them to vscok core). We have another use c=
ase
> >which will need to use skb. But I am not sure how this helps with multip=
le
> >transport cases. Each transport has a dgram_dequeue callback. So we stil=
l
> >need to let vsk have multiple transports somehow. Could you elaborate ho=
w
> >using skb help with multiple transport support? Will that be similar to =
what I
> >mentioned above? Thanks.
> >
> >Moving away from the 1:1 association between DGRAM socket and transports=
 sounds
> >like the right approach to me. A dgram socket bound to CID_ANY would be =
able to
> >use either h2g or g2h on a per dgram basis. If the socket is bound to a =
specific CID -
> >either host or the guest CID, it should only use either the h2g for host=
 CID or g2h
> >for the guest CID. This would match the logic for the stream sockets.
> >
> >I like the idea of removing the dgram_dequeue callback from the transpor=
ts and instead
> >having a call that allow the transports to enqueue received dgrams into =
the socket
> >receive queue as skbs. This is what the VMCI transport does today. Then =
the
> >vsock_dgram_recvmsg function will provide functionality similar to what
> >vmci_transport_dgram_dequeue does today. The current datagram format use=
d was
> >created specifically for VMCI datagrams, but the header just contains so=
urce and dest
> >CID and port, so we should be able to use it as is.
> >
> >For sends from CID_ANY, the same logic as for streams in vsock_assign_tr=
ansport can
> >be applied on each send - but without locking the dgram socket to a spec=
ific transport.
> >
> >So the above is mostly restating what Stefano proposed, so this was a ve=
rbose way
> >of agreeing with that.
>
> Jorgen, thank you very much!
> This is exactly what I had in mind, explained much better :-)
>
> We should look at the datagram header better because virtio-vsock uses
> 64 bits for CID and port, but I don't think it's a big problem.
>
> @Jiang, I think Jorgen answered you questions, but feel free to ask more
> if it's not clear.
>
> >
> >With respect to binding a dgram socket to a port, we could introduce a b=
ound list for
> >dgram sockets just like we have for streams. However, for VMCI, the port=
 space
> >is shared with other VMCI datagram clients (at the VMCI device level), s=
o if a
> >dgram socket can potentially use the vmci transport, it should reserve t=
he port
> >with the VMCI transport before assigning it to the socket. So similar to=
 how
> >__vsock_bind_stream checks if an port is already bound/in use, the dgram=
 socket
> >would have an additional call to potential transports to reserve the por=
t. If the
> >port cannot be reserved with the transport, move on to the next port in =
the case
> >of VMADDR_PORT_ANY, or return EADDRINUSE otherwise. Once reserved,
> >It will ensure that VMCI can deliver datagrams to the specified port. A =
reserved
> >port should be released when the socket is removed from the bound list.
>
> Yes, I agree, it seems the right way to go.
>
> Thanks,
> Stefano
>
