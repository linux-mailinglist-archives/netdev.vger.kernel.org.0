Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89993349666
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhCYQGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:06:16 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:17018 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhCYQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:05:55 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0AC49520D49;
        Thu, 25 Mar 2021 19:05:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688352;
        bh=9RzzHlBe+GQemI1wr+cKUwYGdNaJc4AH1/494l+hZds=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=tn6S0EkWMuVQ2073d3IZSKNb2/6Ufpzrhgv62D34ciufFdwmKXczAeEY3xZwIMPrJ
         PGrcdiOASqzp8xG/+kNoqUPqJJJuc7hGpQZzdPAwP4Sw7Os8PLfpGBpg2XeosmR0zA
         dyhuqnieoZNz4xuzGDRul7LbFbLzA66MySXCMpKbCiigeySKWPqmWYZYuS0+Bb55N1
         gmRW8wD7AlAuSL2AFMYUFH3BY6xSsjQZlsd7+R6mR4ttfOsaGgxvLIKbgYcFBEoTeH
         jwfJVsMREFGn2WUD/Eez9oSEjhG7LIag8Cngmto17FM9wuXsIqus2CYVAL3yiR8lRK
         J2+aNRZ/338IQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 9D20D520D1A;
        Thu, 25 Mar 2021 19:05:51 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:05:50 +0300
Subject: Re: [RFC PATCH v7 00/22] virtio/vsock: introduce SOCK_SEQPACKET
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210325105259.dujvq7honiwigfyg@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <de21977d-9e75-aa17-6b4d-fd2ee8e724fd@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:05:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325105259.dujvq7honiwigfyg@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/25/2021 15:49:07
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162675 [Mar 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 438 438 e169a60cee0e977a975a890ed8ef829a2851344a
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/25/2021 15:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 25.03.2021 15:18:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/25 14:47:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/25 13:43:00 #16496755
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.03.2021 13:52, Stefano Garzarella wrote:
> Hi Arseny,
>
> On Tue, Mar 23, 2021 at 04:07:13PM +0300, Arseny Krasnov wrote:
>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>> transport.
>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>> do it, two new packet operations were added: first for start of record
>> and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>> both operations carries metadata - to maintain boundaries and payload
>> integrity. Metadata is introduced by adding special header with two
>> fields - message id and message length:
>>
>> 	struct virtio_vsock_seq_hdr {
>> 		__le32  msg_id;
>> 		__le32  msg_len;
>> 	} __attribute__((packed));
>>
>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>> packets(buffer of second virtio descriptor in chain) in the same way as
>> data transmitted in RW packets. Payload was chosen as buffer for this
>> header to avoid touching first virtio buffer which carries header of
>> packet, because someone could check that size of this buffer is equal
>> to size of packet header. To send record, packet with start marker is
>> sent first(it's header carries length of record and id),then all data
>> is sent as usual 'RW' packets and finally SEQ_END is sent(it carries
>> id of message, which is equal to id of SEQ_BEGIN), also after sending
>> SEQ_END id is incremented. On receiver's side,size of record is known
> >from packet with start record marker. To check that no packets were
>> dropped by transport, 'msg_id's of two sequential SEQ_BEGIN and SEQ_END
>> are checked to be equal and length of data between two markers is
>> compared to then length in SEQ_BEGIN header.
>> 	Now as  packets of one socket are not reordered neither on
>> vsock nor on vhost transport layers, such markers allows to restore
>> original record on receiver's side. If user's buffer is smaller that
>> record length, when all out of size data is dropped.
>> 	Maximum length of datagram is not limited as in stream socket,
>> because same credit logic is used. Difference with stream socket is
>> that user is not woken up until whole record is received or error
>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>> 	Tests also implemented.
>>
>> 	Thanks to stsp2@yandex.ru for encouragements and initial design
>> recommendations.
>>
>> Arseny Krasnov (22):
>>  af_vsock: update functions for connectible socket
>>  af_vsock: separate wait data loop
>>  af_vsock: separate receive data loop
>>  af_vsock: implement SEQPACKET receive loop
>>  af_vsock: separate wait space loop
>>  af_vsock: implement send logic for SEQPACKET
>>  af_vsock: rest of SEQPACKET support
>>  af_vsock: update comments for stream sockets
>>  virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>>  virtio/vsock: simplify credit update function API
>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>  virtio/vsock: fetch length for SEQPACKET record
>>  virtio/vsock: add SEQPACKET receive logic
>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>  virtio/vsock: SEQPACKET support feature bit
>>  virtio/vsock: setup SEQPACKET ops for transport
>>  vhost/vsock: setup SEQPACKET ops for transport
>>  vsock/loopback: setup SEQPACKET ops for transport
>>  vhost/vsock: SEQPACKET feature bit support
>>  virtio/vsock: SEQPACKET feature bit support
>>  vsock_test: add SOCK_SEQPACKET tests
>>  virtio/vsock: update trace event for SEQPACKET
>>
>> drivers/vhost/vsock.c                        |  21 +-
>> include/linux/virtio_vsock.h                 |  21 +
>> include/net/af_vsock.h                       |   9 +
>> .../events/vsock_virtio_transport_common.h   |  48 +-
>> include/uapi/linux/virtio_vsock.h            |  19 +
>> net/vmw_vsock/af_vsock.c                     | 581 +++++++++++------
>> net/vmw_vsock/virtio_transport.c             |  17 +
>> net/vmw_vsock/virtio_transport_common.c      | 379 +++++++++--
>> net/vmw_vsock/vsock_loopback.c               |  12 +
>> tools/testing/vsock/util.c                   |  32 +-
>> tools/testing/vsock/util.h                   |   3 +
>> tools/testing/vsock/vsock_test.c             | 126 ++++
>> 12 files changed, 1015 insertions(+), 253 deletions(-)
>>
>> v6 -> v7:
>> General changelog:
>> - virtio transport callback for message length now removed
>>   from transport. Length of record is returned by dequeue
>>   callback.
>>
>> - function which tries to get message length now returns 0
>>   when rx queue is empty. Also length of current message in
>>   progress is set to 0, when message processed or error
>>   happens.
>>
>> - patches for virtio feature bit moved after patches with
>>   transport ops.
>>
>> Per patch changelog:
>>  see every patch after '---' line.
> I reviewed the series and I left some comments, I think we are at a good 
> point, but we should have the specification accepted before merging this 
> series to avoid having to change the implementation later.
I'll prepare new version of specification patch
>
> What do you think?
Agree, Thank You
>
> Thanks,
> Stefano
>
>
