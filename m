Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02386EFA9E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbjDZTHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDZTHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:07:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8613C39
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:07:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-76375982b6aso621945939f.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682536028; x=1685128028;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gns1prY/IC1CZaKDOD/dQz0xaGtzimfL6wp+tGPKpdU=;
        b=AI6Dl2BMeYfkNkeKJEKJeXRtOVMNLE51ssGhycMf5ETpfap7jiyir2/xxn7u6zO429
         yYRYGo5vL7hek5Nst2VnmNlIh99+2byuuewAi6P1fIJBYXbqb81eNWTSEvJXaDzYHMiX
         vhXdOgHJ9BcTnd6Wvejy2bIVKdI2YOsVxahju0cIjiccjw/YFo/U0n+CpolzlwZm2hp3
         NvrI12JUpQro1uIT5SUa1CZAAYVrqCz7tCm/pyh22H41svxwV31ZeQLjJkLqjsoUoxai
         1jfrfykl04CxvylVbLmFZmjuUeLUbllufZTIgFj3ZPtriokN9LqY3FYk3XCz9gqSp47R
         lrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682536028; x=1685128028;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gns1prY/IC1CZaKDOD/dQz0xaGtzimfL6wp+tGPKpdU=;
        b=MQAReYbgQ0xtPVHhpL/1BPBxSB2y90b8apfn0Ag9VxZxauHds0Uc0Wp7zDQYNoW0yY
         D0nxjBuTN2LAsOm1n/7f1hkDgJY/eq+MmhjVLFK2Gm/bx93d1uPg6XsB3B0TH/31yZfH
         fcuzDkqGkYmE1kaBBz/tCMbIic+CaIFImC3TluTS6l/IpArQlew4ddijVC4Yhuj8V0zV
         lz+ytIFQsPhGtjGhXnfBC2LzoaK6bNYbD2zoRg5gFCfdfgzcMyEVDIGvWO3v8g+f5YhV
         pMAIeRD1O8L1xzMUjLTDUs7ExuakgrO83qG/gbj1xKEk+clc1swTmLsamEWzXdUt4SqE
         Kaxg==
X-Gm-Message-State: AAQBX9ebL93NEwI4WD8x8CPx0EJZfE9iO7e4qiVtX7bnVCXnC8FY/hab
        olW7qMoZrJJVUwGiUB3fxsFiEeqIx2g=
X-Google-Smtp-Source: AKy350YlztPbypqRLt/ACSXvn3ruhuy+Y5iyaNJ9sLv6Msn0eSRBX5lIN0F3Kp9lWiBS96z0BZIFXA==
X-Received: by 2002:a5d:8ada:0:b0:760:ed78:a251 with SMTP id e26-20020a5d8ada000000b00760ed78a251mr10621271iot.19.1682536028314;
        Wed, 26 Apr 2023 12:07:08 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:cd3f:3e10:b939:59de? ([2601:282:800:7ed0:cd3f:3e10:b939:59de])
        by smtp.googlemail.com with ESMTPSA id z19-20020a6be213000000b007635e28bc11sm972788ioc.6.2023.04.26.12.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 12:07:07 -0700 (PDT)
Message-ID: <5a2eae5c-9ad7-aca5-4927-665db946cfb2@gmail.com>
Date:   Wed, 26 Apr 2023 13:07:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Subject: kernel panics with Big TCP and Tx ZC with hugepages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has been on the back burner for too long now and with v6.3 released
we should get it resolved before reports start rolling in. I am throwing
this data dump out to the mailing list hoping someone else can provide
more insights.

Big TCP (both IPv6 and IPv4 versions are affected) can cause a variety
of panics when combined with the Tx ZC API and buffers backed by
hugepages. I have seen this with mlx5, a driver under development and
veth, so it seems to be a problem with the core stack.

A quick reproducer:

#!/bin/bash
#
# make sure ip is from top of tree iproute2

ip netns add peer
ip li add eth0 type veth peer eth1
ip li set eth0 mtu 3400 up
ip addr add dev eth0 172.16.253.1/24
ip addr add dev eth0 2001:db8:1::1/64

ip li set eth1 netns peer mtu 3400 up
ip -netns peer addr add dev eth1 172.16.253.2/24
ip -netns peer addr add dev eth1 2001:db8:1::2/64

