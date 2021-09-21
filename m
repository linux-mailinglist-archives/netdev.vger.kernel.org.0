Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282324135AB
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhIUOyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhIUOyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 10:54:36 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C685C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 07:53:08 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c8-20020a9d6c88000000b00517cd06302dso28614505otr.13
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7xG1fmTIeRkvO4a2pmdD01LPy7OxyV6G+13/yncA2zM=;
        b=SAHrU6tO4lq1qsEYhkh6h6BoXjQX32JMVFunPgjB0RfJmwVETKlenKHDpd6HhqWmUZ
         oN7LUAaLO7OezqkuJ2Ooz0FlOSMSuhFPyMwYJEsDpvqb+KTf89qEk2c2GyhTPOFWMP+3
         ZjjCwW42aPlgsXhgRqRQnB9fry4yFoYqNRSdVJz1BedSiuscWPK6sEioyXjsKvVhGxJX
         2VBGnz9orAdOL1F2AkEYWo8yTj5Dgd9LFiQYbwut2momF3keHVewBWt+8qfS0YZ5wPO/
         vdZ6F54Uh4uHKdP458iAID2ngU27VziClO7m3PbGtXADtmI2bUWhKl631Vt1iJtypBkG
         ZFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7xG1fmTIeRkvO4a2pmdD01LPy7OxyV6G+13/yncA2zM=;
        b=UiKImx0M9kyX2L4FJujsqWJR3OpmwBUIrC+1bcYu0pA1OTxSpLV0OWYzzai2/kO+kG
         +/QBwEyzNK5qDa8adpSx2x7V5Y4iO+Gke4JJ6bb5j8mQJcjxai3bE5jiiPwPZDTja/cv
         isDgqrxhhRQslTDsIJ4FITPm+NchN9thVGuur+vD9D3Orv5zK0cSw3Nc5Q1WlK3pC+H4
         3VhmjrwlZO9be9ikiVuWt5pAKRQjrDrKqH5Bo27qSVHu9j1+78knsEB/xnZQYm+NNtGr
         VQ47NSb3jOPBKWAxtLdwvS9onb3uEYIf5+haN9IHn1NurypWZbd9/lo9wvhyX0wl4fWa
         sHzA==
X-Gm-Message-State: AOAM531ZisEVdYk0BruYAYlLvyMxJXZyTP1qBfL3FTWv4Czke7Jni5e9
        W8sEyCsOI9DHvqu14yw7ujdNSu7GVHLynQ==
X-Google-Smtp-Source: ABdhPJxndeHbFZ841zivqPLZntg/QZZz++S++KpzXSv6RMpQDAuK/cRwqzmQYg/g4xFP3fnl5Wn1vA==
X-Received: by 2002:a05:6830:50:: with SMTP id d16mr24108262otp.231.1632235987943;
        Tue, 21 Sep 2021 07:53:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id v11sm4208821oto.22.2021.09.21.07.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 07:53:07 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] lib: bpf_legacy: add prog name, load time,
 uid and btf id in prog info dump
To:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210917202338.1810837-1-gokulkumar792@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <056ea304-13e9-e92e-ccfd-7be2312f6d1f@gmail.com>
Date:   Tue, 21 Sep 2021 08:53:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210917202338.1810837-1-gokulkumar792@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 2:23 PM, Gokul Sivakumar wrote:
> The BPF program name is included when dumping the BPF program info and the
> kernel only stores the first (BPF_PROG_NAME_LEN - 1) bytes for the program
> name.
> 
> $ sudo ip link show dev docker0
> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff
>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited
> 
> The BPF program load time (ns since boottime), UID of the user who loaded
> the program and the BTF ID are also included when dumping the BPF program
> information when the user expects a detailed ip link info output.
> 
> $ sudo ip -details link show dev docker0
> 4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
>     link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>     bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filt
> ering 0 vlan_protocol 802.1Q bridge_id 8000.2:42:4c:df:a4:54 designated_root 8000.2:42:4c:df:a4:54 root_port 0 r
> oot_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_chan
> ge_timer    0.00 gc_timer  265.36 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask
> 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast
> _hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_
> interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query
> _response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_v
> ersion 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues
> 1 gso_max_size 65536 gso_max_segs 65535
>     prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited load_time 2676682607316255 created_by_uid 0 btf_id 708

what kernel is this? I was not aware bridge devices support XDP and do
not see that support in net-next.
