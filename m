Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F369E2F97EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 03:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbhARCs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 21:48:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730998AbhARCsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 21:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610938017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6ekTaCUkKdjepJubjr84NceoQSjqFD24PhaaJLdYi8=;
        b=X3jrm6aCp2fmHuVv4/5glyoku801RZqSXgCHfF0vQURec625XSoUPcHoumkkw5zVc9MOSy
        lUDH5V2VZzgzLEdEm785coWL7T1fXs2EY0ejB9A1ONPZeqbnovVS7MuZ8RKjGrZD2vRJx9
        SxapfmzK0QlTDidTDZaL/AaTa1eC+ws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-HGDmO5YxNpSzg8ZGWPAqfQ-1; Sun, 17 Jan 2021 21:46:53 -0500
X-MC-Unique: HGDmO5YxNpSzg8ZGWPAqfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B343107ACE3;
        Mon, 18 Jan 2021 02:46:49 +0000 (UTC)
Received: from [10.72.13.12] (ovpn-13-12.pek2.redhat.com [10.72.13.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 466675C6AB;
        Mon, 18 Jan 2021 02:46:33 +0000 (UTC)
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
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
 <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com>
 <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
 <8ea218a8-a068-1ed9-929d-67ad30111c3c@redhat.com>
 <CAOEp5OfyHz2rXHmOeojNNE2wvrHMn_z1egr5aGQborEq829TLw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <65fe1a40-abc0-77ed-56df-3f0a70615016@redhat.com>
Date:   Mon, 18 Jan 2021 10:46:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOEp5OfyHz2rXHmOeojNNE2wvrHMn_z1egr5aGQborEq829TLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/17 下午3:57, Yuri Benditovich wrote:
> On Thu, Jan 14, 2021 at 5:39 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/1/13 下午10:33, Willem de Bruijn wrote:
>>> On Tue, Jan 12, 2021 at 11:11 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/1/13 上午7:47, Willem de Bruijn wrote:
>>>>> On Tue, Jan 12, 2021 at 3:29 PM Yuri Benditovich
>>>>> <yuri.benditovich@daynix.com> wrote:
>>>>>> On Tue, Jan 12, 2021 at 9:49 PM Yuri Benditovich
>>>>>> <yuri.benditovich@daynix.com> wrote:
>>>>>>> On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
>>>>>>> <yuri.benditovich@daynix.com> wrote:
>>>>>>>> Existing TUN module is able to use provided "steering eBPF" to
>>>>>>>> calculate per-packet hash and derive the destination queue to
>>>>>>>> place the packet to. The eBPF uses mapped configuration data
>>>>>>>> containing a key for hash calculation and indirection table
>>>>>>>> with array of queues' indices.
>>>>>>>>
>>>>>>>> This series of patches adds support for virtio-net hash reporting
>>>>>>>> feature as defined in virtio specification. It extends the TUN module
>>>>>>>> and the "steering eBPF" as follows:
>>>>>>>>
>>>>>>>> Extended steering eBPF calculates the hash value and hash type, keeps
>>>>>>>> hash value in the skb->hash and returns index of destination virtqueue
>>>>>>>> and the type of the hash. TUN module keeps returned hash type in
>>>>>>>> (currently unused) field of the skb.
>>>>>>>> skb->__unused renamed to 'hash_report_type'.
>>>>>>>>
>>>>>>>> When TUN module is called later to allocate and fill the virtio-net
>>>>>>>> header and push it to destination virtqueue it populates the hash
>>>>>>>> and the hash type into virtio-net header.
>>>>>>>>
>>>>>>>> VHOST driver is made aware of respective virtio-net feature that
>>>>>>>> extends the virtio-net header to report the hash value and hash report
>>>>>>>> type.
>>>>>>> Comment from Willem de Bruijn:
>>>>>>>
>>>>>>> Skbuff fields are in short supply. I don't think we need to add one
>>>>>>> just for this narrow path entirely internal to the tun device.
>>>>>>>
>>>>>> We understand that and try to minimize the impact by using an already
>>>>>> existing unused field of skb.
>>>>> Not anymore. It was repurposed as a flags field very recently.
>>>>>
>>>>> This use case is also very narrow in scope. And a very short path from
>>>>> data producer to consumer. So I don't think it needs to claim scarce
>>>>> bits in the skb.
>>>>>
>>>>> tun_ebpf_select_queue stores the field, tun_put_user reads it and
>>>>> converts it to the virtio_net_hdr in the descriptor.
>>>>>
>>>>> tun_ebpf_select_queue is called from .ndo_select_queue.  Storing the
>>>>> field in skb->cb is fragile, as in theory some code could overwrite
>>>>> that between field between ndo_select_queue and
>>>>> ndo_start_xmit/tun_net_xmit, from which point it is fully under tun
>>>>> control again. But in practice, I don't believe anything does.
>>>>>
>>>>> Alternatively an existing skb field that is used only on disjoint
>>>>> datapaths, such as ingress-only, could be viable.
>>>> A question here. We had metadata support in XDP for cooperation between
>>>> eBPF programs. Do we have something similar in the skb?
>>>>
>>>> E.g in the RSS, if we want to pass some metadata information between
>>>> eBPF program and the logic that generates the vnet header (either hard
>>>> logic in the kernel or another eBPF program). Is there any way that can
>>>> avoid the possible conflicts of qdiscs?
>>> Not that I am aware of. The closest thing is cb[].
>>>
>>> It'll have to aliase a field like that, that is known unused for the given path.
>>
>> Right, we need to make sure cb is not used by other ones. I'm not sure
>> how hard to achieve that consider Qemu installs the eBPF program but it
>> doesn't deal with networking configurations.
>>
>>
>>> One other approach that has been used within linear call stacks is out
>>> of band. Like percpu variables softnet_data.xmit.more and
>>> mirred_rec_level. But that is perhaps a bit overwrought for this use
>>> case.
>>
>> Yes, and if we go that way then eBPF turns out to be a burden since we
>> need to invent helpers to access those auxiliary data structure. It
>> would be better then to hard-coded the RSS in the kernel.
>>
>>
>>>>>>> Instead, you could just run the flow_dissector in tun_put_user if the
>>>>>>> feature is negotiated. Indeed, the flow dissector seems more apt to me
>>>>>>> than BPF here. Note that the flow dissector internally can be
>>>>>>> overridden by a BPF program if the admin so chooses.
>>>>>>>
>>>>>> When this set of patches is related to hash delivery in the virtio-net
>>>>>> packet in general,
>>>>>> it was prepared in context of RSS feature implementation as defined in
>>>>>> virtio spec [1]
>>>>>> In case of RSS it is not enough to run the flow_dissector in tun_put_user:
>>>>>> in tun_ebpf_select_queue the TUN calls eBPF to calculate the hash,
>>>>>> hash type and queue index
>>>>>> according to the (mapped) parameters (key, hash types, indirection
>>>>>> table) received from the guest.
>>>>> TUNSETSTEERINGEBPF was added to support more diverse queue selection
>>>>> than the default in case of multiqueue tun. Not sure what the exact
>>>>> use cases are.
>>>>>
>>>>> But RSS is exactly the purpose of the flow dissector. It is used for
>>>>> that purpose in the software variant RPS. The flow dissector
>>>>> implements a superset of the RSS spec, and certainly computes a
>>>>> four-tuple for TCP/IPv6. In the case of RPS, it is skipped if the NIC
>>>>> has already computed a 4-tuple hash.
>>>>>
>>>>> What it does not give is a type indication, such as
>>>>> VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be used.
>>>>> In datapaths where the NIC has already computed the four-tuple hash
>>>>> and stored it in skb->hash --the common case for servers--, That type
>>>>> field is the only reason to have to compute again.
>>>> The problem is there's no guarantee that the packet comes from the NIC,
>>>> it could be a simple VM2VM or host2VM packet.
>>>>
>>>> And even if the packet is coming from the NIC that calculates the hash
>>>> there's no guarantee that it's the has that guest want (guest may use
>>>> different RSS keys).
>>> Ah yes, of course.
>>>
>>> I would still revisit the need to store a detailed hash_type along with
>>> the hash, as as far I can tell that conveys no actionable information
>>> to the guest.
>>
>> Yes, need to figure out its usage. According to [1], it only mention
>> that storing has type is a charge of driver. Maybe Yuri can answer this.
>>
> For the case of Windows VM we can't know how exactly the network stack
> uses provided hash data (including hash type). But: different releases
> of Windows
> enable different hash types (for example UDP hash is enabled only on
> Server 2016 and up).
>
> Indeed the Windows requires a little more from the network adapter/driver
> than Linux does.
>
> The addition of RSS support to virtio specification takes in account
> the widest set of
> requirements (i.e. Windows one), our initial impression is that this
> should be enough also for Linux.
>
> The NDIS specification in part of RSS is _mandatory_ and there are
> certification tests
> that check that the driver provides the hash data as expected. All the
> high-performance
> network adapters have such RSS functionality in the hardware.
> With pre-RSS QEMU (i.e. where the virtio-net device does not indicate
> the RSS support)
> the virtio-net driver for Windows does all the job related to RSS:
> - hash calculation
> - hash/hash_type delivery
> - reporting each packet on the correct CPU according to RSS settings
>
> With RSS support in QEMU all the packets always come on a proper CPU and
> the driver never needs to reschedule them. The driver still need to
> calculate the
> hash and report it to Windows. In this case we do the same job twice: the device
> (QEMU or eBPF) does calculate the hash and get proper queue/CPU to deliver
> the packet. But the hash is not delivered by the device, so the driver needs to
> recalculate it and report to the Windows.
>
> If we add HASH_REPORT support (current set of patches) and the device
> indicates this
> feature we can avoid hash recalculation in the driver assuming we
> receive the correct hash
> value and hash type. Otherwise the driver can't know which exactly
> hash the device has calculated.
>
> Please let me know if I did not answer the question.


I think I get you. The hash type is also a kind of classification (e.g 
TCP or UDP). Any possibility that it can be deduced from the driver? (Or 
it could be too expensive to do that).

Thanks


>
>> Thanks
>>
>> [1]
>> https://docs.microsoft.com/en-us/windows-hardware/drivers/network/indicating-rss-receive-data
>>
>>

