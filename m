Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D3A312AC7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBHGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:35:22 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:61690 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBHGd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:33:59 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 770CB521864;
        Mon,  8 Feb 2021 09:33:01 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612765981;
        bh=vGJIKcvNyCAWGkZdfQTcfoRfLevMPBJXafQ3HZHSHRk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=kyoKePY09dLwBk0VkkPtybBspjMtAv2qTGxR56s2dt/wQ4Fa8KOLtma844QTFNVS6
         H4Nl2XyduoHNP4pkxx5cJH0UKc9dYKczXCnzcShNtXl8/ypS2x9o1SAjbcRPDNJ4HW
         kYGrPI42AwgzCr8KaAJvpGqIww7AiH4qIUFN070Y=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6E43C521863;
        Mon,  8 Feb 2021 09:33:00 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 8 Feb
 2021 09:32:59 +0300
Subject: Re: [RFC PATCH v4 00/17] virtio/vsock: introduce SOCK_SEQPACKET
 support
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207111954-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <8bd3789c-8df1-4383-f233-b4b854b30970@kaspersky.com>
Date:   Mon, 8 Feb 2021 09:32:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210207111954-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2021 9:17:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/08 00:52:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/08 00:27:00 #16141106
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07.02.2021 19:20, Michael S. Tsirkin wrote:
> On Sun, Feb 07, 2021 at 06:12:56PM +0300, Arseny Krasnov wrote:
>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>> transport.
>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>> do it, two new packet operations were added: first for start of record
>>  and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>> both operations carries metadata - to maintain boundaries and payload
>> integrity. Metadata is introduced by adding special header with two
>> fields - message count and message length:
>>
>> 	struct virtio_vsock_seq_hdr {
>> 		__le32  msg_cnt;
>> 		__le32  msg_len;
>> 	} __attribute__((packed));
>>
>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>> packets(buffer of second virtio descriptor in chain) in the same way as
>> data transmitted in RW packets. Payload was chosen as buffer for this
>> header to avoid touching first virtio buffer which carries header of
>> packet, because someone could check that size of this buffer is equal
>> to size of packet header. To send record, packet with start marker is
>> sent first(it's header contains length of record and counter), then
>> counter is incremented and all data is sent as usual 'RW' packets and
>> finally SEQ_END is sent(it also carries counter of message, which is
>> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>> incremented again. On receiver's side, length of record is known from
>> packet with start record marker. To check that no packets were dropped
>> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>> 1) and length of data between two markers is compared to length in
>> SEQ_BEGIN header.
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
>>  Arseny Krasnov (17):
>>   af_vsock: update functions for connectible socket
>>   af_vsock: separate wait data loop
>>   af_vsock: separate receive data loop
>>   af_vsock: implement SEQPACKET receive loop
>>   af_vsock: separate wait space loop
>>   af_vsock: implement send logic for SEQPACKET
>>   af_vsock: rest of SEQPACKET support
>>   af_vsock: update comments for stream sockets
>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>   virtio/vsock: fetch length for SEQPACKET record
>>   virtio/vsock: add SEQPACKET receive logic
>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>   virtio/vsock: setup SEQPACKET ops for transport
>>   vhost/vsock: setup SEQPACKET ops for transport
>>   vsock_test: add SOCK_SEQPACKET tests
>>   loopback/vsock: setup SEQPACKET ops for transport
>>   virtio/vsock: simplify credit update function API
>>
>>  drivers/vhost/vsock.c                   |   8 +-
>>  include/linux/virtio_vsock.h            |  15 +
>>  include/net/af_vsock.h                  |   9 +
>>  include/uapi/linux/virtio_vsock.h       |  16 +
>>  net/vmw_vsock/af_vsock.c                | 588 +++++++++++++++-------
>>  net/vmw_vsock/virtio_transport.c        |   5 +
>>  net/vmw_vsock/virtio_transport_common.c | 316 ++++++++++--
>>  net/vmw_vsock/vsock_loopback.c          |   5 +
>>  tools/testing/vsock/util.c              |  32 +-
>>  tools/testing/vsock/util.h              |   3 +
>>  tools/testing/vsock/vsock_test.c        | 126 +++++
>>  11 files changed, 895 insertions(+), 228 deletions(-)
>>
>>  TODO:
>>  - What to do, when server doesn't support SOCK_SEQPACKET. In current
>>    implementation RST is replied in the same way when listening port
>>    is not found. I think that current RST is enough,because case when
>>    server doesn't support SEQ_PACKET is same when listener missed(e.g.
>>    no listener in both cases).
>    - virtio spec patch
Ok
>
>>  v3 -> v4:
>>  - callbacks for loopback transport
>>  - SEQPACKET specific metadata moved from packet header to payload
>>    and called 'virtio_vsock_seq_hdr'
>>  - record integrity check:
>>    1) SEQ_END operation was added, which marks end of record.
>>    2) Both SEQ_BEGIN and SEQ_END carries counter which is incremented
>>       on every marker send.
>>  - af_vsock.c: socket operations for STREAM and SEQPACKET call same
>>    functions instead of having own "gates" differs only by names:
>>    'vsock_seqpacket/stream_getsockopt()' now replaced with
>>    'vsock_connectible_getsockopt()'.
>>  - af_vsock.c: 'seqpacket_dequeue' callback returns error and flag that
>>    record ready. There is no need to return number of copied bytes,
>>    because case when record received successfully is checked at virtio
>>    transport layer, when SEQ_END is processed. Also user doesn't need
>>    number of copied bytes, because 'recv()' from SEQPACKET could return
>>    error, length of users's buffer or length of whole record(both are
>>    known in af_vsock.c).
>>  - af_vsock.c: both wait loops in af_vsock.c(for data and space) moved
>>    to separate functions because now both called from several places.
>>  - af_vsock.c: 'vsock_assign_transport()' checks that 'new_transport'
>>    pointer is not NULL and returns 'ESOCKTNOSUPPORT' instead of 'ENODEV'
>>    if failed to use transport.
>>  - tools/testing/vsock/vsock_test.c: rename tests
>>
>>  v2 -> v3:
>>  - patches reorganized: split for prepare and implementation patches
>>  - local variables are declared in "Reverse Christmas tree" manner
>>  - virtio_transport_common.c: valid leXX_to_cpu() for vsock header
>>    fields access
>>  - af_vsock.c: 'vsock_connectible_*sockopt()' added as shared code
>>    between stream and seqpacket sockets.
>>  - af_vsock.c: loops in '__vsock_*_recvmsg()' refactored.
>>  - af_vsock.c: 'vsock_wait_data()' refactored.
>>
>>  v1 -> v2:
>>  - patches reordered: af_vsock.c related changes now before virtio vsock
>>  - patches reorganized: more small patches, where +/- are not mixed
>>  - tests for SOCK_SEQPACKET added
>>  - all commit messages updated
>>  - af_vsock.c: 'vsock_pre_recv_check()' inlined to
>>    'vsock_connectible_recvmsg()'
>>  - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
>>    was not found
>>  - virtio_transport_common.c: transport callback for seqpacket dequeue
>>  - virtio_transport_common.c: simplified
>>    'virtio_transport_recv_connected()'
>>  - virtio_transport_common.c: send reset on socket and packet type
>> 			      mismatch.
>>
>> -- 
>> 2.25.1
>
