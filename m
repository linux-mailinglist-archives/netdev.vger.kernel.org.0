Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A188A35FC3E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353698AbhDNUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353718AbhDNUDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:03:08 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD88FC061761
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:46 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id 1so16446114qtb.0
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fJmw5cg9XXe4ty83sBOB42REmqjyuzdrJpjNjrbVtU=;
        b=XUn/CDrzj6JwVk30IYsCOFauwnz+FXAkDa4wv86zpYg5fvESLfW0siWWOGfNoiEmpL
         yq0EXqumuuW4eEblV27q4EGzkn7wojbckhtxGL7fhxm+oI294C0vxM1zYQKv4ojWr4MF
         AZTzn3iN6FOfKc8pCyGT2VEhpca2rqyG53acDB+yyX/GTpG3YqHIxqpyyF2fknSWaMJe
         Hj8n4O+I+EMnGD04VRRCuEVcA0OBjHt7VDWED0+EMIszCovlECIOSgEKdoq1ARQsxfk8
         +lzy199T4zuqScVH619SY9G14RM3tTY6IOBhB0lXxZBb5iKnEWHAa3e3X176VCekraTK
         tORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fJmw5cg9XXe4ty83sBOB42REmqjyuzdrJpjNjrbVtU=;
        b=t0NrSwdHUEYlyoJA5GO7Z64rZi/1WkLpCIXZvsBud2k5AG+sndHXd3Ojn9yxoWlh15
         B8GwJ3E5qOHcDIPProCOU0AUzhISPxaGPgvEc05TE+zP31KW7ViTSv+2NEO3AUb5wg8M
         MWNOKMR4XvdloLlhmVBgrOW5PJje/GZjHLPnCXAMtZodOViuG/IJBL7ZBd9Yt8jxShf5
         O68UL6X+ImBloYniYyO728xK1ZxQE/8TTiQZsPdiFsm6Dx1AzioySSSKP9oV0kWHpib+
         iS6fMH3u+yh+lmDhkUGNiW2IP67d6dGyNo/Gv0kWATXn+fgc3QGrfm1b6JfDEeHiAZSb
         Q9RQ==
X-Gm-Message-State: AOAM530cuO4xQpwtXw8Ns0jt3lHthxbmObRWaC8fPJXTdjQY8+UqpvEz
        u5k9CaqGBuGzXo871/bPBuEXfJ8x/2BVJpEr8QA=
X-Google-Smtp-Source: ABdhPJxUbOS14eWgAEjSUk4Bz+YMj/Nu5h7oSbwe1D2J2P6ylqHUbnHbC3GM5rQAzDuNVkJufJfzMwXwRJj1/p3uDs0=
X-Received: by 2002:ac8:738f:: with SMTP id t15mr38072064qtp.262.1618430566076;
 Wed, 14 Apr 2021 13:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsn2oG4wUHPYOPTPW8j6jbHe=_0UiLntZmXjvaf0Cu9PA@mail.gmail.com>
In-Reply-To: <CAA85sZsn2oG4wUHPYOPTPW8j6jbHe=_0UiLntZmXjvaf0Cu9PA@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 14 Apr 2021 22:02:35 +0200
Message-ID: <CAA85sZsZqz=Dj523x44Lxid4fhpaPMURfNxMPzmeoUv+KdF0Ow@mail.gmail.com>
Subject: Re: [BUG] possible issue with ixgbe
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So after some digging, the error seems to start in fq? It doesn't seem
like the adapter says anything on it's own
but fq is complaining - switched to pfifo_fast for now....

Also, FYI this interface is configured for jumboframes (local interface)

