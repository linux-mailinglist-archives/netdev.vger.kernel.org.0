Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D85FC10F
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJLHGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJLHGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:06:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9717A62AA3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 00:06:09 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id 13so36065766ejn.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 00:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3FHxfaX0nUvU3yM6pdGDpraNdXFnmAEzWTxDZP6zVag=;
        b=cffGMndeYEmELAI2l1vym18F2hWFwe93SbDFuJNsK2tN3mDwPR4EZnrhV1EDQ86JlF
         oPPORGk/wOJ7GRnpblMJkW2fkc0Vpg83lyYrsWp3r68N1G9QuMe1hcVtSq8663uWEo6W
         O6WlojTohjO6nTAaeSN416a8SyCidZa0xF2KWz/I5aPvDQ04a2K1xSP0zZz3llF3nOMI
         MLHfW9ve+SZ+/llayySwVf41keulS2jXW30hXifWIztGNZhu1k/f+JysM8z9J62ouCAs
         oTL55ao3P7wTCsYgZCR/k8UO78YseOVW2NJJjczVUOaS9pZgTOmuzCBnYo8Ok6O7rOgp
         G7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FHxfaX0nUvU3yM6pdGDpraNdXFnmAEzWTxDZP6zVag=;
        b=eyMD3QpOLjuQq0KCi628UwWjVzvt+l5+LDLPPNdYBncxlPChKk2UxWCpRPY50/5LM2
         9QLtdIx3UoctBaq1pZw2BI3sOyBRkSPmE2T2sIQ0WvQuO8MfidIAInTypSrV51R8rh1o
         jecRIQwP+Q0i1eWgKad2T4CxN49kFCUUNGRmek09lr9Rpgo4J7m7QWy7fAgmCjCUU8VT
         fueEbaXmBU6IBZQPuTg5fZGKvr/GvcZnlNiG+25oMWraT3HJPDn8JscEREnFBscacZq0
         ec15wDFJt3N1jARYNWJXc1d1D/mq8WQXyyVm2yR/bgWMf6XR0nsKCSTdTAdBdHcyLJr3
         mjog==
X-Gm-Message-State: ACrzQf0xjYjnYDSAzuaVlHILlRynnDnRx/UjtqdwzzxAnnI7++qnnZ3V
        IuskTLFO9JP1pEdiOa+l05CsXhBvLrUtCqjxVpUfbQ==
X-Google-Smtp-Source: AMsMyM6Xi8F6DTgp4ZKvWbVbWHa1cM1s8X+vpij+0T/1ie3OxzN9LtD5fqXK74DtrKVmQ1uJyfPyoOMlh7NiSF/8Kdk=
X-Received: by 2002:a17:907:7d8e:b0:78d:ed30:643b with SMTP id
 oz14-20020a1709077d8e00b0078ded30643bmr2862275ejc.253.1665558367879; Wed, 12
 Oct 2022 00:06:07 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 Oct 2022 12:35:56 +0530
Message-ID: <CA+G9fYui6--jhN1CFH6fXNK81sHNYgosTs2hyybFqPxFRvndpg@mail.gmail.com>
Subject: BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
To:     open list <linux-kernel@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, linux-bluetooth@vger.kernel.org,
        lkft-triage@lists.linaro.org, regressions@lists.linux.dev,
        Netdev <netdev@vger.kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel deadlock warnings and BUG noticed on arm64 Qcom db845c dev=
