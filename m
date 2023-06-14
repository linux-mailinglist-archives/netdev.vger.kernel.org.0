Return-Path: <netdev+bounces-10596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC3972F43C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14FD281294
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E62615A2;
	Wed, 14 Jun 2023 05:44:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1018138E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:44:28 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D0219B3;
	Tue, 13 Jun 2023 22:44:25 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id A75E05FD4E;
	Wed, 14 Jun 2023 08:44:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1686721461;
	bh=x+U9EAwPscPT+sus2+Qx6lEaN4S9X3UqnewbxDP6+7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	b=oyTEScIN+ET9/rsxEkirqGRR78glrkQa6iTwE2J5RIBn/thCiM3IApBy78a3Y5WDN
	 pRieXbtCoGj34+cAMsiq0iEVvfnkur9WBaXNMwPbz2IKVZE2wcINS/uOiVipUnPvyX
	 dXn+rdWWfKIO1kM6kJI1nyVJzqT3AqrdzYrX6nSY+Wan9w1GjAO5A6KJa+oM+RTOSo
	 eIMT1OLtWHNVz+iYIb7KKYhEiSUPz4clbYA5+fs8Ry4TsKICJdc4in/DCezO6Moh4S
	 t64hNrbrI4GY+xE39V+8l9dfc964wOc8BO2s2K7dV+ASDjhhvwabM+Toi3mzb7u2NC
	 tcL1o81yUfPig==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Wed, 14 Jun 2023 08:44:16 +0300 (MSK)
Message-ID: <7e68f00b-7e50-cc6d-c0dc-ea54f7a2d992@sberdevices.ru>
Date: Wed, 14 Jun 2023 08:39:32 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 00/17] vsock: MSG_ZEROCOPY flag support
Content-Language: en-US
To: Bobby Eshleman <bobbyeshleman@gmail.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <ZIdT9Ei9C5wkHXNe@bullseye>
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <ZIdT9Ei9C5wkHXNe@bullseye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/14 01:08:00 #21497529
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Bobby! Sorry for a little bit late reply.

