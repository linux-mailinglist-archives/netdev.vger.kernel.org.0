Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5390D3AE909
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFUMaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 08:30:06 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:51276 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhFUMaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 08:30:04 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id B879A76350;
        Mon, 21 Jun 2021 15:27:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624278467;
        bh=RqGHixMXSbuv9LW6i7BRGxThDmgvkwrZO3U6ObcynLE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=u1YQH+i9YbY1bpDDFCXZOlfx75BW2qYadYG8o9URI37x86DWaRJpFdWjphkjWUWiw
         dpIYb2vSwVogd2y+c/9Yw0Wj40FbJT2vYM1sooySIE2uZ2/pKa6pW8TQVr/Mh9p4XM
         Pi+9Xo1cFGZjV23gqqcS7hwNG2n7kGVpI2k/O272JQyNBADBRIbyDKm6z40jTHl5Ag
         szmX5T4VQ3z69HJ1/LK45rgId41aH7XzNjahCuizmRwUWBCceNeqs1xIFR1vJrzfoo
         ITTWcYjB5azd1C4X/iVvWmFs/LbdMGDw76BwKvGFSzs9T/iyJgtTzt3sx9/VFX9h67
         0daKz3XWaPgsg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id D19B776342;
        Mon, 21 Jun 2021 15:27:45 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 21
 Jun 2021 15:27:45 +0300
Subject: Re: [MASSMAIL KLMS] Re: [PATCH v11 11/18] virtio/vsock: dequeue
 callback for SOCK_SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
 <20210618155555.j5p4v6j5gk2dboj3@steredhat.lan>
 <650673dc-8b29-657e-5bbd-2cc974628ec9@kaspersky.com>
 <20210618162509.yppkajmvcbzvidy4@steredhat.lan>
 <31f58b17-02e6-4246-5ad8-7e8d7892ecb7@kaspersky.com>
 <b27d3fd1-fa8a-97ff-9035-cf3f525d5866@kaspersky.com>
 <20210621102320.4uaqaee74yynnn2q@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <770f1afe-4ced-e080-769e-959a2ea61281@kaspersky.com>
