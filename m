Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A086A3D824E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhG0WKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhG0WKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:10:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9752DC061757;
        Tue, 27 Jul 2021 15:10:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id d73so499785ybc.10;
        Tue, 27 Jul 2021 15:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4e5KPgwqpie2+fO0IyN0BfwYGfWe7NhxqAu2gbPE+CY=;
        b=bZacNpkggHdLV3OW0wZ3cq1cqgBcngrHxPFWNqf8Zs1vxmrpyzSoHXOGQg6oSYE3IX
         6HzG9F3I9yOqbbUa++xWYJljAzqXm8qb/gQwtgI16w0HOqpwpExY+0JewIsmMjMN6CNB
         1He+Rw097TJo5Ush6zKq48qxV6AMDATZzVeplp/GIy0RsKg7EITlkrMd3/nVML5emHnd
         iQ7F7oDCJPLTuejwg4E+OmLJMI2COOFCedQ0XYKCycJjgnIeA42oGDSb7vJQCLcExN+P
         fZx2OxnyaeuoLyczmcx0AnKeoXrkZGqRDHb5nr3NiEZ/Ac8Uns9A/q0YRLow40OP/E0W
         zxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4e5KPgwqpie2+fO0IyN0BfwYGfWe7NhxqAu2gbPE+CY=;
        b=aqY5zyNb4rB6m1+zpSdMUFgt1sofIolvsaeKVXscV76I75gb72Ps7YpzxGfESI9FFM
         BCmoBTUVjGlxfhq+t9RwnKGAlXw417cCe1U7hE50BY7oH853YLCtChfGWGgmNJmq+Grl
         UN15tgpZ0Oe+4w5/EdlELsILRmwF9pn0ZeNo0VF4/y46dpBaswqwOf/3U91r1Am1Xa04
         19YhPJLBptxOrWwb/s5hWR2Hcz7g8PHrSeVJBPOQN8zCa+foRwhKR/oEf81R/BuMjNBX
         XKrKx97SyS+IhMBsIaxmS2lZycmzHErmp1uOqDHQTwpGgaeo3E1WNsKPmWf97DBc2lmu
         0IWg==
X-Gm-Message-State: AOAM531rqHaLyDTy724Hee91ibmShUGzpsHxsbqKXk7ellduvdpQa4H0
        GhldDwKEOF2D5RVGLHBhe/JOuhy2obucmW7OYOs=
X-Google-Smtp-Source: ABdhPJxuo51FKGB3+vdWsC47t2KnIl41MVLJWw8UDmt59BoR16a0skszeZze2ivcZwt3KPi/OrgocHyEA7q4lLUbwe4=
X-Received: by 2002:a25:9942:: with SMTP id n2mr34524345ybo.230.1627423849929;
 Tue, 27 Jul 2021 15:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210727160500.1713554-1-john.fastabend@gmail.com> <20210727173713.qm24aiwli2bacrlm@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210727173713.qm24aiwli2bacrlm@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 15:10:38 -0700
Message-ID: <CAEf4BzbLiQ3o=ZipMu4GWYhnGEXg5wgSWP8ox7Hoy-+Zjt5LaA@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/3] sockmap fixes picked up by stress tests
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 10:37 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jul 27, 2021 at 09:04:57AM -0700, John Fastabend wrote:
> > Running stress tests with recent patch to remove an extra lock in sockmap
> > resulted in a couple new issues popping up. It seems only one of them
> > is actually related to the patch:
> >
> > 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> >
> > The other two issues had existed long before, but I guess the timing
> > with the serialization we had before was too tight to get any of
> > our tests or deployments to hit it.
> >
> > With attached series stress testing sockmap+TCP with workloads that
> > create lots of short-lived connections no more splats like below were
> > seen on upstream bpf branch.
> >
> > [224913.935822] WARNING: CPU: 3 PID: 32100 at net/core/stream.c:208 sk_stream_kill_queues+0x212/0x220
> > [224913.935841] Modules linked in: fuse overlay bpf_preload x86_pkg_temp_thermal intel_uncore wmi_bmof squashfs sch_fq_codel efivarfs ip_tables x_tables uas xhci_pci ixgbe mdio xfrm_algo xhci_hcd wmi
> > [224913.935897] CPU: 3 PID: 32100 Comm: fgs-bench Tainted: G          I       5.14.0-rc1alu+ #181
> > [224913.935908] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
> > [224913.935914] RIP: 0010:sk_stream_kill_queues+0x212/0x220
> > [224913.935923] Code: 8b 83 20 02 00 00 85 c0 75 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 df e8 2b 11 fe ff eb c3 0f 0b e9 7c ff ff ff 0f 0b eb ce <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 0f 1f 44 00 00 41 57 41
> > [224913.935932] RSP: 0018:ffff88816271fd38 EFLAGS: 00010206
> > [224913.935941] RAX: 0000000000000ae8 RBX: ffff88815acd5240 RCX: dffffc0000000000
> > [224913.935948] RDX: 0000000000000003 RSI: 0000000000000ae8 RDI: ffff88815acd5460
> > [224913.935954] RBP: ffff88815acd5460 R08: ffffffff955c0ae8 R09: fffffbfff2e6f543
> > [224913.935961] R10: ffffffff9737aa17 R11: fffffbfff2e6f542 R12: ffff88815acd5390
> > [224913.935967] R13: ffff88815acd5480 R14: ffffffff98d0c080 R15: ffffffff96267500
> > [224913.935974] FS:  00007f86e6bd1700(0000) GS:ffff888451cc0000(0000) knlGS:0000000000000000
> > [224913.935981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [224913.935988] CR2: 000000c0008eb000 CR3: 00000001020e0005 CR4: 00000000003706e0
> > [224913.935994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [224913.936000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [224913.936007] Call Trace:
> > [224913.936016]  inet_csk_destroy_sock+0xba/0x1f0
> > [224913.936033]  __tcp_close+0x620/0x790
> > [224913.936047]  tcp_close+0x20/0x80
> > [224913.936056]  inet_release+0x8f/0xf0
> > [224913.936070]  __sock_release+0x72/0x120
> >
> > v3: make sock_drop inline in skmsg.h
> > v2: init skb to null and fix a space/tab issue. Added Jakub's acks.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied to bpf, thanks.
