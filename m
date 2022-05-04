Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DBC51AE72
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 21:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377734AbiEDT6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 15:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377723AbiEDT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 15:58:13 -0400
Received: from mxout04.lancloud.ru (mxout04.lancloud.ru [45.84.86.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B704E3BC;
        Wed,  4 May 2022 12:54:34 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru E162820A3C1B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 4/9] ravb: Separate handling of irq enable/disable regs
 into feature
To:     Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-5-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <d260937a-63bd-e3af-a032-c0b8848a4025@omp.ru>
Date:   Wed, 4 May 2022 22:54:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-5-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 5:54 PM, Phil Edworthy wrote:

> Currently, when the HW has a single interrupt, the driver uses the
> TIC, RIC0 registers to enable and disable RX/TX interrupts. When
> the HW has multiple interrupts, it uses the TIE, TID, RIE0, RID0
> registers.
> 
> However, other devices, e.g. RZ/V2M, have multiple irqs and use
> the TIC, RIC0 registers.

   s/use/have only/?

> Therefore, split this into a separate feature.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 15aa09d93ff0..67a240665cd2 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1027,6 +1027,7 @@ struct ravb_hw_info {
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
>  	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
> +	unsigned irq_en_dis_regs:1;	/* Has separate irq enable and disable regs */

   Perhaps just irq_en_dis?

>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
>  	unsigned gptp_ptm_gic:1;	/* gPTP enables Presentation Time Match irq via GIC */
[...]

MBR, Sergey
