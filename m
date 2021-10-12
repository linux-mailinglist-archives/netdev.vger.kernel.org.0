Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF1942AADD
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhJLRgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:36:17 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:43348 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLRgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 13:36:16 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 681EC207D57A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
Date:   Tue, 12 Oct 2021 20:34:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 7:36 PM, Biju Das wrote:

> This patch enables Receive/Transmit port of TOE and removes
> the setting of promiscuous bit from EMAC configuration mode register.
> 
> This patch also update EMAC configuration mode comment from
> "PAUSE prohibition" to "EMAC Mode: PAUSE prohibition; Duplex; TX;
> RX; CRC Pass Through".

   I'm not sure why you set ECMR.RCPT while you don't have the checksum offloaded...

> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2->v3:
>  * Enabled TPE/RPE of TOE, as disabling causes loopback test to fail
>  * Documented CSR0 register bits
>  * Removed PRM setting from EMAC configuration mode
>  * Updated EMAC configuration mode.
> v1->v2:
>  * No change
> V1:
>  * New patch.
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 6 ++++++
>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 69a771526776..08062d73df10 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -204,6 +204,7 @@ enum ravb_reg {
>  	TLFRCR	= 0x0758,
>  	RFCR	= 0x0760,
>  	MAFCR	= 0x0778,
> +	CSR0    = 0x0800,	/* RZ/G2L only */
>  };
>  
>  
> @@ -964,6 +965,11 @@ enum CXR31_BIT {
>  	CXR31_SEL_LINK1	= 0x00000008,
>  };
>  
> +enum CSR0_BIT {
> +	CSR0_TPE	= 0x00000010,
> +	CSR0_RPE	= 0x00000020,
> +};
> +

  Is this really needed if you have ECMR.RCPT cleared?

[...]

MBR, Sergey
