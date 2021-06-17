Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFE43AAB99
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 08:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhFQGFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 02:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229565AbhFQGFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 02:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623909820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1zTTNZzldcOXcFO81FD+YymNMfG6CM1iqsPxo2zJvk=;
        b=Qt9u/uL/UE0IHOZ358NOEBIIELPcLT5cv7RvFglXNaIfFuEDRJJjg8ZlcHR0auQ+IFFan1
        HtWdokIzgWOzSY9YH/Lbrqi8cJgSh76jMdvVMF7ERb/UOcvgfMitjavm2PUMSdZfMHNJzP
        RnAGrSdUJBeMr2Fn+cWtwSnNDI54PUQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-gUw8Jk1IMf2aMlapMLucqg-1; Thu, 17 Jun 2021 02:03:39 -0400
X-MC-Unique: gUw8Jk1IMf2aMlapMLucqg-1
Received: by mail-pj1-f71.google.com with SMTP id x2-20020a17090ab002b029016e8b858193so3352657pjq.3
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 23:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=b1zTTNZzldcOXcFO81FD+YymNMfG6CM1iqsPxo2zJvk=;
        b=PQ1DWmZGFMGTNn8qnt6kHIcax4utx7oSVNaJ7xrmQETPxPrgOQqA8RqyVOuvQoMn2K
         eH3IcbjEUE0sIzSQVEnfwp1o7V3AT3SFwpWCeGM95hwexqWGsiqsjIT4fFSV+UcQX4oV
         mT+ivGE7eHIQkUPzm+Izxa3jor4FcAGDotmADDjo8VeUILmZJRz/cXfuoUb5YO44E/31
         J4M1hgaGHrBqJ8ICwuCEJXLCKfbadEQiBSbcCRDdnz0/YbGgC2qnY3+hfMKTn3AIj0EZ
         Tgw6FeUsAujFBF11U01HVGi3pPJF+InojnMeAJ1/fT7h57XU0nATb/Y+Ld7gk1dfbtKc
         9DzQ==
X-Gm-Message-State: AOAM532aH8HAozDlMu3NVfQCcGBqzwqPVSRP0h9XFWQNj4l12ZEfCC18
        2F6QTpajTHxqyNmb79Cn5TkjflaOzmRGAs8KnuNrxIkmO5lEpXCMnOAi5uqPDu+f8BKxjzhRAsR
        kFDfNcLTSPfqwCngt
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr3578820pfn.3.1623909818211;
        Wed, 16 Jun 2021 23:03:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyneNziveW3pKM2kixvqEMieLDf93TnaHSdn5/1L0tRwaQ6XNsum8Lh4E+DvP8zwQ3nj76oZg==
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr3578783pfn.3.1623909817981;
        Wed, 16 Jun 2021 23:03:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 125sm3731545pfg.52.2021.06.16.23.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 23:03:37 -0700 (PDT)
Subject: Re: [PATCH net-next v5 13/15] virtio-net: support AF_XDP zc rx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust.li" <dust.li@linux.alibaba.com>, netdev@vger.kernel.org,
        yuri Benditovich <yuri.benditovich@daynix.com>,
        Andrew Melnychenko <andrew@daynix.com>
References: <1623909234.193789-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0d4c5ff5-2b53-6b55-b5aa-bd943af98bb7@redhat.com>
Date:   Thu, 17 Jun 2021 14:03:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623909234.193789-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/17 下午1:53, Xuan Zhuo 写道:
> On Thu, 17 Jun 2021 11:23:52 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/6/10 下午4:22, Xuan Zhuo 写道:
>>> Compared to the case of xsk tx, the case of xsk zc rx is more
>>> complicated.
>>>
>>> When we process the buf received by vq, we may encounter ordinary
>>> buffers, or xsk buffers. What makes the situation more complicated is
>>> that in the case of mergeable, when num_buffer > 1, we may still
>>> encounter the case where xsk buffer is mixed with ordinary buffer.
>>>
>>> Another thing that makes the situation more complicated is that when we
>>> get an xsk buffer from vq, the xsk bound to this xsk buffer may have
>>> been unbound.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>
>> This is somehow similar to the case of tx where we don't have per vq reset.
>>
>> [...]
>>
>>> -	if (vi->mergeable_rx_bufs)
>>> +	if (is_xsk_ctx(ctx))
>>> +		skb = receive_xsk(dev, vi, rq, buf, len, xdp_xmit, stats);
>>> +	else if (vi->mergeable_rx_bufs)
>>>    		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
>>>    					stats);
>>>    	else if (vi->big_packets)
>>> @@ -1175,6 +1296,14 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>>>    	int err;
>>>    	bool oom;
>>>
>>> +	/* Because virtio-net does not yet support flow direct,
>>
>> Note that this is not the case any more. RSS has been supported by
>> virtio spec and qemu/vhost/tap now. We just need some work on the
>> virtio-net driver part (e.g the ethool interface).
> Oh, are there any plans? Who is doing this work, can I help?


Qemu and spec has support RSS.

TAP support is ready via steering eBPF program, you can try to play it 
with current qemu master.

The only thing missed is the Linux driver, I think Yuri or Andrew is 
working on this.

Thanks


>
> Thanks.
>
>> Thanks
>>
>>

