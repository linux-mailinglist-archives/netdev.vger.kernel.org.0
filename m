Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E39240590
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHJMID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 08:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgHJMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 08:08:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C5C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 05:08:01 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s189so8592254iod.2
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 05:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=YGrXVf4BI3pwxBSHzUmX4cQpSIcq4pv7/RQXTZUQb54=;
        b=zMs/OZB7mROds9+zYBJYv2qcS2IUllh3a3z00fkQpGB6mpPvfTPpNOlkiFpVs/93Zd
         ZndKc2ptugkW7mBZnKHhpwxgGO9qkSrn+cIhfujsZsJSAYnLbnx5CEkE5RqahhiYjvXS
         L4mmMLKz32FnXJD4GFBlxSQuqS7BsEH4vpw/RjoAsBlEvJPLXdiQvr5I1OIegKVjBeFJ
         jhkZgSEMLyf5nYdL2vsRUR951q2s4LycsZakFko23LniSgwJiTTWshETTlqPQclfPAPg
         ksEuzy+GXj+hbClzkgpIlMir/M9n2v1eG6ywSZy99yu+51QPf9wSyZ8wVsv9yOsYn+RW
         RzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=YGrXVf4BI3pwxBSHzUmX4cQpSIcq4pv7/RQXTZUQb54=;
        b=rZ8K/mRFPD8EzlVdQzlwoWBhVONTbF+xLk5vtaDnitvVCHEgHJdEKJWAwAbWdAHBjg
         pYm2vPB4SgVT8MB8F1/SpgACW3UfVbVT3/kXVTL4mnUn/Wrtoy6Z4CSyi0bu9mAaezug
         2i+HZCJ1dFF02N9vne8M7y9oW7Aa5RX77UCscVGhZRNLT/8b1pGoGUGuewEG6REKz5ZF
         VeFlV0u1eQO8oqPOaTCY0tRCg6E9J4gOJgpIZ62D05zfigBAAL2ERRI9X9KwZfKLp4Ww
         lQonl6OdvnqQutqkwqu3fk9VK1zrRiSUm0Qs5n29Pyb/JLxIqEwqemCE4dFxYqwDqQR6
         93DQ==
X-Gm-Message-State: AOAM532kWrEAS3tuLl9dqMtoD9bYzIeRFqSQdttxmKW/Eo6UAkgtWkVT
        CRGEqcqTOx1552N4Y3XwyLx3dde5fg+cUH3860tHWA==
X-Google-Smtp-Source: ABdhPJyar1BayS88nv6Q3TEmAYuLf+zEG5d7MaLVKKDRl2NVIjj7rcyjJa7ZQlV1ce5u04XuweTKa1SSBjr6KLQHBkY=
X-Received: by 2002:a5d:995a:: with SMTP id v26mr16795758ios.176.1597061279790;
 Mon, 10 Aug 2020 05:07:59 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Aug 2020 17:37:48 +0530
Message-ID: <CA+G9fYv_pFCG8tieFbM-qXtUNDsCauQvvSFqQ8OXW5EmRJxgDQ@mail.gmail.com>
Subject: WARNING: at net/wireless/ti/wlcore/io.h:52 wlcore_set_partition - wl12xx_set_power_on
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftests firmware test cases on arm64 hikey the
following kernel warning noticed after rcu_preempt detected.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: f80535b9aa10b0bbed0fb727247c03e20580db1c
  git describe: next-20200810
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-next/836/config

