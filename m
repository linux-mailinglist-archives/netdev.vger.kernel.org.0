Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1873A799D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhFOI6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:58:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230482AbhFOI6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623747367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+s2ifc74NJCMJa2CG0PdeShLrI+2L59c8fk+vNbuGG0=;
        b=Cbd3eY2hfr9GF9BsMontzRcBzJmR69eaKuiqSYGHc1kdgBbf8VTUD1ldO1w469Ts2snSzs
        F2yS18o2RC1H+cjB7Z0Bzu6fOXv97Z3WiwptvxREGLK47d1+D9N9hj6zHrsfOMYMB9kVzO
        /ZYQ6AD6Lrve8V9eD5awx9Ph/eCVQDQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-L_a6aVpsNyCvMaU4h0Nfjg-1; Tue, 15 Jun 2021 04:56:06 -0400
X-MC-Unique: L_a6aVpsNyCvMaU4h0Nfjg-1
Received: by mail-pf1-f199.google.com with SMTP id q79-20020a6275520000b02902ec76483512so9875961pfc.2
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+s2ifc74NJCMJa2CG0PdeShLrI+2L59c8fk+vNbuGG0=;
        b=R0d80zWetMp19oV2ffsdXqkWZsds2sIWm+ettAGnCQQyRvmabVGfdpZzJee38OnVYz
         /8baMx4z7cjSQSQaeWA2CUlqedTbzXIgdsxIuOKATZg97RqV/Pnc4Ubz1lnGu5g8OUHy
         G6xLiTt1WgQ/bHjTaWN6Mx5RI7CLAX5Ia1csTnmMVZJ0ZeZzIk82JAaVJXG05OK4P9YO
         n965aARMGicTW/NHqCpVYXUvUg2AOS2VYVOPBP+O322uHibgnA8qKxsww9Hvd+DbpFS5
         a0Xql+zDIixES9uLMw38tv28vSnTlCxH8a6Luez/w40dbyr/VsRCKpzu1UmIdSj3ZDf+
         7DNA==
X-Gm-Message-State: AOAM531omvp+oPzYDlhIcgmL0BgbnfWm6/VRLD5cdge2umVXIyD8ypqW
        atSaqADzaVhPRFg+4Nt0J76yHeJ/oaAAxCceuxbC8TN451Gia54IEZjb9prif5vNBJGZaAQpVD0
        SbHICQEU+ANjj/VRW
X-Received: by 2002:a63:ee53:: with SMTP id n19mr21231617pgk.268.1623747365017;
        Tue, 15 Jun 2021 01:56:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycZ94Mh7xNf3ww3MsNuaL/SGN1HuEzV/nUrNRdeRR+9US8W4tj2HlcgJQtRI9jn1lOSm4PUA==
X-Received: by 2002:a63:ee53:: with SMTP id n19mr21231593pgk.268.1623747364591;
        Tue, 15 Jun 2021 01:56:04 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q16sm6223580pfk.209.2021.06.15.01.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 01:56:04 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com>
Date:   Tue, 15 Jun 2021 16:55:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/11 下午10:12, Willem de Bruijn 写道:
> On Thu, Jun 10, 2021 at 11:40 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/11 上午10:45, Willem de Bruijn 写道:
>>> On Thu, Jun 10, 2021 at 10:11 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/6/10 下午10:04, Willem de Bruijn 写道:
>>>>> On Thu, Jun 10, 2021 at 1:25 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/6/10 下午12:19, Alexei Starovoitov 写道:
>>>>>>> On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>> So I wonder why not simply use helpers to access the vnet header like
>>>>>>>> how tcp-bpf access the tcp header?
>>>>>>> Short answer - speed.
>>>>>>> tcp-bpf accesses all uapi and non-uapi structs directly.
>>>>>>>
>>>>>> Ok, this makes sense. But instead of coupling device specific stuffs
>>>>>> like vnet header and neediness into general flow_keys as a context.
>>>>>>
>>>>>> It would be better to introduce a vnet header context which contains
>>>>>>
>>>>>> 1) vnet header
>>>>>> 2) flow keys
>>>>>> 3) other contexts like endian and virtio-net features
>>>>>>
>>>>>> So we preserve the performance and decouple the virtio-net stuffs from
>>>>>> general structures like flow_keys or __sk_buff.
>>>>> You are advocating for a separate BPF program that takes a vnet hdr
>>>>> and flow_keys as context and is run separately after flow dissection?
>>>> Yes.
>>>>
>>>>
>>>>> I don't understand the benefit of splitting the program in two in this manner.
>>>> It decouples a device specific attributes from the general structures
>>>> like flow keys. We have xen-netfront, netvsc and a lot of drivers that
>>>> works for the emulated devices. We could not add all those metadatas as
>>>> the context of flow keys.
>>> What are device-specific attributes here? What kind of metadata?
>>
>> Isn't virtio_net_hdr a virito-net specific metadata?
> I don't think it is ever since it was also adopted for tun, tap,
> pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.


