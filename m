Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFF6486F11
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344504AbiAGAue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344449AbiAGAue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:50:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1023C061245;
        Thu,  6 Jan 2022 16:50:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gp5so3864402pjb.0;
        Thu, 06 Jan 2022 16:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S5vebt9jggOq2lOKb+rEEyNidW86ACbtcR2h/WqV/To=;
        b=cz86p9oLoPP62smZRT6VeFiEtPSJFrpq+uxC4yecG7CbMi/hJt3nNfcNTFTMl6CTjO
         gucQl8UNoGfhQFQSsoERkUQ2Fm12Zrv0PgNoBEcwbZFSpPghU7aTb/33RJdaXJxZXfyC
         pEcu9JRj4atbYu1qAoE3KBc32tZETqSIj+vCW9UjkSS/f3SHal7oxgbCF7hAYXoO0NlN
         5Lm5WhV/NLEYTIhsHft4CD3rg/dbTcAMq4oLuq2ZSabvPwkcetHXbpk4iN4AZjVJ2NJd
         CqXw49ApFt+DT+IBnFp9ubT5x5f6Vl3BhER7+olWzc0UOwapNng1xsN0lchue3dMMgfP
         zo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S5vebt9jggOq2lOKb+rEEyNidW86ACbtcR2h/WqV/To=;
        b=BR3Rv9aHHwwBpXm3Q1tAyWC2mcuG7O84ORW3apUsI0sgFkggPqjenGMcAJEVIMynyA
         LycTxJtYNA6sfZHC7nrWu68DsFJwWB8BS36A/BlwUtMvp2VbRVtJptMTLrxTLcmH+KZM
         CBGtfKa96vxFjy0kjlZUUViM3YDemVl0coRT1Hdyh9HSnC7ys5dkOz9uwUgb6mYtk3dl
         3/gNEF+PdajTy16TshHYvFHC1hvcQV/sAM+ddidLVypLElKISmCJF5X/z/O7KpxFBYd4
         lGGdeaXLFqTby9O3grhTS1a2aZ/6c6fb4WXcKS8OLQ5PDlNVwWJ4iZQZnbG0beJFqMdD
         ARXg==
X-Gm-Message-State: AOAM532vQ4fDigJ8aUjGZK5vhoV5f9ZToG1iUTtwRU0JJ8IbBo9KXhMh
        dHxn3NRyVSUGXoKeoskHl5QOew5Q5y4uYxvR4SM=
X-Google-Smtp-Source: ABdhPJyGD+OQl8unRjiDgavNSXA1xbtokfDZLp7Ck8wKjzGmR6t7wvfOolK4V4kjB3Fa8rTHXeIhNWLqVpTU1J42JEc=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr60544973plo.116.1641516633469; Thu, 06
 Jan 2022 16:50:33 -0800 (PST)
MIME-Version: 1.0
References: <20220106195938.261184-1-toke@redhat.com> <20220106195938.261184-4-toke@redhat.com>
In-Reply-To: <20220106195938.261184-4-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 16:50:18 -0800
Message-ID: <CAADnVQJS-2VdpkPoiXWCDYLV1MC6gk9oQFC+GZYw6jP2umH0Cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 3/3] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 11:59 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> +
> +#define NUM_PKTS 10

