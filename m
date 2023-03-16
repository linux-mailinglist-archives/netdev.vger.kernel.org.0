Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6016BD331
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjCPPPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCPPPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:15:35 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C858D309B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:15:30 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id ek9so2033196qtb.10
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678979729;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iX7BQQGSdX6bue2+26ch+gcyD0tQPZ8/TzCZWLw/N9c=;
        b=qb+NBHL/a+Z6CzpvRVS1BPx4Yn5sXfv8uEN6PlJAnQUP2CubZ8hOZDJBUXSJPmKyTz
         W1f83XMJpz0VqdWjZUAs8c5faeaHA1I3xrR9RzLmp0cIDzXgfvAbCsK/egDxzLfHA1i2
         4slR1bgoSDbBe79/L+Yyg87I8+ssrqboCWCwVM2ynS14wRzgoaMMXdqJ9LtrcTg3qIOo
         hSuYoksZ8RqM4W1cAHmo1N74ZEAbVHySsUnRPVqvYutthxTRFxNKgVFhZuXylO0Wmge8
         Y6MJhN9lXfrrkzfNS53/93fLHJJtWYfiKguyr57lGhC2UKbMgRqHDYO4JcOqfvYsEZug
         gsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678979729;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iX7BQQGSdX6bue2+26ch+gcyD0tQPZ8/TzCZWLw/N9c=;
        b=ZblIt3ookV6xxXhR9/GBr4ynq65KzYOA9ezeFQdbdSvHY9H50tR7tIBarJRe/EjnZ4
         payROYGPl1Zz5jtXxSboA2Hbo1myzZb7CgIksShy8lDFQ1q+u/NtzYMH8JXu37CVXpzT
         m5qXDh0/zyQgGvjL40QFQ1i2RQEb4ZmFtooEdd42WIAJoWldqiA68xRu81wqxeKn/jas
         +wv+0Jou87bc+cp5e8l/N1WHC/vBV6x5Cbbmf/NCnegnXUpP8RE8mk5Tefucb89eHk5w
         yneMHyo0H+joq7FYFr2eAvCQ2FoQhhbuPG8eKfdTfWtWw4kE6hm37+/OYDmpHD2hW4pj
         eFyw==
X-Gm-Message-State: AO0yUKXuPKyfu17FSURPwO86mPzwg/f3mZi3TFjGDnjVrstHxT0L6fkz
        3dj2QHx/untFrMqYo6fPHznU4FxRwOk=
X-Google-Smtp-Source: AK7set+HMy7dQk9KXEVDpNRLLzsiI7Sqk5F03LpR/gObFrz1Fwv1PGrt1NqUSWoY+pSXivOq7ReFjg==
X-Received: by 2002:a05:622a:1189:b0:3bf:cfe8:f8f5 with SMTP id m9-20020a05622a118900b003bfcfe8f8f5mr6754714qtk.41.1678979729093;
        Thu, 16 Mar 2023 08:15:29 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id z10-20020a05620a260a00b0074631fb7cd0sm1367848qko.66.2023.03.16.08.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:15:28 -0700 (PDT)
Date:   Thu, 16 Mar 2023 11:15:28 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Message-ID: <64133290485ad_3333c7208b2@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
References: <20230316011014.992179-1-edumazet@google.com>
Subject: RE: [PATCH net-next 0/9] net/packet: KCSAN awareness
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> This series is based on one syzbot report [1]
> 
> Seven 'flags/booleans' are converted to atomic bit variant.
> 
> po->xmit and po->tp_tstamp accesses get annotations.
> 
> [1]
> BUG: KCSAN: data-race in packet_rcv / packet_setsockopt
> 
> read-write to 0xffff88813dbe84e4 of 1 bytes by task 12312 on cpu 0:
> packet_setsockopt+0xb77/0xe60 net/packet/af_packet.c:3900
> __sys_setsockopt+0x212/0x2b0 net/socket.c:2252
> __do_sys_setsockopt net/socket.c:2263 [inline]
> __se_sys_setsockopt net/socket.c:2260 [inline]
> __x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> read to 0xffff88813dbe84e4 of 1 bytes by task 1911 on cpu 1:
> packet_rcv+0x4b1/0xa40 net/packet/af_packet.c:2187
> deliver_skb net/core/dev.c:2189 [inline]
> dev_queue_xmit_nit+0x3a9/0x620 net/core/dev.c:2259
> xmit_one+0x71/0x2a0 net/core/dev.c:3586
> dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
> __dev_queue_xmit+0x91c/0x11c0 net/core/dev.c:4256
> dev_queue_xmit include/linux/netdevice.h:3008 [inline]
> neigh_hh_output include/net/neighbour.h:530 [inline]
> neigh_output include/net/neighbour.h:544 [inline]
> ip6_finish_output2+0x9e9/0xc30 net/ipv6/ip6_output.c:134
> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
> ip6_finish_output+0x395/0x4f0 net/ipv6/ip6_output.c:206
> NF_HOOK_COND include/linux/netfilter.h:291 [inline]
> ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:227
> dst_output include/net/dst.h:445 [inline]
> ip6_local_out+0x60/0x80 net/ipv6/output_core.c:161
> ip6tunnel_xmit include/net/ip6_tunnel.h:161 [inline]
> udp_tunnel6_xmit_skb+0x321/0x4a0 net/ipv6/ip6_udp_tunnel.c:109
> send6+0x2ed/0x3b0 drivers/net/wireguard/socket.c:152
> wg_socket_send_skb_to_peer+0xbb/0x120 drivers/net/wireguard/socket.c:178
> wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
> wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
> process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
> worker_thread+0x618/0xa70 kernel/workqueue.c:2436
> kthread+0x1a9/0x1e0 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> 
> value changed: 0x00 -> 0x01
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 1911 Comm: kworker/1:3 Not tainted 6.1.0-rc8-syzkaller-00164-g4cee37b3a4e6-dirty #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: wg-crypt-wg0 wg_packet_tx_worker
> 
> Eric Dumazet (9):
>   net/packet: annotate accesses to po->xmit
>   net/packet: convert po->origdev to an atomic flag
>   net/packet: convert po->auxdata to an atomic flag
>   net/packet: annotate accesses to po->tp_tstamp
>   net/packet: convert po->tp_tx_has_off to an atomic flag
>   net/packet: convert po->tp_loss to an atomic flag
>   net/packet: convert po->has_vnet_hdr to an atomic flag
>   net/packet: convert po->running to an atomic flag
>   net/packet: convert po->pressure to an atomic flag
> 
>  net/packet/af_packet.c | 104 +++++++++++++++++++++--------------------
>  net/packet/diag.c      |  12 ++---
>  net/packet/internal.h  |  34 +++++++++++---
>  3 files changed, 87 insertions(+), 63 deletions(-)
> 
> -- 
> 2.40.0.rc2.332.ga46443480c-goog
> 

For the series:

Reviewed-by: Willem de Bruijn <willemb@google.com>
