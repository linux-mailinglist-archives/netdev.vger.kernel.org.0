Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BEB5A18A9
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbiHYSSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243425AbiHYSSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:18:05 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C1BBD1FF
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:17:15 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3321c2a8d4cso562963287b3.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BCMrQbCukGMsGcD2zzVB7BkUKujkSXYiEonnJ9enq3M=;
        b=hht9ayyyOPItGGJtj3y0f7a23alMccSzokSSmQfEX0j4w43T+TZ++nW9w6nalrMhit
         8QjBiRMfjEAvE3M+e4rqa3K4aNcaT8pS73c91RSVJc8vLj1MQ+2omL0Lvk6VlRuDybSn
         pTCZj7RcUIIhsqqzUx1tOymMlmSj6sFqOjGvicP4FS8Yx+0NlSWQJbWNml90GEQKmGJg
         icLMEKhacGiy6UI+wpNPTj40T3+u/hVmDEL3El+kgDNirumS1W2fOCHh9icZNETIK1Lj
         5MO/dKe7/fDDUh9nF03+h5n4eEAJMMU/eG8zRYw0FkKfro1IhAvh/1SM575oQz0xlJLf
         rJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BCMrQbCukGMsGcD2zzVB7BkUKujkSXYiEonnJ9enq3M=;
        b=yH7+w0smdIe2AwOM6VtYIhFAt8S8wtuKnF6y17BNbziHxGHfuBH/XgcQHQhB7d4zjc
         yJtvkiGl4hcQZjYCFd0Mas/EXlKPoGruXJSlbv0g1C2Nu4vmjyCDB2lBQBVqpfFBgLsV
         GJaco6Y2IOy3YfsIapCPsONKaznkqu0iIiPodS/yC9zVDEWY8fN3tEARak2ZUQMqhOiT
         Lf4mlm7KpdWfWXE8MpcMj02Jf1h34edpEx7zVdw9/FHFyutCRxeOBmTXN82+a1xAfZry
         neZKuHen0IMcECI4h4xk3jLWV2ZDpCLfvpVjr7UZd5oOa8XyKfmmUod76ZCphtBHpf++
         eX/A==
X-Gm-Message-State: ACgBeo0hhnihBk2ISrWsqvzxIegtYxtuYNuYZBSIWO9rwyrhzwNiMJWT
        qeAm0dd2+TA0ASVsv2ToyBnmpLxi595Scpm1Hqt/cA==
X-Google-Smtp-Source: AA6agR4Vhp2mxTwReVpRnMNLF13Uu7CAQdfO/BVxcnRSzS7CPrO7kjG2nMg22FinDVmN6NY9+5YSlmL72je1Px6sMr0=
X-Received: by 2002:a81:7c09:0:b0:336:8eb7:10d1 with SMTP id
 x9-20020a817c09000000b003368eb710d1mr5044844ywc.489.1661451433859; Thu, 25
 Aug 2022 11:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <Yv2BhXInteHP7eJm@electric-eye.fr.zoreil.com>
In-Reply-To: <Yv2BhXInteHP7eJm@electric-eye.fr.zoreil.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 25 Aug 2022 11:17:02 -0700
Message-ID: <CANn89i+3jZLjy0iYDo78QhQ5STt2X6B2zxX0rY-xOdqmy9WFSA@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/1] rose: check NULL rose_loopback_neigh->loopback
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-hams@vger.kernel.org,
        Bernard <bernard.f6bvp@gmail.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Thomas Osterried <thomas@osterried.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 5:02 PM Francois Romieu <romieu@fr.zoreil.com> wrote:
