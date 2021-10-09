Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712CE427D1A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhJIT34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:29:56 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:34854 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJIT3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 15:29:55 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 43A00205FD38
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
Date:   Sat, 9 Oct 2021 22:27:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/21 10:07 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> With a few changes in the driver we can support both IPs.
> 
> This patch series is aims to add functional support for Gigabit Ethernet driver
> by filling all the stubs except set_features.
> 
> set_feature patch will send as separate RFC patch along with rx_checksum
> patch, as it needs detailed discussion related to HW checksum.
> 
> Ref:-
>  https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=557655
> 
> RFC->V1:
>  * Removed patch#3 will send it as RFC
>  * Removed rx_csum functionality from patch#7, will send it as RFC
>  * Renamed "nc_queue" -> "nc_queues"
>  * Separated the comment patch into 2 separate patches.
>  * Documented PFRI register bit
>  * Added Sergy's Rb tag

   It's Sergey. :-)

> RFC changes:
>  * used ALIGN macro for calculating the value for max_rx_len.
>  * used rx_max_buf_size instead of rx_2k_buffers feature bit.
>  * moved struct ravb_rx_desc *gbeth_rx_ring near to ravb_private::rx_ring
>    and allocating it for 1 RX queue.
>  * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
>  * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
>  * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
>  * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
>  * renamed ravb_rcar_rx to ravb_rx_rcar
>  * renamed "tsrq" variable
>  * Updated the comments
> 
> Biju Das (14):
>   ravb: Use ALIGN macro for max_rx_len
>   ravb: Add rx_max_buf_size to struct ravb_hw_info
>   ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
>   ravb: Fillup ravb_rx_ring_free_gbeth() stub
>   ravb: Fillup ravb_rx_ring_format_gbeth() stub
>   ravb: Fillup ravb_rx_gbeth() stub
>   ravb: Add carrier_counters to struct ravb_hw_info
>   ravb: Add support to retrieve stats for GbEthernet
>   ravb: Rename "tsrq" variable
>   ravb: Optimize ravb_emac_init_gbeth function
>   ravb: Rename "nc_queue" feature bit
>   ravb: Document PFRI register bit
>   ravb: Update EMAC configuration mode comment
>   ravb: Fix typo AVB->DMAC
> 
>  drivers/net/ethernet/renesas/ravb.h      |  17 +-
>  drivers/net/ethernet/renesas/ravb_main.c | 325 +++++++++++++++++++----
>  2 files changed, 291 insertions(+), 51 deletions(-)

   DaveM, I'm going to review this patch series (starting on Monday). Is that acceptable forewarning? :-)

MBR, Sergey
