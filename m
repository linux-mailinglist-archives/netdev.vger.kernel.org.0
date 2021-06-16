Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675B03A9729
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhFPKYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:24:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231452AbhFPKYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623838930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Er6kUz8790+muQ3PB8tc8+ZG1+kMRI3s0gS5yNNw3lg=;
        b=fKn0Apf04BuSsIHNysBlJhsvWWYtwXwDv4afsjWvLTtSOKN9amPjacuw5A5QxuYGJpG4sc
        XEeGxTqyc+74dGx7HsAqnVm9VeRxvKchN8rNT4LrrGav0y2VVVF1k2PISjT/rXxO3hAE6V
        dkRD0pPXVep2iKBhMxIUlvpf+pfEPSg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-zvl2GwwyMaivqJYj1-JE-Q-1; Wed, 16 Jun 2021 06:22:09 -0400
X-MC-Unique: zvl2GwwyMaivqJYj1-JE-Q-1
Received: by mail-pf1-f200.google.com with SMTP id j206-20020a6280d70000b02902e9e02e1654so1341960pfd.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Er6kUz8790+muQ3PB8tc8+ZG1+kMRI3s0gS5yNNw3lg=;
        b=E/9I9AzbZo4kaDeTcVwwF2ssStmn1y/dEnO8X4FJjwzoBAtRsVEp/xMEd2/ll4NuT0
         yMgmfeuURc7GP4PHLzedcJDLz82eInmdQNJMhHsGGqq4ERt1wYjD7teoCNVu3NcSlZdD
         15PaqRceH9HUQUK1oIs6hx4R+j/6bRpz0DLYsWy+xPWhj15/Xlo3Aj/nUB3hT86JA91u
         B6sNbr8pdLw53LuoyOijSHAUUG55oy9hJBr8VlbwQ3ZCpayHZ1uBKF6SEu52aoXEppiB
         Hl36xD6G4/PIGotaqd/ssoD6k3P8NH35zrRzb1PyCftk6NS8AejPi4D7ZEdlLZAh4y/7
         uekw==
X-Gm-Message-State: AOAM531Zw/kS44zuSnl86nfmnDf26yJ6AFcQkUyFJqhhkAmvQH1igcHn
        ZLlzUsxNF4KVR/NmcDNFvXQpUYIyg3R6oJied46lGi/3LkGWDvfWw8DlQrD2I7feA4/+7rTD8y0
        5lqWivXl+bDhlx48Z
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr9819585pjn.130.1623838927922;
        Wed, 16 Jun 2021 03:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS4CHzk/WO0m/FVuiqSjGWOiMt4xmNHFK1bTUTFH8+yXAW4aWmF1irWqmcMP3Fje86YVrSJQ==
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr9819550pjn.130.1623838927581;
        Wed, 16 Jun 2021 03:22:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm1797296pfh.182.2021.06.16.03.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 03:22:07 -0700 (PDT)
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
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
 <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com>
Date:   Wed, 16 Jun 2021 18:21:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/15 下午10:47, Willem de Bruijn 写道:
>>>> Isn't virtio_net_hdr a virito-net specific metadata?
>>> I don't think it is ever since it was also adopted for tun, tap,
>>> pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.
>>
>> For tun/tap it was used to serve the backend of the virtio-net datapath
>> which is still virtio-net specific.
>>
>> For pf_packet and uml, they looks more like a byproduct or shortcut of
>> the virtio-net backend (vhost has code to use af_packet, but I'm not
>> whether or not it still work), so still kind of.
>>
>> But the most important thing is that, the semantic of vnet header is
>> defined by virtio spec.
> The packet socket and tuntap interfaces have use cases unrelated
> to virtio. virtio_net_hdr is just a way to egress packets with offloads.
>
> So yes and no. The current definition of struct virtio_net_hdr is part of
> the Linux ABI as is, and used outside virtio.
>
> If virtio changes its spec, let's say to add SO_TXTIME to give an
> example, we may or may not bother to add a pf_packet setsockopt
> to optionally support that.


Right.


