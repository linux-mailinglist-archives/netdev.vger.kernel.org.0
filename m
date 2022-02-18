Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55D24BC22D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiBRVem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:34:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbiBRVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:34:42 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EE45BD05
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:34:24 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id n13-20020a056602340d00b006361f2312deso5228786ioz.9
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ESDhSXcBKMjopPYZv2w9C93Fs32sPD81EnUFCwe47Z8=;
        b=E5l4VtDiLjiT+eVmZTPE1i5C+86mM5JRoDcq8W0/E/oTAQSnYBgcBvfjGwabO7E2ks
         9CZhw0EFduv4Y3JtgNzM6IFHH/nu6iAOvNC+IoGOvbJ1OVl7P9lE1CgbvnYH6g90RzbX
         3yGstXNqHYocIETNlCzEvs1jdkqAoIhSue1izYy58fxNAWr0AiyqYBYXlMM/RklD6SGN
         o7AVbF+vCn/jPzkcjjfzwz0UopK//k1rPRDb0u8wpQah7tARzDdkG/ocqyVryaNKoM0X
         aANtflHG+C+teGfVnGbLm3dLy7uTsXAjf7LyjoY1zyrW04UVVZthKq9PmNq3Dj2HNNIE
         jy2g==
X-Gm-Message-State: AOAM531oBWJ2scyJAwodkBu5Ya1pYm4E7oPp8yF8k9Rw9mTMvjEr+5dR
        cwD8UvwS85fsw3TaNvWZIT4CTv9L+6alG1foX/+srTBjr2XT
X-Google-Smtp-Source: ABdhPJwijr18CZvtR9XxK1PvZnkcu5gmF2lHkJyrHt3O3Z8dSibn5LNQzbfbLx58lPYXLyq/i7hG87TE3BFNHiMto1TlRjnzLNL0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190e:b0:2bf:ac1e:b5b7 with SMTP id
 w14-20020a056e02190e00b002bfac1eb5b7mr6853634ilu.304.1645220064174; Fri, 18
 Feb 2022 13:34:24 -0800 (PST)
Date:   Fri, 18 Feb 2022 13:34:24 -0800
In-Reply-To: <0000000000003118ba05d500cce1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080aa2705d851a531@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in nf_nat_setup_info (2)
From:   syzbot <syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17b02532700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=76f99026248b24e4
dashboard link: https://syzkaller.appspot.com/bug?extid=cbcd154fce7c6d953d1c
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1659ab4c700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1621cbf2700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in get_unique_tuple net/netfilter/nf_nat_core.c:548 [inline]
BUG: KMSAN: uninit-value in nf_nat_setup_info+0x628/0x4a40 net/netfilter/nf_nat_core.c:642
 get_unique_tuple net/netfilter/nf_nat_core.c:548 [inline]
 nf_nat_setup_info+0x628/0x4a40 net/netfilter/nf_nat_core.c:642
 nfnetlink_parse_nat_setup+0xb86/0xcf0
 ctnetlink_parse_nat_setup+0xde/0x390 net/netfilter/nf_conntrack_netlink.c:1845
 ctnetlink_setup_nat net/netfilter/nf_conntrack_netlink.c:1920 [inline]
 ctnetlink_create_conntrack net/netfilter/nf_conntrack_netlink.c:2325 [inline]
 ctnetlink_new_conntrack+0x1d5d/0x4240 net/netfilter/nf_conntrack_netlink.c:2452
 nfnetlink_rcv_msg+0xe0a/0xf80 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x40c/0x7e0 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x667/0x4740 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x1093/0x1360 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x14d9/0x1720 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 __alloc_pages+0xbbf/0x1090 mm/page_alloc.c:5429
 alloc_pages+0xa08/0xd50
 alloc_slab_page mm/slub.c:1816 [inline]
 allocate_slab+0x29e/0x1b00 mm/slub.c:1961
 new_slab mm/slub.c:2021 [inline]
 ___slab_alloc+0xb52/0x1da0 mm/slub.c:3035
 __slab_alloc mm/slub.c:3122 [inline]
 slab_alloc_node mm/slub.c:3213 [inline]
 slab_alloc mm/slub.c:3255 [inline]
 kmem_cache_alloc+0xbb3/0x11c0 mm/slub.c:3260
 __nf_conntrack_alloc+0x232/0x7f0 net/netfilter/nf_conntrack_core.c:1553
 init_conntrack+0x29b/0x24c0 net/netfilter/nf_conntrack_core.c:1634
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1745 [inline]
 nf_conntrack_in+0x1abc/0x3130 net/netfilter/nf_conntrack_core.c:1903
 ipv4_conntrack_in+0x68/0x80 net/netfilter/nf_conntrack_proto.c:191
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow net/netfilter/core.c:619 [inline]
 nf_hook_slow_list+0x358/0xb40 net/netfilter/core.c:657
 NF_HOOK_LIST include/linux/netfilter.h:343 [inline]
 ip_sublist_rcv+0x1411/0x14a0 net/ipv4/ip_input.c:607
 ip_list_rcv+0x930/0x970 net/ipv4/ip_input.c:644
 __netif_receive_skb_list_ptype net/core/dev.c:5394 [inline]
 __netif_receive_skb_list_core+0xdf9/0x11f0 net/core/dev.c:5442
 __netif_receive_skb_list+0x7e3/0x940 net/core/dev.c:5494
 netif_receive_skb_list_internal+0x848/0xdc0 net/core/dev.c:5585
 gro_normal_list include/net/gro.h:425 [inline]
 napi_complete_done+0x579/0xdc0 net/core/dev.c:5932
 virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
 virtnet_poll+0x17a4/0x2340 drivers/net/virtio_net.c:1554
 __napi_poll+0x14c/0xc00 net/core/dev.c:6365
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x7e2/0x1820 net/core/dev.c:6519
 __do_softirq+0x1ee/0x7c5 kernel/softirq.c:558

CPU: 1 PID: 3471 Comm: syz-executor142 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================

