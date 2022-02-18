Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE594BB61C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbiBRKDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:03:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiBRKDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:03:00 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC4369C0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 02:02:42 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220218100239euoutp01ac3ece0eea1a25176a9452060e6ab64b~U2S7bs4s32394523945euoutp016
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:02:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220218100239euoutp01ac3ece0eea1a25176a9452060e6ab64b~U2S7bs4s32394523945euoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645178559;
        bh=oKDYveujkfhcs2ZLh37VcFiF0JyMo/sncXxADNqfYsk=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=WGl0LvhPXjAoydPagXUYzI4vodqxcXHijRWoGsWXRbJ07/TipIM1dsQ01f9VknBWI
         GiwHSjoce2zM61CcXk5q2FhRuY3BAOMEfm89v1QEIUkqkpxJF3cLv1migmPmw8nc1S
         ZIfQ1hRtV11mXNZwwUOhnd+8dc0KdOAPk2vWs4gI=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220218100238eucas1p1852026a4ff12eb3180732a492108c515~U2S7BL6Mz0172501725eucas1p14;
        Fri, 18 Feb 2022 10:02:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 7A.2B.10009.FBE6F026; Fri, 18
        Feb 2022 10:02:39 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220218100238eucas1p2c3022a0124bb1b33a20fb375d0e41b5d~U2S6hP4TG1574615746eucas1p2B;
        Fri, 18 Feb 2022 10:02:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220218100238eusmtrp122e09e34915cfbb3c942cdc1605c2849~U2S6fiKj31944819448eusmtrp1b;
        Fri, 18 Feb 2022 10:02:38 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-d6-620f6ebfd99f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 07.9E.09404.EBE6F026; Fri, 18
        Feb 2022 10:02:38 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220218100237eusmtip14cf544f71dd81e19c562908887003dfd~U2S5jWlji2870528705eusmtip1j;
        Fri, 18 Feb 2022 10:02:37 +0000 (GMT)
