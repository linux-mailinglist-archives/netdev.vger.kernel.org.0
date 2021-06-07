Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00E39DB53
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhFGLbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:31:24 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:25335 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhFGLbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:31:23 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 30AC9520DA0;
        Mon,  7 Jun 2021 14:29:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623065370;
        bh=+l0jN8muODPUmRGN9vGw6O/X1tTt+MeF8Ry78sPbqPI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=ESQwf7WDT6QFvAOiI2+zF3GKirKj4Cfsasm5w8xsmDpPdtgCvaj9s0z1x6UEEXHIW
         ZIr1W6t2g1SaklZrjwYl/CTkPJf78RvnbRFjkm/XkETFt/YUXE1LJr4sW6okuJyiUi
         RraaU6JCDNaNECkn7jOjU56kMhvs+p3zIEblTc/WJN9E9j8TPc5lFSR5Dn1QdacgIr
         8Vdz8IUJB4LSRbYdcyWF5sAhPIo0WT2jE5FaE3oZR0hFz7SLHfkbRJQSpalyLlIYFX
         7dQNviVgXZV+Jaf+rotorAKk/IvuQQVs4KQ2z8PjK9OhLzGvxCErffnPPZaVjIT8jI
         Omf+MchzDnj1A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6633A520D81;
        Mon,  7 Jun 2021 14:29:29 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 7
 Jun 2021 14:29:28 +0300
Subject: Re: [MASSMAIL KLMS] Re: [PATCH v10 04/18] af_vsock: implement
 SEQPACKET receive loop
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
 <20210604150638.rmx262k4wjmp2zob@steredhat>
 <93254e99-1cf9-3135-f1c8-d60336bf41b5@kaspersky.com>
 <20210607104816.fgudxa5a6pldkqts@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <95a11b19-8266-7fc0-9426-edccd4512a2d@kaspersky.com>
Date:   Mon, 7 Jun 2021 14:29:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210607104816.fgudxa5a6pldkqts@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/07/2021 11:05:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164153 [Jun 07 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/07/2021 11:09:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 07.06.2021 9:33:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/07 10:08:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/07 07:05:00 #16681090
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07.06.2021 13:48, Stefano Garzarella wrote:
> On Fri, Jun 04, 2021 at 09:00:14PM +0300, Arseny Krasnov wrote:
>> On 04.06.2021 18:06, Stefano Garzarella wrote:
>>> On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>>>> Add receive loop for SEQPACKET. It looks like receive loop for
>>>> STREAM, but there are differences:
>>>> 1) It doesn't call notify callbacks.
>>>> 2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>>>>   there is no sense for these values in SEQPACKET case.
>>>> 3) It waits until whole record is received or error is found during
>>>>   receiving.
>>>> 4) It processes and sets 'MSG_TRUNC' flag.
>>>>
>>>> So to avoid extra conditions for two types of socket inside one loop, two
>>>> independent functions were created.
>>>>
>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>> ---
>>>> v9 -> v10:
>>>> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>>
>>>> include/net/af_vsock.h   |  4 +++
>>>> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
>>>> 2 files changed, 75 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>>> index b1c717286993..5175f5a52ce1 100644
>>>> --- a/include/net/af_vsock.h
>>>> +++ b/include/net/af_vsock.h
>>>> @@ -135,6 +135,10 @@ struct vsock_transport {
>>>> 	bool (*stream_is_active)(struct vsock_sock *);
>>>> 	bool (*stream_allow)(u32 cid, u32 port);
>>>>
>>>> +	/* SEQ_PACKET. */
>>>> +	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>>> +				     int flags, bool *msg_ready);
>>>> +
>>>> 	/* Notification. */
>>>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>>>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index c4f6bfa1e381..aede474343d1 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -1974,6 +1974,73 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>> 	return err;
>>>> }
>>>>
>>>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>> +				     size_t len, int flags)
>>>> +{
>>>> +	const struct vsock_transport *transport;
>>>> +	bool msg_ready;
>>>> +	struct vsock_sock *vsk;
>>>> +	ssize_t record_len;
>>>> +	long timeout;
>>>> +	int err = 0;
>>>> +	DEFINE_WAIT(wait);
>>>> +
>>>> +	vsk = vsock_sk(sk);
>>>> +	transport = vsk->transport;
>>>> +
>>>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>>>> +	msg_ready = false;
>>>> +	record_len = 0;
>>>> +
>>>> +	while (1) {
>>>> +		ssize_t fragment_len;
>>>> +
>>>> +		if (vsock_wait_data(sk, &wait, timeout, NULL, 0) <= 0) {
>>>> +			/* In case of any loop break(timeout, signal
>>>> +			 * interrupt or shutdown), we report user that
>>>> +			 * nothing was copied.
>>>> +			 */
>>>> +			err = 0;
>>> Why we report that nothing was copied?
>>>
>>> What happen to the bytes already copied in `msg`?
>> Seems i need to return result of vsock_wait_data()...
> I'm not sure.
>
> My biggest concern is if we reach timeout or get a signal while waiting 
> for the other pieces of a message.
> I believe that we should not start copying a message if we have not 
> received all the fragments. Otherwise we have this problem.
>
> When we are sure that we have all the pieces, then we should copy them 
> without interrupting.
>
> IIRC this was done in previous versions.

As i remember, previous versions also returned 0, because i thought,

that for interrupted read we can copy piece of data to user's buffer,

but we must return that nothing copied or error. In this way user

won't read part of message, because syscall returned that there is

nothing to copy. So as i understand, it is not enough - user's buffer

must be touched only when whole message is copied?

>
> Stefano
>
>
