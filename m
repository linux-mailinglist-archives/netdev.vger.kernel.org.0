Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00333DC065
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhG3Vrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhG3Vro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:47:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DFCC06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:47:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r2so13055790wrl.1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i46g8UG3DHAsLBiviNjkwsX1JyJdrAOzSZ3O/djol10=;
        b=n0PH2Lho/h9UcCl/xHfLGmDzNNo2zkXMvVcr0GMJE4TddTv+dRVaj+aVKxYmWiQ3Fp
         RINXJ8rmx+ZFCcS8tcyWsC/8wNQpRiHTbV7NHmQdqigCuSjLPJ8maoj2dmSlwyP1JOdM
         oS6nsVrcooWiASjrAi0GdF50S6cxdWWciDMX9zbuFSOh/mPMhgLPAR3r73Pd0l4S0EUJ
         D2iitfPad7qOWILYjZJ+OLSMMgQhHxQ85taG9IvUj8+60aU3NdybOhD/Z2gMRV/LBltc
         QEQ7w3VAK1iGZfRUqHHSxQE7BEukM2VMvXTj309nwJRzncQbMqlghm2vll5G18NCkhvY
         6o8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i46g8UG3DHAsLBiviNjkwsX1JyJdrAOzSZ3O/djol10=;
        b=AAug72CVPJJtdT4H0WqLj8h1nSOJvg5US5EdHfLB27NLUwf/C+a/ZlXdALH2vQrQ5Q
         5OGX5BUi53kiNuvu1ULoPoa7anrvCnDdqc/ZmpAYWBnvaJlurwKIngGefh3H41EDyEZA
         ZLeCPsouGhuBd8WU/1fEvqPZzQHA4kmOtc5ZfBWK1XOFNJi34FhU/zuULQE74ozMNCRz
         CX99QTo8PHrK55KbpyHkMK3FPingC5l8H+EWJyyO+VL9fjAPGwVNR6AxuH2tLGcLOvon
         oGqAzOh3BZgiO+3Dwf6+nd5NHMtQcqZXxASFBs5xSwJ1vEcpvEZfpEttL63fzzm332Dh
         yNHg==
X-Gm-Message-State: AOAM530VGhJkCXS+P++XpMwmldVZLo08NetHZUofbBQdjZsJUagJXPPX
        iVS/5beBBFFVOr8qMxYimvF9Jg==
X-Google-Smtp-Source: ABdhPJyQOFXhqIkCFOWUlCK4u8olBcohNoXcCPsXEOzescIhNAK8TXLqF/AvCtVBboBJRq7bqEEVaw==
X-Received: by 2002:a05:6000:1149:: with SMTP id d9mr5524580wrx.26.1627681656407;
        Fri, 30 Jul 2021 14:47:36 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.68.125])
        by smtp.gmail.com with ESMTPSA id d15sm2847727wrn.28.2021.07.30.14.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 14:47:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 3/7] tools: bpftool: complete and synchronise
 attach or map types
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210729162932.30365-1-quentin@isovalent.com>
 <20210729162932.30365-4-quentin@isovalent.com>
 <CAEf4BzYp2QgaL9ORzs0sWk6KO63Q-9ixU-vOsFfLckE3-bPg6A@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <7c8e25b4-1546-a411-ef21-ae6cd09477df@isovalent.com>
Date:   Fri, 30 Jul 2021 22:47:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYp2QgaL9ORzs0sWk6KO63Q-9ixU-vOsFfLckE3-bPg6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-30 11:52 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Update bpftool's list of attach type names to tell it about the latest
>> attach types, or the "ringbuf" map. Also update the documentation, help
>> messages, and bash completion when relevant.
>>
>> These missing items were reported by the newly added Python script used
>> to help maintain consistency in bpftool.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  .../bpftool/Documentation/bpftool-prog.rst    |  2 +-
>>  tools/bpf/bpftool/bash-completion/bpftool     |  5 +-
>>  tools/bpf/bpftool/common.c                    | 76 ++++++++++---------
>>  tools/bpf/bpftool/prog.c                      |  4 +-
>>  4 files changed, 47 insertions(+), 40 deletions(-)
>>

