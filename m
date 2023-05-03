Return-Path: <netdev+bounces-148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FBA6F5798
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BF0F1C20EBB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A294BD514;
	Wed,  3 May 2023 12:09:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91800D50F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:09:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F95959DD
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683115788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkjEggx5doDuLSwR8ZjUhb7IBiYs0z5W7yuB+yUHCuk=;
	b=h6H2SNzm0pR45sOSvTm9MuUN3xAxyh+rx/ASq4DVtH9OsMs+J6T7ntsFQ3bg7LRJ90y1h0
	B4XPxV3uEKhW5WDfjO7NJ4LJ8wSFUonTtoxs8LPCJzfHL+xDiNeRI4afu/Wy7gvHFSRU8E
	DE6ZO18y0+bVLpTCVOh2MXpQB9tZWso=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300---Qp1LNvOg6effr7sUZ-dg-1; Wed, 03 May 2023 08:09:47 -0400
X-MC-Unique: --Qp1LNvOg6effr7sUZ-dg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94f0dd11762so619791866b.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 05:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683115786; x=1685707786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkjEggx5doDuLSwR8ZjUhb7IBiYs0z5W7yuB+yUHCuk=;
        b=VLU4bXtkgSGBEfS81hqxApPYs4nfHObvPcrysUFGl+1bGi70kh0Aqehm+MCroMsVMR
         CC9zM+p3Q5HTnjFF7HZhy4Q5Mh3ChUE7F8kpYxjZtZlNd70PSz5ypNmPjCTV6nbyepET
         h1F4ydOdiFcJwCLHkhDk3DDfnf8fQePHOmzLmSe0CtoIp6HowESl5o5F3pTjUu1WDP8D
         7i8ViVO4xz8Bk/uiqAqq3x5xGUFdXdWlykDN4nt0K3pTIMscrujn4eIj9X7bItB/PiI6
         /Tcj+eGdCiiaF3tbxK/UVhnCF67TXMPsBmNQJvs0vbOY9Vb0Zi7i+rFH6rBUAVxYBGOE
         GG/w==
X-Gm-Message-State: AC+VfDxgtjOCXuKVPN/5K3uSXyx7ujviGXuIVy15uqVa1sQjK2wPbfbj
	1oqx6nt3uv2z5REeMrZycLuocIqzWCdBpl81xOkDbGjGMN3GxArSqYP7y9xXqgtw65Djlw1CjGD
	8iC7y6vgAzYjrRsMM
X-Received: by 2002:a17:907:3684:b0:94e:547b:6301 with SMTP id bi4-20020a170907368400b0094e547b6301mr2777485ejc.8.1683115786383;
        Wed, 03 May 2023 05:09:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6SuQbXI5bAnd45tZOFasAVvd6rklyRosKoF3BB7Xuzo6B77CAdECRGvlWYq0kYBrlTvQht1w==
X-Received: by 2002:a17:907:3684:b0:94e:547b:6301 with SMTP id bi4-20020a170907368400b0094e547b6301mr2777459ejc.8.1683115786077;
        Wed, 03 May 2023 05:09:46 -0700 (PDT)
Received: from sgarzare-redhat ([185.29.96.107])
        by smtp.gmail.com with ESMTPSA id y15-20020a170906070f00b0094f54279f13sm17256035ejb.157.2023.05.03.05.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:09:45 -0700 (PDT)
Date: Wed, 3 May 2023 14:09:38 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Vishnu Dasa <vdasa@vmware.com>, Wei Liu <wei.liu@kernel.org>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Dexuan Cui <decui@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, Bryan Tan <bryantan@vmware.com>, 
	Eric Dumazet <edumazet@google.com>, linux-hyperv@vger.kernel.org, 
	Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v2 3/4] vsock: Add lockless sendmsg() support
Message-ID: <lc2v5porgyzx6neimlyrpeg3d5l7trnorbs7xubqgcrlp7bbi7@yxs25wx67tm7>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-3-079cc7cee62e@bytedance.com>
 <bs3elc4lwvvq22y2vq27ewo23qibei2neys4txszi6wybxpuzu@czyq5hb7iv5t>
 <ZDp837+YDvAfoNLc@bullseye>
 <se4wymgrmiihkoq4kpnlo2uwklxhfreyzrqjuc7qcqz3c3l7l3@dlxostl5y6q2>
 <ZDre6Mqh9+HA8wuN@bullseye>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZDre6Mqh9+HA8wuN@bullseye>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Apr 15, 2023 at 05:29:12PM +0000, Bobby Eshleman wrote:
