Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E81A6CF2BA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjC2THc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjC2THb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:07:31 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D7810C1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:07:30 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-177ca271cb8so17300817fac.2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680116849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JaUT1tU388H4Iiw0YwVhlOiRQVGRnO0sCIgxdGFYzBo=;
        b=nUlU/uciYcc2nv9mdkYyaCMr60EMZ1HGpA7A0QKmRdrrp6agIwsXY1XTsd1/lvA14s
         n0BCUy7aZ41IQbWv57XAc3DUffF6hG3lKjKgiJLi67bjFuqtctp4DJ0jnz0+kxzoj6F8
         0TgAE2tmSpqbcZ2HpBYrtlR5i7HArV06QxVTlZqvpBF3PcNeaMRVRQJOodE0UZq9QHHG
         yvRQC3z5hvVTIaqV8RfXNoiPCXQhAFuBfhH1s5GjyMg/OwxAvPhZbMw54MoQioTws6Kb
         57rl9VZDhrvJpwGEGQ+ia0F5VXwvUNh2HRJOUC6X1wfPQWCBpKvFmvFbYy2NKlAjnWcx
         qBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680116849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaUT1tU388H4Iiw0YwVhlOiRQVGRnO0sCIgxdGFYzBo=;
        b=3n5RZJtZLrxJICsUjaLaYKpvOVHezjYafZiZLUULbx3fqbHfBY7Uyrf5o9RvWhwksf
         QuqL5EHy1FJ3S+hNKZ8cHoC3/3VANEpzNbt9Z2UE5crwWaRtlttE2S3rGDwfBz5xpYy/
         uQiplmt4pKgQO8DR7/k4p0n82ym93XiSXnr9s0OXt7jOmBnSj5K5URMjL0fGXhNzH7wv
         SVCMYXD63OLuJYt97wFfzhLAtnjFEV+/8XvQIkYx/FqR6jP6e8bIFcUqtX+wRKEXH6jR
         FR4QMAo+I96sfjCVBr8vjJ+YS1jsQHLPXog/nD2ONFD/9YVVTqYQNR/6KZYbKF6YaVp7
         cqQQ==
X-Gm-Message-State: AAQBX9epWVvsLzKL20jPlMsro4mygdWc3Tiu40UptSI43W3YqaNEfVpw
        XKrS9DLV/7bEUoSO4IARlX8r1w==
X-Google-Smtp-Source: AK7set8Y4L9H1obAoZ4wkF+dwXU27OfB8gALFoZq/Ka3R4cGwzO1ALkhor5m4gXJaNG8m39DV7j8fg==
X-Received: by 2002:a05:6870:206:b0:176:7d5d:f02a with SMTP id j6-20020a056870020600b001767d5df02amr14203363oad.11.1680116849050;
        Wed, 29 Mar 2023 12:07:29 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:675:778:777c:5b6b? ([2804:14d:5c5e:4698:675:778:777c:5b6b])
        by smtp.gmail.com with ESMTPSA id ui4-20020a0568714e0400b001718e65a5d0sm11984951oab.57.2023.03.29.12.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 12:07:28 -0700 (PDT)