Message-ID: <2dc85036-c5a8-d79b-71b5-9288d0a53c37@samsung.com>
Date:   Fri, 18 Feb 2022 11:02:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rg?= =?UTF-8?Q?ensen?= 
        <toke@toke.dk>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>, Felipe Balbi <balbi@kernel.org>,
        linux-usb@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Yg9oNlF+YCot6WcO@linutronix.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7r78/iTDG51ilp8+Xmb3eJY2xN2
        i2kXJzFbfD5ynM1i8cJvzBZzzrewWDw99ojdYk/7dmaLph0rmCwubOtjtVi0rJXZ4tgCMYvN
        m6YyW1w6/IjFYuv7FewO/B5bVt5k8tg56y67x4JNpR5dNy4xe2xa1cnm8e7cOXaP9/uusnls
        OXSRzePzJrkAzigum5TUnMyy1CJ9uwSujGlzJzAXrKmoeDrTqoHxbnYXIyeHhICJRPPFaawg
        tpDACkaJNwtNuxi5gOwvQPb8Y2wQzmdGidbXdxlhOp7MeccKkVjOKPH6/yt2COcjo8TWY7dY
        QKp4Bewkpm/uB+tgEVCVmH7qJSNEXFDi5MwnQDUcHKICSRKLtrmDhIUFAiQOzZzEBmIzC4hL
        3HoynwnEFhEwlWi8eIgFZD6zwHEWiUML7oDNZxMwlOh62wXWwCmgK7H1yQRGiGZ5ieats5lB
        GiQE1nNKXGxaBXW2i8Sbe4eYIGxhiVfHt7BD2DISpyf3sEA0NDNKPDy3lh3C6WGUuNw0A6rb
        WuLOuV9sIGczC2hKrN+lDxF2lPizupkZJCwhwCdx460gxBF8EpO2TYcK80p0tAlBVKtJzDq+
        Dm7twQuXmCcwKs1CCpZZSP6fheSdWQh7FzCyrGIUTy0tzk1PLTbMSy3XK07MLS7NS9dLzs/d
        xAhMe6f/Hf+0g3Huq496hxiZOBgPMUpwMCuJ8H44yJskxJuSWFmVWpQfX1Sak1p8iFGag0VJ
        nDc5c0OikEB6YklqdmpqQWoRTJaJg1OqgWnO44WVGZILc1cZrlyRYsB8o56p7dHszj8Zj7aJ
        e70If/rHdWnpKp0FAcxmuf5Ptjvb6dd8rst8Me3XtCk7NB1PvrjUlfnrGT/L+V67KwqNtydK
        Gbsv5J7KdleIzXaTofhOO4stdlc3Wccsipiq5/XWc+13hi6J2N1bPr//dTr7/v3makd/PS1J
        byVr5yTl1Ohk5+3J3AcPHdhTOkdOPmvHo2k3U+SrW633PfkpfMruOfPxezz/V1+dvzt9y9tO
        K/lXR90Y56arHBDYcORmzMRlwar8DG/nltrtXLDr+H/Jyg9/HjtvC2N5e2dHw1JL/3lRxU+r
        PBc4qMhszeJsU775MSK00fNT9MSNvuwHI9KVWIozEg21mIuKEwH+C9ZJ6gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7r78viTDOZ/0bL48vM2u8Wxtifs
        FtMuTmK2+HzkOJvF4oXfmC3mnG9hsXh67BG7xZ727cwWTTtWMFlc2NbHarFoWSuzxbEFYhab
        N01ltrh0+BGLxdb3K9gd+D22rLzJ5LFz1l12jwWbSj26blxi9ti0qpPN4925c+we7/ddZfPY
        cugim8fnTXIBnFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2NimpOZll
        qUX6dgl6GdPmTmAuWFNR8XSmVQPj3ewuRk4OCQETiSdz3rF2MXJxCAksZZRYe/05G0RCRuLk
        tAZWCFtY4s+1LrC4kMB7Rol7B31BbF4BO4npm/sZQWwWAVWJ6adeMkLEBSVOznzCAmKLCiRJ
        rJs+nxnEFhbwk/j2/AxYDbOAuMStJ/OZQGwRAVOJxouHWECOYBY4zSLx5d10ZohlvUwS846X
        gthsAoYSXW8hjuAU0JXY+mQC1CAzia6tXVC2vETz1tnMExiFZiG5YxaSfbOQtMxC0rKAkWUV
        o0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYJxvO/Zzyw7Gla8+6h1iZOJgPMQowcGsJML74SBv
        khBvSmJlVWpRfnxRaU5q8SFGU2BgTGSWEk3OByaavJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQh
        gfTEktTs1NSC1CKYPiYOTqkGJp17L2qy9y9+HOK6sqFR7tH3015+1jxKKaWO1zq/3U3p/a+z
        3Xah1tYPX/dcf7n874b+hZOv+s1nezzHKqmYQ5AtLI7nqoLAm8V6m//66Jhs4tOzdPnZ9vue
        s0yiY0+QXpr9B8sZN1zZJEwNajVSRTXYzJVfV7POzjz5lOlZ42TVHzyaV5tdQmwPm+uZn9tS
        u/v/h9UBJ4pWipQX6XjtmLf8k83dzdcr1Y856DFvdwheXXL5RdOUE77232YJvJifzc+5/bD2
        ru8z3Qqifk72uu31Pd/z595jdyzss15Mu7fK9M/VQ6Ut94Nmtez/x2Gt9e6YoRKnpkPy9xBD
        gZZU4znTXbsnL945K6tZ3iUhQImlOCPRUIu5qDgRAHCPYWV8AwAA
X-CMS-MailID: 20220218100238eucas1p2c3022a0124bb1b33a20fb375d0e41b5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
        <Yg05duINKBqvnxUc@linutronix.de>
        <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
        <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
        <Yg9oNlF+YCot6WcO@linutronix.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 18.02.2022 10:34, Sebastian Andrzej Siewior wrote:
