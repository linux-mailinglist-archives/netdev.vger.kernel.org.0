Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6684D3E105D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbhHEIda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:33:30 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:12214 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbhHEIda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:33:30 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 62812520D38;
        Thu,  5 Aug 2021 11:33:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628152394;
        bh=k0pgS1kHGbla5ruFilbtneTZqlGPAFUQro8mBMppHLE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=5Jl3ZrfuwildCQlS79Y/Bsx4GwA0unWegjmiYNWjJfy9cAlWIrr9DVHnSfBw1Kmll
         eoNTRZx32yLUaWTVt+deAI49RrEwgmARzr9LoZk5kCMIbcDHVHhTaxWI/UvMyge/OF
         5FJPv/NQiJu6reifjT01DD41avbz5BVC2PyYjWqNc3rFHVGgfTswYKku/lw708c8HI
         u2wzWbwX/hCVUJgyxncXOhTIVkX9QktJDwbJeEFSL0Md2Zrk/1ruFp2JQ1kXzTUFF9
         9hd0VaisTaFRrOaecPbOZKczRe/Resn6n/8f6IvNuDaPR2dSodcCy7iUuHgxtrco4C
         IlmDdKiBcNWaQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 9DC01520D3A;
        Thu,  5 Aug 2021 11:33:13 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 5
 Aug 2021 11:33:13 +0300
Subject: Re: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210804125737.kbgc6mg2v5lw25wu@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
Date:   Thu, 5 Aug 2021 11:33:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804125737.kbgc6mg2v5lw25wu@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/05/2021 08:19:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165422 [Aug 04 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/05/2021 08:22:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.08.2021 22:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/04 17:04:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/04 22:55:00 #16982736
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04.08.2021 15:57, Stefano Garzarella wrote:
> Caution: This is an external email. Be cautious while opening links or attachments.
>
>
>
> Hi Arseny,
>
> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>> AF_VSOCK sockets over virtio transport.
>>       Idea is to distinguish concepts of 'messages' and 'records'.
>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>> etc. It has fixed maximum length, and it bounds are visible using
>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>> Current implementation based on message definition above.
> Okay, so the implementation we merged is wrong right?
> Should we disable the feature bit in stable kernels that contain it? Or
> maybe we can backport the fixes...

Hi,

No, this is correct and it is message boundary based. Idea of this

patchset is to add extra boundaries marker which i think could be

useful when we want to send data in seqpacket mode which length

is bigger than maximum message length(this is limited by transport).

Of course we can fragment big piece of data too small messages, but this

requires to carry fragmentation info in data protocol. So In this case

when we want to maintain boundaries receiver calls recvmsg() until MSG_EOR found.

But when receiver knows, that data is fit in maximum datagram length,

it doesn't care about checking MSG_EOR just calling recv() or read()(e.g.

message based mode).


Thank You

>
>>       Record has unlimited length, it consists of multiple message,
>> and bounds of record are visible via MSG_EOR flag returned from
>> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>> receiver will see MSG_EOR when corresponding message will be processed.
>>       To support MSG_EOR new bit was added along with existing
>> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>> is used to mark 'MSG_EOR' bit passed from userspace.
> I understand that it makes sense to remap VIRTIO_VSOCK_SEQ_EOR to
> MSG_EOR to make the user understand the boundaries, but why do we need
> EOM as well?
>
> Why do we care about the boundaries of a message within a record?
> I mean, if the sender makes 3 calls:
>      send(A1,0)
>      send(A2,0)
>      send(A3, MSG_EOR);
>
> IIUC it should be fine if the receiver for example receives all in one
> single recv() calll with MSG_EOR set, so why do we need EOM?
>
> Thanks,
> Stefano
>
>
