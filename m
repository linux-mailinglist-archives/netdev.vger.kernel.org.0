Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0056BBEF3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjCOVXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjCOVX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:23:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB5959F4;
        Wed, 15 Mar 2023 14:22:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso1234256pjb.2;
        Wed, 15 Mar 2023 14:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678915375;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx6XINbG22RuRvopp7NSnS9Ir7wpXLl6X3F0oM3Lksk=;
        b=TT5PfyzZmVmlzKB78JIUQfKeQ3T88kEK2ZqX6va1SSv/9h9+8QE+hjgSa6qknXnz0S
         1xXSbXMxuRxNCFLdguERPbLmfMq+N/WIVTyX/FcrGg7SRyjOA/G3fCWTwR7SQKbphY9N
         7LNmTsYCjDZ6rC4BVZsl5nfz3VjTgObuewhGw4u9Fwqs0fmCNxLHdZiJrD1yRs2D0Zhl
         V7mHgmhjybJMSOJSQvGyDovYpWpEEA17yDa4vrF5z1CU4J3JjdIshgp7x+Eg/ekobZQX
         6EmXSHZmbggVvbV2az9j+hmRBrt1Y870aP8ydfMP3DW44W6xiOyp8IYevClTvgOFM5Ol
         MwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678915375;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fx6XINbG22RuRvopp7NSnS9Ir7wpXLl6X3F0oM3Lksk=;
        b=WLsfZH+pNYnC816iOGh9aCLcfeTbtLuDgmQKmrQder+SPvahBnElanROddZFU2FXtd
         UpWTXVTn6tXDO9v84Zg5unv3Zj+CKm3HL552HKtmXyep3T+qEDuCbgf2WqR7E2Yn3oPI
         zTYz2L4AsiYkKWld9/6dy5sQIFw2ARiIcFYA088q4jIxn3Nl73GrenVfIL8OJ5Y8BqSg
         5n5U/9l30+skmLrBfh9R0057OaosKhOUP6xLryPVYQ78XxOTsvZQtXLgsBDIH5XTFXI/
         9+kYHVo4I6ZpeLDs7r7YC5KR4kxBLYDmObMMiuCWdAFnBQ8vx1c+H/WDF2n0fbmo+rZx
         rPLw==
X-Gm-Message-State: AO0yUKVeHUlmmlO/TKvNz/wkzgqhRlojpXGJeKMv6BnxAFhBdVI2I1ST
        tq3coJc4UofcNxXbu4TLeOY=
X-Google-Smtp-Source: AK7set8w++g0E9Oio4lvebxzVA2u/R2NCFuVd9SPlDPbBsiMF87XW6hdxTbGpP47FgjxTjqMIFyGRQ==
X-Received: by 2002:a17:903:2341:b0:1a0:5bb1:3f0b with SMTP id c1-20020a170903234100b001a05bb13f0bmr1286312plh.40.1678915375520;
        Wed, 15 Mar 2023 14:22:55 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902868c00b0019b0afc24e8sm4043842plo.250.2023.03.15.14.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:22:54 -0700 (PDT)
Date:   Wed, 15 Mar 2023 14:22:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Message-ID: <6412372ddb847_63dce20857@john.notmuch>
In-Reply-To: <20230314083901.40521-2-xuanzhuo@linux.alibaba.com>
References: <20230314083901.40521-1-xuanzhuo@linux.alibaba.com>
 <20230314083901.40521-2-xuanzhuo@linux.alibaba.com>