Message-ID: <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
Date:   Wed, 29 Mar 2023 16:07:24 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Content-Language: en-US
To:     Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org> <ZCOylfbhuk0LeVff@do-x1extreme>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZCOylfbhuk0LeVff@do-x1extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/03/2023 00:37, Seth Forshee wrote:
> On Tue, Mar 28, 2023 at 06:47:33PM -0700, Jakub Kicinski wrote:
>> Seth, does this looks related to commit 267463823adb ("net: sch:
>> eliminate unnecessary RCU waits in mini_qdisc_pair_swap()")
>> by any chance?
> 
> I don't see how it could be. The memory being written is part of the
> qdisc private memory, and tc_new_tfilter() takes a reference to the
> qdisc. If that memory has been freed doesn't it mean that something has
> done an unbalanced qdisc_put()?
> 

Reverting Seth's patches (85c0c3eb9a66 and 267463823adb) leads to these 
traces with the reproducer:
[   52.704956][    C0] ------------[ cut here ]------------
[   52.705568][    C0] ODEBUG: free active (active state 1) object:0
[   52.706542][    C0] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c0
[   52.707283][    C0] Modules linked in:
[   52.707602][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0
[   52.708304][    C0] Hardware name: QEMU Standard PC (i440FX + PI4
[   52.709032][    C0] RIP: 0010:debug_print_object+0x196/0x290
[   52.709509][    C0] Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85e
[   52.711011][    C0] RSP: 0018:ffffc90000007cd0 EFLAGS: 00010282
[   52.711510][    C0] RAX: 0000000000000000 RBX: 0000000000000003 0
[   52.712125][    C0] RDX: ffffffff8c495800 RSI: ffffffff814b96d7 1
[   52.712748][    C0] RBP: 0000000000000001 R08: 0000000000000001 0
[   52.713370][    C0] R10: 0000000000000000 R11: 203a47554245444f 0
[   52.713983][    C0] R13: ffffffff8aa6e960 R14: 0000000000000000 8
[   52.714609][    C0] FS:  0000000000000000(0000) GS:ffff8881f5a000
[   52.715356][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008003
[   52.715863][    C0] CR2: 000055914686f020 CR3: 000000011e856000 0
[   52.716486][    C0] Call Trace:
[   52.716742][    C0]  <IRQ>
[   52.716969][    C0]  debug_check_no_obj_freed+0x302/0x420
[   52.717423][    C0]  slab_free_freelist_hook+0xec/0x1c0
[   52.717848][    C0]  ? rcu_core+0x818/0x1930
[   52.718204][    C0]  __kmem_cache_free+0xaf/0x2e0
[   52.718590][    C0]  rcu_core+0x818/0x1930
[   52.718938][    C0]  ? rcu_report_dead+0x610/0x610
[   52.719328][    C0]  __do_softirq+0x1d4/0x8ef
[   52.719689][    C0]  __irq_exit_rcu+0x11d/0x190
[   52.720062][    C0]  irq_exit_rcu+0x9/0x20
[   52.720402][    C0]  sysvec_apic_timer_interrupt+0x97/0xc0
[   52.720842][    C0]  </IRQ>
[   52.721070][    C0]  <TASK>
[   52.721300][    C0]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   52.721779][    C0] RIP: 0010:default_idle+0xf/0x20
[   52.722172][    C0] Code: 89 07 49 c7 c0 08 00 00 00 4d 29 c8 4c5
[   52.723631][    C0] RSP: 0018:ffffffff8c407e30 EFLAGS: 00000202
[   52.724096][    C0] RAX: 000000000007897f RBX: 0000000000000000 6
[   52.724702][    C0] RDX: 0000000000000000 RSI: 0000000000000001 0
[   52.725335][    C0] RBP: ffffffff8c495800 R08: 0000000000000001 b
[   52.725957][    C0] R10: ffffed103eb46d95 R11: 0000000000000000 0
[   52.726550][    C0] R13: 0000000000000000 R14: ffffffff8e7834d0 0
[   52.727162][    C0]  ? ct_kernel_exit+0x1d6/0x240
[   52.727542][    C0]  default_idle_call+0x67/0xa0
[   52.727912][    C0]  do_idle+0x31e/0x3e0
[   52.728241][    C0]  ? arch_cpu_idle_exit+0x30/0x30
[   52.728635][    C0]  cpu_startup_entry+0x18/0x20
[   52.729006][    C0]  rest_init+0x16d/0x2b0
[   52.729338][    C0]  ? regulator_has_full_constraints+0x9/0x20
[   52.729815][    C0]  ? trace_init_perf_perm_irq_work_exit+0x20/00
[   52.730309][    C0]  arch_call_rest_init+0x13/0x30
[   52.730703][    C0]  start_kernel+0x352/0x4c0
[   52.731087][    C0]  secondary_startup_64_no_verify+0xce/0xdb
[   52.731611][    C0]  </TASK>
[   52.731870][    C0] Kernel panic - not syncing: kernel: panic_on.
[   52.732445][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0
[   52.733140][    C0] Hardware name: QEMU Standard PC (i440FX + PI4
[   52.733867][    C0] Call Trace:
[   52.734143][    C0]  <IRQ>
[   52.734380][    C0]  dump_stack_lvl+0xd9/0x150
[   52.734769][    C0]  panic+0x684/0x730
[   52.735082][    C0]  ? panic_smp_self_stop+0x90/0x90
[   52.735322][    C0]  ? show_trace_log_lvl+0x285/0x390
[   52.735322][    C0]  ? debug_print_object+0x196/0x290
[   52.735322][    C0]  check_panic_on_warn+0xb1/0xc0
[   52.735322][    C0]  __warn+0xf2/0x390
[   52.735322][    C0]  ? debug_print_object+0x196/0x290
[   52.735322][    C0]  report_bug+0x2dd/0x500
[   52.735322][    C0]  handle_bug+0x3c/0x70
[   52.735322][    C0]  exc_invalid_op+0x18/0x50
[   52.735322][    C0]  asm_exc_invalid_op+0x1a/0x20
[   52.735322][    C0] RIP: 0010:debug_print_object+0x196/0x290
[   52.735322][    C0] Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85e
[   52.735322][    C0] RSP: 0018:ffffc90000007cd0 EFLAGS: 00010282
[   52.735322][    C0] RAX: 0000000000000000 RBX: 0000000000000003 0
[   52.735322][    C0] RDX: ffffffff8c495800 RSI: ffffffff814b96d7 1
[   52.735322][    C0] RBP: 0000000000000001 R08: 0000000000000001 0
[   52.735322][    C0] R10: 0000000000000000 R11: 203a47554245444f 0
[   52.735322][    C0] R13: ffffffff8aa6e960 R14: 0000000000000000 8
[   52.735322][    C0]  ? __warn_printk+0x187/0x310
[   52.735322][    C0]  debug_check_no_obj_freed+0x302/0x420
[   52.735322][    C0]  slab_free_freelist_hook+0xec/0x1c0
[   52.735322][    C0]  ? rcu_core+0x818/0x1930
[   52.735322][    C0]  __kmem_cache_free+0xaf/0x2e0
[   52.735322][    C0]  rcu_core+0x818/0x1930
[   52.735322][    C0]  ? rcu_report_dead+0x610/0x610
[   52.735322][    C0]  __do_softirq+0x1d4/0x8ef
[   52.735322][    C0]  __irq_exit_rcu+0x11d/0x190
[   52.735322][    C0]  irq_exit_rcu+0x9/0x20
[   52.735322][    C0]  sysvec_apic_timer_interrupt+0x97/0xc0
[   52.735322][    C0]  </IRQ>
[   52.735322][    C0]  <TASK>
[   52.735322][    C0]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   52.735322][    C0] RIP: 0010:default_idle+0xf/0x20
[   52.735322][    C0] Code: 89 07 49 c7 c0 08 00 00 00 4d 29 c8 4c5
[   52.735322][    C0] RSP: 0018:ffffffff8c407e30 EFLAGS: 00000202
[   52.735322][    C0] RAX: 000000000007897f RBX: 0000000000000000 6
[   52.735322][    C0] RDX: 0000000000000000 RSI: 0000000000000001 0
[   52.735322][    C0] RBP: ffffffff8c495800 R08: 0000000000000001 b
[   52.735322][    C0] R10: ffffed103eb46d95 R11: 0000000000000000 0
[   52.735322][    C0] R13: 0000000000000000 R14: ffffffff8e7834d0 0
[   52.735322][    C0]  ? ct_kernel_exit+0x1d6/0x240
[   52.735322][    C0]  default_idle_call+0x67/0xa0
[   52.735322][    C0]  do_idle+0x31e/0x3e0
[   52.735322][    C0]  ? arch_cpu_idle_exit+0x30/0x30
[   52.735322][    C0]  cpu_startup_entry+0x18/0x20
[   52.735322][    C0]  rest_init+0x16d/0x2b0
[   52.735322][    C0]  ? regulator_has_full_constraints+0x9/0x20
[   52.735322][    C0]  ? trace_init_perf_perm_irq_work_exit+0x20/00
[   52.735322][    C0]  arch_call_rest_init+0x13/0x30
[   52.735322][    C0]  start_kernel+0x352/0x4c0
[   52.735322][    C0]  secondary_startup_64_no_verify+0xce/0xdb
[   52.735322][    C0]  </TASK>
[   52.735322][    C0] Kernel Offset: disabled
[   52.735322][    C0] Rebooting in 86400 seconds..


