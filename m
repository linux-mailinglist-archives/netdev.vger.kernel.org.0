Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22ED4010A7
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbhIEPxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:53:19 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:57428 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhIEPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:53:15 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id CBFB676121;
        Sun,  5 Sep 2021 18:52:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630857130;
        bh=eldlQrYSQIiQ25t4xUDWL1mvwS06bjtE6FUDNQ2h9X4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=3i9ywYIlX8eaxSkCAFr6Pdgs3ID4tVstxnUtmk45boK2FswRfV2MDXrssQa0cWZ5h
         MpHmyk/UU6ICgpxmnkt2iyhBh6TEV/AiPLC1IGn2h38PwoTArJRmT3niruXFnQJveR
         oBJfjLUqC89duNXjmKeFe3eNTC9iApU7Cjp5I230SI3XASX4YE8vFu7XSTa2WBvI+e
         cBUvvLfPrD9NnUiBVTZ91eFS1fsYyWH9MuJisQhOVKxXavjLdiyAmgozz3VU5oXbwC
         HjDTiHP2OX1Dz6EZMOeUWcnDjI2zLqvAF0RM1F5njbXWOsBRs53iWyRrJHr6pkZLdb
         2cd4U882jDtig==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id E2517760D1;
        Sun,  5 Sep 2021 18:52:09 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Sun, 5
 Sep 2021 18:52:09 +0300
Subject: Re: [PATCH net-next v4 2/6] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR'
 bit.
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
 <20210903061523.3187714-1-arseny.krasnov@kaspersky.com>
 <20210905115002-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <14e42fc4-3b78-6865-80bf-e19adfa4c506@kaspersky.com>
Date:   Sun, 5 Sep 2021 18:52:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210905115002-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/05/2021 15:39:47
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165972 [Sep 05 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: lists.oasis-open.org:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/05/2021 15:42:00
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


On 05.09.2021 18:50, Michael S. Tsirkin wrote:
> On Fri, Sep 03, 2021 at 09:15:20AM +0300, Arseny Krasnov wrote:
>> This bit is used to handle POSIX MSG_EOR flag passed from
>> userspace in 'send*()' system calls. It marks end of each
>> record and is visible to receiver using 'recvmsg()' system
>> call.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Spec patch for this?

Hello, here it is

https://lists.oasis-open.org/archives/virtio-comment/202109/msg00008.html

>
>> ---
>>  include/uapi/linux/virtio_vsock.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> index 8485b004a5f8..64738838bee5 100644
>> --- a/include/uapi/linux/virtio_vsock.h
>> +++ b/include/uapi/linux/virtio_vsock.h
>> @@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
>>  /* VIRTIO_VSOCK_OP_RW flags values */
>>  enum virtio_vsock_rw {
>>  	VIRTIO_VSOCK_SEQ_EOM = 1,
>> +	VIRTIO_VSOCK_SEQ_EOR = 2,
>>  };
>>  
>>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>> -- 
>> 2.25.1
>
