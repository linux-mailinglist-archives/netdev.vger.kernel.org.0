Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA29108251
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfKXGKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:10:38 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39462 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfKXGKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:10:37 -0500
Received: by mail-il1-f195.google.com with SMTP id a7so11180013ild.6;
        Sat, 23 Nov 2019 22:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UNXlGZn5plm4idsFpKsZppMq8DKcyV4i3fwszcVIW3s=;
        b=s8S46adXumtlmxhNWI6S7F4MzNNztFZbJkzPJ9boOFkPGxgYznqdcFNEUsiq3nzOQ9
         tpWkNTFx24FLSbNMYkRHR3LleLHIADXG3sxIYXvyslzZq1WijE9h+v/m/shcvE4SDQGp
         Xd9/AaQ6lvJKFXUpGLGOA3CPt8cjfv0zrVYKIolLF2jyPOzmsmU+hpZ57hlSCj4rFTEo
         nww/TC2t97cL85tH/p9E7w2rHMpo/mzyKgBnKhjBrtVs+Y8BmkXlCg47Wai2aglniqw0
         rniBFtI60TKc3ac9ldZywwr/kLN8xoVdguHwYsTUhYoOALiCr321xo4LmBtigQZlnMWh
         8eQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UNXlGZn5plm4idsFpKsZppMq8DKcyV4i3fwszcVIW3s=;
        b=bqACFb57Zg55Mz4ppnhgDiaWdGA/pZQsoy3onUZSUYOD2uhbncSrbYzsWyKIBIjGUW
         6jKyJMK8CmH3G4+9IPV1PH4iceAN9aBT6SgEXpr6kHlAsQaAsBzy+guVOVoXfWlGUQj1
         UmzyOZj+9ZJU1XPNRdjnBDuTXN3zWG4cuIEyorTnmJ+6XVI1xH72+QiouqtyK9eNIWYb
         NnKz8n7pD/4PoAHxZ6WWlTydnl71k6tM881nw6nCP8gIzJ2QUk5Y7i84Z/CAmOMov4an
         4n000nSIFzqydQIPRrn+alN8epMCKfZDg3E6b7hBovOKODBkfUsjOyr3f8g1I7M/qFN3
         MxJw==
X-Gm-Message-State: APjAAAWKph6HqJuyT0t5EohKgPT5260KLY6vFkbvTUEBQ50/rk096V6Y
        Sb2I2bEzwxA7Har30a9jP0go17SB
X-Google-Smtp-Source: APXvYqyLJzs7bMlaea5amsnJuzN4Sq0YKH7kWiC5dQAWW7W+cGQrmtvl2vVWZTVHtLDQgdYR5rxCeA==
X-Received: by 2002:a92:d450:: with SMTP id r16mr25451629ilm.147.1574575836449;
        Sat, 23 Nov 2019 22:10:36 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u18sm810870ior.62.2019.11.23.22.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 22:10:35 -0800 (PST)
Date:   Sat, 23 Nov 2019 22:10:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1ed3e7f5d_62c72ad877f985c42f@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-1-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 0/8] Extend SOCKMAP to store listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> This patch set makes SOCKMAP more flexible by allowing it to hold TCP
> sockets that are either in established or listening state. With it SOCKMAP
> can act as a drop-in replacement for REUSEPORT_SOCKARRAY which reuseport
> BPF programs use. Granted, it is limited to only TCP sockets.
> 
> The idea started out at LPC '19 as feedback from John Fastabend to our
> troubles with repurposing REUSEPORT_SOCKARRAY as a collection of listening
> sockets accessed by a BPF program ran on socket lookup [1]. Without going
> into details, REUSEPORT_SOCKARRAY proved to be tightly coupled with
> reuseport logic. Talk from LPC (see slides [2] or video [3]) highlights
> what problems we ran into when trying to make REUSEPORT_SOCKARRAY work for
> our use-case.
> 
> Patches have evolved quite a bit since the RFC series from a month ago
> [4]. To recap the RFC feedback, John pointed out that BPF redirect helpers
> for SOCKMAP need sane semantics when used with listening sockets [5], and
> that SOCKMAP lookup from BPF would be useful [6]. While Martin asked for
> UDP support [7].

