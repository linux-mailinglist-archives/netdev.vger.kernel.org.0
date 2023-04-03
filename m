Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A376D4CE7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjDCP7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjDCP7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:59:16 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3BB199C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:58:57 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id m16so15038181ybk.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680537536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unIsUUCwc4txNMyZjhgpxEocxG84tqyHjRFLBjZDEuk=;
        b=GhPLyLGxxFWXv4KJoT1G72kfQdmylMoN/vwQ7DEYGziAzZgkQ+hhDOegWQMdRMpv7k
         7q3SOzORS68D3A+AVfa56v9+G0XSv/cHlrQmpCQWkD77iuf6X7ZsXOxGdcnpDFvkZSwL
         x5FJmoqSToEZJGiN+s0B3chBKK183WICuILJnuSYOgCd1AQf8VI58/pfWBL9+erH2BdT
         u90LRgo+kNswUKE2QhaxhztYqQbd1doOJ38yOpChRK/hNi3fQIw0mjEhm9emObmeE6Qw
         evNP4oU3tJQ6dyPUc0gV0g/exF/4uOToUzYYFxsdA/Jof24wTUIHkQQVuYWDWw2nkrek
         QDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680537536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unIsUUCwc4txNMyZjhgpxEocxG84tqyHjRFLBjZDEuk=;
        b=UUbiZo1TWEMH9ililWXPDh7yd13b2AudmybLDQ/X20tifp5//jqOL5L6ZttiDAcDxi
         Y6Hh4ritCz6sQBnjsNKa3nGQwGXf8RpHgsYxuV2jssuruFZZfHT148apw11HHaGnsFcB
         qsysbgf3felSGE1wd4p+8rHcqUoHAGmg9qm0Isfwt5xL2itzA53eReE/rKZydLcX7ho+
         ABN5tbLmCphw8YIlPo9s0ExXiqchWyZGjY7nft0/YldxbdC28bogWfCkgUSzXmVIvQ8H
         PXRjqzg7FXkZm0V0WWm8czrsLD4o/UJG7xXs6Bg732kMRVDzNQ7g5QjDniBqWFBXAw7j
         XTfw==
X-Gm-Message-State: AAQBX9co18OoiRGD1M6tIX0iRvhkAJL8dNKbtovq7u4zmJ8bQMrtLSJ0
        gcmZNS2o9eKNaxAG+0PmgN8f9ocw1XPtOImUWRUMLw==
X-Google-Smtp-Source: AKy350bLFW3p22LgBS1P6oapvR2sJy9GZ47ScbIjLakzG27WZ7r2P9ZmpB8r5C4aBomIj1pjagTZn7OmAqHz4+A+uyc=
X-Received: by 2002:a25:5804:0:b0:a48:4a16:d85e with SMTP id
 m4-20020a255804000000b00a484a16d85emr22647896ybb.7.1680537535810; Mon, 03 Apr
 2023 08:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006cf87705f79acf1a@google.com> <20230328184733.6707ef73@kernel.org>
 <ZCOylfbhuk0LeVff@do-x1extreme> <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
In-Reply-To: <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 3 Apr 2023 11:58:44 -0400
Message-ID: <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in mini_qdisc_pair_swap
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To provide more update:
Happens on single processor before Seth's patches; and only on
multi-processor after Seth's patches.
Theory is: there is a logic bug in the miniqdisc rcu visibility. Feels
like the freeing of the structure is done without rcu involvement.
Jiri/Cong maybe you can take a look since youve been dabbling in
miniqdisc? The reproducer worked for me and Pedro 100% of the time.

cheers,
jamal

