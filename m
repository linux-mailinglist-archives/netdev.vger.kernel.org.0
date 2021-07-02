Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9A83B9AF0
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhGBDQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234899AbhGBDQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625195624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLNRqn3/TOb5zbMyMe666zmzbyZ4iUrHZsW578I6k+A=;
        b=O1Ir62i731V1JbHBl+uO3st3SZC8ucGzEZa+A6JG6BDAdM/wWV/J4VOVunGRkl34BIramj
        N/hwP+abK4/PQ+OhxEL0ZpuTdthw5u+5lbjTXC8MERg4fehZX1hOXkQw+p/7BVzWsV+boZ
        mrzImMdD4I+5p4Xo+95N0qPGdu81Tn8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-TMs_3ySvMGOYwCLKLA2LLw-1; Thu, 01 Jul 2021 23:13:43 -0400
X-MC-Unique: TMs_3ySvMGOYwCLKLA2LLw-1
Received: by mail-pj1-f71.google.com with SMTP id om5-20020a17090b3a85b029016eb0b21f1dso4384977pjb.4
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 20:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gLNRqn3/TOb5zbMyMe666zmzbyZ4iUrHZsW578I6k+A=;
        b=MTXVX135FYIxBcdI0CCfPiWtcA6YbMfm8TM+BOazycC0NPXUsibVg6OTnZ5Mqu846/
         2/ZPqBeXzNyJbmI0nHSOaxs2k1mxNY6EI7JgXmwJJeYAFDS5I9jlf0eNrTYURiw7vdF7
         uW0VwbM+1/yrN5xe5EO+F6Xw5LAgmdWsJ/EF5EuwwQj8m2iIxSSl8JcqtHi0UJHD/RKA
         cy36hapJfHnkhkvgOJppx9gOdB0HhuYuvVPZtS5L1YydqO4KL2gZkee1k/4a4cT3FNr5
         Breaix4ZjtqAfos31YSr4fs5C0ZX3jp2wbO4am/PWBTi0SO516Fkj4NrhOJw0DsBziqx
         417g==
X-Gm-Message-State: AOAM533bRLeC2Vbh0s2HDcSFudlckUi0NB7AYuOfhu4Kj7dieeDldQUd
        pjSvQvKu2QRj4GcxPo/5pVdZUNZkdo4HbirtW2SBip0Rl6krFLIS3bKZTxTBrREAac/FgYIOPCc
        HQ+TxQoYbPNz4+4mg
X-Received: by 2002:a17:902:c14a:b029:129:18c6:9b08 with SMTP id 10-20020a170902c14ab029012918c69b08mr2423321plj.36.1625195622219;
        Thu, 01 Jul 2021 20:13:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3Nq4TJDw78Zx04uksPb2hSXn646M5kSI72Ng6qY2AqcKHzetfKMN5VdIj31InOo/a9/EOAQ==
X-Received: by 2002:a17:902:c14a:b029:129:18c6:9b08 with SMTP id 10-20020a170902c14ab029012918c69b08mr2423299plj.36.1625195621949;
        Thu, 01 Jul 2021 20:13:41 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k19sm971549pji.32.2021.07.01.20.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 20:13:41 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
 <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
 <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
 <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
 <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
 <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com>
 <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ccf524ce-17f8-3763-0f86-2afbcf6aa6fc@redhat.com>
Date:   Fri, 2 Jul 2021 11:13:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/2 上午1:39, David Woodhouse 写道:
> On Thu, 2021-07-01 at 12:13 +0800, Jason Wang wrote:
>> 在 2021/6/30 下午6:02, David Woodhouse 写道:
>>> On Wed, 2021-06-30 at 12:39 +0800, Jason Wang wrote:
>>>> 在 2021/6/29 下午6:49, David Woodhouse 写道:
>>>>> So as I expected, the throughput is better with vhost-net once I get to
>>>>> the point of 100% CPU usage in my main thread, because it offloads the
>>>>> kernel←→user copies. But latency is somewhat worse.
>>>>>
>>>>> I'm still using select() instead of epoll() which would give me a
>>>>> little back — but only a little, as I only poll on 3-4 fds, and more to
>>>>> the point it'll give me just as much win in the non-vhost case too, so
>>>>> it won't make much difference to the vhost vs. non-vhost comparison.
>>>>>
>>>>> Perhaps I really should look into that trick of "if the vhost TX ring
>>>>> is already stopped and would need a kick, and I only have a few packets
>>>>> in the batch, just write them directly to /dev/net/tun".
>>>> That should work on low throughput.
>>> Indeed it works remarkably well, as I noted in my follow-up. I also
>>> fixed a minor stupidity where I was reading from the 'call' eventfd
>>> *before* doing the real work of moving packets around. And that gives
>>> me a few tens of microseconds back too.
>>>
>>>>> I'm wondering how that optimisation would translate to actual guests,
>>>>> which presumably have the same problem. Perhaps it would be an
>>>>> operation on the vhost fd, which ends up processing the ring right
>>>>> there in the context of *that* process instead of doing a wakeup?
>>>> It might improve the latency in an ideal case but several possible issues:
>>>>
>>>> 1) this will blocks vCPU running until the sent is done
>>>> 2) copy_from_user() may sleep which will block the vcpu thread further
>>> Yes, it would block the vCPU for a short period of time, but we could
>>> limit that. The real win is to improve latency of single, short packets
>>> like a first SYN, or SYNACK. It should work fine even if it's limited
>>> to *one* *short* packet which *is* resident in memory.
>>
>> This looks tricky since we need to poke both virtqueue metadata as well
>> as the payload.
> That's OK as we'd *only* do it if the thread is quiescent anyway.
>
>> And we need to let the packet iterate the network stack which might have
>> extra latency (qdiscs, eBPF, switch/OVS).
>>
>> So it looks to me it's better to use vhost_net busy polling instead
>> (VHOST_SET_VRING_BUSYLOOP_TIMEOUT).
> Or something very similar, with the *trylock* and bailing out.
>
>> Userspace can detect this feature by validating the existence of the ioctl.
> Yep. Or if we want to get fancy, we could even offer it to the guest.
> As a *different* doorbell register to poke if they want to relinquish
> the physical CPU to process the packet quicker. We wouldn't even *need*
> to go through userspace at all, if we put that into a separate page...
> but that probably *is* overengineering it :)


