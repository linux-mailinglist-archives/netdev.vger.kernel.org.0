Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20631AD9C9
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgDQJZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:25:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730169AbgDQJZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587115520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZzCCwAaCf8W1JnKQba6xwypKbmkImvL1CWKMe7sxt8=;
        b=FfcEw4uFOORJYDSqGhe8PQkvthPtn3EQKYdk7b0mjgN3GHCOq2x/55dhUPQPyCqcJz+pU2
        cXfzzoB6bqy8tPVsgcj6XC6yF6A5BmJmlSHtjyIts9h8HN+J0SAfm6jwzpaSJRtpo2l71Z
        7BD40PXEm+vSgw+HGf4CTCm9zAVBwl0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-9rk6TgZ0MFCp9Iq_oTe-aA-1; Fri, 17 Apr 2020 05:25:13 -0400
X-MC-Unique: 9rk6TgZ0MFCp9Iq_oTe-aA-1
Received: by mail-lj1-f198.google.com with SMTP id d25so155664ljo.4
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 02:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DZzCCwAaCf8W1JnKQba6xwypKbmkImvL1CWKMe7sxt8=;
        b=N6YRFmSXw1q56PWO8MwVpQza33RrxNxswcYGM9qcsDu4w0BREzSttg4ErET5xmr2qZ
         sZeIO2r//HHGdFXQ5f5Lyejf9MDqqYKfjxFC/jiCN6AfHATrqPjpyv+SlVY7GEi6eXIk
         vH/FHJPYwevg8/iMXGd9xHv9TxXtpAZ5F42pYic4aAMbcsm1t3+7XhdWQN0cMA65nIjJ
         P8XNC7FaqT8wePW2AlokOAPF8uJs6ZlVF56K5ryPhoJtglcBivkN25K9/mNmo5sv3Poh
         07tsKSdp7zmp1PzQz8ZoNXDD/mQhDTkwvjayzAJCohuZzihrmQp41HFqUthCS3U9mvP8
         AB1w==
X-Gm-Message-State: AGi0PuZenOaGr3zLGFZ/kCioc59AlrPD8QhApgak9P0ERU8xBsoakHHv
        8tPIH9ipu6Kd2yuxEPa3Zz2XtS9TLr4bEtSkSh0558+B6cBn2Oqec4ulFrSFcHjiJoXI2FWserF
        zmza8cHw2/Y2o/jeV
X-Received: by 2002:a05:6512:10c9:: with SMTP id k9mr1442048lfg.183.1587115512219;
        Fri, 17 Apr 2020 02:25:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJCnG5CEfRII/stHNsAuv3o/vCjWz9/cNzAt0zWQRIvmBCSMQcql1XcDdYZH0LO7W4QFGDkGQ==
X-Received: by 2002:a05:6512:10c9:: with SMTP id k9mr1442030lfg.183.1587115511975;
        Fri, 17 Apr 2020 02:25:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r21sm17124041ljp.29.2020.04.17.02.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 02:25:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BCEBE181587; Fri, 17 Apr 2020 11:25:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path for xdp_frames
