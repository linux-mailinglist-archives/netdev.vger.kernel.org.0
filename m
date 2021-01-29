Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE13085F9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhA2Gmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:42:45 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44162 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhA2Gml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:42:41 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id B548B521A8F;
        Fri, 29 Jan 2021 09:41:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611902514;
        bh=+IG0V9Y8o9BcqXTY5Yf/8fDBfu3dY09Y0gxQgcF03/A=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=ocmf7x8j1CgAxYS8RQRmtKdw1R7pRm4c50GTTykUL1eD5VGVJvfzr4kwORfbwaHNh
         lhG5o7u4nbm+9lnKxfDdN9JHuUPdyCzSybRQDzFcKwoTLmeiRU/gXgTF9GneUeBGD/
         lOt1TAgLYS3l5jkI2M1QI0nDSTpn+4EcchEz19KU=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id C5ECB521A7A;
        Fri, 29 Jan 2021 09:41:53 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 29
 Jan 2021 09:41:52 +0300
Subject: Re: [RFC PATCH v3 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210128171923.esyna5ccv5s27jyu@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
Date:   Fri, 29 Jan 2021 09:41:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128171923.esyna5ccv5s27jyu@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/29/2021 06:23:39
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161515 [Jan 29 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/29/2021 06:26:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/29/2021 4:21:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/29 05:17:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/29 02:21:00 #16053718
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28.01.2021 20:19, Stefano Garzarella wrote:
> Hi Arseny,
> I reviewed a part, tomorrow I hope to finish the other patches.
>
> Just a couple of comments in the TODOs below.
>
> On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>> transport.
>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>> do it, new packet operation was added: it marks start of record (with
>> record length in header), such packet doesn't carry any data.  To send
>> record, packet with start marker is sent first, then all data is sent
>> as usual 'RW' packets. On receiver's side, length of record is known
> >from packet with start record marker. Now as  packets of one socket
>> are not reordered neither on vsock nor on vhost transport layers, such
>> marker allows to restore original record on receiver's side. If user's
>> buffer is smaller that record length, when all out of size data is
>> dropped.
>> 	Maximum length of datagram is not limited as in stream socket,
>> because same credit logic is used. Difference with stream socket is
>> that user is not woken up until whole record is received or error
>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>> 	Tests also implemented.
>>
>> Arseny Krasnov (13):
>>  af_vsock: prepare for SOCK_SEQPACKET support
>>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>>  af_vsock: implement SEQPACKET rx loop
>>  af_vsock: implement send logic for SOCK_SEQPACKET
>>  af_vsock: rest of SEQPACKET support
>>  af_vsock: update comments for stream sockets
>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>  virtio/vsock: fetch length for SEQPACKET record
>>  virtio/vsock: add SEQPACKET receive logic
>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>  virtio/vsock: setup SEQPACKET ops for transport
>>  vhost/vsock: setup SEQPACKET ops for transport
>>  vsock_test: add SOCK_SEQPACKET tests
>>
>> drivers/vhost/vsock.c                   |   7 +-
>> include/linux/virtio_vsock.h            |  12 +
>> include/net/af_vsock.h                  |   6 +
>> include/uapi/linux/virtio_vsock.h       |   9 +
>> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
>> net/vmw_vsock/virtio_transport.c        |   4 +
>> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
>> tools/testing/vsock/util.c              |  32 +-
>> tools/testing/vsock/util.h              |   3 +
>> tools/testing/vsock/vsock_test.c        | 126 +++++
>> 10 files changed, 862 insertions(+), 175 deletions(-)
>>
>> TODO:
>> - Support for record integrity control. As transport could drop some
>>   packets, something like "record-id" and record end marker need to
>>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>>   length and record id, end marker(let it be SEQ_END) carries only
>>   record id. To be sure that no one packet was lost, receiver checks
>>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>>   means that both markers were not dropped. I think that easiest way
>>   to implement record id for SEQ_BEGIN is to reuse another field of
>>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>>   SEQ_END record id could be stored in 'flags'.
> I don't really like the idea of reusing the 'flags' field for this 
> purpose.
>
>>     Another way to implement it, is to move metadata of both SEQ_END
>>   and SEQ_BEGIN to payload. But this approach has problem, because
>>   if we move something to payload, such payload is accounted by
>>   credit logic, which fragments payload, while payload with record
>>   length and id couldn't be fragmented. One way to overcome it is to
>>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>>   is to update 'stream_has_space()' function: current implementation
>>   return non-zero when at least 1 byte is allowed to use,but updated
>>   version will have extra argument, which is needed length. For 'RW'
>>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>>   record id) and for SEQ_END it is sizeof(record id).
> Is the payload accounted by credit logic also if hdr.op is not 
> VIRTIO_VSOCK_OP_RW?

Yes, on send any packet with payload could be fragmented if

there is not enough space at receiver. On receive 'fwd_cnt' and

'buf_alloc' are updated with header of every packet. Of course,

to every such case i've described i can add check for 'RW'

packet, to exclude payload from credit accounting, but this is

bunch of dumb checks.

>
> I think that we can define a specific header to put after the 
> virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header 
> we can store the id and the length of the message.

I think it is better than use payload and touch credit logic

>
>> - What to do, when server doesn't support SOCK_SEQPACKET. In current
>>   implementation RST is replied in the same way when listening port
>>   is not found. I think that current RST is enough,because case when
>>   server doesn't support SEQ_PACKET is same when listener missed(e.g.
>>   no listener in both cases).
> I think so, but I'll check better if we can have some issues.
>
> Thanks,
> Stefano
>
>> v2 -> v3:
>> - patches reorganized: split for prepare and implementation patches
>> - local variables are declared in "Reverse Christmas tree" manner
>> - virtio_transport_common.c: valid leXX_to_cpu() for vsock header
>>   fields access
>> - af_vsock.c: 'vsock_connectible_*sockopt()' added as shared code
>>   between stream and seqpacket sockets.
>> - af_vsock.c: loops in '__vsock_*_recvmsg()' refactored.
>> - af_vsock.c: 'vsock_wait_data()' refactored.
>>
>> v1 -> v2:
>> - patches reordered: af_vsock.c related changes now before virtio vsock
>> - patches reorganized: more small patches, where +/- are not mixed
>> - tests for SOCK_SEQPACKET added
>> - all commit messages updated
>> - af_vsock.c: 'vsock_pre_recv_check()' inlined to
>>   'vsock_connectible_recvmsg()'
>> - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
>>   was not found
>> - virtio_transport_common.c: transport callback for seqpacket dequeue
>> - virtio_transport_common.c: simplified
>>   'virtio_transport_recv_connected()'
>> - virtio_transport_common.c: send reset on socket and packet type
>> 			      mismatch.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>
>> -- 
>> 2.25.1
>>
>