>
> From: Bernard Pidoux <f6bvp@free.fr>
>
> Commit 3b3fd068c56e3fbea30090859216a368398e39bf added NULL check for
> `rose_loopback_neigh->dev` in rose_loopback_timer() but omitted to
> check rose_loopback_neigh->loopback.
>
> It thus prevents *all* rose connect.
>
> The reason is that a special rose_neigh loopback has a NULL device.
>
> /proc/net/rose_neigh illustrates it via rose_neigh_show() function :
> [...]
> seq_printf(seq, "%05d %-9s %-4s   %3d %3d  %3s     %3s %3lu %3lu",
>            rose_neigh->number,
>            (rose_neigh->loopback) ? "RSLOOP-0" : ax2asc(buf, &rose_neigh->callsign),
>            rose_neigh->dev ? rose_neigh->dev->name : "???",
>            rose_neigh->count,
>
> /proc/net/rose_neigh displays special rose_loopback_neigh->loopback as
> callsign RSLOOP-0:
>
> addr  callsign  dev  count use mode restart  t0  tf digipeaters
> 00001 RSLOOP-0  ???      1   2  DCE     yes   0   0
>
> By checking rose_loopback_neigh->loopback, rose_rx_call_request() is called
> even in case rose_loopback_neigh->dev is NULL. This repairs rose connections.
>
> Verification with rose client application FPAC:
>
> FPAC-Node v 4.1.3 (built Aug  5 2022) for LINUX (help = h)
> F6BVP-4 (Commands = ?) : u
> Users - AX.25 Level 2 sessions :
> Port   Callsign     Callsign  AX.25 state  ROSE state  NetRom status
> axudp  F6BVP-5   -> F6BVP-9   Connected    Connected   ---------
>
> Fixes: 3b3fd068c56e ("rose: Fix Null pointer dereference in rose_send_frame()")
> Signed-off-by: Bernard Pidoux <f6bvp@free.fr>
> Suggested-by: Francois Romieu <romieu@fr.zoreil.com>
> Cc: Thomas DL9SAU Osterried <thomas@osterried.de>
> ---
>
>  Regression appeared in the v5.9..v5.10 cycle. The fix above also applies as-is
>  to stable v5.4, stable v4.19 and stable v4.14.
>
>  net/rose/rose_loopback.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 11c45c8c6c16..036d92c0ad79 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
>                 }
>
>                 if (frametype == ROSE_CALL_REQUEST) {
> -                       if (!rose_loopback_neigh->dev) {
> +                       if (!rose_loopback_neigh->dev &&
> +                           !rose_loopback_neigh->loopback) {
>                                 kfree_skb(skb);
>                                 continue;
>                         }
> --
> 2.37.1

ok but then the original crash/bug reappears....

general protection fault, probably for non-canonical address
0xdffffc000000006c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000360-0x0000000000000367]
CPU: 0 PID: 3587 Comm: udevd Not tainted
6.0.0-rc1-syzkaller-00228-g0c4a95417ee4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 07/22/2022
RIP: 0010:ax25_dev_ax25dev include/net/ax25.h:342 [inline]
RIP: 0010:ax25_send_frame+0xe4/0x640 net/ax25/ax25_out.c:56
Code: 00 48 85 c0 49 89 c4 0f 85 fb 03 00 00 e8 94 4f 2c f9 49 8d bd
60 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c
02 00 0f 85 b1 04 00 00 4d 8b ad 60 03 00 00 4d 85 ed 0f 84
RSP: 0018:ffffc90000007ab8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888026306c08 RCX: 0000000000000100
RDX: 000000000000006c RSI: ffffffff884fbbbc RDI: 0000000000000360
RBP: ffffffff9155a560 R08: 0000000000000001 R09: ffffffff908dda67
R10: 0000000000000001 R11: 1ffffffff2012bb1 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000104 R15: 0000000000000000
FS: 00007feeaa097840(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f831856a1b8 CR3: 000000007bd4f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
rose_send_frame+0xcc/0x2f0 net/rose/rose_link.c:106
rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
expire_timers kernel/time/timer.c:1519 [inline]
__run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
__run_timers kernel/time/timer.c:1768 [inline]
run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
__do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
invoke_softirq kernel/softirq.c:445 [inline]
__irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
</IRQ>
<TASK>
