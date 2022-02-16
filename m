Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5EF4B838C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiBPJCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:02:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiBPJCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:02:33 -0500
X-Greylist: delayed 358 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 01:02:20 PST
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CF6898DA
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 01:02:18 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220216085614euoutp0219babc08bdae39b07d5eba83f67377f0~UOGYMurbN2189721897euoutp02N
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:56:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220216085614euoutp0219babc08bdae39b07d5eba83f67377f0~UOGYMurbN2189721897euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645001774;
        bh=E/nAFi/i8dOsIcKkgYyCC4sYrtFL45VgM5U9IcnwHPM=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=XsckYWMn922dI/qS5+5u9B5C8mEc2naI4fWhmRI3IXm4uV3FTEfhzT7LWWc2+oRzZ
         ZoQ8FHRV6WSifxRziIPDiemjdlUUCKCav1c06ed1GTe5ZzWaieBkktP6T/F5WQ7B8p
         4cKHihcI68lqE26xGztPYSp+3pwAKRA8zgqZAEh4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220216085614eucas1p2da951cfe6c723aeeb8acf803007808ce~UOGX33wy62524625246eucas1p2c;
        Wed, 16 Feb 2022 08:56:14 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 5C.52.09887.E2CBC026; Wed, 16
        Feb 2022 08:56:14 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54~UOGXLLPRv2323523235eucas1p1O;
        Wed, 16 Feb 2022 08:56:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220216085613eusmtrp1eb127a781ca35767688982d9386e4781~UOGXKOLB91922019220eusmtrp1m;
        Wed, 16 Feb 2022 08:56:13 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-b9-620cbc2ebd38
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CA.56.09404.D2CBC026; Wed, 16
        Feb 2022 08:56:13 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220216085612eusmtip14a4defdbeff97f40e3a29ef8097f4ac8~UOGWYFpJB1347413474eusmtip1a;
        Wed, 16 Feb 2022 08:56:12 +0000 (GMT)