On Wed, Mar 29, 2023 at 3:07=E2=80=AFPM Pedro Tammela <pctammela@mojatatu.c=
om> wrote:
>
> On 29/03/2023 00:37, Seth Forshee wrote:
> > On Tue, Mar 28, 2023 at 06:47:33PM -0700, Jakub Kicinski wrote:
> >> Seth, does this looks related to commit 267463823adb ("net: sch:
> >> eliminate unnecessary RCU waits in mini_qdisc_pair_swap()")
> >> by any chance?
> >
> > I don't see how it could be. The memory being written is part of the
> > qdisc private memory, and tc_new_tfilter() takes a reference to the
> > qdisc. If that memory has been freed doesn't it mean that something has
> > done an unbalanced qdisc_put()?
> >
>
> Reverting Seth's patches (85c0c3eb9a66 and 267463823adb) leads to these
> traces with the reproducer:
> [   52.704956][    C0] ------------[ cut here ]------------
> [   52.705568][    C0] ODEBUG: free active (active state 1) object:0
> [   52.706542][    C0] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c0
> [   52.707283][    C0] Modules linked in:
> [   52.707602][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0
> [   52.708304][    C0] Hardware name: QEMU Standard PC (i440FX + PI4
> [   52.709032][    C0] RIP: 0010:debug_print_object+0x196/0x290
> [   52.709509][    C0] Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85e
> [   52.711011][    C0] RSP: 0018:ffffc90000007cd0 EFLAGS: 00010282
> [   52.711510][    C0] RAX: 0000000000000000 RBX: 0000000000000003 0
> [   52.712125][    C0] RDX: ffffffff8c495800 RSI: ffffffff814b96d7 1
> [   52.712748][    C0] RBP: 0000000000000001 R08: 0000000000000001 0
> [   52.713370][    C0] R10: 0000000000000000 R11: 203a47554245444f 0
> [   52.713983][    C0] R13: ffffffff8aa6e960 R14: 0000000000000000 8
> [   52.714609][    C0] FS:  0000000000000000(0000) GS:ffff8881f5a000
> [   52.715356][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008003
> [   52.715863][    C0] CR2: 000055914686f020 CR3: 000000011e856000 0
> [   52.716486][    C0] Call Trace:
> [   52.716742][    C0]  <IRQ>
> [   52.716969][    C0]  debug_check_no_obj_freed+0x302/0x420
> [   52.717423][    C0]  slab_free_freelist_hook+0xec/0x1c0
> [   52.717848][    C0]  ? rcu_core+0x818/0x1930
> [   52.718204][    C0]  __kmem_cache_free+0xaf/0x2e0
> [   52.718590][    C0]  rcu_core+0x818/0x1930
> [   52.718938][    C0]  ? rcu_report_dead+0x610/0x610
> [   52.719328][    C0]  __do_softirq+0x1d4/0x8ef
> [   52.719689][    C0]  __irq_exit_rcu+0x11d/0x190
> [   52.720062][    C0]  irq_exit_rcu+0x9/0x20
> [   52.720402][    C0]  sysvec_apic_timer_interrupt+0x97/0xc0
> [   52.720842][    C0]  </IRQ>
> [   52.721070][    C0]  <TASK>
> [   52.721300][    C0]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [   52.721779][    C0] RIP: 0010:default_idle+0xf/0x20
> [   52.722172][    C0] Code: 89 07 49 c7 c0 08 00 00 00 4d 29 c8 4c5
> [   52.723631][    C0] RSP: 0018:ffffffff8c407e30 EFLAGS: 00000202
> [   52.724096][    C0] RAX: 000000000007897f RBX: 0000000000000000 6
> [   52.724702][    C0] RDX: 0000000000000000 RSI: 0000000000000001 0
> [   52.725335][    C0] RBP: ffffffff8c495800 R08: 0000000000000001 b
> [   52.725957][    C0] R10: ffffed103eb46d95 R11: 0000000000000000 0
> [   52.726550][    C0] R13: 0000000000000000 R14: ffffffff8e7834d0 0
> [   52.727162][    C0]  ? ct_kernel_exit+0x1d6/0x240
> [   52.727542][    C0]  default_idle_call+0x67/0xa0
> [   52.727912][    C0]  do_idle+0x31e/0x3e0
> [   52.728241][    C0]  ? arch_cpu_idle_exit+0x30/0x30
> [   52.728635][    C0]  cpu_startup_entry+0x18/0x20
> [   52.729006][    C0]  rest_init+0x16d/0x2b0
> [   52.729338][    C0]  ? regulator_has_full_constraints+0x9/0x20
> [   52.729815][    C0]  ? trace_init_perf_perm_irq_work_exit+0x20/00
> [   52.730309][    C0]  arch_call_rest_init+0x13/0x30
> [   52.730703][    C0]  start_kernel+0x352/0x4c0
> [   52.731087][    C0]  secondary_startup_64_no_verify+0xce/0xdb
> [   52.731611][    C0]  </TASK>
> [   52.731870][    C0] Kernel panic - not syncing: kernel: panic_on.
> [   52.732445][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0
> [   52.733140][    C0] Hardware name: QEMU Standard PC (i440FX + PI4
> [   52.733867][    C0] Call Trace:
> [   52.734143][    C0]  <IRQ>
> [   52.734380][    C0]  dump_stack_lvl+0xd9/0x150
> [   52.734769][    C0]  panic+0x684/0x730
> [   52.735082][    C0]  ? panic_smp_self_stop+0x90/0x90
> [   52.735322][    C0]  ? show_trace_log_lvl+0x285/0x390
> [   52.735322][    C0]  ? debug_print_object+0x196/0x290
> [   52.735322][    C0]  check_panic_on_warn+0xb1/0xc0
> [   52.735322][    C0]  __warn+0xf2/0x390
> [   52.735322][    C0]  ? debug_print_object+0x196/0x290
> [   52.735322][    C0]  report_bug+0x2dd/0x500
> [   52.735322][    C0]  handle_bug+0x3c/0x70
> [   52.735322][    C0]  exc_invalid_op+0x18/0x50
> [   52.735322][    C0]  asm_exc_invalid_op+0x1a/0x20
> [   52.735322][    C0] RIP: 0010:debug_print_object+0x196/0x290
> [   52.735322][    C0] Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85e
> [   52.735322][    C0] RSP: 0018:ffffc90000007cd0 EFLAGS: 00010282
> [   52.735322][    C0] RAX: 0000000000000000 RBX: 0000000000000003 0
> [   52.735322][    C0] RDX: ffffffff8c495800 RSI: ffffffff814b96d7 1
> [   52.735322][    C0] RBP: 0000000000000001 R08: 0000000000000001 0
> [   52.735322][    C0] R10: 0000000000000000 R11: 203a47554245444f 0
> [   52.735322][    C0] R13: ffffffff8aa6e960 R14: 0000000000000000 8
> [   52.735322][    C0]  ? __warn_printk+0x187/0x310
> [   52.735322][    C0]  debug_check_no_obj_freed+0x302/0x420
> [   52.735322][    C0]  slab_free_freelist_hook+0xec/0x1c0
> [   52.735322][    C0]  ? rcu_core+0x818/0x1930
> [   52.735322][    C0]  __kmem_cache_free+0xaf/0x2e0
> [   52.735322][    C0]  rcu_core+0x818/0x1930
> [   52.735322][    C0]  ? rcu_report_dead+0x610/0x610
> [   52.735322][    C0]  __do_softirq+0x1d4/0x8ef
> [   52.735322][    C0]  __irq_exit_rcu+0x11d/0x190
> [   52.735322][    C0]  irq_exit_rcu+0x9/0x20
> [   52.735322][    C0]  sysvec_apic_timer_interrupt+0x97/0xc0
> [   52.735322][    C0]  </IRQ>
> [   52.735322][    C0]  <TASK>
> [   52.735322][    C0]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [   52.735322][    C0] RIP: 0010:default_idle+0xf/0x20
> [   52.735322][    C0] Code: 89 07 49 c7 c0 08 00 00 00 4d 29 c8 4c5
> [   52.735322][    C0] RSP: 0018:ffffffff8c407e30 EFLAGS: 00000202
> [   52.735322][    C0] RAX: 000000000007897f RBX: 0000000000000000 6
> [   52.735322][    C0] RDX: 0000000000000000 RSI: 0000000000000001 0
> [   52.735322][    C0] RBP: ffffffff8c495800 R08: 0000000000000001 b
> [   52.735322][    C0] R10: ffffed103eb46d95 R11: 0000000000000000 0
> [   52.735322][    C0] R13: 0000000000000000 R14: ffffffff8e7834d0 0
> [   52.735322][    C0]  ? ct_kernel_exit+0x1d6/0x240
> [   52.735322][    C0]  default_idle_call+0x67/0xa0
> [   52.735322][    C0]  do_idle+0x31e/0x3e0
> [   52.735322][    C0]  ? arch_cpu_idle_exit+0x30/0x30
> [   52.735322][    C0]  cpu_startup_entry+0x18/0x20
> [   52.735322][    C0]  rest_init+0x16d/0x2b0
> [   52.735322][    C0]  ? regulator_has_full_constraints+0x9/0x20
> [   52.735322][    C0]  ? trace_init_perf_perm_irq_work_exit+0x20/00
> [   52.735322][    C0]  arch_call_rest_init+0x13/0x30
> [   52.735322][    C0]  start_kernel+0x352/0x4c0
> [   52.735322][    C0]  secondary_startup_64_no_verify+0xce/0xdb
> [   52.735322][    C0]  </TASK>
> [   52.735322][    C0] Kernel Offset: disabled
> [   52.735322][    C0] Rebooting in 86400 seconds..
>
>