> On 2022-02-17 15:08:55 [+0100], Marek Szyprowski wrote:
>>>> Marek, does this work for you?
>>> Yes, this fixed the issue. Thanks!
>>>
>>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> I've just noticed that there is one more issue left to fix (the $subject
>> patch is already applied) - this one comes from threaded irq (if I got
>> the stack trace right):
> netif_rx() did only set the matching softirq bit and not more. Based on
> that I don't see why NOHZ shouldn't complain about a pending softirq
> once the CPU goes idle. Therefore I think the change I made is good
> since it uncovered that.
>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 147 at kernel/softirq.c:363
>> __local_bh_enable_ip+0xa8/0x1c0
> …
>> CPU: 0 PID: 147 Comm: irq/150-dwc3 Not tainted 5.17.0-rc4-next-20220217+
>> #4557
>> Hardware name: Samsung TM2E board (DT)
>> pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : __local_bh_enable_ip+0xa8/0x1c0
>> lr : netif_rx+0xa4/0x2c0
>> ...
>>
>> Call trace:
>>    __local_bh_enable_ip+0xa8/0x1c0
>>    netif_rx+0xa4/0x2c0
>>    rx_complete+0x214/0x250
>>    usb_gadget_giveback_request+0x58/0x170
>>    dwc3_gadget_giveback+0xe4/0x200
>>    dwc3_gadget_endpoint_trbs_complete+0x100/0x388
>>    dwc3_thread_interrupt+0x46c/0xe20
> So dwc3_thread_interrupt() disables interrupts here. Felipe dropped it
> and then added it back in
>      e5f68b4a3e7b0 ("Revert "usb: dwc3: gadget: remove unnecessary _irqsave()"")
>
> I would suggest to revert it (the above commit) and fixing the lockdep
> splat in the gadget driver and other. I don't see the g_ether warning
> Felipe mentioned. It might come from f_ncm (since it uses a timer) or
> something else in the network stack (that uses a timeout timer).
> But not now.
> As much as I hate it, I suggest:
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 183b90923f51b..a0c883f19a417 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -4160,9 +4160,11 @@ static irqreturn_t dwc3_thread_interrupt(int irq, void *_evt)
>   	unsigned long flags;
>   	irqreturn_t ret = IRQ_NONE;
>   
> +	local_bh_disable();
>   	spin_lock_irqsave(&dwc->lock, flags);
>   	ret = dwc3_process_event_buf(evt);
>   	spin_unlock_irqrestore(&dwc->lock, flags);
> +	local_bh_enable();
>   
>   	return ret;
>   }
>
>
> In the long run I would drop that irqsave (along with bh_disable() since
> netif_rx() covers that) and make sure the there is no lockdep warning
> popping up.
>
> Marek, could you please give it a try?

Yes. The above change fixes the issue.


I've also tried to revert the mentioned commit e5f68b4a3e7b, but this 
gives me the following lockdep warning:

IPv6: ADDRCONF(NETDEV_CHANGE): usb0: link becomes ready

