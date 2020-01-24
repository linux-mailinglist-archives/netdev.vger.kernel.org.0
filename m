Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617EB14863E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbgAXNgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:36:19 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43260 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387847AbgAXNgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:36:19 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so510491pfh.10
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 05:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0uBGLEj921E9Pm4+tQgPIwE71cUPiNXUxNvf73v2fb8=;
        b=uG177/Eh6v+mzyPOUO94O97b5a4/kfeHbVkHEBIM3gq+feL5hqfHKaacppNN+Cy9Zr
         Ck2hPZrzdhGRVCQ9AAmNpUvVY9Y44ZKCQM1wgUncehFivCL5UnQkg5Fy99Ke3l6WS9iX
         xwWDV2y+BC9u9SCb4SAWM0lQB/nS92EFKPpb3MPyXFDXht34iJsdhodzMGB/qaCQBZjL
         kiWRB8Z/tf7HBLmqFBMnU1aOW1rK3kr6pMUynwjYUWEI/tz7b5UwvQQAbNI5bqZo1OoY
         QvmTdNH9Yuz8H6FkWgp1ZiQOe1x+7qOk18mfTO14dp3oKZgodltV+BdGgucJg6Krm3Rq
         H3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0uBGLEj921E9Pm4+tQgPIwE71cUPiNXUxNvf73v2fb8=;
        b=pY/vbNhb6o3XA/mkCl4SQmLhVY4Ew7XXw0AvmjGbHiEKf5+Tuhi/5VFaFtoE28FVA6
         YN1pSPyTrv1tN7uXNrrB+I+OsVOWVaBdUwrljUhtSbCfXZsCxCibyXt9zbMVancdzrs3
         COJN4lwDT1KSlZ/30TsuziWdXf/6poKv0Hxuuy1qyFUvTIavGDThJnyfzznx8/RVM+WN
         /L2upU/wFvOQl0E9hDYiZiRmiHnxgl847UcX4szq9SzadVUmie/ubfW1UZqKBZHYy04r
         nMdjnPbrsDL4OKHrgl6DQN1ZN3QK477cwG+CAemk0CbhZ+3uVyDZDlIqHleI3X5tAUcL
         TM9Q==
X-Gm-Message-State: APjAAAWlSz+gXfYoXCMAI15Qyt4+eUDd7RTEtCub1FGw1A2SjJL7H9TB
        Yyhkf0JPnlHYXAwNKwD53W4=
X-Google-Smtp-Source: APXvYqy/nQJKW216pYSF3UUDCGCP8Ro7t92YbXITQi/fTgpandV74f0BIUKb/r9hhuwr+6HaA7+gHw==
X-Received: by 2002:a63:9d0f:: with SMTP id i15mr4079476pgd.240.1579872978385;
        Fri, 24 Jan 2020 05:36:18 -0800 (PST)
Received: from [192.168.1.56] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id 7sm6525892pfx.52.2020.01.24.05.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 05:36:17 -0800 (PST)
Subject: Re: [PATCH bpf-next 10/12] tun: run XDP program in tx path
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, jbrouer@redhat.com, toke@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, Prashant Bhole <prashantbhole.linux@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-11-dsahern@kernel.org>
 <20200123032154-mutt-send-email-mst@kernel.org>