For tun/tap it was used to serve the backend of the virtio-net datapath 
which is still virtio-net specific.

For pf_packet and uml, they looks more like a byproduct or shortcut of 
the virtio-net backend (vhost has code to use af_packet, but I'm not 
whether or not it still work), so still kind of.

But the most important thing is that, the semantic of vnet header is 
defined by virtio spec.


>
>>
>>> The only metadata that can be passed with tuntap, pf_packet et al is
>>> virtio_net_hdr.
>>>
>>> I quite don't understand where xen-netfront et al come in.
>>
>> The problem is, what kind of issue you want to solve. If you want to
>> solve virtio specific issue, why do you need to do that in the general
>> flow dissector?
>>
>> If you want to solve the general issue of the packet metadata validation
>> from untrusted source, you need validate not only virtio-net but all the
>> others. Netfront is another dodgy source and there're a lot of implied
>> untrusted source in the case of virtualization environment.
> Ah understood.
>
> Yes, the goal is to protect the kernel from untrusted packets coming
> from userspace in general. There are only a handful such injection
> APIs.

Userspace is not necessarily the source: it could come from a device or 
BPF.

Theoretically, in the case of virtualization/smart NIC, they could be 
other type of untrusted source. Do we need to validate/mitigate the issues

1) per source/device like what this patch did, looks like a lot of work
2) validate via the general eBPF facility like XDP which requires 
multi-buffer and gso/csum support (which we know will happen for sure)

?


>
> I have not had to deal with netfront as much as the virtio_net_hdr
> users. I'll take a look at that and netvsc.


For xen, it's interesting that dodgy was set by netfront but not netback.


>   I cannot recall seeing as
> many syzkaller reports about those, but that may not necessarily imply
> that they are more robust -- it could just be that syzkaller has no
> easy way to exercise them, like with packet sockets.


Yes.


>
>>>> That's why I suggest to use something more
>>>> generic like XDP from the start. Yes, GSO stuffs was disabled by
>>>> virtio-net on XDP but it's not something that can not be fixed. If the
>>>> GSO and s/g support can not be done in short time
>>> An alternative interface does not address that we already have this
>>> interface and it is already causing problems.
>>
>> What problems did you meant here?
> The long list of syzkaller bugs that required fixes either directly in
> virtio_net_hdr_to_skb or deeper in the stack, e.g.,
>
> 924a9bc362a5 net: check if protocol extracted by
> virtio_net_hdr_set_proto is correct
> 6dd912f82680 net: check untrusted gso_size at kernel entry
> 9274124f023b net: stricter validation of untrusted gso packets
> d2aa125d6290 net: Don't set transport offset to invalid value
> d5be7f632bad net: validate untrusted gso packets without csum offload
> 9d2f67e43b73 net/packet: fix packet drop as of virtio gso
>
> 7c68d1a6b4db net: qdisc_pkt_len_init() should be more robust
> cb9f1b783850 ip: validate header length on virtual device xmit
> 418e897e0716 gso: validate gso_type on ipip style tunnels
> 121d57af308d gso: validate gso_type in GSO handlers
>
> This is not necessarily an exhaustive list.
>
> And others not directly due to gso/csum metadata, but malformed
> packets from userspace nonetheless, such as
>
> 76c0ddd8c3a6 ip6_tunnel: be careful when accessing the inner header


I see. So if I understand correctly, introducing SKB_GSO_DODGY is a 
balance between security and performance. That is to say, defer the 
gso/header check until just before they are used. But a lot of codes 
were not wrote under this assumption (forget to deal with dodgy packets) 
which breaks things.


