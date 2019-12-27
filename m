Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5F12B04F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfL0Bgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:36:45 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39174 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfL0Bgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:36:44 -0500
Received: by mail-pj1-f65.google.com with SMTP id t101so4223772pjb.4
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gNbptXAK8Hfd7Xh2Dj3FjEueg0LrKUbpxj5uju7PCB0=;
        b=tebsvzENeBfhxLo0c8B7dnsKjiWZhMIx2asxpde8n9S3k34quCScVRsvWN2tZYnRiI
         An1aGR56QCJYIq+QwVwmUP0em20QJI13+/CIQr68xxSfh08Odr5LIl8Cv60i54VP4mPi
         nheHI2nPjTeuq0ozFEml0BtC8LQpdiToRXPQ2XBDRIgYYDpKAIeO94Vu7bdXHoPO+Gc0
         ICBti+CKqn5cYI26xLJbEc6rDI/npMsDX0IwdsXXiNHQ283hgXAsAKfTB8N4SU8P00G8
         446lhnitdS62oCJ2yy8vTijs10FDgsO0JOynWp3jfsuwt5osMGD+eino7JVOkfrvi4N5
         S7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gNbptXAK8Hfd7Xh2Dj3FjEueg0LrKUbpxj5uju7PCB0=;
        b=EeSE3SSIJb8m5aWAibYNbd3uNwhvOOtwBzZSbza1WTnBdJEAkEl4ajDa+K9udGheLZ
         42ezYBQWSudWw6hqpIJfcLvmCsyGS2y3XAJowlU0kdXc7GbvHwsgmOxloQ254vm82ej9
         SCIj1hMkhMBDgS6kgZIw95Zoty4XtaOVgdP23sm1Xw+NgbgRq6dZzDrNWmhBtrx+f+C/
         LZ2/mOxiNL9ZruNQqWkC3I+aadlEC4nEl005SwbgJ+e0FFXGyon9RxPLB4BtOu8ilAXL
         W1jC+q6m4fjedoCrosKXG5sL42pkhj9M1HQJgmj6ph/08KSDW1ioJgu0hWz1e7d7AkKg
         +2XA==
X-Gm-Message-State: APjAAAWOyTg+mnQ6oeTdUHy1SpjX48PzEhE7WaryEM41A7UYYuGB0lzX
        jbDYD+JcuyJHhKFJd9w44B5ONnhx
X-Google-Smtp-Source: APXvYqw9eUREg35khPPVx9XELnL4N5Dtwo1shi5ZEMUI88Z4t6eP6ps2He/k7oOy0WJ8vr05MQp8/g==
X-Received: by 2002:a17:90a:d995:: with SMTP id d21mr23216524pjv.118.1577410603648;
        Thu, 26 Dec 2019 17:36:43 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id b2sm12075321pjq.3.2019.12.26.17.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 17:36:43 -0800 (PST)
Subject: Re: [RFC v2 net-next 00/12] XDP in tx path
To:     Tom Herbert <tom@herbertland.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
 <CALx6S37d=JYSSjCfWa_N=AK3HUMSR9TJEv46tLTK-LiMrzoWMg@mail.gmail.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <1552d426-8070-808b-82a0-7218fef21f54@gmail.com>
Date:   Fri, 27 Dec 2019 10:35:38 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALx6S37d=JYSSjCfWa_N=AK3HUMSR9TJEv46tLTK-LiMrzoWMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/19 4:23 AM, Tom Herbert wrote:
> Prashant,
> 
> Can you provide some more detail about the expected use cases. I am
> particularly interested if the intent is to set an XDP-like eBPF hook
> in the generic TX path (the examples provided seem limited to
> tunnels). For instance, is there an intent to send packets on a device
> without ever creating a skbuf as the analogue of how XDP can receive
> packets without needing skb.

This patchset is a result of trying to solve problems in virtual
devices. It just emulates RX path XDP of peer device. At least I have
not thought about the idea that you mentioned. May be this idea can be
helpful when a separate XDP_TX type of program which will introduced
later.

Toke had pointed out one more use case of TX path XDP here:
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#xdp-hook-at-tx

Thanks

