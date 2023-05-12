Return-Path: <netdev+bounces-2166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB6E70099A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C1031C211A8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B28C1E534;
	Fri, 12 May 2023 13:57:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECB6A920
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:57:21 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B4211DB1;
	Fri, 12 May 2023 06:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683899836; x=1715435836;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QwWE/tJlAPiCpmRXJUsvyc0KqZbQ5lpruaSv6RHumwg=;
  b=n9yvwfKQOFStLfiN/7ANP61yDQXq4M5JKwqpZTupb6QKaT5X//BQwv/d
   Cw8xwGCmOfN3VGjjDn4BNWJz5t9Owd1bySvbRL+kzFbNcM0FxdoEwDZ7E
   3UXIQGukEa+E4tkmtnr7itWbA1NcNyyvueA84wKUXAsc/GT9h3jbE1Dp+
   fQQ+ZQEPpBVHInBZi0wraH4/mU+UVYeCgn9EUuelE9ZArsa1CUVqDrsSO
   hlw5pGkia1SaNJUzXKRjKkup5zs0U04yPtZ1S28ToHeW+rmcUCUMkTwxf
   IgisY9wE6gMP0okz4Kh+vJ9/nHjG8R4ZJ0DcxG2EFUDcXiAo2GcAOcNk3
   A==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677567600"; 
   d="scan'208";a="210976329"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 May 2023 06:57:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 12 May 2023 06:57:14 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 12 May 2023 06:57:14 -0700
Date: Fri, 12 May 2023 15:57:13 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
CC: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Clark Wang <xiaoning.wang@nxp.com>, NXP Linux Team
	<linux-imx@nxp.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, Simon Horman <horms@kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<imx@lists.linux.dev>
Subject: Re: [PATCH net] net: fec: remove the xdp_return_frame when lack of
 tx BDs
Message-ID: <20230512135713.lwfpw4lzreece4rb@soft-dev3-1>
References: <20230512133843.1358661-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230512133843.1358661-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/12/2023 08:38, Shenwei Wang wrote:
> 
> In the implementation, the sent_frame count does not increment when
> transmit errors occur. Therefore, bq_xmit_all() will take care of
> returning the XDP frames.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 42ec6ca3bf03..2a3e8b69b70a 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3798,7 +3798,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>         entries_free = fec_enet_get_free_txdesc_num(txq);
>         if (entries_free < MAX_SKB_FRAGS + 1) {
>                 netdev_err(fep->netdev, "NOT enough BD for SG!\n");
> -               xdp_return_frame(frame);
>                 return NETDEV_TX_BUSY;
>         }
> 
> --
> 2.34.1
> 
> 

-- 
/Horatiu

