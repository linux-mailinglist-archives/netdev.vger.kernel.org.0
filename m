Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57877672111
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjARPUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjARPU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:20:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6534B46D71
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674054896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwZ/8Z3ryIfv1IBb1wT6f51xYsnVszpzUcMeJ1HqjCw=;
        b=GAbgrk4bJ1ALgEnm6noH/FZLokVJXRlWuAkWhjJSkO3pILcjEE8oubQJPAP1lUaw/mxfrx
        ENowf48sYl0EVsrY4HRlZk3DYVIG/T95/R1R1kDw31MCPyAsWwYRqIjTZqMjQyKUVxBaCO
        008TQr5i/FFE9XtsiVVFPj/qrpz8+ig=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-438-SDVc3ZKpNNGK25JKx00jJA-1; Wed, 18 Jan 2023 10:14:55 -0500
X-MC-Unique: SDVc3ZKpNNGK25JKx00jJA-1
Received: by mail-pj1-f72.google.com with SMTP id t12-20020a17090a3e4c00b00225cb4e761cso1218702pjm.3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LwZ/8Z3ryIfv1IBb1wT6f51xYsnVszpzUcMeJ1HqjCw=;
        b=cHvzWD5PfoGRmsgpomOY4yCU/LRZyKPyzawG7n2Nd7Ig1neEtR/i2vtQxWYAkAGXeG
         v7i0N8AfqFL/S1pS7/K90mjZoYOJkfBsCGSULy7UeylCee6UmEMqzl/VklytHTffW1OH
         YkgGP8PpxwIu6UpLX+kQ737Ww/nE5ehkNfYfXuo/G2eVFxWROwwaGoWLBeWob5PRq4M7
         YwVUGu84k5K7s8Rgf8PmJucJndiSlIEY3so0TLSZxA+c/6xc1DiDAi86Q296mcrDKxeP
         OrXp5PPvwyoJy0VF5GNQ1EwAjQcNTXSA0gEfkaSRbtG4RzYp7u5QVOFF/RKpjPihvrMQ
         vK8A==
X-Gm-Message-State: AFqh2kqcCsRSyHyNCLgDkw5AUjGHFKK0Jp429v74/VlyR9pW5AkNuLVZ
        L0ey1nmHSJSPzypZqQbbqffGGE2OZuwGXE3Rbi9pfqt1gidHu+svwNScTqLQLRFJUkdXcMpBno6
        j74Y0oTQSKZ+UDUvpPXpFsRXrld1CTCcC
X-Received: by 2002:a17:903:2614:b0:194:78f2:a4df with SMTP id jd20-20020a170903261400b0019478f2a4dfmr683473plb.74.1674054893283;
        Wed, 18 Jan 2023 07:14:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXum/92rV7C+BB6nn9ripD8VYwZgvk4rDoffnGL/mpGbigHjNhkkju7o/H1fejOoHUDaD423ZgtyI3/115yIEkg=
X-Received: by 2002:a17:903:2614:b0:194:78f2:a4df with SMTP id
 jd20-20020a170903261400b0019478f2a4dfmr683456plb.74.1674054892810; Wed, 18
 Jan 2023 07:14:52 -0800 (PST)
MIME-Version: 1.0
References: <20230117181533.2350335-1-neelx@redhat.com> <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
In-Reply-To: <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
From:   Daniel Vacek <neelx@redhat.com>
Date:   Wed, 18 Jan 2023 16:14:15 +0100
Message-ID: <CACjP9X-hKf8g2UqitV8_G7WQW7u6Js5EsCNutsAMA4WD7YYSwA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        Siddaraju <siddaraju.dh@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 7:47 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> On 1/17/2023 10:15 AM, Daniel Vacek wrote:
> > When the link goes down the ice_ptp_tx_tstamp_work() may loop forever trying
> > to process the packets. In this case it makes sense to just drop them.
> >
>
> Hi,
>
> Do you have some more details on what situation caused this state? Or is
> this just based on code review?
>
> It won't loop forever because if link is down for more than 2 seconds
> we'll discard the old timestamps which we assume are not going to arrive.

Oh, my bad. I should have improved the commit message. This
comes from RHEL 8.4 where we do not have commit 0dd9286263923
("ice: handle discarding old Tx requests in ice_ptp_tx_tstamp")
yet.

Though, I still consider 2 seconds being 'forever like'.

