Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2339B2C8
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhFDGpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229930AbhFDGpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622789012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFnBZB4zBhY3VaJKhaqIVeCmOdORZzd7WJ6m8yQ6LGw=;
        b=AfH7ZHQD7uV3z9LvJH6UmKVx+iJybMlYFwK7mSUrLwm3tf4Z7QOtNsFgAiWVDNhx2+1ti5
        qZRyaEBAYEyeZdh5UjS6xDbVbOxOO6vZkwAu5AiFrokUHWi5g9A3IqGIQnc8s2Pu5uTFW5
        VR5PR/GACmfeOM1lwE6Wiig3boXQpKU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-tW35kQuDPPWiwoWT5WzkIg-1; Fri, 04 Jun 2021 02:43:31 -0400
X-MC-Unique: tW35kQuDPPWiwoWT5WzkIg-1
Received: by mail-pf1-f199.google.com with SMTP id q3-20020aa784230000b02902ea311f25e2so3612030pfn.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 23:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sFnBZB4zBhY3VaJKhaqIVeCmOdORZzd7WJ6m8yQ6LGw=;
        b=B1cVQ4cQCxz0FqVdJ7gFvakETEJHHSRSWq7YEED7QG13d4Mzr9tDBxKHelQxgrPl0T
         EFfcn/+pM6eLNduXQrEer4Tlwd6m/+GaclHuCVMTDU6azzvCj219oz2MedQGGOsNvKNJ
         HpkSFF4cq8jns86TVIkL9ZLH93ruLZN6ZG2w4Y4nUwnnI0VgV3KKyMjZ48I4J633cxJn
         HflnC5Gr4CeYVz0kY3KZr4KPvT5EJkR3gLspFKs62bKgSj/H6PL7e/KOFOVaFpT02Ka7
         h4rSDhMkVOEzWS3EZ+7qaQ+k8x3AOX3N1nIP8QuOJkdfOnw8wDyYHSB5l1u5dzNraYEC
         uh2Q==
X-Gm-Message-State: AOAM5327nhjoLS8MIeJbwYiJ5+jhGR80q2l0e5V4qzyK5fg9DzF/q5R+
        UeKEfVtiNFBiKaUtufae+gQjRMLLgE175aibwqyU/ArsYA/h/9S8AnXRr388AoEm/CDjTvdO4Ge
        AweaNtDgi0Fd/6G+c
X-Received: by 2002:a63:801:: with SMTP id 1mr3397430pgi.146.1622789010477;
        Thu, 03 Jun 2021 23:43:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcsep4lSVrTxiJqAf+9CJZemwxxfkxupalS2zPN+3W0/RqQLyk1fjKvbGcLoAJ74+SjHzCBg==
X-Received: by 2002:a63:801:: with SMTP id 1mr3397401pgi.146.1622789010128;
        Thu, 03 Jun 2021 23:43:30 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m134sm927000pfd.148.2021.06.03.23.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 23:43:29 -0700 (PDT)
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection
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
        Tanner Love <tannerlove@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
 <eef275f7-38c5-6967-7678-57dd5d59cf76@redhat.com>
 <CA+FuTSdEF7dONWZWR3t9EZ5VU3XrfWTb0CmWKe7pQBL-tje0WA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d56a153a-ba13-480f-2ce2-7cbc7fd4c529@redhat.com>
Date:   Fri, 4 Jun 2021 14:43:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdEF7dONWZWR3t9EZ5VU3XrfWTb0CmWKe7pQBL-tje0WA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/4 上午11:51, Willem de Bruijn 写道:
> On Thu, Jun 3, 2021 at 10:55 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/2 上午6:18, Tanner Love 写道:
>>> From: Tanner Love <tannerlove@google.com>
>>>
>>> First patch extends the flow dissector BPF program type to accept
>>> virtio-net header members.
>>>
>>> Second patch uses this feature to add optional flow dissection in
>>> virtio_net_hdr_to_skb(). This allows admins to define permitted
>>> packets more strictly, for example dropping deprecated UDP_UFO
>>> packets.
>>>
>>> Third patch extends kselftest to cover this feature.
>>
>> I wonder why virtio maintainers is not copied in this series.
> Sorry, an oversight.


No problem.


>
>> Several questions:
>>
>> 1) having bpf core to know about virito-net header seems like a layer
>> violation, it doesn't scale as we may add new fields, actually there's
>> already fields that is not implemented in the spec but not Linux right now.
> struct virtio_net_hdr is used by multiple interfaces, not just virtio.
> The interface as is will remain, regardless of additional extensions.
>
> If the interface is extended, the validation can be extended with it.


One possible problem is that there's no sufficient context.

The vnet header length is not a fixed value but depends on the feature 
negotiation. The num_buffers (not implemented in this series) is an 
example. The field doesn't not exist for legacy device if mergeable 
buffer is disabled. If we decide to go with this way, we probably need 
to fix this by introducing a vnet header length.

And I'm not sure it can work for all the future cases e.g the semantic 
of a field may vary depends on the feature negotiated, but maybe it's 
safe since it needs to set the flags.

Another note is that the spec doesn't exclude the possibility to have a 
complete new vnet header format in the future. And the bpf program is 
unaware of any virtio features.


>
> Just curious: can you share what extra fields may be in the pipeline?
> The struct has historically not seen (m)any changes.


For extra fields, I vaguely remember we had some discussions on the 
possible method to extend that, but I forget the actual features.

But spec support RSC which may reuse csum_start/offset but it looks to 
me RSC is not something like Linux need.


>
>> 2) virtio_net_hdr_to_skb() is not the single entry point, packet could
>> go via XDP
> Do you mean AF_XDP?


Yes and kernel XDP as well. If the packet is redirected or transmitted, 
it won't even go to virtio_net_hdr_to_skb().

Since there's no GSO/csum support for XDP, it's probably ok, but needs 
to consider this for the future consider the multi-buffer XDP is being 
developed right now, we can release those restriction.


> As far as I know, vnet_hdr is the only injection
> interface for complex packets that include offload instructions (GSO,
> csum) -- which are the ones mostly implicated in bug reports.


Ideally, if GSO/csum is supported by XDP, it would be more simple to use 
XDP I think.


>
>> 3) I wonder whether we can simply use XDP to solve this issue (metadata
>> probably but I don't have a deep thought)
>> 4) If I understand the code correctly, it should deal with all dodgy
>> packets instead of just for virtio
> Yes. Some callers of virtio_net_hdr_to_skb, such as tun_get_user and
> virtio receive_buf, pass all packets to it. Others, like tap_get_user
> and packet_snd, only call it if a virtio_net_hdr is passed. Once we
> have a validation hook, ideally all packets need to pass it. Modifying
> callers like tap_get_user can be a simple follow-on.


Ok.

Thanks

>

