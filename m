Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7254C233C62
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgGaAFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:05:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:45658 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgGaAFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:05:05 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IXd-0006zp-9m; Fri, 31 Jul 2020 02:04:53 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IXd-000XoE-3O; Fri, 31 Jul 2020 02:04:53 +0200
Subject: Re: [PATCH bpf-next v5 15/15] selftests/bpf: Tests for BPF_SK_LOOKUP
 attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200717103536.397595-1-jakub@cloudflare.com>
 <20200717103536.397595-16-jakub@cloudflare.com>
 <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com>
 <891f94a4-1663-0830-516c-348c965844fe@iogearbox.net>
 <87mu3iwvio.fsf@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <884c4328-8515-33e6-d535-6f9747ce007d@iogearbox.net>
Date:   Fri, 31 Jul 2020 02:04:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87mu3iwvio.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 10:55 AM, Jakub Sitnicki wrote:
> Hi Daniel,
> 
> On Tue, Jul 28, 2020 at 10:47 PM CEST, Daniel Borkmann wrote:
> 
> [...]
> 
>> Jakub, I'm actually seeing a slightly different one on my test machine with sk_lookup:
>>
>> # ./test_progs -t sk_lookup
>> #14 cgroup_skb_sk_lookup:OK
>> #73/1 query lookup prog:OK
>> #73/2 TCP IPv4 redir port:OK
>> #73/3 TCP IPv4 redir addr:OK
>> #73/4 TCP IPv4 redir with reuseport:OK
>> #73/5 TCP IPv4 redir skip reuseport:OK
>> #73/6 TCP IPv6 redir port:OK
>> #73/7 TCP IPv6 redir addr:OK
>> #73/8 TCP IPv4->IPv6 redir port:OK
>> #73/9 TCP IPv6 redir with reuseport:OK
>> #73/10 TCP IPv6 redir skip reuseport:OK
>> #73/11 UDP IPv4 redir port:OK
>> #73/12 UDP IPv4 redir addr:OK
>> #73/13 UDP IPv4 redir with reuseport:OK
>> attach_lookup_prog:PASS:open 0 nsec
>> attach_lookup_prog:PASS:bpf_program__attach_netns 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> update_lookup_map:PASS:bpf_map__fd 0 nsec
>> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> update_lookup_map:PASS:bpf_map__fd 0 nsec
>> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> run_lookup_prog:PASS:getsockname 0 nsec
>> run_lookup_prog:PASS:connect 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_client:PASS:make_client 0 nsec
>> send_byte:PASS:send_byte 0 nsec
>> udp_recv_send:FAIL:recvmsg failed
>> (/root/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:339: errno: Resource temporarily unavailable) failed to receive
>> #73/14 UDP IPv4 redir and reuseport with conns:FAIL
>> #73/15 UDP IPv4 redir skip reuseport:OK
>> #73/16 UDP IPv6 redir port:OK
>> #73/17 UDP IPv6 redir addr:OK
>> #73/18 UDP IPv4->IPv6 redir port:OK
>> #73/19 UDP IPv6 redir and reuseport:OK
>> attach_lookup_prog:PASS:open 0 nsec
>> attach_lookup_prog:PASS:bpf_program__attach_netns 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> update_lookup_map:PASS:bpf_map__fd 0 nsec
>> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> update_lookup_map:PASS:bpf_map__fd 0 nsec
>> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
>> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
>> make_server:PASS:bind 0 nsec
>> make_server:PASS:attach_reuseport 0 nsec
>> run_lookup_prog:PASS:getsockname 0 nsec
>> run_lookup_prog:PASS:connect 0 nsec
>> make_socket:PASS:make_address 0 nsec
>> make_socket:PASS:socket 0 nsec
>> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
>> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
>> make_client:PASS:make_client 0 nsec
>> send_byte:PASS:send_byte 0 nsec
>> udp_recv_send:FAIL:recvmsg failed
>> (/root/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:339: errno: Resource temporarily unavailable) failed to receive
>> #73/20 UDP IPv6 redir and reuseport with conns:FAIL
>> #73/21 UDP IPv6 redir skip reuseport:OK
>> #73/22 TCP IPv4 drop on lookup:OK
>> #73/23 TCP IPv6 drop on lookup:OK
>> #73/24 UDP IPv4 drop on lookup:OK
>> #73/25 UDP IPv6 drop on lookup:OK
>> #73/26 TCP IPv4 drop on reuseport:OK
>> #73/27 TCP IPv6 drop on reuseport:OK
>> #73/28 UDP IPv4 drop on reuseport:OK
>> #73/29 TCP IPv6 drop on reuseport:OK
>> #73/30 sk_assign returns EEXIST:OK
>> #73/31 sk_assign honors F_REPLACE:OK
>> #73/32 sk_assign accepts NULL socket:OK
>> #73/33 access ctx->sk:OK
>> #73/34 narrow access to ctx v4:OK
>> #73/35 narrow access to ctx v6:OK
>> #73/36 sk_assign rejects TCP established:OK
>> #73/37 sk_assign rejects UDP connected:OK
>> #73/38 multi prog - pass, pass:OK
>> #73/39 multi prog - drop, drop:OK
>> #73/40 multi prog - pass, drop:OK
>> #73/41 multi prog - drop, pass:OK
>> #73/42 multi prog - pass, redir:OK
>> #73/43 multi prog - redir, pass:OK
>> #73/44 multi prog - drop, redir:OK
>> #73/45 multi prog - redir, drop:OK
>> #73/46 multi prog - redir, redir:OK
>> #73 sk_lookup:FAIL
>> Summary: 1/44 PASSED, 0 SKIPPED, 3 FAILED
> 
> This patch addresses the failures:
> 
>    https://lore.kernel.org/bpf/20200726120228.1414348-1-jakub@cloudflare.com/
> 
> It spawned a discussion on what to do about reuseport bpf returning
> connected udp sockets, and the conclusion was that it would be best to
> change reuseport logic itself if no one is relying on said behavior.
> 
> IOW, I belive the fix does the right thing and can be applied as is. We
> get the same reuseport behavior everywhere, that is with regular socket
> lookup and BPF sk lookup, even if that behavior needs to be changed.

Seems reasonable to me, I've applied it to bpf-next, thanks Jakub!
