Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B15733BFAA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhCOPWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:22:40 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:16037 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhCOPWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:22:16 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 056F3764E8;
        Mon, 15 Mar 2021 18:22:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615821728;
        bh=wjIckQqSRCQLu5XNkpD2uYgkQDsgU9JkWsxS6WnQ4g0=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=y74wA8tcCmC/60WlxHzCrcfF04Mdh9g96QZt+WGefkJHXc8Z67I4oLIUBV1cYmTFy
         2EnaEN3SGfnfyvMjLijL7O8kQZeYEkGjn33fuc8a77Gs6u0QQZl0gyhtsfpn1gxCu1
         9pETguRK77wayrpLysL1r5hx5eO0scpZCkd2paeogpNtoTDbo7y9vxXxM3oDpisV6l
         P3eDhyL1y2RFvg4aop5cW+Nx/U7fG24mPE73Ipkc/ehhlhVAYWwEmU2bylbmLTypuJ
         B3UqZrKM5uTGom3KycjprsRwTLYi+cFrzrZGVLavMdWadhXDZTBS0ytErzMx7ICiDU
         hw9O+46mUKggw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 329D076493;
        Mon, 15 Mar 2021 18:22:07 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 15
 Mar 2021 18:22:06 +0300
Subject: Re: [RFC PATCH v6 00/22] virtio/vsock: introduce SOCK_SEQPACKET
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210315114027.neacovpmw3nzz77z@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <c4be25c6-8a53-7947-735b-2afacd989120@kaspersky.com>
Date:   Mon, 15 Mar 2021 18:22:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210315114027.neacovpmw3nzz77z@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/15/2021 14:59:31
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162388 [Mar 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 436 436 4977b9bfeabc3816a6da3614ba6703afbb88002c
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/15/2021 15:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.03.2021 12:51:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/15 14:36:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/15 06:48:00 #16425473
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 15.03.2021 14:40, Stefano Garzarella wrote:
> Hi Arseny,
>
> On Sun, Mar 07, 2021 at 08:57:19PM +0300, Arseny Krasnov wrote:
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
>>  virtio/vsock: SEQPACKET feature bit
>>  vhost/vsock: SEQPACKET feature bit support
>>  virtio/vsock: SEQPACKET feature bit support
>>  virtio/vsock: setup SEQPACKET ops for transport
>>  vhost/vsock: setup SEQPACKET ops for transport
>>  vsock/loopback: setup SEQPACKET ops for transport
>>  vsock_test: add SOCK_SEQPACKET tests
>>  virtio/vsock: update trace event for SEQPACKET
>>
>> drivers/vhost/vsock.c                        |  22 +-
>> include/linux/virtio_vsock.h                 |  22 +
>> include/net/af_vsock.h                       |  10 +
>> .../events/vsock_virtio_transport_common.h   |  48 +-
>> include/uapi/linux/virtio_vsock.h            |  19 +
>> net/vmw_vsock/af_vsock.c                     | 589 +++++++++++------
>> net/vmw_vsock/virtio_transport.c             |  18 +
>> net/vmw_vsock/virtio_transport_common.c      | 364 ++++++++--
>> net/vmw_vsock/vsock_loopback.c               |  13 +
>> tools/testing/vsock/util.c                   |  32 +-
>> tools/testing/vsock/util.h                   |   3 +
>> tools/testing/vsock/vsock_test.c             | 126 ++++
>> 12 files changed, 1013 insertions(+), 253 deletions(-)
>>
>> v5 -> v6:
>> General changelog:
>> - virtio transport specific callbacks which send SEQ_BEGIN or
>>   SEQ_END now hidden inside virtio transport. Only enqueue,
>>   dequeue and record length callbacks are provided by transport.
>>
>> - virtio feature bit for SEQPACKET socket support introduced:
>>   VIRTIO_VSOCK_F_SEQPACKET.
>>
>> - 'msg_cnt' field in 'struct virtio_vsock_seq_hdr' renamed to
>>   'msg_id' and used as id.
>>
>> Per patch changelog:
>> - 'af_vsock: separate wait data loop':
>>    1) Commit message updated.
>>    2) 'prepare_to_wait()' moved inside while loop(thanks to
>>      Jorgen Hansen).
>>    Marked 'Reviewed-by' with 1), but as 2) I removed R-b.
>>
>> - 'af_vsock: separate receive data loop': commit message
>>    updated.
>>    Marked 'Reviewed-by' with that fix.
>>
>> - 'af_vsock: implement SEQPACKET receive loop': style fixes.
>>
>> - 'af_vsock: rest of SEQPACKET support':
>>    1) 'module_put()' added when transport callback check failed.
>>    2) Now only 'seqpacket_allow()' callback called to check
>>       support of SEQPACKET by transport.
>>
>> - 'af_vsock: update comments for stream sockets': commit message
>>    updated.
>>    Marked 'Reviewed-by' with that fix.
>>
>> - 'virtio/vsock: set packet's type in send':
>>    1) Commit message updated.
>>    2) Parameter 'type' from 'virtio_transport_send_credit_update()'
>>       also removed in this patch instead of in next.
>>
>> - 'virtio/vsock: dequeue callback for SOCK_SEQPACKET': SEQPACKET
>>    related state wrapped to special struct.
>>
>> - 'virtio/vsock: update trace event for SEQPACKET': format strings
>>    now not broken by new lines.
> I left a bunch of comments in the patches, I hope they are easy to fix 
> :-)
Thank you, yes, there are still small fixes.
>
> Thanks for the changelogs. About 'per patch changelog', it is very 
> useful!
> Just a suggestion, I think is better to include them in each patch after 
> the '---' to simplify the review.
Ack
>
> You can use git-notes(1) or you can simply edit the format-patch and add 
> the changelog after the 3 dashes, so that they are ignored when the 
> patch is applied.
>
> Thanks,
> Stefano
>
>
