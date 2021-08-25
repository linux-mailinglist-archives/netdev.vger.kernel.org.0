Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D703F7D14
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbhHYUSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:18:37 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:38852 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhHYUSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:18:36 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru DB27020C01AF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 03/13] ravb: Add no_ptp_cfg_active to struct
 ravb_hw_info
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
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-4-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9264c6ca-7c98-d320-c808-1677fb62ed47@omp.ru>
Date:   Wed, 25 Aug 2021 23:17:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-4-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> There are some H/W differences for the gPTP feature between
> R-Car Gen3, R-Car Gen2, and RZ/G2L as below.
> 
> 1) On R-Car Gen2, gPTP support is not active in config mode.
> 2) On R-Car Gen3, gPTP support is active in config mode.
> 3) RZ/G2L does not support the gPTP feature.
> 
> Add a no_ptp_cfg_active hw feature bit to struct ravb_hw_info for
> handling gPTP for R-Car Gen2.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 20 ++++++++++++--------
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index da486e06b322..9ecf1a8c3ca8 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -998,6 +998,7 @@ struct ravb_hw_info {
>  	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
> +	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */

   Isn't this better to name it 'ptp_active_cfg' -- positive, instead of negative?

[...]

MBR, Sergey