Message-ID: <da6abfe2-dafd-4aa1-adca-472137423ba4@samsung.com>
Date:   Wed, 16 Feb 2022 09:56:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        <toke@redhat.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220211233839.2280731-3-bigeasy@linutronix.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7djP87p6e3iSDNZ9E7f48vM2u8W0i5OY
        LT4fOc5msXjhN2aLOedbWCyeHnvEbrGnfTuzRdOOFUwWF7b1sVocWyBmsXnTVGaLS4cfsVhs
        fb+C3YHXY8vKm0weO2fdZfdYsKnUo+vGJWaPTas62TzenTvH7vF+31U2jy2HLrJ5fN4kF8AZ
        xWWTkpqTWZZapG+XwJUxZe8K5oI/mxgrlv46w9rA+HkyYxcjJ4eEgInEmgdNQDYXh5DACkaJ
        axuesUE4Xxglnu+dxQxSJSTwmVFiwXy4jqPz9kIVLWeU2HxuBVT7R0aJT48fMIFU8QrYSWw5
        fgWsm0VAVWLL7ItQcUGJkzOfsHQxcnCICiRJLNrmDhIWFkiVeNhziQXEZhYQl7j1ZD4TSImI
        QIrEoSNSIOOZBe4wSxxrns0OUsMmYCjR9baLDaSGU8BWYmJ7AkSrvETz1tnMIPUSAss5JZ6s
        3sQIUiMh4CLR3aMCcb+wxKvjW9ghbBmJ05N7WCDqmxklHp5byw7h9DBKXG6aAfWxtcSdc7/A
        ljELaEqs36UPEXaUODD7JTvEfD6JG28FIW7gk5i0bTozRJhXoqNNCKJaTWLW8XVwaw9euMQ8
        gVFpFlKYzELy/Cwk38xC2LuAkWUVo3hqaXFuemqxUV5quV5xYm5xaV66XnJ+7iZGYIo7/e/4
        lx2My1991DvEyMTBeIhRgoNZSYQ37ixnkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe5MwNiUIC
        6YklqdmpqQWpRTBZJg5OqQYmkRyhNrvD9SZCShlrE++/XHb9aG+qmklsXWeI4TMGjT0NT+JL
        9D578yseyOJ7avFpgYZFvXd80Pn2xVfDSpdzRbCnv37P8MbX6POlbI20E8kRF3TnbJrcVeP7
        ruNAmUxHsa+701SuTYumvP0259z++n1RTVvl332J3lJlnaXXdlJO6KGp84I5WzljJJY1cwar
        x09Q/j5tJp/4Su+vew58sFV33RWhuJv3xoLCJdJPni/UaHKYfKJuzqyox/V8TOdm+Odb563K
        cGScqPxOfqFoh/A6zeZ7C0sCyv+8MTnHeJ1B5V/RgcXmNT+dBW3epnR8Pu2QtHO+Xd4zY93e
        l/yx5frPJu7n++Z+ZMXuy9+UWIozEg21mIuKEwGrXO+w4AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t/xu7q6e3iSDCb0WFh8+Xmb3WLaxUnM
        Fp+PHGezWLzwG7PFnPMtLBZPjz1it9jTvp3ZomnHCiaLC9v6WC2OLRCz2LxpKrPFpcOPWCy2
        vl/B7sDrsWXlTSaPnbPusnss2FTq0XXjErPHplWdbB7vzp1j93i/7yqbx5ZDF9k8Pm+SC+CM
        0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL0MuYsncF
        c8GfTYwVS3+dYW1g/DyZsYuRk0NCwETi6Ly9bF2MXBxCAksZJSZ9OsoMkZCRODmtgRXCFpb4
        c60Lqug9o8SROb1sIAleATuJLcevgDWwCKhKbJl9kQkiLihxcuYTFhBbVCBJYt30+WA1wgKp
        Eg97LoHFmQXEJW49mQ9WLyKQIrG88SsLyAJmgXvMEtOnrwZrEBLIlzh0ZiFYA5uAoUTXW5Ar
        ODg4BWwlJrYnQMwxk+ja2sUIYctLNG+dzTyBUWgWkjNmIVk3C0nLLCQtCxhZVjGKpJYW56bn
        FhvpFSfmFpfmpesl5+duYgRG9rZjP7fsYFz56qPeIUYmDsZDjBIczEoivHFnOZOEeFMSK6tS
        i/Lji0pzUosPMZoCw2Iis5Rocj4wteSVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqem
        FqQWwfQxcXBKNTAZc9vucq6+PvOwlMDbT9IZR8WYprLKVRVmSB+czdAS4Pb9/1zunX+3pr2f
        +2Ru5JedsW59Yi0Pv0ntXPDYZGKu+PW4Unar50JXQvK+Jp2fPD0oM+Zp6f5Wdd/rq7Iq9vrN
        djfh3m2v+NHhJaNmz8Q/57cU7HlxeFtW2B5x4+kdG45O4Hgcdl3iT0lD7hyn5sSHeq6/VHfv
        OHU6j4XbLPPNIp4NAk6HZz7d+HKrR42Y13y/hlUbtq/bsrmBrSx66YuKVR11za7vNrul9zyb
        Y/HxTdnamJrC2d4/q/k17kw2Lu5O1PjY5n3DOdrtdH2Fne39iPO32jgXPXmUX7Di4Av1Z4dZ
        nzgsPW9o4ZQ805dXiaU4I9FQi7moOBEAENRBEnUDAAA=
X-CMS-MailID: 20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
        <20220211233839.2280731-3-bigeasy@linutronix.de>
        <CGME20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54@eucas1p1.samsung.com>
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

