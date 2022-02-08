Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D057A4AD4B2
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354079AbiBHJXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349186AbiBHJXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:23:08 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF53FC03FEC1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 01:23:07 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id j2so48244015ybu.0
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 01:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v76WYw+Y0qvP4uX30X1KgyYe/e2hfdHgurh6EKNW+q8=;
        b=n1nAaz8mpAHyjSZbhJO8QIbsIa5zxJfvygj1pQr2QNjKJTccmyrcbRbzPDkMAKs5ts
         DJ87Gl3nQ4o6p1LkBwQmsl2gOa0Z+zt7j/lDCunDTBVsG16tbwuBLsHvQ2C0uIRpgOQA
         WYxkyc+QaeiMs25HR9WMBholE65iyKKgdQkEaenWyoXhTQn/KVfgNajmSMdPzCChmIwR
         ciN14kdB1jJNt9G5Nn92zW+ZWRtc/X9vD7+Ujddwmk1bo+ITNcHy7NVkCrDk8prn/sMW
         FjF5Onpw+OSdNTVDCKJ7xujLHo2FogRS/e5D9a1MfNzQF10J/zUGlMLJPlrDjkEttoVs
         FNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v76WYw+Y0qvP4uX30X1KgyYe/e2hfdHgurh6EKNW+q8=;
        b=yOro4iAv1MDShiE4+dWb6AEnhTBMqA7V87QN6NWsQa4dodM1xjFg8n7FSopeBlHCXl
         ZwI67oxYfH4yQ7TfUDUpVUItZWXe+0ho0RruK/1xuL3JN4f6rKR1vJQltOhR60Rwl+2X
         n/9O/q0MXXjSAWVLOdLdSoy445PrEtlS/3tCDjWxUojB33P2oTRBJ8ZKxyjvnxUrD5WI
         5ok0NT0Ey+zHClzq4A1/tbCd81Y0MeX4lsH5qJhbRo4Vv4Ocg9R8KBU6DfWPv7Wq+8J1
         wDSDZvX0ZwCuFpm/EiZ//BLOdB49HyImFMrwoU8mDJou2B8o+28f+zfhoOi08exZZbQx
         4vPQ==
X-Gm-Message-State: AOAM530tOV3qSnvpo9nZuQaUbx+aCiK9ijjHICIjNJEYmVrgp7ahvhlW
        TQQiL72d75kuuoReoYVxUq96Jnkk7/8WBi7UyfaBJrsFBmDBbg==
X-Google-Smtp-Source: ABdhPJzLRXokh9NY389zkuq7SRqJcDaCXcyuFgSKt6O1g6TLHOTBGT49eRBXwG18qgajp+IKjQlAfWJwMSjXV8jlX64=
X-Received: by 2002:a25:148b:: with SMTP id 133mr3797329ybu.270.1644312186679;
 Tue, 08 Feb 2022 01:23:06 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f5988505d77e20e4@google.com>
In-Reply-To: <000000000000f5988505d77e20e4@google.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 8 Feb 2022 10:22:55 +0100
Message-ID: <CANpmjNPW7Y9oHkdvfYjgEo0OCbtN1Ymf1mXE1CHFBj2oryfJ=g@mail.gmail.com>
Subject: Re: [syzbot] KCSAN: data-race in wg_packet_handshake_receive_worker /
 wg_packet_rx_poll (3)
To:     syzbot <syzbot+ed414b05fe54c96947f8@syzkaller.appspotmail.com>
Cc:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
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

On Tue, 8 Feb 2022 at 10:13, syzbot
<syzbot+ed414b05fe54c96947f8@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    455e73a07f6e Merge tag 'clk-for-linus' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=131009feb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e1f9a6122410716
> dashboard link: https://syzkaller.appspot.com/bug?extid=ed414b05fe54c96947f8
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ed414b05fe54c96947f8@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in wg_packet_handshake_receive_worker / wg_packet_rx_poll
>
> read to 0xffff88813238a9e0 of 8 bytes by interrupt on cpu 1:
>  update_rx_stats drivers/net/wireguard/receive.c:28 [inline]
>  wg_packet_consume_data_done drivers/net/wireguard/receive.c:365 [inline]
>  wg_packet_rx_poll+0xf6b/0x11f0 drivers/net/wireguard/receive.c:481
>  __napi_poll+0x65/0x3f0 net/core/dev.c:6365
>  napi_poll net/core/dev.c:6432 [inline]
>  net_rx_action+0x29e/0x650 net/core/dev.c:6519
>  __do_softirq+0x158/0x2de kernel/softirq.c:558
>  do_softirq+0xb1/0xf0 kernel/softirq.c:459
>  __local_bh_enable_ip+0x68/0x70 kernel/softirq.c:383
>  __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
>  _raw_spin_unlock_bh+0x33/0x40 kernel/locking/spinlock.c:210
>  spin_unlock_bh include/linux/spinlock.h:394 [inline]
>  ptr_ring_consume_bh include/linux/ptr_ring.h:367 [inline]
>  wg_packet_decrypt_worker+0x73c/0x780 drivers/net/wireguard/receive.c:506
>  process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
>  worker_thread+0x616/0xa70 kernel/workqueue.c:2454
>  kthread+0x2c7/0x2e0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30
>
> write to 0xffff88813238a9e0 of 8 bytes by task 5035 on cpu 0:
>  update_rx_stats drivers/net/wireguard/receive.c:28 [inline]
>  wg_receive_handshake_packet drivers/net/wireguard/receive.c:205 [inline]
>  wg_packet_handshake_receive_worker+0x54a/0x6e0 drivers/net/wireguard/receive.c:220
>  process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
>  worker_thread+0x616/0xa70 kernel/workqueue.c:2454
>  kthread+0x2c7/0x2e0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30
>
> value changed: 0x0000000000000aa8 -> 0x0000000000000ac8

Hi Jason,

For stats data races, in the majority of cases if the semantics is
"approximate" no harm is done, so the usual resolution is to mark them
intentionally racy with data_race() [1].

I've released these for completeness, but I can also skip them in
future. However, marking them appropriately helps because when all
intentionally racy accesses are marked, only "bad races" will be left,
and we can do less pre-moderation.

Thanks,
-- Marco

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt
