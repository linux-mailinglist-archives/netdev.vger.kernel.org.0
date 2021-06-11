Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D633A398A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhFKCMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230168AbhFKCMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623377424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3rTCb8ro1KR7NDR8Hmgfr9O9QWrcOYH5m3dnpqhOrA=;
        b=T8jPm7tr+cqXAH4ToBOGJPH4SDkRAYU0x2Jc6GQCpQjCsUUoknEUXp8otzwKtvzI7K01UD
        2y32XT4ZDzPMgASQbXRBBWgRNWkbDrl50GE1XVUEnOdMrObv3wjyaKsAohf/+wukg5Zne1
        G4e9XbqEk22vWFyNicuYWCWm1HA0xUs=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-WcXIbLFxNr6rI9_M2ckHDQ-1; Thu, 10 Jun 2021 22:10:23 -0400
X-MC-Unique: WcXIbLFxNr6rI9_M2ckHDQ-1
Received: by mail-pg1-f200.google.com with SMTP id s14-20020a63450e0000b029021f631b8861so833842pga.20
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=w3rTCb8ro1KR7NDR8Hmgfr9O9QWrcOYH5m3dnpqhOrA=;
        b=rrU9ya2kbmIkcif/pwwwe9FbW1b3WyEgItok4DZ13rULP85EFWh+bNUs8SJ/xBqgV2
         iNbMH6NeCXYeg1U2sti70gHCw800zH8PYneKuG25sG7gHF+L7XIiC7NsfS9smRmsNydx
         hIR9+/tC5oFQuFEFfg9IXajerr9al+PT4TfehhI4WqNyVqQ57ZLPKBquapQykfXsyMA9
         nHGjCugMcmZkwnYBie2ZHx3OLbZCEU1GQNzI5JUxh4kco32WXm+Hyvudvdr9wbLp5wE3
         qXe9zn+fNwdRAppx4/JhSTmboJ1VZT2MPiisLmo9m0D9mzy4zP5PN5loqCzg6zPDqGFm
         mXUw==
X-Gm-Message-State: AOAM533Ery1OhBOAO4j5P17f3+SJgepWnnGouxVdgKpDXw0TY++hWhnw
        Xt4h4GfNuVFgeVf7/EPIVvgrkPm4jfGU1CltZv9bc9furyRhGX6ZnzNIeVvdH7+hUxce/eoZWo9
        Lo/L63B8Gh4NsDV9x
X-Received: by 2002:a17:90a:f0d5:: with SMTP id fa21mr1963187pjb.4.1623377422130;
        Thu, 10 Jun 2021 19:10:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEQbjp/LVAfsrDKiWzK7ZcXYGnT9luh+5dfhan79hHkz2e04RAfz0IilQ1LSTPm/F/yjuY5w==
X-Received: by 2002:a17:90a:f0d5:: with SMTP id fa21mr1963156pjb.4.1623377421844;
        Thu, 10 Jun 2021 19:10:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm3751356pgu.84.2021.06.10.19.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:10:21 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
Date:   Fri, 11 Jun 2021 10:10:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 下午10:04, Willem de Bruijn 写道:
> On Thu, Jun 10, 2021 at 1:25 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/10 下午12:19, Alexei Starovoitov 写道:
>>> On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> So I wonder why not simply use helpers to access the vnet header like
>>>> how tcp-bpf access the tcp header?
>>> Short answer - speed.
>>> tcp-bpf accesses all uapi and non-uapi structs directly.
>>>
>> Ok, this makes sense. But instead of coupling device specific stuffs
>> like vnet header and neediness into general flow_keys as a context.
>>
>> It would be better to introduce a vnet header context which contains
>>
>> 1) vnet header
>> 2) flow keys
>> 3) other contexts like endian and virtio-net features
>>
>> So we preserve the performance and decouple the virtio-net stuffs from
>> general structures like flow_keys or __sk_buff.
> You are advocating for a separate BPF program that takes a vnet hdr
> and flow_keys as context and is run separately after flow dissection?


Yes.


>
> I don't understand the benefit of splitting the program in two in this manner.


It decouples a device specific attributes from the general structures 
like flow keys. We have xen-netfront, netvsc and a lot of drivers that 
works for the emulated devices. We could not add all those metadatas as 
the context of flow keys. That's why I suggest to use something more 
generic like XDP from the start. Yes, GSO stuffs was disabled by 
virtio-net on XDP but it's not something that can not be fixed. If the 
GSO and s/g support can not be done in short time, then a virtio-net 
specific BPF program still looks much better than coupling virtio-net 
metadata into flow keys or other general data structures.


>
> Your previous comment mentions two vnet_hdr definitions that can get
> out of sync. Do you mean v1 of this patch, that adds the individual
> fields to bpf_flow_dissector?


No, I meant this part of the patch:


+static int check_virtio_net_hdr_access(struct bpf_verifier_env *env, 
int off,
+                       int size)
+{
+    if (size < 0 || off < 0 ||
+        (u64)off + size > sizeof(struct virtio_net_hdr)) {
+        verbose(env, "invalid access to virtio_net_hdr off=%d size=%d\n",
+            off, size);
+        return -EACCES;
+    }
+    return 0;
+}
+


It prevents the program from accessing e.g num_buffers.


> That is no longer the case: the latest
> version directly access the real struct. As Alexei points out, doing
> this does not set virtio_net_hdr in stone in the ABI. That is a valid
> worry. But so this patch series will not restrict how that struct may
> develop over time. A version field allows a BPF program to parse the
> different variants of the struct -- in the same manner as other
> protocol headers.


The format of the virtio-net header depends on the virtio features, any 
reason for another version? The correct way is to provide features in 
the context, in this case you don't event need the endian hint.


> If you prefer, we can add that field from the start.
> I don't see a benefit to an extra layer of indirection in the form of
> helper functions.
>
> I do see downsides to splitting the program. The goal is to ensure
> consistency between vnet_hdr and packet payload. A program split
> limits to checking vnet_hdr against what the flow_keys struct has
> extracted. That is a great reduction over full packet access.


Full packet access could be still done in bpf flow dissector.


> For
> instance, does the packet contain IP options? No idea.


I don't understand here. You can figure out this in flow dissector, and 
you can extend the flow keys to carry out this information if necessary.

And if you want to have more capability, XDP which is designed for early 
packet filtering is the right way to go which have even more functions 
that a simple bpf flow dissector.


>
> If stable ABI is not a concern and there are no different struct
> definitions that can go out of sync, does that address your main
> concerns?


I think not. Assuming we provide sufficient contexts (e.g the virtio 
features), problem still: 1) coupling virtio-net with flow_keys 2) can't 
work for XDP.

Thanks


>

