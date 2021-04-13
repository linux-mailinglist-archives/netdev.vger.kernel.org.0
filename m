Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C152435DF74
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbhDMMxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344139AbhDMMw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618318358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRFstN8ybP1GG18FKmvxc5qtDKuqrNS2MtMQDEsXNb4=;
        b=g/Hf5Pj/SvGHfsd8j9T5ZwKTdWJizSKIim7jRJOZJ3wUZah2hyEMTHGqFmaTmG/F6yfokv
        l0iBWjgNkDFOYYLfJhrfw2tp3lGdCm3l4vE7b76KM4cqNN41LG1y6qXxgsV0bJ/DcPOeTS
        DEyeu1uskktC20qziKYyzmEa9Aw2P5I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-f0EggWnzNd-incNH7jxX6w-1; Tue, 13 Apr 2021 08:52:36 -0400
X-MC-Unique: f0EggWnzNd-incNH7jxX6w-1
Received: by mail-ed1-f70.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso1204454edc.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 05:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SRFstN8ybP1GG18FKmvxc5qtDKuqrNS2MtMQDEsXNb4=;
        b=j4EJKRnvb+EQqxUQkchueZJMrpQU4gcivlz669ZHLKeGpCtvajQ5p6Eb15Rn5cewpJ
         2mGAXjcjI+gL3UJXRYrdce1HYN5zY5ZxHrWeI6WdMTLAJdTBEgYUCtoz+bNE8fELubM3
         I4V8IqUQkXsO8dawhmy0VyivkA2cpzEUcL0WlxmbQhRFsezqpwa0a6M2Wpggk0ZR6O1J
         fZfubZWtk6l2DgqC93H1WcbkD/tFI3di3gLi8RkP80iv2L7t7BF27IY9FqUPUonF9pzM
         xM6ChokvRkilIZW6rLvT8Df4wMoV4bBvKg4smfThTnXfJ8cB+Uhysc3/XYI1ql7nNsTU
         +H4Q==
X-Gm-Message-State: AOAM5300SQ46W/gQPtNLjRxW9GUuNYJSZcIM3bHNOFDLVnfTT3MFiqRQ
        HYqFjJZ/klbSAx0UVD7jlAyWLSbQ+HLKaK7ZpGXGL+NLQusY/uFVZbtT4j8Rcn873O76Fko0uMx
        9isRiN1YXXHB+14VN
X-Received: by 2002:a05:6402:cbb:: with SMTP id cn27mr34759551edb.296.1618318354784;
        Tue, 13 Apr 2021 05:52:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOHRwKP2DxsWSsyrZIefn4hg0eUO/+rDCyPOK9/c04qyp3BrVC/eyApsD5HafWIGou1MCyHA==
X-Received: by 2002:a05:6402:cbb:: with SMTP id cn27mr34759525edb.296.1618318354542;
        Tue, 13 Apr 2021 05:52:34 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u19sm9472320edy.23.2021.04.13.05.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 05:52:34 -0700 (PDT)
Date:   Tue, 13 Apr 2021 14:52:31 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "Jiang Wang ." <jiang.wang@bytedance.com>,
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
Subject: Re: [RFC] vsock: add multiple transports support for dgram
Message-ID: <20210413125231.k4qtyayp5eoiyxln@steredhat>
References: <20210406183112.1150657-1-jiang.wang@bytedance.com>
 <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com>
 <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
 <20210412140437.6k3zxw2cv4p54lvm@steredhat>
 <CAP_N_Z9yi96YDW3gJdCFrPJpNhwpJnaT8gruk7JJSsBne8J-8Q@mail.gmail.com>
 <2EE65DBC-30AC-4E11-BFD5-73586B94C985@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2EE65DBC-30AC-4E11-BFD5-73586B94C985@vmware.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 12:12:50PM +0000, Jorgen Hansen wrote:
