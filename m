Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385FD4135D6
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhIUPHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:07:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233847AbhIUPHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632236766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1YWH3E9JHWqYzIpqFipVtZS5Rzpfj/KBDrUEXcgwsSY=;
        b=hAr046/SA/deKlxgQUJvMgwAnllAlRBHAqThBChF7iSQ8rv/kjIOzAk0tOzfZSGdtufmGe
        lioiLCzBk9RX67z3fSmD35X3V9tyrKgbXFSL9sDBWYZdCPPwi02JqI/cAD9VidmKvlhw9/
        Qqtm5Ofpno6mUcKP21OlhnLG5Q7QpQc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-DbMz24kPPE2kGLt5kQvtqQ-1; Tue, 21 Sep 2021 11:06:00 -0400
X-MC-Unique: DbMz24kPPE2kGLt5kQvtqQ-1
Received: by mail-ed1-f71.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso19422901edp.13
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1YWH3E9JHWqYzIpqFipVtZS5Rzpfj/KBDrUEXcgwsSY=;
        b=Nj3TJ6niAvbA0qfTnW/QN5Vm/6Swtm/ulV/FVWwsf50YnxXVNjKmbB9RT1ezCJdJik
         zp2rFSMACgWn7lJ9YfCdSoHGTmPP9Tpt/D1G1byE4piGKkr1fWaj3frcM61wYar1Xm/s
         adwvwkL57UgdavxLP5UhSfEuy5AWFzAwPXkMMpQ7ilb6POTU3fauw9PeIVMzkR0kEaLP
         Z05kdUOAbwdpzHwooVrp3m5RzGa0U0YdGxSTEvay5L44tXW05CkNkLMMtHWFtFDx3076
         r39dsgN6rFNmMqHb0aNFhb53cX3XQEnrnnlmCE2aTQjOaOi7d1ZZVozdVe7eiJODcSJx
         nswQ==
X-Gm-Message-State: AOAM531BBfH2WdAj6p0nRr69i6n6ImekI80UKfeqsv5vqdAP48mQwVc2
        p2Yvf/mKyP7OcJGpc+c9k8t+Dw3OUW2mKzQzM2J0x7MAWC3UfT89L/Qtv1mbcJVFMlGiLSZJn89
        xAvRsDTqFWCqJcJP3
X-Received: by 2002:a17:906:7147:: with SMTP id z7mr34789422ejj.94.1632236757036;
        Tue, 21 Sep 2021 08:05:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5aQNpomO3lVj+molnTq1cKDL7cQDmAJEDWi01V/9xFnN2Voqc8Zam4UkoOkX2S9RmkaHzFg==
X-Received: by 2002:a17:906:7147:: with SMTP id z7mr34789327ejj.94.1632236755654;
        Tue, 21 Sep 2021 08:05:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e13sm7536123eje.95.2021.09.21.08.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 08:05:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 63B1718034A; Tue, 21 Sep 2021 17:05:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Gokul Sivakumar <gokulkumar792@gmail.com>,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next] lib: bpf_legacy: add prog name, load
 time, uid and btf id in prog info dump
In-Reply-To: <056ea304-13e9-e92e-ccfd-7be2312f6d1f@gmail.com>
References: <20210917202338.1810837-1-gokulkumar792@gmail.com>
 <056ea304-13e9-e92e-ccfd-7be2312f6d1f@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Sep 2021 17:05:54 +0200
Message-ID: <87sfxy2ckt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 9/17/21 2:23 PM, Gokul Sivakumar wrote:
>> The BPF program name is included when dumping the BPF program info and the
>> kernel only stores the first (BPF_PROG_NAME_LEN - 1) bytes for the program
>> name.
>> 
>> $ sudo ip link show dev docker0
>> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff
>>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited
>> 
>> The BPF program load time (ns since boottime), UID of the user who loaded
>> the program and the BTF ID are also included when dumping the BPF program
>> information when the user expects a detailed ip link info output.
>> 
>> $ sudo ip -details link show dev docker0
>> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>>     bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filt
>> ering 0 vlan_protocol 802.1Q bridge_id 8000.2:42:4c:df:a4:54 designated_root 8000.2:42:4c:df:a4:54 root_port 0 r
>> oot_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_chan
>> ge_timer    0.00 gc_timer  265.36 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask
>> 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast
>> _hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_
>> interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query
>> _response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_v
>> ersion 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues
>> 1 gso_max_size 65536 gso_max_segs 65535
>>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited load_time 2676682607316255 created_by_uid 0 btf_id 708
>
> what kernel is this? I was not aware bridge devices support XDP and do
> not see that support in net-next.

It's loaded in generic mode (note 'xdpgeneric') :)

-Toke