From:   Prashant Bhole <bholeprashant.oss@gmail.com>
Message-ID: <ffbc0df2-f65f-d4f8-3ff8-45ca129276d3@gmail.com>
Date:   Fri, 24 Jan 2020 22:36:11 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123032154-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2020 5:23 PM, Michael S. Tsirkin wrote:
> On Wed, Jan 22, 2020 at 06:42:08PM -0700, David Ahern wrote:
>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> Run the XDP program as soon as packet is removed from the ptr
>> ring. Since this is XDP in tx path, the traditional handling of
>> XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
>> do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
>> just runs the program and leaves the action handling to us.
>>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   drivers/net/tun.c | 153 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 150 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index b6bac773f2a0..71bcd4ec2571 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -130,6 +130,7 @@ struct tap_filter {
>>   /* MAX_TAP_QUEUES 256 is chosen to allow rx/tx queues to be equal
>>    * to max number of VCPUs in guest. */
>>   #define MAX_TAP_QUEUES 256
>> +#define MAX_TAP_BATCH 64
>>   #define MAX_TAP_FLOWS  4096
>>   
>>   #define TUN_FLOW_EXPIRE (3 * HZ)
>> @@ -175,6 +176,7 @@ struct tun_file {
>>   	struct tun_struct *detached;
>>   	struct ptr_ring tx_ring;
>>   	struct xdp_rxq_info xdp_rxq;
>> +	void *pkt_ptrs[MAX_TAP_BATCH];
>>   };
>>   
>>   struct tun_page {
>> @@ -2140,6 +2142,107 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>   	return total;
>>   }
>>   
>> +static struct sk_buff *tun_prepare_xdp_skb(struct sk_buff *skb)
>> +{
>> +	struct sk_buff *nskb;
>> +
>> +	if (skb_shared(skb) || skb_cloned(skb)) {
>> +		nskb = skb_copy(skb, GFP_ATOMIC);
>> +		consume_skb(skb);
>> +		return nskb;
>> +	}
>> +
>> +	return skb;
>> +}
>> +
>> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
>> +				 struct sk_buff *skb)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	struct xdp_buff xdp;
>> +	u32 act = XDP_PASS;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
>> +	if (xdp_prog) {
>> +		skb = tun_prepare_xdp_skb(skb);
>> +		if (!skb) {
>> +			act = XDP_DROP;
>> +			kfree_skb(skb);
>> +			goto drop;
>> +		}
>> +
>> +		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
>> +		switch (act) {
>> +		case XDP_TX:
>> +			/* Rx path generic XDP will be called in this path
>> +			 */
>> +			local_bh_disable();
>> +			netif_receive_skb(skb);
>> +			local_bh_enable();
>> +			break;
>> +		case XDP_PASS:
>> +			break;
>> +		case XDP_REDIRECT:
>> +			/* Since we are not handling this case yet, let's free
>> +			 * skb here. In case of XDP_DROP/XDP_ABORTED, the skb
>> +			 * was already freed in do_xdp_generic_core()
>> +			 */
>> +			kfree_skb(skb);
>> +			/* fall through */
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			/* fall through */
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(tun->dev, xdp_prog, act);
>> +			/* fall through */
>> +		case XDP_DROP:
>> +			goto drop;
>> +		}
>> +	}
>> +
>> +	return act;
>> +drop:
>> +	this_cpu_inc(tun->pcpu_stats->tx_dropped);
>> +	return act;
>> +}
>> +
>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>> +			 struct xdp_frame *frame)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	struct xdp_buff xdp;
>> +	u32 act = XDP_PASS;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
>> +	if (xdp_prog) {
>> +		xdp.data_hard_start = frame->data - frame->headroom;
>> +		xdp.data = frame->data;
>> +		xdp.data_end = xdp.data + frame->len;
>> +		xdp.data_meta = xdp.data - frame->metasize;
>> +
>> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +		switch (act) {
>> +		case XDP_PASS:
>> +			break;
>> +		case XDP_TX:
>> +			/* fall through */
>> +		case XDP_REDIRECT:
>> +			/* fall through */
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			/* fall through */
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(tun->dev, xdp_prog, act);
>> +			/* fall through */
>> +		case XDP_DROP:
>> +			xdp_return_frame_rx_napi(frame);
>> +			break;
>> +		}
>> +	}
>> +
>> +	return act;
>> +}
>> +
>>   static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>   {
>>   	DECLARE_WAITQUEUE(wait, current);
>> @@ -2557,6 +2660,52 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>>   	return ret;
>>   }
>>   
>> +static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
>> +{
>> +	void **pkts = tfile->pkt_ptrs;
>> +	struct xdp_frame *frame;
>> +	struct tun_struct *tun;
>> +	int i, num_ptrs;
>> +	int pkt_cnt = 0;
>> +	void *ptr;
>> +	u32 act;
>> +	int batchsz;
>> +
>> +	if (unlikely(!tfile))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	tun = rcu_dereference(tfile->tun);
>> +	if (unlikely(!tun)) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +
>> +	while (n) {
>> +		batchsz = (n > MAX_TAP_BATCH) ? MAX_TAP_BATCH : n;
>> +		n -= batchsz;
>> +		num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts,
>> +						    batchsz);
>> +		if (!num_ptrs)
>> +			break;
> 
> Can't we avoid looping over the packets in the current case
> where there are no xdp programs at all?

That's doable. Thanks.

Prashant
> 
> 
>> +		for (i = 0; i < num_ptrs; i++) {
>> +			ptr = pkts[i];
>> +			if (tun_is_xdp_frame(ptr)) {
>> +				frame = tun_ptr_to_xdp(ptr);
>> +				act = tun_do_xdp_tx(tun, tfile, frame);
>> +			} else {
>> +				act = tun_do_xdp_tx_generic(tun, ptr);
>> +			}
>> +
>> +			if (act == XDP_PASS)
>> +				ptr_array[pkt_cnt++] = ptr;
>> +		}
>> +	}
>> +
>> +	rcu_read_unlock();
>> +	return pkt_cnt;
>> +}
>> +
>>   static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>>   		       int flags)
>>   {
>> @@ -2577,9 +2726,7 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>>   			ptr = ctl->ptr;
>>   			break;
>>   		case TUN_MSG_CONSUME_PKTS:
>> -			ret = ptr_ring_consume_batched(&tfile->tx_ring,
>> -						       ctl->ptr,
>> -						       ctl->num);
>> +			ret = tun_consume_packets(tfile, ctl->ptr, ctl->num);
>>   			goto out;
>>   		case TUN_MSG_UNCONSUME_PKTS:
>>   			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr,
>> -- 
>> 2.21.1 (Apple Git-122.3)
> 