Subject: RE: [PATCH net 1/2] virtio_net: fix page_to_skb() miss headroom
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo wrote:
> Because headroom is not passed to page_to_skb(), this causes the shinfo
> exceeds the range. Then the frags of shinfo are changed by other process.
> 
> [  157.724634] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> [  157.725358] CPU: 3 PID: 679 Comm: xdp_pass_user_f Tainted: G            E      6.2.0+ #150
> [  157.726401] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/4
> [  157.727820] RIP: 0010:skb_release_data+0x11b/0x180
> [  157.728449] Code: 44 24 02 48 83 c3 01 39 d8 7e be 48 89 d8 48 c1 e0 04 41 80 7d 7e 00 49 8b 6c 04 30 79 0c 48 89 ef e8 89 b
> [  157.730751] RSP: 0018:ffffc90000178b48 EFLAGS: 00010202
> [  157.731383] RAX: 0000000000000010 RBX: 0000000000000001 RCX: 0000000000000000
> [  157.732270] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff888100dd0b00
> [  157.733117] RBP: 5d5d76010f6e2408 R08: ffff888100dd0b2c R09: 0000000000000000
> [  157.734013] R10: ffffffff82effd30 R11: 000000000000a14e R12: ffff88810981ffc0
> [  157.734904] R13: ffff888100dd0b00 R14: 0000000000000002 R15: 0000000000002310
> [  157.735793] FS:  00007f06121d9740(0000) GS:ffff88842fcc0000(0000) knlGS:0000000000000000
> [  157.736794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  157.737522] CR2: 00007ffd9a56c084 CR3: 0000000104bda001 CR4: 0000000000770ee0
> [  157.738420] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  157.739283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  157.740146] PKRU: 55555554
> [  157.740502] Call Trace:
> [  157.740843]  <IRQ>
> [  157.741117]  kfree_skb_reason+0x50/0x120
> [  157.741613]  __udp4_lib_rcv+0x52b/0x5e0
> [  157.742132]  ip_protocol_deliver_rcu+0xaf/0x190
> [  157.742715]  ip_local_deliver_finish+0x77/0xa0
> [  157.743280]  ip_sublist_rcv_finish+0x80/0x90
> [  157.743834]  ip_list_rcv_finish.constprop.0+0x16f/0x190
> [  157.744493]  ip_list_rcv+0x126/0x140
> [  157.744952]  __netif_receive_skb_list_core+0x29b/0x2c0
> [  157.745602]  __netif_receive_skb_list+0xed/0x160
> [  157.746190]  ? udp4_gro_receive+0x275/0x350
> [  157.746732]  netif_receive_skb_list_internal+0xf2/0x1b0
> [  157.747398]  napi_gro_receive+0xd1/0x210
> [  157.747911]  virtnet_receive+0x75/0x1c0
> [  157.748422]  virtnet_poll+0x48/0x1b0
> [  157.748878]  __napi_poll+0x29/0x1b0
> [  157.749330]  net_rx_action+0x27a/0x340
> [  157.749812]  __do_softirq+0xf3/0x2fb
> [  157.750298]  do_softirq+0xa2/0xd0
> [  157.750745]  </IRQ>
> [  157.751563]  <TASK>
> [  157.752329]  __local_bh_enable_ip+0x6d/0x80
> [  157.753178]  virtnet_xdp_set+0x482/0x860
> [  157.754159]  ? __pfx_virtnet_xdp+0x10/0x10
> [  157.755129]  dev_xdp_install+0xa4/0xe0
> [  157.756033]  dev_xdp_attach+0x20b/0x5e0
> [  157.756933]  do_setlink+0x82e/0xc90
> [  157.757777]  ? __nla_validate_parse+0x12b/0x1e0
> [  157.758744]  rtnl_setlink+0xd8/0x170
> [  157.759549]  ? mod_objcg_state+0xcb/0x320
> [  157.760328]  ? security_capable+0x37/0x60
> [  157.761209]  ? security_capable+0x37/0x60
> [  157.762072]  rtnetlink_rcv_msg+0x145/0x3d0
> [  157.762929]  ? ___slab_alloc+0x327/0x610
> [  157.763754]  ? __alloc_skb+0x141/0x170
> [  157.764533]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
> [  157.765422]  netlink_rcv_skb+0x58/0x110
> [  157.766229]  netlink_unicast+0x21f/0x330
> [  157.766951]  netlink_sendmsg+0x240/0x4a0
> [  157.767654]  sock_sendmsg+0x93/0xa0
> [  157.768434]  ? sockfd_lookup_light+0x12/0x70
> [  157.769245]  __sys_sendto+0xfe/0x170
> [  157.770079]  ? handle_mm_fault+0xe9/0x2d0
> [  157.770859]  ? preempt_count_add+0x51/0xa0
> [  157.771645]  ? up_read+0x3c/0x80
> [  157.772340]  ? do_user_addr_fault+0x1e9/0x710
> [  157.773166]  ? kvm_read_and_reset_apf_flags+0x49/0x60
> [  157.774087]  __x64_sys_sendto+0x29/0x30
> [  157.774856]  do_syscall_64+0x3c/0x90
> [  157.775518]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  157.776382] RIP: 0033:0x7f06122def70
> 
> Fixes: 18117a842ab0 ("virtio-net: remove xdp related info from page_to_skb()")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---

LGTM thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