What really happened is that after the link went down, the
kthread worker 'ice-ptp-0000:10' being a high prio RT class
task kept looping on CPU 33 for almost three minutes starving
other tasks with lower priority. This resulted in RCU stall
and finally in panic due to hung tasks.

The machine is using the E810 NIC.

> [1193024.082447] ice 0000:10:00.1 ens1f1: NIC Link is Down
> [1193024.087861] iavf 0000:10:09.1 net1: NIC Link is Down
> [1193024.093077] iavf 0000:10:09.2 llsm1: NIC Link is Down
> [1193024.099324] iavf 0000:10:09.3 llsm1: NIC Link is Down
> [1193060.630500] ice 0000:10:00.2 ens1f2: NIC Link is up 25 Gbps Full Duplex, Requested FEC: RS-FEC, Negotiated FEC: RS-FEC, Autoneg Advertised: Off, Autoneg Negotiated: False, Flow Contr>
> [1193060.647921] iavf 0000:10:11.1 llsm2: NIC Link is Up Speed is 25 Gbps Full Duplex
> [1193060.655575] iavf 0000:10:11.2 net2: NIC Link is Up Speed is 25 Gbps Full Duplex
> [1193060.663140] iavf 0000:10:11.3 llsm2: NIC Link is Up Speed is 25 Gbps Full Duplex
> [1193084.383798] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [1193084.383799] rcu:   Tasks blocked on level-1 rcu_node (CPUs 32-47): P183189
> [1193084.383804]        (detected by 0, t=60002 jiffies, g=379331397, q=294595)
> [1193084.383807] runc            R  running task        0 183189 183175 0x00084080
> [1193088.721408] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P161097 P183189 } 63616 jiffies s: 1074129 root: 0x4/.
> [1193089.074856] rcu: blocking rcu_node structures: l=1:32-47:0x0/T
>
> [1193199.313106] INFO: task xfsaild/sda4:1428 blocked for more than 120 seconds.
>
> [1193201.399021] NMI backtrace for cpu 33
> [1193201.399021] CPU: 33 PID: 1354 Comm: ice-ptp-0000:10 Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-305.49.1.rt7.121.el8_4.x86_64 #1
>
> [1193201.399050] Kernel panic - not syncing: hung_task: blocked tasks
> [1193201.399052] CPU: 63 PID: 559 Comm: khungtaskd Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-305.49.1.rt7.121.el8_4.x86_64 #1

