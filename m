Return-Path: <netdev+bounces-7644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5969C720F0A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 11:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F321F281AAF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DDFC12E;
	Sat,  3 Jun 2023 09:52:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17164257B
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 09:52:58 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F298197;
	Sat,  3 Jun 2023 02:52:56 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5659d85876dso29188477b3.2;
        Sat, 03 Jun 2023 02:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685785976; x=1688377976;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6OR5QTtvoInCLV23YctcWJUvtwNYCmNRaAouRWx4/q8=;
        b=r0n8+hOu2+EpPs9OqqTG5/MYpW0gfUupaAOYAJukGDnB50eYiMvm3D76VYhEdQ4d4N
         bhXumIFEJeJAuqPc/KBtnL+ondtsZ2uW57oux5jmP2JEFZhNLIEHqXeTk0fB5z9lddQy
         qCVOWKXn+fhIBC3xRaPcsXnbkp5tAc6NBiM99sf/oDAeUtdH1yIinys8rAB6S6zC6ZUf
         GeE47LfR1dQQ8u6z36e0CllpppBCpy3d3+N/gAvFYlY9zGfOVlfmun6wnzoGZ6LO1mZ7
         MJCfb2DF1xW9O/RE3gc9rAGOnenj3T5TrndL95uX2i3Ckcg/RiRzAVhNcVbxc19ag0KC
         a1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685785976; x=1688377976;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6OR5QTtvoInCLV23YctcWJUvtwNYCmNRaAouRWx4/q8=;
        b=O4NGrE2xhUGlno9mrL4q146LYR1JIRU5/m+e5W0x+n84eAfMzC4sS1nEpMXkeJehcN
         49IeepvBAT4xm92j2+JGAO7pmHtxJKAeDKOosaKTla+vhCAESPuuFT6LTIwH1Vxln2GE
         FRJjlCAoDiz+R8VZe+uON3Md3K8K1zVNWbJzWL4Z5gvnoPzDArCNo105BtCXbVA46utN
         yi0GXdJgYmRd7gB1ODB2x+8heF4LMrtFNR0Y0WLty5fNYTpwdkzK2Rbqr+oyV+dN0Rcf
         c+fELHIPWkQz0fUNXA9esszBvAEmQPxWdod4fGG+DHc1m5AEiquvZfxM8+d7AsIsFXtW
         Z5mw==
X-Gm-Message-State: AC+VfDxv+lepJfy6OBKQD67ULpg77Ebdf9LPtSm6RUiHx5E8i76vUtu4
	/PMA3DBjzEtZjW/JbbSdzb836kuma0dugWPvVPM=
X-Google-Smtp-Source: ACHHUZ6cV1+6T4uqdm3SH6HE+Rin50hxX3WHA1d8jKdtSfzs7NLV3NKyk11GRFr9vSjI6kEa87tokibdqAt97SYoaBg=
X-Received: by 2002:a0d:cd85:0:b0:565:a3d1:be19 with SMTP id
 p127-20020a0dcd85000000b00565a3d1be19mr133749ywd.31.1685785975662; Sat, 03
 Jun 2023 02:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Palash Oswal <oswalpalash@gmail.com>
Date: Sat, 3 Jun 2023 02:52:44 -0700
Message-ID: <CAGyP=7cEJdEiHRRYZ1yGu-YFa-fDdufd-fCEwu+Pi8ymuaV8OQ@mail.gmail.com>
Subject: KASAN: slab-use-after-free Read in skb_dequeue
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jesper Dangaard Brouer <brouer@redhat.com>, Menglong Dong <imagedong@tencent.com>, 
	Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,
I found the following issue using syzkaller with enriched corpus[1] on:
HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
git tree: linux
C Reproducer : I do not have a C reproducer yet. I will update this
thread when I get one.
Kernel .config :
https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f

Link:
1. https://github.com/cmu-pasta/linux-kernel-enriched-corpus

Console log :
==================================================================
BUG: KASAN: slab-use-after-free in skb_dequeue+0x163/0x180
Read of size 8 at addr ffff88803460d080 by task ksoftirqd/0/16

