Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331383A8D03
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhFOX6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:58:38 -0400
Received: from smtp.lucas.inf.br ([177.190.248.62]:36476 "EHLO
        smtp.lucas.inf.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhFOX6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:58:37 -0400
Received: from [192.168.5.2] (unknown [177.101.131.138])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: lucas)
        by smtp.lucas.inf.br (Postfix) with ESMTPSA id D3C7010C9778
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 20:56:30 -0300 (-03)
Authentication-Results: lucas.inf.br; dmarc=fail (p=reject dis=none) header.from=lucas.inf.br
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucas.inf.br; s=mail;
        t=1623801390; bh=oeOZzcsOVWJJ6Vesk3d8u/D5DE8aqYTuH6z7Y1yW3EA=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=b9P4J0mle52vkmkai634JlHBZatkgkG4gGGyJa1dxmC88oZN8vr2KpjpcY7hZ1tp2
         kaOhfTqSYSDWSCF1929odz/yrN5RXoxPzMX330kJyycr1rPOXh4N0WaPutIoeBd4XU
         SI6C+YXR7OIWm+q9BqsQ0bcmKGp+fEKAIjq2jcer64V4fFIPtIb30xOI9GsKAXbkKv
         r55mlYblxwk6m4viD4P20YaRTAWBfRpR0lzW0Cfs+mJy+u8HVG3FafxC0LH/Ba16E0
         1tmKm939C2SpIleWtEzfYCTdg+kh70vvIrxDII8irwlPsvdSoFq/LAj2+nKi87Bhui
         LVLS9n/IfJkAg==
Subject: Re: Strange dropped packets results in TC
From:   Lucas Bocchi <lucas@lucas.inf.br>
To:     netdev@vger.kernel.org
References: <aee69c28-2cd1-1b0c-05db-88697db2dbd2@lucas.inf.br>
Message-ID: <8d52ffbb-eb21-2d74-071b-4a29c4d851e3@lucas.inf.br>
Date:   Tue, 15 Jun 2021 20:56:31 -0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <aee69c28-2cd1-1b0c-05db-88697db2dbd2@lucas.inf.br>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pt-BR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

P.S: The kernel is two machines is 5.12.10

Please, if it's the wrong list, advise me.

Thanks for the patience


