Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75AF231BAE
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgG2IzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgG2IzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:55:16 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE69C0619D2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:55:15 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k13so12607404lfo.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=8L8D/nK8y1XzW/trlaVpU5smarSVbjSHeNmxrK5S3II=;
        b=X7CxcoXQhOgWXBbIRkX5wh1u3OPdHWbG5owooIWCbOQpvOrCNr1BOR7MPzREkhsnPI
         inpcWgj3ya3chKXWYf8v1XMCsyVQhxTagBtOtwmdcwmKIYarP28Uo4kDi1WlSZXFiSIX
         z4Q/4XQDvNQZPio9Gi45GxE2RYyVYI4x3a0Ns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=8L8D/nK8y1XzW/trlaVpU5smarSVbjSHeNmxrK5S3II=;
        b=YEmJM1POK5VXv0rGk/W0+RlI1RztDwRcKImNX1bB9kp6I1sBrK25Z8tOmwNBlGa1Q7
         EUYvNc8MKV9c/4XCIVljipfFMHrKogkqINjNx/PtFihKP4pCjilwZq2i28PQfbU43zcg
         8WCKNrxmB9FEUYRr61ZNxDAxtpulurvkHh++ClndUnnA5uo219JibTKMBLh7Fjh318jv
         vZ4U+BCiZmsiz24yTEma+/oCr6A2cJUmk7mJ5nFKCFfg5+cAMXPHCmsuf/kcydOiTdT1
         Nhey86V0XtjwezQIdkaqIYNP7S29Kv3Nci0VgPKryzHk9b/vScPNd4IK6zUfWNoXqvkR
         yPnQ==
X-Gm-Message-State: AOAM533d1k4Hfr6oxndYVxE3/MIZmibvr0+6+27tFw0S31VIF5FvtQRl
        juJ5XDf0cPR7y5Wq2Km90cFUDQ==
X-Google-Smtp-Source: ABdhPJz/Swh+MDJVrvQcHnPCKTylj0XOUN1i6n2MGa66tpDG38V0CT57NYRVsJH9JVCkbOvoMP5Ohg==
X-Received: by 2002:ac2:58c6:: with SMTP id u6mr16636479lfo.105.1596012913343;
        Wed, 29 Jul 2020 01:55:13 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q22sm309834lfc.33.2020.07.29.01.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 01:55:12 -0700 (PDT)
References: <20200717103536.397595-1-jakub@cloudflare.com> <20200717103536.397595-16-jakub@cloudflare.com> <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com> <891f94a4-1663-0830-516c-348c965844fe@iogearbox.net>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v5 15/15] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
In-reply-to: <891f94a4-1663-0830-516c-348c965844fe@iogearbox.net>
Date:   Wed, 29 Jul 2020 10:55:11 +0200
Message-ID: <87mu3iwvio.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Jul 28, 2020 at 10:47 PM CEST, Daniel Borkmann wrote:

[...]