CPU: 0 PID: 16 Comm: ksoftirqd/0 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xd9/0x150
 print_address_description.constprop.0+0x2c/0x3c0
 kasan_report+0x11c/0x130
 skb_dequeue+0x163/0x180
 ieee80211_tasklet_handler+0x38/0x140
 tasklet_action_common.constprop.0+0x201/0x2e0
 __do_softirq+0x1d4/0x905
 run_ksoftirqd+0x31/0x60
 smpboot_thread_fn+0x659/0x9e0
 kthread+0x2e8/0x3a0
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 16:
 kasan_save_stack+0x22/0x40
 kasan_set_track+0x25/0x30
 __kasan_slab_alloc+0x7f/0x90
 kmem_cache_alloc_node+0x296/0x510
 __alloc_skb+0x288/0x330
 skb_copy+0x13d/0x3e0
 mac80211_hwsim_tx_frame_no_nl.isra.0+0xb02/0x1290
 mac80211_hwsim_tx_frame+0x1ee/0x2a0
 mac80211_hwsim_beacon_tx+0x561/0xb10
 __iterate_interfaces+0x2c8/0x570
 ieee80211_iterate_active_interfaces_atomic+0x73/0x1c0
 mac80211_hwsim_beacon+0x101/0x200
 __hrtimer_run_queues+0x5fa/0xbe0
 hrtimer_run_softirq+0x17f/0x360
 __do_softirq+0x1d4/0x905

Freed by task 16:
 kasan_save_stack+0x22/0x40
 kasan_set_track+0x25/0x30
 kasan_save_free_info+0x2b/0x40
 ____kasan_slab_free+0x13b/0x1a0
 kmem_cache_free+0x105/0x370
 kfree_skbmem+0xef/0x1b0
 consume_skb+0xdd/0x170
 mac80211_hwsim_tx_frame+0x1f6/0x2a0
 mac80211_hwsim_beacon_tx+0x561/0xb10
 __iterate_interfaces+0x2c8/0x570
 ieee80211_iterate_active_interfaces_atomic+0x73/0x1c0
 mac80211_hwsim_beacon+0x101/0x200
 __hrtimer_run_queues+0x5fa/0xbe0
 hrtimer_run_softirq+0x17f/0x360
 __do_softirq+0x1d4/0x905
Last potentially related work creation:
------------[ cut here ]------------
pool index 44248 out of bounds (719) for stack id 21b8acd8
WARNING: CPU: 0 PID: 16 at lib/stackdepot.c:472
stack_depot_print+0x6b/0x90
Modules linked in:
CPU: 0 PID: 16 Comm: ksoftirqd/0 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:stack_depot_print+0x6b/0x90
Code: f0 3f 00 00 48 01 c1 8b 71 0c 48 8d 79 18 85 f6 74 1a 48 83 c4
08 31 d2 5b e9 b1 9d 32 fd 48 c7 c7 f0 b8 f4 8b e8 25 03 0d fd <0f> 0b
48 83 c4 08 5b c3 c3 48 89 de 48 c7 c7 80 a4 12 8d 89 4c 24
RSP: 0018:ffffc9000055fca0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff88803460d170 RCX: 0000000000000100
RDX: ffff8880151d63c0 RSI: ffffffff814a8297 RDI: 0000000000000001
RBP: ffff88803460d080 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 646e69206c6f6f70 R12: ffffea0000d18340
R13: ffff88803460d080 R14: 0000000000000008 R15: ffff8880151d63c0
FS:  0000000000000000(0000) GS:ffff888063a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b2e7e9f39f CR3: 000000010fb6e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kasan_print_aux_stacks+0x57/0x70
 print_address_description.constprop.0+0x71/0x3c0
 kasan_report+0x11c/0x130
 skb_dequeue+0x163/0x180
 ieee80211_tasklet_handler+0x38/0x140
 tasklet_action_common.constprop.0+0x201/0x2e0
 __do_softirq+0x1d4/0x905
 run_ksoftirqd+0x31/0x60
 smpboot_thread_fn+0x659/0x9e0
 kthread+0x2e8/0x3a0
 ret_from_fork+0x1f/0x30
 </TASK>