> crash> bc 33
> PID: 1354     TASK: ff48df6f2c5c8000  CPU: 33   COMMAND: "ice-ptp-0000:10"
>  #0 [fffffe000069ce38] crash_nmi_callback+0x33 at ffffffffb664cb63
>  #1 [fffffe000069ce40] nmi_handle+0x5b at ffffffffb661c68b
>  #2 [fffffe000069ce98] default_do_nmi+0x72 at ffffffffb6f4a562
>  #3 [fffffe000069cec0] do_nmi+0x18d at ffffffffb661cd1d
>  #4 [fffffe000069cef0] end_repeat_nmi+0x16 at ffffffffb7001544
>     [exception RIP: delay_tsc+0x6d]
>     RIP: ffffffffb6f4794d  RSP: ff7daf7a4aa2fd48  RFLAGS: 00000246
>     RAX: 000000008cf66cff  RBX: 0006582e8cf66caf  RCX: 0000000000000000
>     RDX: 000000000006582e  RSI: ffffffffb76eefe3  RDI: ffffffffb76d1b60
>     RBP: 0006582e8cf5ef89   R8: 000000000000000c   R9: 0000000000000000
>     R10: 0000000000000000  R11: 0000000000000000  R12: 00000000000249f2
>     R13: 0000000000000021  R14: ff48df63ec9aa3e0  R15: ff48df57541d0300
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <NMI exception stack> ---
>  #5 [ff7daf7a4aa2fd48] delay_tsc+0x6d at ffffffffb6f4794d
>  ## [  endcall jmp 68] __const_udelay+0x37 at ffffffffb6f477f7
>  #6 [ff7daf7a4aa2fd68] ice_sq_send_cmd+0x356 at ffffffffc0612ee6 [ice]
>  ## [  inlined     c0] ice_sbq_send_cmd at drivers/net/ethernet/intel/ice/ice_common.c:1407
>  #7 [ff7daf7a4aa2fdc0] ice_sbq_rw_reg+0xc4 at ffffffffc06147e4 [ice]
>  #8 [ff7daf7a4aa2fe18] ice_read_phy_reg_e810+0x4d at ffffffffc0655b0d [ice]
>  ## [  inlined     50] ice_read_phy_tstamp_e810 at drivers/net/ethernet/intel/ice/ice_ptp_hw.c:2608
>  #9 [ff7daf7a4aa2fe50] ice_read_phy_tstamp+0x5a at ffffffffc06584ca [ice]
>
> #10 [ff7daf7a4aa2fe90] ice_ptp_tx_tstamp_work+0x95 at ffffffffc0654185 [ice]
> #11 [ff7daf7a4aa2fee0] kthread_worker_fn+0xab at ffffffffb6701c4b
> #12 [ff7daf7a4aa2ff10] kthread+0x15d at ffffffffb6701b7d
>
> crash> delay_fn
> delay_fn = (void (*)(u64)) 0xffffffffb6f478e0 <delay_tsc>
>
> crash> bc 33 | grep -o 'R[BDA1][PX2]: 0[^ ]*'
> RAX: 000000008cf66cff
> RBX: 0006582e8cf66caf
> RDX: 000000000006582e
> RBP: 0006582e8cf5ef89
> R12: 00000000000249f2
>
>         249f2 r12     cycles (150002)
> 6582e8cf5ef89 rbp     bclock
> 6582e8cf66cff rdx:rax now
> 6582e8cf66caf rbx     last
>
>  962 ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
> --
>  965 {
> --
> 1063         do {
> 1064                 if (ice_sq_done(hw, cq))
> 1065                         break;
> 1066
> 1067                 udelay(ICE_CTL_Q_SQ_CMD_USEC);
> 1068                 total_delay++;
> 1069         } while (total_delay < cq->sq_cmd_timeout);
>
>  19 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
>  20 #define udelay(n)                                                       \
> --
>  26                                 __const_udelay((n) * 0x10c7ul);         \
>
> crash> pd loops_per_jiffy
> loops_per_jiffy = 1500000
>
> #define ICE_CTL_Q_SQ_CMD_USEC           100   /* Check every 100usec */
>
> crash> pd (100*0x10c7*4*250*loops_per_jiffy>>32)+1
> 150002
>
> crash> p 100*0x10c7ul
> 0x68dbc
>
> crash> dis ice_sq_send_cmd+0x346 13
> 0xffffffffc0612ed6 <ice_sq_send_cmd+0x346>: jmp    0xffffffffc0612eef <ice_sq_send_cmd+0x35f>
>
> 0xffffffffc0612ed8 <ice_sq_send_cmd+0x348>: mov    $0x68dbc,%edi
> 0xffffffffc0612edd <ice_sq_send_cmd+0x34d>: add    $0x1,%r13d
> 0xffffffffc0612ee1 <ice_sq_send_cmd+0x351>: call   0xffffffffb6f477c0 <__const_udelay>
> 0xffffffffc0612ee6 <ice_sq_send_cmd+0x356>: cmp    %r13d,0xc8(%rbp)
> 0xffffffffc0612eed <ice_sq_send_cmd+0x35d>: jbe    0xffffffffc0612f05 <ice_sq_send_cmd+0x375>
>
> 0xffffffffc0612eef <ice_sq_send_cmd+0x35f>: mov    0xa0(%rbp),%eax
> 0xffffffffc0612ef5 <ice_sq_send_cmd+0x365>: add    (%rbx),%rax
> 0xffffffffc0612ef8 <ice_sq_send_cmd+0x368>: mov    (%rax),%edx
> 0xffffffffc0612efa <ice_sq_send_cmd+0x36a>: movzwl 0x9a(%rbp),%eax
> 0xffffffffc0612f01 <ice_sq_send_cmd+0x371>: cmp    %eax,%edx
> 0xffffffffc0612f03 <ice_sq_send_cmd+0x373>: jne    0xffffffffc0612ed8 <ice_sq_send_cmd+0x348>
>
> 0xffffffffc0612f05 <ice_sq_send_cmd+0x375>: mov    0xa0(%rbp),%eax
>
> crash> dis delay_tsc 2
> 0xffffffffb6f478e0 <delay_tsc>: nopl   0x0(%rax,%rax,1) [FTRACE NOP]
> 0xffffffffb6f478e5 <delay_tsc+0x5>: push   %r13
>
> crash> rx ff7daf7a4aa2fd60
> ff7daf7a4aa2fd60:  0000000000000001    // total_delay

It's the first time the loop in function ice_sq_send_cmd() is being iterated.
The ice_sq_send_cmd() has to be called all over again.

> crash> dis ice_sq_send_cmd+0x2d
> 0xffffffffc0612bbd <ice_sq_send_cmd+0x2d>: mov    %rsi,%rbp
>
> crash> dis delay_tsc 6
> 0xffffffffb6f478e0 <delay_tsc>: nopl   0x0(%rax,%rax,1) [FTRACE NOP]
> 0xffffffffb6f478e5 <delay_tsc+0x5>: push   %r13
> 0xffffffffb6f478e7 <delay_tsc+0x7>: push   %r12
> 0xffffffffb6f478e9 <delay_tsc+0x9>: mov    %rdi,%r12
> 0xffffffffb6f478ec <delay_tsc+0xc>: mov    $0x1,%edi
> 0xffffffffb6f478f1 <delay_tsc+0x11>: push   %rbp
>
> crash> rx ff7daf7a4aa2fd50
> ff7daf7a4aa2fd50:  ff48df6f05dd6730
>
> crash> ice_ctl_q_info.sq_cmd_timeout,sq.head,sq.next_to_use ff48df6f05dd6730
>   sq_cmd_timeout = 0x2710 = 10000,
>   sq.head = 0x80300,
>   sq.next_to_use = 0x20,


> crash> runqc 33
> CPU 33 RUNQUEUE: ff48df6f3f86c380
>   CURRENT: PID: 1354     TASK: ff48df6f2c5c8000  COMMAND: "ice-ptp-0000:10"
>   RT PRIO_ARRAY: ff48df6f3f86c5c0
>      [ 89] PID: 1354     TASK: ff48df6f2c5c8000  COMMAND: "ice-ptp-0000:10"
>      [ 98] PID: 161097   TASK: ff48df634a111ec0  COMMAND: "handler111"
>   CFS RB_ROOT: ff48df6f3f86c430
>      [100] PID: 583      TASK: ff48df6f37845c40  COMMAND: "kworker/33:1H"
>      [120] PID: 4113728  TASK: ff48df5055db9ec0  COMMAND: "kworker/33:6"
>      [120] PID: 183189   TASK: ff48df5d24aa8000  COMMAND: "runc"
>
> crash> ps -m 1354 161097 583 4113728 183189
> [ 0 00:02:56.990] [RU]  PID: 1354     TASK: ff48df6f2c5c8000  CPU: 33   COMMAND: "ice-ptp-0000:10"
> [ 0 00:02:56.990] [RU]  PID: 161097   TASK: ff48df634a111ec0  CPU: 33   COMMAND: "handler111"
> [ 0 00:02:56.991] [RU]  PID: 4113728  TASK: ff48df5055db9ec0  CPU: 33   COMMAND: "kworker/33:6"
> [ 0 00:02:57.015] [RU]  PID: 183189   TASK: ff48df5d24aa8000  CPU: 33   COMMAND: "runc"
> [ 0 00:02:57.030] [RU]  PID: 583      TASK: ff48df6f37845c40  CPU: 33   COMMAND: "kworker/33:1H"

These runnable tasks have lower prio and hence they are being starved.

> crash> ps -mC33 | head -13
> CPU: 33
> [ 0 00:02:56.990] [RU]  PID: 1354     TASK: ff48df6f2c5c8000  CPU: 33   COMMAND: "ice-ptp-0000:10"
> [ 0 00:02:56.990] [RU]  PID: 161097   TASK: ff48df634a111ec0  CPU: 33   COMMAND: "handler111"
> [ 0 00:02:56.991] [RU]  PID: 4113728  TASK: ff48df5055db9ec0  CPU: 33   COMMAND: "kworker/33:6"
> [ 0 00:02:56.991] [IN]  PID: 278      TASK: ff48df504fd08000  CPU: 33   COMMAND: "ksoftirqd/33"
> [ 0 00:02:57.014] [IN]  PID: 277      TASK: ff48df504fcebd80  CPU: 33   COMMAND: "rcuc/33"
> [ 0 00:02:57.015] [RU]  PID: 183189   TASK: ff48df5d24aa8000  CPU: 33   COMMAND: "runc"
> [ 0 00:02:57.016] [IN]  PID: 146      TASK: ff48df5040268000  CPU: 33   COMMAND: "rcuop/16"
> [ 0 00:02:57.020] [IN]  PID: 276      TASK: ff48df504fce8000  CPU: 33   COMMAND: "migration/33"
> [ 0 00:02:57.024] [IN]  PID: 413      TASK: ff48df504f971ec0  CPU: 33   COMMAND: "rcuop/49"
> [ 0 00:02:57.024] [IN]  PID: 494      TASK: ff48df504f43bd80  CPU: 33   COMMAND: "rcuop/59"
> [ 0 00:02:57.029] [UN]  PID: 183233   TASK: ff48df5193618000  CPU: 33   COMMAND: "exe"
> [ 0 00:02:57.030] [RU]  PID: 583      TASK: ff48df6f37845c40  CPU: 33   COMMAND: "kworker/33:1H"

> crash> ice_pf.pdev,int_name ff48df6f05dd4180
>   pdev = 0xff48df6f37fe6000,
>   int_name = "ice-0000:10:00.1:misc",
>
> crash> ice_hw.mac_type ff48df6f05dd4dc0
>   mac_type = ICE_MAC_E810,

> crash> ice_ptp_tx.work.func,len,in_use,quad,quad_offset ff48df6f05dd44e0
>   work.func = 0xffffffffc06540f0 <ice_ptp_tx_tstamp_work>,
>   len = 0x40,
>   in_use = 0xff48df63d0354cc0,
>   quad = 0x1,
>   quad_offset = 0x0,
>
> crash> rx 0xff48df63d0354cc0
> ff48df63d0354cc0:  0000000000000001

> crash> ice_ptp_tx.tstamps ff48df6f05dd44e0
>   tstamps = 0xff48df62d6e69800,
>
> crash> ice_tx_tstamp.start,cached_tstamp,skb 0xff48df62d6e69800
>   start = 0x14717935c,
>   cached_tstamp = 0xbe9c63f31b
>   skb = 0xff48df5e20552f00,
>
> crash> pd jiffies-0x14717935c
> 177354

The packet is waiting for almost three minutes. The mentioned
commit 0dd9286263923 would definitely skip it and clear it's
bit in the tx->in_use mask. But still only two seconds too late
which needs to be addressed. And since the link went down
I guess just dropping the packets is a reasonable approach.

Checking the latest upstream code in v6.2-rc4 I *guess* this
can still happen as described above. Just not looping forever
but rather only for 2 seconds. But doing nothing for two
seconds is just as bad really. Hence the patch I'm suggesting.

> The trouble is that if a timestamp *does* arrive late, we need to ensure
> that we never assign the captured time to the wrong packet, and that for
> E822 devices we always read the correct number of timestamps (otherwise
> we can get the logic for timestamp interrupt generation broken).
>
> Consider for example this flow for e810:
>
> 1) a tx packet with a timestamp request is scheduled to hw
> 2) the packet begins being transmitted
> 3) link goes down
> 4) interrupt triggers, ice_ptp_tx_tstamp is run
> 5) link is down, so we skip reading this timestamp. Since we don't read
> the timestamp, we just discard the skb and we don't update the cached tx
> timestamp value
> 6) link goes up
> 7) 2 tx packets with a timestamp request are sent and one of them is on
> the same index as the packet in (1)
> 8) the other tx packet completes and we get an interrupt
> 9) the loop reads both timestamps. Since the tx packet in slot (1)
> doesn't match its cached value it looks "new" so the function reports
> the old timestamp to the wrong packet.

