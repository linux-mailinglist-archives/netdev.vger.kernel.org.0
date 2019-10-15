Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FCFD6CAE
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfJOA5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 20:57:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40172 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfJOA5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 20:57:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so11321926pfb.7;
        Mon, 14 Oct 2019 17:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wsv1eeRYK3FckN4mPKM6Tyd9SrCDq1K6jdUYJvegRgw=;
        b=qcf6YCz2nrdYS9t+vyxPGwCWBe+pJkCYK9K2IoXAFvzqMvXj+YTcU5kd1SC2AD/VMK
         2zQuNPSdDJadMcQABTNlSDNX7o41OSKRswbHRAEWqfXkGwFB8nyAwrA0wGYUh0t/Y671
         1wAnWZIWk9rKP4PpEZ5+CWO6AMqRmv0Kyj3X0qyXYJVdjBu4wy4P2ySlt6gUO/GauRpw
         +VVTlCqmUPWrRBuKsBVgHhiIF8PT6J2VICiJc34MxhTqmiZ8bxaMs0m+gFP/PC+4IHNQ
         MXYxKN0LyF0Lfh4JWvgu+t+KPUVcRR9Ax3NM1UA6L4E4lxgU3+MukujzgT+cPRcNSYr8
         y22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wsv1eeRYK3FckN4mPKM6Tyd9SrCDq1K6jdUYJvegRgw=;
        b=lfddC+EhEpg0qC0z4ngcaOcsnYpUlAkIaBXvgvl/Vx1+osXTvfa0yK44tNkLgBnuEa
         VQKft82KgfvfUTkuLnbXmU55nq5SXJ3P3NxuUY0MZlUTL0GdQIqpVnp1eHIQALtbIlEQ
         dQjgbF/FyD/8AWJWuo0XYChwdySnaFSo+ce+Z/+HYxWifNiYhM640kxm+Vtw2oT2DVRr
         s1iLLOxSG2vd3Xd58nHCsKCXPHt2cubUmeLM7YmEONPQCsfheOaOMdy1DlyxtZHixpG2
         f9vQ742FNsEYu6zwk7GU8tyvcdem8IO7aU1U8pVwpcmsnhsXRExjDWHSckr2m2naVW1P
         f0IA==
X-Gm-Message-State: APjAAAX+HV79YAkB3cwqDvXJT9Bn1ZoPbquzeTGexyG+n1cWcgitDUvW
        Le5JItERRvOBhc9g2pCr2UgtGx6H
X-Google-Smtp-Source: APXvYqxJBVBZFmeB7ozapEcpOz5kvEfy2Ogpgrpa/kA8ZCiYDBDztGekyX/rE9/CAELuXONhMbyL1A==
X-Received: by 2002:a62:e40d:: with SMTP id r13mr35490542pfh.154.1571101065271;
        Mon, 14 Oct 2019 17:57:45 -0700 (PDT)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s36sm20196820pgk.84.2019.10.14.17.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 17:57:44 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] vhost_net: user tap recvmsg api to access
 ptr ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
 <20191012015357.1775-3-prashantbhole.linux@gmail.com>
 <20191012164059-mutt-send-email-mst@kernel.org>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <a98a594c-f0ee-43f7-956b-159009dc6e0f@gmail.com>
Date:   Tue, 15 Oct 2019 09:57:11 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012164059-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,
Thanks for reviewing.

On 10/13/19 5:41 AM, Michael S. Tsirkin wrote:
> On Sat, Oct 12, 2019 at 10:53:56AM +0900, prashantbhole.linux@gmail.com wrote:
>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> Currently vhost_net directly accesses ptr ring of tap driver to
>> fetch Rx packet pointers. In order to avoid it this patch modifies
>> tap driver's recvmsg api to do additional task of fetching Rx packet
>> pointers.
>>
>> A special struct tun_msg_ctl is already being usedd via msg_control
>> for tun Rx XDP batching. This patch extends tun_msg_ctl usage to
>> send sub commands to recvmsg api. recvmsg can now produce/unproduce
>> pointers from ptr ring as an additional task.
>>
>> This will be useful in future in implementation of virtio-net XDP
>> offload feature. Where packets will be XDP batch processed in
>> tun_recvmsg.
> 
> I'd like to see that future patch, by itself this patchset
> seems to be of limited usefulness.

Agree, this set is just a reorganization. Next time this will be a part
of set which actually uses it.

Thanks

