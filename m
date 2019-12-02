Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2910E83E
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfLBKKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:10:18 -0500
Received: from smtp11.iq.pl ([86.111.242.220]:58868 "EHLO smtp11.iq.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfLBKKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 05:10:18 -0500
Received: from [192.168.2.111] (unknown [185.78.72.18])
        (Authenticated sender: pstaszewski@itcare.pl)
        by smtp.iq.pl (Postfix) with ESMTPSA id 47RLTJ5gmRz3xDD;
        Mon,  2 Dec 2019 11:10:12 +0100 (CET)
Subject: Re: Linux kernel - 5.4.0+ (net-next from 27.11.2019) routing/network
 performance
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
 <589d2715-80ae-0478-7e31-342060519320@gmail.com>
From:   =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>
Message-ID: <8e17a844-e98b-59b1-5a0e-669562b3178c@itcare.pl>
Date:   Mon, 2 Dec 2019 11:09:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <589d2715-80ae-0478-7e31-342060519320@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 01.12.2019 o 17:05, David Ahern pisze:
> On 11/29/19 4:00 PM, Paweł Staszewski wrote:
>> As always - each year i need to summarize network performance for
>> routing applications like linux router on native Linux kernel (without
>> xdp/dpdk/vpp etc) :)
>>
> Do you keep past profiles? How does this profile (and traffic rates)
> compare to older kernels - e.g., 5.0 or 4.19?
>
>
Yes - so for 4.19:

Max bandwidth was about 40-42Gbit/s RX / 40-42Gbit/s TX of 
forwarded(routed) traffic

And after "order-0 pages" patches - max was 50Gbit/s RX + 50Gbit/s TX 
(forwarding - bandwidth max)

(current kernel almost doubled this)