>
>>>> then a virtio-net
>>>> specific BPF program still looks much better than coupling virtio-net
>>>> metadata into flow keys or other general data structures.
>>>>
>>>>
>>>>> Your previous comment mentions two vnet_hdr definitions that can get
>>>>> out of sync. Do you mean v1 of this patch, that adds the individual
>>>>> fields to bpf_flow_dissector?
>>>> No, I meant this part of the patch:
>>>>
>>>>
>>>> +static int check_virtio_net_hdr_access(struct bpf_verifier_env *env,
>>>> int off,
>>>> +                       int size)
>>>> +{
>>>> +    if (size < 0 || off < 0 ||
>>>> +        (u64)off + size > sizeof(struct virtio_net_hdr)) {
>>>> +        verbose(env, "invalid access to virtio_net_hdr off=%d size=%d\n",
>>>> +            off, size);
>>>> +        return -EACCES;
>>>> +    }
>>>> +    return 0;
>>>> +}
>>>> +
>>>>
>>>>
>>>> It prevents the program from accessing e.g num_buffers.
>>> I see, thanks. See my response to your following point.
>>>
>>>>> That is no longer the case: the latest
>>>>> version directly access the real struct. As Alexei points out, doing
>>>>> this does not set virtio_net_hdr in stone in the ABI. That is a valid
>>>>> worry. But so this patch series will not restrict how that struct may
>>>>> develop over time. A version field allows a BPF program to parse the
>>>>> different variants of the struct -- in the same manner as other
>>>>> protocol headers.
>>>> The format of the virtio-net header depends on the virtio features, any
>>>> reason for another version? The correct way is to provide features in
>>>> the context, in this case you don't event need the endian hint.
>>> That might work. It clearly works for virtio. Not sure how to apply it
>>> to pf_packet or tuntap callers of virtio_net_hdr_to_skb.
>>
>> This requires more thought but it also applies to the version. For
>> tuntap, features could be deduced from the 1) TUN_SET_VET_HDR and 2)
>> TUN_SET_OFFLOADS
>>
>> Note that theatrically features could be provided by the userspace, but
>> version is not (unless it's a part of uAPI but it became a duplication
>> of the features).
>>
>> Actually, this is a strong hint that the conext for packet, tuntap is
>> different with virtio-net (though they are sharing the same (or patial)
>> vnet header structure). E.g tuntap is unaware of mergerable buffers, it
>> just leave the room for vhost-net or qemu to fill that fields.
> True. We need to pass the length of the struct along with any
> version/typing information (which is currently only that endianness
> boolean). Also to address the bounds checking issue you raised above.


For packet socket, it's work probably via assuming a fixed set of feature.


>>>>> If you prefer, we can add that field from the start.
>>>>> I don't see a benefit to an extra layer of indirection in the form of
>>>>> helper functions.
>>>>>
>>>>> I do see downsides to splitting the program. The goal is to ensure
>>>>> consistency between vnet_hdr and packet payload. A program split
>>>>> limits to checking vnet_hdr against what the flow_keys struct has
>>>>> extracted. That is a great reduction over full packet access.
>>>> Full packet access could be still done in bpf flow dissector.
>>>>
>>>>
>>>>> For
>>>>> instance, does the packet contain IP options? No idea.
>>>> I don't understand here. You can figure out this in flow dissector, and
>>>> you can extend the flow keys to carry out this information if necessary.
>>> This I disagree with. flow_keys are a distillation/simplification of
>>> the packet contents. It is unlikely to capture every feature of every
>>> packet.
>>
>> It depends on what kind of checks you want to do. When introducing a new
>> API like this, we need to make sure all the fields could be validated
>> instead of limiting it to some specific fields. Not all the fields are
>> related to the flow, that's another point that validating it in the flow
>> dissector is not a good choice.
>>
>> For vnet_header fields that is related to the flow, they should be a
>> subset of the current flow keys otherwise it's a hint a flow keys need
>> to be extended. For vnet_header fields that is not related to the flow,
>> validate it in flow dissector requires a lot of other context (features,
>> and probably the virtqueue size for the num_buffers). And if you want to
>> validate things that is totally unrelated to the vnet header (e.g IP
>> option), it can be done in the flow dissector right now or via XDP.
> But correlating this data with the metadata is needlessly more complex
> with two programs vs one. The issue is not that flow keys can capture
> all vnet_hdr fields. It is that it won't capture all relevant packet
> contents.
>
>>>    We end up having to extend it for every new case we're
>>> interested in. That is ugly and a lot of busywork. And for what
>>> purpose? The virtio_net_hdr field prefaces the protocol headers in the
>>> same buffer in something like tpacket. Processing the metadata
>>> together with the data is straightforward. I don't see what isolation
>>> or layering that breaks.
>>
>> Well, if you want to process metadata with the data, isn't XDP a much
>> more better place to do that?
> XDP or bpf flow dissector: they are both BPF programs. The defining
> point is what context to pass along.


