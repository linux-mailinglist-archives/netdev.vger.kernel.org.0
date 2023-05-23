Return-Path: <netdev+bounces-4552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E78F670D35F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C15361C20CD8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9840A1B916;
	Tue, 23 May 2023 05:50:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4451B915
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:50:38 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59239119;
	Mon, 22 May 2023 22:50:35 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 33EF55FD29;
	Tue, 23 May 2023 08:50:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684821032;
	bh=9+wsTQnGJ8GmIVjwudDTHD1ZbkCaDVjLvF5QC9OWKyM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	b=TpdFHEq9GZuhh0zDOhKKyT4tprXHPsThKBSgfzh6QANzI7dQ1WieAeRdNU8J5rwBS
	 Hwgd8a7iO+ouh/d5SKr7NfrRK4v1lIBp4jWOePbLSEZFv+1P9tEapph6yITlS5M4tl
	 VXk7+S8N4eHykCBo0ZXW2QVp/tGrV73/YMHffV7ow7RMxSzLwi3A2KIzOCQ5BUmOf4
	 IQZ29Lv4hFcAUbDn56+U8WBIJm/LtXMtsmRJSl257V0a7D5aenepSDqCIgnD3ttv5/
	 uPOrp61uIiJZhtkOMwQTb5jM00eVMuNAeoCebSMfPJvQ0Asr5InogGEW9ChEABbJAY
	 WveoYicKmLJdg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Tue, 23 May 2023 08:50:27 +0300 (MSK)
Message-ID: <ed2b7314-8d0b-f17f-f188-a7d018520ecc@sberdevices.ru>
Date: Tue, 23 May 2023 08:46:06 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 05/17] vsock/virtio: MSG_ZEROCOPY flag support
Content-Language: en-US
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
To: Simon Horman <simon.horman@corigine.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <20230522073950.3574171-6-AVKrasnov@sberdevices.ru>
 <ZGtqEghjjiBnvEBW@corigine.com>
 <7c0a4203-b0bf-1963-14c1-d7c664946d5e@sberdevices.ru>
