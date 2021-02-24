Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F0A3238CE
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhBXIhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:37:45 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:45672 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhBXIhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:37:12 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id BC4F1521320;
        Wed, 24 Feb 2021 11:36:15 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614155775;
        bh=92YEeYk2M/SQMzHOI89FZGf8Gn2PDRHqkk0JTMPF8KI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=7UMKmygtSLxZCLITtXS96tgVzQzpnrmn6lTTgee6LBpaNybh5TiiH1VF8C852BgQq
         G4lS/i/yumO/8VvDeRtHF+etlJEvE1Yn0sofKfoI63W4khZhOVCHAi1yyM2DYfAi6M
         bnqXeSLZR9S863FOoOV0edjw3fOwlDLfqKDswwS6dgSTksQLXD9q8i7bLIXo0hxjZk
         TCDA/WcmaJjsqjXneVu7zL8LBdh81kMq9Ox1oHfwFqtZeztlrD2YU9c6zzwgA9nuxQ
         yVLGXuYOnqixK+d171eYNrJtHVfjRSKi8xormoXS32Cmi/tL0C2XujZJXJ57zo/JzU
         lMV46jARGJjsQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 5B20C521319;
        Wed, 24 Feb 2021 11:36:15 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Wed, 24
 Feb 2021 11:36:14 +0300
Subject: Re: [RFC PATCH v5 00/19] virtio/vsock: introduce SOCK_SEQPACKET
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
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210222142311.gekdd7gsm33wglos@steredhat>
 <20210223145016.ddavx6fihq4akdim@steredhat>
 <7a280168-cb54-ae26-4697-c797f6b04708@kaspersky.com>
 <20210224082319.yrmqr6zs7emvghw3@steredhat>
 <710d9dc2-3a0c-ea0b-fb02-68b460e6282e@kaspersky.com>
 <20210224083516.kkxlkoin632iaqik@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <d5fbeb19-d949-9720-a306-6cb9cc5289a7@kaspersky.com>
Date:   Wed, 24 Feb 2021 11:36:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224083516.kkxlkoin632iaqik@steredhat>
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
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/24 06:25:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/24 06:02:00 #16329712
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24.02.2021 11:35, Stefano Garzarella wrote:
> On Wed, Feb 24, 2021 at 11:28:50AM +0300, Arseny Krasnov wrote:
>> On 24.02.2021 11:23, Stefano Garzarella wrote:
>>> On Wed, Feb 24, 2021 at 07:29:25AM +0300, Arseny Krasnov wrote:
>>>> On 23.02.2021 17:50, Stefano Garzarella wrote:
>>>>> On Mon, Feb 22, 2021 at 03:23:11PM +0100, Stefano Garzarella wrote:
>>>>>> Hi Arseny,
>>>>>>
>>>>>> On Thu, Feb 18, 2021 at 08:33:44AM +0300, Arseny Krasnov wrote:
>>>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>>>> transport.
>>>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>>>> do it, two new packet operations were added: first for start of record
>>>>>>> and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>>>>>> both operations carries metadata - to maintain boundaries and payload
>>>>>>> integrity. Metadata is introduced by adding special header with two
>>>>>>> fields - message count and message length:
>>>>>>>
>>>>>>> 	struct virtio_vsock_seq_hdr {
>>>>>>> 		__le32  msg_cnt;
>>>>>>> 		__le32  msg_len;
>>>>>>> 	} __attribute__((packed));
>>>>>>>
>>>>>>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>>>>>> packets(buffer of second virtio descriptor in chain) in the same way as
>>>>>>> data transmitted in RW packets. Payload was chosen as buffer for this
>>>>>>> header to avoid touching first virtio buffer which carries header of
>>>>>>> packet, because someone could check that size of this buffer is equal
>>>>>>> to size of packet header. To send record, packet with start marker is
>>>>>>> sent first(it's header contains length of record and counter), then
>>>>>>> counter is incremented and all data is sent as usual 'RW' packets and
>>>>>>> finally SEQ_END is sent(it also carries counter of message, which is
>>>>>>> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>>>>>> incremented again. On receiver's side, length of record is known from
>>>>>>> packet with start record marker. To check that no packets were dropped
>>>>>>> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>>>>>> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>>>>>> 1) and length of data between two markers is compared to length in
>>>>>>> SEQ_BEGIN header.
>>>>>>> 	Now as  packets of one socket are not reordered neither on
>>>>>>> vsock nor on vhost transport layers, such markers allows to restore
>>>>>>> original record on receiver's side. If user's buffer is smaller that
>>>>>>> record length, when all out of size data is dropped.
>>>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>>>> because same credit logic is used. Difference with stream socket is
>>>>>>> that user is not woken up until whole record is received or error
>>>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>>>> 	Tests also implemented.
>>>>>> I reviewed the first part (af_vsock.c changes), tomorrow I'll review
>>>>>> the rest. That part looks great to me, only found a few minor issues.
>>>>> I revieiwed the rest of it as well, left a few minor comments, but I
>>>>> think we're well on track.
>>>>>
>>>>> I'll take a better look at the specification patch tomorrow.
>>>> Great, Thank You
>>>>> Thanks,
>>>>> Stefano
>>>>>
>>>>>> In the meantime, however, I'm getting a doubt, especially with regard
>>>>>> to other transports besides virtio.
>>>>>>
>>>>>> Should we hide the begin/end marker sending in the transport?
>>>>>>
>>>>>> I mean, should the transport just provide a seqpacket_enqueue()
>>>>>> callbacl?
>>>>>> Inside it then the transport will send the markers. This is because
>>>>>> some transports might not need to send markers.
>>>>>>
>>>>>> But thinking about it more, they could actually implement stubs for
>>>>>> that calls, if they don't need to send markers.
>>>>>>
>>>>>> So I think for now it's fine since it allows us to reuse a lot of
>>>>>> code, unless someone has some objection.
>>>> I thought about that, I'll try to implement it in next version. Let's see...
>>> If you want to discuss it first, write down the idea you want to
>>> implement, I wouldn't want to make you do unnecessary work. :-)
>> Idea is simple, in iov iterator of 'struct msghdr' which is passed to
>>
>> enqueue callback we have two fields: 'iov_offset' which is byte
>>
>> offset inside io vector where next data must be picked and 'count'
>>
>> which is rest of unprocessed bytes in io vector. So in seqpacket
>>
>> enqueue callback if 'iov_offset' is 0 i'll send SEQBEGIN, and if
>>
>> 'count' is 0 i'll send SEQEND.
>>
> Got it, make sense and it's defently more transparent for the vsock 
> core!
> Go head, maybe adding a comment in the vsock core explaining this, so 
> other developers can understand better if they want to support SEPACKET 
> in other transports.
Ack
>
> Thanks,
> Stefano
>
>