> 
> Tom
> 
> On Wed, Dec 25, 2019 at 6:33 PM Prashant Bhole
> <prashantbhole.linux@gmail.com> wrote:
>>
>> v2:
>> - New XDP attachment type: Jesper, Toke and Alexei discussed whether
>>    to introduce a new program type. Since this set adds a way to attach
>>    regular XDP program to the tx path, as per Alexei's suggestion, a
>>    new attachment type BPF_XDP_EGRESS is introduced.
>>
>> - libbpf API changes:
>>    Alexei had suggested _opts() style of API extension. Considering it
>>    two new libbpf APIs are introduced which are equivalent to existing
>>    APIs. New ones can be extended easily. Please see individual patches
>>    for details. xdp1 sample program is modified to use new APIs.
>>
>> - tun: Some patches from previous set are removed as they are
>>    irrelevant in this series. They will in introduced later.
>>
>>
>> This series introduces new XDP attachment type BPF_XDP_EGRESS to run
>> an XDP program in tx path. The idea is to emulate RX path XDP of the
>> peer interface. Such program will not have access to rxq info.
>>
>> RFC also includes its usage in tun driver.
>> Later it can be posted separately. Another possible use of this
>> feature can be in veth driver. It can improve container networking
>> where veth pair links the host and the container. Host can set ACL by
>> setting tx path XDP to the veth interface.
>>
>> It was originally a part of Jason Wang's work "XDP offload with
>> virtio-net" [1]. In order to simplify this work we decided to split
>> it and introduce tx path XDP separately in this set.
>>
>> The performance improvment can be seen when an XDP program is attached
>> to tun tx path opposed to rx path in the guest.
>>
>> * Case 1: When packets are XDP_REDIRECT'ed towards tun.
>>
>>                       virtio-net rx XDP      tun tx XDP
>>    xdp1(XDP_DROP)        2.57 Mpps           12.90 Mpps
>>    xdp2(XDP_TX)          1.53 Mpps            7.15 Mpps
>>
>> * Case 2: When packets are pass through bridge towards tun
>>
>>                       virtio-net rx XDP      tun tx XDP
>>    xdp1(XDP_DROP)        0.99 Mpps           1.00 Mpps
>>    xdp2(XDP_TX)          1.19 Mpps           0.97 Mpps
>>
>> Since this set modifies tun and vhost_net, below are the netperf
>> performance numbers.
>>
>>      Netperf_test       Before      After   Difference
>>    UDP_STREAM 18byte     90.14       88.77    -1.51%
>>    UDP_STREAM 1472byte   6955        6658     -4.27%
>>    TCP STREAM            9409        9402     -0.07%
>>    UDP_RR                12658       13030    +2.93%
>>    TCP_RR                12711       12831    +0.94%
>>
>> XDP_REDIRECT will be handled later because we need to come up with
>> proper way to handle it in tx path.
>>
>> Patches 1-5 are related to adding tx path XDP support.
>> Patches 6-12 implement tx path XDP in tun driver.
>>
>> [1]: https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
>>
>>
>>
>> David Ahern (2):
>>    net: introduce BPF_XDP_EGRESS attach type for XDP
>>    tun: set tx path XDP program
>>
>> Jason Wang (2):
>>    net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
>>    net: core: export do_xdp_generic_core()
>>
>> Prashant Bhole (8):
>>    tools: sync kernel uapi/linux/if_link.h header
>>    libbpf: api for getting/setting link xdp options
>>    libbpf: set xdp program in tx path
>>    samples/bpf: xdp1, add XDP tx support
>>    tuntap: check tun_msg_ctl type at necessary places
>>    vhost_net: user tap recvmsg api to access ptr ring
>>    tuntap: remove usage of ptr ring in vhost_net
>>    tun: run XDP program in tx path
>>
>>   drivers/net/tap.c                  |  42 +++---
>>   drivers/net/tun.c                  | 220 ++++++++++++++++++++++++++---
>>   drivers/vhost/net.c                |  77 +++++-----
>>   include/linux/if_tap.h             |   5 -
>>   include/linux/if_tun.h             |  23 ++-
>>   include/linux/netdevice.h          |   6 +-
>>   include/uapi/linux/bpf.h           |   1 +
>>   include/uapi/linux/if_link.h       |   1 +
>>   net/core/dev.c                     |  42 ++++--
>>   net/core/filter.c                  |   8 ++
>>   net/core/rtnetlink.c               | 112 ++++++++++++++-
>>   samples/bpf/xdp1_user.c            |  42 ++++--
>>   tools/include/uapi/linux/bpf.h     |   1 +
>>   tools/include/uapi/linux/if_link.h |   2 +
>>   tools/lib/bpf/libbpf.h             |  40 ++++++
>>   tools/lib/bpf/libbpf.map           |   2 +
>>   tools/lib/bpf/netlink.c            | 113 +++++++++++++--
>>   17 files changed, 613 insertions(+), 124 deletions(-)
>>
>> --
>> 2.21.0
>>