Em 15/06/2021 09:49, Lucas Bocchi escreveu:
> Hello Folks
>
> We have a little doubt about dropped packets in tc util. As you see, 
> my interface doesn't show any dropped packets in ethtool or in kernel 
> statistics, but in tc is showed dropped packets. And that ocurrs in 
> two different servers, with two different network interface / queue 
> disciplines.
>
> The kernel
>
> Server 1 - Intel IXGBE Driver with Intel Corporation 82599ES 
> 10-Gigabit SFI/SFP+ Network Card and TP-LINK TL-SM321B Transceiver
>
> Transceiver Statistics:
>
>  ethtool -m enp1s0f0
>         Identifier                                : 0x03 (SFP)
>         Extended identifier                       : 0x04 (GBIC/SFP 
> defined by 2-wire interface ID)
>         Connector                                 : 0x07 (LC)
>         Transceiver codes                         : 0x00 0x00 0x00 
> 0x02 0x82 0x00 0x01 0x01 0x00
>         Transceiver type                          : Ethernet: 1000BASE-LX
>         Transceiver type                          : FC: very long 
> distance (V)
>         Transceiver type                          : FC: Longwave laser 
> (LC)
>         Transceiver type                          : FC: Single Mode (SM)
>         Transceiver type                          : FC: 100 MBytes/sec
>         Encoding                                  : 0x01 (8B/10B)
>         BR, Nominal                               : 1300MBd
>         Rate identifier                           : 0x00 (unspecified)
>         Length (SMF,km)                           : 20km
>         Length (SMF)                              : 20000m
>         Length (50um)                             : 0m
>         Length (62.5um)                           : 0m
>         Length (Copper)                           : 0m
>         Length (OM3)                              : 0m
>         Laser wavelength                          : 1310nm
>         Vendor name                               : TP-LINK
>         Vendor OUI                                : 00:00:00
>         Vendor PN                                 : TL-SM321B
>         Vendor rev                                : 1.1
>         Option values                             : 0x00 0x1a
>         Option                                    : RX_LOS implemented
>         Option                                    : TX_FAULT implemented
>         Option                                    : TX_DISABLE 
> implemented
>         BR margin, max                            : 0%
>         BR margin, min                            : 0%
>         Vendor SN                                 : 35704205710058
>         Date code                                 : 170517
>
>
> Ethtool Statistic
>
> NIC statistics:
>      rx_packets: 1830508376
>      tx_packets: 2095191306
>      rx_bytes: 1559661300658
>      tx_bytes: 1796376456250
>      rx_pkts_nic: 1830508375
>      tx_pkts_nic: 2095191306
>      rx_bytes_nic: 1566983334162
>      tx_bytes_nic: 1806513286636
>      lsc_int: 1
>      tx_busy: 0
>      non_eop_descs: 0
>      rx_errors: 0
>      tx_errors: 0 // No TX Error
>      rx_dropped: 55706
>      tx_dropped: 0 // No dropped Packets
>      multicast: 55706
>      broadcast: 45
>      rx_no_buffer_count: 0
>      collisions: 0
>      rx_over_errors: 0
>      rx_crc_errors: 0
>      rx_frame_errors: 0
>      hw_rsc_aggregated: 0
>      hw_rsc_flushed: 0
>      fdir_match: 1335933692
>      fdir_miss: 548533583
>      fdir_overflow: 888
>      rx_fifo_errors: 0
>      rx_missed_errors: 0
>      tx_aborted_errors: 0
>      tx_carrier_errors: 0
>      tx_fifo_errors: 0
>      tx_heartbeat_errors: 0
>      tx_timeout_count: 0
>      tx_restart_queue: 0
>      rx_length_errors: 0
>      rx_long_length_errors: 0
>      rx_short_length_errors: 0
>      tx_flow_control_xon: 0
>      rx_flow_control_xon: 0
>      tx_flow_control_xoff: 0
>      rx_flow_control_xoff: 0
>      rx_csum_offload_errors: 87755
>      alloc_rx_page: 184014
>      alloc_rx_page_failed: 0
>      alloc_rx_buff_failed: 0
>      rx_no_dma_resources: 0
>      os2bmc_rx_by_bmc: 0
>      os2bmc_tx_by_bmc: 0
>      os2bmc_tx_by_host: 0
>      os2bmc_rx_by_host: 0
>      tx_hwtstamp_timeouts: 0
>      tx_hwtstamp_skipped: 0
>      rx_hwtstamp_cleared: 0
>      tx_ipsec: 0
>      rx_ipsec: 0
>      fcoe_bad_fccrc: 0
>      rx_fcoe_dropped: 0
>      rx_fcoe_packets: 0
>      rx_fcoe_dwords: 0
>      fcoe_noddp: 0
>      fcoe_noddp_ext_buff: 0
>      tx_fcoe_packets: 0
>      tx_fcoe_dwords: 0
>      tx_queue_0_packets: 293242265
>      tx_queue_0_bytes: 247153468767
>      tx_queue_1_packets: 288898419
>      tx_queue_1_bytes: 245035641991
>      tx_queue_2_packets: 291236572
>      tx_queue_2_bytes: 249561212685
>      tx_queue_3_packets: 39837597
>      tx_queue_3_bytes: 2358074882
>      tx_queue_4_packets: 307730121
>      tx_queue_4_bytes: 264761824523
>      tx_queue_5_packets: 317352090
>      tx_queue_5_bytes: 277380973829
>      tx_queue_6_packets: 300122596
>      tx_queue_6_bytes: 258114228358
>      tx_queue_7_packets: 256771646
>      tx_queue_7_bytes: 252011031215
> ...
>      rx_queue_0_packets: 251550997
>      rx_queue_0_bytes: 212000117060
>      rx_queue_1_packets: 253297759
>      rx_queue_1_bytes: 210961040647
>      rx_queue_2_packets: 254114246
>      rx_queue_2_bytes: 218970216150
>      rx_queue_3_packets: 71013743
>      rx_queue_3_bytes: 23381820239
>      rx_queue_4_packets: 267448221
>      rx_queue_4_bytes: 236201977962
>      rx_queue_5_packets: 281248119
>      rx_queue_5_bytes: 232497403664
>      rx_queue_6_packets: 262045046
>      rx_queue_6_bytes: 223232203577
>      rx_queue_7_packets: 189790245
>      rx_queue_7_bytes: 202416521359
> ...
>
> ip statistics
>
>  ip -s -s addr show dev enp1s0f0
> 4: enp1s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc multiq 
> state UP group default qlen 1000
>     link/ether 90:e2:ba:89:11:70 brd ff:ff:ff:ff:ff:ff
>     inet 187.60.215.230/30 brd 187.60.215.231 scope global enp1s0f0
>        valid_lft forever preferred_lft forever
>     inet6 2804:6fc:1:10::66/126 scope global
>        valid_lft forever preferred_lft forever
>     inet6 fe80::92e2:baff:fe89:1170/64 scope link
>        valid_lft forever preferred_lft forever
>     RX: bytes  packets  errors  dropped missed  mcast
>     1563726136109 1835102960 0       55846   0       55845
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     1799499580192 2099722447 0       0       0       0  // No packet 
> dropped
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       2
>
>
> tc qdisc
>
> tc -s qdisc ls dev enp1s0f0
> qdisc multiq 8003: root refcnt 65 bands 8/64
>  Sent 1760376270449 bytes 2048050689 pkt (dropped 69, overlimits 0 
> requeues 477)
>  backlog 0b 0p requeues 477
>
> tc -s class ls dev enp1s0f0
> class multiq 8003:1 parent 8003:
>  Sent 242641753495 bytes 286672005 pkt (dropped 15, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:2 parent 8003:
>  Sent 241001820689 bytes 282960042 pkt (dropped 0, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:3 parent 8003:
>  Sent 244006535406 bytes 284363659 pkt (dropped 0, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:4 parent 8003:
>  Sent 2290044667 bytes 39029076 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:5 parent 8003:
>  Sent 260775212492 bytes 301997242 pkt (dropped 0, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:6 parent 8003:
>  Sent 271403512839 bytes 309429699 pkt (dropped 54, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:7 parent 8003:
>  Sent 252190559164 bytes 292911989 pkt (dropped 0, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
> class multiq 8003:8 parent 8003:
>  Sent 245887513841 bytes 250404773 pkt (dropped 0, overlimits 0 
> requeues 0)
>  backlog 0b 0p requeues 0
>
>
> Server 2 - Intel Corporation Ethernet Connection (12) I219-V
>
> ethtool -S eno1
> NIC statistics:
>      rx_packets: 16327063
>      tx_packets: 8024473
>      rx_bytes: 22725903298
>      tx_bytes: 3014818845
>      rx_broadcast: 2598
>      tx_broadcast: 1
>      rx_multicast: 0
>      tx_multicast: 7
>      rx_errors: 0
>      tx_errors: 0
>      tx_dropped: 0 // No Dropped or error in TX
>      multicast: 0
>      collisions: 0
>      rx_length_errors: 0
>      rx_over_errors: 0
>      rx_crc_errors: 0
>      rx_frame_errors: 0
>      rx_no_buffer_count: 0
>      rx_missed_errors: 0
>      tx_aborted_errors: 0
>      tx_carrier_errors: 0
>      tx_fifo_errors: 0
>      tx_heartbeat_errors: 0
>      tx_window_errors: 0
>      tx_abort_late_coll: 0
>      tx_deferred_ok: 0
>      tx_single_coll_ok: 0
>      tx_multi_coll_ok: 0
>      tx_timeout_count: 0
>      tx_restart_queue: 0
>      rx_long_length_errors: 0
>      rx_short_length_errors: 0
>      rx_align_errors: 0
>      tx_tcp_seg_good: 0
>      tx_tcp_seg_failed: 0
>      rx_flow_control_xon: 0
>      rx_flow_control_xoff: 0
>      tx_flow_control_xon: 0
>      tx_flow_control_xoff: 0
>      rx_csum_offload_good: 0
>      rx_csum_offload_errors: 0
>      rx_header_split: 0
>      alloc_rx_buff_failed: 0
>      tx_smbus: 0
>      rx_smbus: 0
>      dropped_smbus: 0
>      rx_dma_failed: 0
>      tx_dma_failed: 0
>      rx_hwtstamp_cleared: 0
>      uncorr_ecc_errors: 0
>      corr_ecc_errors: 0
>      tx_hwtstamp_timeouts: 0
>      tx_hwtstamp_skipped: 0
>
> ip statistics
>
> 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo state 
> UP mode DEFAULT group default qlen 1000
>     link/ether a8:a1:59:5a:56:e7 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped missed  mcast
>     22738286184 16335559 0       2600    0       0
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     3015100201 8026007  0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       2
>     altname enp0s31f6
>
> tc statistic
>
>  tc -s qdisc ls dev eno1
> qdisc pfifo 8002: root refcnt 2 limit 1000p
>  Sent 2982635243 bytes 8027086 pkt (dropped 247, overlimits 0 requeues 
> 4254)
>  backlog 0b 0p requeues 4254
>
> Any tip to try to identify that problem?
