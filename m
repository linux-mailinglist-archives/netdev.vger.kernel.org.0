Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC59758249E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiG0Kkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiG0Kkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEF132AEC
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658918432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=82nv2SFGdqlZfGEwVZ1wVPV33YMz3X0zqGrGaNF2BiU=;
        b=axAr28WRdTe+f9Phx52dzqfDUoDYYbIxOCgwnyrKUrB1A39DrcIma++MoUmK0GkoZyZ73N
        CGGZJvOHfN3/XjLTS2mTXgvY95BgMPBNCHomtp6Xlpp+LHr0HVj+V5JdR9G3fseCe+HCxf
        zvefjJIrf3vOZblB9ktm/OC4smWmCzI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-ta9eS8w7OKCH8mso2QweGQ-1; Wed, 27 Jul 2022 06:40:32 -0400
X-MC-Unique: ta9eS8w7OKCH8mso2QweGQ-1
Received: by mail-lf1-f70.google.com with SMTP id 9-20020ac25f09000000b0048aae4b6e40so1107508lfq.20
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=82nv2SFGdqlZfGEwVZ1wVPV33YMz3X0zqGrGaNF2BiU=;
        b=5ceNHVu3Kw3JdBhFV3QTI8e8TXf3CGvL3LpNyAzT8DB27dRG5wMN0lIcmlSFhiZY18
         klsnMKlgqEY1SiFTapr0fOqw0l2ihY9Yv7JEcUidLAZ9ypP9x7Zigyfi2lLmDZThpXmH
         xAGg7DquCIY+ZnJvJbkDGCV8glIO00R4zKjI8PX8rxomjUBhxiotH67CV+2eh436wkA5
         mB54yoVn36wtDyrxN3+6W5rHdxiSQecGB74tkZyiP1Rmv5dtGLBsK++rJ2LZO2A5DtNF
         sTS/qR8Z3bwNNUSjGj+3bnyCs59Dj5Hqecdt2o2EL0zVa/u7nrxkIRadha4slLqlQOOj
         shiQ==
X-Gm-Message-State: AJIora9kLeqIDp8ngp7YV07re733dDmB5q7Tx2Qa8B+0YsL1mBw0t4Lz
        K+gko4EFRe2392+w2APqXA/qzcpdvcywlGFc2Zdqee3Y3L/j2WOE85IcZtXLK6HKoZBWJorrKJY
        ESJ+ByMmjuMiRHcIq6T5V/0fS4Dc6mxLr
X-Received: by 2002:a05:6512:39c2:b0:489:dca6:a23b with SMTP id k2-20020a05651239c200b00489dca6a23bmr8700902lfu.633.1658918429682;
        Wed, 27 Jul 2022 03:40:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t8cpnuh34xtzOoYJZ0wWBPfGNdrm/i4++Be0JQ2rxv0YhEPB6aZBoRjNsNYjyzSbkaeX9vyykt1GzDFP0ELYc=
X-Received: by 2002:a05:6512:39c2:b0:489:dca6:a23b with SMTP id
 k2-20020a05651239c200b00489dca6a23bmr8700889lfu.633.1658918429188; Wed, 27
 Jul 2022 03:40:29 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Wed, 27 Jul 2022 12:40:18 +0200
Message-ID: <CA+QYu4qw6LecuxwAESLBvzEpj9Uv4LobX0rofDgVk_3YHjY7Fw@mail.gmail.com>
Subject: [aarch64] pc : ftrace_set_filter_ip+0x24/0xa0 - lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Recently we started to hit the following panic when testing the
net-next tree on aarch64. The first commit that we hit this is
"b3fce974d423".

