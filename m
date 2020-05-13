Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273721D1CA4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgEMRyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732611AbgEMRyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:54:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED35C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 10:54:12 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y16so561393wrs.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 10:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qrPZKJXbGMwALSemLP7RWVRFNnIGoUHXOtqWHeuOnBM=;
        b=m8GDk2ZJuxXcQH9Qgz1yyarlKJmlgRGd5bP9O8+N57gCdGHGjC2a604HpAdDRjq3Yb
         bEX8oyzOfv6UQhFqyVSZgGHm0Bjk34oU43Ta141Z/xe8g1zMUjSQ6zJUT0gpP687Mlux
         ByW8XUV4E/BGFJmAD2Ft+v6e5sgH+EO1JZb+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=qrPZKJXbGMwALSemLP7RWVRFNnIGoUHXOtqWHeuOnBM=;
        b=LkIT9Y8RshxHQVWWtIXBiNY//VMEJ7cRDlMBQldemZDJIPQHaasOiTH/6G5gjSzVCm
         Yi+jHhMcKewZKqS7dlpHCyeiEbVQrY/bMbKaKIEHNkzoF9Wx177xrOaO3EjBAAUEBN5y
         wyxH84cmY+cGEAyifemFdQzChd7IYUu7bAeLNn8JphBSNNccnb4EgpPhMJEkkMNH0nVY
         LerJ44Imygwh7UxC8YZJt0f79Zu0KsdJYeNAwtnRRZDnt02QoCowR1cA7igbVRZGFCt6
         xXiX93PCmRuO3ZARUOrwR6TeGda+jswvNGO8BAvU4+AmkAIIz1wjiBTDHd9DYYJqjbH4
         tr/Q==
X-Gm-Message-State: AOAM531I/N2h5yEadLsp089Q681on4YAEl+tW66vB/Zy4HqVT/9optYj
        c8/KMOEpLjaEsTVnJxjKf+JBBA==
X-Google-Smtp-Source: ABdhPJzMtvEq/fdpSueoeNKLighk3hZkMq5VUtyCbv+B9aih8PhQOK52MbyKBYu45+K2NMqZh5icBQ==
X-Received: by 2002:adf:8023:: with SMTP id 32mr523523wrk.247.1589392451540;
        Wed, 13 May 2020 10:54:11 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z7sm274020wrl.88.2020.05.13.10.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 10:54:10 -0700 (PDT)
References: <20200511185218.1422406-1-jakub@cloudflare.com> <20200511194520.pr5d74ao34jigvof@kafai-mbp.dhcp.thefacebook.com> <873685v006.fsf@cloudflare.com> <20200512163411.4ae2faoa6hwnrv3k@kafai-mbp.dhcp.thefacebook.com>
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
In-reply-to: <20200512163411.4ae2faoa6hwnrv3k@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 13 May 2020 19:54:09 +0200
Message-ID: <87sgg3u3em.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 06:34 PM CEST, Martin KaFai Lau wrote:
> On Tue, May 12, 2020 at 01:57:45PM +0200, Jakub Sitnicki wrote:
>> On Mon, May 11, 2020 at 09:45 PM CEST, Martin KaFai Lau wrote:
>> > On Mon, May 11, 2020 at 08:52:01PM +0200, Jakub Sitnicki wrote:

[...]

>> >> RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 sec=
onds.
>> >>
>> >> | tcp4 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94=
 rx pps |
>> >> |------------------------------+------------------------+----------|
>> >> | 5.6.3 vanilla (baseline)     | 939,616 =C2=B1 0.5%         |       =
 - |
>> >> | no SK_LOOKUP prog attached   | 929,275 =C2=B1 1.2%         |    -1.=
1% |
>> >> | with SK_LOOKUP prog attached | 918,582 =C2=B1 0.4%         |    -2.=
2% |
>> >>
>> >> | tcp6 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94=
 rx pps |
>> >> |------------------------------+------------------------+----------|
>> >> | 5.6.3 vanilla (baseline)     | 875,838 =C2=B1 0.5%         |       =
 - |