Test output:
----------------
# ./fw_filesystem.sh filesystem loading works
filesystem: loading_works #
# ./fw_filesystem.sh async filesystem loading works
async: filesystem_loading #
# ./fw_filesystem.sh firmware loading platform trigger not present,
ignoring test
firmware: loading_platform #
<trim>
# Testing with the file missing...
with: the_file #
# Batched request_firmware() nofile try #1 OK
request_firmware(): nofile_try #
# Batched request_firmware() nofile try #2 OK
request_firmware(): nofile_try #
# Batched request_firmware() nofile try #3 OK
request_firmware(): nofile_try #
# Batched request_firmware() nofile try #4 OK
request_firmware(): nofile_try #
# Batched request_firmware() nofile try #5 OK
request_firmware(): nofile_try #
# Batched request_firmware_into_buf() nofile try #1 OK
request_firmware_into_buf(): nofile_try #
# Batched request_firmware_into_buf() nofile try #2 OK
request_firmware_into_buf(): nofile_try #
[  703.458858] rcu: INFO: rcu_preempt detected expedited stalls on
CPUs/tasks: { 0-... } 6847 jiffies s: 5897 root: 0x1/.
[  703.638281] rcu: blocking rcu_node structures:
[  703.823398] Task dump for CPU 0:
[  704.010337] swapper/0       R  running task        0     0      0 0x0000002a
[  704.183444] Call trace:
[  704.350054]  __switch_to+0xf8/0x148
[  704.519735]  function_trace_call+0xec/0x138
[  704.692279]  ftrace_ops_no_ops+0xd0/0x190
[  704.857800]  ftrace_graph_call+0x0/0xc
[  705.007071]  cpuidle_reflect+0x1c/0x50
[  705.192659]  do_idle+0x230/0x2c0
[  705.367973]  cpu_startup_entry+0x2c/0x70
[  705.534699]  rest_init+0x1ac/0x280
[  705.702975]  arch_call_rest_init+0x14/0x1c
[  705.868195]  start_kernel+0x4ec/0x524
[  760.984689] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  761.050531] rcu: 0-....: (3 GPs behind) idle=d36/0/0x3
softirq=30311/30311 fqs=3259
[  761.116235] (detected by 1, t=6520 jiffies, g=69177, q=54)
[  761.181632] Task dump for CPU 0:
[  761.242682] swapper/0       R  running task        0     0      0 0x0000002a
[  761.308592] Call trace:
[  761.368972]  __switch_to+0xf8/0x148
[  761.430354]  function_trace_call+0xec/0x138
[  761.492435]  ftrace_ops_no_ops+0xd0/0x190
[  761.553839]  ftrace_graph_call+0x0/0xc
[  761.614710]  cpuidle_reflect+0x1c/0x50
[  761.675523]  do_idle+0x230/0x2c0
[  761.735348]  cpu_startup_entry+0x2c/0x70
[  761.795729]  rest_init+0x1ac/0x280
[  761.855426]  arch_call_rest_init+0x14/0x1c
[  761.915590]  start_kernel+0x4ec/0x524
[  785.377148] rcu: INFO: rcu_preempt detected expedited stalls on
CPUs/tasks: { 0-... } 27327 jiffies s: 5897 root: 0x1/.
[  785.446389] rcu: blocking rcu_node structures:
[  785.509145] Task dump for CPU 0:
[  785.570463] swapper/0       R  running task        0     0      0 0x0000002a
[  785.635790] Call trace:
[  785.696364]  __switch_to+0xf8/0x148
[  785.757660]  0x0
[  802.076559] rcu: INFO: rcu_preempt self-detected stall on CPU
[  802.139876] rcu: 0-....: (4 GPs behind)
idle=d3a/1/0x4000000000000004 softirq=30311/30311 fqs=3258
[  802.207058] (t=6533 jiffies g=69181 q=191)
[  802.268659] Task dump for CPU 0:
[  802.329629] swapper/0       R  running task        0     0      0 0x0000002a
[  802.394536] Call trace:
[  802.454730]  dump_backtrace+0x0/0x1f8
[  802.516048]  show_stack+0x2c/0x38
[  802.576849]  sched_show_task+0x1ac/0x240
[  802.638160]  dump_cpu_task+0x48/0x58
[  802.699098]  rcu_dump_cpu_stacks+0xbc/0xfc
[  802.760519]  rcu_sched_clock_irq+0x7d8/0xc60
[  802.821943]  update_process_times+0x34/0xb8
[  802.883276]  tick_sched_handle.isra.16+0x44/0x68
[  802.944984]  tick_sched_timer+0x50/0xa0
[  803.005901]  __hrtimer_run_queues+0x2c0/0x638
[  803.067397]  hrtimer_interrupt+0xd8/0x248
[  803.128494]  arch_timer_handler_phys+0x38/0x58
[  803.189953]  handle_percpu_devid_irq+0xd0/0x468
[  803.251437]  generic_handle_irq+0x3c/0x58
[  803.312373]  __handle_domain_irq+0x68/0xc0
[  803.373219]  gic_handle_irq+0x60/0xb8
[  803.433731]  el1_irq+0xbc/0x180
[  803.493681]  arch_local_irq_restore+0x4/0x8
[  803.554618]  kmem_cache_free+0xb0/0x4a0
[  803.615231]  kfree_skbmem+0xc8/0xe8
[  803.675452]  kfree_skb+0x9c/0x250
[  803.735442]  enqueue_to_backlog+0xdc/0x390
[  803.796164]  netif_rx_internal+0x98/0x2f8
[  803.856651]  netif_rx+0x60/0x318
[  803.916259]  usbnet_skb_return+0x7c/0x150
[  803.976614]  ax88179_rx_fixup+0x100/0x1e8
[  804.036898]  usbnet_bh+0x1d0/0x330
[  804.096500]  usbnet_bh_tasklet+0x20/0x30
[  804.156685]  tasklet_action_common.isra.17+0x148/0x178
[  804.218153]  tasklet_action+0x2c/0x38
[  804.278130]  __do_softirq+0x154/0x6fc
[  804.338094]  irq_exit+0x174/0x180
[  804.397695]  __handle_domain_irq+0x6c/0xc0
[  804.458067]  gic_handle_irq+0x60/0xb8
[  804.518016]  el1_irq+0xbc/0x180
[  804.577436]  tick_nohz_idle_exit+0x6c/0xd0
[  804.637874]  do_idle+0x198/0x2c0
[  804.697323]  cpu_startup_entry+0x2c/0x70
[  804.757389]  rest_init+0x1ac/0x280
[  804.816924]  arch_call_rest_init+0x14/0x1c
[  804.877059]  start_kernel+0x4ec/0x524
[  865.249148] rcu: INFO: rcu_preempt detected expedited stalls on
CPUs/tasks: { 0-... } 47295 jiffies s: 5897 root: 0x1/.
[  865.316312] rcu: blocking rcu_node structures:
[  865.377050] Task dump for CPU 0:
[  865.436479] swapper/0       R  running task        0     0      0 0x0000002a
[  865.499869] Call trace:
[  865.558584]  __switch_to+0xf8/0x148
[  865.618377]  0x0
[  867.936304] ax88179_178a 1-1.1:1.0 eth0: ax88179 - Link status is: 0
[  869.373982] wlcore: down
[  875.464663] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  884.666485] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[  884.921791] ------------[ cut here ]------------
[  884.971615] WARNING: CPU: 1 PID: 326 at
/usr/src/kernel/drivers/net/wireless/ti/wlcore/io.h:52
wlcore_set_partition+0x68/0x520 [wlcore]
[  885.029490] Modules linked in: sch_fq 8021q garp mrp stp llc
iptable_filter ip_tables x_tables cls_bpf sch_ingress veth test_bpf
algif_hash wl18xx wlcore mac80211 cfg80211 snd_soc_hdmi_codec hci_uart
btqca btbcm adv7511 bluetooth wlcore_sdio snd_soc_audio_graph_card cec
crct10dif_ce snd_soc_simple_card_utils rfkill lima gpu_sched kirin_drm
dw_drm_dsi drm_kms_helper drm fuse [last unloaded: trace_printk]
[  885.165343] CPU: 1 PID: 326 Comm: NetworkManager Tainted: G
W         5.8.0-next-20200810 #1
[  885.220456] Hardware name: HiKey Development Board (DT)
[  885.272459] pstate: 00000005 (nzcv daif -PAN -UAO BTYPE=--)
[  885.334688] pc : wlcore_set_partition+0x68/0x520 [wlcore]
[  885.396798] lr : wl12xx_set_power_on+0x90/0x188 [wlcore]
[  885.458495] sp : ffff800013bf30e0
[  885.517806] x29: ffff800013bf30e0 x28: ffff00006a9edb48
[  885.579741] x27: 0000000000000003 x26: 0000000000000000
[  885.641668] x25: ffff00006acf3120 x24: ffff00006a9edce0
[  885.703396] x23: ffff800009837000 x22: 0000000000000000
[  885.764913] x21: ffff800009837000 x20: ffff8000094da068
[  885.826615] x19: ffff00006acf3120 x18: ffffffffffffffff
[  885.888716] x17: 0000000000000000 x16: 0000000000000000
[  885.950787] x15: 0000000000000000 x14: ffff0000772717c0
[  886.013104] x13: ffff800065bcd000 x12: 0000000005c00ff0
[  886.075443] x11: 0000000005c00000 x10: 0000000000000000
[  886.137915] x9 : ffff8000126a0a88 x8 : 0000000000000001
[  886.200375] x7 : 000000000000063c x6 : ffff800013bf2f40
[  886.262892] x5 : 0000000000000001 x4 : ffff00006ad00000
[  886.326075] x3 : 00c0000000000400 x2 : ffff000069831680
[  886.390946] x1 : 0000000000700000 x0 : 0000000000000009
[  886.454521] Call trace:
[  886.471228]  wlcore_set_partition+0x68/0x520 [wlcore]
[  886.490669]  wl12xx_set_power_on+0x90/0x188 [wlcore]
[  886.510013]  wl12xx_chip_wakeup+0x3c/0x260 [wlcore]
[  886.529294]  wl1271_op_add_interface+0x504/0xa08 [wlcore]
[  886.549263]  drv_add_interface+0xa0/0x3e0 [mac80211]
[  886.568802]  ieee80211_do_open+0x38c/0xc60 [mac80211]
[  886.588461]  ieee80211_open+0x4c/0x68 [mac80211]
[  886.607462]  __dev_open+0x118/0x1a8
[  886.625308]  __dev_change_flags+0x16c/0x1d0
[  886.643908]  dev_change_flags+0x3c/0x78
[  886.662123]  do_setlink+0x35c/0xed8
[  886.679969]  __rtnl_newlink+0x404/0x790
[  886.698180]  rtnl_newlink+0x54/0x80
[  886.716037]  rtnetlink_rcv_msg+0x29c/0x4f0
[  886.734510]  netlink_rcv_skb+0x64/0x130
[  886.752691]  rtnetlink_rcv+0x28/0x38
[  886.770608]  netlink_unicast+0x1dc/0x290
[  886.788870]  netlink_sendmsg+0x2b8/0x3f8
[  886.807122]  ____sys_sendmsg+0x288/0x2d0
[  886.825359]  ___sys_sendmsg+0x90/0xd0
[  886.843309]  __sys_sendmsg+0x78/0xd0
[  886.861158]  __arm64_sys_sendmsg+0x2c/0x38
[  886.879529]  el0_svc_common.constprop.3+0x7c/0x198
[  886.898659]  do_el0_svc+0x34/0xa0
[  886.916260]  el0_sync_handler+0x16c/0x210
[  886.934574]  el0_sync+0x140/0x180
[  886.952129] irq event stamp: 410260
[  886.969885] hardirqs last  enabled at (410259):
[<ffff80001133808c>] _raw_spin_unlock_irqrestore+0x94/0xc0
[  886.994216] hardirqs last disabled at (410260):
[<ffff80001132f068>] __schedule+0xf0/0x8f0
[  887.017150] softirqs last  enabled at (410218):
[<ffff800010001a94>] __do_softirq+0x674/0x6fc
[  887.040184] softirqs last disabled at (410211):
[<ffff800010097eb4>] irq_exit+0x174/0x180
[  887.062692] ---[ end trace 3c2f34a7bd5df45e ]---
[  887.144763] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  887.376864] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[  887.516634] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  887.716961] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[  888.013264] ------------[ cut here ]------------
[  888.074832] WARNING: CPU: 1 PID: 326 at
/usr/src/kernel/drivers/net/wireless/ti/wlcore/io.h:52
wlcore_set_partition+0x68/0x520 [wlcore]
[  888.144754] Modules linked in: sch_fq 8021q garp mrp stp llc
iptable_filter ip_tables x_tables cls_bpf sch_ingress veth test_bpf
algif_hash wl18xx wlcore mac80211 cfg80211 snd_soc_hdmi_codec hci_uart
btqca btbcm adv7511 bluetooth wlcore_sdio snd_soc_audio_graph_card cec
crct10dif_ce snd_soc_simple_card_utils rfkill lima gpu_sched kirin_drm
dw_drm_dsi drm_kms_helper drm fuse [last unloaded: trace_printk]
[  888.310219] CPU: 1 PID: 326 Comm: NetworkManager Tainted: G
W         5.8.0-next-20200810 #1
[  888.377744] Hardware name: HiKey Development Board (DT)
[  888.439538] pstate: 00000005 (nzcv daif -PAN -UAO BTYPE=--)
[  888.500910] pc : wlcore_set_partition+0x68/0x520 [wlcore]
[  888.561065] lr : wlcore_set_partition+0x20/0x520 [wlcore]
[  888.620899] sp : ffff800013bf30e0
[  888.678069] x29: ffff800013bf30e0 x28: ffff00006a9edb48
[  888.737880] x27: 0000000000000002 x26: 0000000000000000
[  888.798234] x25: ffff00006acf3120 x24: ffff00006a9edce0
[  888.858216] x23: ffff800009837000 x22: 0000000000000000
[  888.918112] x21: ffff800009837000 x20: ffff8000094da068
[  888.978896] x19: ffff00006acf3120 x18: ffffffffffffffff
[  889.038725] x17: 0000000000000000 x16: 0000000000000000
[  889.098607] x15: 0000000000000000 x14: ffff0000772717c0
[  889.158319] x13: ffff800065bcd000 x12: 0000000006700ff0
[  889.218287] x11: 0000000006700000 x10: 0000000000000000
[  889.278223] x9 : ffff8000126a0a88 x8 : 0000000000000001
[  889.338189] x7 : 0000000000000754 x6 : 0000000000021c0c
[  889.398530] x5 : ffff000062570300 x4 : 0000000000000000
[  889.458829] x3 : 00c0000000000400 x2 : ffff000069831680
[  889.519263] x1 : 0000000000700000 x0 : 0000000000000009
[  889.579662] Call trace:
[  889.636302]  wlcore_set_partition+0x68/0x520 [wlcore]
[  889.696047]  wl12xx_set_power_on+0x90/0x188 [wlcore]
[  889.755840]  wl12xx_chip_wakeup+0x3c/0x260 [wlcore]
[  889.815948]  wl1271_op_add_interface+0x504/0xa08 [wlcore]
[  889.877624]  drv_add_interface+0xa0/0x3e0 [mac80211]
[  889.937184]  ieee80211_do_open+0x38c/0xc60 [mac80211]
[  889.997542]  ieee80211_open+0x4c/0x68 [mac80211]
[  890.056701]  __dev_open+0x118/0x1a8
[  890.114776]  __dev_change_flags+0x16c/0x1d0
[  890.173336]  dev_change_flags+0x3c/0x78
[  890.231500]  do_setlink+0x35c/0xed8
[  890.288995]  __rtnl_newlink+0x404/0x790
[  890.347399]  rtnl_newlink+0x54/0x80
[  890.404950]  rtnetlink_rcv_msg+0x29c/0x4f0
[  890.463423]  netlink_rcv_skb+0x64/0x130
[  890.522076]  rtnetlink_rcv+0x28/0x38
[  890.579762]  netlink_unicast+0x1dc/0x290
[  890.638249]  netlink_sendmsg+0x2b8/0x3f8
[  890.696278]  ____sys_sendmsg+0x288/0x2d0
[  890.754574]  ___sys_sendmsg+0x90/0xd0
[  890.813095]  __sys_sendmsg+0x78/0xd0
[  890.871646]  __arm64_sys_sendmsg+0x2c/0x38
[  890.930336]  el0_svc_common.constprop.3+0x7c/0x198
[  890.989993]  do_el0_svc+0x34/0xa0
[  891.048176]  el0_sync_handler+0x16c/0x210
[  891.106626]  el0_sync+0x140/0x180
[  891.164652] irq event stamp: 410260
[  891.222545] hardirqs last  enabled at (410259):
[<ffff80001133808c>] _raw_spin_unlock_irqrestore+0x94/0xc0
[  891.287511] hardirqs last disabled at (410260):
[<ffff80001132f068>] __schedule+0xf0/0x8f0
[  891.350969] softirqs last  enabled at (410218):
[<ffff800010001a94>] __do_softirq+0x674/0x6fc
[  891.415147] softirqs last disabled at (410211):
[<ffff800010097eb4>] irq_exit+0x174/0x180
[  891.478913] ---[ end trace 3c2f34a7bd5df45f ]---
[  891.610580] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  891.866528] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[  892.014674] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  892.282641] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)

full test log link,
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20200810/testrun/3045576/suite/linux-log-parser/test/check-kernel-warning-1653950/log

-- 
Linaro LKFT
https://lkft.linaro.org
