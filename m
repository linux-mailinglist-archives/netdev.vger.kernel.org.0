Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B6B34965E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhCYQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:04:39 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:16233 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhCYQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:04:20 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id D2A00521918;
        Thu, 25 Mar 2021 19:04:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688257;
        bh=k5jSEw3fXkClYM4D4vx74TvLzqLl5pRN3jOQh1xreYw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=dNh7xv2fNdNI2Sj3/EhtfjMJmdr7dhyYtl6xF2gTbCSMjnzRIjoXVZMOKu9KFD8Kf
         3/VA/hGOY/3lZNSgtpi0L6duMZ6rXUGbWW8L+bEG2xR1R5tToOeeoadsKctsu9/TGF
         SP7P//XQi1eBj1k3ybOwfID3L5aGx/Q0Cy0HhVlnb2iMupcrpvcJc2eT7jGZtWIvHo
         Tdmt6aIaH7kLKOAFNkQ8XstrwJClZccPu6oOj9uUJUcFeV5elcqcQp+PCy3YcYrdZQ
         OEKNsGiYLOKofF+CNLxD0skV39EGyitjVFzsq/r4RJSBFDI4603rNWAWFDWIAjZ+JE
         geWvao2P1HZTw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 0E764521909;
        Thu, 25 Mar 2021 19:04:17 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:04:16 +0300
Subject: Re: [RFC PATCH v7 15/22] virtio/vsock: SEQPACKET support feature bit
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
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131352.2461534-1-arseny.krasnov@kaspersky.com>
 <20210325102655.ujyfpapvwnubcggn@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <66c37c8e-161d-da61-9280-4a1637ed08ba@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:04:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325102655.ujyfpapvwnubcggn@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/25/2021 15:37:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162675 [Mar 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 438 438 e169a60cee0e977a975a890ed8ef829a2851344a
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/25/2021 15:40:00
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


On 25.03.2021 13:26, Stefano Garzarella wrote:
> On Tue, Mar 23, 2021 at 04:13:49PM +0300, Arseny Krasnov wrote:
>> This adds new virtio vsock specific feature bit which means
>> SOCK_SEQPACKET support. Guest negotiates this bit with vhost,
>> thus checking that vhost side supports SEQPACKET.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/uapi/linux/virtio_vsock.h | 3 +++
>> 1 file changed, 3 insertions(+)
> Since you have this patch, I think you can generalize the title, update 
> the description, and merge here the changes I mentioned in patch 11/22 
> about changes of include/uapi/linux/virtio_vsock.h.
>
> So you can have a single patch with the new virtio-spec defines and 
> structs related to SEQPACKET, of course then we move it before patch 11.
>
> What do you think?
Ok, i'll move all changes related to spec to separate patch
>
> Stefano
>
>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> index 692f8078cced..619aaebb355a 100644
>> --- a/include/uapi/linux/virtio_vsock.h
>> +++ b/include/uapi/linux/virtio_vsock.h
>> @@ -38,6 +38,9 @@
>> #include <linux/virtio_ids.h>
>> #include <linux/virtio_config.h>
>>
>> +/* The feature bitmap for virtio vsock */
>> +#define VIRTIO_VSOCK_F_SEQPACKET	0	/* SOCK_SEQPACKET supported */
>> +
>> struct virtio_vsock_config {
>> 	__le64 guest_cid;
>> } __attribute__((packed));
>> -- 
>> 2.25.1
>>
>
