Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7D213938
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGCLSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:18:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbgGCLSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 07:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593775129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VnNbDSyZiB0HaDH6CJ+U6VCjcauNgCOYO5OdcxEql90=;
        b=cisMUDvT519712T5vbiOcVXOWYUHeL50qu/H4hsaIqDLQQTwLu8/OAnJSZgjsHVbjWJ/Dp
        CCoS90j3aFP1MRWaoafFtv9cLSYS7X3g81Zv0en+UiBC1q7SFQRieGNy5mh6gxYyfIMzij
        ZwsMcD1xPCnsXzwzwtP3VxIiNR7RAU4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-QGDesds2N7uThacJdwaeaQ-1; Fri, 03 Jul 2020 07:18:47 -0400
X-MC-Unique: QGDesds2N7uThacJdwaeaQ-1
Received: by mail-qt1-f197.google.com with SMTP id l14so2200341qtr.2
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 04:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VnNbDSyZiB0HaDH6CJ+U6VCjcauNgCOYO5OdcxEql90=;
        b=dbrkQUX5o/8aGZ5c0Fn5XH8iQ8Zu5nE7MJNdEvUowDdefJyY/Cf04q95a/L93drycY
         uFjS/OLHAoG+D18jthfqe3jDhc9aFZsLIv4ojovWVtK+Mqhpu3BkLQGhvdWB7vGdTUV7
         DWzo8ZBiwXgWBk1ZM5HLIKR+q8Kh+fEv9gU32H0hV7aY5c0GCKtHamJRg9MnkboWFyCh
         eS6khrHR+leeVXm5EF/bsqRxtugwXRGp1RHiwjUnWC0abipRdV0bVw7P+A6NyFA48pIB
         XsnenP1H/HP1gF0RM4pUYULxKKIeNQgk5k1cGJ10TgsoZxbWLiRnlJadYEt5wRdGcUNb
         LoQw==
X-Gm-Message-State: AOAM532KYdASwPmd+tpAy68n2q5MUR8vUDzssCvoqA0MddZ9c5pbciAt
        mB6vKB3sQGNTnBRHDGJbhGUnJDHoibVwU8hrDoWN1OE9BmsYOK+OsLd3yhqmjz3bjmjVCSGMrzO
        ekTpgioLWH2C3Ml7D
X-Received: by 2002:ac8:4297:: with SMTP id o23mr35414869qtl.74.1593775126998;
        Fri, 03 Jul 2020 04:18:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR3OmpQC0Xa7GAi77/M9aOuWPvkRLcqu/FU0NnpYuzSBGofEM9/0NVuNOtdx9D3mZmwqWL8g==
X-Received: by 2002:ac8:4297:: with SMTP id o23mr35414850qtl.74.1593775126794;
        Fri, 03 Jul 2020 04:18:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q28sm11633046qtk.13.2020.07.03.04.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 04:18:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0573E1828E4; Fri,  3 Jul 2020 13:18:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        torvalds@linux-foundation.org
Cc:     davem@davemloft.net, daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] bpf: Populate bpffs with map and prog iterators
In-Reply-To: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Jul 2020 13:18:43 +0200
Message-ID: <878sg0etik.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
> maps, load two BPF programs, attach them to BPF iterators, and finally send two
> bpf_link IDs back to the kernel.
> The kernel will pin two bpf_links into newly mounted bpffs instance under
> names "progs" and "maps". These two files become human readable.
>
> $ cat /sys/fs/bpf/progs
>   id name            pages attached
>   11    dump_bpf_map     1 bpf_iter_bpf_map
>   12   dump_bpf_prog     1 bpf_iter_bpf_prog
>   27 test_pkt_access     1
>   32       test_main     1 test_pkt_access test_pkt_access
>   33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
>   34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
>   35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
>   36 new_get_skb_len     1 get_skb_len test_pkt_access
>   37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
>   38 new_get_constan     1 get_constant test_pkt_access

Do the iterators respect namespace boundaries? Or will I see all
programs/maps on the host if I cat the file inside a container?

> Few interesting observations:
> - though bpffs comes with two human readble files "progs" and "maps" they
>   can be removed. 'rm -f /sys/fs/bpf/progs' will remove bpf_link and kernel
>   will automatically unload corresponding BPF progs, maps, BTFs.

Is there any way to get the files back if one does this by mistake
(other than re-mounting the bpffs)?

-Toke

