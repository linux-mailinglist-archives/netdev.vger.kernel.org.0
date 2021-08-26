Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802EE3F8FC1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 22:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhHZUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:42:22 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:49858 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhHZUmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 16:42:22 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 7110E208B737
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 08/13] ravb: Factorise ravb_rx function
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
 <20210825070154.14336-9-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <38945153-ae69-2817-91c3-3cec6ac9350d@omp.ru>
Date:   Thu, 26 Aug 2021 23:41:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-9-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> R-Car uses an extended descriptor in RX whereas, RZ/G2L uses
> normal descriptor in RX. Factorise the ravb_rx function to
> support the later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 148c974499b4..1cace5324261 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -562,8 +562,7 @@ static void ravb_rx_csum(struct sk_buff *skb)
>  	skb_trim(skb, skb->len - sizeof(__sum16));
>  }
>  
> -/* Packet receive function for Ethernet AVB */
> -static bool ravb_rx(struct net_device *ndev, int *quota, int q)
> +static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)

   Mhm, isn't this too large a function to duplicate it all for RZ-G2?

[...]

MBR, Sergey
