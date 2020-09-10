Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D372263B7A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 05:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgIJDa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 23:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIJDaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 23:30:46 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1974C061573;
        Wed,  9 Sep 2020 20:30:44 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id u6so5539999iow.9;
        Wed, 09 Sep 2020 20:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C4M2TfZe9EkGGeaZR5HyDrKfqg/6t6no4BM3W8xFfPk=;
        b=OPrqthiKqt3RLRxj92+Sh5odbtDT9g4DQTZIzecceiTPoFuBPqOWtaBvIIwlW3lsfP
         xhCeBFLhdJ30ipy0MkX3/ODkc4p8uv7YjevFNpohA/mZR+NN63yDZXHHnRohpnNQnRrt
         WADD5Va+ZofluJxs44SM7soVLGb/8pQbk+gAfyDuJVtBnwAE8l01cUVe4elVNGCyrB0T
         NDO7qujEQXemOQArGg8tulG6kO9d/92h/gmfia7uWSumjgCXP+ZOLe6aitmYwQ704VSA
         LJo6HLiKP6LGXnZcgZVMLoV42QnS9fn398JQUtiOT7yn47DzYGp6YaJ728kcCuqsFWtC
         n6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C4M2TfZe9EkGGeaZR5HyDrKfqg/6t6no4BM3W8xFfPk=;
        b=Yt5i1SEN78kHBAtPQqXwuSzdVeSPq54GKDLmGqriu2m9N2D3vET8QSEDlT3NA6cyHV
         PK1+tIdUlqmMlmAW+jHTSx5gL87fwj4jCHAzqVJSaBqThvSXEwLaq5vgubefvTaANhPR
         WODp8LnMq1STh1OYJZmNsvOqiFE8OA6x3yP65mqwrxY+T+t+tFjuczqImM1JUTwaGwI9
         Vvxsokig3RlRsz9QxH50d+O8aWNiIapnCq/f4Tyc+XKkEbxMteXQYASnIUH41yCMuXzU
         aXxl0cBuBq3aWLf7v7x/Bc4M2LqwiKONFYA9uuuF8r9Y3l3vpRH3I6g/APSgeBnBXZ5u
         PDXQ==
X-Gm-Message-State: AOAM532WomggxmREQqb++SQRd+NYlg+KVPNz0kPxwDUt2ZEG+OSyaROy
        bWyrnNfnlp7n23nD7vIE1lo=
X-Google-Smtp-Source: ABdhPJyCodTqjk6acXm9qbUOgCGrhHf1vc4AsTGDG3M90tzAHczCBXhuMwmrEr7j6abViz2srcfucA==
X-Received: by 2002:a02:a30b:: with SMTP id q11mr6821878jai.77.1599708642952;
        Wed, 09 Sep 2020 20:30:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:d97e:cc69:8585:c056])
        by smtp.googlemail.com with ESMTPSA id k16sm2396163ilc.38.2020.09.09.20.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 20:30:42 -0700 (PDT)
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
Date:   Wed, 9 Sep 2020 21:30:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 8:35 PM, Hangbin Liu wrote:
> Hi Alexei,
> 
> On Wed, Sep 09, 2020 at 02:52:06PM -0700, Alexei Starovoitov wrote:
>> On Mon, Sep 07, 2020 at 04:27:21PM +0800, Hangbin Liu wrote:
>>> This patch is for xdp multicast support. which has been discussed
>>> before[0], The goal is to be able to implement an OVS-like data plane in
>>> XDP, i.e., a software switch that can forward XDP frames to multiple ports.
>>>
>>> To achieve this, an application needs to specify a group of interfaces
>>> to forward a packet to. It is also common to want to exclude one or more
>>> physical interfaces from the forwarding operation - e.g., to forward a
>>> packet to all interfaces in the multicast group except the interface it
>>> arrived on. While this could be done simply by adding more groups, this
>>> quickly leads to a combinatorial explosion in the number of groups an
>>> application has to maintain.
>>>
>>> To avoid the combinatorial explosion, we propose to include the ability
>>> to specify an "exclude group" as part of the forwarding operation. This
>>> needs to be a group (instead of just a single port index), because a
>>> physical interface can be part of a logical grouping, such as a bond
>>> device.
>>>
>>> Thus, the logical forwarding operation becomes a "set difference"
>>> operation, i.e. "forward to all ports in group A that are not also in
>>> group B". This series implements such an operation using device maps to
>>> represent the groups. This means that the XDP program specifies two
>>> device maps, one containing the list of netdevs to redirect to, and the
>>> other containing the exclude list.
>>
>> "set difference" and BPF_F_EXCLUDE_INGRESS makes sense to me as high level api,
>> but I don't see how program or helper is going to modify the packet
>> before multicasting it.
>> Even to implement a basic switch the program would need to modify destination
>> mac addresses before xmiting it on the device.
>> In case of XDP_TX the bpf program is doing it manually.
>> With this api the program is out of the loop.
>> It can prepare a packet for one target netdev, but sending the same
>> packet as-is to other netdevs isn't going to to work correctly.
> 
> Yes, we can't modify the packets on ingress as there are multi egress ports
> and each one may has different requirements. So this helper will only forward
> the packets to other group(looks like a multicast group) devices.
> 
> I think the packets modification (edit dst mac, add vlan tag, etc) should be
> done on egress, which rely on David's XDP egress support.

agreed. The DEVMAP used for redirect can have programs attached that
update the packet headers - assuming you want to update them.

This is tagged as "multicast" support but it really is redirecting a
packet to multiple devices. One use case I see that evolves from this
set is the ability to both forward packets (e.g., host ingress to VM)
and grab a copy tcpdump style by redirecting packets to a virtual device
(similar to a patch set for dropwatch). ie., no need for an perf-events
style copy to push to userspace.
