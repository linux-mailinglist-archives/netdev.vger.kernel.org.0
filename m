Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D1230A931
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhBAN6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:58:12 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:56770 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhBAN6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:58:08 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 249D552169F;
        Mon,  1 Feb 2021 16:57:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612187841;
        bh=JIQhZmGiqsZDGRJKmrSOh3/yj72rPSfycuCmzuhNXdw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=Z3EYJT30tqW9tcbOABrUW1UacH+6PtLGa7HEfQ8LMr8YmPCPOM5p+omlfcn8MmWbK
         u7gxnfMNS2L3yA71ZtWl54aTNfUsikw/ZnZnYCqfxfihJZZhvolBcqBKOaMSeohrYo
         zrXd0FC0F4GW8KCGAnhOTdlsaBROGmH42gTKghaI=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 266A15216CB;
        Mon,  1 Feb 2021 16:57:20 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 1 Feb
 2021 16:57:19 +0300
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
 <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
 <20210129092604.mgaw3ipiyv6xra3b@steredhat>
 <cb6d5a9c-fd49-a9dd-33b3-52027ae2f71c@kaspersky.com>
 <20210201110258.7ze7a7izl7gesv4w@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <1b80eb27-4818-50d7-7454-ff6cc398422e@kaspersky.com>
Date:   Mon, 1 Feb 2021 16:57:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201110258.7ze7a7izl7gesv4w@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/01/2021 13:23:40
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161565 [Feb 01 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/01/2021 13:25:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/1/2021 12:14:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/01 10:58:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/01 10:06:00 #16068838
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01.02.2021 14:02, Stefano Garzarella wrote:
> On Fri, Jan 29, 2021 at 06:52:23PM +0300, Arseny Krasnov wrote:
>> On 29.01.2021 12:26, Stefano Garzarella wrote:
>>> On Fri, Jan 29, 2021 at 09:41:50AM +0300, Arseny Krasnov wrote:
>>>> On 28.01.2021 20:19, Stefano Garzarella wrote:
>>>>> Hi Arseny,
>>>>> I reviewed a part, tomorrow I hope to finish the other patches.
>>>>>
>>>>> Just a couple of comments in the TODOs below.
>>>>>
>>>>> On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>>> transport.
>>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>>> do it, new packet operation was added: it marks start of record (with
>>>>>> record length in header), such packet doesn't carry any data.  To send
>>>>>> record, packet with start marker is sent first, then all data is sent
>>>>>> as usual 'RW' packets. On receiver's side, length of record is known
>>>>> >from packet with start record marker. Now as  packets of one socket
>>>>>> are not reordered neither on vsock nor on vhost transport layers, such
>>>>>> marker allows to restore original record on receiver's side. If user's
>>>>>> buffer is smaller that record length, when all out of size data is
>>>>>> dropped.
>>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>>> because same credit logic is used. Difference with stream socket is
>>>>>> that user is not woken up until whole record is received or error
>>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>>> 	Tests also implemented.
>>>>>>
>>>>>> Arseny Krasnov (13):
>>>>>>  af_vsock: prepare for SOCK_SEQPACKET support
>>>>>>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>>>>>>  af_vsock: implement SEQPACKET rx loop
>>>>>>  af_vsock: implement send logic for SOCK_SEQPACKET
>>>>>>  af_vsock: rest of SEQPACKET support
>>>>>>  af_vsock: update comments for stream sockets
>>>>>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>>>  virtio/vsock: fetch length for SEQPACKET record
>>>>>>  virtio/vsock: add SEQPACKET receive logic
>>>>>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>>>>>  virtio/vsock: setup SEQPACKET ops for transport
>>>>>>  vhost/vsock: setup SEQPACKET ops for transport
>>>>>>  vsock_test: add SOCK_SEQPACKET tests
>>>>>>
>>>>>> drivers/vhost/vsock.c                   |   7 +-
>>>>>> include/linux/virtio_vsock.h            |  12 +
>>>>>> include/net/af_vsock.h                  |   6 +
>>>>>> include/uapi/linux/virtio_vsock.h       |   9 +
>>>>>> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
>>>>>> net/vmw_vsock/virtio_transport.c        |   4 +
>>>>>> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
>>>>>> tools/testing/vsock/util.c              |  32 +-
>>>>>> tools/testing/vsock/util.h              |   3 +
>>>>>> tools/testing/vsock/vsock_test.c        | 126 +++++
>>>>>> 10 files changed, 862 insertions(+), 175 deletions(-)
>>>>>>
>>>>>> TODO:
>>>>>> - Support for record integrity control. As transport could drop some
>>>>>>   packets, something like "record-id" and record end marker need to
>>>>>>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>>>>>>   length and record id, end marker(let it be SEQ_END) carries only
>>>>>>   record id. To be sure that no one packet was lost, receiver checks
>>>>>>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>>>>>>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>>>>>>   means that both markers were not dropped. I think that easiest way
>>>>>>   to implement record id for SEQ_BEGIN is to reuse another field of
>>>>>>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>>>>>>   SEQ_END record id could be stored in 'flags'.
>>>>> I don't really like the idea of reusing the 'flags' field for this
>>>>> purpose.
>>>>>
>>>>>>     Another way to implement it, is to move metadata of both SEQ_END
>>>>>>   and SEQ_BEGIN to payload. But this approach has problem, because
>>>>>>   if we move something to payload, such payload is accounted by
>>>>>>   credit logic, which fragments payload, while payload with record
>>>>>>   length and id couldn't be fragmented. One way to overcome it is to
>>>>>>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>>>>>>   is to update 'stream_has_space()' function: current implementation
>>>>>>   return non-zero when at least 1 byte is allowed to use,but updated
>>>>>>   version will have extra argument, which is needed length. For 'RW'
>>>>>>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>>>>>>   record id) and for SEQ_END it is sizeof(record id).
>>>>> Is the payload accounted by credit logic also if hdr.op is not
>>>>> VIRTIO_VSOCK_OP_RW?
>>>> Yes, on send any packet with payload could be fragmented if
>>>>
>>>> there is not enough space at receiver. On receive 'fwd_cnt' and
>>>>
>>>> 'buf_alloc' are updated with header of every packet. Of course,
>>>>
>>>> to every such case i've described i can add check for 'RW'
>>>>
>>>> packet, to exclude payload from credit accounting, but this is
>>>>
>>>> bunch of dumb checks.
>>>>
>>>>> I think that we can define a specific header to put after the
>>>>> virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header
>>>>> we can store the id and the length of the message.
>>>> I think it is better than use payload and touch credit logic
>>>>
>>> Cool, so let's try this option, hoping there aren't a lot of issues.
>> If i understand, current implementation has 'struct virtio_vsock_hdr',
>>
>> then i'll add 'struct virtio_vsock_hdr_seq' with message length and id.
>>
>> After that, in 'struct virtio_vsock_pkt' which describes packet, field for
>>
>> header(which is 'struct virtio_vsock_hdr') must be replaced with new
>>
>> structure which  contains both 'struct virtio_vsock_hdr' and 'struct
>>
>> virtio_vsock_hdr_seq', because header field of 'struct virtio_vsock_pkt'
>>
>> is buffer for virtio layer. After it all accesses to header(for example to
>>
>> 'buf_alloc' field will go accross new  structure with both headers:
>>
>> pkt->hdr.buf_alloc   ->   pkt->extended_hdr.classic_hdr.buf_alloc
>>
>> May be to avoid this, packet's header could be allocated dynamically
>>
>> in the same manner as packet's buffer? Size of allocation is always
>>
>> sizeof(classic header) + sizeof(seq header). In 'struct virtio_vsock_pkt'
>>
>> such header will be implemented as union of two pointers: class header
>>
>> and extended header containing classic and seq header. Which pointer
>>
>> to use is depends on packet's op.
> I think that the 'classic header' can stay as is, and the extended 
> header can be dynamically allocated, as we do for the payload.
>
> But we have to be careful what happens if the other peer doesn't support 
> SEQPACKET and if it counts this extra header as a payload for the credit 
> mechanism.

You mean put extra header to payload(buffer of second virtio desc),

in this way on send/receive auxiliary 'if's are needed to avoid credit

logic(or set length field in header of such packets to 0). But what

about placing extra header after classic header in buffer of first virtio

desc? In this case extra header is not payload and credit works as is.

Or it is critical, that size of first buffer will be not same as size of

classic header?

>
> I'll try to take a closer look in the next few days.
>
> Thanks,
> Stefano
>
>
