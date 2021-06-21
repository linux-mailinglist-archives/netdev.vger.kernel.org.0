Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573BC3AE349
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhFUGf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFUGf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624257223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssq2+dxO7TxGtEOmndNnWcnA7CPFIvh/ZG1bOb9xGYI=;
        b=LO99R0YmtWHoMyEgnH9uegz0rA+OhAslq+jGM+ic/GjnUIxN8INzbDKUiuoqlNTo5KisOr
        7q0JNM4C6/4vqv4zdLY/q+D2gO9ToWtEQT5lmOujMOhCGkDq4lPlzRO31HluoYKVw3MgS9
        SMe9OU6Necaif30jfh8ECETN7TLEbPQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-0SuqEidKPjynXkgYMW709g-1; Mon, 21 Jun 2021 02:33:42 -0400
X-MC-Unique: 0SuqEidKPjynXkgYMW709g-1
Received: by mail-pl1-f200.google.com with SMTP id l10-20020a17090270cab029011dbfb3981aso4396963plt.22
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 23:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ssq2+dxO7TxGtEOmndNnWcnA7CPFIvh/ZG1bOb9xGYI=;
        b=DgqOAsSEoavrLQIM3Ajw4S67uKeQhuNa+JebHkWwDPsvAvq+7qfZTyrRnL19JZJu2P
         BLsD5zw8jpW5XbeUK9ikqpMLFsolb4dRre+hTctXNpCrLKk+mgdjiGVBfSYZcl4D1FXA
         fOqGcbVEPIDX1+3xlm6PXtu1el7V1x6mX9e4jdrVXweAc9/6I43nQWL5SOrQXzdp6Mb6
         4kHFf3hJCDo9g0edpzwu2aawfKBYhPiRUY7oLZOJc5H0lX28jgiIExXae5M4ObmujcpV
         Dca52LP6J01fufz+Rz2RIzZ4uKYRM4BShxwC4SHTBA6iqMAPeSoMkgaaj0AAIZyxZFLt
         Fgdg==
X-Gm-Message-State: AOAM533DwVuNDHGMv4BtbqmrHRxrhTI9rmDuBz5gTGtS1RWxVoCcIxSC
        h+670Eatywmru3DGZM0Xmj6VLGKoi1B08RXXujUz7fEQ2fNh8VZvNsbDKF3uxCehoe1QTK+zdAK
        onA9vFbhIlAG7Swme
X-Received: by 2002:a17:902:cec3:b029:105:fff1:74ad with SMTP id d3-20020a170902cec3b0290105fff174admr16288317plg.69.1624257221022;
        Sun, 20 Jun 2021 23:33:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI5oZqK9gvNEyU468PY/4LfuDETes1og+ZElIzZsPj8G9i1ikJ6NkUCjcOQGT8+60yjHPIww==
X-Received: by 2002:a17:902:cec3:b029:105:fff1:74ad with SMTP id d3-20020a170902cec3b0290105fff174admr16288297plg.69.1624257220719;
        Sun, 20 Jun 2021 23:33:40 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g3sm13616192pjl.17.2021.06.20.23.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 23:33:40 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com>
 <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
 <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
 <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
 <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com>
 <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com>
 <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
 <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com>
 <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <58202b1c-945d-fc9e-3f24-2f6314d86eaa@redhat.com>
Date:   Mon, 21 Jun 2021 14:33:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/17 下午10:43, Willem de Bruijn 写道:
> On Wed, Jun 16, 2021 at 6:22 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/15 下午10:47, Willem de Bruijn 写道:
>>>>>> Isn't virtio_net_hdr a virito-net specific metadata?
>>>>> I don't think it is ever since it was also adopted for tun, tap,
>>>>> pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.
>>>> For tun/tap it was used to serve the backend of the virtio-net datapath
>>> The purpose of this patch series is to protect the kernel against packets
>>> inserted from userspace, by adding validation at the entry point.
>>>
>>> Agreed that BPF programs can do unspeakable things to packets, but
>>> that is a different issue (with a different trust model), and out of scope.
>>
>> Ok, I think I understand your point, so basically we had two types of
>> untrusted sources for virtio_net_hdr_to_skb():
>>
>> 1) packet injected from userspace: tun, tap, packet
>> 2) packet received from a NIC: virtio-net, uml
>>
>> If I understand correctly, you only care about case 1). But the method
>> could also be used by case 2).
>>
>> For 1) the proposal should work, we only need to care about csum/gso
>> stuffs instead of virtio specific attributes like num_buffers.
>>
>> And 2) is the one that I want to make sure it works as expected since it
>> requires more context to validate and we have other untrusted NICs
> Yes. I did not fully appreciate the two different use cases of this
> interface. For packets entering the the receive stack from a network
> device, I agree that XDP is a suitable drop filter in principle. No
> need for another layer.


So strictly speaking, tuntap is also the path that the packet entering 
the receive stack.


> In practice, the single page constraint is a
> large constraint today. But as you point out multi-buffer is a work in
> progress.


Another advantage is that XDP is per device, but it looks to me flow 
dissector is per ns.


>
>> Ideally, I think XDP is probably the best. It is designed to do such
>> early packet dropping per device. But it misses some important features
>> which makes it can't work today.
>>
>> The method proposed in this patch should work for userspace injected
>> packets, but it may not work very well in the case of XDP in the future.
>> Using another bpf program type may only solve the issue of vnet header
>> coupling with vnet header.
>>
>> I wonder whether or not we can do something in the middle:
>>
>> 1) make sure the flow dissector works even for the case of XDP (note
>> that tun support XDP)
> I think that wherever an XDP program exists in the datapath, that can
> do the filtering, so there is no need for additional flow dissection.


I agree.


>
> If restricting this patch series to the subset of callers that inject
> into the egress path *and* one of them has an XDP hook, the scope for
> this feature set is narrower.


Right, if we don't restrict, we can't prevent user from using this in 2).


>
>> 2) use some general fields instead of virtio-net specific fields, e.g
>> using device header instead of vnet header in the flow keys strcuture
> Can you give an example of what would be in the device header?
>
> Specific for GSO, we have two sets of constants: VIRTIO_NET_HDR_GSO_..
> and SKB_GSO_.. Is the suggestion to replace the current use of the
> first in field flow_keys->virtio_net_hdr.gso_type with the second in
> flow_keys->gso_type?


No, I meant using a general fields like flow_keys->device_hdr. And use 
bpf helpers to access the field.

I think for mitigation, we don't care too much about the performance lose.

Thanks


>

