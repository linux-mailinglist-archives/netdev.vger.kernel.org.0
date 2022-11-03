Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC36173AA
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiKCBUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 21:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKCBUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 21:20:03 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8512AE2;
        Wed,  2 Nov 2022 18:20:02 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id g10so532901oif.10;
        Wed, 02 Nov 2022 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbiWrZrL3bsFq0TshCggBu/RtjhGiHSYByzwtFjnSiE=;
        b=DcyBmPIZUNRiTvMQUjmHyYKi8kFgjlx0sykPWhJTwkoFY1aYyOPSPAHI2L5wjcuW+y
         q/Js8Ha1p8l4VaW/J+mY3zE7tN5KWJjlxijddtTsZJSs0/LneiFDyw29HSOvjf8YZUHh
         BkptEVFfaCCLj2J3e2i+rJxyRbQC/6leCQzxc0ix0RK7gecbCPOM9oQXOpCrkJTkgoLC
         n467FjBgj+BStTKX61lZ3RGl7S2bk6zG9vZrXgYrE0VdGK49R/Dx36+GjUW3dheZSGm1
         TA146chhCF1aKp1OduZu25baLG2KstbokIVqZ8iCIKfNsdhvYwDfnSsjtHuVqA5YB+F0
         CDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbiWrZrL3bsFq0TshCggBu/RtjhGiHSYByzwtFjnSiE=;
        b=CJB7l7U8q3Nnxy8paS+wIve/PIAw9SsKiliEIg64cHJk3Zhe18zHBuhkjXXcnfvIJr
         RCrSVfGdg/OZgjR3usa8Trbt+3vvEw1SNlHQmbxDTyJiQAVLXCBurHNM1WhcS8XGf9xa
         dOU/W3XofaXjUuRiWC1nD76bQC0G4EJhQByO0kdKxtoaNFmEiEw0K0vtyxkCaI6sVSVx
         FjL5pKDaF+0a/amFmof59Ru6I6GdnVOCglOMamw853qm0G8RHZaKHrA99Q4cpIyiohWx
         zn/bgiGdVQtXN3z36egtZIkfjMzCsZzfrKnRFSrl5om422vZ7yv1MwYsxPq3JqZS8Wwb
         RWlQ==
X-Gm-Message-State: ACrzQf2NJnc6pUVM8dswlDlDPLe7XvvIkKC+EIaCzH1mfq12TEvJWq7j
        wC2/9dFbQt1WevWsyde4i6xmwbym1NUAfRYzniI=
X-Google-Smtp-Source: AMsMyM4dleC+mEAGp5wzjZ8E5NFOIHM6Qc5RNewymKWUpPivuO1Nv55k0s4kBZJcts0gzQheim2DDzVa3CD7n4nQoGg=
X-Received: by 2002:a05:6808:d53:b0:355:4c55:2384 with SMTP id
 w19-20020a0568080d5300b003554c552384mr23442111oik.190.1667438401365; Wed, 02
 Nov 2022 18:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <7033694f-a4a5-d571-3eec-eec74aaa3e7c@huawei.com>
In-Reply-To: <7033694f-a4a5-d571-3eec-eec74aaa3e7c@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 2 Nov 2022 21:19:36 -0400
Message-ID: <CADvbK_eLkuvpof=jsc0b+2TdMtRAjBmizAdUXsagoZLNHUMgCQ@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in sctp_sched_dequeue_common
To:     Zhen Chen <chenzhen126@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, caowangbao@huawei.com,
        yanan@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 10:29 AM Zhen Chen <chenzhen126@huawei.com> wrote:
>
> Hi,all
>
> We found the following crash when running fuzz tests on stable-5.10.
>
> ------------[ cut here ]------------
> list_del corruption, ffffa035ddf01c18->next is NULL
> WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_valid=
+0x59/0xe0
> CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G         =
  O
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-=
g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
> RIP: 0010:__list_del_entry_valid+0x59/0xe0
> Code: c0 74 5a 4d 8b 00 49 39 f0 75 6a 48 8b 52 08 4c 39 c2 75 79 b8 01 0=
0 00 00 c3 cc cc cc cc 48 c7 c7 68 ae 78 8b e8 d2 3d 4e 00 <0f> 0b 31 c0 c3=
 cc cc cc cc 48 c7 c7 90 ae 78 8b e8 bd 3d 4e 00 0f
