Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7366DCDF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbjAQLx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbjAQLxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:53:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5B334C2A;
        Tue, 17 Jan 2023 03:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673956402; x=1705492402;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EyCiChHftQ8iN2gWVAhtRIoldyffQXVLXSIIFcFPlts=;
  b=CveQnbVUaufo5PQvmSC6013lZk59BmzC0bdlvauoaGpZpOX8dv+deQYn
   Sh7T/XdbFL9Cmb45mhvhPTXdvGBK2YFFRtWSPyGioab38S5GyHBF7AyhY
   nbKQiVoey3NMrU7oLZ0m+pyY3uTFda2aYIm1ryClp6l27+YtWRynadiej
   dokaOM6mJX4Auro2dGyknHSJJMVgRoy5Y2aO80BLP1Mi/IlkwlfH8YMC4
   QVbzJ8XVhZt9z+Wz+VS1FNgni9x6goz0itOZiM7+e0lKi6l41TD43Xb3t
   Oy5fxdOcI+DAasd1Vyo6UeoGBrlCSrS2/v5mmi56vklVkt4jGBjYlBoD5
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="192589119"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 04:53:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 04:53:18 -0700
Received: from HNO-LT-M43596A.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 04:53:13 -0700
Message-ID: <c45808c864e0aa60b34324c953d021ec10a0ee92.camel@microchip.com>
Subject: Re: [PATCH net 2/5] lan966x: execute xdp_do_flush() before
 napi_complete_done()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <maciej.fijalkowski@intel.com>,
        <kuba@kernel.org>, <toke@redhat.com>, <pabeni@redhat.com>,
        <davem@davemloft.net>, <aelior@marvell.com>, <manishc@marvell.com>,
        <horatiu.vultur@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <mst@redhat.com>, <jasowang@redhat.com>, <ioana.ciornei@nxp.com>,
        <madalin.bucur@nxp.com>
CC:     <bpf@vger.kernel.org>
Date:   Tue, 17 Jan 2023 12:53:13 +0100
In-Reply-To: <20230117092533.5804-3-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
         <20230117092533.5804-3-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Magnus,

This looks good to me.

Acked-by: Steen Hegelund <Steen.Hegelund@microchip.com>

BR
Steen

On Tue, 2023-01-17 at 10:25 +0100, Magnus Karlsson wrote:
> [Some people who received this message don't often get email from magnus.karlsson@gmail.com. Learn
> why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be follwed by a xdp_do_flush() from the
> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found following the first link below.
> 
> The second reason is that the XDP_REDIRECT logic in itself relies on
> being inside a single NAPI instance through to the xdp_do_flush() call
> for RCU protection of all in-kernel data structures. Details can be
> found in the second link below.
> 
> Fixes: a825b611c7c1 ("net: lan966x: Add support for XDP_REDIRECT")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
> Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 5314c064ceae..55b484b10562 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -608,12 +608,12 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
>                 lan966x_fdma_rx_reload(rx);
>         }
> 
> -       if (counter < weight && napi_complete_done(napi, counter))
> -               lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
> -
>         if (redirect)
>                 xdp_do_flush();
> 
> +       if (counter < weight && napi_complete_done(napi, counter))
> +               lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
> +
>         return counter;
>  }
> 
> --
> 2.34.1
> 


