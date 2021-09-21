Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76C4135F6
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhIUPP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhIUPP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:15:58 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12742C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:14:30 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id p22-20020a4a8156000000b002a8c9ea1858so3213270oog.11
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PjdLoqecbdDxdob1KT/H3n5++XqKN56OaqXD3htpcyc=;
        b=Lz53KVU026TyGdCqX/SRPjI0GtigVYJ3SmJzXmiOZ7C4FKjxJMkF29oNQq6Y1kOSQm
         eCBHVdKtuP+N6k8QJXWohVS5WNGfmTTDO1TtPIiekHN9C6U2LfD2IHcBQM+CosDEH+OG
         yD1i6z208MZ+bbYP3zF9IXZAsD/4ngq9I4gX4CYFHOEAOjH0Uy4u/zU4LQalknF+60Ky
         HRZ6QLU86DUlyYgCNLCP4aORdhv23pJSZnjxa6NX19b7YJvjD41VGu7rzG4bW+KpWMci
         4Q1n9eg1rkn6JGoHEqoHV4hhvWF9FSfw+l7fs5gXCSSxrasy3QtyEAYTMIEZ2NMa8HSj
         R4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PjdLoqecbdDxdob1KT/H3n5++XqKN56OaqXD3htpcyc=;
        b=QfwAOOHqBqRkvr4v8pagKfO45ptoWXdBi3jJGsbI+8WHI3CSUodayULs+f22rmMGji
         3yAOeteTIx5a/HeN42cGXC9ahmg+ClVOdcR7o+pj+g4JQqKq07BDzcluutwGIGuM+g69
         SWg5uiopcPQhGtxO7keIKr5bPeoRBZe5PCU/Zl80FT4KuybTvZcxtA7zQAHLEt8+NuUY
         +GeZSnhttDg4rAO0qFSwkB5b3B/osDuv84Y2byG8BWkZw5h+vcChh48slXuWnk9TfFP8
         z5wA2nq0JdcVdPsG+a2mHTw5GuMUQrIPm8uQ4QhuxnbVXeLgJkUuNtNbXjxreQo3qkFl
         zmFQ==
X-Gm-Message-State: AOAM532RT/rvRt9YScUiSVllntlfdVGRdO4aZQZeopnTfduDoyl9YfEa
        1bCjv/QVGFNq0xxgRK7QVaA=
X-Google-Smtp-Source: ABdhPJxXb3tlR1ExsfK7mei7L6zxUOTkjg9LT9SKlA3Y3Huf5c9LxnWtOZ7CVAo1O3eagGL7fvbX4w==
X-Received: by 2002:a05:6820:410:: with SMTP id o16mr7977472oou.36.1632237268872;
        Tue, 21 Sep 2021 08:14:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id k2sm793603oog.5.2021.09.21.08.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:14:27 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] lib: bpf_legacy: add prog name, load time,
 uid and btf id in prog info dump
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Gokul Sivakumar <gokulkumar792@gmail.com>,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210917202338.1810837-1-gokulkumar792@gmail.com>
 <056ea304-13e9-e92e-ccfd-7be2312f6d1f@gmail.com> <87sfxy2ckt.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80ae956d-8840-be0d-7a2b-44ceefcea3e5@gmail.com>
Date:   Tue, 21 Sep 2021 09:14:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87sfxy2ckt.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 9:05 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 9/17/21 2:23 PM, Gokul Sivakumar wrote:
>>> The BPF program name is included when dumping the BPF program info and the
>>> kernel only stores the first (BPF_PROG_NAME_LEN - 1) bytes for the program
>>> name.
>>>
>>> $ sudo ip link show dev docker0
>>> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>>>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff
>>>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited
>>>
>>> The BPF program load time (ns since boottime), UID of the user who loaded
>>> the program and the BTF ID are also included when dumping the BPF program
>>> information when the user expects a detailed ip link info output.
>>>
>>> $ sudo ip -details link show dev docker0
>>> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>>>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>>>     bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filt
>>> ering 0 vlan_protocol 802.1Q bridge_id 8000.2:42:4c:df:a4:54 designated_root 8000.2:42:4c:df:a4:54 root_port 0 r
>>> oot_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_chan
>>> ge_timer    0.00 gc_timer  265.36 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask
>>> 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast
>>> _hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_
>>> interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query
>>> _response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_v
>>> ersion 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues
>>> 1 gso_max_size 65536 gso_max_segs 65535
>>>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited load_time 2676682607316255 created_by_uid 0 btf_id 708
>>
>> what kernel is this? I was not aware bridge devices support XDP and do
>> not see that support in net-next.
> 
> It's loaded in generic mode (note 'xdpgeneric') :)
> 

ah, thanks for the reminder. I keep forgetting about xdpgeneric (brain
is pretending it does not exist ?!? :-)).

There's a lot of distance -- and characters -- between 'xdpgeneric' and
the 'prog/xdp' line. :-(