>
>>>>> The only metadata that can be passed with tuntap, pf_packet et al is
>>>>> virtio_net_hdr.
>>>>>
>>>>> I quite don't understand where xen-netfront et al come in.
>>>> The problem is, what kind of issue you want to solve. If you want to
>>>> solve virtio specific issue, why do you need to do that in the general
>>>> flow dissector?
>>>>
>>>> If you want to solve the general issue of the packet metadata validation
>>>> from untrusted source, you need validate not only virtio-net but all the
>>>> others. Netfront is another dodgy source and there're a lot of implied
>>>> untrusted source in the case of virtualization environment.
>>> Ah understood.
>>>
>>> Yes, the goal is to protect the kernel from untrusted packets coming
>>> from userspace in general. There are only a handful such injection
>>> APIs.
>> Userspace is not necessarily the source: it could come from a device or
>> BPF.
>>
>> Theoretically, in the case of virtualization/smart NIC, they could be
>> other type of untrusted source. Do we need to validate/mitigate the issues
> Adding packets coming from NICs or BPF programs greatly expands
> the scope.
>
> The purpose of this patch series is to protect the kernel against packets
> inserted from userspace, by adding validation at the entry point.
>
> Agreed that BPF programs can do unspeakable things to packets, but
> that is a different issue (with a different trust model), and out of scope.


Ok, I think I understand your point, so basically we had two types of 
untrusted sources for virtio_net_hdr_to_skb():

1) packet injected from userspace: tun, tap, packet
2) packet received from a NIC: virtio-net, uml

If I understand correctly, you only care about case 1). But the method 
could also be used by case 2).

For 1) the proposal should work, we only need to care about csum/gso 
stuffs instead of virtio specific attributes like num_buffers.

And 2) is the one that I want to make sure it works as expected since it 
requires more context to validate and we have other untrusted NICs


>
>> 1) per source/device like what this patch did, looks like a lot of work
>> 2) validate via the general eBPF facility like XDP which requires
>> multi-buffer and gso/csum support (which we know will happen for sure)
>>
>> ?
> Are you thinking of the XDP support in virtio-net, which is specific
> to that device and does not capture these other uses cases of
> struct virtio_net_hdr_to_skb?


Just to clarify, currently when using XDP, virtio-net will think the 
vnet header is invalid since there's no way to access the vnet header 
and XDP doesn't support s/g, csum and offloads. But I believe in the 
future it will get all those support, and then XDP should have a way to 
access the device specific packet header like vnet header. Assuming all 
of these are ready, virtio_net_hdr_to_skb() is not necessarily called in 
the RX path. This means, we may lose to track some packets if they were 
go via XDP which bypass the validation hooks in virtio_net_hdr_skb().


>
> Or are you okay with the validation hook, but suggesting using
> an XDP program type instead of a flow dissector program type?


Basically, I think the virtio_net_hdr_to_skb() is probably not the best 
place (see above).

I wonder whether XDP is the best place to do that. But XDP has its own 
issues e.g it can't work for packet and macvtap.

Or maybe we can simply tweak this patch to make sure the hooks works 
even if XDP is used.