On 12.06.2023 20:20, Bobby Eshleman wrote:
> Hey Arseniy,
> 
> Thanks for this series, very good stuff!
> 
> On Sat, Jun 03, 2023 at 11:49:22PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>>                            DESCRIPTION
>>
>> this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>> current implementation for TCP as much as possible:
>>
>> 1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>>    flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>>    flag will be ignored (e.g. without completion).
>>
>> 2) Kernel uses completions from socket's error queue. Single completion
>>    for single tx syscall (or it can merge several completions to single
>>    one). I used already implemented logic for MSG_ZEROCOPY support:
>>    'msg_zerocopy_realloc()' etc.
>>
>> Difference with copy way is not significant. During packet allocation,
>> non-linear skb is created and filled with pinned user pages.
>> There are also some updates for vhost and guest parts of transport - in
>> both cases i've added handling of non-linear skb for virtio part. vhost
>> copies data from such skb to the guest's rx virtio buffers. In the guest,
>> virtio transport fills tx virtio queue with pages from skb.
>>
>> Head of this patchset is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
>>
>>
>> This version has several limits/problems:
>>
>> 1) As this feature totally depends on transport, there is no way (or it
>>    is difficult) to check whether transport is able to handle it or not
>>    during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>>    setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>>    leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>>    are not considered to be called from each other. So in current version
>>    SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>>    AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>>    tx routine will fail with EOPNOTSUPP.
>>
>>    ^^^
>>    This is still no resolved :(
>>
> 
> I think to get around this you could use set SOCK_CUSTOM_SOCKOPT in the
> vsock create function, handle SO_ZEROCOPY in the vsock handler, but pass
> the rest of the common options to sock_setsockopt().

Ah yes, I really forget about this way, thanks!

> 
> I think the next issue you would run into though is that users may call
> setsockopt() before connect(), and so the transport will still be
> unknown (except for dgrams, which are weird for reasons).
> 
> What do you think about EOPNOTSUPP being returned when the user selects
> an incompatible transport with connect() instead of returning it later
> in the tx path?

Yes, I think it is ok, in 'vsock_assign_transport()' which was called from
'connect()' I will check that if zerocopy transmission is enabled, I will
check that transport supports it (seqpacket mode works in the same way -
if transports doesn't support it -> connect failed).

So if 'setsockopt()' is called before 'connect()' (e.g. transport is unknown),
I just set this option and thats all. Later in 'connect()' during transport
assignment I'll check that selected transport supports this feature if needed.

If 'setsockopt()' is called after 'connect()' everything is simple - transport
is already known.

Thanks for this clue, I'll include it in v5!

> 
>> 2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>>    one completion. In each completion there is flag which shows how tx
>>    was performed: zerocopy or copy. This leads that whole message must
>>    be send in zerocopy or copy way - we can't send part of message with
>>    copying and rest of message with zerocopy mode (or vice versa). Now,
>>    we need to account vsock credit logic, e.g. we can't send whole data
>>    once - only allowed number of bytes could sent at any moment. In case
>>    of copying way there is no problem as in worst case we can send single
>>    bytes, but zerocopy is more complex because smallest transmission
>>    unit is single page. So if there is not enough space at peer's side
>>    to send integer number of pages (at least one) - we will wait, thus
>>    stalling tx side. To overcome this problem i've added simple rule -
>>    zerocopy is possible only when there is enough space at another side
>>    for whole message (to check, that current 'msghdr' was already used
>>    in previous tx iterations i use 'iov_offset' field of it's iov iter).
>>
>>    ^^^
>>    Discussed as ok during v2. Link:
>>    https://lore.kernel.org/netdev/23guh3txkghxpgcrcjx7h62qsoj3xgjhfzgtbmqp2slrz3rxr4@zya2z7kwt75l/
>>
>> 3) loopback transport is not supported, because it requires to implement
>>    non-linear skb handling in dequeue logic (as we "send" fragged skb
>>    and "receive" it from the same queue). I'm going to implement it in
>>    next versions.
>>
>>    ^^^ fixed in v2
>>
>> 4) Current implementation sets max length of packet to 64KB. IIUC this
>>    is due to 'kmalloc()' allocated data buffers. I think, in case of
>>    MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>>    not touched for data - user space pages are used as buffers. Also
>>    this limit trims every message which is > 64KB, thus such messages
>>    will be send in copy mode due to 'iov_offset' check in 2).
>>
>>    ^^^ fixed in v2
>>
>>                          PATCHSET STRUCTURE
>>
>> Patchset has the following structure:
>> 1) Handle non-linear skbuff on receive in virtio/vhost.
>> 2) Handle non-linear skbuff on send in virtio/vhost.
>> 3) Updates for AF_VSOCK.
>> 4) Enable MSG_ZEROCOPY support on transports.
>> 5) Tests/tools/docs updates.
>>
>>                             PERFORMANCE
>>
>> Performance: it is a little bit tricky to compare performance between
>> copy and zerocopy transmissions. In zerocopy way we need to wait when
>> user buffers will be released by kernel, so it is like synchronous
>> path (wait until device driver will process it), while in copy way we
>> can feed data to kernel as many as we want, don't care about device
>> driver. So I compared only time which we spend in the 'send()' syscall.
>> Then if this value will be combined with total number of transmitted
>> bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
>> enough credit, receiver allocates same amount of space as sender needs.
>>
>> Sender:
>> ./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]
>>
>> Receiver:
>> ./vsock_perf --vsk-size 256M
>>
>> I run tests on two setups: desktop with Core i7 - I use this PC for
>> development and in this case guest is nested guest, and host is normal
>> guest. Another hardware is some embedded board with Atom - here I don't
>> have nested virtualization - host runs on hw, and guest is normal guest.
>>
>> G2H transmission (values are Gbit/s):
>>
>>    Core i7 with nested guest.            Atom with normal guest.
>>
>> *-------------------------------*   *-------------------------------*
>> |          |         |          |   |          |         |          |
>> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>> |          |         |          |   |          |         |          |
>> *-------------------------------*   *-------------------------------*
>> |   4KB    |    3    |    10    |   |   4KB    |   0.8   |   1.9    |
>> *-------------------------------*   *-------------------------------*
>> |   32KB   |   20    |    61    |   |   32KB   |   6.8   |   20.2   |
>> *-------------------------------*   *-------------------------------*
>> |   256KB  |   33    |   244    |   |   256KB  |   7.8   |   55     |
>> *-------------------------------*   *-------------------------------*
>> |    1M    |   30    |   373    |   |    1M    |   7     |   95     |
>> *-------------------------------*   *-------------------------------*
>> |    8M    |   22    |   475    |   |    8M    |   7     |   114    |
>> *-------------------------------*   *-------------------------------*
>>
>> H2G:
>>
>>    Core i7 with nested guest.            Atom with normal guest.
>>
>> *-------------------------------*   *-------------------------------*
>> |          |         |          |   |          |         |          |
>> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>> |          |         |          |   |          |         |          |
>> *-------------------------------*   *-------------------------------*
>> |   4KB    |   20    |    10    |   |   4KB    |   4.37  |    3     |
>> *-------------------------------*   *-------------------------------*
>> |   32KB   |   37    |    75    |   |   32KB   |   11    |   18     |
>> *-------------------------------*   *-------------------------------*
>> |   256KB  |   44    |   299    |   |   256KB  |   11    |   62     |
>> *-------------------------------*   *-------------------------------*
>> |    1M    |   28    |   335    |   |    1M    |   9     |   77     |
>> *-------------------------------*   *-------------------------------*
>> |    8M    |   27    |   417    |   |    8M    |  9.35   |  115     |
>> *-------------------------------*   *-------------------------------*
>>
> 
> Nice!
> 
> 
> [...]
> 
> Thanks,
> Bobby

Thanks, Arseniy