And also old perf top (from kernel 4.19) - before "order-0 pages patch":

    PerfTop:  108490 irqs/sec  kernel:99.6%  exact:  0.0% [4000Hz 
cycles],  (all, 56 CPUs)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


     26.78%  [kernel]       [k] queued_spin_lock_slowpath
      9.09%  [kernel]       [k] mlx5e_skb_from_cqe_linear
      4.94%  [kernel]       [k] mlx5e_sq_xmit
      3.63%  [kernel]       [k] memcpy_erms
      3.30%  [kernel]       [k] fib_table_lookup
      3.26%  [kernel]       [k] build_skb
      2.41%  [kernel]       [k] mlx5e_poll_tx_cq
      2.11%  [kernel]       [k] get_page_from_freelist
      1.51%  [kernel]       [k] vlan_do_receive
      1.51%  [kernel]       [k] _raw_spin_lock
      1.43%  [kernel]       [k] __dev_queue_xmit
      1.41%  [kernel]       [k] dev_gro_receive
      1.34%  [kernel]       [k] mlx5e_poll_rx_cq
      1.26%  [kernel]       [k] tcp_gro_receive
      1.21%  [kernel]       [k] free_one_page
      1.13%  [kernel]       [k] swiotlb_map_page
      1.13%  [kernel]       [k] mlx5e_post_rx_wqes
      1.05%  [kernel]       [k] pfifo_fast_dequeue
      1.05%  [kernel]       [k] mlx5e_handle_rx_cqe
      1.03%  [kernel]       [k] ip_finish_output2
      1.02%  [kernel]       [k] ipt_do_table
      0.96%  [kernel]       [k] inet_gro_receive
      0.91%  [kernel]       [k] mlx5_eq_int
      0.88%  [kernel]       [k] __slab_free.isra.79
      0.86%  [kernel]       [k] __build_skb
      0.84%  [kernel]       [k] page_frag_free
      0.76%  [kernel]       [k] skb_release_data
      0.75%  [kernel]       [k] __netif_receive_skb_core
      0.75%  [kernel]       [k] irq_entries_start
      0.71%  [kernel]       [k] ip_route_input_rcu
      0.65%  [kernel]       [k] vlan_dev_hard_start_xmit
      0.56%  [kernel]       [k] ip_forward
      0.56%  [kernel]       [k] __memcpy
      0.52%  [kernel]       [k] kmem_cache_alloc
      0.52%  [kernel]       [k] kmem_cache_free_bulk
      0.49%  [kernel]       [k] mlx5e_page_release
      0.47%  [kernel]       [k] netif_skb_features
      0.47%  [kernel]       [k] mlx5e_build_rx_skb
      0.47%  [kernel]       [k] dev_hard_start_xmit
      0.43%  [kernel]       [k] __page_pool_put_page
      0.43%  [kernel]       [k] __netif_schedule
      0.43%  [kernel]       [k] mlx5e_xmit
      0.41%  [kernel]       [k] __qdisc_run
      0.41%  [kernel]       [k] validate_xmit_skb.isra.142
      0.41%  [kernel]       [k] swiotlb_unmap_page
      0.40%  [kernel]       [k] inet_lookup_ifaddr_rcu
      0.34%  [kernel]       [k] ip_rcv_core.isra.20.constprop.25
      0.34%  [kernel]       [k] tcp4_gro_receive
      0.29%  [kernel]       [k] _raw_spin_lock_irqsave
      0.29%  [kernel]       [k] napi_consume_skb
      0.29%  [kernel]       [k] skb_gro_receive
      0.29%  [kernel]       [k] ___slab_alloc.isra.80
      0.27%  [kernel]       [k] eth_type_trans
      0.26%  [kernel]       [k] __free_pages_ok
      0.26%  [kernel]       [k] __get_xps_queue_idx
      0.24%  [kernel]       [k] _raw_spin_trylock
      0.23%  [kernel]       [k] __local_bh_enable_ip
      0.22%  [kernel]       [k] pfifo_fast_enqueue
      0.21%  [kernel]       [k] tasklet_action_common.isra.21
      0.21%  [kernel]       [k] sch_direct_xmit
      0.21%  [kernel]       [k] skb_network_protocol
      0.21%  [kernel]       [k] kmem_cache_free
      0.20%  [kernel]       [k] netdev_pick_tx
      0.18%  [kernel]       [k] napi_gro_complete
      0.18%  [kernel]       [k] __sched_text_start
      0.18%  [kernel]       [k] mlx5e_xdp_handle
      0.17%  [kernel]       [k] ip_finish_output
      0.16%  [kernel]       [k] napi_gro_flush
      0.16%  [kernel]       [k] vlan_passthru_hard_header
      0.16%  [kernel]       [k] skb_segment
      0.15%  [kernel]       [k] __alloc_pages_nodemask
      0.15%  [kernel]       [k] mlx5e_features_check
      0.15%  [kernel]       [k] mlx5e_napi_poll
      0.15%  [kernel]       [k] napi_gro_receive
      0.14%  [kernel]       [k] fib_validate_source
      0.14%  [kernel]       [k] _raw_spin_lock_irq
      0.14%  [kernel]       [k] inet_gro_complete
      0.14%  [kernel]       [k] get_partial_node.isra.78
      0.13%  [kernel]       [k] napi_complete_done
      0.13%  [kernel]       [k] ip_rcv_finish_core.isra.17
      0.13%  [kernel]       [k] cmd_exec


