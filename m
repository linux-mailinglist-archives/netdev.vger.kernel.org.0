Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C74879F0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348141AbiAGPyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:54:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239713AbiAGPyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 10:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641570860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGvnE7zQvE8DHksLMeuO5QhRX3HCRgbpmTFdQN7sWw0=;
        b=GoPF61ToLCg+isXxbxq2vPFfZRKc0a5c6nIFA1dnIy2XOkPt1QM8BHs/10iYhG4gM1Fbqh
        mjABUA6wn16FWkIZUdS60/VsuRUi7U6NdspJB5CzO1ht6d70szyU/CK8t4UcqA5IqXqy2p
        XrsktlLeuO3MzqVGCf8Iyp8DTG6g1Mg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-hS9mYij1PS2bbWUdwNOH8w-1; Fri, 07 Jan 2022 10:54:19 -0500
X-MC-Unique: hS9mYij1PS2bbWUdwNOH8w-1
Received: by mail-ed1-f72.google.com with SMTP id q15-20020a056402518f00b003f87abf9c37so4986008edd.15
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 07:54:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gGvnE7zQvE8DHksLMeuO5QhRX3HCRgbpmTFdQN7sWw0=;
        b=TRWWV17Cl9XJSpbYdrfRJj25+SXBF/9KuZaSX8cxjyRL5nZB1hfNq/yNHbL54UCVk/
         TRGPdxfql5wpLd3WD4RULzkEzQj5PId2u4aa6RnXuqzP5rdTAwUvVlpPDL+dOj8oNypc
         iChCBEMvC7NkVaGcaBajW4dlT1REU+M+Y9kJR8NhP2e87h9P8d6n4bULbyxdNa+eW+o3
         xoxWT8iNQ1ynIB8R7flv9te+4WdCPU8bvMi1BbFe7/agXw89xu3Uj10feyWtULl4OdS3
         1S6YHcEdoGFOPeHNB6nfxHkiYAPDYtzydNL9EDTQb00HyHVsWHzRRZJkeSdIF05bZSmO
         eK1w==
X-Gm-Message-State: AOAM533tqlJRqYCG1GaOyY9y9FM2rk7e06rj9uyJIrOksbkPUux58LFb
        FvcPfwmtWff5OJtq+GjWgGiMrAJkhv/XbroqzKByg44/Y0RZUo3a3zFHv3VoH/lx7befJZ4f8xR
        gCYMAJMWjBtE3ewMu
X-Received: by 2002:a17:906:5502:: with SMTP id r2mr49381200ejp.627.1641570855463;
        Fri, 07 Jan 2022 07:54:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjKj1n+FW4zoqNtgx7huVrX0MhGmABaJ0slHOxZcl7G3crUoA/41mryDmSVJ7zjQAUWB+dug==
X-Received: by 2002:a17:906:5502:: with SMTP id r2mr49381160ejp.627.1641570854488;
        Fri, 07 Jan 2022 07:54:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g17sm1505969eja.165.2022.01.07.07.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 07:54:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F22B1181F2A; Fri,  7 Jan 2022 16:54:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH bpf-next v6 3/3] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
In-Reply-To: <CAADnVQJS-2VdpkPoiXWCDYLV1MC6gk9oQFC+GZYw6jP2umH0Cw@mail.gmail.com>
References: <20220106195938.261184-1-toke@redhat.com>
 <20220106195938.261184-4-toke@redhat.com>
 <CAADnVQJS-2VdpkPoiXWCDYLV1MC6gk9oQFC+GZYw6jP2umH0Cw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Jan 2022 16:54:12 +0100