[   44.517109] audit: type=1334 audit(1658859870.268:59): prog-id=19 op=LOAD
[   44.622031] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000010
[   44.624321] Mem abort info:
[   44.625049]   ESR = 0x0000000096000004
[   44.625935]   EC = 0x25: DABT (current EL), IL = 32 bits
[   44.627182]   SET = 0, FnV = 0
[   44.627930]   EA = 0, S1PTW = 0
[   44.628684]   FSC = 0x04: level 0 translation fault
[   44.629788] Data abort info:
[   44.630474]   ISV = 0, ISS = 0x00000004
[   44.631362]   CM = 0, WnR = 0
[   44.632041] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100ab5000
[   44.633494] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
[   44.635202] Internal error: Oops: 96000004 [#1] SMP
[   44.636452] Modules linked in: xfs crct10dif_ce ghash_ce virtio_blk
virtio_console virtio_mmio qemu_fw_cfg
[   44.638713] CPU: 2 PID: 1 Comm: systemd Not tainted 5.19.0-rc7 #1
[   44.640164] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[   44.641799] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   44.643404] pc : ftrace_set_filter_ip+0x24/0xa0
[   44.644659] lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
[   44.646118] sp : ffff80000803b9f0
[   44.646950] x29: ffff80000803b9f0 x28: ffff0b5d80364400 x27: ffff80000803bb48
[   44.648721] x26: ffff8000085ad000 x25: ffff0b5d809d2400 x24: 0000000000000000
[   44.650493] x23: 00000000ffffffed x22: ffff0b5dd7ea0900 x21: 0000000000000000
[   44.652279] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
[   44.654067] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
[   44.655787] x14: ffff0b5d809d2498 x13: ffff0b5d809d2432 x12: 0000000005f5e100
[   44.657535] x11: abcc77118461cefd x10: 000000000000005f x9 : ffffa7219cb5b190
[   44.659254] x8 : ffffa7219c8e0000 x7 : 0000000000000000 x6 : ffffa7219db075e0
[   44.661066] x5 : ffffa7219d3130e0 x4 : ffffa7219cab9da0 x3 : 0000000000000000
[   44.662837] x2 : 0000000000000000 x1 : ffffa7219cb7a5c0 x0 : 0000000000000000
[   44.664675] Call trace:
[   44.665274]  ftrace_set_filter_ip+0x24/0xa0
[   44.666327]  bpf_trampoline_update.constprop.0+0x428/0x4a0
[   44.667696]  __bpf_trampoline_link_prog+0xcc/0x1c0
[   44.668834]  bpf_trampoline_link_prog+0x40/0x64
[   44.669919]  bpf_tracing_prog_attach+0x120/0x490
[   44.671011]  link_create+0xe0/0x2b0
[   44.671869]  __sys_bpf+0x484/0xd30
[   44.672706]  __arm64_sys_bpf+0x30/0x40
[   44.673678]  invoke_syscall+0x78/0x100
[   44.674623]  el0_svc_common.constprop.0+0x4c/0xf4
[   44.675783]  do_el0_svc+0x38/0x4c
[   44.676624]  el0_svc+0x34/0x100
[   44.677429]  el0t_64_sync_handler+0x11c/0x150
[   44.678532]  el0t_64_sync+0x190/0x194
[   44.679439] Code: 2a0203f4 f90013f5 2a0303f5 f9001fe1 (f9400800)
[   44.680959] ---[ end trace 0000000000000000 ]---
[   44.682111] Kernel panic - not syncing: Oops: Fatal exception
[   44.683488] SMP: stopping secondary CPUs
[   44.684551] Kernel Offset: 0x2721948e0000 from 0xffff800008000000
[   44.686095] PHYS_OFFSET: 0xfffff4a380000000
[   44.687144] CPU features: 0x010,00022811,19001080
[   44.688308] Memory Limit: none
[   44.689082] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

more logs:
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/07/26/redhat:597047279/build_aarch64_redhat:597047279_aarch64/tests/1/results_0001/console.log/console.log

https://datawarehouse.cki-project.org/kcidb/tests/4529120

CKI issue tracker: https://datawarehouse.cki-project.org/issue/1434

Thanks,
Bruno Goncalves