>> >> | no SK_LOOKUP prog attached   | 872,005 =C2=B1 0.3%         |    -0.=
4% |
>> >> | with SK_LOOKUP prog attached | 856,250 =C2=B1 0.5%         |    -2.=
2% |
>> >>
>> >> | udp4 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94=
 rx pps |
>> >> |------------------------------+------------------------+----------|
>> >> | 5.6.3 vanilla (baseline)     | 2,738,662 =C2=B1 1.5%       |       =
 - |
>> >> | no SK_LOOKUP prog attached   | 2,576,893 =C2=B1 1.0%       |    -5.=
9% |
>> >> | with SK_LOOKUP prog attached | 2,530,698 =C2=B1 1.0%       |    -7.=
6% |
>> >>
>> >> | udp6 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94=
 rx pps |
>> >> |------------------------------+------------------------+----------|
>> >> | 5.6.3 vanilla (baseline)     | 2,867,885 =C2=B1 1.4%       |       =
 - |
>> >> | no SK_LOOKUP prog attached   | 2,646,875 =C2=B1 1.0%       |    -7.=
7% |
>> > What is causing this regression?
>> >
>>
>> I need to go back to archived perf.data and see if perf-annotate or
>> perf-diff provide any clues that will help me tell where CPU cycles are
>> going. Will get back to you on that.
>>
>> Wild guess is that for udp6 we're loading and coping more data to
>> populate v6 addresses in program context. See inet6_lookup_run_bpf
>> (patch 7).
> If that is the case,
> rcu_access_pointer(net->sk_lookup_prog) should be tested first before
> doing ctx initialization.

Coming back after looking for more hints in recorded perf.data.

`perf diff` between baseline and no-prog-attached shows:

# Event 'cycles'
#
# Baseline    Delta  Symbol
# ........  .......  ......................................
#
     4.63%   +0.07%  [k] udpv6_queue_rcv_one_skb
     3.88%   -0.38%  [k] __netif_receive_skb_core
     3.54%   +0.21%  [k] udp6_lib_lookup2
     3.01%   -0.42%  [k] 0xffffffffc04926cc
     2.69%   -0.10%  [k] mlx5e_skb_from_cqe_linear
     2.56%   -0.20%  [k] ipv6_gro_receive
     2.31%   -0.15%  [k] dev_gro_receive
     2.20%   -0.13%  [k] do_csum
     2.02%   -0.68%  [k] ip6_pol_route
     1.94%   +0.79%  [k] __udp6_lib_lookup

So __udp6_lib_lookup is where to look, as expected.