ice
While booting Linux next 20221012 tag kernel Image and kselftest configs.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[   18.690573] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   18.695938] WARNING: possible recursive locking detected
[   18.701307] 6.0.0-next-20221012 #1 Not tainted
[   18.705804] --------------------------------------------
[   18.711168] kworker/u16:5/256 is trying to acquire lock:
[   18.716544] ffff58730911e4f8 (&irq_desc_lock_class){-.-.}-{2:2},
at: __irq_get_desc_lock+0x64/0xa4
[   18.725629]
[   18.725629] but task is already holding lock:
[   18.731519] ffff5873071c64f8 (&irq_desc_lock_class){-.-.}-{2:2},
at: __irq_get_desc_lock+0x64/0xa4
[   18.733233] remoteproc remoteproc0: remote processor
remoteproc-adsp is now up
[   18.740563]
[   18.740563] other info that might help us debug this:
[   18.740566]  Possible unsafe locking scenario:
[   18.740566]
[   18.740569]        CPU0
[   18.740571]        ----
[   18.740573]   lock(&irq_desc_lock_class);
[   18.740579]   lock(&irq_desc_lock_class);
[   18.740585]
[   18.740585]  *** DEADLOCK ***
[   18.740585]
[   18.740587]  May be due to missing lock nesting notation
[   18.740587]
[   18.757926] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[   18.760420] 6 locks held by kworker/u16:5/256:
[   18.760424]  #0: ffff587300032938
((wq_completion)events_unbound){+.+.}-{0:0}, at:
process_one_work+0x1e8/0x6d4
[   18.793798] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   18.794138]  #1: ffff800009a1bdd0
(deferred_probe_work){+.+.}-{0:0}, at: process_one_work+0x1e8/0x6d4
[   18.815528]  #2: ffff5873019e68f8 (&dev->mutex){....}-{3:3}, at:
__device_attach+0x44/0x200
[   18.833287]  #3: ffffdd47e98f1cf0 (cpu_hotplug_lock){++++}-{0:0},
at: cpus_read_lock+0x18/0x24
M[K[  *** ] (2 of 2) A start j[   18.842012]  #4: ffff587301248518
(subsys mutex#8){+.ob is running for=C3=A2=E2=82=AC=C2=A6n to /usr/lib/rfsa=
 (9s / no
limit)
[   18.857511]  #5: ffff5873071c64f8
(&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x64/0xa4
[   18.871877]
[   18.871877] stack backtrace:
[   18.876286] CPU: 4 PID: 256 Comm: kworker/u16:5 Not tainted
6.0.0-next-20221012 #1
[   18.883936] Hardware name: Thundercomm Dragonboard 845c (DT)
[   18.889655] Workqueue: events_unbound deferred_probe_work_func
[   18.895566] Call trace:
[   18.898046]  dump_backtrace+0xe4/0x140
[   18.901847]  show_stack+0x30/0x60
[   18.905203]  dump_stack_lvl+0x8c/0xb8
[   18.908918]  dump_stack+0x18/0x34
[   18.912274]  __lock_acquire+0x1154/0x2040
[   18.916330]  lock_acquire.part.0+0xe8/0x24c
[   18.920568]  lock_acquire+0x84/0xa0
[   18.924102]  _raw_spin_lock_irqsave+0x70/0xb0
[   18.928523]  __irq_get_desc_lock+0x64/0xa4
[   18.928532]  enable_irq+0x40/0xb0
[   18.928542]  lmh_enable_interrupt+0x3c/0x50 [lmh]
Coldplug All udev De[   18.94080vices.
[   18.952775]  __irq_startup+0x88/0xbc
[K[   18.957451]  irq_startup+0x84/0x180
[   18.961243]  __enable_irq+0x88/0xa0
[   18.964776]  enable_irq+0x54/0xb0
[   18.968140]  qcom_cpufreq_ready+0x2c/0x3c
[   18.972200]  cpufreq_online+0x2f4/0xb24
[   18.976083]  cpufreq_add_dev+0xdc/0x100
[   18.979964]  subsys_interface_register+0x134/0x14c
[   18.984819]  cpufreq_register_driver+0x16c/0x2e0
[   18.989488]  qcom_cpufreq_hw_driver_probe+0xdc/0x150
[   18.994510]  platform_probe+0x70/0x100
[   18.998311]  really_probe+0xd4/0x3f4
[   19.001936]  __driver_probe_device+0x8c/0x1a0
[   19.006347]  driver_probe_device+0x4c/0x13c
[   19.010584]  __device_attach_driver+0xd8/0x180
[   19.015081]  bus_for_each_drv+0x88/0xe0
[   19.018966]  __device_attach+0xb4/0x200
[   19.022845]  device_initial_probe+0x28/0x40
[   19.027081]  bus_probe_device+0xa8/0xb0
[   19.030965]  deferred_probe_work_func+0xc0/0x120
[   19.035637]  process_one_work+0x280/0x6d4
[   19.039695]  worker_thread+0x7c/0x430
[   19.043407]  kthread+0x110/0x114
[   19.046677]  ret_from_fork+0x10/0x20
[   19.108471] cpu cpu4: EM: created perf domain
         Starting Wait for udev To =C3=A2=E2=82=AC=C2=A6plete Device Initia=
lization.
[   19.125768] remoteproc remoteproc1: remote processor
remoteproc-cdsp is now up
[   19.138140] xhci_hcd 0000:01:00.0: Adding to iommu group 6
[   19.150419] coresight stm0: STM32 initialized
[   19.254272] ath10k_snoc 18800000.wifi: Adding to iommu group 10
[   19.372948] ath10k_snoc 18800000.wifi: supply vdd-3.3-ch1 not
found, using dummy regulator
[   19.472640] geni_spi 880000.spi: FIFO mode disabled, but couldn't
get DMA, fall back to FIFO mode
[   19.485178] gpi 800000.dma-controller: Adding to iommu group 11
[  OK  ] Reached target [0;1;39mHardware activated USB gadget.
[   19.528153] i2c 16-0010: Fixing up cyclic dependency with acb3000.camss
[   19.559810] i2c 10-003b: Fixing up cyclic dependency with hdmi-out
[   19.575396] gpi a00000.dma-controller: Adding to iommu group 12
[   19.590779] qcom-venus aa00000.video-codec: Adding to iommu group 13
[   19.608167] qcom-venus aa00000.video-codec: non legacy binding
[   19.618073] remoteproc remoteproc2: 4080000.remoteproc is available
[   19.629950] qcom-camss acb3000.camss: Adding to iommu group 14
[   19.630180] Bluetooth: Core ver 2.22
[   19.639713] NET: Registered PF_BLUETOOTH protocol family
[   19.645247] Bluetooth: HCI device and connection manager initialized
[   19.651711] Bluetooth: HCI socket layer initialized
[   19.656813] Bluetooth: L2CAP socket layer initialized
[   19.661960] Bluetooth: SCO socket layer initialized
[   19.743786] adreno 5000000.gpu: Adding to iommu group 15
[   19.764896] Bluetooth: HCI UART driver ver 2.3
[   19.769470] Bluetooth: HCI UART protocol H4 registered
[   19.778004] msm-mdss ae00000.mdss: Adding to iommu group 16
[   19.783005] Bluetooth: HCI UART protocol LL registered
[   19.809993] Bluetooth: HCI UART protocol Broadcom registered
[   19.819508] Bluetooth: HCI UART protocol QCA registered
[   19.829474] Bluetooth: HCI UART protocol Marvell registered
[   19.858355] EXT4-fs (sde9): mounted filesystem with ordered data
mode. Quota mode: none.
[   19.893331] platform ae94000.dsi: Fixing up cyclic dependency with 10-00=
3b
[  OK  ] Finished Mount DSP partition to /usr/lib/rfsa.
[   19.917937] platform ae94000.dsi: Fixing up cyclic dependency with
ae01000.display-controller
[  OK  ] Reached target Local File Systems.
[  OK  ] Listening on Load/Save RF =C3=A2=E2=82=AC=C2=A6itch Status /dev/rf=
kill Watch.
[   19.950987] BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:580
[   19.959591] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid:
258, name: kworker/u16:7
[   19.968096] preempt_count: 100, expected: 0
[   19.972374] RCU nest depth: 0, expected: 0
[   19.976562] INFO: lockdep is turned off.
[   19.980574] CPU: 0 PID: 258 Comm: kworker/u16:7 Not tainted
6.0.0-next-20221012 #1
[   19.988245] Hardware name: Thundercomm Dragonboard 845c (DT)
[   19.993986] Workqueue: events_unbound async_run_entry_fn
[   19.999395] Call trace:
[   20.001886]  dump_backtrace+0xe4/0x140
[   20.005700]  show_stack+0x30/0x60
[   20.009069]  dump_stack_lvl+0x8c/0xb8
[   20.012798]  dump_stack+0x18/0x34
[   20.016169]  __might_resched+0x1c4/0x240
[   20.020155]  __might_sleep+0x58/0xb0
[   20.020802] rtc-pm8xxx c440000.spmi:pmic@0:rtc@6000: registered as rtc0
[   20.023766]  __mutex_lock+0x54/0x424
[   20.023778]  mutex_lock_nested+0x50/0x6c
[   20.030501] rtc-pm8xxx c440000.spmi:pmic@0:rtc@6000: setting system
clock to 1970-01-01T00:00:30 UTC (30)
[   20.033086] input: pm8941_pwrkey as
/devices/platform/soc@0/c440000.spmi/spmi-0/0-00/c440000.spmi:pmic@0:pon@80=
0/c440000.spmi:pmic@0:pon@800:pwrkey/input/input1
[   20.034047]  lpg_brightness_single_set+0x48/0x9c [leds_qcom_lpg]
[   20.034132] systemd-journald[295]: Time jumped backwards, rotating.
[   20.074723]  led_set_brightness_nosleep+0x54/0x80
[   20.079509]  led_heartbeat_function+0x88/0x180
[   20.084024]  call_timer_fn+0xc0/0x3c4
[   20.087751]  __run_timers.part.0+0x220/0x27c
[   20.092085]  run_timer_softirq+0x44/0x80
[   20.096073]  __do_softirq+0x1e4/0x62c
[   20.099793]  ____do_softirq+0x18/0x24
[   20.103520]  call_on_irq_stack+0x2c/0x58
[   20.107511]  do_softirq_own_stack+0x24/0x3c
[   20.111757]  __irq_exit_rcu+0x168/0x1a0
[   20.115661]  irq_exit_rcu+0x18/0x40
[   20.119203]  el1_interrupt+0x38/0x64
[   20.122838]  el1h_64_irq_handler+0x18/0x2c
[   20.127002]  el1h_64_irq+0x64/0x68
[   20.130465]  arch_counter_get_cntvct+0x14/0x30
[   20.134979]  __delay+0xa4/0x110
[   20.138179]  __const_udelay+0x34/0x44
[   20.141900]  qcom_geni_serial_poll_bit+0xc4/0x104
[   20.146675]  qcom_geni_serial_stop_rx+0xc0/0x190
[   20.151367]  qcom_geni_serial_set_termios+0x4c/0x360
[   20.156410]  uart_change_speed+0x60/0x130
[   20.160479]  uart_set_termios+0x90/0x190
[   20.164460]  tty_set_termios+0x194/0x240
[   20.168447]  ttyport_open+0x144/0x180
[   20.172169]  serdev_device_open+0x38/0xe4
[   20.176248]  hci_uart_register_device+0x68/0x3ac [hci_uart]
[   20.181957]  qca_serdev_probe+0x2f4/0x530 [hci_uart]
[   20.186753] input: pm8941_resin as
/devices/platform/soc@0/c440000.spmi/spmi-0/0-00/c440000.spmi:pmic@0:pon@80=
0/c440000.spmi:pmic@0:pon@800:resin/input/input2
[   20.187003]  serdev_drv_probe+0x44/0x90
[   20.187016]  really_probe+0xd4/0x3f4
[   20.208885]  __driver_probe_device+0x8c/0x1a0
[   20.213311]  driver_probe_device+0x4c/0x13c
[   20.217555]  __driver_attach_async_helper+0x64/0x110
[   20.222594]  async_run_entry_fn+0x40/0x180
[   20.226759]  process_one_work+0x280/0x6d4
[   20.230837]  worker_thread+0x7c/0x430
[   20.234557]  kthread+0x110/0x114
[   20.237849]  ret_from_fork+0x10/0x20

Full boot log link,
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20221012=
/testrun/12361480/suite/log-parser-boot/test/check-kernel-bug/log
 - https://lkft.validation.linaro.org/scheduler/job/5660839#L3720


metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git_sha: f843795727e4f5612c612cd178db1557978da742
  git_describe: next-20221012
  kernel_version: 6.0.0
  kernel-config: https://builds.tuxbuild.com/2G10hEBW0Cdgh2jzrxvNzlRXdec/co=
nfig
  build-url: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next/-/pipel=
ines/664367901
  artifact-location: https://builds.tuxbuild.com/2G10hEBW0Cdgh2jzrxvNzlRXde=
c
  toolchain: gcc-11
  System.map: https://builds.tuxbuild.com/2G10hEBW0Cdgh2jzrxvNzlRXdec/Syste=
m.map
  vmlinux.xz: https://builds.tuxbuild.com/2G10hEBW0Cdgh2jzrxvNzlRXdec/vmlin=
ux.xz


--
Linaro LKFT
https://lkft.linaro.org
