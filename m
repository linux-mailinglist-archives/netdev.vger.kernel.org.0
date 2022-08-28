Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6225A3F26
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 20:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiH1Snh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 14:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiH1Sng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 14:43:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246E2FFDF;
        Sun, 28 Aug 2022 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661712212; x=1693248212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3iS5DuytXsVlwE/RRWVK2kpyrBj9GFyLwS42O7Lbs2A=;
  b=0Dbnw4KuoAHBmR+azh8H0m/q+oWWzMLHiJ+xYa5WqgV/A+8nyIZ0wuR0
   Cy9Xs5yWb4ITiBUCjw2pjZqqKft52FpuupJmi94p23bR3y3QnCL84v6A+
   62dd8r1MTtuxPFBEImPsodxWo1ljg4arm1LNzuOQaJPfYWdLRl81tip/R
   uz039An1xTevOEmYA65cZpzVyeve000Cm0XMZM66HdF9vzESj6Tv7hyHo
   1g63Bejj2zFRxEwDpMnYik0tpP4xXy+aZcNoMbeRKU94BhNl9/qQasxve
   e9+09URVpVU3sEsrjIvnFR8b1XUA8G9mnuX7gpcMIXauCVhmkhgjUGnjE
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="188396689"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2022 11:43:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 28 Aug 2022 11:43:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Sun, 28 Aug 2022 11:43:31 -0700
Date:   Sun, 28 Aug 2022 20:47:48 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] net: lan966x: improve error handle in
 lan966x_fdma_rx_get_frame()
Message-ID: <20220828184748.e446pjykjklesxja@soft-dev3-1.localhost>
References: <YwjgDm/SVd5c1tQU@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YwjgDm/SVd5c1tQU@kili>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/26/2022 18:00, Dan Carpenter wrote:
> 
> Don't just print a warning.  Clean up and return an error as well.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Fixes: c8349639324a ("net: lan966x: Add FDMA functionality")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 6dea7f8c1481..51f8a0816377 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -425,7 +425,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
>         lan966x_ifh_get_src_port(skb->data, &src_port);
>         lan966x_ifh_get_timestamp(skb->data, &timestamp);
> 
> -       WARN_ON(src_port >= lan966x->num_phys_ports);
> +       if (WARN_ON(src_port >= lan966x->num_phys_ports))
> +               goto free_skb;
> 
>         skb->dev = lan966x->ports[src_port]->dev;
>         skb_pull(skb, IFH_LEN * sizeof(u32));
> @@ -449,6 +450,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> 
>         return skb;
> 
> +free_skb:
> +       kfree_skb(skb);
>  unmap_page:
>         dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
>                        FDMA_DCB_STATUS_BLOCKL(db->status),
> --
> 2.35.1
> 

-- 
/Horatiu
