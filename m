Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F49C1383DA
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbgAKWrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 17:47:22 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33763 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbgAKWrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 17:47:22 -0500
Received: by mail-il1-f194.google.com with SMTP id v15so4837473iln.0;
        Sat, 11 Jan 2020 14:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FHnWPScfMncuR6f/o6kbPM7rkDiQBP7uwK0WiBVEWDA=;
        b=PQ5GDxcVxxwZqxa9UCUJQMhDzLakDgbjd/EkbDkKWvYU9ulOCEb5pXXBpY6MbGt5FX
         kirSp1HkLxZG8veKvnG5W2l5HJ6ECAUmaEjalIVREcMIbSZ1c2N0+4T5pMccYoLD4TxY
         gUuG6es/Ma/g4Usn7G0lhm+9fv/FsW8qCofTmIT/r2nPQsPOdtmuf/zWS3VIUeaC6BeK
         A43o9qgootxBLjQLCo9rJCn2v6j++0OoLVtf9TA87Ve+oYcVLUi+WovLdCLRsM5dGk2Q
         dio+QvqHFPiSX9024a8IbP+aYUuRFbLKmwuLbvUafEUc4GLjVZxQH6th/5whyncHy0lE
         7Ddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FHnWPScfMncuR6f/o6kbPM7rkDiQBP7uwK0WiBVEWDA=;
        b=puToFX3XPBqX+27o0y68bCEfJhA2EzthSolWYLYBHSIfk8yqc7Ll+YQKFoLw/b/xCZ
         aaV48b80qe3qO9wJ9V/jI6+fh7HpRrDkL8k4rH0tboJKhC/yr2WvajHrAmaWdF7439z4
         6bpDD0g6U64bI9B6pjm3BfDOtxI+yHqSEacyweHNnvasigXvLK9ABElTH6Nlg5O15ybV
         BYonBZs3LnA44IDauSAwNFt7cmUrKSfA7VSRQxfltOiIuoqb7fg1JbiGrytdcUFsuDFe
         ARPT7hYni7LphQy6ubJGS38k9ejyj1rj7tG56iLx9iPa6Y47ri2my4uj4Aeif502qpER
         rrhQ==
X-Gm-Message-State: APjAAAWo6PmClxWvmOFZPwVl1TK61GJZeHoH1HYVbInGd+TckEXsoYYY
        5CyN/GUgyLvhjAPA2OHOKq0=
X-Google-Smtp-Source: APXvYqyPEti3tEt9F5eX5NM6wXrwheJ7B3X+dO6KmUdniPvDabG2yuB/12PyGY40xBw/IVcsKrvA7w==
X-Received: by 2002:a92:ce85:: with SMTP id r5mr9107694ilo.301.1578782841431;
        Sat, 11 Jan 2020 14:47:21 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v21sm1593100ios.69.2020.01.11.14.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 14:47:20 -0800 (PST)
Date:   Sat, 11 Jan 2020 14:47:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a507040615_1e7f2b0c859c45c0c9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 00/11] Extend SOCKMAP to store listening
 sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> With the realization that properly cloning listening sockets that have
> psock state/callbacks is tricky, comes the second version of patches.
> 
> The spirit of the patch set stays the same - make SOCKMAP a generic
> collection for listening and established sockets. This would let us use the
> SOCKMAP with reuseport today, and in the future hopefully with BPF programs
> that run at socket lookup time [0]. For a bit more context, please see v1
> cover letter [1].
> 
> The biggest change that happened since v1 is how we deal with clearing
> psock state in a copy of parent socket when cloning it (patches 3 & 4).
> 
> As much as I did not want to touch icsk/tcp clone path, it seems
> unavoidable. The changes were kept down to a minimum, with attention to not
> break existing users. That said, a review from the TCP maintainer would be
> invaluable (patches 3 & 4).
> 
> Patches 1 & 2 will conflict with recently posted "Fixes for sockmap/tls
> from more complex BPF progs" series [0]. I'll adapt or split them out this
> series once sockmap/tls fixes from John land in bpf-next branch.

Thanks I just posted a v2 of that series so once that lands we will need
to respin this series.

> 
> Some food for thought - is mixing listening and established sockets in the
> same BPF map a good idea? I don't know but I couldn't find a good reason to
> restrict the user.

+1 in general I've been trying to avoid adding arbitrary restriction.
In this case I agree I can't think of a good reason to do it for my use
cases but lets not stop someone from doing it if their use case wants to
for some reason.

> 
> Considering how much the code evolved, I didn't carry over Acks from v1.

Sounds good thanks for keeping this series going.

> 
> Thanks,
> jkbs
> 
> [0] https://lore.kernel.org/bpf/157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2/T/#t
> [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
> 
> v1 -> v2:
> 
> - af_ops->syn_recv_sock callback is no longer overridden and burdened with
>   restoring sk_prot and clearing sk_user_data in the child socket. As child
>   socket is already hashed when syn_recv_sock returns, it is too late to
>   put it in the right state. Instead patches 3 & 4 restore sk_prot and
>   clear sk_user_data before we hash the child socket. (Pointed out by
>   Martin Lau)
> 
> - Annotate shared access to sk->sk_prot with READ_ONCE/WRITE_ONCE macros as
>   we write to it from sk_msg while socket might be getting cloned on
>   another CPU. (Suggested by John Fastabend)
> 
> - Convert tests for SOCKMAP holding listening sockets to return-on-error
>   style, and hook them up to test_progs. Also use BPF skeleton for setup.
>   Add new tests to cover the race scenario discovered during v1 review.
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
> 
> Jakub Sitnicki (11):
>   bpf, sk_msg: Don't reset saved sock proto on restore
>   net, sk_msg: Annotate lockless access to sk_prot on clone
>   net, sk_msg: Clear sk_user_data pointer on clone if tagged
>   tcp_bpf: Don't let child socket inherit parent protocol ops on copy
>   bpf, sockmap: Allow inserting listening TCP sockets into sockmap
>   bpf, sockmap: Don't set up sockmap progs for listening sockets
>   bpf, sockmap: Return socket cookie on lookup from syscall
>   bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
>   bpf: Allow selecting reuseport socket from a SOCKMAP
>   selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
>   selftests/bpf: Tests for SOCKMAP holding listening sockets
> 
>  include/linux/skmsg.h                         |   14 +-
>  include/net/sock.h                            |   37 +-
>  include/net/tcp.h                             |    1 +
>  kernel/bpf/verifier.c                         |    6 +-
>  net/core/filter.c                             |   15 +-
>  net/core/skmsg.c                              |    2 +-
>  net/core/sock.c                               |   11 +-
>  net/core/sock_map.c                           |  120 +-
>  net/ipv4/tcp_bpf.c                            |   19 +-
>  net/ipv4/tcp_minisocks.c                      |    2 +
>  net/ipv4/tcp_ulp.c                            |    2 +-
>  net/tls/tls_main.c                            |    2 +-
>  .../bpf/prog_tests/select_reuseport.c         |   60 +-
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 1378 +++++++++++++++++
>  .../selftests/bpf/progs/test_sockmap_listen.c |   76 +
>  tools/testing/selftests/bpf/test_maps.c       |    6 +-
>  16 files changed, 1696 insertions(+), 55 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> 
> -- 
> 2.24.1
> 


