Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26AF5FC494
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 13:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJLL4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 07:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJLL4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 07:56:11 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C33BBA25E
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:56:08 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b1so20401625lfs.7
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aYIY89oVfV3Cha2m/C5Rzwmm5SoCmP3eO+T8yBTmbq4=;
        b=F0R4zaldS6d5aXR1L7VatOhgCFFjZC/G6zsWmVyVQre2KSUZ979mYjoLHGjdJ8xy3T
         4RTb8ABdPlRwCkrKbAydSPgM8i9VbuJVjx4GNuyD7GMw9p6HqJbT7BpYcbt4sZNmYvp7
         ir/dhkkMUN08bieuSqtCDluRAeoMaJKHGwnNunMbrCtaJpq28TW7jhWfSp1pb4YPLJ/U
         9RROFY4L7Q82oZFBkbubPQobC9URohFP3c/Nbq+U7+KFOwRJEWSHW7BZ2U89L6OpGJqj
         nm4m0ASfsK3aBLGnuWc8HBlhkq7EcbaX9Bd9gwQKrWe6QAmfFrbBwSm49mx7zWmVhimJ
         +tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYIY89oVfV3Cha2m/C5Rzwmm5SoCmP3eO+T8yBTmbq4=;
        b=v0UlToIE/nkIdjVNDGMKxqkkknf98DzUjD0SsFU+P8+s31d0vNQxVt40Nw8QKDfKhq
         DnHQU5L+tRlaJjsELEtnaxKGiUZex8Q62Hrn1bCXE5/813gWgIkFWcfbAEczuYRzJAXD
         Kl43SWPxmsb9eoWKcYssqv93rai4OuLE0mt5QBHxeWZc1yK1o90yNWj8o+BgqzshAIyZ
         mcITLKUudrGq2qNcyCnsDSSJOMkmDUep59hq6DFuFa/wDke1tqqwZcyfYsT2AV/l2qww
         1eB2rGEVSAyt+iUZryb0MBhRV3cSblPFttmgcEGDhI2jC82vv4ri24Auhss4k1h2Ut2U
         IElA==
X-Gm-Message-State: ACrzQf39QN0yhoNvnMGIuOVVju1Ok+5dO/m+NR22DFS+0kX4+9x9bJLL
        yfMS/97sK+NQiI4plZSzA9AjlrQd0RG+ALBfzRFanw==
X-Google-Smtp-Source: AMsMyM77WIsn5veYY1FHU6uEub7t4BL92WdwxonHMHlVmEpwqBGKqWx2glgF8fTR8/zCFqykygFDCmpaXGg4/TG522U=
X-Received: by 2002:ac2:46d9:0:b0:4a2:22e1:4ad1 with SMTP id
 p25-20020ac246d9000000b004a222e14ad1mr9862681lfo.19.1665575766846; Wed, 12
 Oct 2022 04:56:06 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 12 Oct 2022 13:55:55 +0200
Message-ID: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
Subject: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon, hi Saeed,

We have seen crashes during server shutdown on both kernel 5.10 and
kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.

All of the crashes point to

1606                         memcpy(ent->out->first.data,
ent->lay->out, sizeof(ent->lay->out));

I guess, it's kind of use after free for ent buffer. I tried to reprod
by repeatedly reboot the testing servers, but no success  so far.

A sample output from kernel 5.15.32

<30>[ 1246.308327] systemd-shutdown[1]: Rebooting.

<6>[ 1246.308429] kvm: exiting hardware virtualization

<6>[ 1246.602813] megaraid_sas 0000:65:00.0:
megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009

<6>[ 1246.605901] mlx5_core 0000:4b:00.1: Shutdown was called

<6>[ 1246.608371] mlx5_core 0000:4b:00.0: Shutdown was called

<4>[ 1246.608811] general protection fault, probably for non-canonical
address 0xb028ffa964bb3e4b: 0000 [#1] SMP

<4>[ 1246.615211] CPU: 95 PID: 5670 Comm: kworker/u256:6 Tainted: G
       O      5.15.32-pserver
#5.15.32-1+feature+linux+5.15.y+20220405.0441+03895bda~deb11

<4>[ 1246.628483] Hardware name: Dell Inc. PowerEdge R650/0PYXKY, BIOS
1.5.5 02/10/2022

<4>[ 1246.635401] Workqueue: mlx5_cmd_0000:4b:00.0 cmd_work_handler [mlx5_core]

<4>[ 1246.642459] RIP: 0010:mlx5_cmd_comp_handler+0xda/0x490 [mlx5_core]

<4>[ 1246.649707] Code: b0 00 00 00 01 0f 84 9a 02 00 00 4c 89 ff e8
9d e5 ff ff e8 28 86 34 db 49 8b 97 00 01 00 00 49 89 87 20 01 00 00
49 8b 47 10 <48> 8b 72 20 48 8b 7a 28 31 d2 48 89 70 1c 4c 89 fe 48 89
78 24 48

<4>[ 1246.664596] RSP: 0018:ff59e28ca3103db0 EFLAGS: 00010202

<4>[ 1246.672167] RAX: ff25be460afc4580 RBX: ff25be460d196180 RCX:
0000000000000017

<4>[ 1246.679804] RDX: b028ffa964bb3e2b RSI: 000000000003a550 RDI:
000ce7c15700ae52

<4>[ 1246.687528] RBP: ff59e28ca3103e28 R08: 0000000000000001 R09:
ffffffffc0dc5500

<4>[ 1246.695331] R10: ff25be4607793000 R11: ff25be4607793000 R12:
0000000000000000

<4>[ 1246.703167] R13: ff25be460d196180 R14: ff25be460d1962a8 R15:
ff25be4607793000

<4>[ 1246.711051] FS:  0000000000000000(0000)
GS:ff25bec4019c0000(0000) knlGS:0000000000000000

<4>[ 1246.719000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

<4>[ 1246.726844] CR2: 00007f82d8850006 CR3: 000000695760a004 CR4:
0000000000771ee0

<4>[ 1246.734856] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000

<4>[ 1246.742757] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

<4>[ 1246.750573] PKRU: 55555554

<4>[ 1246.758289] Call Trace:

<4>[ 1246.765755]  <TASK>

<4>[ 1246.772997]  ? dump_command+0x159/0x3d0 [mlx5_core]

<4>[ 1246.780267]  cmd_work_handler+0x270/0x5d0 [mlx5_core]

<4>[ 1246.787576]  process_one_work+0x1d6/0x370

<4>[ 1246.794669]  worker_thread+0x4d/0x3d0

<4>[ 1246.801796]  ? rescuer_thread+0x390/0x390

<4>[ 1246.808895]  kthread+0x124/0x150

<4>[ 1246.815957]  ? set_kthread_struct+0x40/0x40

<4>[ 1246.823051]  ret_from_fork+0x1f/0x30

<4>[ 1246.830076]  </TASK>

Is this problem known, maybe already fixed?
I briefly checked the git, don't see anything, could you give me some hint?


Thanks!
Jinpu Wang @ IONOS
