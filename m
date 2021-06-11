Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9D3A448E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhFKPCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:02:45 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:27308 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhFKPCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:02:44 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0BBD2520CE3;
        Fri, 11 Jun 2021 18:00:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623423644;
        bh=yMZMCLDSKRLSd6YOdIWpE0TF4L4SV13EO8NbpS+k6Co=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=ZqV8sSliCb9JYfhhc8MnbazVz89Rmhf05rZ/3kFz0Y1MQ6LaPgNoNcbFKS0Ol2mdU
         J+AGuYl/dbBkX89C+dfmwsFvZ20q4ysNUn4Ud9jrL4JDic8gu2OkewQDqEw6Jdo/0o
         ifNWi0DBlCCYpS231rZQr30wg+3mNYhNRAdKVq4M57LQBUYe/NhvPITB9XaxpMHBVE
         l3Vy/DmS9wEEgVzPCrM9QIPsjJQle9v7opmJAkdj7fg1ZcF2nM/3f/Bzd+IJsGIAgb
         /v5oaXIMNoj0Qhm1vC4nCnlgVlLBbmLN36WiQ0fdZWiN6cmXV8ooGBJ9rGmatkrO8E
         Pvw/UiYxiDaaQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6C070520CEA;
        Fri, 11 Jun 2021 18:00:43 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 18:00:42 +0300
Subject: Re: [PATCH v11 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <59b720a8-154f-ad29-e7a9-b86b69408078@kaspersky.com>
 <20210611122533.cy4jce4vxhhou5ms@steredhat>
 <10a64ff5-86df-85f3-5cf2-2fa7e8ddc294@kaspersky.com>
 <20210611145756.lfi7dwvxqwjhkctr@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <4a443078-5f71-c43a-38ad-adc23bb059f4@kaspersky.com>
Date:   Fri, 11 Jun 2021 18:00:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210611145756.lfi7dwvxqwjhkctr@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 14:38:32
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164287 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 14:40:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 12:41:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 12:53:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/11 13:21:00 #16710450
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.06.2021 17:57, Stefano Garzarella wrote:
> On Fri, Jun 11, 2021 at 05:39:01PM +0300, Arseny Krasnov wrote:
>> On 11.06.2021 15:25, Stefano Garzarella wrote:
>>> Hi Arseny,
>>>
>>> On Fri, Jun 11, 2021 at 02:17:00PM +0300, Arseny Krasnov wrote:
>>>> On 11.06.2021 14:07, Arseny Krasnov wrote:
>>>>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>>>>> transport.
>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>>>>> set to 1 in last RW packet of message.
>>>>> 	Now as  packets of one socket are not reordered neither on vsock
>>>>> nor on vhost transport layers, such bit allows to restore original
>>>>> message on receiver's side. If user's buffer is smaller than message
>>>>> length, when all out of size data is dropped.
>>>>> 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
>>>>> 	Implementation also supports 'MSG_TRUNC' flags.
>>>>> 	Tests also implemented.
>>>>>
>>>>> 	Thanks to stsp2@yandex.ru for encouragements and initial design
>>>>> recommendations.
>>>>>
>>>>>  Arseny Krasnov (18):
>>>>>   af_vsock: update functions for connectible socket
>>>>>   af_vsock: separate wait data loop
>>>>>   af_vsock: separate receive data loop
>>>>>   af_vsock: implement SEQPACKET receive loop
>>>>>   af_vsock: implement send logic for SEQPACKET
>>>>>   af_vsock: rest of SEQPACKET support
>>>>>   af_vsock: update comments for stream sockets
>>>>>   virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>>>>>   virtio/vsock: simplify credit update function API
>>>>>   virtio/vsock: defines and constants for SEQPACKET
>>>>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>>   virtio/vsock: add SEQPACKET receive logic
>>>>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>>>>   virtio/vsock: enable SEQPACKET for transport
>>>>>   vhost/vsock: enable SEQPACKET for transport
>>>>>   vsock/loopback: enable SEQPACKET for transport
>>>>>   vsock_test: add SOCK_SEQPACKET tests
>>>>>   virtio/vsock: update trace event for SEQPACKET
>>>>>
>>>>>  drivers/vhost/vsock.c                              |  56 ++-
>>>>>  include/linux/virtio_vsock.h                       |  10 +
>>>>>  include/net/af_vsock.h                             |   8 +
>>>>>  .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>>>>>  include/uapi/linux/virtio_vsock.h                  |   9 +
>>>>>  net/vmw_vsock/af_vsock.c                           | 464 ++++++++++++------
>>>>>  net/vmw_vsock/virtio_transport.c                   |  26 ++
>>>>>  net/vmw_vsock/virtio_transport_common.c            | 179 +++++++-
>>>>>  net/vmw_vsock/vsock_loopback.c                     |  12 +
>>>>>  tools/testing/vsock/util.c                         |  32 +-
>>>>>  tools/testing/vsock/util.h                         |   3 +
>>>>>  tools/testing/vsock/vsock_test.c                   | 116 ++++++
>>>>>  12 files changed, 730 insertions(+), 190 deletions(-)
>>>>>
>>>>>  v10 -> v11:
>>>>>  General changelog:
>>>>>   - now data is copied to user's buffer only when
>>>>>     whole message is received.
>>>>>   - reader is woken up when EOR packet is received.
>>>>>   - if read syscall was interrupted by signal or
>>>>>     timeout, error is returned(not 0).
>>>>>
>>>>>  Per patch changelog:
>>>>>   see every patch after '---' line.
>>>> So here is new version for review with updates discussed earlier :)
>>> Thanks, I'll review next week, but I suggest you again to split in two
>>> series, since patchwork (and netdev maintainers) are not happy with a
>>> series of 18 patches.
>>>
>>> If you still prefer to keep them together during development, then
>>> please use the RFC tag.
>>>
>>> Also did you take a look at the FAQ for netdev that I linked last 
>>> time?
>>> I don't see the net-next tag...
>> I didn't use next tag because two patches from first seven(which was
>>
>> considered to be sent to netdev) - 0004 and 0006
>>
>> were changed in this patchset(because of last ideas about queueing
>>
>> whole message). So i removed R-b line and now there is no sense to
>>
>> use net-next tag for first patches. When it will be R-b - i'll send it 
> Okay, in that case better to use RFC tag.
Ack, for big patchset for LKML i'll RFC tag
>
>> to
>>
>> netdev with such tag and we can continue discussing second part
>>
>> of patches(virtio specific).
> Don't worry for now. You can do it for the next round, but I think all 
> the patches will go through netdev and would be better to split in 2 
> series, both of them with net-next tag.

Of course, for netdev this patchset will be splitted for two series


Thank You

>
> Thanks,
> Stefano
>
>
