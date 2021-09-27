Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1713418D83
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 03:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhI0Blf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 21:41:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:24977 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhI0Ble (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 21:41:34 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHlZh3PLlzbmlY;
        Mon, 27 Sep 2021 09:35:40 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 27 Sep 2021 09:39:55 +0800
Subject: Re: [PATCH net] can: isotp: add result check for
 wait_event_interruptible()
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>
CC:     <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20210918092819.156291-1-william.xuanziyang@huawei.com>
Message-ID: <1fcfeb88-d49d-2a2a-1524-8504eb848123@huawei.com>
Date:   Mon, 27 Sep 2021 09:39:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210918092819.156291-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Using wait_event_interruptible() to wait for complete transmission,
> but do not check the result of wait_event_interruptible() which can
> be interrupted. It will result in tx buffer has multiple accessers
> and the later process interferes with the previous process.
> 
> Following is one of the problems reported by syzbot.
> 
> =============================================================
> WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
> Call Trace:
>  <IRQ>
>  ? isotp_setsockopt+0x390/0x390
>  __hrtimer_run_queues+0xb8/0x610
>  hrtimer_run_softirq+0x91/0xd0
>  ? rcu_read_lock_sched_held+0x4d/0x80
>  __do_softirq+0xe8/0x553
>  irq_exit_rcu+0xf8/0x100
>  sysvec_apic_timer_interrupt+0x9e/0xc0
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20
> 
> Add result check for wait_event_interruptible() in isotp_sendmsg()
> to avoid multiple accessers for tx buffer.
> 
> Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Hi Oliver,
I send a new patch with this problem, ignore this patch please.

Thank you!
