Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E4F46A17E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350720AbhLFQiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:38:21 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34442
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350539AbhLFQiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:38:20 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EF2743F175
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638808490;
        bh=i3QaBRjh8TEeGGt4YhrSWODT6KWw62FFOkURaRyExAg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=dC4wWpjR7Aj7FoFPJtgsd4CWzkHQIIdS8lMKshVcX+sbshFAsGRXCBRoMZT6F6t9K
         PGU+OCULnaUgJhocEBrjqbOoKHXN0d4sV9Cvw1tERBXS3ylDXGmJ4Dn9jSce0iAG/W
         phTVRrbU5OFzPV8xb8pwJuQ438H1Kqv95c7A9ZnUIkj2gmr7pSjTXNzf/nJKF9sgGi
         18rEYMiINCyuJyHYM7jJlVX3rpmu0Ey9vpnuYyO1z4TbewVMnEMHByqYsCreMNJZFp
         wgIEJXKZN/Vlf0VQJkuZUjv9KKmYVeKLVaTLuTiZ0gS1b1f633DYZT+/Wnb0GbnTsf
         VMJffRosXKqYA==
Received: by mail-ed1-f71.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so8794406edw.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 08:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i3QaBRjh8TEeGGt4YhrSWODT6KWw62FFOkURaRyExAg=;
        b=X1yaru3jf4/e+wEioXx7ForjK9O18rTkd6I85vImKniS+5p6CjNsAkCNDi0VVFraxl
         BQ4H9N25dZdPVhHfw90pos8sOxrOTY1JKCT89KPdJtU2/z4ePs3oa377yXyX0sGQAvrI
         gc55zjR4kAo7dn4KRCm0xLM759LJ5+gEGFbQpkQK13mu+EJKXonIEgZv1IxrXVzuw5RN
         7OeDRL9zevhUVwh8HezkJBreIggYQubkrXBEBBPRdS/1pLiScsXR4ueR2Uvucf2+yYMv
         fNKnJZjgBZDM4wGAKYiQPjAs8ul0Po5DFFjdYLi9g8IHN6NS8n7Qv1JYsW4G5D5+NjIz
         X+KA==
X-Gm-Message-State: AOAM533c9f/ScGGIMc3L+PIy5Xf6gSb2qp8XcLR2pyozsvp1CasDOHvl
        lzkmwWNMT52JPAvpNxZU7Kq4SbavYXE2ZydtaJ9vj4zBNp6MDAREtqsYbvIoTWKh9dPMa8Gqzrf
        BYJATGsH0qTjipGzLzVPn+Ok8AO8kd97lAA==
X-Received: by 2002:a17:906:e115:: with SMTP id gj21mr47377866ejb.348.1638808490643;
        Mon, 06 Dec 2021 08:34:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrKPJl8reE4one2n9ITKQM9dFvmHRJHhglH7sFwAewXYI1JBIVdvoC2JkRQdXNk1XPVeefXw==
X-Received: by 2002:a17:906:e115:: with SMTP id gj21mr47377833ejb.348.1638808490407;
        Mon, 06 Dec 2021 08:34:50 -0800 (PST)
Received: from arighi-desktop.homenet.telecomitalia.it ([2001:67c:1560:8007::aac:c1b6])
        by smtp.gmail.com with ESMTPSA id cq19sm917916edb.33.2021.12.06.08.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:34:50 -0800 (PST)
From:   Andrea Righi <andrea.righi@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Date:   Mon,  6 Dec 2021 17:34:47 +0100
Message-Id: <20211206163447.991402-1-andrea.righi@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to trigger a NULL pointer dereference by running the srv6
net kselftest (tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh):

[  249.051216] BUG: kernel NULL pointer dereference, address: 0000000000000378
[  249.052331] #PF: supervisor read access in kernel mode
[  249.053137] #PF: error_code(0x0000) - not-present page
[  249.053960] PGD 0 P4D 0
[  249.054376] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  249.055083] CPU: 1 PID: 21 Comm: ksoftirqd/1 Tainted: G            E     5.16.0-rc4 #2
[  249.056328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[  249.057632] RIP: 0010:ip6_forward+0x53c/0xab0
[  249.058354] Code: 49 c7 44 24 20 00 00 00 00 48 83 e0 fe 48 8b 40 30 48 3d 70 b2 b5 81 0f 85 b5 04 00 00 e8 7c f2 ff ff 41 89 c5 e9 17 01 00 00 <44> 8b 93 78 03 00 00 45 85 d2 0f 85 92 fb ff ff 49 8b 54 24 10 48
[  249.061274] RSP: 0018:ffffc900000cbb30 EFLAGS: 00010246
[  249.062042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881051d3400
[  249.063141] RDX: ffff888104bda000 RSI: 00000000000002c0 RDI: 0000000000000000
[  249.064264] RBP: ffffc900000cbbc8 R08: 0000000000000000 R09: 0000000000000000
[  249.065376] R10: 0000000000000040 R11: 0000000000000000 R12: ffff888103409800
[  249.066498] R13: ffff8881051d3410 R14: ffff888102725280 R15: ffff888103525000
[  249.067619] FS:  0000000000000000(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
[  249.068881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  249.069777] CR2: 0000000000000378 CR3: 0000000104980000 CR4: 0000000000750ee0
[  249.070907] PKRU: 55555554
[  249.071337] Call Trace:
[  249.071730]  <TASK>
[  249.072070]  ? debug_smp_processor_id+0x17/0x20
[  249.072807]  seg6_input_core+0x2bb/0x2d0
[  249.073436]  ? _raw_spin_unlock_irqrestore+0x29/0x40
[  249.074225]  seg6_input+0x3b/0x130
[  249.074768]  lwtunnel_input+0x5e/0xa0
[  249.075357]  ip_rcv+0x17b/0x190
[  249.075867]  ? update_load_avg+0x82/0x600
[  249.076514]  __netif_receive_skb_one_core+0x86/0xa0
[  249.077231]  __netif_receive_skb+0x15/0x60
[  249.077843]  process_backlog+0x97/0x160
[  249.078389]  __napi_poll+0x31/0x170
[  249.078912]  net_rx_action+0x229/0x270
[  249.079506]  __do_softirq+0xef/0x2ed
[  249.080085]  run_ksoftirqd+0x37/0x50
[  249.080663]  smpboot_thread_fn+0x193/0x230
[  249.081312]  kthread+0x17a/0x1a0
[  249.081847]  ? smpboot_register_percpu_thread+0xe0/0xe0
[  249.082677]  ? set_kthread_struct+0x50/0x50
[  249.083340]  ret_from_fork+0x22/0x30
[  249.083926]  </TASK>
[  249.090295] ---[ end trace 1998d7ba5965a365 ]---

It looks like commit 0857d6f8c759 ("ipv6: When forwarding count rx stats
on the orig netdev") tries to determine the right netdev to account the
rx stats, but in this particular case it's failing and the netdev is
NULL.

Fallback to the previous method of determining the netdev interface (via
skb->dev) to account the rx stats when the orig netdev can't be
determined.

Fixes: 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 net/ipv6/ip6_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4e83e2a506..7ca4719ff34c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -472,6 +472,9 @@ int ip6_forward(struct sk_buff *skb)
 	u32 mtu;
 
 	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
+	if (unlikely(!idev))
+		idev = __in6_dev_get_safely(skb->dev);
+
 	if (net->ipv6.devconf_all->forwarding == 0)
 		goto error;
 
-- 
2.32.0

