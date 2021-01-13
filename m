Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18AE2F42D7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbhAMEIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:08:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbhAMEIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:08:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610510815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PxNJxfcBZCn+PYg3zFHkleQNGlx8msMEL+UpPYXTQP8=;
        b=hJRWa2Pjwl60Wplqry1w7sm5a6bdGrwVLrVQojMak0yjnsyESkluD+Z9hLJXJylmaaK17x
        WOjgCs9JL1htMOJo6WZzsYdcoZkqasBv85svWOfLILDd5BccoupamTxiwRGBnr2smdeLjZ
        LqjK6EPButmCiJHxiJDXaAOommT3Wjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-1sf6hBiPPdiBX3Q_hxFfQg-1; Tue, 12 Jan 2021 23:06:08 -0500
X-MC-Unique: 1sf6hBiPPdiBX3Q_hxFfQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FAEC107ACFA;
        Wed, 13 Jan 2021 04:06:04 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 430BA5D9D2;
        Wed, 13 Jan 2021 04:05:48 +0000 (UTC)
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
        cai@lca.pw, Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Yan Vugenfirer <yan@daynix.com>
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
 <CAOEp5Oc5qif_krU8oC6qhq6X0xRW-9GpWrBzWgPw0WevyhT8Mg@mail.gmail.com>
 <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com>
Date:   Wed, 13 Jan 2021 12:05:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/13 上午7:47, Willem de Bruijn wrote:
> On Tue, Jan 12, 2021 at 3:29 PM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
>> On Tue, Jan 12, 2021 at 9:49 PM Yuri Benditovich
>> <yuri.benditovich@daynix.com> wrote:
>>> On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
>>> <yuri.benditovich@daynix.com> wrote:
>>>> Existing TUN module is able to use provided "steering eBPF" to
>>>> calculate per-packet hash and derive the destination queue to
>>>> place the packet to. The eBPF uses mapped configuration data
>>>> containing a key for hash calculation and indirection table
>>>> with array of queues' indices.
>>>>
>>>> This series of patches adds support for virtio-net hash reporting
>>>> feature as defined in virtio specification. It extends the TUN module
>>>> and the "steering eBPF" as follows:
>>>>
>>>> Extended steering eBPF calculates the hash value and hash type, keeps
>>>> hash value in the skb->hash and returns index of destination virtqueue
>>>> and the type of the hash. TUN module keeps returned hash type in
>>>> (currently unused) field of the skb.
>>>> skb->__unused renamed to 'hash_report_type'.
>>>>
>>>> When TUN module is called later to allocate and fill the virtio-net
>>>> header and push it to destination virtqueue it populates the hash
>>>> and the hash type into virtio-net header.
>>>>
>>>> VHOST driver is made aware of respective virtio-net feature that
>>>> extends the virtio-net header to report the hash value and hash report
>>>> type.
>>> Comment from Willem de Bruijn:
>>>
>>> Skbuff fields are in short supply. I don't think we need to add one
>>> just for this narrow path entirely internal to the tun device.
>>>
>> We understand that and try to minimize the impact by using an already
>> existing unused field of skb.
> Not anymore. It was repurposed as a flags field very recently.
>
> This use case is also very narrow in scope. And a very short path from
> data producer to consumer. So I don't think it needs to claim scarce
> bits in the skb.
>
> tun_ebpf_select_queue stores the field, tun_put_user reads it and
> converts it to the virtio_net_hdr in the descriptor.
>
> tun_ebpf_select_queue is called from .ndo_select_queue.  Storing the
> field in skb->cb is fragile, as in theory some code could overwrite
> that between field between ndo_select_queue and
> ndo_start_xmit/tun_net_xmit, from which point it is fully under tun
> control again. But in practice, I don't believe anything does.
>
> Alternatively an existing skb field that is used only on disjoint
> datapaths, such as ingress-only, could be viable.


A question here. We had metadata support in XDP for cooperation between 
eBPF programs. Do we have something similar in the skb?

E.g in the RSS, if we want to pass some metadata information between 
eBPF program and the logic that generates the vnet header (either hard 
logic in the kernel or another eBPF program). Is there any way that can 
avoid the possible conflicts of qdiscs?


