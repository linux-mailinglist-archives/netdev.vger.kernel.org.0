Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564BE2E86E4
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 11:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbhABKNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 05:13:01 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:63998 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbhABKNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 05:13:00 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 0C706766BD;
        Sat,  2 Jan 2021 13:12:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1609582336;
        bh=vmHcNFJSdZuQOx2Vmbwh1++2dtYiBZbvS1QS9J7BceE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=DDUa2Hw1rjd2Jz5TY2BXgKvo/KOKi8R4nAsZGWfRx2Byxwtsaa5NOA5uDEO/kD/nh
         DHy1Lwg3zCdnstbY7DOweTcCF9TndiSF8EOcEg6xK2oqhuSQ4Ttyxyi13GN0TM11xR
         zOdaUSxHQWnMroQTDQYaDxgIyep0zCqGkvvqAj6s=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 84F2D766B9;
        Sat,  2 Jan 2021 13:12:15 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sat, 2 Jan
 2021 13:12:14 +0300
Subject: Re: [PATCH 2/3] vhost/vsock: support for SOCK_SEQPACKET socket.
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201229110634.275024-1-arseny.krasnov@kaspersky.com>
 <20201230155410-mutt-send-email-mst@kernel.org>
 <20201230155742-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <ff5993ea-7001-78fa-ec2f-dda1ae606b36@kaspersky.com>
Date:   Sat, 2 Jan 2021 13:12:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201230155742-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/02/2021 10:01:29
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 160969 [Jan 02 2021]
X-KSE-AntiSpam-Info: LuaCore: 419 419 70b0c720f8ddd656e5f4eb4a4449cf8ce400df94
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/02/2021 10:04:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 02.01.2021 4:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/02 09:25:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/01 22:24:00 #15996345
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> oh this was not threaded correctly so I did not see rest of
> patches. ignore this pls will respond there.

Sorry, i'll resend whole patchset ASAP in one thread.

On 30.12.2020 23:58, Michael S. Tsirkin wrote:
> On Wed, Dec 30, 2020 at 03:56:03PM -0500, Michael S. Tsirkin wrote:
>> On Tue, Dec 29, 2020 at 02:06:33PM +0300, Arseny Krasnov wrote:
>>> 	This patch simply adds transport ops and removes
>>> ignore of non-stream type of packets.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> How is this supposed to work? virtio vsock at the moment
>> has byte level end to end credit accounting at the
>> protocol level. I suspect some protocol changes involving
>> more than this tweak would
>> be needed to properly support anything that isn't a stream.
>
> oh this was not threaded correctly so I did not see rest of
> patches. ignore this pls will respond there.
>
>>> ---
>>>  drivers/vhost/vsock.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index a483cec31d5c..4a36ef1c52d0 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -346,8 +346,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>>>  		return NULL;
>>>  	}
>>>  
>>> -	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>>> -		pkt->len = le32_to_cpu(pkt->hdr.len);
>>> +	pkt->len = le32_to_cpu(pkt->hdr.len);
>>>  
>>>  	/* No payload */
>>>  	if (!pkt->len)
>>> @@ -416,6 +415,9 @@ static struct virtio_transport vhost_transport = {
>>>  		.stream_is_active         = virtio_transport_stream_is_active,
>>>  		.stream_allow             = virtio_transport_stream_allow,
>>>  
>>> +		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
>>> +		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
>>> +
>>>  		.notify_poll_in           = virtio_transport_notify_poll_in,
>>>  		.notify_poll_out          = virtio_transport_notify_poll_out,
>>>  		.notify_recv_init         = virtio_transport_notify_recv_init,
>>> -- 
>>> 2.25.1
>