On 12.02.2022 00:38, Sebastian Andrzej Siewior wrote:
> Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
> work in all contexts and get rid of netif_rx_ni()". Eric agreed and
> pointed out that modern devices should use netif_receive_skb() to avoid
> the overhead.
> In the meantime someone added another variant, netif_rx_any_context(),
> which behaves as suggested.
>
> netif_rx() must be invoked with disabled bottom halves to ensure that
> pending softirqs, which were raised within the function, are handled.
> netif_rx_ni() can be invoked only from process context (bottom halves
> must be enabled) because the function handles pending softirqs without
> checking if bottom halves were disabled or not.
> netif_rx_any_context() invokes on the former functions by checking
> in_interrupts().
>
> netif_rx() could be taught to handle both cases (disabled and enabled
> bottom halves) by simply disabling bottom halves while invoking
> netif_rx_internal(). The local_bh_enable() invocation will then invoke
> pending softirqs only if the BH-disable counter drops to zero.
>
> Eric is concerned about the overhead of BH-disable+enable especially in
> regard to the loopback driver. As critical as this driver is, it will
> receive a shortcut to avoid the additional overhead which is not needed.
>
> Add a local_bh_disable() section in netif_rx() to ensure softirqs are
> handled if needed.
> Provide __netif_rx() which does not disable BH and has a lockdep assert
> to ensure that interrupts are disabled. Use this shortcut in the
> loopback driver and in drivers/net/*.c.
> Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
> can be removed once they are no more users left.
>
> Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>

This patch landed in linux-next 20220215 as commit baebdf48c360 ("net: 
dev: Makes sure netif_rx() can be invoked in any context."). I found 
that it triggers the following warning on my test systems with USB CDC 
ethernet gadget:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 876 at kernel/softirq.c:308 
__local_bh_disable_ip+0xbc/0xc0
Modules linked in: hci_uart btbcm btintel brcmfmac bluetooth s5p_mfc 
s5p_csis s5p_fimc s5p_jpeg cfg80211 v4l2_mem2mem videobuf2_dma_contig 
videobuf2_memops exynos4_is_common videobuf2_v4l2 v4l2_fwnode 
videobuf2_common v4l2_async videodev ecdh_generic ecc brcmutil mc
CPU: 0 PID: 876 Comm: ip Not tainted 5.17.0-rc3-01145-gbaebdf48c360 #11325
Hardware name: Samsung Exynos (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0x238/0x23c
  __warn from warn_slowpath_fmt+0xac/0xb4
  warn_slowpath_fmt from __local_bh_disable_ip+0xbc/0xc0
  __local_bh_disable_ip from netif_rx+0x1c/0x28c
  netif_rx from rx_complete+0x12c/0x224
  rx_complete from dwc2_hsotg_complete_request+0x94/0x208
  dwc2_hsotg_complete_request from dwc2_hsotg_epint+0x9ac/0x1224
  dwc2_hsotg_epint from dwc2_hsotg_irq+0x264/0x1020
  dwc2_hsotg_irq from __handle_irq_event_percpu+0x74/0x3ac
  __handle_irq_event_percpu from handle_irq_event_percpu+0xc/0x38
  handle_irq_event_percpu from handle_irq_event+0x38/0x5c
  handle_irq_event from handle_fasteoi_irq+0xc4/0x180
  handle_fasteoi_irq from generic_handle_domain_irq+0x44/0x88
  generic_handle_domain_irq from gic_handle_irq+0x88/0xac
  gic_handle_irq from generic_handle_arch_irq+0x58/0x78
  generic_handle_arch_irq from __irq_svc+0x54/0x88
Exception stack(0xc3fb58e0 to 0xc3fb5928)
58e0: 00000000 c0f33a98 00000001 00000cbb 60000013 c2dc8730 c2dc875c 
00000cc0
5900: c2d2cc00 00000001 00000000 00000000 00000001 c3fb5930 c0b7dbc4 
c0b890d4
5920: 20000013 ffffffff
  __irq_svc from _raw_spin_unlock_irqrestore+0x2c/0x60
  _raw_spin_unlock_irqrestore from rx_fill+0x6c/0xa0
  rx_fill from eth_open+0x60/0x74
  eth_open from __dev_open+0xf0/0x174
  __dev_open from __dev_change_flags+0x16c/0x1b8
  __dev_change_flags from dev_change_flags+0x14/0x44
  dev_change_flags from do_setlink+0x33c/0xa3c
  do_setlink from __rtnl_newlink+0x524/0x80c
  __rtnl_newlink from rtnl_newlink+0x44/0x60
  rtnl_newlink from rtnetlink_rcv_msg+0x14c/0x4ec
  rtnetlink_rcv_msg from netlink_rcv_skb+0xdc/0x110
  netlink_rcv_skb from netlink_unicast+0x1ac/0x244
  netlink_unicast from netlink_sendmsg+0x328/0x448
  netlink_sendmsg from ____sys_sendmsg+0x1c4/0x220
  ____sys_sendmsg from ___sys_sendmsg+0x68/0x94
  ___sys_sendmsg from __sys_sendmsg+0x4c/0x88
  __sys_sendmsg from ret_fast_syscall+0x0/0x1c
Exception stack(0xc3fb5fa8 to 0xc3fb5ff0)
5fa0:                   beacb6dc beac3624 00000003 beac3630 00000000 
00000000
5fc0: beacb6dc beac3624 00000000 00000128 0054e304 386d3fd2 0054e000 
beac3630
5fe0: 0000006c beac35e0 00517f80 b6ea2ab8
irq event stamp: 3260
hardirqs last  enabled at (3259): [<c0b89104>] 
_raw_spin_unlock_irqrestore+0x5c/0x60
hardirqs last disabled at (3260): [<c0100aec>] __irq_svc+0x4c/0x88
softirqs last  enabled at (3250): [<c0982a90>] __dev_change_flags+0x80/0x1b8
softirqs last disabled at (3248): [<c0982690>] dev_set_rx_mode+0x0/0x40
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 876 at kernel/softirq.c:362 
__local_bh_enable_ip+0x200/0x204
Modules linked in: hci_uart btbcm btintel brcmfmac bluetooth s5p_mfc 
s5p_csis s5p_fimc s5p_jpeg cfg80211 v4l2_mem2mem videobuf2_dma_contig 
videobuf2_memops exynos4_is_common videobuf2_v4l2 v4l2_fwnode 
videobuf2_common v4l2_async videodev ecdh_generic ecc brcmutil mc
CPU: 0 PID: 876 Comm: ip Tainted: G        W 
5.17.0-rc3-01145-gbaebdf48c360 #11325
Hardware name: Samsung Exynos (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0x238/0x23c
  __warn from warn_slowpath_fmt+0xac/0xb4
  warn_slowpath_fmt from __local_bh_enable_ip+0x200/0x204
  __local_bh_enable_ip from netif_rx+0x9c/0x28c
  netif_rx from rx_complete+0x12c/0x224
  rx_complete from dwc2_hsotg_complete_request+0x94/0x208
  dwc2_hsotg_complete_request from dwc2_hsotg_epint+0x9ac/0x1224
  dwc2_hsotg_epint from dwc2_hsotg_irq+0x264/0x1020
  dwc2_hsotg_irq from __handle_irq_event_percpu+0x74/0x3ac
  __handle_irq_event_percpu from handle_irq_event_percpu+0xc/0x38
  handle_irq_event_percpu from handle_irq_event+0x38/0x5c
  handle_irq_event from handle_fasteoi_irq+0xc4/0x180
  handle_fasteoi_irq from generic_handle_domain_irq+0x44/0x88
  generic_handle_domain_irq from gic_handle_irq+0x88/0xac
  gic_handle_irq from generic_handle_arch_irq+0x58/0x78
  generic_handle_arch_irq from __irq_svc+0x54/0x88
Exception stack(0xc3fb58e0 to 0xc3fb5928)
58e0: 00000000 c0f33a98 00000001 00000cbb 60000013 c2dc8730 c2dc875c 
00000cc0
5900: c2d2cc00 00000001 00000000 00000000 00000001 c3fb5930 c0b7dbc4 
c0b890d4
5920: 20000013 ffffffff
  __irq_svc from _raw_spin_unlock_irqrestore+0x2c/0x60
  _raw_spin_unlock_irqrestore from rx_fill+0x6c/0xa0
  rx_fill from eth_open+0x60/0x74
  eth_open from __dev_open+0xf0/0x174
  __dev_open from __dev_change_flags+0x16c/0x1b8
  __dev_change_flags from dev_change_flags+0x14/0x44
  dev_change_flags from do_setlink+0x33c/0xa3c
  do_setlink from __rtnl_newlink+0x524/0x80c
  __rtnl_newlink from rtnl_newlink+0x44/0x60
  rtnl_newlink from rtnetlink_rcv_msg+0x14c/0x4ec
  rtnetlink_rcv_msg from netlink_rcv_skb+0xdc/0x110
  netlink_rcv_skb from netlink_unicast+0x1ac/0x244
  netlink_unicast from netlink_sendmsg+0x328/0x448
  netlink_sendmsg from ____sys_sendmsg+0x1c4/0x220
  ____sys_sendmsg from ___sys_sendmsg+0x68/0x94
  ___sys_sendmsg from __sys_sendmsg+0x4c/0x88
  __sys_sendmsg from ret_fast_syscall+0x0/0x1c
Exception stack(0xc3fb5fa8 to 0xc3fb5ff0)
5fa0:                   beacb6dc beac3624 00000003 beac3630 00000000 
00000000
5fc0: beacb6dc beac3624 00000000 00000128 0054e304 386d3fd2 0054e000 
beac3630
5fe0: 0000006c beac35e0 00517f80 b6ea2ab8
irq event stamp: 3261
hardirqs last  enabled at (3259): [<c0b89104>] 
_raw_spin_unlock_irqrestore+0x5c/0x60
hardirqs last disabled at (3260): [<c0100aec>] __irq_svc+0x4c/0x88
softirqs last  enabled at (3250): [<c0982a90>] __dev_change_flags+0x80/0x1b8
softirqs last disabled at (3261): [<c097b808>] netif_rx+0x0/0x28c
---[ end trace 0000000000000000 ]---

The above log comes from Samsung Exynos4210-based Trats board (ARM32 
bit), but similar are triggered on other boards too.

> ---
>   drivers/net/amt.c          |  4 +--
>   drivers/net/geneve.c       |  4 +--
>   drivers/net/gtp.c          |  2 +-
>   drivers/net/loopback.c     |  4 +--
>   drivers/net/macsec.c       |  6 ++--
>   drivers/net/macvlan.c      |  4 +--
>   drivers/net/mhi_net.c      |  2 +-
>   drivers/net/ntb_netdev.c   |  2 +-
>   drivers/net/rionet.c       |  2 +-
>   drivers/net/sb1000.c       |  2 +-
>   drivers/net/veth.c         |  2 +-
>   drivers/net/vrf.c          |  2 +-
>   drivers/net/vxlan.c        |  2 +-
>   include/linux/netdevice.h  | 14 ++++++--
>   include/trace/events/net.h | 14 --------
>   net/core/dev.c             | 67 +++++++++++++++++---------------------
>   16 files changed, 60 insertions(+), 73 deletions(-)
>
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index f1a36d7e2151c..10455c9b9da0e 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -2373,7 +2373,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
>   	skb->pkt_type = PACKET_MULTICAST;
>   	skb->ip_summed = CHECKSUM_NONE;
>   	len = skb->len;
> -	if (netif_rx(skb) == NET_RX_SUCCESS) {
> +	if (__netif_rx(skb) == NET_RX_SUCCESS) {
>   		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
>   		dev_sw_netstats_rx_add(amt->dev, len);
>   	} else {
> @@ -2470,7 +2470,7 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
>   	skb->pkt_type = PACKET_MULTICAST;
>   	skb->ip_summed = CHECKSUM_NONE;
>   	len = skb->len;
> -	if (netif_rx(skb) == NET_RX_SUCCESS) {
> +	if (__netif_rx(skb) == NET_RX_SUCCESS) {
>   		amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_UPDATE,
>   					true);
>   		dev_sw_netstats_rx_add(amt->dev, len);
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index c1fdd721a730d..a895ff756093a 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -925,7 +925,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>   		}
>   
>   		skb->protocol = eth_type_trans(skb, geneve->dev);
> -		netif_rx(skb);
> +		__netif_rx(skb);
>   		dst_release(&rt->dst);
>   		return -EMSGSIZE;
>   	}
> @@ -1021,7 +1021,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>   		}
>   
>   		skb->protocol = eth_type_trans(skb, geneve->dev);
> -		netif_rx(skb);
> +		__netif_rx(skb);
>   		dst_release(dst);
>   		return -EMSGSIZE;
>   	}
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 24e5c54d06c15..bf087171bcf04 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -207,7 +207,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
>   
>   	dev_sw_netstats_rx_add(pctx->dev, skb->len);
>   
> -	netif_rx(skb);
> +	__netif_rx(skb);
>   	return 0;
>   
>   err:
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index ed0edf5884ef8..d05f86fe78c95 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -78,7 +78,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
>   
>   	skb_orphan(skb);
>   
> -	/* Before queueing this packet to netif_rx(),
> +	/* Before queueing this packet to __netif_rx(),
>   	 * make sure dst is refcounted.
>   	 */
>   	skb_dst_force(skb);
> @@ -86,7 +86,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
>   	skb->protocol = eth_type_trans(skb, dev);
>   
>   	len = skb->len;
> -	if (likely(netif_rx(skb) == NET_RX_SUCCESS))
> +	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
>   		dev_lstats_add(dev, len);
>   
>   	return NETDEV_TX_OK;
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 3d08743317634..832f09ac075e7 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1033,7 +1033,7 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>   				else
>   					nskb->pkt_type = PACKET_MULTICAST;
>   
> -				netif_rx(nskb);
> +				__netif_rx(nskb);
>   			}
>   			continue;
>   		}
> @@ -1056,7 +1056,7 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>   
>   		nskb->dev = ndev;
>   
> -		if (netif_rx(nskb) == NET_RX_SUCCESS) {
> +		if (__netif_rx(nskb) == NET_RX_SUCCESS) {
>   			u64_stats_update_begin(&secy_stats->syncp);
>   			secy_stats->stats.InPktsUntagged++;
>   			u64_stats_update_end(&secy_stats->syncp);
> @@ -1288,7 +1288,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
>   
>   		macsec_reset_skb(nskb, macsec->secy.netdev);
>   
> -		ret = netif_rx(nskb);
> +		ret = __netif_rx(nskb);
>   		if (ret == NET_RX_SUCCESS) {
>   			u64_stats_update_begin(&secy_stats->syncp);
>   			secy_stats->stats.InPktsUnknownSCI++;
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 6ef5f77be4d0a..d87c06c317ede 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -410,7 +410,7 @@ static void macvlan_forward_source_one(struct sk_buff *skb,
>   	if (ether_addr_equal_64bits(eth_hdr(skb)->h_dest, dev->dev_addr))
>   		nskb->pkt_type = PACKET_HOST;
>   
> -	ret = netif_rx(nskb);
> +	ret = __netif_rx(nskb);
>   	macvlan_count_rx(vlan, len, ret == NET_RX_SUCCESS, false);
>   }
>   
> @@ -468,7 +468,7 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
>   			/* forward to original port. */
>   			vlan = src;
>   			ret = macvlan_broadcast_one(skb, vlan, eth, 0) ?:
> -			      netif_rx(skb);
> +			      __netif_rx(skb);
>   			handle_res = RX_HANDLER_CONSUMED;
>   			goto out;
>   		}
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index aaa628f859fd4..0b1b6f650104b 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -225,7 +225,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>   		u64_stats_inc(&mhi_netdev->stats.rx_packets);
>   		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
>   		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> -		netif_rx(skb);
> +		__netif_rx(skb);
>   	}
>   
>   	/* Refill if RX buffers queue becomes low */
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
> index 98ca6b18415e7..80bdc07f2cd33 100644
> --- a/drivers/net/ntb_netdev.c
> +++ b/drivers/net/ntb_netdev.c
> @@ -119,7 +119,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
>   	skb->protocol = eth_type_trans(skb, ndev);
>   	skb->ip_summed = CHECKSUM_NONE;
>   
> -	if (netif_rx(skb) == NET_RX_DROP) {
> +	if (__netif_rx(skb) == NET_RX_DROP) {
>   		ndev->stats.rx_errors++;
>   		ndev->stats.rx_dropped++;
>   	} else {
> diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
> index 1a95f3beb784d..39e61e07e4894 100644
> --- a/drivers/net/rionet.c
> +++ b/drivers/net/rionet.c
> @@ -109,7 +109,7 @@ static int rionet_rx_clean(struct net_device *ndev)
>   		skb_put(rnet->rx_skb[i], RIO_MAX_MSG_SIZE);
>   		rnet->rx_skb[i]->protocol =
>   		    eth_type_trans(rnet->rx_skb[i], ndev);
> -		error = netif_rx(rnet->rx_skb[i]);
> +		error = __netif_rx(rnet->rx_skb[i]);
>   
>   		if (error == NET_RX_DROP) {
>   			ndev->stats.rx_dropped++;
> diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
> index 57a6d598467b2..c3f8020571add 100644
> --- a/drivers/net/sb1000.c
> +++ b/drivers/net/sb1000.c
> @@ -872,7 +872,7 @@ printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[3
>   
>   	/* datagram completed: send to upper level */
>   	skb_trim(skb, dlen);
> -	netif_rx(skb);
> +	__netif_rx(skb);
>   	stats->rx_bytes+=dlen;
>   	stats->rx_packets++;
>   	lp->rx_skb[ns] = NULL;
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 354a963075c5f..6754fb8d9fabc 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -286,7 +286,7 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
>   {
>   	return __dev_forward_skb(dev, skb) ?: xdp ?
>   		veth_xdp_rx(rq, skb) :
> -		netif_rx(skb);
> +		__netif_rx(skb);
>   }
>   
>   /* return true if the specified skb has chances of GRO aggregation
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index e0b1ab99a359e..714cafcf6c6c8 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -418,7 +418,7 @@ static int vrf_local_xmit(struct sk_buff *skb, struct net_device *dev,
>   
>   	skb->protocol = eth_type_trans(skb, dev);
>   
> -	if (likely(netif_rx(skb) == NET_RX_SUCCESS))
> +	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
>   		vrf_rx_stats(dev, len);
>   	else
>   		this_cpu_inc(dev->dstats->rx_drps);
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 359d16780dbbc..d0dc90d3dac28 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2541,7 +2541,7 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
>   	tx_stats->tx_bytes += len;
>   	u64_stats_update_end(&tx_stats->syncp);
>   
> -	if (netif_rx(skb) == NET_RX_SUCCESS) {
> +	if (__netif_rx(skb) == NET_RX_SUCCESS) {
>   		u64_stats_update_begin(&rx_stats->syncp);
>   		rx_stats->rx_packets++;
>   		rx_stats->rx_bytes += len;
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index e490b84732d16..c9e883104adb1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3669,8 +3669,18 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
>   void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
>   int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
>   int netif_rx(struct sk_buff *skb);
> -int netif_rx_ni(struct sk_buff *skb);
> -int netif_rx_any_context(struct sk_buff *skb);
> +int __netif_rx(struct sk_buff *skb);
> +
> +static inline int netif_rx_ni(struct sk_buff *skb)
> +{
> +	return netif_rx(skb);
> +}
> +
> +static inline int netif_rx_any_context(struct sk_buff *skb)
> +{
> +	return netif_rx(skb);
> +}
> +
>   int netif_receive_skb(struct sk_buff *skb);
>   int netif_receive_skb_core(struct sk_buff *skb);
>   void netif_receive_skb_list_internal(struct list_head *head);
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 78c448c6ab4c5..032b431b987b6 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -260,13 +260,6 @@ DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_entry,
>   	TP_ARGS(skb)
>   );
>   
> -DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_ni_entry,
> -
> -	TP_PROTO(const struct sk_buff *skb),
> -
> -	TP_ARGS(skb)
> -);
> -
>   DECLARE_EVENT_CLASS(net_dev_rx_exit_template,
>   
>   	TP_PROTO(int ret),
> @@ -312,13 +305,6 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_exit,
>   	TP_ARGS(ret)
>   );
>   
> -DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_ni_exit,
> -
> -	TP_PROTO(int ret),
> -
> -	TP_ARGS(ret)
> -);
> -
>   DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
>   
>   	TP_PROTO(int ret),
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0d13340ed4054..7d90f565e540a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4815,66 +4815,57 @@ static int netif_rx_internal(struct sk_buff *skb)
>   	return ret;
>   }
>   
> +/**
> + *	__netif_rx	-	Slightly optimized version of netif_rx
> + *	@skb: buffer to post
> + *
> + *	This behaves as netif_rx except that it does not disable bottom halves.
> + *	As a result this function may only be invoked from the interrupt context
> + *	(either hard or soft interrupt).
> + */
> +int __netif_rx(struct sk_buff *skb)
> +{
> +	int ret;
> +
> +	lockdep_assert_once(hardirq_count() | softirq_count());
> +
> +	trace_netif_rx_entry(skb);
> +	ret = netif_rx_internal(skb);
> +	trace_netif_rx_exit(ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL(__netif_rx);
> +
>   /**
>    *	netif_rx	-	post buffer to the network code
>    *	@skb: buffer to post
>    *
>    *	This function receives a packet from a device driver and queues it for
> - *	the upper (protocol) levels to process.  It always succeeds. The buffer
> - *	may be dropped during processing for congestion control or by the
> - *	protocol layers.
> + *	the upper (protocol) levels to process via the backlog NAPI device. It
> + *	always succeeds. The buffer may be dropped during processing for
> + *	congestion control or by the protocol layers.
> + *	The network buffer is passed via the backlog NAPI device. Modern NIC
> + *	driver should use NAPI and GRO.
> + *	This function can used from any context.
>    *
>    *	return values:
>    *	NET_RX_SUCCESS	(no congestion)
>    *	NET_RX_DROP     (packet was dropped)
>    *
>    */
> -
>   int netif_rx(struct sk_buff *skb)
>   {
>   	int ret;
>   
> +	local_bh_disable();
>   	trace_netif_rx_entry(skb);
> -
>   	ret = netif_rx_internal(skb);
>   	trace_netif_rx_exit(ret);
> -
> +	local_bh_enable();
>   	return ret;
>   }
>   EXPORT_SYMBOL(netif_rx);
>   
> -int netif_rx_ni(struct sk_buff *skb)
> -{
> -	int err;
> -
> -	trace_netif_rx_ni_entry(skb);
> -
> -	preempt_disable();
> -	err = netif_rx_internal(skb);
> -	if (local_softirq_pending())
> -		do_softirq();
> -	preempt_enable();
> -	trace_netif_rx_ni_exit(err);
> -
> -	return err;
> -}
> -EXPORT_SYMBOL(netif_rx_ni);
> -
> -int netif_rx_any_context(struct sk_buff *skb)
> -{
> -	/*
> -	 * If invoked from contexts which do not invoke bottom half
> -	 * processing either at return from interrupt or when softrqs are
> -	 * reenabled, use netif_rx_ni() which invokes bottomhalf processing
> -	 * directly.
> -	 */
> -	if (in_interrupt())
> -		return netif_rx(skb);
> -	else
> -		return netif_rx_ni(skb);
> -}
> -EXPORT_SYMBOL(netif_rx_any_context);
> -
>   static __latent_entropy void net_tx_action(struct softirq_action *h)
>   {
>   	struct softnet_data *sd = this_cpu_ptr(&softnet_data);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

