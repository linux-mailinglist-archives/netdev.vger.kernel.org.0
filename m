Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31B96DBFB1
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjDILtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDILtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 07:49:42 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE4C1FF5;
        Sun,  9 Apr 2023 04:49:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 94521604F5;
        Sun,  9 Apr 2023 13:49:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681040975; bh=DV8lfbN8orBSN2EV7jaFfHBhHenYpFwH3F86YqW+Gfs=;
        h=Date:To:Cc:From:Subject:From;
        b=cWmlYxLDUsS41T0VIi3hk8hglIJKZMn8O5J4LKv+fQ30Ado3UiI/0l2SBLAVRykv6
         2MPfAEiAVPQhp6IbeBVaZpJ6bkFDvQ3XFdnIrKGo7HgEs/+H242BFMwFzPcCi4lmUq
         xsvyk6Xzck5UvPLtePXpHjaQxChGLdJLrvVy1FvJlLpCwNHc2xP4RLf1mYPyTUewzo
         nUrlD23EB39E/oqbDmILZRMpO65jp7Bnl4s8tcEneuvnQPXxHf7VUOvw+CqUO04gWS
         MmG7xUvnZDICFnBHR8453W8lwD6cV/liQWJgrCMwcvK5rxFtN40ORFZAEZJVy/w90e
         2WEuvLc2MdufA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7EreKA9QbWnR; Sun,  9 Apr 2023 13:49:32 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id AFB7F604ED;
        Sun,  9 Apr 2023 13:49:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681040972; bh=DV8lfbN8orBSN2EV7jaFfHBhHenYpFwH3F86YqW+Gfs=;
        h=Date:To:Cc:From:Subject:From;
        b=hFp/owszAMPVP+Qr+iD/1gOpGn51CHlepX1oq6NvK6OnzHHOSr/hiTWjSnlURa7sl
         JhWdcjLG42y08EMxectlTrf7O/UZlNu8YIxlnYb386hzQlDaB2rwZMomeaZj/zJQOI
         xJn5Azy4atbeuIhIThfz36UndNbGH+BkQ4V0nzjvOsTrP1lSCSnJB2lBd+2eq9V3BZ
         teYCy99G6E3Bj/HePNv9wn39W6OUHUyWg7r+s4bRydWP6CIZXgr8ZxOb8BIWA8xj0z
         pTJeERzQihLJK3jQfBAAZAXix9UetgviICrn0WfTgqu5PgxcqKbKZPMMJHllSSDeCB
         fDCscc9YtlqWg==
Message-ID: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
Date:   Sun, 9 Apr 2023 13:49:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US, hr
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [BUG] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

There appears to be a memleak triggered by the selftest drivers/net/team.

# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8c18def8ee00 (size 256):
  comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
  hex dump (first 32 bytes):
    00 20 09 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
    [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
    [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
    [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
    [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
    [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
    [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
    [<ffffffffb6ac7574>] dev_open+0x94/0xa0
    [<ffffffffc176515e>] 0xffffffffc176515e
    [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
    [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
    [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
    [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
    [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
    [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
    [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
unreferenced object 0xffff8c18250d3700 (size 32):
  comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
  hex dump (first 32 bytes):
    a0 ee f8 de 18 8c ff ff a0 ee f8 de 18 8c ff ff  ................
    81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
    [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
    [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
    [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
    [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
    [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
    [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
    [<ffffffffb6ac7574>] dev_open+0x94/0xa0
    [<ffffffffc176515e>] 0xffffffffc176515e
    [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
    [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
    [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
    [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
    [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
    [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
    [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
unreferenced object 0xffff8c1846e16800 (size 256):
  comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
  hex dump (first 32 bytes):
    00 20 f7 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
    [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
    [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
    [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
    [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
    [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
    [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
    [<ffffffffb6ac7574>] dev_open+0x94/0xa0
    [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
    [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
    [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
    [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
    [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
    [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
    [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
    [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
unreferenced object 0xffff8c184c5ff2a0 (size 32):
  comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
  hex dump (first 32 bytes):
    a0 68 e1 46 18 8c ff ff a0 68 e1 46 18 8c ff ff  .h.F.....h.F....
    81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
    [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
    [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
    [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
    [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
    [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
    [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
    [<ffffffffb6ac7574>] dev_open+0x94/0xa0
    [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
    [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
    [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
    [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
    [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
    [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
    [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
    [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20

The platform is Ubuntu 22.10 with the latest Torvalds tree 6.3-rc5+ build commit cdc9718d5e59
on a Lenovo Ideapad 3 15ITL6.

The minimum reproducing tools/testing/selftest/Makefile is provided here:

→ https://domac.alu.unizg.hr/~mtodorov/linux/bugreports/drivers_net/

leaving only two test suites:

# TARGETS += drivers/s390x/uvdevice
TARGETS += drivers/net/bonding
TARGETS += drivers/net/team
# TARGETS += efivarfs

(Smaller one won't run, missing prerequisites.)

Please find the config, complete kmemleak and lshw output.

I am available for further data required.

(The Cc: list is from scripts/get_maintainers on net/core/rtnetlink.c).

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"
