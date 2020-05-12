Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C11CF3E3
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 13:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgELL5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 07:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgELL5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 07:57:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBF9C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 04:57:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l18so14993126wrn.6
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 04:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3+1UCndI9AXECNjAszE65h8ymzBGEnwP0Tn3NvmhVbM=;
        b=hMshJeAipdM0jP2BQh5thdVg0AnuDfmz7Wkybc9ckxXSzdyl62xm5aaWkdbR64zn7a
         0XPJOVJ5kAmPHTtJnCqfejZgfzLZI5GpyBHADub/n5XvLC64DHT1Oo8rq+NKH/1x+EH7
         q3fvF0rJ70gcWagx/EP+ISGrGzyLsHZFCGeJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=3+1UCndI9AXECNjAszE65h8ymzBGEnwP0Tn3NvmhVbM=;
        b=WgfZc+FBZjihDwikSJl4rjq9+If5WOEVNQ+tpMkvafj+bmzmXBrBt2c8cai/NHlPyW
         ebeBWxcUpQcDDLDwrg0MtfrYjMDRX+Pj5EQRcWZVXm2Q+K1V8D0i8FrGY2ZIpWEs1tVf
         HxPN2B6maQj9L++wyuVrrHNA7Ve51zYkV+/n+e+gJEQZgtzWU8osKB/Ee1W4Y38s/YZk
         ypw4dq4ehzLIZ/oE4efyFL6Cky8DBBftcygwvOWVpA/avBaqSIjP5/IzqC/Qxw7Ig2eu
         1NxFGm/Uk5dG59fWo9/3OFZy+w5Ak+1UtVE47WS9FOTDETLrX2iXmuAFEL2mFyCnJ4v5
         JOBA==
X-Gm-Message-State: AGi0PuZ3H5f5FKy/Ci5dnNGqWQ6TEIrD4iesafCPPHB1woafaGS1UsUg
        g8D8wZiSD6KVi2KPIWh4t1Fjzg==
X-Google-Smtp-Source: APiQypIiieCVQbqmIPE4X2PTSsXEHDaKz6VBIRYLAVcW3jOS3STlVT4jJihvEo7MLcz3fU0TVxip2g==
X-Received: by 2002:adf:e511:: with SMTP id j17mr26735518wrm.204.1589284667329;
        Tue, 12 May 2020 04:57:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g184sm16978351wmg.1.2020.05.12.04.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 04:57:46 -0700 (PDT)
References: <20200511185218.1422406-1-jakub@cloudflare.com> <20200511194520.pr5d74ao34jigvof@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/17] Run a BPF program on socket lookup
In-reply-to: <20200511194520.pr5d74ao34jigvof@kafai-mbp.dhcp.thefacebook.com>
Date:   Tue, 12 May 2020 13:57:45 +0200
Message-ID: <873685v006.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 09:45 PM CEST, Martin KaFai Lau wrote:
> On Mon, May 11, 2020 at 08:52:01PM +0200, Jakub Sitnicki wrote:
>
> [ ... ]
>
>> Performance considerations
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>>
>> Patch set adds new code on receive hot path. This comes with a cost,
>> especially in a scenario of a SYN flood or small UDP packet flood.
>>
>> Measuring the performance penalty turned out to be harder than expected
>> because socket lookup is fast. For CPUs to spend >=3D 1% of time in sock=
et
>> lookup we had to modify our setup by unloading iptables and reducing the
>> number of routes.
>>
>> The receiver machine is a Cloudflare Gen 9 server covered in detail at [=
0].
>> In short:
>>
>>  - 24 core Intel custom off-roadmap 1.9Ghz 150W (Skylake) CPU
>>  - dual-port 25G Mellanox ConnectX-4 NIC
>>  - 256G DDR4 2666Mhz RAM
>>
>> Flood traffic pattern:
>>
>>  - source: 1 IP, 10k ports
>>  - destination: 1 IP, 1 port
>>  - TCP - SYN packet
>>  - UDP - Len=3D0 packet
>>
>> Receiver setup:
>>
>>  - ingress traffic spread over 4 RX queues,
>>  - RX/TX pause and autoneg disabled,
>>  - Intel Turbo Boost disabled,
>>  - TCP SYN cookies always on.
>>
>> For TCP test there is a receiver process with single listening socket
>> open. Receiver is not accept()'ing connections.
>>
>> For UDP the receiver process has a single UDP socket with a filter
>> installed, dropping the packets.
>>
>> With such setup in place, we record RX pps and cpu-cycles events under
>> flood for 60 seconds in 3 configurations:
>>
>>  1. 5.6.3 kernel w/o this patch series (baseline),
>>  2. 5.6.3 kernel with patches applied, but no SK_LOOKUP program attached,
>>  3. 5.6.3 kernel with patches applied, and SK_LOOKUP program attached;
>>     BPF program [1] is doing a lookup LPM_TRIE map with 200 entries.
> Is the link in [1] up-to-date?  I don't see it calling bpf_sk_assign().

