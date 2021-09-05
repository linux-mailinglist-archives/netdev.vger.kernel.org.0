Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128E84010D9
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhIEQWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 12:22:37 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:32318 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbhIEQWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 12:22:36 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 3D7AA521517;
        Sun,  5 Sep 2021 19:21:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630858891;
        bh=QDVEyPY1LYpmyVN8hCYnnXkrylTBmGyfkM5TrhV8LUI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=dJkfefhi7Sz0t2m3jAZFzc3VGbloVwAnPuKpqaE9NmGZ6HeNf3zGm+hpBKr/iJabY
         zlVA+I3L1Hkz9BRy2Gk4woTjepPMjzLFq0CbFd8t9t9E251jj3lgVcYSzmBFOzQcv1
         BS85Gy4W16OWJRCqR2yfsAJZRXyQTBmnMk94ZUP3bQmF6uYZdHv3U9wpcAbyeLyjNF
         6EFyHap2IwsQ4RPE4CtPhPTP+iyr6Kj9/98hFos7RnloDf606WfIUdZikwsLpo+KoX
         S06qJd058cds+JA54//pSXIGQKDu9JnSld7hPicmk6UcnjuB5kQQvjBeTSLMaB7bdc
         pkL7i38FaLj8Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 8817652154A;
        Sun,  5 Sep 2021 19:21:30 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Sun, 5
 Sep 2021 19:21:10 +0300
Subject: Re: [PATCH net-next v5 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
 <20210905115139-mutt-send-email-mst@kernel.org>
 <4558e96b-6330-667f-955b-b689986f884f@kaspersky.com>
 <20210905121932-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <5b20410a-fb8f-2e38-59d9-74dc6b8a9d4f@kaspersky.com>
Date:   Sun, 5 Sep 2021 19:21:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210905121932-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/05/2021 16:03:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165972 [Sep 05 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;lkml.org:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/05/2021 16:08:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 05.09.2021 14:20:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/09/05 15:01:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/09/05 13:26:00 #17165381
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.09.2021 19:19, Michael S. Tsirkin wrote:
> On Sun, Sep 05, 2021 at 07:02:44PM +0300, Arseny Krasnov wrote:
>> On 05.09.2021 18:55, Michael S. Tsirkin wrote:
>>> On Fri, Sep 03, 2021 at 03:30:13PM +0300, Arseny Krasnov wrote:
>>>> 	This patchset implements support of MSG_EOR bit for SEQPACKET
>>>> AF_VSOCK sockets over virtio transport.
>>>> 	First we need to define 'messages' and 'records' like this:
>>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>>> etc. It has fixed maximum length, and it bounds are visible using
>>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>>> Current implementation based on message definition above.
>>>> 	Record has unlimited length, it consists of multiple message,
>>>> and bounds of record are visible via MSG_EOR flag returned from
>>>> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>>>> receiver will see MSG_EOR when corresponding message will be processed.
>>>> 	Idea of patchset comes from POSIX: it says that SEQPACKET
>>>> supports record boundaries which are visible for receiver using
>>>> MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
>>>> and we don't need to maintain boundaries of corresponding send -
>>>> receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
>>>> that all these calls operates with messages, e.g. 'sendXXX()' sends
>>>> message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
>>>> must read one entire message from socket, dropping all out of size
>>>> bytes. Thus, both message boundaries and MSG_EOR bit must be supported
>>>> to follow POSIX rules.
>>>> 	To support MSG_EOR new bit was added along with existing
>>>> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>>>> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>>>> is used to mark 'MSG_EOR' bit passed from userspace.
>>>> 	This patchset includes simple test for MSG_EOR.
>>> I'm prepared to merge this for this window,
>>> but I'm not sure who's supposed to ack the net/vmw_vsock/af_vsock.c
>>> bits. It's a harmless variable renaming so maybe it does not matter.
>>>
>>> The rest is virtio stuff so I guess my tree is ok.
>>>
>>> Objections, anyone?
>> https://lkml.org/lkml/2021/9/3/76 this is v4. It is same as v5 in af_vsock.c changes.
>>
>> It has Reviewed by from Stefano Garzarella.
> Is Stefano the maintainer for af_vsock then?
> I wasn't sure.
Ack, let's wait for maintainer's comment
>
>>>
>>>>  Arseny Krasnov(6):
>>>>   virtio/vsock: rename 'EOR' to 'EOM' bit.
>>>>   virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
>>>>   vhost/vsock: support MSG_EOR bit processing
>>>>   virtio/vsock: support MSG_EOR bit processing
>>>>   af_vsock: rename variables in receive loop
>>>>   vsock_test: update message bounds test for MSG_EOR
>>>>
>>>>  drivers/vhost/vsock.c                   | 28 +++++++++++++----------
>>>>  include/uapi/linux/virtio_vsock.h       |  3 ++-
>>>>  net/vmw_vsock/af_vsock.c                | 10 ++++----
>>>>  net/vmw_vsock/virtio_transport_common.c | 23 ++++++++++++-------
>>>>  tools/testing/vsock/vsock_test.c        |  8 ++++++-
>>>>  5 files changed, 45 insertions(+), 27 deletions(-)
>>>>
>>>>  v4 -> v5:
>>>>  - Move bitwise and out of le32_to_cpu() in 0003.
>>>>
>>>>  v3 -> v4:
>>>>  - 'sendXXX()' renamed to 'send*()' in 0002- commit msg.
>>>>  - Comment about bit restore updated in 0003-.
>>>>  - 'same' renamed to 'similar' in 0003- commit msg.
>>>>  - u32 used instead of uint32_t in 0003-.
>>>>
>>>>  v2 -> v3:
>>>>  - 'virtio/vsock: rename 'EOR' to 'EOM' bit.' - commit message updated.
>>>>  - 'VIRTIO_VSOCK_SEQ_EOR' bit add moved to separate patch.
>>>>  - 'vhost/vsock: support MSG_EOR bit processing' - commit message
>>>>    updated.
>>>>  - 'vhost/vsock: support MSG_EOR bit processing' - removed unneeded
>>>>    'le32_to_cpu()', because input argument was already in CPU
>>>>    endianness.
>>>>
>>>>  v1 -> v2:
>>>>  - 'VIRTIO_VSOCK_SEQ_EOR' is renamed to 'VIRTIO_VSOCK_SEQ_EOM', to
>>>>    support backward compatibility.
>>>>  - use bitmask of flags to restore in vhost.c, instead of separated
>>>>    bool variable for each flag.
>>>>  - test for EAGAIN removed, as logically it is not part of this
>>>>    patchset(will be sent separately).
>>>>  - cover letter updated(added part with POSIX description).
>>>>
>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>> -- 
>>>> 2.25.1
>