>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>> index 1828bba19020..b47797cac64f 100644
>> --- a/tools/bpf/bpftool/common.c
>> +++ b/tools/bpf/bpftool/common.c
>> @@ -31,42 +31,48 @@
>>  #endif
>>
>>  const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
>> -       [BPF_CGROUP_INET_INGRESS]       = "ingress",
>> -       [BPF_CGROUP_INET_EGRESS]        = "egress",
>> -       [BPF_CGROUP_INET_SOCK_CREATE]   = "sock_create",
>> -       [BPF_CGROUP_INET_SOCK_RELEASE]  = "sock_release",
>> -       [BPF_CGROUP_SOCK_OPS]           = "sock_ops",
>> -       [BPF_CGROUP_DEVICE]             = "device",
>> -       [BPF_CGROUP_INET4_BIND]         = "bind4",
>> -       [BPF_CGROUP_INET6_BIND]         = "bind6",
>> -       [BPF_CGROUP_INET4_CONNECT]      = "connect4",
>> -       [BPF_CGROUP_INET6_CONNECT]      = "connect6",
>> -       [BPF_CGROUP_INET4_POST_BIND]    = "post_bind4",
>> -       [BPF_CGROUP_INET6_POST_BIND]    = "post_bind6",
>> -       [BPF_CGROUP_INET4_GETPEERNAME]  = "getpeername4",
>> -       [BPF_CGROUP_INET6_GETPEERNAME]  = "getpeername6",
>> -       [BPF_CGROUP_INET4_GETSOCKNAME]  = "getsockname4",
>> -       [BPF_CGROUP_INET6_GETSOCKNAME]  = "getsockname6",
>> -       [BPF_CGROUP_UDP4_SENDMSG]       = "sendmsg4",
>> -       [BPF_CGROUP_UDP6_SENDMSG]       = "sendmsg6",
>> -       [BPF_CGROUP_SYSCTL]             = "sysctl",
>> -       [BPF_CGROUP_UDP4_RECVMSG]       = "recvmsg4",
>> -       [BPF_CGROUP_UDP6_RECVMSG]       = "recvmsg6",
>> -       [BPF_CGROUP_GETSOCKOPT]         = "getsockopt",
>> -       [BPF_CGROUP_SETSOCKOPT]         = "setsockopt",
>> +       [BPF_CGROUP_INET_INGRESS]               = "ingress",
>> +       [BPF_CGROUP_INET_EGRESS]                = "egress",
>> +       [BPF_CGROUP_INET_SOCK_CREATE]           = "sock_create",
>> +       [BPF_CGROUP_INET_SOCK_RELEASE]          = "sock_release",
>> +       [BPF_CGROUP_SOCK_OPS]                   = "sock_ops",
>> +       [BPF_CGROUP_DEVICE]                     = "device",
>> +       [BPF_CGROUP_INET4_BIND]                 = "bind4",
>> +       [BPF_CGROUP_INET6_BIND]                 = "bind6",
>> +       [BPF_CGROUP_INET4_CONNECT]              = "connect4",
>> +       [BPF_CGROUP_INET6_CONNECT]              = "connect6",
>> +       [BPF_CGROUP_INET4_POST_BIND]            = "post_bind4",
>> +       [BPF_CGROUP_INET6_POST_BIND]            = "post_bind6",
>> +       [BPF_CGROUP_INET4_GETPEERNAME]          = "getpeername4",
>> +       [BPF_CGROUP_INET6_GETPEERNAME]          = "getpeername6",
>> +       [BPF_CGROUP_INET4_GETSOCKNAME]          = "getsockname4",
>> +       [BPF_CGROUP_INET6_GETSOCKNAME]          = "getsockname6",
>> +       [BPF_CGROUP_UDP4_SENDMSG]               = "sendmsg4",
>> +       [BPF_CGROUP_UDP6_SENDMSG]               = "sendmsg6",
>> +       [BPF_CGROUP_SYSCTL]                     = "sysctl",
>> +       [BPF_CGROUP_UDP4_RECVMSG]               = "recvmsg4",
>> +       [BPF_CGROUP_UDP6_RECVMSG]               = "recvmsg6",
>> +       [BPF_CGROUP_GETSOCKOPT]                 = "getsockopt",
>> +       [BPF_CGROUP_SETSOCKOPT]                 = "setsockopt",
>>
>> -       [BPF_SK_SKB_STREAM_PARSER]      = "sk_skb_stream_parser",
>> -       [BPF_SK_SKB_STREAM_VERDICT]     = "sk_skb_stream_verdict",
>> -       [BPF_SK_SKB_VERDICT]            = "sk_skb_verdict",
>> -       [BPF_SK_MSG_VERDICT]            = "sk_msg_verdict",
>> -       [BPF_LIRC_MODE2]                = "lirc_mode2",
>> -       [BPF_FLOW_DISSECTOR]            = "flow_dissector",
>> -       [BPF_TRACE_RAW_TP]              = "raw_tp",
>> -       [BPF_TRACE_FENTRY]              = "fentry",
>> -       [BPF_TRACE_FEXIT]               = "fexit",
>> -       [BPF_MODIFY_RETURN]             = "mod_ret",
>> -       [BPF_LSM_MAC]                   = "lsm_mac",
>> -       [BPF_SK_LOOKUP]                 = "sk_lookup",
>> +       [BPF_SK_SKB_STREAM_PARSER]              = "sk_skb_stream_parser",
>> +       [BPF_SK_SKB_STREAM_VERDICT]             = "sk_skb_stream_verdict",
>> +       [BPF_SK_SKB_VERDICT]                    = "sk_skb_verdict",
>> +       [BPF_SK_MSG_VERDICT]                    = "sk_msg_verdict",
>> +       [BPF_LIRC_MODE2]                        = "lirc_mode2",
>> +       [BPF_FLOW_DISSECTOR]                    = "flow_dissector",
>> +       [BPF_TRACE_RAW_TP]                      = "raw_tp",
>> +       [BPF_TRACE_FENTRY]                      = "fentry",
>> +       [BPF_TRACE_FEXIT]                       = "fexit",
>> +       [BPF_MODIFY_RETURN]                     = "mod_ret",
>> +       [BPF_LSM_MAC]                           = "lsm_mac",
>> +       [BPF_SK_LOOKUP]                         = "sk_lookup",
>> +       [BPF_TRACE_ITER]                        = "trace_iter",
>> +       [BPF_XDP_DEVMAP]                        = "xdp_devmap",
>> +       [BPF_XDP_CPUMAP]                        = "xdp_cpumap",
>> +       [BPF_XDP]                               = "xdp",
>> +       [BPF_SK_REUSEPORT_SELECT]               = "sk_skb_reuseport_select",
>> +       [BPF_SK_REUSEPORT_SELECT_OR_MIGRATE]    = "sk_skb_reuseport_select_or_migrate",
>>  };
>>
> 
> you are ruining Git blaming abilities for purely aesthetic reasons,
> which are not good enough reasons, IMO. Please don't do this, this
> nice alignment is nice, but definitely not necessary. So whatever is
> longer then the "default indentation", just add another tab or two and
> be done with it.

I think I've been asked to do the opposite in the past. And I wouldn't
be ruining much in the current case, the array has been moved from
another location and nearly all types were added here in the same
commit. But OK.

> That way we can actually see what was added in this
> patch, btw.

On this one I agree :)