In-Reply-To: <7c0a4203-b0bf-1963-14c1-d7c664946d5e@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/23 01:22:00 #21370342
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 22.05.2023 16:09, Arseniy Krasnov wrote:
> 
> 
> On 22.05.2023 16:11, Simon Horman wrote:
>> On Mon, May 22, 2023 at 10:39:38AM +0300, Arseniy Krasnov wrote:
>>> This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>>> flag is set and zerocopy transmission is possible, then non-linear skb
>>> will be created and filled with the pages of user's buffer. Pages of
>>> user's buffer are locked in memory by 'get_user_pages()'.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>>  net/vmw_vsock/virtio_transport_common.c | 305 +++++++++++++++++++-----
>>>  1 file changed, 243 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 9854f48a0544..5acf824afe41 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -37,73 +37,161 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>>>  	return container_of(t, struct virtio_transport, transport);
>>>  }
>>>  
>>> -/* Returns a new packet on success, otherwise returns NULL.
>>> - *
>>> - * If NULL is returned, errp is set to a negative errno.
>>> - */
>>> -static struct sk_buff *
>>> -virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>> -			   size_t len,
>>> -			   u32 src_cid,
>>> -			   u32 src_port,
>>> -			   u32 dst_cid,
>>> -			   u32 dst_port)
>>> -{
>>> -	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>>> -	struct virtio_vsock_hdr *hdr;
>>> -	struct sk_buff *skb;
>>> -	void *payload;
>>> -	int err;
>>> +static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
>>> +				       size_t max_to_send)
>>> +{
>>> +	struct iov_iter *iov_iter;
>>> +	size_t max_skb_cap;
>>> +	size_t bytes;
>>> +	int i;
>>>  
>>> -	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>>> -	if (!skb)
>>> -		return NULL;
>>> +	if (!info->msg)
>>> +		return false;
>>>  
>>> -	hdr = virtio_vsock_hdr(skb);
>>> -	hdr->type	= cpu_to_le16(info->type);
>>> -	hdr->op		= cpu_to_le16(info->op);
>>> -	hdr->src_cid	= cpu_to_le64(src_cid);
>>> -	hdr->dst_cid	= cpu_to_le64(dst_cid);
>>> -	hdr->src_port	= cpu_to_le32(src_port);
>>> -	hdr->dst_port	= cpu_to_le32(dst_port);
>>> -	hdr->flags	= cpu_to_le32(info->flags);
>>> -	hdr->len	= cpu_to_le32(len);
>>> +	if (!(info->flags & MSG_ZEROCOPY) && !info->msg->msg_ubuf)
>>> +		return false;
>>>  
>>> -	if (info->msg && len > 0) {
>>> -		payload = skb_put(skb, len);
>>> -		err = memcpy_from_msg(payload, info->msg, len);
>>> -		if (err)
>>> -			goto out;
>>> +	iov_iter = &info->msg->msg_iter;
>>> +
>>> +	if (iter_is_ubuf(iov_iter)) {
>>> +		if (offset_in_page(iov_iter->ubuf))
>>> +			return false;
>>> +
>>> +		return true;
>>> +	}
>>> +
>>> +	if (!iter_is_iovec(iov_iter))
>>> +		return false;
>>> +
>>> +	if (iov_iter->iov_offset)
>>> +		return false;
>>> +
>>> +	/* We can't send whole iov. */
>>> +	if (iov_iter->count > max_to_send)
>>> +		return false;
>>> +
>>> +	for (bytes = 0, i = 0; i < iov_iter->nr_segs; i++) {
>>> +		const struct iovec *iovec;
>>> +		int pages_in_elem;
>>> +
>>> +		iovec = &iov_iter->__iov[i];
>>> +
>>> +		/* Base must be page aligned. */
>>> +		if (offset_in_page(iovec->iov_base))
>>> +			return false;
>>>  
>>> -		if (msg_data_left(info->msg) == 0 &&
>>> -		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>>> -			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>> +		/* Only last element could have non page aligned size. */
>>> +		if (i != (iov_iter->nr_segs - 1)) {
>>> +			if (offset_in_page(iovec->iov_len))
>>> +				return false;
>>>  
>>> -			if (info->msg->msg_flags & MSG_EOR)
>>> -				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>> +			pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
>>> +		} else {
>>> +			pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
>>> +			pages_in_elem >>= PAGE_SHIFT;
>>>  		}
>>> +
>>> +		bytes += (pages_in_elem * PAGE_SIZE);

^^^
This alignment (base and length) checks are not needed, because virtio supports unaligned buffers. I'll remove
it in v4.

Thanks, Arseniy

>>>  	}
>>
>> Hi Arseniy,
>>
>> bytes is set but the loop above, but seems otherwise unused in this function.
>>
>>>  
>>> -	if (info->reply)
>>> -		virtio_vsock_skb_set_reply(skb);
>>> +	/* How many bytes we can pack to single skb. Maximum packet
>>> +	 * buffer size is needed to allow vhost handle such packets,
>>> +	 * otherwise they will be dropped.
>>> +	 */
>>> +	max_skb_cap = min((unsigned int)(MAX_SKB_FRAGS * PAGE_SIZE),
>>> +			  (unsigned int)VIRTIO_VSOCK_MAX_PKT_BUF_SIZE);
>>
>> Likewise, max_skb_cap seems to be set but unused in this function.
>>
> 
> Exactly! Seems I forgot to remove it since v2. Thanks for this and above!
> 
>>>  
>>> -	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>>> -					 dst_cid, dst_port,
>>> -					 len,
>>> -					 info->type,
>>> -					 info->op,
>>> -					 info->flags);
>>> +	return true;
>>> +}
>>
>> ...

