Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5642C1DA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhJMN73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhJMN72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:59:28 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FAC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 06:57:25 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r134so3058967iod.11
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 06:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zH9iLVZeYc3T/1I0i4gfF2z69XUZS+8cTQ9a+77tSlA=;
        b=W6IP04V7/XemvrA3m4cQhGGZeBRhMbWCY8Aos8bg0ay35+YB/fsdJAK5IhukXo4FT+
         2YkUX8v/fMPQA5Ad3nH5KszGtBktHXAx7EGMvZVkP20wz/A78XnM5liLZA0jdhSneIrK
         kQo6BwQwSWRIq/a9Z845kXMs0I8WmU6itFG/PrfqC8/78Pq5NfnmO/p/XnHViyxGkUwu
         nK+s3oNmiQh28dBV4c0NOKskOhS/liAviPec+9urqi0v0L6sdIwkKgp2obeFHqtfei/l
         B9IOBrr+Kju7S3cSPBwfd2odcwKPbEuw8bhZn2dcdbVqjG2wyTYtSRbhKdox6TT4w6gW
         t8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zH9iLVZeYc3T/1I0i4gfF2z69XUZS+8cTQ9a+77tSlA=;
        b=4CeG35pvzlFwd6m53uvFpcdZ45hJeHt0mQ5uNYo+s4ksbwZjqck27VQFFrM8MgjgMr
         JMW+hh82+aLerzY2BIgWJoN+e39lGEQpO1NDHnBG6BIQV5vt7HKZT0zaJ1hL8kbr4pXU
         IkJqf9rXmcvuu02gLreTpm/nD7ApQenYq9EvtxsBuXCLI+wbKWbvYffqnUhawLVIBflo
         wCaacsBTkFHl7H0QgKJ1Lb9YjTciHxuBAYq1QqxChHIE93Y8DfvZLqCMJXc6izNpABTD
         76Erzgoz0RP/kg6Q1ZvRQN0KAKMDRxNUSvW22K2thAGqOz4xdZ3ZKxW/kT3ZoFDLE+u7
         DqKA==
X-Gm-Message-State: AOAM532Wap1TGONOZfWaeeUdcIengtEypLT2hDd8akZKHF4zV9bWLHzI
        LLneh0wyb3kbUmB57rD6qMg=
X-Google-Smtp-Source: ABdhPJwW4EvHHRL/0uwUUvoMM8INp2X8/ZXq/nAntgg9pzps2QvP8KH8by/5wbOCDqKVtegG2RM7oQ==
X-Received: by 2002:a6b:cd8b:: with SMTP id d133mr31037888iog.88.1634133444754;
        Wed, 13 Oct 2021 06:57:24 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h7sm6978213ils.0.2021.10.13.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:57:24 -0700 (PDT)
Date:   Wed, 13 Oct 2021 06:57:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jun Miao <jun.miao@windriver.com>, john.fastabend@gmail.com,
        cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org
Message-ID: <6166e5bcda91c_48c5d20882@john-XPS-13-9370.notmuch>
In-Reply-To: <f733db94-c75f-2091-4bae-c99daa5a555d@windriver.com>
References: <f733db94-c75f-2091-4bae-c99daa5a555d@windriver.com>
Subject: RE: Bug Report:bpf, sockmap: On cleanup we additionally need to
 remove cached skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jun Miao wrote:
> Hi,
> =

>  =C2=A0 From our netperf stress test with your patch, the Call trace st=
ill =

> can reproduce, as follow:

Hi Jun,

Is this testing with sockmap and BPF? If not I can't see how the above
patch is the correct bisection. That patch touches internals of skmsg
handling in a specific backlog case which would only be used in BPF
use case.

Thanks,
John


> =

> *Test Log:*
> =

> [ 6405.990626] Writes:  Total: 12095025292  Max/Min: 379145540/23752721=
2   Fail: 0
> [ 6436.970251] ------------[ cut here ]------------
> [ 6436.975016] WARNING: CPU: 0 PID: 42336 at net/core/stream.c:207 sk_s=
tream_kill_queues+0x11a/0x140
> [ 6436.984044] Modules linked in: i10nm_edac iTCO_wdt intel_pmc_bxt iTC=
O_vendor_support intel_rapl_msr watchdog intel_rapl_common intel_th_gth x=
86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crct10dif_=
common aesni_intel crypto_simd cryptd qat_c4xxx(O) intel_qat(O) dh_generi=
c uio intel_spi_pci intel_spi intel_th_pci ice i2c_i801 spi_nor intel_th =
i2c_smbus i2c_ismt wmi acpi_cpufreq sch_fq_codel openvswitch nsh nf_connc=
ount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 fuse [last unloade=
d: i10nm_edac]
> [ 6437.029831] CPU: 0 PID: 42336 Comm: netperf Tainted: G        W  O  =
    5.15.0-rc3 #1
