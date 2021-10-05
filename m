Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4814225C4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhJEL4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:56:32 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:55634 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhJEL4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:56:31 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru A42BA20E8DEC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 00/12] Add functional support for Gigabit Ethernet driver
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <0239b412-c769-747b-4ac8-88d2bbb5f0c2@omp.ru>
Date:   Tue, 5 Oct 2021 14:54:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

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
> by filling all the stubs.
> 
> Ref:-
> https://lore.kernel.org/linux-renesas-soc/OS0PR01MB5922240F88E5E0FD989ECDF386AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com/T/#m8dee0a1b14d505d4611cad8c10e4017a30db55d6
> 
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
> Biju Das (12):
>   ravb: Use ALIGN macro for max_rx_len
>   ravb: Add rx_max_buf_size to struct ravb_hw_info
>   ravb: Fillup ravb_set_features_gbeth() stub
>   ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
>   ravb: Fillup ravb_rx_ring_free_gbeth() stub
>   ravb: Fillup ravb_rx_ring_format_gbeth() stub
>   ravb: Fillup ravb_rx_gbeth() stub
>   ravb: Add carrier_counters to struct ravb_hw_info
>   ravb: Add support to retrieve stats for GbEthernet
>   ravb: Rename "tsrq" variable
>   ravb: Optimize ravb_emac_init_gbeth function
>   ravb: Update/Add comments
> 
>  drivers/net/ethernet/renesas/ravb.h      |  51 +++-
>  drivers/net/ethernet/renesas/ravb_main.c | 349 +++++++++++++++++++++--
>  2 files changed, 367 insertions(+), 33 deletions(-)

   I dodn;'t expect the patchset to be reposted so soon but I'll switch
to reviewing it insted of the previously posted 8-patch series...

MBR, Sergey
