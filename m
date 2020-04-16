Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E1E1AD377
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 01:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgDPXvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 19:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726326AbgDPXvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 19:51:04 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0977CC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 16:51:02 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id q73so68713qvq.2
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 16:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dE39GiFJA7Z6DdKvJb6x06EC8eVhLQu3+EpL2cR5UuM=;
        b=GUamblLWJHO2F1AvWCVmx9B59odYWkloq3905SpR4C//rubdsVxzQ2OtA1pthlJ7OM
         JrVdVL15OeX/GP/jbnsjspMrFQHhZih+CEa5oZMo8NaYAgJcTE6Oo07X6rQxcyaSPfnz
         mKLWJt+JGCn7Vwzl6lkeiFpMtXKwVcCn8KAYPDi5s8EpOeD31hG552SmHpk0EpGwD9sZ
         +3k6cUYhD0MYY79MKLoLo19V9jOtgfdVKTYBr7SpI92ZsGjpft2bMz0t5aAq1hCMXLh9
         u/gx2SuEgFUYqIj5pfktcTZGUQHhHaR5cUPaZOJunLjEbzwJQ1m58THLWw0p98HkZ4Fr
         Dh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dE39GiFJA7Z6DdKvJb6x06EC8eVhLQu3+EpL2cR5UuM=;
        b=CIL9RFyEmdp6WdktKXNHFSCDpRWl+qyNHbKu9Sxdmg9k5A61kc51H7fIu82Ee0QUUn
         V763RxP2W/WMo0bbBEWd9ANByV3dHRk/aE85H+pzALQ30wUne/3g2hSHoTO511Efr2jq
         Ws1Ejf3tWKAKuWHERIRULqQTNr6quqh0HghY+Qz6VHddWEjDe01KLN9pwn7QzaLkPhCK
         g/6ntIY0wluWPBNsH96IdlNw1VNWbMfDA1aqd10AlUPjxRBoCX/yuP/7HazkRyYcl64q
         Jp3wWpgA282X7mRuEEpoUiRRkTci1Wl2KHW6SQQsZk//c7uHogPLeh0mQXzySY3PFAst
         QZSw==
X-Gm-Message-State: AGi0PubS52PlyZBH9XzAFTSDuXvAiNVqU2z1VErHijVfMg3Gz2ykd8Po
        axK5RsJpmmDUzHdEycKM2L8=
X-Google-Smtp-Source: APiQypK8y0FAa6s51qUNAml3QtC7E9p4x2sq0o7kcRlktQLk4zCtBTWXW0ntFvyLM+pp2moiayymnQ==
X-Received: by 2002:a05:6214:1462:: with SMTP id c2mr185510qvy.202.1587081062131;
        Thu, 16 Apr 2020 16:51:02 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id 11sm14642273qkg.122.2020.04.16.16.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 16:51:01 -0700 (PDT)
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path for
 xdp_frames
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200413171801.54406-1-dsahern@kernel.org>
 <20200413171801.54406-10-dsahern@kernel.org> <87imhzlea3.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a15e955-7018-cb86-e090-e2024f3e0dc9@gmail.com>
Date:   Thu, 16 Apr 2020 17:50:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87imhzlea3.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/20 8:02 AM, Toke Høiland-Jørgensen wrote:
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index 58bdca5d978a..bedecd07d898 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -322,24 +322,33 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>>  {
>>  	struct net_device *dev = bq->dev;
>>  	int sent = 0, drops = 0, err = 0;
>> +	unsigned int count = bq->count;
>>  	int i;
>>  
>> -	if (unlikely(!bq->count))
>> +	if (unlikely(!count))
>>  		return 0;
>>  
>> -	for (i = 0; i < bq->count; i++) {
>> +	for (i = 0; i < count; i++) {
>>  		struct xdp_frame *xdpf = bq->q[i];
>>  
>>  		prefetch(xdpf);
>>  	}
>>  
>> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
>> +	if (static_branch_unlikely(&xdp_egress_needed_key)) {
>> +		count = do_xdp_egress_frame(dev, bq->q, &count);
> 
> nit: seems a bit odd to pass the point to count, then reassign it with
> the return value?

thanks for noticing that. leftover from the evolution of this. changed to
		count = do_xdp_egress_frame(dev, bq->q, count);


>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1bbaeb8842ed..f23dc6043329 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4720,6 +4720,76 @@ u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
>>  }
>>  EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
>>  
>> +static u32 __xdp_egress_frame(struct net_device *dev,
>> +			      struct bpf_prog *xdp_prog,
>> +			      struct xdp_frame *xdp_frame,
>> +			      struct xdp_txq_info *txq)
>> +{
>> +	struct xdp_buff xdp;
>> +	u32 act;
>> +
>> +	xdp.data_hard_start = xdp_frame->data - xdp_frame->headroom;
>> +	xdp.data = xdp_frame->data;
>> +	xdp.data_end = xdp.data + xdp_frame->len;
>> +	xdp_set_data_meta_invalid(&xdp);
> 
> Why invalidate the metadata? On the contrary we'd want metadata from the
> RX side to survive, wouldn't we?

right, replaced with:
	xdp.data_meta = xdp.data - metasize;

> 
>> +	xdp.txq = txq;
>> +
>> +	act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +	act = handle_xdp_egress_act(act, dev, xdp_prog);
>> +
>> +	/* if not dropping frame, readjust pointers in case
>> +	 * program made changes to the buffer
>> +	 */
>> +	if (act != XDP_DROP) {
>> +		int headroom = xdp.data - xdp.data_hard_start;
>> +		int metasize = xdp.data - xdp.data_meta;
>> +
>> +		metasize = metasize > 0 ? metasize : 0;
>> +		if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
>> +			return XDP_DROP;
>> +
>> +		xdp_frame = xdp.data_hard_start;
>> +		xdp_frame->data = xdp.data;
>> +		xdp_frame->len  = xdp.data_end - xdp.data;
>> +		xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>> +		xdp_frame->metasize = metasize;
>> +		/* xdp_frame->mem is unchanged */
>> +	}
>> +
>> +	return act;
>> +}
>> +
>> +unsigned int do_xdp_egress_frame(struct net_device *dev,
>> +				 struct xdp_frame **frames,
>> +				 unsigned int *pcount)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	unsigned int count = *pcount;
>> +
>> +	xdp_prog = rcu_dereference(dev->xdp_egress_prog);
>> +	if (xdp_prog) {
>> +		struct xdp_txq_info txq = { .dev = dev };
> 
> Do you have any thoughts on how to populate this for the redirect case?

not sure I understand. This is the redirect case. ie.., On rx a program
is run, XDP_REDIRECT is returned and the packet is queued. Once the
queue fills or flush is done, bq_xmit_all is called to send the frames.

> I guess using Magnus' HWQ abstraction when that lands? Or did you have
> something different in mind?
> 