>On Fri, Apr 28, 2023 at 12:29:50PM +0200, Stefano Garzarella wrote:
>> On Sat, Apr 15, 2023 at 10:30:55AM +0000, Bobby Eshleman wrote:
>> > On Wed, Apr 19, 2023 at 11:30:53AM +0200, Stefano Garzarella wrote:
>> > > On Fri, Apr 14, 2023 at 12:25:59AM +0000, Bobby Eshleman wrote:
>> > > > Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
>> > > > it does not scale when many senders share a socket.
>> > > >
>> > > > Prior to this patch the socket lock is used to protect the local_addr,
>> > > > remote_addr, transport, and buffer size variables. What follows are the
>> > > > new protection schemes for the various protected fields that ensure a
>> > > > race-free multi-sender sendmsg() path for vsock dgrams.
>> > > >
>> > > > - local_addr
>> > > >    local_addr changes as a result of binding a socket. The write path
>> > > >    for local_addr is bind() and various vsock_auto_bind() call sites.
>> > > >    After a socket has been bound via vsock_auto_bind() or bind(), subsequent
>> > > >    calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
>> > > >    rejects the user request and vsock_auto_bind() early exits.
>> > > >    Therefore, the local addr can not change while a parallel thread is
>> > > >    in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
>> > > >    Change: only acquire lock for auto-binding as-needed in sendmsg().
>> > > >
>> > > > - vsk->transport
>> > > >    Updated upon socket creation and it doesn't change again until the
>> > >
>> > > This is true only for dgram, right?
>> > >
>> >
>> > Yes.
>> >
>> > > How do we decide which transport to assign for dgram?
>> > >
>> >
>> > The transport is assigned in proto->create() [vsock_create()]. It is
>> > assigned there *only* for dgrams, whereas for streams/seqpackets it is
>> > assigned in connect(). vsock_create() sets transport to
>> > 'transport_dgram' if sock->type == SOCK_DGRAM.
>> >
>> > vsock_sk_destruct() then eventually sets vsk->transport to NULL.
>> >
>> > Neither destruct nor create can occur in parallel with sendmsg().
>> > create() hasn't yet returned the sockfd for the user to call upon it
>> > sendmsg(), and AFAICT destruct is only called after the final socket
>> > reference is released, which only happens after the socket no longer
>> > exists in the fd lookup table and so sendmsg() will fail before it ever
>> > has the chance to race.
>>
>> This is okay if a socket can be assigned to a single transport, but with
>> dgrams I'm not sure we can do that.
>>
>> Since it is not connected, a socket can send or receive packets from
>> different transports, so maybe we can't assign it to a specific one,
>> but do a lookup for every packets to understand which transport to use.
>>
>
>Yes this is true, this lookup needs to be implemented... currently
>sendmsg() doesn't do this at all. It grabs the remote_addr when passed
>in from sendto(), but then just uses the same old transport from vsk.
>You are right that sendto() should be a per-packet lookup, not a
>vsk->transport read. Perhaps I should add that as another patch in this
>series, and make it precede this one?

Yep, I think so, we need to implement it before adding a new transport
that can support dgram.

>
>For the send() / sendto(NULL) case where vsk->transport is being read, I
>do believe this is still race-free, but...
>
>If we later support dynamic transports for datagram, such that
>connect(VMADDR_LOCAL_CID) sets vsk->transport to transport_loopback,
>connect(VMADDR_CID_HOST) sets vsk->transport to something like
>transport_datagram_g2h, etc..., then vsk->transport will need to be
>bundled into the RCU-protected pointer too, since it may change when
>remote_addr changes.

Yep, I think so. Although in vsock_dgram_connect we call lock_sock(), so 
maybe that could be enough to protect us.

In general I think we should use vsk->transport if vsock_dgram_connect()
is called, or we need to do per-packet lookup.

Another think I would change, is the dgram_dequeue() callback.
I would remove it, and move in the core the code in 
vmci_transport_dgram_dequeue() since it seems pretty generic.

This should work well if every transport uses sk_receive_skb() to 
enqueue sk_buffs in the socket buffer.

Thanks,
Stefano