I don't really fully understand the HW nor the driver to be honest.
For sure I can see it kept looping as the work is being re-queued
due to tx->in_use bitmap not being cleared. And that can only
happen when ice_read_phy_tstamp() returns with error or the
returned &raw_tstamp is not valid or it matches the cached value
(considering our version of ice_ptp_tx_tstamp() looks like the
one in v5.15 stable tree). And that said the v5.15 stable needs
backport of this fix as well I guess.

> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/net/ethernet/intel/ice/ice_ptp.c?h=v5.15.88#n1170

> Consider this flow for e822:
>
> 1) 2 tx packets with a timestamp request are scheduled to hw
> 2) the packets begin being transmitted
> 3) link goes down
> 4) an interrupt for the Tx timestamp is triggered, but we don't read the
> timestamps because we have link down and we skipped the ts_read.
> 5) the internal e822 hardware counter is not decremented due to no reads
> 6) no more timestamp interrupts will be triggered by hardware until we
> read the appropriate number of timestamps
>
> I am not sure if link going up will properly reset and re-initialize the
> Tx timestamp block but I suspect it does not. @Karol, @Siddaraju,
> @Michal, do you recall more details on this?
>
> I understand the desire to avoid polling when unnecessary, but I am
> worried because the hardware and firmware interactions here are pretty
> complex and its easy to get this wrong. (see: all of the previous
> patches and bug fixes we've been working on... we got this wrong a LOT
> already...)