> RSP: 0018:ffffaf7d84a57930 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffffa035ddf01c18 RCX: 0000000000000000
> RDX: ffffa035facb0820 RSI: ffffa035faca0410 RDI: ffffa035faca0410
> RBP: ffffa035dddff6f8 R08: 0000000000000000 R09: ffffaf7d84a57770
> R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c18
> R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
> FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f509a3d0ee8 CR3: 000000010f7c2001 CR4: 00000000001706e0
> Call Trace:
>  sctp_sched_dequeue_common+0x17/0x70 [sctp]
>  sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
>  sctp_outq_flush_data+0x85/0x360 [sctp]
>  sctp_outq_uncork+0x77/0xa0 [sctp]
>  sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
>  sctp_side_effects+0x37/0xe0 [sctp]
>  sctp_do_sm+0xd0/0x230 [sctp]
>  sctp_primitive_SEND+0x2f/0x40 [sctp]
>  sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
>  sctp_sendmsg+0x3d5/0x440 [sctp]
>  sock_sendmsg+0x5b/0x70
>  sock_write_iter+0x97/0x100
>  new_sync_write+0x1a1/0x1b0
>  vfs_write+0x1b7/0x250
>  ksys_write+0xab/0xe0
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> RIP: 0033:0x461e3d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
> RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
> RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff
> ---[ end trace 332cf75246d5ba68 ]---
> BUG: kernel NULL pointer dereference, address: 0000000000000070
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 800000010c0d4067 P4D 800000010c0d4067 PUD 10f275067 PMD 0
> Oops: 0000 [#1] SMP PTI
> CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G        W=
  O
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-=
g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
> RIP: 0010:sctp_sched_dequeue_common+0x5c/0x70 [sctp]
> Code: 5b 08 4c 89 e7 e8 44 c5 cc c9 84 c0 74 0f 48 8b 53 18 48 8b 43 20 4=
8 89 42 08 48 89 10 48 8b 43 38 4c 89 63 18 4c 89 63 20 5b <8b> 40 70 29 45=
 20 5d 41 5c c3 cc cc cc cc 66 0f 1f 44 00 00 0f 1f
> RSP: 0018:ffffaf7d84a57940 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffaf7d84a579a0 RCX: 0000000000000000
> RDX: ffffa035ddf01c30 RSI: ffffa035ddf01c30 RDI: ffffa035ddf01c30
> RBP: ffffa035dddff6f8 R08: ffffa035ddf01c30 R09: ffffaf7d84a57770
> R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c30
> R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
> FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000070 CR3: 000000010f7c2001 CR4: 00000000001706e0
> Call Trace:
>  sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
>  sctp_outq_flush_data+0x85/0x360 [sctp]
>  sctp_outq_uncork+0x77/0xa0 [sctp]
>  sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
>  sctp_side_effects+0x37/0xe0 [sctp]
>  sctp_do_sm+0xd0/0x230 [sctp]
>  sctp_primitive_SEND+0x2f/0x40 [sctp]
>  sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
>  sctp_sendmsg+0x3d5/0x440 [sctp]
>  sock_sendmsg+0x5b/0x70
>  sock_write_iter+0x97/0x100
>  new_sync_write+0x1a1/0x1b0
>  vfs_write+0x1b7/0x250
>  ksys_write+0xab/0xe0
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> RIP: 0033:0x461e3d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
> RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
> RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff
>
>
> It is quite similar to the issue (See https://lore.kernel.org/all/CAO4mrf=
cB0d+qbwtfndzqcrL+QEQgfOmJYQMAdzwxRePmP8TY1A@mail.gmail.com/ ) , which was =
addressed by 181d8d2066c0 (sctp: leave the err path free in sctp_stream_ini=
t to sctp_stream_free), but unfortunately the patch do not work with this b=
ug :(
>
So this issue is reproducible in your env?
Can you show what it does in your test or the reproducer if there is one?

Thanks.
