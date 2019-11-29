Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DF710DB6C
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfK2WHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 17:07:11 -0500
Received: from smtp11.iq.pl ([86.111.242.220]:54447 "EHLO smtp11.iq.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfK2WHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 17:07:11 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Nov 2019 17:07:08 EST
Received: from [192.168.2.111] (unknown [185.78.72.18])
        (Authenticated sender: pstaszewski@itcare.pl)
        by smtp.iq.pl (Postfix) with ESMTPSA id 47PpNT5Bj8z3xJC
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 23:00:41 +0100 (CET)
To:     netdev@vger.kernel.org
From:   =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>
Subject: Linux kernel - 5.4.0+ (net-next from 27.11.2019) routing/network
 performance
Message-ID: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
Date:   Fri, 29 Nov 2019 23:00:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As always - each year i need to summarize network performance for 
routing applications like linux router on native Linux kernel (without 
xdp/dpdk/vpp etc) :)

HW setup:

Server (Supermicro SYS-1019P-WTR)

1x Intel 6146

2x Mellanox connect-x 5 (100G) (installed in two different x16 pcie 
gen3.1 slots)

6x 8GB DDR4 2666 (it really matters cause 100G is about 12.5GB/s of 
memory bandwidth one direction)


And here it is:

perf top at 72Gbit.s RX and 72Gbit/s TX (at same time)

    PerfTop:   91202 irqs/sec  kernel:99.7%  exact: 100.0% [4000Hz 
cycles:ppp],  (all, 24 CPUs)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


      7.56%  [kernel]       [k] __dev_queue_xmit
      5.27%  [kernel]       [k] build_skb
      4.41%  [kernel]       [k] rr_transmit
      4.17%  [kernel]       [k] fib_table_lookup
      3.83%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
      3.30%  [kernel]       [k] mlx5e_sq_xmit
      3.14%  [kernel]       [k] __netif_receive_skb_core
      2.48%  [kernel]       [k] netif_skb_features
      2.36%  [kernel]       [k] _raw_spin_trylock
      2.27%  [kernel]       [k] dev_hard_start_xmit
      2.26%  [kernel]       [k] dev_gro_receive
      2.20%  [kernel]       [k] mlx5e_handle_rx_cqe_mpwrq
      1.92%  [kernel]       [k] mlx5_eq_comp_int
      1.91%  [kernel]       [k] mlx5e_poll_tx_cq
      1.74%  [kernel]       [k] tcp_gro_receive
      1.68%  [kernel]       [k] memcpy_erms
      1.64%  [kernel]       [k] kmem_cache_free_bulk
      1.57%  [kernel]       [k] inet_gro_receive
      1.55%  [kernel]       [k] netdev_pick_tx
      1.52%  [kernel]       [k] ip_forward
      1.45%  [kernel]       [k] team_xmit
      1.40%  [kernel]       [k] vlan_do_receive
      1.37%  [kernel]       [k] team_handle_frame
      1.36%  [kernel]       [k] __build_skb
      1.33%  [kernel]       [k] ipt_do_table
      1.33%  [kernel]       [k] mlx5e_poll_rx_cq
      1.28%  [kernel]       [k] ip_finish_output2
      1.26%  [kernel]       [k] vlan_passthru_hard_header
      1.20%  [kernel]       [k] netdev_core_pick_tx
      0.93%  [kernel]       [k] ip_rcv_core.isra.22.constprop.27
      0.87%  [kernel]       [k] validate_xmit_skb.isra.148
      0.87%  [kernel]       [k] ip_route_input_rcu
      0.78%  [kernel]       [k] kmem_cache_alloc
      0.77%  [kernel]       [k] mlx5e_handle_rx_dim
      0.71%  [kernel]       [k] iommu_need_mapping
      0.69%  [kernel]       [k] tasklet_action_common.isra.21
      0.66%  [kernel]       [k] mlx5e_xmit
      0.65%  [kernel]       [k] mlx5e_post_rx_mpwqes
      0.63%  [kernel]       [k] _raw_spin_lock
      0.61%  [kernel]       [k] ip_sublist_rcv
      0.57%  [kernel]       [k] skb_release_data
      0.53%  [kernel]       [k] __local_bh_enable_ip
      0.53%  [kernel]       [k] tcp4_gro_receive
      0.51%  [kernel]       [k] pfifo_fast_dequeue
      0.51%  [kernel]       [k] page_frag_free
      0.50%  [kernel]       [k] kmem_cache_free
      0.47%  [kernel]       [k] dma_direct_map_page
      0.45%  [kernel]       [k] native_irq_return_iret
      0.44%  [kernel]       [k] __slab_free.isra.89
      0.43%  [kernel]       [k] skb_gro_receive
      0.43%  [kernel]       [k] napi_gro_receive
      0.43%  [kernel]       [k] __do_softirq
      0.41%  [kernel]       [k] sch_direct_xmit
      0.41%  [kernel]       [k] ip_rcv_finish_core.isra.19
      0.40%  [kernel]       [k] skb_network_protocol
      0.40%  [kernel]       [k] __get_xps_queue_idx


Im useing team (2x 100G LAG)- that is why here is some load:

      4.41%  [kernel]       [k] rr_transmit



No discards on interfaces:

ethtool -S enp179s0f0 | grep disc
      rx_discards_phy: 0
      tx_discards_phy: 0

ethtool -S enp179s0f1 | grep disc
      rx_discards_phy: 0
      tx_discards_phy: 0

io/stream test at 72G/72G traffic:

-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:           38948.8     0.004368     0.004108     0.004533
Scale:          37914.6     0.004473     0.004220     0.004802
Add:            43134.6     0.005801     0.005564     0.006086
Triad:          42934.1     0.005696     0.005590     0.005901
-------------------------------------------------------------


And some links to screenshoots

Softirqs

https://pasteboard.co/IIZkGrw.png

And bandwidth / cpu / pps grapsh

https://pasteboard.co/IIZl6XP.png


Currently it looks like the biggest problem for 100G is cpu->mem->nic 
bandwidth or nic doorbell / page cache at RX processing - cause what i 
can see is that if I run iperf on this host i can TX full 100G - but I 
cant RX 100G when i flood this host from some packet generator (it will 
start to drop packets at arount 82Gbit/s) - and this is not a problem 
with ppp but it is bandwidth problem.

For example i can flood RX with 14Mpps or 64b packets without nic 
discards but i cant flood it with 1000b frames and same pps - cause when 
it reaches 82Gbit/s nic's start to report discards.


Thanks



-- 
Paweł Staszewski