After "order-0 pages" patch

    PerfTop:  104692 irqs/sec  kernel:99.5%  exact:  0.0% [4000Hz 
cycles],  (all, 56 CPUs)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


      9.06%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
      6.43%  [kernel]       [k] tasklet_action_common.isra.21
      5.68%  [kernel]       [k] fib_table_lookup
      4.89%  [kernel]       [k] irq_entries_start
      4.53%  [kernel]       [k] mlx5_eq_int
      4.10%  [kernel]       [k] build_skb
      3.39%  [kernel]       [k] mlx5e_poll_tx_cq
      3.38%  [kernel]       [k] mlx5e_sq_xmit
      2.73%  [kernel]       [k] mlx5e_poll_rx_cq
      2.18%  [kernel]       [k] __dev_queue_xmit
      2.13%  [kernel]       [k] vlan_do_receive
      2.12%  [kernel]       [k] mlx5e_handle_rx_cqe_mpwrq
      2.00%  [kernel]       [k] ip_finish_output2
      1.87%  [kernel]       [k] mlx5e_post_rx_mpwqes
      1.86%  [kernel]       [k] memcpy_erms
      1.85%  [kernel]       [k] ipt_do_table
      1.70%  [kernel]       [k] dev_gro_receive
      1.39%  [kernel]       [k] __netif_receive_skb_core
      1.31%  [kernel]       [k] inet_gro_receive
      1.21%  [kernel]       [k] ip_route_input_rcu
      1.21%  [kernel]       [k] tcp_gro_receive
      1.13%  [kernel]       [k] _raw_spin_lock
      1.08%  [kernel]       [k] __build_skb
      1.06%  [kernel]       [k] kmem_cache_free_bulk
      1.05%  [kernel]       [k] __softirqentry_text_start
      1.03%  [kernel]       [k] vlan_dev_hard_start_xmit
      0.98%  [kernel]       [k] pfifo_fast_dequeue
      0.95%  [kernel]       [k] mlx5e_xmit
      0.95%  [kernel]       [k] page_frag_free
      0.88%  [kernel]       [k] ip_forward
      0.81%  [kernel]       [k] dev_hard_start_xmit
      0.78%  [kernel]       [k] rcu_irq_exit
      0.77%  [kernel]       [k] netif_skb_features
      0.72%  [kernel]       [k] napi_complete_done
      0.72%  [kernel]       [k] kmem_cache_alloc
      0.68%  [kernel]       [k] validate_xmit_skb.isra.142
      0.66%  [kernel]       [k] ip_rcv_core.isra.20.constprop.25
      0.58%  [kernel]       [k] swiotlb_map_page
      0.57%  [kernel]       [k] __qdisc_run
      0.56%  [kernel]       [k] tasklet_action
      0.54%  [kernel]       [k] __get_xps_queue_idx
      0.54%  [kernel]       [k] inet_lookup_ifaddr_rcu
      0.50%  [kernel]       [k] tcp4_gro_receive
      0.49%  [kernel]       [k] skb_release_data
      0.47%  [kernel]       [k] eth_type_trans
      0.40%  [kernel]       [k] sch_direct_xmit
      0.40%  [kernel]       [k] net_rx_action
      0.39%  [kernel]       [k] __local_bh_enable_ip


>> HW setup:
>>
>> Server (Supermicro SYS-1019P-WTR)
>>
>> 1x Intel 6146
>>
>> 2x Mellanox connect-x 5 (100G) (installed in two different x16 pcie
>> gen3.1 slots)
>>
>> 6x 8GB DDR4 2666 (it really matters cause 100G is about 12.5GB/s of
>> memory bandwidth one direction)
>>
>>
>> And here it is:
>>
>> perf top at 72Gbit.s RX and 72Gbit/s TX (at same time)
>>
>>     PerfTop:   91202 irqs/sec  kernel:99.7%  exact: 100.0% [4000Hz
>> cycles:ppp],  (all, 24 CPUs)
>> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>>
>>       7.56%  [kernel]       [k] __dev_queue_xmit
>>       5.27%  [kernel]       [k] build_skb
>>       4.41%  [kernel]       [k] rr_transmit
>>       4.17%  [kernel]       [k] fib_table_lookup
>>       3.83%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
>>       3.30%  [kernel]       [k] mlx5e_sq_xmit
>>       3.14%  [kernel]       [k] __netif_receive_skb_core
>>       2.48%  [kernel]       [k] netif_skb_features
>>       2.36%  [kernel]       [k] _raw_spin_trylock
>>       2.27%  [kernel]       [k] dev_hard_start_xmit

-- 
Paweł Staszewski

