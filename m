Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190C9E432D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 08:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbfJYGAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 02:00:42 -0400
Received: from mout.gmx.net ([212.227.15.18]:59341 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393967AbfJYGAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 02:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571983222;
        bh=wZlyKENycmK9lsri3lVZvS+vGwQPRxstzXSq54uEgJo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dX1bDxYx3CT2VCRZ5EqGCvuVnkWgIpLus5YsA9xbBXpUbJR2qWlvMUdGx5/OQEX1r
         k14XlJCS3vq+UitNLKbQQS0qyh/BOXBE2RY1gxxBxi09FuVHOKGEjln8es/E939Ep7
         aFkYoOEHKFTlXV/4PfuQHRwRBsS8N4q7JKzFSWGY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MowKi-1he8Hw1ZDK-00qTcW; Fri, 25
 Oct 2019 08:00:22 +0200
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
To:     Daniel Wagner <dwagner@suse.de>, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20191018082817.111480-1-dwagner@suse.de>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <a8ce75ca-f756-309e-11b4-6ad597e94ad9@gmx.net>
Date:   Fri, 25 Oct 2019 08:00:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018082817.111480-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:loHQDQWry2EsaXAbHdVuW9BsRZL5d6w37/LhjAdnn4zbwdK+I2F
 bJvlGDW9j6Zik3ReSxnWZsFVcOgNyv5ehuSgjzw1kvQh/TGiIoQ1QOi6FMaSI5+xHNcr0wB
 nAejnS/bYom/Xd3AdVOBJYCNX+7Bh3mply9te/INQjz9oZHSPStnarRAmlpzXilNK+QMUJN
 DKmerXE06uXHtLyz81yUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EPY1KEOBwA8=:HgIsmDJp2gMfjRXKreHUOD
 sItz/VQ9rbfCjFXmW0zLDZn6l/K2eyt/Hgrb8UZYIhNOH8wfg6Dg8FHPV+TDSBS9A3br6aD5j
 EljSBhFJLAhZ1KvF4/1qemD4+lCY6xut3A52zroXkZkmvbBOueaD0dCDkp31Kmrx6djCL/6l1
 jsfV65ep2Z3JajfUJRoS4uF64agzXTUt+tqU7EuWBPL7dDZGDxT3ScRAKLmoJ36PecMUMScs1
 Rro534Y+FWAEXJNba2MIUZXCzExOjNw+yjYd5M/YJ9HiKpl6z10I2SKzkbJe3CcsQplleV1Eq
 vd23GaVI73Fv/qBj7iee+w5S8m2HsHazYsKSKASvHvO7snXPJPgMti/yIc6kxOjz4lRe6oFYy
 c42BiOUVnXCwC02nX16BA+FGydw8gWNmK3l3JsXbvUhFY4xnT7t7vX3dIdAKf6ul0SRTAk9MT
 5wu+secPp1zOqGpPtqFV9nBMCs2DITd8/kCG9fTZ95DGdBYfUv8Qs3cg5uV00dubA5ZPz4yBi
 x8haQfdG3t6oQJGhLQeqN3ojTq4w9rg5N9NrgnsaGDjeFjzb81CSgdaIxaWrvR/VBkAby1wSO
 VfTcvgqtbvYerDOG1gEUhf097wFf2vnBAoL9SXkvTSHQXl3R2fzHBAaiRdGQ+lJKZNSNxRgW5
 Kohwtf1i27UL3lr/ap80SnYxgGmlVQ8BjtMk8EUWbmYe9u+MHHPFqmkrdswXrNg++LECU/Yqp
 cem3BjZUR1dIoRZq+NNJxOWFbS9xI1oa3w43rNa6gkyt7cbpV94D8SyHIyU+tTf0wy066AeZN
 peJrmzJQ+Uo81xPrQk1XUn0gkW4piUl1ehTs0OhD7ThGhRrL3fj0luX9aHTRlh4oGBrMyyu+w
 7+E6I4U+68Mutlz7y4Q90F/lrLPlLKGpfmwdknPumkAYcM70zY1j9Oae2RkuJzh6dzYPkHSao
 caZxwmCcrCaSUpJ/HIO8Byf29iH5Gf+U39WAwrEIpB9bX5toGUwLjvcmcuWBN0kn4mELLiKJu
 KC5g/3xYPRZ0e/QgtVY9dCKvQwHVRijF7UnAiuWDjREye8rO7FcSOm6kkTfP1BL6fOAXiPfOD
 iAjIzMD8ZEexIe8kxI7DqA/wmREgTRYq6tqPZmV5usQnxj7QtXbMn4UB9ro0YjzZWcTcUDh+a
 cPu3JT9RLvCEaqRSOWIJJUuJrPCOdXbMCN5pm1HSs+JUVIMwxVAOPefqU+EpXz5wOSnuk4CNC
 AnFfwMEosnCpVkxtjU0Vp8qtwM4sFjHbUGa8Pz2M4HZTK1WEvKBtUUdha/is=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18.10.19 um 10:28 schrieb Daniel Wagner:
> handle_simple_irq() expect interrupts to be disabled. The USB
> framework is using threaded interrupts, which implies that interrupts
> are re-enabled as soon as it has run.
>
> This reverts the changes from cc89c323a30e ("lan78xx: Use irq_domain
> for phy interrupt from USB Int. EP").
>
> [    4.886203] 000: irq 79 handler irq_default_primary_handler+0x0/0x8 enabled interrupts
> [    4.886243] 000: WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x154/0x168
> [    4.896294] 000: Modules linked in:
> [    4.896301] 000: CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.6 #39
> [    4.896310] 000: Hardware name: Raspberry Pi 3 Model B+ (DT)
> [    4.896315] 000: pstate: 60000005 (nZCv daif -PAN -UAO)
> [    4.896321] 000: pc : __handle_irq_event_percpu+0x154/0x168
> [    4.896331] 000: lr : __handle_irq_event_percpu+0x154/0x168
> [    4.896339] 000: sp : ffff000010003cc0
> [    4.896346] 000: x29: ffff000010003cc0 x28: 0000000000000060
> [    4.896355] 000: x27: ffff000011021980 x26: ffff00001189c72b
> [    4.896364] 000: x25: ffff000011702bc0 x24: ffff800036d6e400
> [    4.896373] 000: x23: 000000000000004f x22: ffff000010003d64
> [    4.896381] 000: x21: 0000000000000000 x20: 0000000000000002
> [    4.896390] 000: x19: ffff8000371c8480 x18: 0000000000000060
> [    4.896398] 000: x17: 0000000000000000 x16: 00000000000000eb
> [    4.896406] 000: x15: ffff000011712d18 x14: 7265746e69206465
> [    4.896414] 000: x13: ffff000010003ba0 x12: ffff000011712df0
> [    4.896422] 000: x11: 0000000000000001 x10: ffff000011712e08
> [    4.896430] 000: x9 : 0000000000000001 x8 : 000000000003c920
> [    4.896437] 000: x7 : ffff0000118cc410 x6 : ffff0000118c7f00
> [    4.896445] 000: x5 : 000000000003c920 x4 : 0000000000004510
> [    4.896453] 000: x3 : ffff000011712dc8 x2 : 0000000000000000
> [    4.896461] 000: x1 : 73a3f67df94c1500 x0 : 0000000000000000
> [    4.896466] 000: Call trace:
> [    4.896471] 000:  __handle_irq_event_percpu+0x154/0x168
> [    4.896481] 000:  handle_irq_event_percpu+0x50/0xb0
> [    4.896489] 000:  handle_irq_event+0x40/0x98
> [    4.896497] 000:  handle_simple_irq+0xa4/0xf0
> [    4.896505] 000:  generic_handle_irq+0x24/0x38
> [    4.896513] 000:  intr_complete+0xb0/0xe0
> [    4.896525] 000:  __usb_hcd_giveback_urb+0x58/0xd8
> [    4.896533] 000:  usb_giveback_urb_bh+0xd0/0x170
> [    4.896539] 000:  tasklet_action_common.isra.0+0x9c/0x128
> [    4.896549] 000:  tasklet_hi_action+0x24/0x30
> [    4.896556] 000:  __do_softirq+0x120/0x23c
> [    4.896564] 000:  irq_exit+0xb8/0xd8
> [    4.896571] 000:  __handle_domain_irq+0x64/0xb8
> [    4.896579] 000:  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
> [    4.896586] 000:  el1_irq+0xb8/0x140
> [    4.896592] 000:  arch_cpu_idle+0x10/0x18
> [    4.896601] 000:  do_idle+0x200/0x280
> [    4.896608] 000:  cpu_startup_entry+0x20/0x28
> [    4.896615] 000:  rest_init+0xb4/0xc0
> [    4.896623] 000:  arch_call_rest_init+0xc/0x14
> [    4.896632] 000:  start_kernel+0x454/0x480
>
> [dwagner: Updated Jisheng's initial patch]
>
> Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB Int. EP")
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Stefan Wahren <wahrenst@gmx.net>
> Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---

Acked-by: Stefan Wahren <wahrenst@gmx.net>