Date:   Mon, 21 Jun 2021 15:27:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210621102320.4uaqaee74yynnn2q@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/21/2021 12:08:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164502 [Jun 21 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/21/2021 12:12:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 21.06.2021 11:41:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/21 10:51:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/21 10:36:00 #16775443
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.06.2021 13:23, Stefano Garzarella wrote:
> On Mon, Jun 21, 2021 at 09:55:13AM +0300, Arseny Krasnov wrote:
>> On 18.06.2021 19:26, Arseny Krasnov wrote:
>>> On 18.06.2021 19:25, Stefano Garzarella wrote:
>>>> On Fri, Jun 18, 2021 at 07:08:30PM +0300, Arseny Krasnov wrote:
>>>>> On 18.06.2021 18:55, Stefano Garzarella wrote:
>>>>>> On Fri, Jun 18, 2021 at 06:04:37PM +0300, Arseny Krasnov wrote:
>>>>>>> On 18.06.2021 16:44, Stefano Garzarella wrote:
>>>>>>>> Hi Arseny,
>>>>>>>> the series looks great, I have just a question below about
>>>>>>>> seqpacket_dequeue.
>>>>>>>>
>>>>>>>> I also sent a couple a simple fixes, it would be great if you can review
>>>>>>>> them:
>>>>>>>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>>>>>>>>
>>>>>>>>
>>>>>>>> On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>>>>>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>>>>>> full, we just send credit update and drop data.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>>>>>> ---
>>>>>>>>> v10 -> v11:
>>>>>>>>> 1) 'msg_count' field added to count current number of EORs.
>>>>>>>>> 2) 'msg_ready' argument removed from callback.
>>>>>>>>> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>>>>>>>>>    no next attempts to copy data, rest of record will be freed.
>>>>>>>>>
>>>>>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>>>>>> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
>>>>>>>>> 2 files changed, 89 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>>>>>> index dc636b727179..1d9a302cb91d 100644
>>>>>>>>> --- a/include/linux/virtio_vsock.h
>>>>>>>>> +++ b/include/linux/virtio_vsock.h
>>>>>>>>> @@ -36,6 +36,7 @@ struct virtio_vsock_sock {
>>>>>>>>> 	u32 rx_bytes;
>>>>>>>>> 	u32 buf_alloc;
>>>>>>>>> 	struct list_head rx_queue;
>>>>>>>>> +	u32 msg_count;
>>>>>>>>> };
>>>>>>>>>
>>>>>>>>> struct virtio_vsock_pkt {
>>>>>>>>> @@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>>>>>> 			       struct msghdr *msg,
>>>>>>>>> 			       size_t len, int flags);
>>>>>>>>>
>>>>>>>>> +ssize_t
>>>>>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>>>>>> +				   struct msghdr *msg,
>>>>>>>>> +				   int flags);
>>>>>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>>>>>
>>>>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> index ad0d34d41444..1e1df19ec164 100644
>>>>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> @@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>> 	return err;
>>>>>>>>> }
>>>>>>>>>
>>>>>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>> +						 struct msghdr *msg,
>>>>>>>>> +						 int flags)
>>>>>>>>> +{
>>>>>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>>>>>> +	int dequeued_len = 0;
>>>>>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>>>>>> +	bool copy_failed = false;
>>>>>>>>> +	bool msg_ready = false;
>>>>>>>>> +
>>>>>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>>>>>> +
>>>>>>>>> +	if (vvs->msg_count == 0) {
>>>>>>>>> +		spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>> +		return 0;
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>> +	while (!msg_ready) {
>>>>>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>>>>>> +
>>>>>>>>> +		if (!copy_failed) {
>>>>>>>>> +			size_t pkt_len;
>>>>>>>>> +			size_t bytes_to_copy;
>>>>>>>>> +
>>>>>>>>> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>>>>>> +			bytes_to_copy = min(user_buf_len, pkt_len);
>>>>>>>>> +
>>>>>>>>> +			if (bytes_to_copy) {
>>>>>>>>> +				int err;
>>>>>>>>> +
>>>>>>>>> +				/* sk_lock is held by caller so no one else can dequeue.
>>>>>>>>> +				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>>>>>> +				 */
>>>>>>>>> +				spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>> +
>>>>>>>>> +				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>>>>>>>>> +				if (err) {
>>>>>>>>> +					/* Copy of message failed, set flag to skip
>>>>>>>>> +					 * copy path for rest of fragments. Rest of
>>>>>>>>> +					 * fragments will be freed without copy.
>>>>>>>>> +					 */
>>>>>>>>> +					copy_failed = true;
>>>>>>>>> +					dequeued_len = err;
>>>>>>>> If we fail to copy the message we will discard the entire packet.
>>>>>>>> Is it acceptable for the user point of view, or we should leave the
>>>>>>>> packet in the queue and the user can retry, maybe with a different
>>>>>>>> buffer?
>>>>>>>>
>>>>>>>> Then we can remove the packets only when we successfully copied all the
>>>>>>>> fragments.
>>>>>>>>
>>>>>>>> I'm not sure make sense, maybe better to check also other
>>>>>>>> implementations :-)
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Stefano
>>>>>>> Understand, i'll check it on weekend, anyway I think it is
>>>>>>> not critical for implementation.
>>>>>> Yep, I agree.
>>>>>>
>>>>>>> I have another question: may be it is useful to research for
>>>>>>> approach where packets are not queued until whole message
>>>>>>> is received, but copied to user's buffer thus freeing memory.
>>>>>>> (like previous implementation, of course with solution of problem
>>>>>>> where part of message still in queue, while reader was woken
>>>>>>> by timeout or signal).
>>>>>>>
>>>>>>> I think it is better, because  in current version, sender may set
>>>>>>> 'peer_alloc_buf' to  for example 1MB, so at receiver we get
>>>>>>> 1MB of 'kmalloc()' memory allocated, while having user's buffer
>>>>>>> to copy data there or drop it(if user's buffer is full). This way
>>>>>>> won't change spec(e.g. no message id or SEQ_BEGIN will be added).
>>>>>>>
>>>>>>> What do You think?
>>>>>> Yep, I see your point and it would be great, but I think the main issues
>>>>>> to fix is how to handle a signal while we are waiting other fragments
>>>>>> since the other peer can take unspecified time to send them.
>>>>> What about transport callback, something like 'seqpacket_drain()' or
>>>>>
>>>>> 'seqpacket_drop_curr()' - when we got signal or timeout, notify transport
>>>>>
>>>>> to drop current message. In virtio case this will set special flag in transport,
>>>>>
>>>>> so on next dequeue, this flag is checked and if it is set - we drop all packets
>>>>>
>>>>> until EOR found. Then we can copy untouched new record.
>>>>>
>>>> But in this way, we will lose the entire message.
>>>>
>>>> Is it acceptable for seqpacket?
>>>>
>>>> Stefano
>>> Hm, i'll check it. At least for unix domain sockets - it supports SEQPACKET
>> Hello, i've checked AF_UNIX and AF_AX25 SEQPACKET implementations,
> Great! Thanks for checking!
>
>> in both cases:
>>
>> 1) Datagram is dequeued first, then copied to user's buffer.
>>
>> 2) Datagram is also freed when copying to user's buffer fail
>>
>> (it is not reinserted back).
>>
>>
>> But, in case of virtio vsock, i've got the following concern in
>> this approach: in cases of AF_UNIX or AF_AX25 there is maximum
>>
>> datagram size, strictly limited by spec, so no 'setsockopt()' call allows
>>
>> to exceed this. Also these limits are significantly smaller that current
>>
>> amounts of RAM. But, in our case, there is no such limit: peer could
>>
>> say 'i want to use 100MB datagram', and receiver just answer 'ok',
> The receiver sets the limit of its receive buffer and tells the 
> transmitter that it should not exceed it. The default should be 256 KB, 
> so IIUC this scenario can happen only if the receiver do a 
> 'setsockopt()' increasing the limit to 100MB. Right?
>
> Maybe we should limit it.

Yes, sorry, i meant this. Two peers want's to transmit 100mb message.

Receiver calls 'setsockopt()' and got 100mb of kmalloc() memory.

May be, from point of view of these two peers its ok. But for whole system

- i'm not sure. And limit - it is interesting question, what value to use as limit?

>
>>  as there is just variable assignment to setup new limit. Now, consider
>>
>> that there will be 10 peers, 100MB each(no one limit such request,
>>
>> because each socket doesn't know about each other). I think we get
>>
>> out-of-service in this case - all kmalloc() memory will be wasted for
>>
>> pending record.
>>
>>
>> I still think, that approach when we copy data from packet to user's
>>
>> buffer without waiting EOR is better.
> Okay, in this way we can remove the receive buffer limit and maybe if we 
> receive a signal, we can set MSG_TRUNC, return the partially received 
> packet to the user, but we must free any next fragments.
>
> So, as you proposed, we need a `seqpacket_drop()` to tell to the 
> transport that if we were copying an uncompleted message, then it should 
> delete the queued fragments and any others until the next EOR.

Ok, i'll prepare RFC patch for this approach, i think it will be

significantly smaller than merged patchset.

>
>>
>> Also i'll rebase QEMU patch today or tomorrow.
> Great, please CC me, this is something high priority to test 
> SOCK_SEQPACKET with a guest.
Ack
>
>>
>> What do You Think?
> I'm fine with both, but I slightly prefer the approach we implemented 
> because it's easier to handle.
>
> Thanks,
> Stefano
>
>