Yes, it is, or rather was.

The reason why the inet-tool version you reviewed was not using
bpf_sk_assign(), but the "old way" from RFCv2, is that the switch to
map_lookup+sk_assign was done late in development, after changes to
SOCKMAP landed in bpf-next.

By that time performance tests were already in progress, and since they
take a bit of time to set up, and the change affected just the scenario
with program attached, I tested without this bit.

Sorry, I should have explained that in the cover letter. The next round
of benchmarks will be done against the now updated version of inet-tool
that uses bpf_sk_assign:

https://github.com/majek/inet-tool/commit/6a619c3743aaae6d4882cbbf11b616e1e=
468b436

>
>>
>> RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 second=
s.
>>
>> | tcp4 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94 rx=
 pps |
>> |------------------------------+------------------------+----------|
>> | 5.6.3 vanilla (baseline)     | 939,616 =C2=B1 0.5%         |        - |
>> | no SK_LOOKUP prog attached   | 929,275 =C2=B1 1.2%         |    -1.1% |
>> | with SK_LOOKUP prog attached | 918,582 =C2=B1 0.4%         |    -2.2% |
>>
>> | tcp6 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94 rx=
 pps |
>> |------------------------------+------------------------+----------|
>> | 5.6.3 vanilla (baseline)     | 875,838 =C2=B1 0.5%         |        - |
>> | no SK_LOOKUP prog attached   | 872,005 =C2=B1 0.3%         |    -0.4% |
>> | with SK_LOOKUP prog attached | 856,250 =C2=B1 0.5%         |    -2.2% |
>>
>> | udp4 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94 rx=
 pps |
>> |------------------------------+------------------------+----------|
>> | 5.6.3 vanilla (baseline)     | 2,738,662 =C2=B1 1.5%       |        - |
>> | no SK_LOOKUP prog attached   | 2,576,893 =C2=B1 1.0%       |    -5.9% |
>> | with SK_LOOKUP prog attached | 2,530,698 =C2=B1 1.0%       |    -7.6% |
>>
>> | udp6 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94 rx=
 pps |
>> |------------------------------+------------------------+----------|
>> | 5.6.3 vanilla (baseline)     | 2,867,885 =C2=B1 1.4%       |        - |
>> | no SK_LOOKUP prog attached   | 2,646,875 =C2=B1 1.0%       |    -7.7% |
> What is causing this regression?
>

I need to go back to archived perf.data and see if perf-annotate or
perf-diff provide any clues that will help me tell where CPU cycles are
going. Will get back to you on that.

Wild guess is that for udp6 we're loading and coping more data to
populate v6 addresses in program context. See inet6_lookup_run_bpf
(patch 7).

This makes me realize the copy is unnecessary, I could just store the
pointer to in6_addr{}. Will make this change in v3.

As to why udp6 is taking a bigger hit than udp4 - comparing top 10 in
`perf report --no-children` shows that in our test setup, socket lookup
contributes less to CPU cycles on receive for udp4 than for udp6.

* udp4 baseline (no children)

# Overhead       Samples  Symbol
# ........  ............  ......................................
#
     8.11%         19429  [k] fib_table_lookup
     4.31%         10333  [k] udp_queue_rcv_one_skb
     3.75%          8991  [k] fib4_rule_action
     3.66%          8763  [k] __netif_receive_skb_core
     3.42%          8198  [k] fib_rules_lookup
     3.05%          7314  [k] fib4_rule_match
     2.71%          6507  [k] mlx5e_skb_from_cqe_linear
     2.58%          6192  [k] inet_gro_receive
     2.49%          5981  [k] __x86_indirect_thunk_rax
     2.36%          5656  [k] udp4_lib_lookup2

* udp6 baseline (no children)

# Overhead       Samples  Symbol
# ........  ............  ......................................
#
     4.63%         11100  [k] udpv6_queue_rcv_one_skb
     3.88%          9308  [k] __netif_receive_skb_core
     3.54%          8480  [k] udp6_lib_lookup2
     2.69%          6442  [k] mlx5e_skb_from_cqe_linear
     2.56%          6137  [k] ipv6_gro_receive
     2.31%          5540  [k] dev_gro_receive
     2.20%          5264  [k] do_csum
     2.02%          4835  [k] ip6_pol_route
     1.94%          4639  [k] __udp6_lib_lookup
     1.89%          4540  [k] selinux_socket_sock_rcv_skb

Notice that __udp4_lib_lookup didn't even make the cut. That could
explain why adding instructions to __udp6_lib_lookup has more effect on
RX PPS.

Frankly, that is something that suprised us, but we didn't have time to
investigate further, yet.

>> | with SK_LOOKUP prog attached | 2,520,474 =C2=B1 0.7%       |   -12.1% |
> This also looks very different from udp4.
>

Thanks for the questions,
Jakub