I think XDP covers the use cases here and XDP can do more than just flow 
dissection.

A minor issue is that XDP doesn't work for af_packet, but it's not hard 
to add.

(Assuming XDP has multi-buffer support).


>
>>>> And if you want to have more capability, XDP which is designed for early
>>>> packet filtering is the right way to go which have even more functions
>>>> that a simple bpf flow dissector.
>>>>
>>>>> If stable ABI is not a concern and there are no different struct
>>>>> definitions that can go out of sync, does that address your main
>>>>> concerns?
>>>> I think not. Assuming we provide sufficient contexts (e.g the virtio
>>>> features), problem still: 1) coupling virtio-net with flow_keys
>>> A flow dissection program is allowed to read both contents of struct
>>> virtio_net_hdr and packet contents. virtio_net_hdr is not made part of
>>> struct bpf_flow_keys.
>>
>> It doesn't matter whether or not it's a pointer. And actually you had
>> vhdr_is_little_endian:
>>
>> @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
>>          };
>>          __u32   flags;
>>          __be32  flow_label;
>> +       __bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
>> +       __u8    vhdr_is_little_endian;
>>    };
>>
>>
>> And if we want to add the support to validate other untrusted sources,
>> do we want:
>>
>> struct bpf_flow_keys {
>>       /* general fields */
>>       virtio_net_context;
>>       xen_netfront_context;
>>       netvsc_context;
>>       ...
>> };
>>
>> ?
> No, I think just a pointer to the metadata context and a
> type/versioning field that tells the program how to interpret it. A
> strict program can drop everything that it does not understand. It
> does not have to be complete.


Yes, but still a kind of coupling consider we have a way to have this. (XDP)


>
>>>    The pointer there is just a way to give access
>>> to multiple data sources through the single bpf program context.
>>>
>>>> 2) can't work for XDP.
>>> This future work (AF_?)XDP based alternative to
>>> pf_packet/tuntap/virtio does not exist yet, so it's hard to fully
>>> prepare for. But any replacement interface will observe the same
>>> issue: when specifying offloads like GSO/csum, that metadata may not
>>> agree with actual packet contents. We have to have a way to validate
>>> that. I could imagine that this XDP program attached to the AF_XDP
>>> interface would do the validation itself?
>>
>> If the XDP can do validation itself, any reason to duplicate the work in
>> the flow dissector?
>>
>>
>>> Is that what you mean?
>>
>> Kind of, it's not specific to AF_XDP, assuming XDP supports GSO/sg. With
>> XDP_REDIRECT/XDP_TX, you still need to validate the vnet header.
> The purpose is validation of data coming from untrusted userspace into
> the kernel.
>
> XDP_REDIRECT and XDP_TX forward data within the kernel, so are out of scope.


So the problem is that, the NIC driver is wrote under the assumption 
that the gso metadata is correct. I remember there's a kernel CVE 
(divide by zero) because of the gso_size or other fields several years 
ago for a driver.


>
> In the case where they are used along with some ABI through which data
> can be inserted into the kernel,


CPUMAP is something that the data can be inserted into the kernel.


> such as AF_XDP, it is relevant. And I
> agree that then the XDP program can do the validation directly.
>
> That just does not address validating of legacy interfaces. Those
> interfaces generally require CAP_NET_RAW to setup, but they are often
> used after setup to accept untrusted contents, so I don't think they
> should be considered "root, so anything goes".


I'm not sure I understand the meaning of "legacy" interface here.


>
>> Thanks
> Thanks for the discussion. As said, we'll start by looking at the
> other similar netfront interfaces.


Thanks, I'm not objecting the goal, but I want to figure out whether 
it's the best to choice to do that via flow dissector.


>