>
>
>On 12 Apr 2021, at 20:53, Jiang Wang . <jiang.wang@bytedance.com<mailto:jiang.wang@bytedance.com>> wrote:
>
>On Mon, Apr 12, 2021 at 7:04 AM Stefano Garzarella <sgarzare@redhat.com<mailto:sgarzare@redhat.com>> wrote:
>
>Hi Jiang,
>thanks for re-starting the multi-transport support for dgram!
>
>No problem.
>
>On Wed, Apr 07, 2021 at 11:25:36AM -0700, Jiang Wang . wrote:
>On Wed, Apr 7, 2021 at 2:51 AM Jorgen Hansen <jhansen@vmware.com<mailto:jhansen@vmware.com>> wrote:
>
>
>On 6 Apr 2021, at 20:31, Jiang Wang <jiang.wang@bytedance.com<mailto:jiang.wang@bytedance.com>> wrote:
>
>From: "jiang.wang<http://jiang.wang>" <jiang.wang@bytedance.com<mailto:jiang.wang@bytedance.com>>
>
>Currently, only VMCI supports dgram sockets. To supported
>nested VM use case, this patch removes transport_dgram and
>uses transport_g2h and transport_h2g for dgram too.
>
>I agree on this part, I think that's the direction to go.
>transport_dgram was added as a shortcut.
>
>Got it.
>
>
>Could you provide some background for introducing this change - are you
>looking at introducing datagrams for a different transport? VMCI datagrams
>already support the nested use case,
>
>Yes, I am trying to introduce datagram for virtio transport. I wrote a
>spec patch for
>virtio dgram support and also a code patch, but the code patch is still WIP.
>When I wrote this commit message, I was thinking nested VM is the same as
>multiple transport support. But now, I realize they are different.
>Nested VMs may use
>the same virtualization layer(KVM on KVM), or different virtualization layers
>(KVM on ESXi). Thanks for letting me know that VMCI already supported nested
>use cases. I think you mean VMCI on VMCI, right?
>
>but if we need to support multiple datagram
>transports we need to rework how we administer port assignment for datagrams.
>One specific issue is that the vmci transport won’t receive any datagrams for a
>port unless the datagram socket has already been assigned the vmci transport
>and the port bound to the underlying VMCI device (see below for more details).
>
>I see.
>
>The transport is assgined when sending every packet and
>receiving every packet on dgram sockets.
>
>Is the intent that the same datagram socket can be used for sending packets both
>In the host to guest, and the guest to directions?
>
>Nope. One datagram socket will only send packets to one direction, either to the
>host or to the guest. My above description is wrong. When sending packets, the
>transport is assigned with the first packet (with auto_bind).
>
>I'm not sure this is right.
>The auto_bind on the first packet should only assign a local port to the
>socket, but does not affect the transport to be used.
>
>A user could send one packet to the nested guest and another to the host
>using the same socket, or am I wrong?
>
>OK. I think you are right.
>
>
>The problem is when receiving packets. The listener can bind to the
>VMADDR_CID_ANY
>address. Then it is unclear which transport we should use. For stream
>sockets, there will be a new socket for each connection, and transport
>can be decided
>at that time. For datagram sockets, I am not sure how to handle that.
>
>yes, this I think is the main problem, but maybe the sender one is even
>more complicated.
>
>Maybe we should remove the 1:1 association we have now between vsk and
>transport.
>
>Yes, I thought about that too. One idea is to define two transports in vsk.
>For sending pkt, we can pick the right transport when we get the packet, like
>in virtio_transport_send_pkt_info(). For receiving pkts, we have to check
>and call both
>transports dequeue callbacks if the local cid is CID_ANY.
>
>At least for DGRAM, for connected sockets I think the association makes
>sense.
>
>Yeah. For a connected socket, we will only use one transport.
>
>For VMCI, does the same transport can be used for both receiving from
>host and from
>the guest?
>
>Yes, they're registered at different times, but it's the same transport.
>
>
>For virtio, the h2g and g2h transports are different,, so we have to
>choose
>one of them. My original thought is to wait until the first packet
>arrives.
>
>Another idea is that we always bind to host addr and use h2g
>transport because I think that might
>be more common. If a listener wants to recv packets from the host, then
>it
>should bind to the guest addr instead of CID_ANY.
>
>Yes, I remember we discussed this idea, this would simplify the
>receiving, but there is still the issue of a user wanting to receive
>packets from both the nested guest and the host.
>
>OK. Agree.
>
>Any other suggestions?
>
>
>I think one solution could be to remove the 1:1 association between
>DGRAM socket and transport.
>
>IIUC VMCI creates a skb for each received packet and queues it through
>sk_receive_skb() directly in the struct sock.
>
>Then the .dgram_dequeue() callback dequeues them using
>skb_recv_datagram().
>
>We can move these parts in the vsock core, and create some helpers to
>allow the transports to enqueue received DGRAM packets in the same way
>(and with the same format) directly in the struct sock.
>
>
>I agree to use skbs (and move them to vscok core). We have another use case
>which will need to use skb. But I am not sure how this helps with multiple
>transport cases. Each transport has a dgram_dequeue callback. So we still
>need to let vsk have multiple transports somehow. Could you elaborate how
>using skb help with multiple transport support? Will that be similar to what I
>mentioned above? Thanks.
>
>Moving away from the 1:1 association between DGRAM socket and transports sounds
>like the right approach to me. A dgram socket bound to CID_ANY would be able to
>use either h2g or g2h on a per dgram basis. If the socket is bound to a specific CID -
>either host or the guest CID, it should only use either the h2g for host CID or g2h
>for the guest CID. This would match the logic for the stream sockets.
>
>I like the idea of removing the dgram_dequeue callback from the transports and instead
>having a call that allow the transports to enqueue received dgrams into the socket
>receive queue as skbs. This is what the VMCI transport does today. Then the
>vsock_dgram_recvmsg function will provide functionality similar to what
>vmci_transport_dgram_dequeue does today. The current datagram format used was
>created specifically for VMCI datagrams, but the header just contains source and dest
>CID and port, so we should be able to use it as is.
>
>For sends from CID_ANY, the same logic as for streams in vsock_assign_transport can
>be applied on each send - but without locking the dgram socket to a specific transport.
>
>So the above is mostly restating what Stefano proposed, so this was a verbose way
>of agreeing with that.

Jorgen, thank you very much!
This is exactly what I had in mind, explained much better :-)

We should look at the datagram header better because virtio-vsock uses 
64 bits for CID and port, but I don't think it's a big problem.

@Jiang, I think Jorgen answered you questions, but feel free to ask more 
if it's not clear.

>
>With respect to binding a dgram socket to a port, we could introduce a bound list for
>dgram sockets just like we have for streams. However, for VMCI, the port space
>is shared with other VMCI datagram clients (at the VMCI device level), so if a
>dgram socket can potentially use the vmci transport, it should reserve the port
>with the VMCI transport before assigning it to the socket. So similar to how
>__vsock_bind_stream checks if an port is already bound/in use, the dgram socket
>would have an additional call to potential transports to reserve the port. If the
>port cannot be reserved with the transport, move on to the next port in the case
>of VMADDR_PORT_ANY, or return EADDRINUSE otherwise. Once reserved,
>It will ensure that VMCI can deliver datagrams to the specified port. A reserved
>port should be released when the socket is removed from the bound list.

Yes, I agree, it seems the right way to go.

Thanks,
Stefano

