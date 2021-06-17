Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0A23AACD5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 08:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhFQHA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:00:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhFQHAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623913127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOaHdq19h0FHSg5bZ7nKKung5JqY0zRI7wk+b6EfG4M=;
        b=Wm1J0GSQE+gTwtSKw6+ox5SY4OIAp+47miW3uBSoawh00mXxk9GEsF+S3AmSkk2nwZO4cM
        W+1F4JE2M+FcIgvdR1xOmh8hpwVNJphjDrCdsKmCk8sQlZNIOpiQoUSpupqqjnUsFv5td2
        6JgfvQznCsIXw6l8sV09s6sFf7u78Jk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-i-XRvXsnO2mbIvmmEiSvAw-1; Thu, 17 Jun 2021 02:58:46 -0400
X-MC-Unique: i-XRvXsnO2mbIvmmEiSvAw-1
Received: by mail-pl1-f199.google.com with SMTP id 62-20020a1709020544b0290116739a77a4so1362747plf.7
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 23:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oOaHdq19h0FHSg5bZ7nKKung5JqY0zRI7wk+b6EfG4M=;
        b=nLQoGTWaSgC/K2qEzqgADaywY4on51wEe399FM80KDTA89qk1eMerBkl5o1n5olEuC
         +A7hzdmGUSfMlJcmaQ5Fd9tZH9rJGT5dwDc9SyNp3tSw8/RDzmvp/FH07RlmKJMmeJvq
         YrNdxst1j3865U6rFIXxqMor+VJ167TB+YcivwcJd+yCItwnKUQmWTgK93bIQWTzbrdw
         1Zi9XkCns27KwgKclgUiqun7iJxBcdRNh80MwH4Huls3aYK588NBYHAlODfekQrYE+Iy
         aFGYZIkESJR7yHifu7hIlnmgKzxv2FnZlr8fNknWP81PZcOkjJriml7nOfIX+yuXJA5X
         rYjg==
X-Gm-Message-State: AOAM532m/IGx0p4WZURViipWRqPkwqYB4rTo/dRe05tCAWPn7NVSzrvl
        q2373xG3bxfOjgNoG5U1ZAnnOIeG/sX6w2OQoVEfasRIanH+4TAG/I195KYSS7NgelxhNRijf5L
        OlxUh615OV8H61h0b
X-Received: by 2002:a63:7c08:: with SMTP id x8mr3610828pgc.184.1623913125087;
        Wed, 16 Jun 2021 23:58:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwUSnD5cuh7xbAATrzKhJmHrpLZfoxOlAvgZTAR0bzrEOjJocAZWmX4wUY/0QaEbPCp+cKsg==
X-Received: by 2002:a63:7c08:: with SMTP id x8mr3610801pgc.184.1623913124900;
        Wed, 16 Jun 2021 23:58:44 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j10sm930961pjz.36.2021.06.16.23.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 23:58:44 -0700 (PDT)
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
References: <1623911825.4660118-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a8f79a9d-1328-f5e8-167b-4eda844c52ca@redhat.com>
Date:   Thu, 17 Jun 2021 14:58:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623911825.4660118-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/17 下午2:37, Xuan Zhuo 写道:
> On Thu, 17 Jun 2021 14:03:29 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/6/17 下午1:53, Xuan Zhuo 写道:
>>> On Thu, 17 Jun 2021 11:23:52 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/6/10 下午4:22, Xuan Zhuo 写道:
>>>>> Compared to the case of xsk tx, the case of xsk zc rx is more
>>>>> complicated.
>>>>>
>>>>> When we process the buf received by vq, we may encounter ordinary
>>>>> buffers, or xsk buffers. What makes the situation more complicated is
>>>>> that in the case of mergeable, when num_buffer > 1, we may still
>>>>> encounter the case where xsk buffer is mixed with ordinary buffer.
>>>>>
>>>>> Another thing that makes the situation more complicated is that when we
>>>>> get an xsk buffer from vq, the xsk bound to this xsk buffer may have
>>>>> been unbound.
>>>>>
>>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>> This is somehow similar to the case of tx where we don't have per vq reset.
>>>>
>>>> [...]
>>>>
>>>>> -	if (vi->mergeable_rx_bufs)
>>>>> +	if (is_xsk_ctx(ctx))
>>>>> +		skb = receive_xsk(dev, vi, rq, buf, len, xdp_xmit, stats);
>>>>> +	else if (vi->mergeable_rx_bufs)
>>>>>     		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
>>>>>     					stats);
>>>>>     	else if (vi->big_packets)
>>>>> @@ -1175,6 +1296,14 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>>>>>     	int err;
>>>>>     	bool oom;
>>>>>
>>>>> +	/* Because virtio-net does not yet support flow direct,
>>>> Note that this is not the case any more. RSS has been supported by
>>>> virtio spec and qemu/vhost/tap now. We just need some work on the
>>>> virtio-net driver part (e.g the ethool interface).
>>> Oh, are there any plans? Who is doing this work, can I help?
>>
>> Qemu and spec has support RSS.
>>
>> TAP support is ready via steering eBPF program, you can try to play it
>> with current qemu master.
>>
>> The only thing missed is the Linux driver, I think Yuri or Andrew is
>> working on this.
> I feel that in the case of xsk, the flow director is more appropriate.
>
> Users may still want to allocate packets to a certain channel based on
> information such as port/ip/tcp/udp, and then xsk will process them.
>
> I will try to push the flow director to the spec.


That would be fine. For the backend implementation, it could still be 
implemented via steering eBPF.

Thanks


>
> Thanks.
>
>> Thanks
>>
>>
>>> Thanks.
>>>
>>>> Thanks
>>>>
>>>>