I'm afraid this needs more work.
Just bumping above to 1M I got:
[  254.165911] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  254.166387] WARNING: inconsistent lock state
[  254.166882] 5.16.0-rc7-02011-g64923127f1b3 #3784 Tainted: G           O
[  254.167659] --------------------------------
[  254.168140] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[  254.168793] swapper/7/0 [HC0[0]:SC1[5]:HE1:SE0] takes:
[  254.169373] ffff888113d24220 (&r->producer_lock){+.?.}-{2:2}, at:
veth_xmit+0x361/0x830
[  254.170317] {SOFTIRQ-ON-W} state was registered at:
[  254.170921]   lock_acquire+0x18a/0x450
[  254.171371]   _raw_spin_lock+0x2f/0x40
[  254.171815]   veth_xdp_xmit+0x1d7/0x8c0
[  254.172241]   veth_ndo_xdp_xmit+0x1d/0x50
[  254.172689]   bq_xmit_all+0x562/0xc30
[  254.173159]   __dev_flush+0xb1/0x220
[  254.173586]   xdp_do_flush+0xa/0x20
[  254.173983]   xdp_test_run_batch.constprop.25+0x90c/0xf00
[  254.174564]   bpf_test_run_xdp_live+0x369/0x480
[  254.175038]   bpf_prog_test_run_xdp+0x63f/0xe50
[  254.175512]   __sys_bpf+0x688/0x4410
[  254.175923]   __x64_sys_bpf+0x75/0xb0
[  254.176327]   do_syscall_64+0x34/0x80
[  254.176733]   entry_SYSCALL_64_after_hwframe+0x44/0xae
[  254.177297] irq event stamp: 130862
[  254.177681] hardirqs last  enabled at (130862):
[<ffffffff812d0812>] call_rcu+0x2a2/0x640
[  254.178561] hardirqs last disabled at (130861):
[<ffffffff812d08bd>] call_rcu+0x34d/0x640
[  254.179404] softirqs last  enabled at (130814):
[<ffffffff83c00534>] __do_softirq+0x534/0x835
[  254.180332] softirqs last disabled at (130839):
[<ffffffff811389f7>] irq_exit_rcu+0xe7/0x120
[  254.181255]
[  254.181255] other info that might help us debug this:
[  254.181969]  Possible unsafe locking scenario:
[  254.183172]   lock(&r->producer_lock);
[  254.183590]   <Interrupt>
[  254.183893]     lock(&r->producer_lock);
[  254.184321]
[  254.184321]  *** DEADLOCK ***
[  254.184321]
[  254.185047] 5 locks held by swapper/7/0:
[  254.185501]  #0: ffff8881f6d89db8 ((&ndev->rs_timer)){+.-.}-{0:0},
at: call_timer_fn+0xc8/0x440
[  254.186496]  #1: ffffffff854415e0 (rcu_read_lock){....}-{1:2}, at:
ndisc_send_skb+0x761/0x12e0
[  254.187444]  #2: ffffffff85441580 (rcu_read_lock_bh){....}-{1:2},
at: ip6_finish_output2+0x2da/0x1e00
[  254.188447]  #3: ffffffff85441580 (rcu_read_lock_bh){....}-{1:2},
at: __dev_queue_xmit+0x1de/0x2910
[  254.189502]  #4: ffffffff854415e0 (rcu_read_lock){....}-{1:2}, at:
veth_xmit+0x41/0x830
[  254.190455]
[  254.190455] stack backtrace:
[  254.190963] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G           O
  5.16.0-rc7-02011-g64923127f1b3 #3784
[  254.192109] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[  254.193427] Call Trace:
[  254.193711]  <IRQ>
[  254.193945]  dump_stack_lvl+0x44/0x57
[  254.194418]  mark_lock.part.54+0x157b/0x2210
[  254.194940]  ? mark_lock.part.54+0xfd/0x2210
[  254.195451]  ? print_usage_bug+0x80/0x80
[  254.195896]  ? rcu_read_lock_sched_held+0x91/0xc0
[  254.196413]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  254.196903]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  254.197389]  ? find_held_lock+0x33/0x1c0
[  254.197826]  ? lock_release+0x3a1/0x650
[  254.198251]  ? __stack_depot_save+0x274/0x490
[  254.198742]  ? lock_acquire+0x19a/0x450
[  254.199175]  ? lock_downgrade+0x690/0x690
[  254.199626]  ? do_raw_spin_lock+0x11d/0x270
[  254.200091]  ? rwlock_bug.part.2+0x90/0x90
[  254.200550]  __lock_acquire+0x151f/0x6310
[  254.201000]  ? mark_lock.part.54+0xfd/0x2210
[  254.201470]  ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
[  254.202083]  ? lock_is_held_type+0xda/0x130
[  254.202592]  ? rcu_read_lock_sched_held+0x91/0xc0
[  254.203134]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  254.203630]  lock_acquire+0x18a/0x450
[  254.204041]  ? veth_xmit+0x361/0x830
[  254.204455]  ? lock_release+0x650/0x650
[  254.204932]  ? eth_gro_receive+0xc60/0xc60
[  254.205421]  ? rcu_read_lock_held+0x91/0xa0
[  254.205912]  _raw_spin_lock+0x2f/0x40
[  254.206314]  ? veth_xmit+0x361/0x830
[  254.206707]  veth_xmit+0x361/0x830

I suspect it points out that local_bh_disable is needed
around xdp_do_flush.

That's why I asked you to test it with something
more than 3 in NUM_PKTS.
What values did you test it with? I hope not just 10.

Please make sure XDP_PASS/TX/REDIRECT are all stress tested.