Message-ID: <87a6g7a6e3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jan 6, 2022 at 11:59 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>> +
>> +#define NUM_PKTS 10
>
> I'm afraid this needs more work.
> Just bumping above to 1M I got:
> [  254.165911] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  254.166387] WARNING: inconsistent lock state
> [  254.166882] 5.16.0-rc7-02011-g64923127f1b3 #3784 Tainted: G           O
> [  254.167659] --------------------------------
> [  254.168140] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [  254.168793] swapper/7/0 [HC0[0]:SC1[5]:HE1:SE0] takes:
> [  254.169373] ffff888113d24220 (&r->producer_lock){+.?.}-{2:2}, at:
> veth_xmit+0x361/0x830
> [  254.170317] {SOFTIRQ-ON-W} state was registered at:
> [  254.170921]   lock_acquire+0x18a/0x450
> [  254.171371]   _raw_spin_lock+0x2f/0x40
> [  254.171815]   veth_xdp_xmit+0x1d7/0x8c0
> [  254.172241]   veth_ndo_xdp_xmit+0x1d/0x50
> [  254.172689]   bq_xmit_all+0x562/0xc30
> [  254.173159]   __dev_flush+0xb1/0x220
> [  254.173586]   xdp_do_flush+0xa/0x20
> [  254.173983]   xdp_test_run_batch.constprop.25+0x90c/0xf00
> [  254.174564]   bpf_test_run_xdp_live+0x369/0x480
> [  254.175038]   bpf_prog_test_run_xdp+0x63f/0xe50
> [  254.175512]   __sys_bpf+0x688/0x4410
> [  254.175923]   __x64_sys_bpf+0x75/0xb0
> [  254.176327]   do_syscall_64+0x34/0x80
> [  254.176733]   entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  254.177297] irq event stamp: 130862
> [  254.177681] hardirqs last  enabled at (130862):
> [<ffffffff812d0812>] call_rcu+0x2a2/0x640
> [  254.178561] hardirqs last disabled at (130861):
> [<ffffffff812d08bd>] call_rcu+0x34d/0x640
> [  254.179404] softirqs last  enabled at (130814):
> [<ffffffff83c00534>] __do_softirq+0x534/0x835
> [  254.180332] softirqs last disabled at (130839):
> [<ffffffff811389f7>] irq_exit_rcu+0xe7/0x120
> [  254.181255]
> [  254.181255] other info that might help us debug this:
> [  254.181969]  Possible unsafe locking scenario:
> [  254.183172]   lock(&r->producer_lock);
> [  254.183590]   <Interrupt>
> [  254.183893]     lock(&r->producer_lock);
> [  254.184321]
> [  254.184321]  *** DEADLOCK ***
> [  254.184321]
> [  254.185047] 5 locks held by swapper/7/0:
> [  254.185501]  #0: ffff8881f6d89db8 ((&ndev->rs_timer)){+.-.}-{0:0},
> at: call_timer_fn+0xc8/0x440
> [  254.186496]  #1: ffffffff854415e0 (rcu_read_lock){....}-{1:2}, at:
> ndisc_send_skb+0x761/0x12e0
> [  254.187444]  #2: ffffffff85441580 (rcu_read_lock_bh){....}-{1:2},
> at: ip6_finish_output2+0x2da/0x1e00
> [  254.188447]  #3: ffffffff85441580 (rcu_read_lock_bh){....}-{1:2},
> at: __dev_queue_xmit+0x1de/0x2910
> [  254.189502]  #4: ffffffff854415e0 (rcu_read_lock){....}-{1:2}, at:
> veth_xmit+0x41/0x830
> [  254.190455]
> [  254.190455] stack backtrace:
> [  254.190963] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G           O
>   5.16.0-rc7-02011-g64923127f1b3 #3784
> [  254.192109] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [  254.193427] Call Trace:
> [  254.193711]  <IRQ>
> [  254.193945]  dump_stack_lvl+0x44/0x57
> [  254.194418]  mark_lock.part.54+0x157b/0x2210
> [  254.194940]  ? mark_lock.part.54+0xfd/0x2210
> [  254.195451]  ? print_usage_bug+0x80/0x80
> [  254.195896]  ? rcu_read_lock_sched_held+0x91/0xc0
> [  254.196413]  ? rcu_read_lock_bh_held+0xa0/0xa0
> [  254.196903]  ? rcu_read_lock_bh_held+0xa0/0xa0
> [  254.197389]  ? find_held_lock+0x33/0x1c0
> [  254.197826]  ? lock_release+0x3a1/0x650
> [  254.198251]  ? __stack_depot_save+0x274/0x490
> [  254.198742]  ? lock_acquire+0x19a/0x450
> [  254.199175]  ? lock_downgrade+0x690/0x690
> [  254.199626]  ? do_raw_spin_lock+0x11d/0x270
> [  254.200091]  ? rwlock_bug.part.2+0x90/0x90
> [  254.200550]  __lock_acquire+0x151f/0x6310
> [  254.201000]  ? mark_lock.part.54+0xfd/0x2210
> [  254.201470]  ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
> [  254.202083]  ? lock_is_held_type+0xda/0x130
> [  254.202592]  ? rcu_read_lock_sched_held+0x91/0xc0
> [  254.203134]  ? rcu_read_lock_bh_held+0xa0/0xa0
> [  254.203630]  lock_acquire+0x18a/0x450
> [  254.204041]  ? veth_xmit+0x361/0x830
> [  254.204455]  ? lock_release+0x650/0x650
> [  254.204932]  ? eth_gro_receive+0xc60/0xc60
> [  254.205421]  ? rcu_read_lock_held+0x91/0xa0
> [  254.205912]  _raw_spin_lock+0x2f/0x40
> [  254.206314]  ? veth_xmit+0x361/0x830
> [  254.206707]  veth_xmit+0x361/0x830
>
> I suspect it points out that local_bh_disable is needed
> around xdp_do_flush.
>
> That's why I asked you to test it with something
> more than 3 in NUM_PKTS.
> What values did you test it with? I hope not just 10.
>
> Please make sure XDP_PASS/TX/REDIRECT are all stress tested.

Okay, finally managed to reproduce this; it did not show up at all in my
own tests.

Did you run the old version of the selftest by any chance? At least I
can only reproduce it with the forwarding sysctl enabled; it happens
because the XDP_PASS path races with the XDP_REDIRECT path and end up
trying to grab the same lock, which only happens when the XDP_PASS path
sends the packets back out the same interface. The fix is to extend the
local_bh_disable() to cover the full loop in xdp_test_run_batch().

I'll send an update with that fixed. But I'm not sure what to do about
the selftest? I can keep the forwarding enabled + 1 million iterations -
that seems to trigger the bug fairly reliably for me, but it takes a bit
longer to run. Is that acceptable?

-Toke