ip netns exec peer iperf3 -s -D

ip li set dev eth0 gso_ipv4_max_size $((510*1024)) gro_ipv4_max_size
$((510*1024)) gso_max_size $((510*1024)) gro_max_size  $((510*1024))

ip -netns peer li set dev eth1 gso_ipv4_max_size $((510*1024))
gro_ipv4_max_size  $((510*1024)) gso_max_size $((510*1024)) gro_max_size
 $((510*1024))

sysctl -w vm.nr_hugepages=2

cat <<EOF
Run either:

    iperf3 -c 172.16.253.2 --zc_api
    iperf3 -c 2001:db8:1::2 --zc_api

where iperf3 is from https://github.com/dsahern/iperf mods-3.10
EOF

iperf3 in my tree has support for buffers using hugepages when using the
Tx ZC API (--zc_api arg above).

I have seen various backtraces based on platform and configuration, but
skb_release_data is typically in the path. This is a common one for the
veth reproducer above (saw it with both v4 and v6):

[   32.167294] general protection fault, probably for non-canonical
address 0xdd8672069ea377b2: 0000 [#1] PREEMPT SMP
[   32.167569] CPU: 5 PID: 635 Comm: iperf3 Not tainted 6.3.0+ #4
[   32.167742] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.13.0-1ubuntu1.1 04/01/2014
[   32.168039] RIP: 0010:skb_release_data+0xf4/0x180
[   32.168208] Code: 7e 57 48 89 d8 48 c1 e0 04 4d 8b 64 05 30 41 f6 c4
01 75 e1 41 80 7e 76 00 4d 89 e7 79 0c 4c 89 e7 e8 90 f
[   32.168869] RSP: 0018:ffffc900001a4eb0 EFLAGS: 00010202
[   32.169025] RAX: 00000000000001c0 RBX: 000000000000001c RCX:
0000000000000000
[   32.169265] RDX: 0000000000000102 RSI: 000000000000068f RDI:
00000000ffffffff
[   32.169475] RBP: ffffc900001a4ee0 R08: 0000000000000000 R09:
ffff88807fd77ec0
[   32.169708] R10: ffffea0000173430 R11: 0000000000000000 R12:
dd8672069ea377aa
[   32.169915] R13: ffff8880069cf100 R14: ffff888011910ae0 R15:
dd8672069ea377aa
[   32.170126] FS:  0000000001720880(0000) GS:ffff88807fd40000(0000)
knlGS:0000000000000000
[   32.170398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.170586] CR2: 00007f0f04400000 CR3: 0000000004caa000 CR4:
0000000000750ee0
[   32.170796] PKRU: 55555554
[   32.170888] Call Trace:
[   32.170975]  <IRQ>
[   32.171039]  skb_release_all+0x2e/0x40
[   32.171152]  napi_consume_skb+0x62/0xf0
[   32.171281]  net_rx_action+0xf6/0x250
[   32.171394]  __do_softirq+0xdf/0x2c0
[   32.171506]  do_softirq+0x81/0xa0
[   32.171608]  </IRQ>


Xin came up with this patch a couple of months ago that resolves the
panic but it has a big impact on performance:

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0fbd5c85155f..6c2c8d09fd89 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1717,7 +1717,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
gfp_mask)
 {
        int num_frags = skb_shinfo(skb)->nr_frags;
        struct page *page, *head = NULL;
-       int i, new_frags;
+       int i, new_frags, pagelen;
        u32 d_off;

        if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
@@ -1733,7 +1733,16 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
gfp_mask)
                return 0;
        }

-       new_frags = (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+       pagelen = __skb_pagelen(skb);
+       if (pagelen > GSO_LEGACY_MAX_SIZE) {
+               /* without hugepages, skb frags can only hold 65536 data. */
+               if (!__pskb_pull_tail(skb, pagelen - GSO_LEGACY_MAX_SIZE))
+                       return -ENOMEM;
+               pagelen = GSO_LEGACY_MAX_SIZE;
+               num_frags = skb_shinfo(skb)->nr_frags;
+       }
+       new_frags = (pagelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
        for (i = 0; i < new_frags; i++) {
                page = alloc_page(gfp_mask);
                if (!page) {