> Jakub, I'm actually seeing a slightly different one on my test machine with sk_lookup:
>
> # ./test_progs -t sk_lookup
> #14 cgroup_skb_sk_lookup:OK
> #73/1 query lookup prog:OK
> #73/2 TCP IPv4 redir port:OK
> #73/3 TCP IPv4 redir addr:OK
> #73/4 TCP IPv4 redir with reuseport:OK
> #73/5 TCP IPv4 redir skip reuseport:OK
> #73/6 TCP IPv6 redir port:OK
> #73/7 TCP IPv6 redir addr:OK
> #73/8 TCP IPv4->IPv6 redir port:OK
> #73/9 TCP IPv6 redir with reuseport:OK
> #73/10 TCP IPv6 redir skip reuseport:OK
> #73/11 UDP IPv4 redir port:OK
> #73/12 UDP IPv4 redir addr:OK
> #73/13 UDP IPv4 redir with reuseport:OK
> attach_lookup_prog:PASS:open 0 nsec
> attach_lookup_prog:PASS:bpf_program__attach_netns 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> update_lookup_map:PASS:bpf_map__fd 0 nsec
> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> update_lookup_map:PASS:bpf_map__fd 0 nsec
> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> run_lookup_prog:PASS:getsockname 0 nsec
> run_lookup_prog:PASS:connect 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_client:PASS:make_client 0 nsec
> send_byte:PASS:send_byte 0 nsec
> udp_recv_send:FAIL:recvmsg failed
> (/root/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:339: errno: Resource temporarily unavailable) failed to receive
> #73/14 UDP IPv4 redir and reuseport with conns:FAIL
> #73/15 UDP IPv4 redir skip reuseport:OK
> #73/16 UDP IPv6 redir port:OK
> #73/17 UDP IPv6 redir addr:OK
> #73/18 UDP IPv4->IPv6 redir port:OK
> #73/19 UDP IPv6 redir and reuseport:OK
> attach_lookup_prog:PASS:open 0 nsec
> attach_lookup_prog:PASS:bpf_program__attach_netns 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> update_lookup_map:PASS:bpf_map__fd 0 nsec
> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> update_lookup_map:PASS:bpf_map__fd 0 nsec
> update_lookup_map:PASS:bpf_map_update_elem 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_server:PASS:setsockopt(IP_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(IPV6_RECVORIGDSTADDR) 0 nsec
> make_server:PASS:setsockopt(SO_REUSEPORT) 0 nsec
> make_server:PASS:bind 0 nsec
> make_server:PASS:attach_reuseport 0 nsec
> run_lookup_prog:PASS:getsockname 0 nsec
> run_lookup_prog:PASS:connect 0 nsec
> make_socket:PASS:make_address 0 nsec
> make_socket:PASS:socket 0 nsec
> make_socket:PASS:setsockopt(SO_SNDTIMEO) 0 nsec
> make_socket:PASS:setsockopt(SO_RCVTIMEO) 0 nsec
> make_client:PASS:make_client 0 nsec
> send_byte:PASS:send_byte 0 nsec
> udp_recv_send:FAIL:recvmsg failed
> (/root/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:339: errno: Resource temporarily unavailable) failed to receive
> #73/20 UDP IPv6 redir and reuseport with conns:FAIL
> #73/21 UDP IPv6 redir skip reuseport:OK
> #73/22 TCP IPv4 drop on lookup:OK
> #73/23 TCP IPv6 drop on lookup:OK
> #73/24 UDP IPv4 drop on lookup:OK
> #73/25 UDP IPv6 drop on lookup:OK
> #73/26 TCP IPv4 drop on reuseport:OK
> #73/27 TCP IPv6 drop on reuseport:OK
> #73/28 UDP IPv4 drop on reuseport:OK
> #73/29 TCP IPv6 drop on reuseport:OK
> #73/30 sk_assign returns EEXIST:OK
> #73/31 sk_assign honors F_REPLACE:OK
> #73/32 sk_assign accepts NULL socket:OK
> #73/33 access ctx->sk:OK
> #73/34 narrow access to ctx v4:OK
> #73/35 narrow access to ctx v6:OK
> #73/36 sk_assign rejects TCP established:OK
> #73/37 sk_assign rejects UDP connected:OK
> #73/38 multi prog - pass, pass:OK
> #73/39 multi prog - drop, drop:OK
> #73/40 multi prog - pass, drop:OK
> #73/41 multi prog - drop, pass:OK
> #73/42 multi prog - pass, redir:OK
> #73/43 multi prog - redir, pass:OK
> #73/44 multi prog - drop, redir:OK
> #73/45 multi prog - redir, drop:OK
> #73/46 multi prog - redir, redir:OK
> #73 sk_lookup:FAIL
> Summary: 1/44 PASSED, 0 SKIPPED, 3 FAILED

This patch addresses the failures:

  https://lore.kernel.org/bpf/20200726120228.1414348-1-jakub@cloudflare.com/

It spawned a discussion on what to do about reuseport bpf returning
connected udp sockets, and the conclusion was that it would be best to
change reuseport logic itself if no one is relying on said behavior.

IOW, I belive the fix does the right thing and can be applied as is. We
get the same reuseport behavior everywhere, that is with regular socket
lookup and BPF sk lookup, even if that behavior needs to be changed.

[...]
