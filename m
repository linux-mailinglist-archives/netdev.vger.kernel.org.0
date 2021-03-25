Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FD349660
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCYQFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:05:13 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:16436 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhCYQEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:04:44 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 9F63A5215B7;
        Thu, 25 Mar 2021 19:04:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688281;
        bh=7pcdVRyGV7z8Tc6pz/9NgzLjtvmy5MsAiUhSTGGbXkg=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=tOa9wJ4KMNEG6O7qqIooX6ZQH2t/GW1RocdhjV9b1j54IfOP61t2H53yo+z44otyH
         C7wifl4OCj7p5hm/s21hkb0Qz/4km0TBvWv8KEXl+B2Uz+MJ+QWrjYNys2AxtDk5qG
         TXRj9EzOnZd3zjOKQhXIHFMQwJU52/Y+ALUezL9B4Xeh9HDva9dTnU7YO/Bx1BN+8b
         xbJipj+RUWNgoXh2DvdEyI3aefHK3HoULZmw+F7OYtCYF0iPmvs5Dnwt4iFI2NXCJg
         bs6b9OBVj7zqq4W7I5gSI7dKjgoJPVCmUP/9KoPp83p5JsvvATVGrdTlLP0OETQ78e
         69vQXz10N99HQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 4F8D85215CF;
        Thu, 25 Mar 2021 19:04:41 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:04:40 +0300
Subject: Re: [RFC PATCH v7 16/22] virtio/vsock: setup SEQPACKET ops for
 transport
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
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
 <20210323131406.2461651-1-arseny.krasnov@kaspersky.com>
 <20210325103950.7k75hntees5ppgbm@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <1d721a98-e510-1320-9e88-cd0829cf385a@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:04:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325103950.7k75hntees5ppgbm@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
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


On 25.03.2021 13:39, Stefano Garzarella wrote:
> On Tue, Mar 23, 2021 at 04:14:03PM +0300, Arseny Krasnov wrote:
>> This adds SEQPACKET ops for virtio transport and 'seqpacket_allow()'
>> callback.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/virtio_transport.c | 12 ++++++++++++
>> 1 file changed, 12 insertions(+)
> Sorry for not mentioning this in the previous review, but maybe we can 
> merge this patch with "virtio/vsock: SEQPACKET feature bit support", so 
> we have a single patch when we fully enable the SEQPACKET support in 
> this transport.
>
> Anyway, I don't have a strong opinion on that.
>
> What do you think?
Ok, no problem
>
> Stefano
>
>> diff --git a/net/vmw_vsock/virtio_transport.c 
>> b/net/vmw_vsock/virtio_transport.c
>> index 2700a63ab095..83ae2078c847 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -443,6 +443,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>> }
>>
>> +static bool virtio_transport_seqpacket_allow(void);
>> +
>> static struct virtio_transport virtio_transport = {
>> 	.transport = {
>> 		.module                   = THIS_MODULE,
>> @@ -469,6 +471,10 @@ static struct virtio_transport virtio_transport = {
>> 		.stream_is_active         = virtio_transport_stream_is_active,
>> 		.stream_allow             = virtio_transport_stream_allow,
>>
>> +		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>> +		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>> +		.seqpacket_allow          = virtio_transport_seqpacket_allow,
>> +
>> 		.notify_poll_in           = virtio_transport_notify_poll_in,
>> 		.notify_poll_out          = virtio_transport_notify_poll_out,
>> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>> @@ -483,8 +489,14 @@ static struct virtio_transport virtio_transport = {
>> 	},
>>
>> 	.send_pkt = virtio_transport_send_pkt,
>> +	.seqpacket_allow = false
>> };
>>
>> +static bool virtio_transport_seqpacket_allow(void)
>> +{
>> +	return virtio_transport.seqpacket_allow;
>> +}
>> +
>> static void virtio_transport_rx_work(struct work_struct *work)
>> {
>> 	struct virtio_vsock *vsock =
>> -- 2.25.1
>>
>