> 
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   drivers/net/tap.c      | 22 +++++++++++++++++++-
>>   drivers/net/tun.c      | 24 +++++++++++++++++++++-
>>   drivers/vhost/net.c    | 46 +++++++++++++++++++++++++++++++++---------
>>   include/linux/if_tun.h |  3 +++
>>   4 files changed, 83 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 01bd260ce60c..3d0bf382dbbc 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -1234,8 +1234,28 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
>>   		       size_t total_len, int flags)
>>   {
>>   	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
>> -	struct sk_buff *skb = m->msg_control;
>> +	struct tun_msg_ctl *ctl = m->msg_control;
>> +	struct sk_buff *skb = NULL;
>>   	int ret;
>> +
>> +	if (ctl) {
>> +		switch (ctl->cmd) {
>> +		case TUN_CMD_PACKET:
>> +			skb = ctl->ptr;
>> +			break;
>> +		case TUN_CMD_PRODUCE_PTRS:
>> +			return ptr_ring_consume_batched(&q->ring,
>> +							ctl->ptr_array,
>> +							ctl->num);
>> +		case TUN_CMD_UNPRODUCE_PTRS:
>> +			ptr_ring_unconsume(&q->ring, ctl->ptr_array, ctl->num,
>> +					   tun_ptr_free);
>> +			return 0;
>> +		default:
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>>   	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
>>   		kfree_skb(skb);
>>   		return -EINVAL;
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 29711671959b..7d4886f53389 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -2577,7 +2577,8 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>>   {
>>   	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
>>   	struct tun_struct *tun = tun_get(tfile);
>> -	void *ptr = m->msg_control;
>> +	struct tun_msg_ctl *ctl = m->msg_control;
>> +	void *ptr = NULL;
>>   	int ret;
>>   
>>   	if (!tun) {
>> @@ -2585,6 +2586,27 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>>   		goto out_free;
>>   	}
>>   
>> +	if (ctl) {
>> +		switch (ctl->cmd) {
>> +		case TUN_CMD_PACKET:
>> +			ptr = ctl->ptr;
>> +			break;
>> +		case TUN_CMD_PRODUCE_PTRS:
>> +			ret = ptr_ring_consume_batched(&tfile->tx_ring,
>> +						       ctl->ptr_array,
>> +						       ctl->num);
>> +			goto out;
>> +		case TUN_CMD_UNPRODUCE_PTRS:
>> +			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr_array,
>> +					   ctl->num, tun_ptr_free);
>> +			ret = 0;
>> +			goto out;
>> +		default:
>> +			ret = -EINVAL;
>> +			goto out_put_tun;
>> +		}
>> +	}
>> +
>>   	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC|MSG_ERRQUEUE)) {
>>   		ret = -EINVAL;
>>   		goto out_put_tun;
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 5946d2775bd0..5e5c1063606c 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -175,24 +175,44 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>>   
>>   static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
>>   {
>> +	struct vhost_virtqueue *vq = &nvq->vq;
>> +	struct socket *sock = vq->private_data;
>>   	struct vhost_net_buf *rxq = &nvq->rxq;
>> +	struct tun_msg_ctl ctl = {
>> +		.cmd = TUN_CMD_PRODUCE_PTRS,
>> +		.ptr_array = rxq->queue,
>> +		.num = VHOST_NET_BATCH,
>> +	};
>> +	struct msghdr msg = {
>> +		.msg_control = &ctl,
>> +	};
>>   
>>   	rxq->head = 0;
>> -	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
>> -					      VHOST_NET_BATCH);
>> +	rxq->tail = sock->ops->recvmsg(sock, &msg, 0, 0);
>> +	if (rxq->tail < 0)
>> +		rxq->tail = 0;
>> +
>>   	return rxq->tail;
>>   }
>>   
>>   static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
>>   {
>> +	struct vhost_virtqueue *vq = &nvq->vq;
>> +	struct socket *sock = vq->private_data;
>>   	struct vhost_net_buf *rxq = &nvq->rxq;
>> +	struct tun_msg_ctl ctl = {
>> +		.cmd = TUN_CMD_UNPRODUCE_PTRS,
>> +		.ptr_array = rxq->queue + rxq->head,
>> +		.num = vhost_net_buf_get_size(rxq),
>> +	};
>> +	struct msghdr msg = {
>> +		.msg_control = &ctl,
>> +	};
>>   
>> -	if (nvq->rx_ring && !vhost_net_buf_is_empty(rxq)) {
>> -		ptr_ring_unconsume(nvq->rx_ring, rxq->queue + rxq->head,
>> -				   vhost_net_buf_get_size(rxq),
>> -				   tun_ptr_free);
>> -		rxq->head = rxq->tail = 0;
>> -	}
>> +	if (!vhost_net_buf_is_empty(rxq))
>> +		sock->ops->recvmsg(sock, &msg, 0, 0);
>> +
>> +	rxq->head = rxq->tail = 0;
>>   }
>>   
>>   static int vhost_net_buf_peek_len(void *ptr)
>> @@ -1109,6 +1129,9 @@ static void handle_rx(struct vhost_net *net)
>>   		.flags = 0,
>>   		.gso_type = VIRTIO_NET_HDR_GSO_NONE
>>   	};
>> +	struct tun_msg_ctl ctl = {
>> +		.cmd = TUN_CMD_PACKET,
>> +	};
>>   	size_t total_len = 0;
>>   	int err, mergeable;
>>   	s16 headcount;
>> @@ -1166,8 +1189,11 @@ static void handle_rx(struct vhost_net *net)
>>   			goto out;
>>   		}
>>   		busyloop_intr = false;
>> -		if (nvq->rx_ring)
>> -			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
>> +		if (nvq->rx_ring) {
>> +			ctl.cmd = TUN_CMD_PACKET;
>> +			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
>> +			msg.msg_control = &ctl;
>> +		}
>>   		/* On overrun, truncate and discard */
>>   		if (unlikely(headcount > UIO_MAXIOV)) {
>>   			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
>> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
>> index bdfa671612db..8608d4095143 100644
>> --- a/include/linux/if_tun.h
>> +++ b/include/linux/if_tun.h
>> @@ -13,10 +13,13 @@
>>   
>>   #define TUN_CMD_PACKET 1
>>   #define TUN_CMD_BATCH  2
>> +#define TUN_CMD_PRODUCE_PTRS	3
>> +#define TUN_CMD_UNPRODUCE_PTRS	4
>>   struct tun_msg_ctl {
>>   	unsigned short cmd;
>>   	unsigned short num;
>>   	void *ptr;
>> +	void **ptr_array;
>>   };
>>   
>>   struct tun_xdp_hdr {
>> -- 
>> 2.21.0