> [ 6437.039374] Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE=
, BIOS JBVLCRB2.86B.0014.P67.2103111848 03/11/2021
> [ 6437.050212] RIP: 0010:sk_stream_kill_queues+0x11a/0x140
> [ 6437.055581] Code: 93 90 02 00 00 85 d2 75 21 8b 83 48 02 00 00 85 c0=
 75 23 5b 41 5c 5d c3 48 89 df e8 10 d1 fe ff 8b 93 90 02 00 00 85 d2 74 =
df <0f> 0b 8b 83 48 02 00 00 85 c0 74 dd 0f 0b 5b 41 5c 5d c3 0f 0b eb
> [ 6437.074492] RSP: 0018:ffffac32425d7d90 EFLAGS: 00010282
> [ 6437.079861] RAX: ffffffff9931cfc0 RBX: ffff9cd4eda58d40 RCX: 0000000=
000000000
> [ 6437.087139] RDX: 00000000fffffb80 RSI: 0000000000000480 RDI: ffff9cd=
4eda58ea8
> [ 6437.094424] RBP: ffffac32425d7da0 R08: 0000000000000000 R09: 0000000=
000000000
> [ 6437.101705] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9cd=
4eda58ea8
> [ 6437.108986] R13: ffff9cd4eda58dc8 R14: 0000000000000000 R15: ffff9cd=
57079d230
> [ 6437.116263] FS:  00007fe132d96740(0000) GS:ffff9ce3ba200000(0000) kn=
lGS:0000000000000000
> [ 6437.124498] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6437.130385] CR2: 0000556041d81128 CR3: 0000000165aa4000 CR4: 0000000=
000350ef0
> [ 6437.137668] Call Trace:
> [ 6437.140259]  inet_csk_destroy_sock+0x64/0x150
> [ 6437.144762]  __tcp_close+0x3b2/0x4e0
> [ 6437.148484]  tcp_close+0x25/0x80
> [ 6437.151858]  inet_release+0x4d/0x90
> [ 6437.155494]  __sock_release+0x3f/0xb0
> [ 6437.159305]  sock_close+0x18/0x20
> [ 6437.162765]  __fput+0xb0/0x280
> [ 6437.165967]  ____fput+0xe/0x10
> [ 6437.169167]  task_work_run+0x61/0xb0
> [ 6437.172889]  exit_to_user_mode_loop+0x114/0x120
> [ 6437.177568]  exit_to_user_mode_prepare+0xe9/0x150
> [ 6437.182421]  syscall_exit_to_user_mode+0x1e/0x60
> [ 6437.187183]  do_syscall_64+0x50/0x90
> [ 6437.190904]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 6437.196097] RIP: 0033:0x7fe132e950c7
> [ 6437.199820] Code: b8 ff ff ff ff e9 3e ff ff ff 66 0f 1f 84 00 00 00=
 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f =
05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 33 b1 f8 ff
> [ 6437.218732] RSP: 002b:00007fffc46df2c8 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000003
> [ 6437.226449] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fe=
132e950c7
> [ 6437.233727] RDX: 0000000000000001 RSI: 00007fffc46df2e4 RDI: 0000000=
000000004
> [ 6437.241007] RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000=
000000000
> [ 6437.248286] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000=
000000001
> [ 6437.255565] R13: 0000000000000001 R14: 0000000000000000 R15: 0000559=
ace3650c0
> [ 6437.262847] irq event stamp: 0
> [ 6437.266049] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [ 6437.272463] hardirqs last disabled at (0): [<ffffffff96d134fd>] copy=
_process+0x74d/0x18a0
> [ 6437.280786] softirqs last  enabled at (0): [<ffffffff96d134fd>] copy=
_process+0x74d/0x18a0
> [ 6437.289109] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [ 6437.295524] ---[ end trace 42c5ce4ee9dd57c1 ]---

[...]=