>
>>> I have not had to deal with netfront as much as the virtio_net_hdr
>>> users. I'll take a look at that and netvsc.
>>
>> For xen, it's interesting that dodgy was set by netfront but not netback.
>>
>>
>>>    I cannot recall seeing as
>>> many syzkaller reports about those, but that may not necessarily imply
>>> that they are more robust -- it could just be that syzkaller has no
>>> easy way to exercise them, like with packet sockets.
>>
>> Yes.
>>
>>
>>>>>> That's why I suggest to use something more
>>>>>> generic like XDP from the start. Yes, GSO stuffs was disabled by
>>>>>> virtio-net on XDP but it's not something that can not be fixed. If the
>>>>>> GSO and s/g support can not be done in short time
>>>>> An alternative interface does not address that we already have this
>>>>> interface and it is already causing problems.
>>>> What problems did you meant here?
>>> The long list of syzkaller bugs that required fixes either directly in
>>> virtio_net_hdr_to_skb or deeper in the stack, e.g.,
>>>
>>> 924a9bc362a5 net: check if protocol extracted by
>>> virtio_net_hdr_set_proto is correct
>>> 6dd912f82680 net: check untrusted gso_size at kernel entry
>>> 9274124f023b net: stricter validation of untrusted gso packets
>>> d2aa125d6290 net: Don't set transport offset to invalid value
>>> d5be7f632bad net: validate untrusted gso packets without csum offload
>>> 9d2f67e43b73 net/packet: fix packet drop as of virtio gso
>>>
>>> 7c68d1a6b4db net: qdisc_pkt_len_init() should be more robust
>>> cb9f1b783850 ip: validate header length on virtual device xmit
>>> 418e897e0716 gso: validate gso_type on ipip style tunnels
>>> 121d57af308d gso: validate gso_type in GSO handlers
>>>
>>> This is not necessarily an exhaustive list.
>>>
>>> And others not directly due to gso/csum metadata, but malformed
>>> packets from userspace nonetheless, such as
>>>
>>> 76c0ddd8c3a6 ip6_tunnel: be careful when accessing the inner header
>>
>> I see. So if I understand correctly, introducing SKB_GSO_DODGY is a
>> balance between security and performance. That is to say, defer the
>> gso/header check until just before they are used. But a lot of codes
>> were not wrote under this assumption (forget to deal with dodgy packets)
>> which breaks things.
> DODGY and requiring robust kernel stack code is part of it, but
>
> Making the core kernel stack robust against bad packets incurs cost on
> every packet for the relatively rare case of these packets coming from
> outside the stack. Ideally, this cost is incurred on such packets
> alone. That's why I prefer validation at the source.
>
> This patch series made it *optional* validation at the source to
> address your concerns about performance regressions. I.e., if you know
> that the path packets will take is robust, such as a simple bridging
> case between VMs, it is perhaps fine to forgo the checks. But egress
> over a physical NIC or even through the kernel egress path (or
> loopback to ingress, which has a different set of expectations) has
> higher integrity requirements.
>
> Not all concerns are GSO, and thus captured by DODGY. Such as truncated hdrlen.


Yes, what I understand that the major use case is the mitigation and we 
still need to make sure the stack is robust.


>
>> So the problem is that, the NIC driver is wrote under the assumption
>> that the gso metadata is correct. I remember there's a kernel CVE
>> (divide by zero) because of the gso_size or other fields several years
>> ago for a driver.
> Right, and more: both NICs and the software stack itself have various
> expectations on input. Such as whether protocol headers are in the
> linear section, or that the csum offset is within bounds.
>
>>> In the case where they are used along with some ABI through which data
>>> can be inserted into the kernel,
>>
>> CPUMAP is something that the data can be inserted into the kernel.
>>
>>
>>> such as AF_XDP, it is relevant. And I
>>> agree that then the XDP program can do the validation directly.
>>>
>>> That just does not address validating of legacy interfaces. Those
>>> interfaces generally require CAP_NET_RAW to setup, but they are often
>>> used after setup to accept untrusted contents, so I don't think they
>>> should be considered "root, so anything goes".
>>
>> I'm not sure I understand the meaning of "legacy" interface here.
> the existing interfaces to insert packets from userspace:
> tuntap/uml/pf_packet/..


Ok.


>
>>
>>>> Thanks
>>> Thanks for the discussion. As said, we'll start by looking at the
>>> other similar netfront interfaces.
>>
>> Thanks, I'm not objecting the goal, but I want to figure out whether
>> it's the best to choice to do that via flow dissector.
> Understood. My main question at this point is whether you are
> suggesting a different bpf program type at the same hooks, or are
> arguing that a XDP-based interface will make all this obsolete.


Ideally, I think XDP is probably the best. It is designed to do such 
early packet dropping per device. But it misses some important features 
which makes it can't work today.

The method proposed in this patch should work for userspace injected 
packets, but it may not work very well in the case of XDP in the future. 
Using another bpf program type may only solve the issue of vnet header 
coupling with vnet header.

I wonder whether or not we can do something in the middle:

1) make sure the flow dissector works even for the case of XDP (note 
that tun support XDP)
2) use some general fields instead of virtio-net specific fields, e.g 
using device header instead of vnet header in the flow keys strcuture

Or if the maintainers are happy with the current method, I don't want to 
block it.

Thanks



>