Curious if you've started looking into UDP support. I had hoped to do
it but haven't got there yet.

> 
> As it happens, patches needed more work to get SOCKMAP to actually behave
> correctly with listening sockets. It turns out flexibility has its
> price. Change log below outlines them all.
> 

But looks pretty clean to me, only major change here is to add an extra
hook to remove psock from the child socket. And that looks fine to me and
cleaner than any other solution I had in mind.

Changes +/- looks good as well most the updates are in selftests to update
tests and add some new ones. +1 

> With more than I would like patches in the set, I left the new features,
> lookup from BPF as well as UDP support, for another series. I'm quite happy
> with how the changes turned out and the test coverage so I'm boldly
> proposing it as v1 :-)
> 
> Curious to see what you think.

Ack on the series from me.

> 
> RFC -> v1:
> 
> - Switch from overriding proto->accept to af_ops->syn_recv_sock, which
>   happens earlier. Clearing the psock state after accept() does not work
>   for child sockets that become orphaned (never got accepted). v4-mapped
>   sockets need special care.
> 
> - Return the socket cookie on SOCKMAP lookup from syscall to be on par with
>   REUSEPORT_SOCKARRAY. Requires SOCKMAP to take u64 on lookup/update from
>   syscall.
> 
> - Make bpf_sk_redirect_map (ingress) and bpf_msg_redirect_map (egress)
>   SOCKMAP helpers fail when target socket is a listening one.
> 
> - Make bpf_sk_select_reuseport helper fail when target is a TCP established
>   socket.
> 
> - Teach libbpf to recognize SK_REUSEPORT program type from section name.
> 
> - Add a dedicated set of tests for SOCKMAP holding listening sockets,
>   covering map operations, overridden socket callbacks, and BPF helpers.
> 
> Thanks,
> Jakub
> 
> [1] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> [2] https://linuxplumbersconf.org/event/4/contributions/487/
> [3] https://www.youtube.com/watch?v=qRDoUpqvYjY
> [4] https://lore.kernel.org/bpf/20191022113730.29303-1-jakub@cloudflare.com/
> [5] https://lore.kernel.org/bpf/5db1da20174b1_5c282ada047205c046@john-XPS-13-9370.notmuch/
> [6] https://lore.kernel.org/bpf/5db1d7a810bdb_5c282ada047205c08f@john-XPS-13-9370.notmuch/
> [7] https://lore.kernel.org/bpf/20191028213804.yv3xfjjlayfghkcr@kafai-mbp/
> 
> 
> Jakub Sitnicki (8):
>   bpf, sockmap: Return socket cookie on lookup from syscall
>   bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
>   bpf, sockmap: Allow inserting listening TCP sockets into SOCKMAP
>   bpf, sockmap: Don't let child socket inherit psock or its ops on copy
>   bpf: Allow selecting reuseport socket from a SOCKMAP
>   libbpf: Recognize SK_REUSEPORT programs from section name
>   selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
>   selftests/bpf: Tests for SOCKMAP holding listening sockets
> 
>  include/linux/skmsg.h                         |  17 +-
>  kernel/bpf/verifier.c                         |   6 +-
>  net/core/filter.c                             |   2 +
>  net/core/sock_map.c                           |  68 +-
>  net/ipv4/tcp_bpf.c                            |  66 +-
>  tools/lib/bpf/libbpf.c                        |   1 +
>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   9 +-
>  .../bpf/progs/test_sockmap_listen_kern.c      |  75 ++
>  tools/testing/selftests/bpf/test_maps.c       |   6 +-
>  .../selftests/bpf/test_select_reuseport.c     | 141 ++-
>  .../selftests/bpf/test_select_reuseport.sh    |  14 +
>  .../selftests/bpf/test_sockmap_listen.c       | 820 ++++++++++++++++++
>  13 files changed, 1170 insertions(+), 56 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen_kern.c
>  create mode 100755 tools/testing/selftests/bpf/test_select_reuseport.sh
>  create mode 100644 tools/testing/selftests/bpf/test_sockmap_listen.c
> 
> -- 
> 2.20.1
> 