>
>>> Instead, you could just run the flow_dissector in tun_put_user if the
>>> feature is negotiated. Indeed, the flow dissector seems more apt to me
>>> than BPF here. Note that the flow dissector internally can be
>>> overridden by a BPF program if the admin so chooses.
>>>
>> When this set of patches is related to hash delivery in the virtio-net
>> packet in general,
>> it was prepared in context of RSS feature implementation as defined in
>> virtio spec [1]
>> In case of RSS it is not enough to run the flow_dissector in tun_put_user:
>> in tun_ebpf_select_queue the TUN calls eBPF to calculate the hash,
>> hash type and queue index
>> according to the (mapped) parameters (key, hash types, indirection
>> table) received from the guest.
> TUNSETSTEERINGEBPF was added to support more diverse queue selection
> than the default in case of multiqueue tun. Not sure what the exact
> use cases are.
>
> But RSS is exactly the purpose of the flow dissector. It is used for
> that purpose in the software variant RPS. The flow dissector
> implements a superset of the RSS spec, and certainly computes a
> four-tuple for TCP/IPv6. In the case of RPS, it is skipped if the NIC
> has already computed a 4-tuple hash.
>
> What it does not give is a type indication, such as
> VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be used.
> In datapaths where the NIC has already computed the four-tuple hash
> and stored it in skb->hash --the common case for servers--, That type
> field is the only reason to have to compute again.


The problem is there's no guarantee that the packet comes from the NIC, 
it could be a simple VM2VM or host2VM packet.

And even if the packet is coming from the NIC that calculates the hash 
there's no guarantee that it's the has that guest want (guest may use 
different RSS keys).

Thanks


>
>> Our intention is to keep the hash and hash type in the skb to populate them
>> into a virtio-net header later in tun_put_user.
>> Note that in this case the type of calculated hash is selected not
>> only from flow dissections
>> but also from limitations provided by the guest.
>>
>> This is already implemented in qemu (for case of vhost=off), see [2]
>> (virtio_net_process_rss)
>> For case of vhost=on there are WIP for qemu to load eBPF and attach it to TUN.
>> Note that exact way of selecting rx virtqueue depends on the guest,
>> it could be automatic steering (typical for Linux VM), RSS (typical
>> for Windows VM) or
>> any other steering mechanism implemented in loadable TUN steering BPF with
>> or without hash calculation.
>>
>> [1] https://github.com/oasis-tcs/virtio-spec/blob/master/content.tex#L3740
>> [2] https://github.com/qemu/qemu/blob/master/hw/net/virtio-net.c#L1591
>>
>>> This also hits on a deeper point with the choice of hash values, that
>>> I also noticed in my RFC patchset to implement the inverse [1][2]. It
>>> is much more detailed than skb->hash + skb->l4_hash currently offers,
>>> and that can be gotten for free from most hardware.
>> Unfortunately in the case of RSS we can't get this hash from the hardware as
>> this requires configuration of the NIC's hardware with key and hash types for
>> Toeplitz hash calculation.
> I don't understand. Toeplitz hash calculation is enabled by default
> for multiqueue devices, and many devices will pass the toeplitz hash
> along for free to avoid software flow dissection.
>
>>> In most practical
>>> cases, that information suffices. I added less specific fields
>>> VIRTIO_NET_HASH_REPORT_L4, VIRTIO_NET_HASH_REPORT_OTHER that work
>>> without explicit flow dissection. I understand that the existing
>>> fields are part of the standard. Just curious, what is their purpose
>>> beyond 4-tuple based flow hashing?
>> The hash is used in combination with the indirection table to select
>> destination rx virtqueue.
>> The hash and hash type are to be reported in virtio-net header, if requested.
>> For Windows VM - in case the device does not report the hash (even if
>> it calculated it to
>> schedule the packet to a proper queue), the driver must do that for each packet
>> (this is a certification requirement).
> I understand the basics of RSS. My question is what the hash-type is
> intended to be used for by the guest. It is part of the virtio spec,
> so this point is somewhat moot: it has to be passed along with the
> hash value now.
>
> But it is not entirely moot. If most users are satisfied with knowing
> whether a hash is L4 or not, we could add two new types
> VIRTIO_NET_HASH_TYPE_L4 and VIRTIO_NET_HASH_TYPE_OTHER. And then pass
> the existing skb->hash as is, likely computed by the NIC.
>
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20201228162233.2032571-2-willemdebruijn.kernel@gmail.com/
>
>>> [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=406859&state=*
>>> [2] https://github.com/wdebruij/linux/commit/0f77febf22cd6ffc242a575807fa8382a26e511e
>>>> Yuri Benditovich (7):
>>>>    skbuff: define field for hash report type
>>>>    vhost: support for hash report virtio-net feature
>>>>    tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
>>>>    tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
>>>>    tun: add ioctl code TUNSETHASHPOPULATION
>>>>    tun: populate hash in virtio-net header when needed
>>>>    tun: report new tun feature IFF_HASH
>>>>
>>>>   drivers/net/tun.c           | 43 +++++++++++++++++++++++++++++++------
>>>>   drivers/vhost/net.c         | 37 ++++++++++++++++++++++++-------
>>>>   include/linux/skbuff.h      |  7 +++++-
>>>>   include/uapi/linux/if_tun.h |  2 ++
>>>>   4 files changed, 74 insertions(+), 15 deletions(-)
>>>>
>>>> --
>>>> 2.17.1
>>>>