On Mon, Apr 12, 2021 at 8:41 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> Hi,
>
> I've encountered this a few times now, been moving kernels since
> there's been things fixed that
> looked related... but...
>
> [959642.297143] ------------[ cut here ]------------
> [959642.297149] NETDEV WATCHDOG: eno1 (ixgbe): transmit queue 2 timed out
> [959642.297189] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:442
> dev_watchdog+0x21f/0x230
> [959642.297199] Modules linked in: chaoskey
> [959642.297205] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.11.11 #272
> [959642.297209] Hardware name: Supermicro Super
> Server/A2SDi-12C-HLN4F, BIOS 1.2 11/05/2019
> [959642.297211] RIP: 0010:dev_watchdog+0x21f/0x230
> [959642.297216] Code: 27 1a fd ff eb ab 4c 89 ef c6 05 c2 27 1a 01 01
> e8 46 12 fa ff 44 89 e1 4c 89 ee 48 c7 c7 90 37 22 a5 48 89 c2 e8 a8
> f2 32 00 <0f> 0b eb 8c 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 f9
> 48 8d
> [959642.297220] RSP: 0018:ffffb1d20015cec8 EFLAGS: 00010282
> [959642.297223] RAX: 0000000000000000 RBX: ffff8dda45c34ec0 RCX:
> ffff8dddafad78d8
> [959642.297225] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI:
> ffff8dddafad78d0
> [959642.297228] RBP: ffff8dda45c28480 R08: 0000000000000000 R09:
> ffffb1d20015cd00
> [959642.297230] R10: ffffb1d20015ccf8 R11: ffffffffa553e8c8 R12:
> 0000000000000002
> [959642.297232] R13: ffff8dda45c28000 R14: 0000000000000001 R15:
> ffff8dddafadbb40
> [959642.297234] FS:  0000000000000000(0000) GS:ffff8dddafac0000(0000)
> knlGS:0000000000000000
> [959642.297237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [959642.297240] CR2: 00007f0fdc76d5a8 CR3: 000000013debe000 CR4:
> 00000000003526e0
> [959642.297242] Call Trace:
> [959642.297246]  <IRQ>
> [959642.297250]  ? pfifo_fast_init+0x100/0x100
> [959642.297254]  call_timer_fn+0x24/0xf0
> [959642.297259]  __run_timers.part.0+0x1b8/0x220
> [959642.297263]  ? recalibrate_cpu_khz+0x10/0x10
> [959642.297268]  ? ktime_get+0x33/0x90
> [959642.297272]  ? lapic_timer_set_periodic+0x20/0x20
> [959642.297276]  ? clockevents_program_event+0x88/0xe0
> [959642.297280]  run_timer_softirq+0x21/0x50
> [959642.297284]  __do_softirq+0xba/0x264
> [959642.297290]  asm_call_irq_on_stack+0x12/0x20
> [959642.297294]  </IRQ>
> [959642.297296]  do_softirq_own_stack+0x32/0x40
> [959642.297300]  irq_exit_rcu+0x83/0xb0
> [959642.297304]  sysvec_apic_timer_interrupt+0x36/0x80
> [959642.297309]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [959642.297314] RIP: 0010:cpuidle_enter_state+0xcd/0x340
> [959642.297320] Code: 49 89 c5 0f 1f 44 00 00 31 ff e8 8e 96 5b ff 45
> 84 ff 74 12 9c 58 f6 c4 02 0f 85 56 02 00 00 31 ff e8 b7 3b 60 ff fb
> 45 85 f6 <0f> 88 e9 00 00 00 49 63 c6 4c 2b 2c 24 48 8d 14 40 48 8d 0c
> 90 48
> [959642.297322] RSP: 0018:ffffb1d20008fea8 EFLAGS: 00000202
> [959642.297326] RAX: ffff8dddafae9a40 RBX: ffffd1d1ffaeb500 RCX:
> 000000000000001f
> [959642.297328] RDX: 0000000000000000 RSI: 0000000040000000 RDI:
> 0000000000000000
> [959642.297330] RBP: 0000000000000002 R08: 000368ca223b0fae R09:
> 0000000000000008
> [959642.297332] R10: 00000000000003dc R11: 00000000000003da R12:
> ffffffffa55ecf40
> [959642.297334] R13: 000368ca223b0fae R14: 0000000000000002 R15:
> 0000000000000000
> [959642.297338]  ? cpuidle_enter_state+0xb2/0x340
> [959642.297342]  cpuidle_enter+0x24/0x40
> [959642.297346]  do_idle+0x1ba/0x210
> [959642.297351]  cpu_startup_entry+0x14/0x20
> [959642.297354]  secondary_startup_64_no_verify+0xb0/0xbb
> [959642.297359] ---[ end trace 9b29a940f734a412 ]---
> [959642.297365] ixgbe 0000:06:00.0 eno1: initiating reset due to tx timeout
> [959647.929975] ixgbe 0000:06:00.0 eno1: initiating reset due to tx timeout
> [959649.130161] ixgbe 0000:06:00.0 eno1: Reset adapter
> [959649.135186] ixgbe 0000:06:00.0 eno1: NIC Link is Down
> [959652.566949] ixgbe 0000:06:00.0 eno1: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [959669.944390] ixgbe 0000:06:00.0 eno1: initiating reset due to tx timeout
> [959670.096838] ixgbe 0000:06:00.0 eno1: Reset adapter
> [959670.101836] ixgbe 0000:06:00.0 eno1: NIC Link is Down
> [959673.405387] ixgbe 0000:06:00.0 eno1: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [959856.307490] ixgbe 0000:06:00.0 eno1: initiating reset due to tx timeout
> [959861.536015] ixgbe 0000:06:00.0 eno1: Reset adapter
> [959861.541031] ixgbe 0000:06:00.0 eno1: NIC Link is Down
> [959865.387649] ixgbe 0000:06:00.0 eno1: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> ----
>
> It always seems to happen under cpu load - I'm mad enough to run
> gentoo on a Atom (Intel(R) Atom(TM) CPU C3858 @ 2.00GHz) machine ;)
>
> When first triggered it takes a while - eventually any spike in cpu
> load will crash the machine... (I suspect that the hw-watchdog reboots
> it but there is no logs)
>
> Any clues? I did run with flow offload in nftables - but I have since
> disabled that as well...
