Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804EB37F9F1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhEMOsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:48:06 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:18818 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbhEMOrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:47:23 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 4E11B7613D;
        Thu, 13 May 2021 17:46:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620917171;
        bh=HaLUOTq1NjnbyJ1ccTVP4hrXVKS2N88ZsUAsU5b+1Aw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=Je3Fa27C1ZH+MB9xEBI/H0DiVbN3mfBf9jEFTfVW7hQdyaf4m9Fv0F7/5ohv+siNV
         HvM8hYinUYF55PAQ4G5vJhAAGPRc7b7FFL7U3UrMzGdFq8InEOWO+cA2lsHWh9wWkc
         Rrjol0qjj/FY9zlVy8Db7xaUiikwwlay42WluoGUg9kgdhvhCMHQA9aFSlTtNaA9XU
         k3O/4CjsvhERyEtLG7K9p8OSbdPjOasW9OMqdfFHhp9mCWYqa18X8eQpzx3ypzW4iW
         yE0YqQSrwm+x2DcIcHxlPO+x2ljic3ZRpummvF8q1TiL/JwO9ynQGjwGEX2eHt8H7o
         mj/zcH5cNaJ+g==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 15ACF7605C;
        Thu, 13 May 2021 17:46:11 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:46:10 +0300
Subject: Re: [RFC PATCH v9 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210513141018.pqsmb5wqbjrbwwho@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <04bb38ce-7f7f-e9e8-ee3e-20be94c9850c@kaspersky.com>
Date:   Thu, 13 May 2021 17:46:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513141018.pqsmb5wqbjrbwwho@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/13/2021 14:30:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163644 [May 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/13/2021 14:33:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.05.2021 13:39:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/13 13:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/13 10:44:00 #16575454
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.2021 17:10, Stefano Garzarella wrote:
> Hi Arseny,
>
> On Sat, May 08, 2021 at 07:30:23PM +0300, Arseny Krasnov wrote:
>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>> transport.
>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>> set to 1 in last RW packet of message.
>> 	Now as  packets of one socket are not reordered neither on vsock
>> nor on vhost transport layers, such bit allows to restore original
>> message on receiver's side. If user's buffer is smaller than message
>> length, when all out of size data is dropped.
>> 	Maximum length of datagram is not limited as in stream socket,
>> because same credit logic is used. Difference with stream socket is
>> that user is not woken up until whole record is received or error
>> occurred. Implementation also supports 'MSG_TRUNC' flags.
>> 	Tests also implemented.
>>
>> 	Thanks to stsp2@yandex.ru for encouragements and initial design
>> recommendations.
>>
>> Arseny Krasnov (19):
>>  af_vsock: update functions for connectible socket
>>  af_vsock: separate wait data loop
>>  af_vsock: separate receive data loop
>>  af_vsock: implement SEQPACKET receive loop
>>  af_vsock: implement send logic for SEQPACKET
>>  af_vsock: rest of SEQPACKET support
>>  af_vsock: update comments for stream sockets
>>  virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>>  virtio/vsock: simplify credit update function API
>>  virtio/vsock: defines and constants for SEQPACKET
>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>  virtio/vsock: add SEQPACKET receive logic
>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>  virtio/vsock: enable SEQPACKET for transport
>>  vhost/vsock: enable SEQPACKET for transport
>>  vsock/loopback: enable SEQPACKET for transport
>>  vsock_test: add SOCK_SEQPACKET tests
>>  virtio/vsock: update trace event for SEQPACKET
>>  af_vsock: serialize writes to shared socket
>>
>> drivers/vhost/vsock.c                        |  42 +-
>> include/linux/virtio_vsock.h                 |   9 +
>> include/net/af_vsock.h                       |   8 +
>> .../events/vsock_virtio_transport_common.h   |   5 +-
>> include/uapi/linux/virtio_vsock.h            |   9 +
>> net/vmw_vsock/af_vsock.c                     | 417 +++++++++++------
>> net/vmw_vsock/virtio_transport.c             |  25 +
>> net/vmw_vsock/virtio_transport_common.c      | 129 ++++-
>> net/vmw_vsock/vsock_loopback.c               |  11 +
>> tools/testing/vsock/util.c                   |  32 +-
>> tools/testing/vsock/util.h                   |   3 +
>> tools/testing/vsock/vsock_test.c             |  63 +++
>> 12 files changed, 594 insertions(+), 159 deletions(-)
>>
>> v8 -> v9:
>> General changelog:
>> - see per patch change log.
>>
> I reviewed this series and left some comments.
>
> Before remove the RFC tag, please check that all the commit messages 
> contains the right information.
>
> Also, I recommend you take a look on how the other commits in the Linux 
> tree are written because the commits in this series look like todo 
> lists.
> For RFC could be fine, but for the final version it would be better to 
> rewrite them following the advice written here: 
> Documentation/process/submitting-patches.rst
Thank You for review, ok, i'll check it
>
> Thanks,
> Stefano
>
>