In-Reply-To: <1a15e955-7018-cb86-e090-e2024f3e0dc9@gmail.com>
References: <20200413171801.54406-1-dsahern@kernel.org> <20200413171801.54406-10-dsahern@kernel.org> <87imhzlea3.fsf@toke.dk> <1a15e955-7018-cb86-e090-e2024f3e0dc9@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Apr 2020 11:25:10 +0200
Message-ID: <877dyelb0p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/16/20 8:02 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>>> index 58bdca5d978a..bedecd07d898 100644
>>> --- a/kernel/bpf/devmap.c
>>> +++ b/kernel/bpf/devmap.c
>>> @@ -322,24 +322,33 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue =
*bq, u32 flags)
>>>  {
>>>  	struct net_device *dev =3D bq->dev;
>>>  	int sent =3D 0, drops =3D 0, err =3D 0;
>>> +	unsigned int count =3D bq->count;
>>>  	int i;
>>>=20=20
>>> -	if (unlikely(!bq->count))
>>> +	if (unlikely(!count))
>>>  		return 0;
>>>=20=20
>>> -	for (i =3D 0; i < bq->count; i++) {
>>> +	for (i =3D 0; i < count; i++) {
>>>  		struct xdp_frame *xdpf =3D bq->q[i];
>>>=20=20
>>>  		prefetch(xdpf);
>>>  	}
>>>=20=20
>>> -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
>>> +	if (static_branch_unlikely(&xdp_egress_needed_key)) {
>>> +		count =3D do_xdp_egress_frame(dev, bq->q, &count);
>>=20
>> nit: seems a bit odd to pass the point to count, then reassign it with
>> the return value?
>
> thanks for noticing that. leftover from the evolution of this. changed to
> 		count =3D do_xdp_egress_frame(dev, bq->q, count);

Thought it might be. Great!

>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 1bbaeb8842ed..f23dc6043329 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -4720,6 +4720,76 @@ u32 do_xdp_egress_skb(struct net_device *dev, st=
ruct sk_buff *skb)
>>>  }
>>>  EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
>>>=20=20
>>> +static u32 __xdp_egress_frame(struct net_device *dev,
>>> +			      struct bpf_prog *xdp_prog,
>>> +			      struct xdp_frame *xdp_frame,
>>> +			      struct xdp_txq_info *txq)
>>> +{
>>> +	struct xdp_buff xdp;
>>> +	u32 act;
>>> +
>>> +	xdp.data_hard_start =3D xdp_frame->data - xdp_frame->headroom;
>>> +	xdp.data =3D xdp_frame->data;
>>> +	xdp.data_end =3D xdp.data + xdp_frame->len;
>>> +	xdp_set_data_meta_invalid(&xdp);
>>=20
>> Why invalidate the metadata? On the contrary we'd want metadata from the
>> RX side to survive, wouldn't we?
>
> right, replaced with:
> 	xdp.data_meta =3D xdp.data - metasize;

OK.

>>=20
>>> +	xdp.txq =3D txq;
>>> +
>>> +	act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>>> +	act =3D handle_xdp_egress_act(act, dev, xdp_prog);
>>> +
>>> +	/* if not dropping frame, readjust pointers in case
>>> +	 * program made changes to the buffer
>>> +	 */
>>> +	if (act !=3D XDP_DROP) {
>>> +		int headroom =3D xdp.data - xdp.data_hard_start;
>>> +		int metasize =3D xdp.data - xdp.data_meta;
>>> +
>>> +		metasize =3D metasize > 0 ? metasize : 0;
>>> +		if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
>>> +			return XDP_DROP;
>>> +
>>> +		xdp_frame =3D xdp.data_hard_start;
>>> +		xdp_frame->data =3D xdp.data;
>>> +		xdp_frame->len  =3D xdp.data_end - xdp.data;
>>> +		xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
>>> +		xdp_frame->metasize =3D metasize;
>>> +		/* xdp_frame->mem is unchanged */
>>> +	}
>>> +
>>> +	return act;
>>> +}
>>> +
>>> +unsigned int do_xdp_egress_frame(struct net_device *dev,
>>> +				 struct xdp_frame **frames,
>>> +				 unsigned int *pcount)
>>> +{
>>> +	struct bpf_prog *xdp_prog;
>>> +	unsigned int count =3D *pcount;
>>> +
>>> +	xdp_prog =3D rcu_dereference(dev->xdp_egress_prog);
>>> +	if (xdp_prog) {
>>> +		struct xdp_txq_info txq =3D { .dev =3D dev };
>>=20
>> Do you have any thoughts on how to populate this for the redirect case?
>
> not sure I understand. This is the redirect case. ie.., On rx a program
> is run, XDP_REDIRECT is returned and the packet is queued. Once the
> queue fills or flush is done, bq_xmit_all is called to send the
> frames.

I just meant that eventually we'd want to populate xdp_txq_info with a
TX HWQ index (and possibly other stuff), right? So how do you figure
we'd get that information at this call site?

-Toke