========================================================
WARNING: possible irq lock inversion dependency detected
5.17.0-rc4-next-20220217+ #4563 Not tainted
--------------------------------------------------------
swapper/0/0 just changed the state of lock:
ffff000025548098 (_xmit_ETHER#2){+.-.}-{2:2}, at: 
sch_direct_xmit+0x2f0/0x360
but this lock took another, SOFTIRQ-unsafe lock in the past:
  (&dev->lock#2){+.+.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
  Possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&dev->lock#2);
                                local_irq_disable();
                                lock(_xmit_ETHER#2);
                                lock(&dev->lock#2);
   <Interrupt>
     lock(_xmit_ETHER#2);

  *** DEADLOCK ***

5 locks held by swapper/0/0:
  #0: ffff80000a5f39e0 ((&ndev->rs_timer)){+.-.}-{0:0}, at: 
call_timer_fn+0x0/0x3b0
  #1: ffff80000a695e00 (rcu_read_lock){....}-{1:2}, at: 
ndisc_send_skb+0x138/0x730 [ipv6]
  #2: ffff80000a696290 (rcu_read_lock_bh){....}-{1:2}, at: 
ip6_finish_output2+0x94/0xbe8 [ipv6]
  #3: ffff80000a696290 (rcu_read_lock_bh){....}-{1:2}, at: 
__dev_queue_xmit+0x64/0xec8
  #4: ffff0000246cd258 (dev->qdisc_tx_busylock ?: 
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x9a4/0xec8

the shortest dependencies between 2nd lock and 1st lock:
  -> (&dev->lock#2){+.+.}-{2:2} {
     HARDIRQ-ON-W at:
                       lock_acquire+0x120/0x3c8
                       _raw_spin_lock+0x58/0x78
                       gether_connect+0x118/0x1c0
                       ecm_set_alt+0xf4/0x170
                       composite_setup+0x8d0/0x1820
                       dwc3_ep0_delegate_req+0x40/0x68
                       dwc3_ep0_interrupt+0x5a4/0xf88
                       dwc3_thread_interrupt+0xb7c/0xe18
                       irq_thread_fn+0x28/0x98
                       irq_thread+0x184/0x238
                       kthread+0x100/0x120
                       ret_from_fork+0x10/0x20
     SOFTIRQ-ON-W at:
                       lock_acquire+0x120/0x3c8
                       _raw_spin_lock+0x58/0x78
                       gether_connect+0x118/0x1c0
                       ecm_set_alt+0xf4/0x170
                       composite_setup+0x8d0/0x1820
                       dwc3_ep0_delegate_req+0x40/0x68
                       dwc3_ep0_interrupt+0x5a4/0xf88
                       dwc3_thread_interrupt+0xb7c/0xe18
                       irq_thread_fn+0x28/0x98
                       irq_thread+0x184/0x238
                       kthread+0x100/0x120
                       ret_from_fork+0x10/0x20
     INITIAL USE at:
                      lock_acquire+0x120/0x3c8
                      _raw_spin_lock_irq+0x74/0xa0
                      eth_open+0x28/0x78
                      __dev_open+0x100/0x190
                      __dev_change_flags+0x16c/0x1b8
                      dev_change_flags+0x20/0x60
                      do_setlink+0x314/0xd28
                      __rtnl_newlink+0x418/0x798
                      rtnl_newlink+0x4c/0x78
                      rtnetlink_rcv_msg+0x2bc/0x4e0
                      netlink_rcv_skb+0xe8/0x130
                      rtnetlink_rcv+0x14/0x20
                      netlink_unicast+0x1d4/0x280
                      netlink_sendmsg+0x2cc/0x408
                      ____sys_sendmsg+0x258/0x290
                      ___sys_sendmsg+0x80/0xc0
                      __sys_sendmsg+0x60/0xb8
                      __arm64_sys_sendmsg+0x1c/0x28
                      invoke_syscall+0x40/0xf8
                      el0_svc_common.constprop.3+0x8c/0x120
                      do_el0_svc+0x20/0x98
                      el0_svc+0x48/0x100
                      el0t_64_sync_handler+0x8c/0xb0
                      el0t_64_sync+0x15c/0x160
   }
   ... key      at: [<ffff80000b5004b8>] __key.60862+0x0/0x10
   ... acquired at:
    _raw_spin_lock_irqsave+0x78/0x148
    eth_start_xmit+0x30/0x3a0
    dev_hard_start_xmit+0x108/0x3d8
    sch_direct_xmit+0xf4/0x360
    __dev_queue_xmit+0xa10/0xec8
    dev_queue_xmit+0x10/0x18
    neigh_resolve_output+0x18c/0x290
    ip6_finish_output2+0x20c/0xbe8 [ipv6]
    __ip6_finish_output+0x104/0x2b8 [ipv6]
    ip6_finish_output+0x30/0x108 [ipv6]
    ip6_output+0x80/0x360 [ipv6]
    mld_sendpack+0x570/0x5a0 [ipv6]
    mld_ifc_work+0x2a4/0x4a0 [ipv6]
    process_one_work+0x29c/0x6b0
    worker_thread+0x48/0x420
    kthread+0x100/0x120
    ret_from_fork+0x10/0x20

-> (_xmit_ETHER#2){+.-.}-{2:2} {
    HARDIRQ-ON-W at:
                     lock_acquire+0x120/0x3c8
                     _raw_spin_lock+0x58/0x78
                     sch_direct_xmit+0x2f0/0x360
                     __dev_queue_xmit+0xa10/0xec8
                     dev_queue_xmit+0x10/0x18
                     neigh_resolve_output+0x18c/0x290
                     ip6_finish_output2+0x20c/0xbe8 [ipv6]
                     __ip6_finish_output+0x104/0x2b8 [ipv6]
                     ip6_finish_output+0x30/0x108 [ipv6]
                     ip6_output+0x80/0x360 [ipv6]
                     mld_sendpack+0x570/0x5a0 [ipv6]
                     mld_ifc_work+0x2a4/0x4a0 [ipv6]
                     process_one_work+0x29c/0x6b0
                     worker_thread+0x48/0x420
                     kthread+0x100/0x120
                     ret_from_fork+0x10/0x20
    IN-SOFTIRQ-W at:
                     lock_acquire+0x120/0x3c8
                     _raw_spin_lock+0x58/0x78
                     sch_direct_xmit+0x2f0/0x360
                     __dev_queue_xmit+0xa10/0xec8
                     dev_queue_xmit+0x10/0x18
                     ip6_finish_output2+0x8bc/0xbe8 [ipv6]
                     __ip6_finish_output+0x104/0x2b8 [ipv6]
                     ip6_finish_output+0x30/0x108 [ipv6]
                     ip6_output+0x80/0x360 [ipv6]
                     ndisc_send_skb+0x464/0x730 [ipv6]
                     ndisc_send_rs+0x58/0x138 [ipv6]
                     addrconf_rs_timer+0x140/0x218 [ipv6]
                     call_timer_fn+0xb4/0x3b0
                     run_timer_softirq+0x290/0x678
                     _stext+0x11c/0x5cc
                     irq_exit_rcu+0x168/0x1a8
                     el1_interrupt+0x40/0x128
                     el1h_64_irq_handler+0x14/0x20
                     el1h_64_irq+0x64/0x68
                     arch_cpu_idle+0x14/0x20
                     default_idle_call+0x78/0x350
                     do_idle+0x1f0/0x280
                     cpu_startup_entry+0x24/0x80
                     rest_init+0x180/0x290
                     arch_call_rest_init+0xc/0x14
                     start_kernel+0x694/0x6cc
                     __primary_switched+0xc0/0xc8
    INITIAL USE at:
                    lock_acquire+0x120/0x3c8
                    _raw_spin_lock+0x58/0x78
                    sch_direct_xmit+0x2f0/0x360
                    __dev_queue_xmit+0xa10/0xec8
                    dev_queue_xmit+0x10/0x18
                    neigh_resolve_output+0x18c/0x290
                    ip6_finish_output2+0x20c/0xbe8 [ipv6]
                    __ip6_finish_output+0x104/0x2b8 [ipv6]
                    ip6_finish_output+0x30/0x108 [ipv6]
                    ip6_output+0x80/0x360 [ipv6]
                    mld_sendpack+0x570/0x5a0 [ipv6]
                    mld_ifc_work+0x2a4/0x4a0 [ipv6]
                    process_one_work+0x29c/0x6b0
                    worker_thread+0x48/0x420
                    kthread+0x100/0x120
                    ret_from_fork+0x10/0x20
  }
  ... key      at: [<ffff80000b507ca8>] netdev_xmit_lock_key+0x10/0x390
  ... acquired at:
    __lock_acquire+0x564/0x16f8
    lock_acquire+0x120/0x3c8
    _raw_spin_lock+0x58/0x78
    sch_direct_xmit+0x2f0/0x360
    __dev_queue_xmit+0xa10/0xec8
    dev_queue_xmit+0x10/0x18
    ip6_finish_output2+0x8bc/0xbe8 [ipv6]
    __ip6_finish_output+0x104/0x2b8 [ipv6]
    ip6_finish_output+0x30/0x108 [ipv6]
    ip6_output+0x80/0x360 [ipv6]
    ndisc_send_skb+0x464/0x730 [ipv6]
    ndisc_send_rs+0x58/0x138 [ipv6]
    addrconf_rs_timer+0x140/0x218 [ipv6]
    call_timer_fn+0xb4/0x3b0
    run_timer_softirq+0x290/0x678
    _stext+0x11c/0x5cc
    irq_exit_rcu+0x168/0x1a8
    el1_interrupt+0x40/0x128
    el1h_64_irq_handler+0x14/0x20
    el1h_64_irq+0x64/0x68
    arch_cpu_idle+0x14/0x20
    default_idle_call+0x78/0x350
    do_idle+0x1f0/0x280
    cpu_startup_entry+0x24/0x80
    rest_init+0x180/0x290
    arch_call_rest_init+0xc/0x14
    start_kernel+0x694/0x6cc
    __primary_switched+0xc0/0xc8


stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc4-next-20220217+ #4563
Hardware name: Samsung TM2E board (DT)
Call trace:
  dump_backtrace.part.6+0xd8/0xe8
  show_stack+0x14/0x60
  dump_stack_lvl+0x88/0xb0
  dump_stack+0x14/0x2c
  print_irq_inversion_bug+0x194/0x1f8
  mark_lock.part.52+0x29c/0x440
  __lock_acquire+0x564/0x16f8
  lock_acquire+0x120/0x3c8
  _raw_spin_lock+0x58/0x78
  sch_direct_xmit+0x2f0/0x360
  __dev_queue_xmit+0xa10/0xec8
  dev_queue_xmit+0x10/0x18
  ip6_finish_output2+0x8bc/0xbe8 [ipv6]
  __ip6_finish_output+0x104/0x2b8 [ipv6]
  ip6_finish_output+0x30/0x108 [ipv6]
  ip6_output+0x80/0x360 [ipv6]
  ndisc_send_skb+0x464/0x730 [ipv6]
  ndisc_send_rs+0x58/0x138 [ipv6]
  addrconf_rs_timer+0x140/0x218 [ipv6]
  call_timer_fn+0xb4/0x3b0
  run_timer_softirq+0x290/0x678
  _stext+0x11c/0x5cc
  irq_exit_rcu+0x168/0x1a8
  el1_interrupt+0x40/0x128
  el1h_64_irq_handler+0x14/0x20
  el1h_64_irq+0x64/0x68
  arch_cpu_idle+0x14/0x20
  default_idle_call+0x78/0x350
  do_idle+0x1f0/0x280
  cpu_startup_entry+0x24/0x80
  rest_init+0x180/0x290
  arch_call_rest_init+0xc/0x14
  start_kernel+0x694/0x6cc
  __primary_switched+0xc0/0xc8


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

