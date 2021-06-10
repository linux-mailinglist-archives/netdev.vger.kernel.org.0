Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074B73A22FA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFJDzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhFJDzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 23:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623297232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlHeDaRpj14Nh5x7bGrc9HFbf+z4n0+A508Ev0DirBo=;
        b=X/ZpjncnLfjnFod+8HH3Mf5iSHm2GVyJAyIsnI+ILNYGlHDS4f2FfMa0slJn1l+fadNTZ+
        5F8FUbCr/1LIqq8CuzbYdYFmdx8VnXnz5oGkvN/2M6ZegaTeemIj3BLPio89amgOBayPum
        1h9EzHvQzvrPpuZgX4QuKiPYVH7thCk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-QHyOg044P7WQ89HqOKH2Xw-1; Wed, 09 Jun 2021 23:53:51 -0400
X-MC-Unique: QHyOg044P7WQ89HqOKH2Xw-1
Received: by mail-pj1-f72.google.com with SMTP id t8-20020a17090aba88b029016baed73c00so2889746pjr.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 20:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rlHeDaRpj14Nh5x7bGrc9HFbf+z4n0+A508Ev0DirBo=;
        b=Xd+1e+odyxeM71/aiIh3mokQvnZ1DxUDQkggTeRTSr3AEMXQp4b4k3Zg+K0kN4a0TA
         P/9pFRv+e5GR0Ml7CsD3alIIZOin/MV2+LkqQpK71vpEiq3FfMZ6HCcqPl311F2+ncjt
         lS3/XgaISfycfgim0ZQgs/eb3sB3tiK3yZrlB1l5uoGY2S9pPHmZGvcPDmPatSVPzNoL
         LYjwAUivNkrJoAvmQLJgdXiB5anHWOduU3551dnl6V1vtedkirEp0e+ZxuqnuCQ98z34
         jLsnpGFAyXXXVm8TdUjJGb0FDjcGNKlZvhlPB+I44ieQPFbTeocgcXeU0zp8FfZYlm32
         kNyw==
X-Gm-Message-State: AOAM533ngr3u+lJVnQom2Z1gwpZRsDTiZMJrxomdr6fI5xV/XJ+Upa94
        KgVeMQpaGbvRrOJu2tJ4a1fHt1bZ2+7iWXgtjZ1LXFeMH9he8Nskfxn5eIIg2St/TEaoQ1jk8e8
        12+MnTHfNmDMCwRp5
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr1130562pjp.1.1623297230415;
        Wed, 09 Jun 2021 20:53:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz91JY6xpohd4Ejz6oQ06kcY/qW4ulZ5MZqVqJjGhG6SRmlisz8a+C8CKJcQzGPwLLA8f8MWw==
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr1130537pjp.1.1623297230106;
        Wed, 09 Jun 2021 20:53:50 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p11sm1069040pgn.65.2021.06.09.20.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:53:49 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
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
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
 <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com>
Date:   Thu, 10 Jun 2021 11:53:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 上午11:15, Willem de Bruijn 写道:
> On Wed, Jun 9, 2021 at 11:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/9 上午1:02, Tanner Love 写道:
>>>    retry:
>>> -                     if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>>> +                     /* only if flow dissection not already done */
>>> +                     if (!static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
>>> +                         !skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>>>                                                              NULL, 0, 0, 0,
>>>                                                              0)) {
>>
>> So I still wonder the benefit we could gain from reusing the bpf flow
>> dissector here. Consider the only context we need is the flow keys,
> Maybe I misunderstand the comment, but the goal is not just to access
> the flow keys, but to correlate data in the packet payload with the fields
> of the virtio_net_header. E.g., to parse a packet payload to verify that
> it matches the gso type and header length. I don't see how we could
> make that two separate programs, one to parse a packet (flow dissector)
> and one to validate the vnet_hdr.


I may miss something here. I think it could be done via passing flow 
keys built by flow dissectors to vnet header validation eBPF program.

(Looking at validate_vnet_hdr(), it needs only flow keys and skb length).

Having two programs may have other advantages:

1) bpf vnet header validation can work without bpf flow dissector
2) keep bpf flow dissector simpler (unaware of vnet header), otherwise 
you need to prepare a dedicated bpf dissector for virtio-net/tap etc.


>
>> we
>> had two choices
>>
>> a1) embed the vnet header checking inside bpf flow dissector
>> a2) introduce a dedicated eBPF type for doing that
>>
>> And we have two ways to access the vnet header
>>
>> b1) via pesudo __sk_buff
>> b2) introduce bpf helpers
>>
>> I second for a2 and b2. The main motivation is to hide the vnet header
>> details from the bpf subsystem.
> b2 assumes that we might have many different variants of
> vnet_hdr, but that all will be able to back a functional
> interface like "return the header length"?


Probably.


> Historically, the
> struct has not seen such a rapid rate of change that I think
> would warrant introducing this level of indirection.


For the rapid change, yes. But:

1) __sk_buff is part of the general uAPI, adding virtio-net fields looks 
like a layer violation and a duplication to the existing virtio-net uAPI
2) as you said below the vnet header is not self contained
3) using helpers we can make vnet header format transparent to bpf core 
(that's the way how bpf access TCP headers AFAIK)


>
> The little_endian field does demonstrate one form of how
> the struct can be context sensitive -- and not self describing.


Yes and we probably need to provide more context, e.g the negotiated 
features.


>
> I think we can capture multiple variants of the struct, if it ever
> comes to that, with a versioning field. We did not add that
> right away, because that can be introduced later, when a
> new version arrives. But we have a plan for the eventuality.


It works but it couples virtio with bpf.

Thanks


>> Thanks
>>

