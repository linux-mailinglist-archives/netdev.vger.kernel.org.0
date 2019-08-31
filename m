Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52D6A4425
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 12:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfHaKyH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 31 Aug 2019 06:54:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3964 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfHaKyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 06:54:07 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 808AE8A4EE7F00B88A7A;
        Sat, 31 Aug 2019 18:54:02 +0800 (CST)
Received: from DGGEML423-HUB.china.huawei.com (10.1.199.40) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 31 Aug 2019 18:54:02 +0800
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.34]) by
 dggeml423-hub.china.huawei.com ([10.1.199.40]) with mapi id 14.03.0439.000;
 Sat, 31 Aug 2019 18:53:57 +0800
From:   maowenan <maowenan@huawei.com>
To:     David Miller <davem@davemloft.net>,
        "cpaasch@apple.com" <cpaasch@apple.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tim.froidcoeur@tessares.net" <tim.froidcoeur@tessares.net>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "aprout@ll.mit.edu" <aprout@ll.mit.edu>,
        "edumazet@google.com" <edumazet@google.com>,
        "jtl@netflix.com" <jtl@netflix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Topic: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Index: AQHVX55YYqkinwCtOUunKpnrH9Dyz6cUAA+AgAEVD0A=
Date:   Sat, 31 Aug 2019 10:53:56 +0000
Message-ID: <F95AC9340317A84688A5F0DF0246F3F21AAAA825@dggeml532-mbs.china.huawei.com>
References: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
        <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
        <20190830232657.GL45416@MacBook-Pro-64.local>
 <20190830.192049.1447010488040109227.davem@davemloft.net>
In-Reply-To: <20190830.192049.1447010488040109227.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.96]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[<ffffff90094930dc>] skb_peek_tail include/linux/skbuff.h:1516 [inline]
[<ffffff90094930dc>] tcp_write_queue_tail include/net/tcp.h:1478 [inline]
[<ffffff90094930dc>] tcp_rtx_queue_tail include/net/tcp.h:1543 [inline]
[<ffffff90094930dc>] tcp_fragment+0xc64/0xce8 net/ipv4/tcp_output.c:1175
[<ffffff90094a37f0>] tcp_write_wakeup+0x3f8/0x4a0 net/ipv4/tcp_output.c:3496
[<ffffff90094a38d0>] tcp_send_probe0+0x38/0x2d8 net/ipv4/tcp_output.c:3523
[<ffffff90094a75a0>] tcp_probe_timer net/ipv4/tcp_timer.c:343 [inline]
[<ffffff90094a75a0>] tcp_write_timer_handler+0x640/0x720 net/ipv4/tcp_timer.c:548
[<ffffff90094a76f8>] tcp_write_timer+0x78/0x1d0 net/ipv4/tcp_timer.c:562
[<ffffff90082610b0>] call_timer_fn.isra.1+0x58/0x180 kernel/time/timer.c:1144
[<ffffff90082616ec>] __run_timers kernel/time/timer.c:1218 [inline]
[<ffffff90082616ec>] run_timer_softirq+0x514/0x848 kernel/time/timer.c:1401
[<ffffff9008141a28>] __do_softirq+0x340/0x878 kernel/softirq.c:273
[<ffffff9008142890>] do_softirq_own_stack include/linux/interrupt.h:498 [inline]
[<ffffff9008142890>] invoke_softirq kernel/softirq.c:357 [inline]
[<ffffff9008142890>] irq_exit+0x170/0x370 kernel/softirq.c:391
[<ffffff900821d550>] __handle_domain_irq+0x100/0x1c0 kernel/irq/irqdesc.c:459
[<ffffff90080914a0>] handle_domain_irq include/linux/irqdesc.h:168 [inline]
[<ffffff90080914a0>] gic_handle_irq+0xd0/0x1f0 drivers/irqchip/irq-gic.c:377
