Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEC1417BD7
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 21:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345854AbhIXThW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 15:37:22 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:51002 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344824AbhIXThV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 15:37:21 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 1C1E2209D6E7
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 11/18] ravb: Add rx_2k_buffers to struct ravb_hw_info
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
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-12-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <1e9d1d3c-0846-077e-8e1a-e06ff86c00fa@omp.ru>
Date:   Fri, 24 Sep 2021 22:35:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-12-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:08 PM, Biju Das wrote:

> R-Car AVB-DMAC has Maximum 2K size on RZ buffer.
> We need to Allow for changing the MTU within the
> limit of the maximum size of a descriptor (2048 bytes).
> 
> Add a rx_2k_buffers hw feature bit to struct ravb_hw_info
> to add this constraint only for R-Car.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 7532cb51d7b8..ab4909244276 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1033,6 +1033,7 @@ struct ravb_hw_info {
>  	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
>  	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */
>  	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
> +	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX */

   It seems more flexible to specify the buffer size, not just a bit like this...

[...]

MBR, Sergey