Yes. Actually, it makes a PV virtio driver which requires an 
architectural way to detect the existence of those kinds of doorbell.

This seems contradict to how virtio want to go as a general 
device/driver interface which is not limited to the world of virtualization.


>
>>> Although actually I'm not *overly* worried about the 'resident' part.
>>> For a transmit packet, especially a short one not a sendpage(), it's
>>> fairly likely the the guest has touched the buffer right before sending
>>> it. And taken the hit of faulting it in then, if necessary. If the host
>>> is paging out memory which is *active* use by a guest, that guest is
>>> screwed anyway :)
>>
>> Right, but there could be workload that is unrelated to the networking.
>> Block vCPU thread in this case seems sub-optimal.
>>
> Right, but the VMM (or the guest, if we're letting the guest choose)
> wouldn't have to use it for those cases.


I'm not sure I get here. If so, simply write to TUN directly would work.


>
>>> Alternatively, there's still the memory map thing I need to fix before
>>> I can commit this in my application:
>>>
>>> #ifdef __x86_64__
>>> 	vmem->regions[0].guest_phys_addr = 4096;
>>> 	vmem->regions[0].memory_size = 0x7fffffffe000;
>>> 	vmem->regions[0].userspace_addr = 4096;
>>> #else
>>> #error FIXME
>>> #endif
>>> 	if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
>>>
>>> Perhaps if we end up with a user-visible feature to deal with that,
>>> then I could use the presence of *that* feature to infer that the tun
>>> bugs are fixed.
>>
>> As we discussed before it could be a new backend feature. VHOST_NET_SVA
>> (shared virtual address)?
> Yeah, I'll take a look.
>
>>> Another random thought as I stare at this... can't we handle checksums
>>> in tun_get_user() / tun_put_user()? We could always set NETIF_F_HW_CSUM
>>> on the tun device, and just do it *while* we're copying the packet to
>>> userspace, if userspace doesn't support it. That would be better than
>>> having the kernel complete the checksum in a separate pass *before*
>>> handing the skb to tun_net_xmit().
>>
>> I'm not sure I get this, but for performance reason we don't do any csum
>> in this case?
> I think we have to; the packets can't leave the box without a valid
> checksum. If the skb isn't CHECKSUM_COMPLETE at the time it's handed
> off to the ->hard_start_xmit of a netdev which doesn't advertise
> hardware checksum support, the network stack will do it manually in an
> extra pass.


Yes.


>
> Which is kind of silly if the tun device is going to do a pass over all
> the data *anyway* as it copies it up to userspace. Even in the normal
> case without vhost-net.


I think the design is to delay the tx checksum as much as possible:

1) host RX -> TAP TX -> Guest RX -> Guest TX -> TX RX -> host TX
2) VM1 TX -> TAP RX -> switch -> TX TX -> VM2 TX

E.g  if the checksum is supported in all those path, we don't need any 
software checksum at all in the above path. And if any part is not 
capable of doing checksum, the checksum will be done by networking core 
before calling the hard_start_xmit of that device.


>
>>> We could similarly do a partial checksum in tun_get_user() and hand it
>>> off to the network stack with ->ip_summed == CHECKSUM_PARTIAL.
>>
>> I think that's is how it is expected to work (via vnet header), see
>> virtio_net_hdr_to_skb().
> But only if the "guest" supports it; it doesn't get handled by the tun
> device. It *could*, since we already have the helpers to checksum *as*
> we copy to/from userspace.
>
> It doesn't help for me to advertise that I support TX checksums in
> userspace because I'd have to do an extra pass for that. I only do one
> pass over the data as I encrypt it, and in many block cipher modes the
> encryption of the early blocks affects the IV for the subsequent
> blocks... do I can't just go back and "fix" the checksum at the start
> of the packet, once I'm finished.
>
> So doing the checksum as the packet is copied up to userspace would be
> very useful.


I think I get this, but it requires a new TUN features (and maybe make 
it userspace controllable via tun_set_csum()).

Thanks