`perf annotate __udp6_lib_lookup` for no-prog-attached has a hot spot
right were we populate the context object:


         :                      /* Lookup redirect from BPF */
         :                      result =3D inet6_lookup_run_bpf(net, udptab=
le->protocol,
    0.00 :   ffffffff818530db:       mov    0x18(%r14),%edx
         :                      inet6_lookup_run_bpf():
         :                      const struct in6_addr *saddr,
         :                      __be16 sport,
         :                      const struct in6_addr *daddr,
         :                      unsigned short hnum)
         :                      {
         :                      struct bpf_inet_lookup_kern ctx =3D {
 inet6_hashtables.h:115    1.27 :   ffffffff818530df:       lea    -0x78(%r=
bp),%r9
    0.00 :   ffffffff818530e3:       xor    %eax,%eax
    0.00 :   ffffffff818530e5:       mov    $0x8,%ecx
    0.00 :   ffffffff818530ea:       mov    %r9,%rdi
 inet6_hashtables.h:115   26.09 :   ffffffff818530ed:       rep stos %rax,%=
es:(%rdi)
 inet6_hashtables.h:115    1.35 :   ffffffff818530f0:       mov    $0xa,%eax
    0.00 :   ffffffff818530f5:       mov    %bx,-0x60(%rbp)
    0.00 :   ffffffff818530f9:       mov    %ax,-0x78(%rbp)
    0.00 :   ffffffff818530fd:       mov    (%r15),%rax
    1.42 :   ffffffff81853100:       mov    %dl,-0x76(%rbp)
    0.00 :   ffffffff81853103:       mov    0x8(%r15),%rdx
    0.00 :   ffffffff81853107:       mov    %r11w,-0x48(%rbp)
    0.00 :   ffffffff8185310c:       mov    %rax,-0x70(%rbp)
    1.27 :   ffffffff81853110:       mov    (%r12),%rax
    0.02 :   ffffffff81853114:       mov    %rdx,-0x68(%rbp)
    0.00 :   ffffffff81853118:       mov    0x8(%r12),%rdx
    0.02 :   ffffffff8185311d:       mov    %rax,-0x58(%rbp)
    1.24 :   ffffffff81853121:       mov    %rdx,-0x50(%rbp)
         :                      __read_once_size():
         :                      })
         :
         :                      static __always_inline
         :                      void __read_once_size(const volatile void *=
p, void *res, int size)
         :                      {
         :                      __READ_ONCE_SIZE;
    0.05 :   ffffffff81853125:       mov    0xd28(%r13),%rdx

Note, struct bpf_inet_lookup has been renamed to bpf_sk_lookup since
then.

I'll switch to copying just the pointer to in6_addr{} and push the
context initialization after test for net->sk_lookup_prog, like you
suggested.

I can post full output from perf-diff/annotate to some pastebin if you
would like to take a deeper look.

Thanks,
Jakub

>
>>
>> This makes me realize the copy is unnecessary, I could just store the
>> pointer to in6_addr{}. Will make this change in v3.
>>
>> As to why udp6 is taking a bigger hit than udp4 - comparing top 10 in
>> `perf report --no-children` shows that in our test setup, socket lookup
>> contributes less to CPU cycles on receive for udp4 than for udp6.
>>
>> * udp4 baseline (no children)
>>
>> # Overhead       Samples  Symbol
>> # ........  ............  ......................................
>> #
>>      8.11%         19429  [k] fib_table_lookup
>>      4.31%         10333  [k] udp_queue_rcv_one_skb
>>      3.75%          8991  [k] fib4_rule_action
>>      3.66%          8763  [k] __netif_receive_skb_core
>>      3.42%          8198  [k] fib_rules_lookup
>>      3.05%          7314  [k] fib4_rule_match
>>      2.71%          6507  [k] mlx5e_skb_from_cqe_linear
>>      2.58%          6192  [k] inet_gro_receive
>>      2.49%          5981  [k] __x86_indirect_thunk_rax
>>      2.36%          5656  [k] udp4_lib_lookup2
>>
>> * udp6 baseline (no children)
>>
>> # Overhead       Samples  Symbol
>> # ........  ............  ......................................
>> #
>>      4.63%         11100  [k] udpv6_queue_rcv_one_skb
>>      3.88%          9308  [k] __netif_receive_skb_core
>>      3.54%          8480  [k] udp6_lib_lookup2
>>      2.69%          6442  [k] mlx5e_skb_from_cqe_linear
>>      2.56%          6137  [k] ipv6_gro_receive
>>      2.31%          5540  [k] dev_gro_receive
>>      2.20%          5264  [k] do_csum
>>      2.02%          4835  [k] ip6_pol_route
>>      1.94%          4639  [k] __udp6_lib_lookup
>>      1.89%          4540  [k] selinux_socket_sock_rcv_skb
>>
>> Notice that __udp4_lib_lookup didn't even make the cut. That could
>> explain why adding instructions to __udp6_lib_lookup has more effect on
>> RX PPS.
>>
>> Frankly, that is something that suprised us, but we didn't have time to
>> investigate further, yet.
> The perf report should be able to annotate bpf prog also.
> e.g. may be part of it is because the bpf_prog itself is also dealing
> with a longer address?
>
>>
>> >> | with SK_LOOKUP prog attached | 2,520,474 =C2=B1 0.7%       |   -12.=
1% |
>> > This also looks very different from udp4.
>> >
>>
>> Thanks for the questions,
>> Jakub