I see. Here my favorite quote applies: "Everybody falls the first time."

I totally understand and I cannot imagine developing and maintaining this
without a solid test suite. On the other hand, some things (like especially
races) could be tricky to reproduce.

> Without a more concrete explanation of what this fixes I'm worried about
> this change :(

Hopefully I already managed to shed a bit more light here. Again, I'm sorry
about the brief commit message.

> At a minimum I think I would only set drop_ts but not not goto skip_ts_read.

IIUC, that would still fail to clear the tx->in_use bit in case
ice_read_phy_tstamp()
returns with error. It would only work for the other case where no error is
returned but rather the returned &raw_tstamp is invalid. I'll send a v2 of
this fix trying to address the goto concern.

> crash> ice_sbq_msg_input ff7daf7a4aa2fe2c
> struct ice_sbq_msg_input {
>   dest_dev = 0x2,
>   opcode = 0x0,
>   msg_addr_low = 0x1000,
>   msg_addr_high = 0x309,
>   data = 0x0
> }
> crash> ice_sbq_msg_req ff7daf7a4aa2fdc8
> struct ice_sbq_msg_req {
>   dest_dev = 0x2,
>   src_dev = 0x0,
>   opcode = 0x0,
>   flags = 0x40,
>   sbe_fbe = 0xf,
>   func_id = 0x0,
>   msg_addr_low = 0x1000,
>   msg_addr_high = 0x309,
>   data = 0x0
> }
> crash> ice_sbq_cmd_desc ff7daf7a4aa2fdd8
> struct ice_sbq_cmd_desc {
>   flags = 0x1400,
>   opcode = 0xc00,
>   datalen = 0x0,
>   cmd_retval = 0x0,
>   cookie_high = 0x0,
>   cookie_low = 0x0,
>   param0 = {
>     cmd_len = 0xc,
>     cmpl_len = 0xc
>   },
>   reserved = "",
>   addr_high = 0x0,
>   addr_low = 0x0
> }

I see commit 1229b33973c7b ("ice: Add low latency Tx timestamp read") got
rid of that kthread_work in favor of threaded irq. But the
ice_misc_intr_thread_fn()
keeps waking itself in the same manner as the work did keep re-queuing itself.
So the loop still needs to be broken (i.e. the tx->in_use bitmap cleared). Even
for v6.2-rc4.

> That way if we happen to have a ready timestamp (for E822) we'll still
> read it and avoid the miscounting from not reading a completed timestamp.
>
> This also ensures that on e810 the cached timestamp value is updated and
> that we avoid the other situation.
>
> I'd still prefer if you have a bug report or more details on the failure
> case. I believe even if we poll it should be no more than 2 seconds for
> an old timestamp that never got sent to be discarded.

Unfortunately I only have this one report with a dump from customer's testing.
The uptime was almost 14 days, so I'm not sure how easy it is to reproduce.

Again, hopefully the above covers enough details. I'm happy to share more
if I missed some. But looping in a softirq (or worker thread) for two seconds
is not really acceptable. That's just a wrong design. Right?

--nX

> > Signed-off-by: Daniel Vacek <neelx@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_ptp.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> > index d63161d73eb16..c313177ba6676 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> > @@ -680,6 +680,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
> >       struct ice_pf *pf;
> >       struct ice_hw *hw;
> >       u64 tstamp_ready;
> > +     bool link_up;
> >       int err;
> >       u8 idx;
> >
> > @@ -695,6 +696,8 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
> >       if (err)
> >               return false;
> >
> > +     link_up = hw->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP;
> > +
> >       for_each_set_bit(idx, tx->in_use, tx->len) {
> >               struct skb_shared_hwtstamps shhwtstamps = {};
> >               u8 phy_idx = idx + tx->offset;
> > @@ -702,6 +705,12 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
> >               bool drop_ts = false;
> >               struct sk_buff *skb;
> >
> > +             /* Drop packets if the link went down */
> > +             if (!link_up) {
> > +                     drop_ts = true;
> > +                     goto skip_ts_read;
> > +             }
> > +
> >               /* Drop packets which have waited for more than 2 seconds */
> >               if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
> >                       drop_ts = true;
>

